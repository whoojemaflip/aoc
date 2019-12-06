package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func loadFile(filename string) Memory {
	data, err := ioutil.ReadFile(filename)
	check(err)
	d2 := strings.Trim(string(data), "\n ")
	numbers := strings.Split(string(d2), ",")

	out := make(Memory, len(numbers))
	for i, n := range numbers {
		out[i], _ = strconv.Atoi(n)
	}
	return out
}

type Memory []int

func (memory Memory) peek(addr int) int {
	if !memory.addressInRange(addr) {
		return -1
	}

	return memory[addr]
}

func (memory Memory) poke(addr int, value int) {
	memory[addr] = value
}

func (memory Memory) size() int {
	return len(memory)
}

func (memory Memory) addressInRange(addr int) bool {
	if addr < 0 || addr >= memory.size() {
		return false
	} else {
		return true
	}
}

type Opcode struct {
	name  string
	arity int
	calc  OpcodeFunction
}

type OpcodeFunction func(args []Arg, memory Memory) error

type Halt string

func (e Halt) Error() string {
	return string(e)
}

type Arg struct {
	value int
	mode  int
}

func (arg Arg) resolved_value(memory Memory) int {
	if arg.mode == 0 {
		return memory.peek(arg.value)
	} else {
		return arg.value
	}
}

func (arg Arg) String() string {
	if arg.mode == 0 {
		return fmt.Sprintf("peek(%v)", arg.value)
	} else {
		return fmt.Sprintf("literal(%v)", arg.value)
	}
}

var instructions = map[int]Opcode{
	1: {
		"add",
		3,
		func(args []Arg, memory Memory) (e error) {
			a := args[0].resolved_value(memory)
			b := args[1].resolved_value(memory)
			store := args[2].value
			memory.poke(store, a+b)
			return
		},
	},
	2: {
		"mult",
		3,
		func(args []Arg, memory Memory) (e error) {
			a := args[0].resolved_value(memory)
			b := args[1].resolved_value(memory)
			store := args[2].value
			memory.poke(store, a*b)
			return
		},
	},
	3: {
		"input",
		1,
		func(args []Arg, memory Memory) (e error) {
			reader := bufio.NewReader(os.Stdin)
			fmt.Print("Enter number: ")
			text, _ := reader.ReadString('\n')
			text = strings.TrimSuffix(text, "\n")
			num, err := strconv.Atoi(text)
			check(err)
			store := args[0].value
			memory.poke(store, num)
			return
		},
	},
	4: {
		"output",
		1,
		func(args []Arg, memory Memory) (e error) {
			out := args[0].resolved_value(memory)
			fmt.Println(out)
			return
		},
	},
	5: {
		"jump-if-true",
		2,
		func(args []Arg, memory Memory) (e error) {
			if args[0].resolved_value(memory) != 0 {
				pc = args[1].resolved_value(memory)
			}
			return
		},
	},
	6: {
		"jump-if-false",
		2,
		func(args []Arg, memory Memory) (e error) {
			if args[0].resolved_value(memory) == 0 {
				pc = args[1].resolved_value(memory)
			}
			return
		},
	},
	7: {
		"less than",
		3,
		func(args []Arg, memory Memory) (e error) {
			a := args[0].resolved_value(memory)
			b := args[1].resolved_value(memory)
			store := args[2].value
			if a < b {
				memory.poke(store, 1)
			} else {
				memory.poke(store, 0)
			}
			return
		},
	},
	8: {
		"equals",
		3,
		func(args []Arg, memory Memory) (e error) {
			a := args[0].resolved_value(memory)
			b := args[1].resolved_value(memory)
			store := args[2].value
			if a == b {
				memory.poke(store, 1)
			} else {
				memory.poke(store, 0)
			}
			return
		},
	},
	99: {
		"halt",
		0,
		func(args []Arg, memory Memory) (e error) {
			e = Halt("Program complete")
			return
		},
	},
}

func decode_instruction(instruction int) (opcode int, parameter_modes []int) {
	opcode = instruction % 100
	instruction = instruction / 100
	for {
		if instruction == 0 {
			break
		}

		mode := instruction % 2
		parameter_modes = append(parameter_modes, mode)

		instruction = instruction / 10
	}

	return
}

func prepare_args(arity int, parameter_modes []int, memory Memory, pc int) (args []Arg) {
	for i := 0; i < arity; i++ {
		var mode int
		if i >= len(parameter_modes) || parameter_modes[i] == 0 {
			mode = 0
		} else {
			mode = 1
		}
		value := memory.peek(pc + i)
		args = append(args, Arg{value, mode})
	}
	return
}

var pc int

func process(memory Memory) {
	for {
		//	fmt.Println(pc, memory)
		instruction := memory.peek(pc)
		code, parameter_modes := decode_instruction(instruction)

		opcode, ok := instructions[code]
		if !ok {
			panic(fmt.Sprintf("Opcode not found at %v", pc))
		}

		pc += 1
		args := prepare_args(opcode.arity, parameter_modes, memory, pc)
		pc += opcode.arity

		//	fmt.Printf("%v %v\n", opcode.name, args)

		error := opcode.calc(args, memory)

		if error != nil {
			return
		}
	}
}

func main() {
	filename := os.Args[1]
	memory := loadFile(filename)
	process(memory)
}
