halftone:		equ $ff8a00	; 16 halftone RAM registers

src_x_inc:		equ $ff8a20	; source x increment
src_y_inc:		equ $ff8a22	; source y increment
src_addr:		equ $ff8a24	; source address

endmask1:		equ $ff8a28	; left end mask		
endmask2:		equ $ff8a2a	; middle mask
endmask3:		equ $ff8a2c	; right end mask

dst_x_inc:		equ $ff8a2e	; destination x increment
dst_y_inc:		equ $ff8a30	; destination y increment
dst_addr:		equ $ff8a32	; destination address

words_per_line_count:	equ $ff8a36	; x count
lines_per_block:	equ $ff8a38	; y count

hop:			equ $ff8a3a	; halftone operation
op:			equ $ff8a3b	; logical operation
line_num:		equ $ff8a3c
skew:			equ $ff8a3d	; source shift

sprite_x:		equ 0		; sprite pos in pixels
					; this has to be recalculated in screen
					; word number and endmask (where 0 is $ffff,
					; 1 is $7fff and so forth) and skew (where 0 is 0,
					; 1 is 1, and so-forth)
sprite_y:		equ 131		; sprite pos in pixels

	SECTION TEXT

	move.l #_screen,d0
	clr.b d0
	move.l d0,screen_ptr

	lea bitmap,a0
	movea.l screen_ptr,a1

	move.w #(32000/4)-2,d0
loop:
	move.l (a0)+,(a1)+
	dbra d0,loop

; Disable cursor
	clr.l -(sp)		; disable cursor
	move.w #21,-(sp)
	trap #14
	addq.l #6,sp

; Enter SUPER mode
	clr.l -(sp)
	move.w #32,-(sp)
	trap #1
	addq.l #6,sp

; Mask interrupts
;	move.w #$2700,sr

; Get video mode and store it for lated
	move.b $ff8260,previous_video_mode

; Read vram address (low byte is zero on the STE) and store it for later
	move.l $ff8200,previous_video_ptr

; Save palette
	move.l #$ff8240,a0
	lea previous_palette,a1
	rept 7			; 16/2 - 1
	move.l (a0)+,(a1)+
	endr

; wvbl
	move.w #$25,-(sp)
	trap #14
	addq.l #2,sp

; Set 320x200x4 bitplanes mode
	clr.b $ff8260

; wvbl
	move.w #$25,-(sp)
	trap #14
	addq.l #2,sp

; Load palette
	lea palette,a0
	move.l #$ff8240,a1
	rept 16
	move.w (a0)+,(a1)+
	endr

	move.l screen_ptr,d0
	lsr.w #8,d0
	move.l d0,$ff8200

; BLiTTER

	move.w #320-16,d5
	move.w #sprite_x,d3
	move.w #sprite_y,d6

loop1:
	move.l screen_ptr,d0
	move.l d0,src_addr

;	addi.l #(sprite_y*160)+0,d0
	move.w d6,d7
	mulu #160,d7
	add.l d7,d0
				; 58
;	move.w d6,d7
;	lsl.w #7,d7
;	add.l d7,d0
;	move.w d6,d7
;	lsl.w #5,d7
;	add.l d7,d0
				; 60

; calculate screen word
	move.w d3,d2
	lsr.w #1,d2
	andi.b #$f8,d2
	add.w d2,d0

	move.l d0,dst_addr

	move.w #4,words_per_line_count
	move.w #10,lines_per_block

	move.w #2,src_x_inc
	move.w #320/2-6,src_y_inc

	move.w #2,dst_x_inc
	move.w #320/2-6,dst_y_inc

	move.w d3,d4
	andi.w #15,d4
	move.w #$ffff,d0
	lsr.w d4,d0
	move.w d0,endmask1
	move.w d0,endmask2
	move.w d0,endmask3

	move.b #2,hop			; source
	move.b #3,op

	move.b d4,skew

	move.b #%11000000,line_num	; run (BUSY | HOG)

; if d3 is not aligned to screen word blit second half
	move.w d3,d0

	addq.w #1,d3

	andi.w #15,d0
	beq skip

	move.l screen_ptr,d0
	move.l d0,src_addr

; next screen word
;	addi.l #(sprite_y*160)+8,d0

	add.l d7,d0
	addq #8,d0
				; 12

	add.l d2,d0
	move.l d0,dst_addr

	move.w #4,words_per_line_count
	move.w #10,lines_per_block

	move.w #2,src_x_inc
	move.w #320/2-6,src_y_inc

	move.w #2,dst_x_inc
	move.w #320/2-6,dst_y_inc

	move.w d3,d2
	subi.w #1,d2
	andi.w #15,d2

	addi.w #1,d2

	move.b #17,d0
	sub.b d2,d0
	move.b d0,d2

	move.w #$ffff,d0
	lsl.w d2,d0

	move.w d0,endmask1
	move.w d0,endmask2
	move.w d0,endmask3

	move.b #2,hop			; source
	move.b #3,op

	moveq #0,d0
	sub.b d2,d0
	move.b d0,skew

	move.b #%11000000,line_num	; run (BUSY | HOG)

skip:

; wvbl
	move.w #$25,-(sp)
	trap #14
	addq.l #2,sp

	dbra d5,loop1

; Ummask interupts
;	move.w #$2300,sr

; Wait for a key
	move.w #7,-(sp)
	trap #1
	addq.l #2,sp

; wvbl
	move.w #$25,-(sp)
	trap #14
	addq.l #2,sp

; Restore resolution
	move.b previous_video_mode,$ff8260

; wvbl
	move.w #$25,-(sp)
	trap #14
	addq.l #2,sp

; Restore palette
	lea previous_palette,a0
	move.l #$ff8240,a1
	rept 7			; 16/2 - 1
	move.l (a0)+,(a1)+
	endr

; Restore vram pointer
	move.l previous_video_ptr,$ff8200

; Enter USER mode
	move.w #32,-(sp)
	trap #1
	addq.l #6,sp

; Exit
	clr.w -(sp)
	trap #1

	SECTION BSS
_alignment:		ds.b $ff
_screen:		ds.b 32000

	align 2
screen_ptr:		ds.l 1
previous_video_ptr:	ds.l 1
previous_palette:	ds.w 16
previous_video_mode:	ds.b 1


	SECTION DATA
bitmap:			incbin "dw1.raw"
palette:		incbin "dw.pal"
