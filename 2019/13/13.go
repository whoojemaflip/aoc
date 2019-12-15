package main

import (
	"fmt"
	"os"
	"virtual_machine"
)

func runUntilHaltReceived(vm *virtual_machine.VM) []int64 {
	out := make([]int64, 0)

	for {
		err := vm.Process()
		switch err.(type) {
		case virtual_machine.Yield:
			out = append(out, vm.ReadFromOutputBuffer())
		case virtual_machine.Halt:
			return out
		}
	}
}

func main() {
	filename := os.Args[1]
	vm := virtual_machine.NewVM(filename)

	result := runUntilHaltReceived(&vm)
	screen := make(map[string]int)

	for i := 0; i < len(result); i += 3 {
		tile := fmt.Sprintf("%dx%d", result[i], result[i+1])
		screen[tile] = int(result[i+2])
	}

	blocks := 0
	for _, tile_id := range screen {
		if tile_id == 2 {
			blocks += 1
		}
	}
	fmt.Println(blocks)
}
