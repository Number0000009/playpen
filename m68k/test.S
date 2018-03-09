	.text

	.globl _start

.mri	1

_start:
	long $15C0DE68
	nop

;	movea.l #stack,sp
	movea.l #msg,a0
	move.l a0,d0
	bsrs putx
	bsrs puts
	jmp (a6)

; --- Utils ---
PUTCH	equ $00F03000

; Input:	a0 - asciz
puts:
	movem.l a0-a1,-(sp)
	movea.l #PUTCH,a1
puts_cont:
	cmpi.b #0,(a0)
	beq puts_exit
	move.b (a0)+,(a1)
	bras puts_cont
puts_exit:
	movem.l (sp)+,a0-a1
	rts

; Input:	d0 - number
putx:
	movem.l d0-d2,-(sp)
	rol.w #8,d0
	swap d0
	rol.w #8,d0
	movea.l #PUTCH,a1
	move.b #'$',(a1)
	moveq #3,d1
	move.b d0,d2
putx_cont:
	lsr.b #4,d2
	addi.b #'0',d2
	cmpi.b #$a+'0',d2
	blo putx_l1
	addi.b #('a'-10-'0'),d2
putx_l1:
	move.b d2,(a1)
	move.b d0,d2
	andi.b #$0F,d2
	addi.b #'0',d2
	cmpi.b #$a+'0',d2
	blo putx_l2
	addi.b #('a'-10-'0'),d2
putx_l2:
	move.b d2,(a1)
	move.l d0,d2
	ror.l #8,d2
	move.l d2,d0
	dbra d1,putx_cont
	movem.l (sp)+,d0-d2
	rts

stack_top:
	space $ff
stack:
msg:	asciz "\nHenlo\n"
