/*
Subject: Daily Coding Problem: Problem #109 [Medium]

Good morning! Here's your coding interview problem for today.

This problem was asked by Cisco.

Given an unsigned 8-bit integer, swap its even and odd bits. The 1st and 2nd bit
should be swapped, the 3rd and 4th bit should be swapped, and so on.

For example, 10101010 should be 01010101. 11100010 should be 11010001.

Bonus: Can you do this in one line?
*/

package main

import "fmt"

func swap(i int) int {
	out := ((i & 0b10101010) >> 1) | ((i & 0b01010101) << 1)
	return out
}

func main() {
	fmt.Printf("%.08b\n", swap(0b10101010))
	fmt.Printf("%.08b\n", swap(0b01010101))
	fmt.Printf("%.08b\n", swap(0b11100010))
}
