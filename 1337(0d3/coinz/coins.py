#!/usr/bin/env python

coins = [1, 5, 10, 25]

coins = reversed(sorted(coins))

#n = 21 (10 + 10 + 1)
#n = 16 (10 + 5 + 1)
n = 5

res = []

def find(n):
    print(f"n = {n}")
    for i in coins:
        if n // i >= 1:
            new_n = n // i
            print(f"new_n {new_n}  n {n}  i {i}")
            print(f"n - new_n * i = {n - (new_n * i)}")

            for _ in range(n // i):
                res.append(i)

            if n - (new_n * i) == 0:
                print(f"exiting for {(n - new_n * i)}")
                return

            else:
                find(n - (new_n * i))


find(n)


print(res)
