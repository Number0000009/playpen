; Enter SUPER mode
	clr.l -(sp)
	move.w #32,-(sp)
	trap #1
	addq.l #6,sp

; Mask interupts
;	move.w #$2700,sr

; Disable mouse
;	move.b #$12,$fffffc02.w

; Disable cursor
	move.w #0,-(sp)		; not needed
	move.w #0,-(sp)		; disable cursor
	move.w #21,-(sp)
	trap #14
	addq.l #6,sp

; Set 320x200x4 mode
	clr.b $ffff8260.w

; Read vram address (low byte is zero on the STE)
;	move.l $ff8200,d0	; ff8201 = high byte, ff8203 = mid byte
;	andi.l #$00ff00ff,d0
;	lsl.w #$8,d0

; Read vram logical address via XBIOS
	move.w #3,-(sp)
	trap #14
	addq.l #2,sp

	move.l d0,a1

; x = [16 bit plane 0][16 bit plane 1][16 bit plane 2][16 bit plane3]
;     fedcba9876543210

; x next word = x + 8
; y next = y + 0xa0

;	move.w #%1000000000000000,(a0)+
;	move.w #%0000000000000000,(a0)+
;	move.w #%0000000000000000,(a0)+
;	move.w #%0000000000000000,(a0)+

;	move.w #%1000000000000000,(a0)+
;	move.w #%0000000000000000,(a0)+
;	move.w #%0000000000000000,(a0)+
;	move.w #%0000000000000000,(a0)+

pos_x: equ 0
pos_y: equ 200/2

	move.l #pos_x,d4
	move.l #pos_y,d5

	move.l #319,d3
loop:
	move.l a1,a0

	move.l d4,d0
	move.l d5,d1

; y
; 160 = 2^7 + 32
	eor d2,d2
	rept 32
	add.l d1,d2
	endr

	lsl.l #7,d1

	add.l d2,d1
	add.l d1,a0

; x
; start_x + pos_x/2-th byte

	move d0,d2
	lsr.l #4,d2
	lsl.l #3,d2
; d2-th word

	add.l d2,a0

; ???-th bit
	divu #16,d0
	swap.w d0
	eor.l d1,d1
	move.b d0,d1
	move.l d1,d0

	move.w #%1000000000000000,d1
	lsr.l d0,d1

	or.w d1,(a0)

; Wait for a key
	move.w #7,-(sp)
	trap #1
	addq.l #2,sp

	addi.l #1,d4
	subi.w #1,d3
	bne loop

; Set medium resolution
	move.b #%01,$ffff8260.w

; Unmask interrupts
;	move.w #$2300,sr

; Enable cursor
;	move.w #0,-(sp)		; not needed
;	move.w #1,-(sp)		; enable cursor
;	move.w #21,-(sp)
;	trap #14
;	addq.l #6,sp

; Enable mouse
;	move.b #$8,$fffffc02.w

; Enter USER mode
	move.w #32,-(sp)
	trap #1
	addq.l #6,sp

; Exit
	clr.w -(sp)
	trap #1
