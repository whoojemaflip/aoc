package main

import "testing"

func t1_input() [][4]int {
	start := make([][4]int, 3, 3)
	start[0] = [...]int{-1, 2, 4, 3}
	start[1] = [...]int{0, -10, -8, 5}
	start[2] = [...]int{2, -7, 8, -1}
	return start
}

func t2_input() [][4]int {
	start := make([][4]int, 3, 3)
	start[0] = [...]int{-8, 5, 2, 9}
	start[1] = [...]int{-10, 5, -7, -8}
	start[2] = [...]int{0, 10, 3, -3}
	return start
}

func TestCalcRepeatIntervalSet1(t *testing.T) {
	result := calcRepeatInterval(t1_input())
	if result != 2772 {
		t.Errorf("Failed test 1, expected 2772 got %v", result)
	}
}

func TestCalcRepeatIntervalSet2(t *testing.T) {
	result := calcRepeatInterval(t2_input())
	if result != 4686774924 {
		t.Errorf("Failed test 2, expected 27468677492472 got %v", result)
	}
}

func TestCalcEnergySet1(t *testing.T) {
	result := calcEnergy(t1_input(), 10)

	if result != 179 {
		t.Errorf("Failed calculating energy, expected 179 got %v", result)
	}
}
func TestCalcEnergySet2(t *testing.T) {
	result := calcEnergy(t2_input(), 100)

	if result != 1940 {
		t.Errorf("Failed calculating energy, expected 1940 got %v", result)
	}
}
