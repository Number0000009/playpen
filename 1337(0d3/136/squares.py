#!/usr/bin/env python3

'''
Daily Coding Problem: Problem #136 [Medium]

This question was asked by Google.

Given an N by M matrix consisting only of 1's and 0's, find the largest rectangle containing only 1's and return its area.

For example, given the following matrix:

[[1, 0, 0, 0],
 [1, 0, 1, 1],
 [1, 0, 1, 1],
 [0, 1, 0, 0]]
Return 4.
'''

import unittest


class Square:
    def __init__(self, m) -> None:
        self.m = m


    def __side_h(self) -> int:
        return len(self.m[0])


    def __side_v(self) -> int:
        return len(self.m)


    def __check_down(self, i, j) -> int:
        z = 0
        steps = 0

        if self.__side_h() - 1 - j > self.__side_v() - 1:
            steps = self.__side_v() - 1
        else:
            steps = self.__side_h() - 1 - j

        for k in range(steps):
            if self.m[i+k][j+k] and self.m[i+k][j+k+1] and self.m[i+k+1][j+k] and self.m[i+k+1][j+k+1]:
                z += 1
            else:
                pass

        if z > 0:
            z += 1

        return z


    def print(self) -> None:
        for i in range(self.__side_v()):
            print(self.m[i])


    def get(self) -> int:
        sizes = []
        for i in range(self.__side_h()):
            sizes.append(self.__check_down(0, i))

        return (max(sizes)) ** 2


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


if __name__ == '__main__':
    unittest.main()

    square = Square([[1, 0, 0, 0], \
                     [1, 0, 1, 1], \
                     [1, 0, 1, 1], \
                     [0, 1, 0, 0]])

    square.print()

    print(square.get())
