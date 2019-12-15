package virtual_machine

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func (vm *VM) ReplaceInputBuffer(val int64) {
	vm.input_buffer = make([]int64, 1)
	vm.input_buffer[0] = val
}

func (vm *VM) readFromInputBuffer() int64 {
	out := vm.input_buffer[0]
	vm.input_buffer = vm.input_buffer[1:]
	return out
}

func (vm *VM) ReadFromOutputBuffer() int64 {
	out := vm.output_buffer[0]
	vm.output_buffer = vm.output_buffer[1:]
	return out
}

func (vm *VM) writeToOutputBuffer(val int64) {
	vm.output_buffer = append(vm.output_buffer, val)
}

func (vm VM) DumpOutputBuffer() {
	fmt.Println(vm.output_buffer)
}

func RequestUserInput(prompt string) int {
	reader := bufio.NewReader(os.Stdin)
	fmt.Print(prompt)
	text, _ := reader.ReadString('\n')
	text = strings.TrimSuffix(text, "\n")
	num, err := strconv.Atoi(text)
	if err != nil {
		panic("bad input eh!")
	}
	return num
}
