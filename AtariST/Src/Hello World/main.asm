; Prints 'Hello from Atari ST TOS!' and waits for any key pressed
; vasmm68k_mot -Ftos -I ../../Include/ main.asm -o main.tos

	include "GEMDOS.I"

	move.l	#string,-(sp)
	move.w	#c_conws,-(sp)
	trap	#1	; A-la int 0x21
	addq.l	#6,sp	; GemDos calls don't preserve stack
 	
; Wait for a key
	move.w	#c_conin,-(sp)
	trap	#1
	addq.l	#2,sp

; Exit
	clr.w	-(sp)	; p_term0
	trap	#1

string:	dc.b "Hello from Atari ST TOS!",$0d,$0a,$00
