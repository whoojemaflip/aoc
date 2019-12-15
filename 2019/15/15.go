package main

import (
	"math/rand"
	"os"
	"time"
	"virtual_machine"
)

type Point struct {
	x int
	y int
}

func move(direction int64, p Point) Point {
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
	}

	starting_position := Point{25, 25}
	droid := starting_position

	var status int64

	rand.Seed(time.Now().UnixNano())
	for {
		in := int64(rand.Intn(4) + 1)
		vm.ReplaceInputBuffer(in)

		err := vm.Process()
		switch err.(type) {
		case virtual_machine.Yield:
			status = vm.ReadFromOutputBuffer()
		case virtual_machine.Halt:
			break
		}

		if status == 0 {
			wall := move(in, droid)
			screen.Update(wall.x, wall.y, 1)
		} else if status == 1 {
			screen.Update(droid.x, droid.y, 3)
			droid = move(in, droid)
			screen.Update(droid.x, droid.y, 2)
		} else if status == 2 {
			droid = move(in, droid)
			screen.Update(droid.x, droid.y, 4)
			screen.Update(starting_position.x, starting_position.y, 5)
			screen.Print(tiles)
			break
		}
	}
}
