#! /usr/bin/env python3.9

import math
import curses
import time

#stdscr = curses.initscr()

i = 0
j = 0
k = 0

table = bytearray()

for _ in range(631 * 2):
    table.append(0)

while j < 631:
#while True:
#    stdscr.clear()

    i += 0.01
    x = int(math.sin(i*5 + 3.14/2)*70 + 100)
    y = int(math.cos(i*6)*60 + 100)

    print(x)
    print(y)
    table[k] = x
    k += 1
    table[k] = y
    k += 1

#    stdscr.addstr(y, x, '.')

#    stdscr.refresh()

#    time.sleep(0.05)
    j += 1

f = open('table.bin', 'wb')
f.write(table)
f.close()
