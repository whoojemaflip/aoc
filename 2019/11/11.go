package main

import (
	"fmt"
	"os"
	"virtual_machine"
)

type Point struct {
	x int
	y int
}

func (p Point) String() string {
	return fmt.Sprintf("(%v,%v)", p.x, p.y)
}

type Hull map[Point]int64

func newHull() Hull {
	return make(map[Point]int64)
}

func (hull Hull) panel_colour(p Point) int64 {
	colour, ok := hull[p]
	if ok {
		return colour
	} else {
		return 0
	}
}

func (hull Hull) paint_panel(p Point, colour int64) {
	hull[p] = colour
}

func runUntilOutputReceived(vm *virtual_machine.VM) int64 {
	err := vm.Process()
	switch err.(type) {
	case virtual_machine.Yield:
		return vm.ReadFromOutputBuffer()
	case virtual_machine.Halt:
		return -1
	}
	panic("Not sure how i ended up here")
}

func exec_turn(dir int, turn int64) int {
	// 0 = up
	// 1 = right
	// 2 = down
	// 3 = left

	if turn == 0 {
		dir -= 1
	} else if turn == 1 {
		dir += 1
	} else {
		panic("not sure about this")
	}

	if dir < 0 {
		dir = 3
	} else if dir > 3 {
		dir = 0
	}

	return dir
}

func exec_move(p Point, dir int) Point {
	if dir == 0 {
		return Point{p.x, p.y + 1}
	} else if dir == 1 {
		return Point{p.x + 1, p.y}
	} else if dir == 2 {
		return Point{p.x, p.y - 1}
	} else if dir == 3 {
		return Point{p.x - 1, p.y}
	}
	panic("dont knw what to do")
}

func (hull Hull) draw(ox, oy, w, h int) {
	for y := h + 1; y > oy-1; y -= 1 {
		for x := ox - 1; x < w+1; x += 1 {
			colour := hull.panel_colour(Point{x, y})
			if colour == 1 {
				fmt.Print("#")
			} else {
				fmt.Print(".")
			}
		}
		fmt.Print("\n")
	}
	fmt.Print("\n")
}

func main() {
	filename := os.Args[1]
	vm := virtual_machine.NewVM(filename)

	hull := newHull()

	var dir int
	var pos = Point{0, 0}
	hull.paint_panel(pos, 1)

	var min_w, max_w, min_h, max_h int

	for {
		panel_colour := hull.panel_colour(pos)
		vm.ReplaceInputBuffer(panel_colour)

		colour := runUntilOutputReceived(&vm)
		if colour == -1 {
			break
		}
		hull.paint_panel(pos, colour)

		turn_dir := runUntilOutputReceived(&vm)
		if turn_dir == -1 {
			break
		}

		dir = exec_turn(dir, turn_dir)
		pos = exec_move(pos, dir)

		if pos.x > max_w {
			max_w = pos.x
		} else if pos.x < min_w {
			min_w = pos.x
		} else if pos.y > max_h {
			max_h = pos.y
		} else if pos.y < min_h {
			min_h = pos.y
		}

		hull.draw(min_w, min_h, max_w, max_h)
		// time.Sleep(100 * time.Millisecond)

	}

	fmt.Println(len(hull))
}
