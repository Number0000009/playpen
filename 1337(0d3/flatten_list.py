#!/usr/bin/env python3

#TODO: recursion is dangerous

import unittest

def parse_one(input, output):
	if isinstance(input, int):
		output.append(input)
		return
	else:
		for i in input:
			parse_one(i, output)


class TestMethods(unittest.TestCase):
	def test_one(self):
		l = [1, 2, 3], [[[42]]], [[]], [[4], 5, 6], [[7, 8, 9]]
		k = []
		parse_one(l, k)
		self.assertEqual(k, [1, 2, 3, 42, 4, 5, 6, 7, 8, 9])

	def test_two(self):
		l = [1, 2, 3]
		k = []
		parse_one(l, k)
		self.assertEqual(k, [1, 2, 3])

	def test_three(self):
		l = []
		k = []
		parse_one(l, k)
		self.assertEqual(k, [])

	def test_four(self):
		l = [], [1, 2, 3], [[]], [[4], 6, 5], [[9, 8, 7]]
		k = []
		parse_one(l, k)
		self.assertEqual(k, [1, 2, 3, 4, 6, 5, 9, 8, 7])


if __name__ == '__main__':
	unittest.main()

l = [1, 2, 3], [[[42]]], [[]], [[4], 5, 6], [[7, 8, 9]]
k = []

print("initial ", l)
parse_one(l, k)

print("final")
print(k)

l = [1, 2, 3]
k = []

print("initial ", l)
parse_one(l, k)

print("final")
print(k)

l = []
k = []

print("initial ", l)
parse_one(l, k)

print("final")
print(k)

l = [], [1, 2, 3], [[]], [[4], 6, 5], [[9, 8, 7]]
k = []

print("initial ", l)
parse_one(l, k)

print("final")
print(k)
