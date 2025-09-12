package main

import "testing"

func TestCheck(t *testing.T) {

	if swap(0xaa) != 0x55 {
		t.Log("Failed")
		t.Fail()
	}

	if swap(0x55) != 0xaa {
		t.Log("Failed")
		t.Fail()
	}

	if swap(0b11100010) != 0b11010001 {
		t.Log("Failed")
		t.Fail()
	}

	if swap(0xff) != 0xff {
		t.Log("Failed")
		t.Fail()
	}

	if swap(0xf0) != 0xf0 {
		t.Log("Failed")
		t.Fail()
	}

	if swap(0b11111000) != 0b11110100 {
		t.Log("Failed")
		t.Fail()
	}

	if swap(0b01111000) != 0b10110100 {
		t.Log("Failed")
		t.Fail()
	}
}
