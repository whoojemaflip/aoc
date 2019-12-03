package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"os"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

type WireVector struct {
	direction byte
	distance  int
}

type Point struct {
	x int
	y int
}

func parseWirePath(wire string) (out []WireVector) {
	points := strings.Split(wire, ",")
	for _, point := range points {
		direction := point[0]
		distance, err := strconv.Atoi(point[1:])
		check(err)
		out = append(out, WireVector{
			direction, distance,
		})
	}
	return
}

func loadFile(filename string) [][]WireVector {
	data, err := ioutil.ReadFile(filename)
	check(err)

	lines := strings.Split(string(data), "\n")

	out := make([][]WireVector, 2)
	out[0] = parseWirePath(lines[0])
	out[1] = parseWirePath(lines[1])
	return out
}

var lookup = map[byte]Point{
	82: {1, 0},
	85: {0, 1},
	76: {-1, 0},
	68: {0, -1},
}

func (p Point) move(direction byte) Point {
	p2 := lookup[direction]
	return Point{
		p.x + p2.x,
		p.y + p2.y,
	}
}

func traceFirstWire(wire []WireVector) map[Point]bool {
	p := Point{0, 0}
	out := make(map[Point]bool)
	for _, vector := range wire {
		for i := 0; i < vector.distance; i++ {
			p = p.move(vector.direction)
			out[p] = true
		}
	}
	return out
}

func traceSecondWire(wire []WireVector, other_wire map[Point]bool) (out []Point) {
	p := Point{0, 0}
	for _, vector := range wire {
		for i := 0; i < vector.distance; i++ {
			p = p.move(vector.direction)
			ok := other_wire[p]
			if ok {
				out = append(out, p)
			}
		}
	}
	return
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func closestPoint(points []Point) int {
	lowest := math.MaxInt32
	for _, p := range points {
		d := abs(p.x) + abs(p.y)
		if d < lowest {
			lowest = d
		}
	}
	return lowest
}

func main() {
	filename := os.Args[1]
	wires := loadFile(filename)
	trace := traceFirstWire(wires[0])
	cross_overs := traceSecondWire(wires[1], trace)
	fmt.Println(cross_overs)
	result := closestPoint(cross_overs)
	fmt.Println(result)
}
