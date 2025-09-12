/*
Subject: Daily Coding Problem: Problem #61 [Medium]

Good morning! Here's your coding interview problem for today.

This problem was asked by Google.

Implement integer exponentiation. That is, implement the pow(x, y) function,
where x and y are integers and returns x^y.

Do this faster than the naive method of repeated multiplication.

For example, pow(2, 10) should return 1024.
*/

package main

import ("fmt"
	"math")

func pow1(x int, y int) float64 {
	var out float64 = 1

	for i := 0; i < y/2; i++ {
		out *= float64 (x)
	}

	out = out * out

	if y%2 != 0 {
		out *= float64 (x)
	}

	return out
}

func powe(x int, y int) float64 {
	var out float64 = 1
	if x != 0 {
		out = math.Exp(float64 (y) * math.Log(math.Abs(float64 (x))))
	}

	if x < 0 {
		out = -out
	}

	return out
}

func main() {
	fmt.Println(pow1(2, 10))
	fmt.Println(powe(2, 10))
}
