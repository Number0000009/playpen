#!/usr/bin/env python3.9

# [ 16 bit Plane 0 ] [ 16 bit Plane 1 ] [ 16 bit Plane 2 ] [ 16 bit Plane 3 ]
#  ^^^^^^^^^^^^^^^^
#   pixel per bit

import struct

f = open('birthday.raw', 'rb')
data = f.read()
f.close()

# in bytes
DATA_WIDTH = (64//16)*8

# in bytes
SPRITE_WIDTH = ((64+16)//16)*8

f = open('birthdays.raw', 'wb')

s = []

for i in range(16):
    a = data[i*DATA_WIDTH:(i+1)*DATA_WIDTH]
    for i in a:
        s.append(i)

    for j in range(SPRITE_WIDTH - DATA_WIDTH):
        s.append(0)

sprite = bytearray()
for i in s:
    sprite.append(i)

for stage in range(16):

    plane_z = bytearray()

    new_scanline = bytearray()
    for i in range(SPRITE_WIDTH):
            new_scanline.append(0)

    for scanline in range(16):
        array = sprite[(scanline*SPRITE_WIDTH):((scanline+1)*SPRITE_WIDTH)]     # full scanline

        print("scanline =", array)

        plane_start = 0

        for plane in range(4):

            x = 0

            print('plane_start', plane_start)

            for plane_off in range(SPRITE_WIDTH//8):
                x = x << 16
                x |= array[plane_off * 8 + plane_start] << 8 | array[plane_off * 8 + 1 + plane_start]

            x >>= stage

            print('x', hex(x))

            # pack back

            # flip x
            z = 0
            for i in range(SPRITE_WIDTH//4):
                b = x & 0xff
                x = x >> 8

                z = z << 8
                z = z | b

            x = z
            z = 0

            print("x'", hex(x))

            for plane_off in range(SPRITE_WIDTH//8):

                z = x & 0xffff
                x = x >> 16

                z = z.to_bytes(2, 'little')

#                print(hex((scanline*SPRITE_WIDTH) + plane_off * 8 + plane_start))
                print(hex(plane_off * 8 + plane_start))
                print(hex(z[0]))
                print(hex(z[1]))

                new_scanline[plane_off * 8 + plane_start] = z[0]
                new_scanline[plane_off * 8 + 1 + plane_start] = z[1]

            plane_start += 2

        f.write(new_scanline)

f.close()
