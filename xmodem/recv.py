#!/usr/bin/env python3

import sys
import socket

class connect:

	SOH = 1		# Start Of Header
	EOT = 4		# End Of Transmission
	ACK = 6		# Acknowledge
	NAK = 0x15	# Not acknowledge
	ETB = 0x17	# End of transmission Block
	CAN = 0x18	# Cancel
	REQ = b"C"
	BLOCK_SIZE = 128
	HEADER_SIZE = 3
	FOOTER_SIZE = 2

	def __init__(self, IP, PORT):
		self.IP = IP
		self.PORT = int(PORT)

		try:
			self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			self.s.connect((self.IP, self.PORT))
		except socket.error as ex:
			print("Fatal error")
			print(ex)


	def __del__(self):
		self.s.close()


	def req(self):
		print("REQ")
		self.s.send(self.REQ)


	def ack(self):
		print("ACK")
		self.s.send(self.ACK.to_bytes(1, "big"))


	def nak(self):
		print("NAK")
		self.s.send(self.NAK.to_bytes(1, "big"))


	def crc(self, data):
		crc = 0

		for i in data[self.HEADER_SIZE:-self.FOOTER_SIZE]:

			crc = crc ^ (i << 8)

			for j in range(8):
				if crc & 0x8000:
					crc = crc << 1 ^ 0x1021
				else:
					crc = crc << 1

		return crc & 0xffff


	def read(self):
		print("read")

		self.req()

		try:
			while True:
				# SOH 01 255-01 data[128] crc-16[2]
				data = self.s.recv(self.BLOCK_SIZE + self.HEADER_SIZE + self.FOOTER_SIZE)

				if data == self.EOT.to_bytes(1, "big"):
					print("EOT")
					self.ack()
					return data_buf

				crc = self.crc(data)
				if crc.to_bytes(2, "big") == data[-self.FOOTER_SIZE:]:
					self.ack()
				else:
					print("crc mismatch")
					self.nak()

				data_buf = data

		except socket.error as ex:
			print("Fatal error")
			print(ex)


if __name__ == "__main__":

	if len(sys.argv) < 2:
		print("Usage: recv.py PORT")
		exit(1)

	IP = "127.0.0.1"
	PORT = sys.argv[1]

	c = connect(IP, PORT)
	if c is None:
		print("Couldn't connect")
		exit(1)

	with open("xmodem_rcv.bin", "wb") as file:
		data = c.read()
		file.write(data[c.HEADER_SIZE:-c.FOOTER_SIZE])
		file.close()

