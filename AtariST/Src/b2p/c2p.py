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

# 16 word size colour registers 3 bits per colour:
# xxxxxR2R1R0xG2G1G0xB2B1B0

f = open('palette.txt', 'rt')
data = f.readlines()
f.close()

pal_data = []
for i in range(len(data)):
	d = data[i].strip('\n')
	d = d.replace('#', '')
	pal_data.append(int(d, 16))

for i in pal_data:
	print(hex(i))

pal = bytearray()
for i in range(16*2):
	pal.append(0)

# ff is 0f
# scale down

j = 0

for i in pal_data:
	r = i >> 16
	g = (i & 0xff00) >> 8
	b = i & 0xff

	print("or", hex(r))
	print("og", hex(g))
	print("ob", hex(b))

	r = int(r / (256/8))
	g = int(g / (256/8))
	b = int(b / (256/8))

	print("nr", hex(r))
	print("ng", hex(g))
	print("nb", hex(b))

# xxxxxRRR xGGGxBBB
	col = r<<8 | g<<4 | b
	pal[j+0] = col>>8
	pal[j+1] = col & 0x00ff

#	print(hex(pal[j+0]))
#	print(hex(pal[j+1]))

#	print(hex(col))

	j += 2

f = open('logopouet.pal', 'wb')
f.write(pal)
f.close()
