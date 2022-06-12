#!/usr/bin/env python3

z = 0
x = 0

table = bytearray()

for _ in range(320*16*8):
	table.append(0)

for i in range(320):

	bitmap = 0b1000000000000000 >> (i & 15)

	for colour in range(16):

		plane0 = bool(colour & 0b0001)
		plane1 = bool(colour & 0b0010)
		plane2 = bool(colour & 0b0100)
		plane3 = bool(colour & 0b1000)

		if plane0:
			table[z+0] = (bitmap).to_bytes(2, byteorder="little")[1]
			table[z+1] = (bitmap).to_bytes(2, byteorder="little")[0]

		if plane1:
			table[z+2] = (bitmap).to_bytes(2, byteorder="little")[1]
			table[z+3] = (bitmap).to_bytes(2, byteorder="little")[0]

		if plane2:
			table[z+4] = (bitmap).to_bytes(2, byteorder="little")[1]
			table[z+5] = (bitmap).to_bytes(2, byteorder="little")[0]

		if plane3:
			table[z+6] = (bitmap).to_bytes(2, byteorder="little")[1]
			table[z+7] = (bitmap).to_bytes(2, byteorder="little")[0]

		z += 8

f = open('table.bin', 'wb')
f.write(table)
f.close()
