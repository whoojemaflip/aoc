package main

import (
	"os"
	"virtual_machine"
	"fmt"
)

type Point struct {
	x int
	y int
}

func move(direction int, p Point) Point {
	if direction == 1 { // north
		return Point{p.x, p.y - 1}
	} else if direction == 2 { // south
		return Point{p.x, p.y + 1}
	} else if direction == 3 { // west
		return Point{p.x + 1, p.y}
	} else if direction == 4 { // east
		return Point{p.x - 1, p.y}
	}
	panic("not a dirextion")
}

func isWall(screen virtual_machine.Screen, pos Point) bool {
	return 1 == screen.Get(pos.x, pos.y)
}

func isEmpty(screen virtual_machine.Screen, pos Point) bool {
	return 3 == screen.Get(pos.x, pos.y)
}

func toTheRight(direction int) int {
	switch direction {
	case 1:
		return 4
	case 2:
		return 3
	case 3:
		return 1
	case 4:
		return 2
	}

	panic("wtf")
}

func toTheLeft(direction int) int {
	switch direction {
	case 1:
		return 3
	case 2:
		return 4
	case 3:
		return 2
	case 4:
		return 1
	}

	panic("wtf")
}

// follow the wall to your right
func nextMove(screen virtual_machine.Screen, p Point, last_move int) int {
	if !isWall(screen, move(toTheRight(last_move), p)) {
		return toTheRight(last_move)
	} else if !isWall(screen, move(last_move, p)) {
		return last_move
	} else if !isWall(screen, move(toTheLeft(last_move), p)) {
		return toTheLeft(last_move)
	} else {
		return toTheLeft(toTheLeft(last_move))
	}
}

func main() {
	filename := os.Args[1]
	vm := virtual_machine.NewVM(filename)
	screen := virtual_machine.NewScreen(50, 50)

	tiles := map[int]string{
		0: " ",
		1: "#",
		2: "D",
		3: ".",
		4: "X",
		5: "@",
		6: "O",
	}

	starting_position := Point{25, 25}
	droid := starting_position

	var status int64
	last_move := 1
	var oxygen_system Point
	moves := 0

	for {
		vm.ReplaceInputBuffer(int64(last_move))

		err := vm.Process()
		switch err.(type) {
		case virtual_machine.Yield:
			status = vm.ReadFromOutputBuffer()
		case virtual_machine.Halt:
			break
		}

		if status == 0 {
			wall := move(last_move, droid)
			screen.Update(wall.x, wall.y, 1)
		} else if status == 1 {
			screen.Update(droid.x, droid.y, 3)
			droid = move(last_move, droid)
			screen.Update(droid.x, droid.y, 2)
		} else if status == 2 {
			droid = move(last_move, droid)
			screen.Update(droid.x, droid.y, 4)
			oxygen_system = droid
		}

		if moves == 100000 { // that should be enough eh
			screen.Update(droid.x, droid.y, 3)
			screen.Update(oxygen_system.x, oxygen_system.y, 4)
			screen.Print(tiles)
			break
		}

		last_move = nextMove(screen, droid, last_move)
		moves += 1
	}

	fill_queue := []Point{oxygen_system}
	time_elapsed := 0

	for {
		next_queue := make([]Point, 0)

		for _, p := range fill_queue {
			screen.Update(p.x, p.y, 6)

			for d := 1; d <= 4; d += 1 {
				if isEmpty(screen, move(d, p)) {
					next_queue = append(next_queue, move(d, p))
				}
			}
		}

		if len(next_queue) == 0 {
			break
		}

		fill_queue = next_queue
		time_elapsed += 1
		screen.Print(tiles)
	}
	fmt.Println(time_elapsed)
}
