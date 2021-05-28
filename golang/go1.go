/*
https://www.dailycodingproblem.com/
Given a list of numbers and a number k, return whether any two numbers from the list add up to k.
For example, given [10, 15, 3, 7] and k of 17, return true since 10 + 7 is 17.
Bonus: Can you do this in one pass?
*/

package main

import "fmt"

func check_one(seq []int, n int) {
	fmt.Println("seq = ", seq)
	fmt.Println("n = ", n)

	for i := 0; i < len(seq); i++ {
		for j := i+1; j < len(seq); j++ {
			if n == seq[i] + seq[j] {
				fmt.Println(seq[i], " and ", seq[j], " equals to ", n)
			}
		}
	}
}

func check_two(seq []int, n int) {
	fmt.Println("seq = ", seq)
	fmt.Println("n = ", n)

	var max = seq[0]

	for _, e := range seq {
		if max < e {
			max = e
		}
	}

	var hash = make(map[int]bool)

	for j := 0; j <= max; j++ {
		for _, e := range seq {
			if j == e {
				hash[j] = true
				break
			} else {
				hash[j] = false
			}
		}
	}

	for i, e := range seq {
		if hash[n - e] == true {
			fmt.Println(e, " and ", n - e, " equals to ", n)
			hash[seq[i]] = false
		}
	}
}

func main() {
	check_one([]int{2, 3, 5, 7, 11, 13}, 16)
	check_two([]int{2, 3, 5, 7, 11, 13}, 16)

	fmt.Println("---")

	check_one([]int{10, 15, 3, 7}, 17)
	check_two([]int{10, 15, 3, 7}, 17)

	fmt.Println("---")

	check_one([]int{10, -10, 15, 3, 7}, 0)
	check_two([]int{10, -10, 15, 3, 7}, 0)

	fmt.Println("---")

	check_one([]int{5, 5}, 10)
	check_two([]int{5, 5}, 10)

	fmt.Println("---")

	check_one([]int{10, 15, 3, 7}, 16)
	check_two([]int{10, 15, 3, 7}, 16)

	fmt.Println("---")

	check_one([]int{5}, 5)
	check_two([]int{5}, 5)
}

