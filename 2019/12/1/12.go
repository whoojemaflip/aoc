package main

import (
	"crypto/sha1"
	"fmt"
)

type Position struct {
	x int
	y int
	z int
}

type Velocity struct {
	x int
	y int
	z int
}

type Moon struct {
	p *Position
	v *Velocity
}

func NewMoon(x, y, z int) Moon {
	return Moon{
		&Position{x, y, z},
		&Velocity{0, 0, 0},
	}
}

func puzzle_input() []Moon {
	moons := make([]Moon, 4)
	moons[0] = NewMoon(-15, 1, 4)
	moons[1] = NewMoon(1, -10, -8)
	moons[2] = NewMoon(-5, 4, 9)
	moons[3] = NewMoon(4, 6, -2)
	return moons
}

func test_input() []Moon {
	moons := make([]Moon, 4)
	moons[0] = NewMoon(-1, 0, 2)
	moons[1] = NewMoon(2, -10, -7)
	moons[2] = NewMoon(4, -8, 8)
	moons[3] = NewMoon(3, 5, -1)
	return moons
}

func test_input2() []Moon {
	moons := make([]Moon, 4)
	moons[0] = NewMoon(-8, -10, 0)
	moons[1] = NewMoon(5, 5, 10)
	moons[2] = NewMoon(2, -7, 3)
	moons[3] = NewMoon(9, -8, -3)
	return moons
}

func updateMoonVelocities(moons []Moon) []Moon {
	moons[0].applyGravity(moons[1])
	moons[0].applyGravity(moons[2])
	moons[0].applyGravity(moons[3])

	moons[1].applyGravity(moons[0])
	moons[1].applyGravity(moons[2])
	moons[1].applyGravity(moons[3])

	moons[2].applyGravity(moons[0])
	moons[2].applyGravity(moons[1])
	moons[2].applyGravity(moons[3])

	moons[3].applyGravity(moons[0])
	moons[3].applyGravity(moons[1])
	moons[3].applyGravity(moons[2])

	return moons
}

func (moon *Moon) applyGravity(m2 Moon) {
	if m2.p.x > moon.p.x {
		moon.v.x += 1
	} else if m2.p.x < moon.p.x {
		moon.v.x -= 1
	}

	if m2.p.y > moon.p.y {
		moon.v.y += 1
	} else if m2.p.y < moon.p.y {
		moon.v.y -= 1
	}

	if m2.p.z > moon.p.z {
		moon.v.z += 1
	} else if m2.p.z < moon.p.z {
		moon.v.z -= 1
	}
}

func updateMoonPositions(moons []Moon) []Moon {
	for i, _ := range moons {
		moons[i].updateMoonPosition()
	}
	return moons
}

func (moon *Moon) updateMoonPosition() {
	moon.p.x += moon.v.x
	moon.p.y += moon.v.y
	moon.p.z += moon.v.z
}

func (m Moon) String() string {
	return fmt.Sprintf("%v, %v\n", m.p, m.v)
}

func (p Position) String() string {
	return fmt.Sprintf("pos=<x=%v, y=%v, z=%v>", p.x, p.y, p.z)
}

func (v Velocity) String() string {
	return fmt.Sprintf("vel=<x=%v, y=%v, z=%v>", v.x, v.y, v.z)
}

func printStep(i int, moons []Moon) {
	fmt.Printf("\nAfter %v steps:\n", i)
	for _, moon := range moons {
		fmt.Print(moon)
	}
}

func abs(x int) int {
	if x < 0 {
		return x * -1
	} else {
		return x
	}
}

func (moon Moon) potential() int {
	return abs(moon.p.x) + abs(moon.p.y) + abs(moon.p.z)
}

func (moon Moon) kinetic() int {
	return abs(moon.v.x) + abs(moon.v.y) + abs(moon.v.z)
}

func hashMoons(moons []Moon) string {
	var str string
	for _, moon := range moons {
		str += fmt.Sprint(moon)
	}
	h := sha1.New()
	h.Write([]byte(str))
	bs := h.Sum(nil)
	return fmt.Sprintf("%x\n", bs)
}

func totalEnergy(moons []Moon) int {
	var sum int
	for _, moon := range moons {
		pot := moon.potential()
		kin := moon.kinetic()
		sum += pot * kin
	}
	return sum
}

func main() {
	moons := puzzle_input()
	//moons := test_input2()
	var i int
	seen := make(map[string]bool)

	for {
		moons = updateMoonVelocities(moons)
		moons = updateMoonPositions(moons)
		hash := hashMoons(moons)

		_, ok := seen[hash]
		if ok {
			fmt.Println("Complete.")
			fmt.Println(i)
			break
		}
		seen[hash] = true

		i += 1

		if i%1000000 == 0 {
			fmt.Print(".")
		}
	}
}
