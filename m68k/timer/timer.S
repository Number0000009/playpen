	.text

	.globl _start

.mri	1

	; --- Vectors ---
	; Boot vectors (0,1)
	long	$00000ffe	; Boot SP
	long	_start		; Boot PC

	; System exceptions (2-15)
	long	bomb		; Bus error
	long	bomb		; Address error
	long	bomb		; Illegal
	long	bomb		; Div 0 (int)
	long	bomb		; CHK/CHK2
	long	bomb		; TRAPcc/TRAPV
	long	bombp		; Privilege violation
	long	bomb		; Trace trap
	long	bomb		; A line
	long	bomb		; F line
	long	bomb		; unused
	long	bomb		; unused (no coprocessor on a 68000)
	long	bomb		; unused (format on 68010+)
	long	bomb		; uninitialized interrupt vector

	; Reserved (16-23)
	long	bomb		; spare 16
	long	bomb		; spare 17
	long	bomb		; spare 18
	long	bomb		; spare 19
	long	bomb		; spare 20
	long	bomb		; spare 21
	long	bomb		; spare 22
	long	bomb		; spare 23

	; Spurious IRQ (24)
	long	bomb		; spare 24

	; Autovector IRQ (25-31)
	long	ignore		; Level 1
	long	ignore		; Level 2
	long	ignore		; Level 3
	long	ignore		; Level 4
	long	ignore		; Level 5
	long	timer		; Level 6
	long	mmu			; Level 7

	; Traps (32-47)
	long	bomb		; Trap 0
	long 	bomb		; Trap 1
	long	bomb		; Trap 2
	long	bomb		; Trap 3
	long	bomb		; Trap 4
	long	bomb		; Trap 5
	long	bomb		; Trap 6
	long	bomb		; Trap 7
	long	bomb		; Trap 8
	long 	bomb		; Trap 9
	long	bomb		; Trap 10
	long	bomb		; Trap 11
	long	bomb		; Trap 12
	long	bomb		; Trap 13
	long	bomb		; Trap 14
	long	bomb		; Trap 15

	; FPU 48-55(unused)
	long	bomb		; BSUC
	long	bomb		; Inexact
	long	bomb		; Div0
	long	bomb		; Underflow
	long	bomb		; Operand error
	long	bomb		; Overflow
	long	bomb		; NaN
	long	bomb		; Unimplemented data (68040+)

	; MMU 56-58 (unused - not on 68000)
	long	bomb		; Configuration error
	long	bomb		; Illegal operation
	long	bomb		; Access level violation

	; Reserved (59-63)
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb

	; User vectors 64-255
	long	bomb		; 64
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 72
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 80
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 88
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 96
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 104
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 112
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 120
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 128
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 136
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 144
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 152
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 160
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 168
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 176
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 184
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 192
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 200
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 208
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 216
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 224
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 232
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 240
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb		; 248
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb
	long	bomb

	; End of vector table (Address $0400)


_start:
; unmask all IRQs
	and.w #$F8FF,sr

; windup timer
TIMERIO	equ $00F04000
	move.b #$30,TIMERIO
	bras .

; --- Handlers ---
timer:
	cmp.w TIMERIO,a0	; ACK
	movea.l #timer_msg,a0
	bsrs puts
	rte

mmu:
	movea.l #mmu_msg,a0
	bsrs puts
	rte

bomb:
bombp:
	movea.l #bomb_msg,a0
	bsrs puts
	rte

ignore:
	movea.l #ignore_msg,a0
	bsrs puts
	rte

; --- Utils ---
PUTCH	equ $00F03000

; Input:	a0 - asciz
puts:
	movem.l a0-a1,-(sp)
	movea.l #PUTCH,a1
puts_cont:
	cmpi.b #0,(a0)
	beqs puts_exit
	move.b (a0)+,(a1)
	bras puts_cont
puts_exit:
	movem.l (sp)+,a0-a1
	rts

timer_msg:
	asciz "\nTimer IRQ6\n"

mmu_msg:
	asciz "\nMMU IRQ7\n"

bomb_msg:
	asciz "\nUnhandled IRQ\n"

ignore_msg:
	asciz "\nIgnored IRQ\n"
