/*
 * Reset-time initialisation routines for baremetal tests.
 */

#include <arch_defs.h>

	.global init
init:
	mrs	x0, scr_el3
	orr	x0, x0, #(1 << 10)		// SCR_EL3.RW
	orr	x0, x0, #(1 << 0)		// SCR_EL3.NS
	msr	scr_el3, x0

	mrs	x0, hcr_el2
	orr	x0, x0, #(1 << 31)		// HCR_EL2.RW
	msr	hcr_el2, x0

	mov	x28, x30
	bl	go_to_el1

	adr	x0, vectors
	msr	vbar_el1, x0

	bl	write_current_el
	bl	setup_mmu

	ret	x28

	.global go_to_el1
go_to_el1:
	adr	x0, goto_el1
	mov	x27, x30
	bl	writeln
	mov	x0, #EL1t
	msr	spsr_el3, x0
	adr	x0, go_in_el1
	msr	elr_el3, x0
	eret
go_in_el1:
	ret	x27

	.global write_current_el
write_current_el:
	adr	x0, current
	mov	x27, x30
	bl	writeln
	mrs	x1, CurrentEL
	adr	x0, el
	ubfm	w1, w1, #2, #31
	add	w1, w1, #'0'
	strb	w1, [x0]
	bl	writeln
	ret	x27

current:
	.asciz "Currently in EL"
el:
	.asciz "?\r\n"
goto_el1:
	.asciz "Going to EL1...\r\n"
