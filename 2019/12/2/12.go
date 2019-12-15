package main

import "fmt"

func puzzle_input() [][4]int {
	start := make([][4]int, 3, 3)
	start[0] = [...]int{-15, 1, -5, 4}
	start[1] = [...]int{1, -10, 4, 6}
	start[2] = [...]int{4, -8, 9, -2}
	return start
}

func step(p, v [4]int) ([4]int, [4]int) {
	// apply gravity
	if p[0] > p[1] {
		v[0] -= 1
		v[1] += 1
	} else if p[0] < p[1] {
		v[0] += 1
		v[1] -= 1
	}

	if p[0] > p[2] {
		v[0] -= 1
		v[2] += 1
	} else if p[0] < p[2] {
		v[0] += 1
		v[2] -= 1
	}

	if p[0] > p[3] {
		v[0] -= 1
		v[3] += 1
	} else if p[0] < p[3] {
		v[0] += 1
		v[3] -= 1
	}

	if p[1] > p[2] {
		v[1] -= 1
		v[2] += 1
	} else if p[1] < p[2] {
		v[1] += 1
		v[2] -= 1
	}

	if p[1] > p[3] {
		v[1] -= 1
		v[3] += 1
	} else if p[1] < p[3] {
		v[1] += 1
		v[3] -= 1
	}

	if p[2] > p[3] {
		v[2] -= 1
		v[3] += 1
	} else if p[2] < p[3] {
		v[2] += 1
		v[3] -= 1
	}

	// update positions
	p[0] += v[0]
	p[1] += v[1]
	p[2] += v[2]
	p[3] += v[3]

	return p, v
}

func printMoons(p, v [][4]int) {
	for m := 0; m < 4; m += 1 {
		fmt.Printf("pos=<x=%3d, y=%3d, z=%3d>, vel=<x=%3d, y=%3d, z=%3d>\n", p[0][m], p[1][m], p[2][m], v[0][m], v[1][m], v[2][m])
	}
}

func calcEnergy(p [][4]int, steps int) int {
	v := startVelocity()

	// fmt.Printf("After 0 steps\n")
	// printMoons(p, v)

	for i := 1; i <= steps; i += 1 {
		for i := 0; i < 3; i += 1 {
			p[i], v[i] = step(p[i], v[i])
		}
		// fmt.Printf("After %d steps\n", i)
		// printMoons(p, v)
	}

	sum_energy := 0
	for moon := 0; moon < 4; moon += 1 {
		moon_pot := 0
		moon_kin := 0

		for dim := 0; dim < 3; dim += 1 {
			moon_pot += abs(p[dim][moon])
			moon_kin += abs(v[dim][moon])
		}

		sum_energy += (moon_pot * moon_kin)
	}

	return sum_energy
}

func startVelocity() [][4]int {
	v := make([][4]int, 3, 3)
	v[0] = [4]int{0, 0, 0, 0}
	v[1] = [4]int{0, 0, 0, 0}
	v[2] = [4]int{0, 0, 0, 0}

	return v
}

func calcRepeatInterval(start_positions [][4]int) uint64 {
	p := make([][4]int, 3, 3)
	p[0] = start_positions[0]
	p[1] = start_positions[1]
	p[2] = start_positions[2]

	v := startVelocity()

	results := make([]uint64, 3)

	for i := 0; i < 3; i += 1 {
		var t uint64

		for {
			p[i], v[i] = step(p[i], v[i])
			t += 1

			if p[i] == start_positions[i] && v[i] == [4]int{0, 0, 0, 0} {
				break
			}

			// if t%100000000 == 0 {
			// 	fmt.Print(".")
			// }
		}

		// fmt.Print("\n")
		// fmt.Println(i, t)
		results[i] = t
	}

	return (LCM(results[0], results[1], results[2]))
}

func main() {
	r1 := calcEnergy(puzzle_input(), 1000)
	fmt.Printf("Part 1: %v\n", r1)

	r2 := calcRepeatInterval(puzzle_input())
	fmt.Printf("Part 2: %v\n", r2)
}

// greatest common divisor (GCD) via Euclidean algorithm
func GCD(a, b uint64) uint64 {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

// find Least Common Multiple (LCM) via GCD
func LCM(a, b uint64, integers ...uint64) uint64 {
	result := a * b / GCD(a, b)

	for i := 0; i < len(integers); i++ {
		result = LCM(result, integers[i])
	}

	return result
}

func abs(x int) int {
	if x < 0 {
		return x * -1
	} else {
		return x
	}
}
