# fun with xmodem

## How to use
server:
sz -v -X --tcp-server /tmp/hello

client:
rz -v -X --tcp-client localhost:61236 /tmp/1

or client as in resv.py

## What it does

Receives one block of 128 bytes of data over XModem protocol.

## Protocol

```
Sender		Receiver
		"C"
packet1
		ACK
packet2
		NAK
repeat packet2
		ACK
packet3
.
.
.
		ACK
EOT
		ACK
------- END -------
```

## Packet format

(lengths are in bits)
```
Opcode[8] Num[8] (0xFF-Num)[8] Data[128] CRC[16]
```

Total 128 bytes of data + 2 bytes of CRC-16 + Opcode + Num + Num'
133

## Opcodes

```
SOH	1	Start Of Header
(STX	2	Start Of Header for 1K mode)
(ETX	3	End Of Transmission for 1K mode???)
EOT	4	End Of Transmission
(ENQ	5	idk)
ACK	6	Acknowledge
NAK	0x15	Not acknowledge
ETB	0x17	End of transmission Block
CAN	0x18	Cancel
(EOF	0x1A	idk)
```
