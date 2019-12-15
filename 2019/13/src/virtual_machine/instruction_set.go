package virtual_machine

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Opcode struct {
	name  string
	arity int
	calc  OpcodeFunction
}

type OpcodeFunction func(args []Arg, vm *VM) error

var InteractiveInput = Opcode{
	"input",
	1,
	func(args []Arg, vm *VM) (e error) {
		reader := bufio.NewReader(os.Stdin)
		fmt.Print("Enter number: ")
		text, _ := reader.ReadString('\n')
		text = strings.TrimSuffix(text, "\n")
		num, err := strconv.Atoi(text)
		if err != nil {
			panic("bad input eh!")
		}
		store := args[0].addr
		vm.memory.poke(store, int64(num))
		return
	},
}

func InteractiveInstructions() map[int]Opcode {
	ins := Instructions
	ins[3] = InteractiveInput
	return ins
}

var Instructions = map[int]Opcode{
	1: {
		"add",
		3,
		func(args []Arg, vm *VM) (e error) {
			a := args[0].resolved
			b := args[1].resolved
			store := args[2].addr
			vm.memory.poke(store, a+b)
			return
		},
	},
	2: {
		"mult",
		3,
		func(args []Arg, vm *VM) (e error) {
			a := args[0].resolved
			b := args[1].resolved
			store := args[2].addr
			vm.memory.poke(store, a*b)
			return
		},
	},
	3: {
		"input",
		1,
		func(args []Arg, vm *VM) (e error) {
			num := vm.readFromInputBuffer()
			store := args[0].addr
			vm.memory.poke(store, num)
			return
		},
	},
	4: {
		"output",
		1,
		func(args []Arg, vm *VM) (e error) {
			out := args[0].resolved
			vm.writeToOutputBuffer(out)
			e = Yield("yielding")
			return
		},
	},
	5: {
		"jump-if-true",
		2,
		func(args []Arg, vm *VM) (e error) {
			if args[0].resolved != 0 {
				vm.pc = uint64(args[1].resolved)
			}
			return
		},
	},
	6: {
		"jump-if-false",
		2,
		func(args []Arg, vm *VM) (e error) {
			if args[0].resolved == 0 {
				vm.pc = uint64(args[1].resolved)
			}
			return
		},
	},
	7: {
		"less than",
		3,
		func(args []Arg, vm *VM) (e error) {
			a := args[0].resolved
			b := args[1].resolved
			store := args[2].addr
			if a < b {
				vm.memory.poke(store, 1)
			} else {
				vm.memory.poke(store, 0)
			}
			return
		},
	},
	8: {
		"equals",
		3,
		func(args []Arg, vm *VM) (e error) {
			a := args[0].resolved
			b := args[1].resolved
			store := args[2].addr
			if a == b {
				vm.memory.poke(store, 1)
			} else {
				vm.memory.poke(store, 0)
			}
			return
		},
	},
	9: {
		"adjust relative base",
		1,
		func(args []Arg, vm *VM) (e error) {
			a := args[0].resolved
			vm.IncRegister(0, a)
			return
		},
	},
	99: {
		"halt",
		0,
		func(args []Arg, vm *VM) (e error) {
			e = Halt("Program complete")
			return
		},
	},
}
