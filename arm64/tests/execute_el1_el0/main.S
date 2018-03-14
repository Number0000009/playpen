/*
 * [Redacted] bare-metal test for an EL0 [Redacted].
 */

.cpu cortex-a53+fp+simd

#include <platform_hardware.h>
#include <utils.h>

#include "defs.h"


.text
.align 2

	.global _start

_start:
	mrs	x0, mpidr_el1
	tst	x0, #0x0f	// not b0000 (not a primary CPU) - goto stop
	b.eq	primary_cpu_continue

secondary_stop:
	wfe
	b	secondary_stop

primary_cpu_continue:
	adr	x0, banner
	bl	writeln

	bl	write_current_el

	adr	x0, initialize
	bl	writeln

	bl	init

	adr	x0, redacted_testcases
	bl	writeln

// Copy code into a page
	ldr	x0, =(LOOPHOLE_CODE_SRC_VA - 16)
	ldr	x1, =(loophole - 16)
	mov	x2, #((end_loophole - loophole) >> 4)

copy_redacted_code:
	ldp	x3, x4, [x1, #16]!
	stp	x3, x4, [x0, #16]!
	subs	x2, x2, #1
	b.ne	copy_redacted_code

	dsb	nsh
	isb

// --- Enter into a [Redacted] ---

	ldr	x0, =LOOPHOLE_CODE_SRC_VA
	msr	elr_el1, x0

	ldr	x0, =(continue)
	translate_el1_s1 x0
	msr	vbar_el1, x0

// Enter [Redacted]
	eret

// --- [Redacted] will exit via abort to "continue" ---

// RES[10 - 0] bits of VBAR_EL1 - D7-2125
.balign 0x400

continue:
// continue in an EL1 [redacted]
	nop
	nop
	nop

// finish
	adr	x0, done
	b	stop_machine_ok
// end ------------------------------------------------------------------------


// Underlying machinery stuff

// This code will be executed in an EL0 [redacted]
.align 4				// Align to 2 x words for LDP
loophole:
	adr	x0, loophole_msg

// Q: Why couldn't we just ldr x1, =PL011_UART0_VA or something?
// A: Because literal pool stuff would still be calculated for EL1 [Redacted]
	mov	x1, #0xffffff8000000000
	movk	x1, 0x109, lsl 16
// UART0 MMIO virtual address in an EL0 [Redacted] = 0xFFFFFF8001090000

loophole_writeln_txfe:
	ldrb	w2, [x1, #PL011_UARTFR]
	ands	x2, x2, #UART_TXFE
	b.eq	loophole_writeln_txfe

	ldrb	w2, [x0], #1
	cbz	w2, loophole_writeln_end

	strb	w2, [x1]
	b	loophole_writeln_txfe

loophole_writeln_end:
	eret

loophole_msg:
	.asciz "Hello from EL0!!\r\n"

.align 4
end_loophole:
// -------------------------------------------------

// input x0 - message addr
	.global stop_machine_fail
stop_machine_fail:
	mov	w3, #0x55
	b	stop_machine

	.global stop_machine_ok
stop_machine_ok:
	mov	w3, #0xaa
stop_machine:
	bl	writeln
	mov	x0, #FVP_SYSREG
	strb	w3, [x0, #FVP_SYSREG_SYSLEDS]
	dsb	nsh
stop_again:
	wfe
	b	stop_again


	.global check_esr_ec
check_esr_ec:
	ret	// no special ESR_EL1.EC to check against


banner:
	.ascii " ____________________\r\n"
	.ascii "< EL0[Redacted] test >\r\n"
	.ascii " --------------------\r\n"
	.ascii "        \\   ^__^\r\n"
	.ascii "         \\  (oo)\\_______\r\n"
	.ascii "            (__)\\       )\\/\\\r\n"
	.ascii "                \|\|----w \|\r\n"
	.asciz "                \|\|     \|\|\r\n"

initialize:
	.asciz "Initialising...\r\n"

redacted_testcases:
	.asciz "\nredacted test cases:\r\nExecuting in a EL0 [Redacted]\r\n"

done:
	.asciz "All done.\r\n"
