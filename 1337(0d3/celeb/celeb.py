#!/usr/bin/env python3

"""
Given a party when someone knows someone = pleb;
celeb doesn't know anyone, but everyone know celeb;
Find celeb

Given O(1) func knows find celeb in O(N)
"""

N = 4
connections = [
				[0, 1, 1, 0],	# knows 1 and 2
				[0, 0, 1, 0],	# knows 3
				[0, 0, 0, 0],	# doesn't know anyone (celeb)
				[1, 0, 1, 0]	# knows 0 and 2
				]

#N = 4
#connections = [
#				[0, 0, 0, 0],
#				[0, 0, 1, 0],
#				[0, 0, 0, 0],
#				[1, 0, 0, 0]
#				]


def knows(a: int, b: int) -> bool:
	if connections[a][b]:
		return True
	return False

celebs = [-1 for _ in range(N)]

# Find celeb in O(N^2)
for i in range(N):
	print("person", i)
	for j in range(N):
		if knows(i, j) and i != j:
			print(i, "knows", j, "-> pleb")
			celebs[i] = -1
			break
		else:
			print("doesn't know", j)
	else:
		celebs[i] = i

print(celebs)

# sanity check
c = 0
for i in celebs:
	if i >= 0:
		c += 1

if c != 1:
    print("Wow wow wow, this program doesn't work for sure")
    exit(1)

for i in celebs:
	if i >= 0:
		print("Celeb is", i)
		break

# TODO: find celeb in O(N)
