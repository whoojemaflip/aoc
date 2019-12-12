package main

import "testing"

func TestApplyGravity(t *testing.T) {
	moon_1 := Moon{
		&Position{1, 2, 3},
		&Velocity{0, 0, 0},
	}

	moon_2 := Moon{
		&Position{3, 2, 1},
		&Velocity{0, 0, 0},
	}

	moon_1.applyGravity(moon_2)

	expected_velocity := Velocity{1, 0, -1}

	if *moon_1.v != expected_velocity {
		t.Error("well, shit")
	}
}
