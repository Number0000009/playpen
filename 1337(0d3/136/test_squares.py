#!/usr/bin/env python3

import unittest
from squares import Square


class TestMethods(unittest.TestCase):

    def test1(self):
        print("\n")

        m = [
            [1, 0, 0, 0],
            [1, 0, 1, 1],
            [1, 0, 1, 1],
            [0, 1, 0, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 4)


    def test2(self):
        print()

        m = [
            [1, 0, 0, 0, 1],
            [1, 0, 1, 1, 0],
            [0, 0, 1, 1, 0],
            [1, 0, 0, 0, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 4)


    def test3(self):
        print()

        m = [
            [1, 0, 0, 0, 1],
            [1, 0, 1, 1, 1],
            [0, 0, 1, 1, 1],
            [1, 0, 1, 1, 1]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 9)


    def test4(self):
        print()

        m = [
            [1, 0, 0, 0, 1, 0, 0, 0],
            [1, 0, 1, 1, 1, 0, 1, 1],
            [0, 0, 1, 1, 1, 0, 1, 1],
            [1, 0, 1, 1, 1, 0, 0, 0],
            [1, 0, 0, 0, 0, 0, 0, 0],
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 9)


    def test5(self):
        print()

        m = [
            [1, 0, 0, 0, 1, 0],
            [1, 0, 1, 1, 1, 0],
            [0, 0, 1, 1, 1, 0],
            [1, 0, 1, 1, 1, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 9)


    def test6(self):
        print()

        m = [
            [1, 0, 0],
            [1, 1, 1],
            [0, 1, 1],
            [1, 0, 0],
            [1, 0, 1]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 4)


    def test7(self):
        print()

        m = [
            [0, 1, 0],
            [1, 1, 1],
            [1, 0, 1],
            [0, 1, 0],
            [0, 1, 1]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test8(self):
        print("\n")

        m = [
            [1, 0, 0, 0],
            [1, 0, 0, 1],
            [1, 0, 1, 1],
            [0, 1, 0, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test9(self):
        print("\n")

        m = [
            [1, 0, 0, 0],
            [1, 0, 1, 0],
            [1, 0, 1, 1],
            [0, 1, 0, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test10(self):
        print("\n")

        m = [
            [1, 0, 0, 0],
            [1, 0, 1, 1],
            [1, 0, 1, 0],
            [0, 1, 0, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test11(self):
        print("\n")

        m = [
            [1, 0, 0, 0],
            [1, 0, 1, 1],
            [1, 0, 0, 1],
            [0, 1, 0, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test12(self):
        print("\n")

        m = [
            [1, 0, 0, 0],
            [1, 0, 0, 0],
            [1, 0, 0, 0],
            [0, 1, 0, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test13(self):
        print("\n")

        m = [
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test14(self):
        print("\n")

        m = [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 16)


    def test15(self):
        print("\n")

        m = [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 9)


    def test16(self):
        print("\n")

        m = [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 16)


    def test17(self):
        print()

        m = [
            [1, 0, 0, 0, 1],
            [1, 0, 1, 0, 0],
            [0, 0, 0, 0, 0],
            [1, 0, 0, 0, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test18(self):
        print()

        m = [
            [1, 0, 0, 0, 1],
            [1, 0, 1, 1, 1],
            [0, 0, 1, 0, 1],
            [1, 0, 1, 1, 1]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test19(self):
        print()

        m = [
            [1, 0, 0, 0, 1, 0, 0, 0],
            [1, 0, 1, 1, 1, 0, 1, 1],
            [0, 0, 1, 0, 1, 0, 1, 1],
            [1, 0, 1, 1, 1, 0, 0, 0],
            [1, 0, 0, 0, 0, 0, 0, 0],
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 4)


    def test20(self):
        print()

        m = [
            [1, 0, 0, 0, 1, 0, 0, 0],
            [1, 0, 1, 1, 1, 0, 0, 1],
            [0, 0, 1, 0, 1, 0, 1, 1],
            [1, 0, 1, 1, 1, 0, 0, 0],
            [1, 0, 0, 0, 0, 0, 0, 0],
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test21(self):
        print()

        m = [
            [1, 0, 0, 0, 1, 0],
            [1, 0, 1, 0, 1, 0],
            [0, 0, 1, 1, 1, 0],
            [1, 0, 1, 1, 1, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 4)


    def test22(self):
        print()

        m = [
            [1, 0, 0, 0, 1, 0],
            [1, 0, 1, 1, 1, 0],
            [0, 0, 1, 1, 0, 0],
            [1, 0, 1, 1, 1, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 4)


    def test23(self):
        print()

        m = [
            [1, 0, 0, 0, 1, 0],
            [1, 0, 1, 1, 1, 0],
            [0, 0, 1, 0, 1, 0],
            [1, 0, 1, 1, 1, 0]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 0)


    def test24(self):
        print()

        m = [
            [1, 0, 0],
            [1, 1, 1],
            [0, 1, 1],
            [1, 0, 0],
            [1, 0, 1]
            ]

        square = Square(m)
        square.print()
        s = square.get();
        print(s)
        self.assertEqual(s, 4)


unittest.main()
