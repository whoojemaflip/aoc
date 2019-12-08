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

	layers := make([][]int, len(pixels)/150)

	lowest := 999999
	l_ind := 0
	for i, _ := range layers {
		layers[i] = []int{0, 0, 0}
		for j := 0; j < 150; j += 1 {
			pos := (i * 150) + j
			this := pixels[pos]
			layers[i][this] += 1
		}
		if layers[i][0] < lowest {
			l_ind = i
			lowest = layers[i][0]
		}
	}

	fmt.Println(layers[l_ind])
}
