package main

import "fmt"

func check(list []int, k int) bool {

	length := len(list)
	list = append(list, 0)

	current_sum := 0
	steps_back := 0

	for i := 0; i < length; i++ {

		current_sum += list[i]

		if current_sum == k {
			return true
		}

		// Overflow
		if current_sum > k {
			i -= steps_back
			current_sum = 0
			steps_back = 0
			continue
		}

		// Monotonicity break
		if list[i + 1] != list[i] + 1 {
			current_sum = 0
			continue
		}
		steps_back += 1
	}
	return false
}

func main() {
	fmt.Println(check([]int{1, 2, 3, 4, 1, 5}, 9))	// T
	fmt.Println(check([]int{1, 2, 3, 4, 5, 1, 5, 6}, 9))	// T
	fmt.Println(check([]int{1, 2, 3, 4, 5}, 9))	// T
	fmt.Println(check([]int{1, 2, 1, 4, 5}, 9))	// T
	fmt.Println(check([]int{1, 2, 1, 4, 5}, 3))	// T
	fmt.Println(check([]int{1, 2, 1, 4, 0}, 5))	// F
	fmt.Println(check([]int{1, 2, 1, 4, 5}, 4))	// T
	fmt.Println(check([]int{100, 2, 1, 4, 5}, 4))	// T
	fmt.Println(check([]int{1, 100, 2, 3, 4, 1, 5}, 9))	// T
	fmt.Println(check([]int{1, 100, 1, 100, 2, 3, 4, 1, 5}, 9))	// T
}
