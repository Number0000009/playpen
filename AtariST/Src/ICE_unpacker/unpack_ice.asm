; Unpack SNDH packed by ICE!

section text

	lea packed_data,a0
	lea unpacked_data,a1

	jsr ice_decrunch
; d0 = unpacked length

	move.l d0,d1

; save file
; create
	move.w #0,-(sp)
	move.l #filename,-(sp)
	move.w #$3c,-(sp)
	trap #1
	addq.l #8,sp
	tst.w d0
	bmi error

	move d0,d2				; preserve handler

; write
	move.l #unpacked_data,-(sp)
	move.l d1,-(sp)			; size
	move.w d2,-(sp)			; handle
	move.w #$40,-(sp)
	trap #1
	add.l #12,sp
	tst.l d0
	bmi error

; close
	move.w d2,-(sp)			; handle
	move.w #$3e,-(sp)
	trap #1
	addq.l #4,sp
	tst.w d0
	bmi error

	clr.w -(sp)
	trap #1

error:
	bra.s error

	include "ICE_UNPA.S"

packed_data:	incbin "1.sndh"

filename:	dc.b "1.snd",0
unpacked_data: ds.l 0xffff
