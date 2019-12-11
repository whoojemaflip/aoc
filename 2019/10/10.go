package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func loadFile(filename string) ([]Pos, []Pos, int, int) {
	data, err := ioutil.ReadFile(filename)
	check(err)
	d2 := strings.Trim(string(data), "\n ")
	rows := strings.Split(string(d2), "\n")

	asteroids := make([]Pos, 0)
	locations := make([]Pos, 0)
	width := len(rows[0])
	height := len(rows)

	for y, row := range rows {
		for x, char := range row {
			pos := Pos{x, y}
			if char == '#' {
				asteroids = append(asteroids, pos)
			} else {
				locations = append(locations, pos)
			}
		}
	}
	return asteroids, locations, width, height
}

type Pos struct {
	x int
	y int
}

type Vector Pos

func gcd(a, b int) int {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func vector(location, asteroid Pos) Vector {
	x := location.x - asteroid.x
	y := location.y - asteroid.y
	gcd := abs(gcd(x, y))
	// fmt.Println(x, y, gcd)
	if x == 0 && y == 0 {
		return Vector{
			x,
			y,
		}
	} else if x == 0 {
		if y < 0 {
			return Vector{0, -1}
		} else {
			return Vector{
				0, 1,
			}
		}
	} else if y == 0 {
		if x < 0 {
			return Vector{
				-1, 0,
			}
		} else {
			return Vector{
				1, 0,
			}
		}
	} else {
		return Vector{
			x / gcd,
			y / gcd,
		}
	}
}

func main() {
	filename := os.Args[1]
	asteroids, _, _, _ := loadFile(filename)

	var max int
	var loc_max Pos

	out := make(map[Pos]int)
	for _, l := range asteroids {
		result := make(map[Vector]bool)
		for _, a := range asteroids {
			v := vector(a, l)
			//		fmt.Printf("v: %x l: %v a: %v\n", v, l, a)
			result[v] = true
		}
		size := len(result) - 1
		out[l] = size
		// fmt.Println(l, size)
		// fmt.Println(result)
		if size > max {
			loc_max = l
			max = size
		}
	}

	fmt.Print("\n")
	fmt.Println(loc_max, max)
	fmt.Print("\n")

	// for i := 0; i < h; i += 1 {
	// 	for j := 0; j < w; j += 1 {
	// 		if p, ok := out[Pos{j, i}]; ok {
	// 			fmt.Print(p)
	// 		} else {
	// 			fmt.Print(".")
	// 		}
	// 	}
	// 	fmt.Print("\n")
	// }
}
