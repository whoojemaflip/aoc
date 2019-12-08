package main

import (
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

func process(memory Memory, pc *int) error {
	for {
		//		fmt.Println(*pc, memory)
		instruction := memory.peek(*pc)
		code, parameter_modes := decode_instruction(instruction)

		opcode, ok := Instructions[code]
		if !ok {
			panic(fmt.Sprintf("Opcode not found at %v", *pc))
		}

		*pc += 1
		args := prepare_args(opcode.arity, parameter_modes, memory, *pc)
		*pc += opcode.arity

		//		fmt.Printf("%v %v\n", opcode.name, args)

		e := opcode.calc(args, memory, pc)

		if e != nil {
			return e
		}
	}
}

func readFromInputBuffer() int {
	out := input_buffer[0]
	input_buffer = input_buffer[1:]
	return out
}

func writeToOutputBuffer(val int) {
	output_buffer = val
}

var input_buffer = make([]int, 2)
var output_buffer int

func main() {
	filename := os.Args[1]
	memory := loadFile(filename)
	fmt.Println(memory)

	max_juice := 0
	var best_phase_sequence []int

	var phase_seq = PhaseSequence{
		5, 6, 7, 8, 9,
	}
	phase_sequence_iterator := NewPhaseSequenceIterator(phase_seq)

	for phase_sequence_iterator.Next() {
		sequence := phase_sequence_iterator.Value()
		fmt.Printf("Sequence: %v\n", sequence)

		pc := make([]int, 5)
		machines := [5]Memory{}
		for i, _ := range machines {
			machines[i] = make([]int, len(memory))
			copy(machines[i], memory)
		}

		output_buffer = 0
		for i, n := range sequence {
			input_buffer = []int{n, output_buffer}
			//		fmt.Printf("\nStarting mahine %v with %v\n", i, input_buffer)
			process(machines[i], &pc[i])
		}

		var i int
	LOOP:
		for {
			input_buffer = []int{output_buffer}
			//		fmt.Printf("\nStarting machine %v with %v\n", i, input_buffer)
			e := process(machines[i], &pc[i])

			if e != nil {
				switch e.(type) {
				case Halt:
					fmt.Printf("Machine %v completed with %v\n", i, output_buffer)

					if i == 4 {
						if output_buffer > max_juice {
							max_juice = output_buffer
							best_phase_sequence = sequence
						}

						fmt.Println("END")
						break LOOP
					} else {
						i += 1
						continue
					}
				case Yield:
					if i == 4 {
						i = 0
					} else {
						i += 1
					}
					continue
				}
			}
		}
	}

	fmt.Println(max_juice)
	fmt.Println(best_phase_sequence)
}
