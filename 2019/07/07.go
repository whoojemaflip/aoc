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

func process(memory Memory) {
	pc = 0

	for {
		//fmt.Println(pc, memory)
		instruction := memory.peek(pc)
		code, parameter_modes := decode_instruction(instruction)

		opcode, ok := Instructions[code]
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
	scratch_mem := make([]int, len(memory))

	max_juice := 0
	var best_phase_sequence []int

	var phase_seq = PhaseSequence{
		0, 1, 2, 3, 4,
	}
	phase_sequence_iterator := NewPhaseSequenceIterator(phase_seq)

	for phase_sequence_iterator.Next() {
		sequence := phase_sequence_iterator.Value()
		fmt.Printf("Sequence: %v", sequence)
		output_buffer = 0

		for _, n := range sequence {
			copy(scratch_mem, memory)
			input_buffer = []int{n, output_buffer}
			process(scratch_mem)
		}

		fmt.Printf(" completed with %v\n", output_buffer)

		if output_buffer > max_juice {
			max_juice = output_buffer
			best_phase_sequence = sequence
		}
	}

	fmt.Println(max_juice)
	fmt.Println(best_phase_sequence)
}
