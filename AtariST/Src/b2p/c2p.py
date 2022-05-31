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

# 16 word size colour registers 3 bits per colour:
# xxxxxR2R1R0xG2G1G0xB2B1B0

f = open('logopouet.raw', 'rb')
data = f.read()
f.close()

j = 0

screen = bytearray()
for i in range(320*200//16*8):
	screen.append(0)

screen_word = 0

for i in range(320*200):
	colour = data[i]

	plane0 = colour & 0b0001
	plane1 = colour & 0b0010
	plane2 = colour & 0b0100
	plane3 = colour & 0b1000

	screen_bitmap = 0b1000000000000000 >> (i & 15)

	word_byte = (i % 16) // 8

	if (i & 15) == False:
		if i > 0:
			screen_word += 8

	if plane0:
		screen[(screen_word + 0) + word_byte] |= (screen_bitmap).to_bytes(2, byteorder="little")[1]
		screen[(screen_word + 0) + word_byte] |= (screen_bitmap).to_bytes(2, byteorder="little")[0]

	if plane1:
		screen[(screen_word + 2) + word_byte] |= (screen_bitmap).to_bytes(2, byteorder="little")[1]
		screen[(screen_word + 2) + word_byte] |= (screen_bitmap).to_bytes(2, byteorder="little")[0]

	if plane2:
		screen[(screen_word + 4) + word_byte] |= (screen_bitmap).to_bytes(2, byteorder="little")[1]
		screen[(screen_word + 4) + word_byte] |= (screen_bitmap).to_bytes(2, byteorder="little")[0]

	if plane3:
		screen[(screen_word + 6) + word_byte] |= (screen_bitmap).to_bytes(2, byteorder="little")[1]
		screen[(screen_word + 6) + word_byte] |= (screen_bitmap).to_bytes(2, byteorder="little")[0]


f = open('logopouet.pi1', 'wb')
f.write(screen)
f.close()
