#!/usr/bin/env python3

# given a number, find the next closest one
# with the same amount of bits set to "1"
# i.e. 6 (0b0110) -> 9 (0b1001)

# say we have 0b0110
# we go from right to left until a set bit resets:
# 0, 1, 1, 0
# so the split will be at the 3rd bit:
# 0 | 110
# then we swap bordering bits:
# 1 | 010
# then we shift the right part to the right until it's the smallest:
# 0b001
# then we merge everything together:
# 0b1 | 0b001 = 0b1001

# 0b1001 -> 0x1010
# 1, 0
# split:
# 100|1
# swap:
# 1010
# TODO: whoops, what to do with the shift to the right???
# shift if the right part has at least 2 bits

# say we have 0b10011100 -> 0b10100011
# 0, 0, 1, 1, 1, 0
# split is at bit 4
# 100 | 11100
# swap:
# 101 | 01100
# 01100 >> all the way = 00011
# merge:
# 0b101 | 0b00011 = 0b10100011

# say we have 0b10100011 -> 0b10100101
# 1, 1, 0
# split:
# 101000 | 11
# swap:
# 101001 | 10
# 10 -> 01
# 101001 | 01 = 10100101

import unittest

#n = 3
#n = 6
#n = 9
#n = 0b10100011 # 163

def next(n:int) -> int:
	sn = list("{0:08b}".format(n))
	print(n, bin(n))

	bits = len(sn) - 1

	latch = False
	for i in range(bits):
		if sn[bits - i] == "0" and latch == True:
			del sn[bits - i:bits - i + 1]
			sn.insert(bits - i + 1, "0")

			# count trailing zeroes
			zeroes = 0
			latch2 = False

			# if the last bit is "0" and there's at least 2 bits
			if sn[bits] != "1" and i >= 2:
				for j in range(bits - i + 1, bits + 1):
					if sn[j] == "0" and latch2 == False:
						zeroes += 1
					else:
						latch2 = True
						continue

			for k in range(zeroes):
				del sn[bits: bits + 1]
				sn.insert(j - 1, "0")

			break
		else:
			latch = True

	z = str()

	for b in sn:
		z += b

	z = int(z, 2)

	print(z, bin(z))
	return z


class TestMethods(unittest.TestCase):
	def test_one(self):
		n = next(3)
		self.assertEqual(n, 5)


	def test_two(self):
		n = next(6)
		self.assertEqual(n, 9)


	def test_three(self):
		n = next(9)
		self.assertEqual(n, 10)


	def test_four(self):
		n = next(163)
		self.assertEqual(n, 165)


	def test_five(self):
		n = next(0)
		self.assertEqual(n, 0)


	def test_six(self):
		n = next(1)
		self.assertEqual(n, 2)


	def test_seven(self):
		n = next(0b10000000)
		self.assertNotEqual(n, 0b100000000)


	def test_eight(self):
		n = next(0b00001)
		self.assertEqual(n, 0b00010)


	def test_nine(self):
		n = next(2)
		self.assertEqual(n, 4)


if __name__ == '__main__':
	unittest.main()

