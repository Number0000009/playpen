import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.connect(("127.0.0.1", 43967))

s.send(b"C")

# SOH 01 255-01 data[128] crc-16[2]
data = s.recv(128 + 2 + 1 + 1 + 1)

print(data.hex())

s.send(b"\x06")	# ACK

data = s.recv(128 + 2 + 1 + 1 + 1)

print(data.hex())

# 4 = EOT

s.send(b"\x06")	# ACK

s.close()
