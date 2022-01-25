; Get video mode
	move.w #4,-(sp)
	trap #14
	addq.l #2,sp

; Store it for later
	move.w d0,previous_video_mode

; Disable cursor
	move.w #0,-(sp)		; not needed
	move.w #0,-(sp)		; disable cursor
	move.w #21,-(sp)
	trap #14
	addq.l #6,sp

; Set 320x240x4 bitplans mode
	move.w #0,-(sp)
	move.l #-1,-(sp)
	move.l #-1,-(sp)
	move.w #5,-(sp)
	trap #14
	add.l #12,sp

; Read vram logical address via XBIOS
	move.w #3,-(sp)
	trap #14
	addq.l #2,sp

	move.l d0,a1		; Screen pointer

; x = [16 bit plane 0][16 bit plane 1][16 bit plane 2][16 bit plane3]
;     fedcba9876543210

; x next word = x + 8
; y next = y + 0xa0

pos_x	equ 0
pos_y	equ 0

	move.w #pos_y,d5	; d5 -> d1 after tests
	move.w #200-1,d7	; Remove after tests
loop1:
	move.w #pos_x,d4	; d4 -> d0 after tests
	move.w #320-1,d6	; Remove after tests
loop:
	move.l a1,a0		; Screen pointer

	move.w d4,d0		; Remove after tests
	move.w d5,d1		; Remove after tests

; y*160 = y * 2^7 + 32*y => y<<7 + y<<5
	lsl.w #5,d1
	add.w d1,a0
	lsl.w #2,d1
	add.w d1,a0

; x
	move d0,d2
; d2/16 * 8 and drop last 3 bits

	lsr.w #1,d2
	andi.b #$f8,d2

; d2-th word

	add.l d2,a0

; x-th bit

; calculate the remainder
; x % 2^n == x & (2^n - 1) => x % 2^4 == x & (2^4 - 1) => x % 16 = x & 15

	andi.b #15,d0

	move.w #%1000000000000000,d1
	lsr.w d0,d1
	or.w d1,(a0)

	addq.w #1,d4	; Remove after tests
	dbeq d6,loop	; Ditto

	addi.w #1,d5	; Ditto
	dbeq d7,loop1	; Ditto

; Wait for a key
	move.w #7,-(sp)
	trap #1
	addq.l #2,sp

; Restore resolution
	move.w previous_video_mode,-(sp)
	move.l #-1,-(sp)
	move.l #-1,-(sp)
	move.w #5,-(sp)
	trap #14
	add.l #12,sp

; Enable cursor
;	move.w #0,-(sp)		; not needed
;	move.w #1,-(sp)		; enable cursor
;	move.w #21,-(sp)
;	trap #14
;	addq.l #6,sp

; Enable mouse
;	move.b #$8,$fffffc02.w

; Exit
	clr.w -(sp)
	trap #1

previous_video_mode: dw 0
