#!/usr/bin/env python3

f = open('logopouet.raw', 'rb')
data = f.read()
f.close()

pic = bytearray()
for i in range(320*200):
	pic.append(data[i] * 8)

f = open('logopouet_scaled.raw', 'wb')
f.write(pic)
f.close()
