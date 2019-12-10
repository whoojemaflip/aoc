package main

import (
	"io/ioutil"
	"strconv"
	"strings"
)

type Memory map[uint64]int64

func NewMemory(filename string) Memory {
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	d2 := strings.Trim(string(data), "\n ")
	numbers := strings.Split(string(d2), ",")

	out := make(Memory)
	for i, n := range numbers {
		x, _ := strconv.Atoi(n)
		out[uint64(i)] = int64(x)
	}
	return out
}

func (memory Memory) peek(addr uint64) int64 {
	return memory[addr]
}

func (memory Memory) poke(addr uint64, value int64) {
	memory[addr] = value
}

func (memory Memory) size() uint64 {
	return uint64(len(memory))
}

func (memory Memory) addressInRange(addr uint64) bool {
	if addr < 0 || addr >= memory.size() {
		return false
	} else {
		return true
	}
}
