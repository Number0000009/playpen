#!/usr/bin/env python3

import unittest
from swap import Swap


class TestMethods(unittest.TestCase):
	def test1(self):
		s = Swap()
		self.assertEqual(s.swap([0, 1, 2], ["a", "b", "c"]), ["a", "b", "c"])

	def test2(self):
		s = Swap()
		self.assertEqual(s.swap([2, 1, 0], ["a", "b", "c"]), ["c", "b", "a"])

	def test3(self):
		s = Swap()
		self.assertEqual(s.swap([0, 0, 0], ["a", "b", "c"]), ["a", "a", "a"])

	def test4(self):
		s = Swap()
		self.assertEqual(s.swap([], []), [])

	def test5(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [666], ["z"])

	def test6(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [0, 1, 2], ["a"])

	def test7(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [], ["a"])

	def test8(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [0], [])

	def test9(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [666], [])

	def test10(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [-666], [])

	def test11(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [-666], ["a"])

	def test12(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [], ["a"])

	def test13(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [0], ["abcde"])

	def test14(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [], ["abcde"])

	def test15(self):
		s = Swap()
		self.assertRaises(AssertionError, s.swap, [0, 1, 2], [])


unittest.main()
