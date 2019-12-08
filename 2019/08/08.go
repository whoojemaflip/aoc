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
	d2 := strings.Trim(string(data), "\n ")

	out := make([]int, len(d2))
	for i, n := range d2 {
		out[i], _ = strconv.Atoi(string(n))
	}
	return out
}

func main() {
	filename := os.Args[1]
	pixels := loadFile(filename)
	layers := len(pixels) / 150

	image := make([]int, 150)

	for i := range image {
		image[i] = 2
	}

	for i := 0; i < layers; i += 1 {
		for j := 0; j < 150; j += 1 {
			pos := (i * 150) + j

			if image[j] == 2 {
				image[j] = pixels[pos]
			}
		}
	}

	for i := 0; i < 6; i += 1 {
		row := 25 * i
		fmt.Printf("%v\n", image[row:row+25])
	}
}
