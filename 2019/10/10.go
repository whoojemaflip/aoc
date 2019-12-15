package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"os"
	"sort"
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

func (p Pos) eql(q Pos) bool {
	return p.x == q.x && p.y == q.y
}

type Vector struct {
	x int
	y int
	d int
	p Pos
	a float64
}

func (v Vector) mapkey() string {
	return fmt.Sprintf("%v,%v", v.x, v.y)
}

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
	x := asteroid.x - location.x
	y := asteroid.y - location.y
	gcd := abs(gcd(x, y))
	dist := abs(x) + abs(y)
	a := angle(x, y)
	// fmt.Println(x, y, gcd)
	if x == 0 && y == 0 {
		return Vector{
			0, 0, dist, asteroid, a,
		}
	} else if x == 0 {
		if y < 0 {
			return Vector{0, -1, dist, asteroid, a}
		} else {
			return Vector{
				0, 1, dist, asteroid, a,
			}
		}
	} else if y == 0 {
		if x < 0 {
			return Vector{
				-1, 0, dist, asteroid, a,
			}
		} else {
			return Vector{
				1, 0, dist, asteroid, a,
			}
		}
	} else {
		return Vector{
			x / gcd,
			y / gcd,
			dist, asteroid, a,
		}
	}
}

func angle(x, y int) float64 {
	i := math.Atan2(float64(x), float64(y))
	pi := 3.141592653589793
	if i < 0 {
		i = (i * -1) + pi
	}

	return (i * 180 / pi)
}

type byDistance []Vector

func (b byDistance) Len() int           { return len(b) }
func (b byDistance) Swap(i, j int)      { b[i], b[j] = b[j], b[i] }
func (b byDistance) Less(i, j int) bool { return b[i].d < b[j].d }

func main() {
	filename := os.Args[1]
	asteroids, _, _, _ := loadFile(filename)

	var max int
	var loc_max Pos

	out := make(map[Pos]int)
	for _, l := range asteroids {
		result := make(map[string]bool)
		for _, a := range asteroids {
			v := vector(l, a)
			//		fmt.Printf("v: %x l: %v a: %v\n", v, l, a)
			result[v.mapkey()] = true
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

	angles := make(map[float64][]Vector)
	l := loc_max
	for _, a := range asteroids {
		if !a.eql(l) {
			v := vector(l, a)
			angle := v.a
			if angles[angle] == nil {
				angles[angle] = make([]Vector, 0)
			}
			angles[angle] = append(angles[angle], v)
		}
	}

	removed := make([]Vector, 0)

	for {
		keys := make([]float64, 0, len(angles))
		for a := range angles {
			keys = append(keys, a)
		}
		sort.Float64s(keys)

		for _, angle := range keys {
			//	fmt.Println(angle)
			//		fmt.Println(angles[angle])
			removed = append(removed, angles[angle][0])

			if len(angles[angle]) == 1 {
				delete(angles, angle)
				keys = keys
			} else {
				sort.Sort(byDistance(angles[angle]))
				angles[angle] = angles[angle][1:]
			}

			if len(angles) == 0 {
				break
			}
		}
		if len(angles) == 0 {
			break
		}
	}

	for i, r := range removed {
		fmt.Printf("%v - %v\n", i, r)
	}

	//	fmt.Println(removed[200])
}
