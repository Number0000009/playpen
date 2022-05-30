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

f = open('logopouet.raw', 'rb')
data = f.read()
f.close()

screen = bytearray()
for i in range(320*200//16*8):
	screen.append(0)

word_size = 2
word_count = 0

for i in range(320*200):
	colour = data[i]

	plane0 = colour & 0b0001
	plane1 = colour & 0b0010
	plane2 = colour & 0b0100
	plane3 = colour & 0b1000

	screen_bitmap = 0b1000000000000000 >> (i & 15)
	screen_word = word_count // 16

	screen_word *= word_size

	if plane0:
		screen[(screen_word + 0) + 0] |= (screen_bitmap).to_bytes(2, byteorder="little")[1]
		screen[(screen_word + 0) + 1] |= (screen_bitmap).to_bytes(2, byteorder="little")[0]

	if plane1:
		screen[(screen_word + 1 * word_size) + 0] |= (screen_bitmap).to_bytes(2, byteorder="little")[1]
		screen[(screen_word + 1 * word_size) + 1] |= (screen_bitmap).to_bytes(2, byteorder="little")[0]

	if plane2:
		screen[(screen_word + 2 * word_size) + 0] |= (screen_bitmap).to_bytes(2, byteorder="little")[1]
		screen[(screen_word + 2 * word_size) + 1] |= (screen_bitmap).to_bytes(2, byteorder="little")[0]

	if plane3:
		screen[(screen_word + 3 * word_size) + 0] |= (screen_bitmap).to_bytes(2, byteorder="little")[1]
		screen[(screen_word + 3 * word_size) + 1] |= (screen_bitmap).to_bytes(2, byteorder="little")[0]

	word_count += 4

f = open('logopouet.pi1', 'wb')
f.write(screen)
f.close()