package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func loadFile(filename string) []int {
	data, err := ioutil.ReadFile(filename)
	check(err)

	out := make([]int, 0)
	for _, n := range data {
		i := int(n - 48)
		if i >= 0 && i <= 9 {
			out = append(out, i)
		}
	}
	return out
}

func patterns(n int) [][]int {
	base := []int{0, 1, 0, -1}
	out := make([][]int, n)

	for i := 0; i < n; i += 1 { // create each pattern
		out[i] = make([]int, 0)

		for {
			for j := 0; j < len(base); j += 1 {
				for m := 0; m < i+1; m += 1 {
					out[i] = append(out[i], base[j]%len(base))
				}
			}

			if len(out[i]) > n {
				out[i] = out[i][1 : n+1]
				break
			}
		}

	}

	return out
}

func fft(data []int, patterns [][]int) []int {
	out := make([]int, len(data))
	for i := 0; i < len(data); i += 1 {
		p := patterns[i]
		sum := 0
		for j := 0; j < len(data); j += 1 {
			sum += data[j] * p[j]
		}
		out[i] = abs(sum) % 10
	}
	return out
}

func abs(x int) int {
	if x < 0 {
		return x * -1
	} else {
		return x
	}
}

func fftIterations(data []int, patterns [][]int, iterations int) []int {
	for i := 0; i < iterations; i += 1 {
		data = fft(data, patterns)
	}
	return data
}

func main() {
	filename := os.Args[1]
	data := loadFile(filename)
	patterns := patterns(len(data))
	result := fftIterations(data, patterns, 100)
	fmt.Println(result)
}
