package main

import "testing"
import "math"

func check(a, b, c float64) bool {
//	e := math.Nextafter(1, 2) - 1
	e := 0.0000001
	ab := a - b
	ac := a - c
	ba := b - a
	bc := b - c
	ca := c - a
	cb := c - b

	return ab < e && ac < e && ba < e && bc < e && ca < e && cb < e
}

func TestPow(t *testing.T) {
	var a = pow1(2, 10)
	var b = powe(2, 10)
	var c = math.Pow(2, 10)

	if !check(a, b, c) {
		t.Log("Failed", a, b, c)
		t.Fail()
	}

	a = pow1(5, 11)
	b = powe(5, 11)
	c = math.Pow(5, 11)

	if !check(a, b, c) {
		t.Log("Failed", a, b, c)
		t.Fail()
	}

	a = pow1(1, 1)
	b = powe(1, 1)
	c = math.Pow(1, 1)

	if !check(a, b, c) {
		t.Log("Failed", a, b, c)
		t.Fail()
	}

	a = pow1(0, 0)
	b = powe(0, 0)
	c = math.Pow(0, 0)

	if !check(a, b, c) {
		t.Log("Failed", a, b, c)
		t.Fail()
	}

	a = pow1(-1, -1)
	b = powe(-1, -1)
	c = math.Pow(-1, -1)

	if !check(a, b, c) {
		t.Log("Failed", a, b, c)
		t.Fail()
	}
}
