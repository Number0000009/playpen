/*
Given an array of integers, return a new array such that each element at index i
of the new array is the product of all the numbers in the original array except
the one at i.

For example, if our input was [1, 2, 3, 4, 5], the expected output would be
[120, 60, 40, 30, 24]. If our input was [3, 2, 1], the expected output would be
[2, 3, 6].

Follow-up: what if you can't use division?
*/
// Division?

package main

import "fmt"

func calc(in []int) []int {
	fmt.Println(in)

	var out [] int

	if len(in) == 1 {
		return []int{0}
	}

	for i := 0; i < len(in); i++ {
		out = append(out, 1)

		for j := 0; j < len(in); j++ {
			if i != j {
				out[i] *= in[j]
			}
		}
	}

	return out
}

func main() {
	fmt.Println(calc([]int{1, 2, 3, 4, 5}))
	fmt.Println(calc([]int{3, 2, 1}))
	fmt.Println(calc([]int{}))
	fmt.Println(calc([]int{10}))
	fmt.Println(calc([]int{1, 2}))
}
