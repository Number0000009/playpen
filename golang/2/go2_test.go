package main

import "testing"

func check(a, b []int) bool {
	for i, j := range a {
		if b[i] != j {
			return false
		}
	}
	return true
}

func TestCalc(t *testing.T) {
	var a = calc([]int{1, 2, 3, 4, 5})
	var b = []int{120, 60, 40, 30, 24}
	if !check(a, b) {
		t.Log("Failed")
		t.Fail()
	}

	a = calc([]int{3, 2, 1})
	b = []int{2, 3, 6}
	if !check(a, b) {
		t.Log("Failed")
		t.Fail()
	}

	a = calc([]int{})
	b = []int{}
	if !check(a, b) {
		t.Log("Failed")
		t.Fail()
	}

	a = calc([]int{10})
	b = []int{0}
	if !check(a, b) {
		t.Log("Failed")
		t.Fail()
	}

	a = calc([]int{1, 2})
	b = []int{2, 1}
	if !check(a, b) {
		t.Log("Failed")
		t.Fail()
	}
}
