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


if __name__ == '__main__':

    square = Square([[1, 0, 0, 0], \
                     [1, 0, 1, 1], \
                     [1, 0, 1, 1], \
                     [0, 1, 0, 0]])

    square.print()

    print(square.get())
