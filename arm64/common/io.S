/*
 * Simple debug I/O routines:
 *  putch
 *  writeln
 *  phex64
 */

#include <platform_hardware.h>


.macro putch_macro, putreg_smallname, tempreg, tempreg_smallname
99:	mov	\tempreg, #PL011_UART0		// Grim, but saves a reg!
	ldrb	\tempreg_smallname, [\tempreg, #PL011_UARTFR]
	ands	\tempreg, \tempreg, #(1<<7)	// TXFE - Transmit FIFO empty.
	b.eq	99b
	mov	\tempreg, #PL011_UART0
	strb	\putreg_smallname, [\tempreg]
.endm

// input x0 - asciz string address
// Corrupts x0-x2
	.global writeln
writeln:
	mov	x2, x0
1:	ldrb	w0, [x2], #1
	cbz	w0, 2f
	putch_macro w0, x1, w1
	b	1b
2:	ret


// Input x0:  Character to output
// Corrupts x0,x1
	.global putch
putch:	putch_macro w0, x1, w1
	ret


// Input x0:  64-bit integer to output
// Corrupts x0-x3
	.global phex64
phex64:
	mov	x1, #64/4
	orr	x2, xzr, x0, ror #60

1:	and	x0, x2, #0xf
	cmp	x0, #0xa

	add	x3, x0, #'0'
	blo	2f
	add	x0, x0, #'a' - 10 - '0'

2:	putch_macro w0, x3, w3
	orr	x2, xzr, x2, ror #60
	sub	x1, x1, #1
	cbnz	x1, 1b
	ret
