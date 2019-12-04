package main

import "testing"

func TestTestAdjacent(t *testing.T) {
	if !testAdjacent(112233) {
		t.Error("all repeated digits are exactly two digits long")
	}

	if testAdjacent(123444) {
		t.Error("the repeated 44 is part of a larger group of 444")
	}

	if !testAdjacent(111122) {
		t.Error("even though 1 is repeated more than twice, it still contains a double 22")
	}
}
