#!/usr/bin/env python3

#TODO: recursion is dangerous

def parse_one(input, output):
	if isinstance(input, int):
		output.append(input)
		return
	else:
		for i in input:
			parse_one(i, output)

l = [1,2,3], [[[42]]], [[]], [[4], 5, 6], [[7, 8, 9]]
k = []

print("initial ", l)
parse_one(l, k)

print("final")
print(k)

l = [1,2,3]
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

l = [], [1,2,3], [[]], [[4], 5, 6], [[7, 8, 9]]
k = []

print("initial ", l)
parse_one(l, k)

print("final")
print(k)
