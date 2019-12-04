package main

import (
	"fmt"
	"strconv"
)

func main() {
	var low = 138307
	var high = 654504

	result := 0

	for i := low; i < high; i++ {
		if test(i) {
			result += 1
		}
	}

	fmt.Println(result)
}

func test(i int) bool {
	return testAdjacent(i) && testIncreasing(i)
}

func testIncreasing(i int) bool {
	var last_byte byte
	for _, char := range strconv.Itoa(i) {
		if byte(char) < last_byte {
			return false
		}
		last_byte = byte(char)
	}
	return true
}

func testAdjacent(i int) bool {
	last_char := '-'
	repeat_count := 1

	for _, char := range strconv.Itoa(i) {
		if char == last_char {
			repeat_count += 1
		} else if repeat_count == 2 {
			return true
		} else {
			repeat_count = 1
		}
		last_char = char
	}
	if repeat_count == 2 {
		return true
	} else {
		return false
	}
}
