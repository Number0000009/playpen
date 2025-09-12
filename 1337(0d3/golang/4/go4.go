/*
Subject: Daily Coding Problem: Problem #106 [Medium]

Good morning! Here's your coding interview problem for today.

This problem was asked by Pinterest.

Given an integer list where each number represents the number of hops you can
make, determine whether you can reach to the last index starting at index 0.

For example, [2, 0, 1, 0] returns True while [1, 1, 0, 1] returns False.
*/

package main

import "fmt"

func check(list []int) bool {

	if len(list) == 0 {
		return false;
	}

	landing := len(list) - 1

	sum := 0

	for i := 0; i < landing; i++ {

		if sum == 0 {
			sum += list[i]
		}

		if sum == 0 {
			return false
		}

		sum--
	}

	if sum == 0 && list[0] == 0 {
		return false
	}

	return true
}

func main() {
	fmt.Println(check([]int{0}))	// F
	fmt.Println(check([]int{1}))	// T
	fmt.Println(check([]int{}))	// F

	fmt.Println(check([]int{1, 0, 2, 1}))	// F
	fmt.Println(check([]int{2, 0, 1, 0}))	// T
	fmt.Println(check([]int{2, 0, 1, 2, 0}))	// T
	fmt.Println(check([]int{1, 1, 0, 1}))	// F
	fmt.Println(check([]int{1, 1, 1, 1}))	// T
	fmt.Println(check([]int{1, 1, 1, 0}))	// T
	fmt.Println(check([]int{1, 1, 0, 1}))	// F
}
