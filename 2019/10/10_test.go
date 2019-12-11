package main

import (
	"fmt"
	"testing"
)

func TestVector(t *testing.T) {
	l := Pos{4, 4}
	a := Pos{4, 2}
	v := vector(l, a)
	expected := Vector{0, -2}

	if v != expected {
		fmt.Println(v, expected)
		t.Error("narp")
	}
}
