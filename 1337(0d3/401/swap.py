#!/usr/bin/env python3

"""
Daily Coding Problem: Problem #401 [Easy]

A permutation can be specified by an array P, where P[i] represents
the location of the element at i in the permutation.
For example, [2, 1, 0] represents the permutation where elements
at the index 0 and 2 are swapped.

Given an array and a permutation, apply the permutation to the array.
For example, given the array ["a", "b", "c"] and the permutation [2, 1, 0],
return ["c", "b", "a"].
"""

class Swap:
	def swap(self, P, S) -> []:
		assert(len(P) == len(S))

		output = []

		for i in P:
			assert(i >= 0)
			assert(i <= len(S))
			assert(len(S[i]) == 1)
			output.append(S[i])

		return output


if __name__ == '__main__':
	s = Swap()

	P = [2, 1, 0]
	S = ["a", "b", "c"]

	print(s.swap(P, S))
