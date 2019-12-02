package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func loadFile(filename string) []int {
	data, err := ioutil.ReadFile(filename)
	check(err)

	numbers := strings.Fields(string(data))

	out := make([]int, len(numbers))
	for i, n := range numbers {
		out[i], _ = strconv.Atoi(n)
	}
	return out
}

func calcFuelForMass(mass int) int {
	return (mass / 3) - 2
}

func sum(numbers []int) int {
	var out int
	for _, n := range numbers {
		fuel := calcFuelForMass(n)

		for fuel > 0 {
			out += fuel
			fuel = calcFuelForMass(fuel)
		}
	}
	return out
}

func main() {
	filename := os.Args[1]
	nums := loadFile(filename)
	result := sum(nums)
	fmt.Println(result)
}
