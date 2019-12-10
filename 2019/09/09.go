package main

import (
	"os"
)

func main() {
	filename := os.Args[1]
	vm := NewVM(filename)
	vm.input_buffer[0] = 2
	vm.Process()
	vm.DumpOutputBuffer()
}
