package main

import "testing"

func TestCheck(t *testing.T) {

	if check([]int{1, 0, 2, 1}) {
		t.Log("Failed")
		t.Fail()
	}

	if !check([]int{2, 0, 1, 0}) {
		t.Log("Failed")
		t.Fail()
	}

	if !check([]int{2, 0, 1, 2, 0}) {
		t.Log("Failed")
		t.Fail()
	}

	if check([]int{1, 1, 0, 1}) {
		t.Log("Failed")
		t.Fail()
	}

	if !check([]int{1, 1, 1, 1}) {
		t.Log("Failed")
		t.Fail()
	}

	if !check([]int{1, 1, 1, 0}) {
		t.Log("Failed")
		t.Fail()
	}

	if check([]int{1, 1, 0, 1}) {
		t.Log("Failed")
		t.Fail()
	}

	if check([]int{1, 0, 1, 1}) {
		t.Log("Failed")
		t.Fail()
	}

	if check([]int{0, 1, 1, 1}) {
		t.Log("Failed")
		t.Fail()
	}

	if check([]int{1, 0, 2, 1}) {
		t.Log("Failed")
		t.Fail()
	}

	if !check([]int{1, 2, 0, 1}) {
		t.Log("Failed")
		t.Fail()
	}

	if check([]int{2, 1, 0, 1}) {
		t.Log("Failed")
		t.Fail()
	}

	if check([]int{}) {
		t.Log("Failed")
		t.Fail()
	}

	if check([]int{0}) {
		t.Log("Failed")
		t.Fail()
	}

	if !check([]int{1}) {
		t.Log("Failed")
		t.Fail()
	}
}
