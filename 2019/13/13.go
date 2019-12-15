package main

import (
	"fmt"
	"os"
	"virtual_machine"
)

func runUntilTileUpdated(vm *virtual_machine.VM) []int64 {
	out := make([]int64, 0)

	for {
		err := vm.Process()
		switch err.(type) {
		case virtual_machine.Yield:
			out = append(out, vm.ReadFromOutputBuffer())
			if len(out) == 3 {
				return out
			}
		case virtual_machine.Halt:
			return []int64{-99}
		}
	}
}

func tiles() map[int]string {
	return map[int]string{
		0: " ",
		1: "#",
		2: "~",
		3: "=",
		4: "o",
	}
}

func main() {
	filename := os.Args[1]
	vm := virtual_machine.NewVM(filename)
	screen := virtual_machine.NewScreen(45, 23)
	vm.SetMem(0, 2) // free play
	var score int64
	paddle_x := 0
	ball_x := 0

	for {
		result := runUntilTileUpdated(&vm)
		if len(result) == 1 {
			break
		}

		if result[0] == -1 {
			score = result[2]
			fmt.Printf("Score: %v\n", score)
		} else {
			screen.Update(int(result[0]), int(result[1]), int(result[2]))
			screen.Print(tiles())

			if result[2] == 3 {
				paddle_x = int(result[0])
			} else if result[2] == 4 {
				ball_x = int(result[0])

				if ball_x > paddle_x {
					vm.ReplaceInputBuffer(1)
				} else if ball_x < paddle_x {
					vm.ReplaceInputBuffer(-1)
				} else {
					vm.ReplaceInputBuffer(0)
				}
			}
		}
	}
}
