#!/usr/bin/env python3

# [ 16 bit Plane 0 ] [ 16 bit Plane 1 ] [ 16 bit Plane 2 ] [ 16 bit Plane 3 ]
#  ^^^^^^^^^^^^^^^^
#   pixel per bit
# 0b0000 - background colour #0
# 0b1000 - colour #1 Plane 0
# 0b0100 - colour #2 Plane 1
# 0b0010 - colour #4 Plane 2
# 0b0001 - colour #8 Plane 3
# 0b1111 - colour #16 Plane 0, 1, 2, 3

#input = 0x0f # 0b1111 - one per Plane
pos_x = 0
colour = 15

assert(colour <= 15)

print("Input", bin(colour))

plane0 = colour & 0b0001
plane1 = colour & 0b0010
plane2 = colour & 0b0100
plane3 = colour & 0b1000

print("Plane0", "0b{0:>04b}".format(plane0))
print("Plane1", "0b{0:>04b}".format(plane1))
print("Plane2", "0b{0:>04b}".format(plane2))
print("Plane3", "0b{0:>04b}".format(plane3))

screen_byte = 0b1000000000000000 >> (pos_x & 15)
print("screen word number", pos_x // 16)
print("screen byte number", (pos_x % 8) // 4)
print("screen byte", hex(screen_byte))
