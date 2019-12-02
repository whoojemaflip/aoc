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

func loadFile(filename string) []int {
	data, err := ioutil.ReadFile(filename)
	check(err)
	d2 := strings.Trim(string(data), "\n ")
	numbers := strings.Split(string(d2), ",")

	out := make([]int, len(numbers))
	for i, n := range numbers {
		out[i], _ = strconv.Atoi(n)
	}
	return out
}

func process(program []int) int {
	pc := 0
	lp := len(program)

	for {
		opcode := program[pc]

		if opcode == 99 {
			return program[0]
		}

		a := program[pc+1]
		b := program[pc+2]
		addr := program[pc+3]

		if a < 0 || a >= lp || b < 0 || b >= lp || addr < 0 || addr >= lp {
			return -1
		}

		var result int
		switch opcode {
		case 1:
			result = program[a] + program[b]
		case 2:
			result = program[a] * program[b]
		}

		//	fmt.Println(a, b, addr, result)
		program[addr] = result

		pc += 4
	}
}

func bruteForce(input []int, target int) (int, int) {
	for noun := 0; noun < 100; noun++ {
		for verb := 0; verb < 100; verb++ {
			scratch_mem := make([]int, len(input))
			copy(scratch_mem, input)
			scratch_mem[1] = noun
			scratch_mem[2] = verb

			result := process(scratch_mem)

			if result == target {
				return noun, verb
			}
		}
	}
	return 0, 0
}

func main() {
	filename := os.Args[1]
	nums := loadFile(filename)
	noun, verb := bruteForce(nums, 19690720)
	fmt.Println((100 * noun) + verb)
}
