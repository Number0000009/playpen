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


; Inputs:
; d0 = screen_ptr
; Outputs:
; None
; Corrupts:
; d0
swap_buffers	MACRO
; Swap screen
		lsr.w	#8,d0
		move.l	d0,$ff8200
		ENDM

; Inputs:
; None
; Outputs:
; None
; Corrupts:
; d0
wait_for_vbl	MACRO
; wait for VBL

; Ummask interupts
;		move.w	#$2300,sr

		move.w	#0,$466
\@
		tst.w $466.w
		beq.s	\@
		move.w #0,$466

; Mask interrupts
;		move.w	#$2700,sr

		ENDM

; -----------------------------------------------------------------------------

	SECTION TEXT

; TODO: wtf is this memory mumbo-jumbo?
	move.l	4(sp),a5			; address to basepage
	move.l	$0c(a5),d0		; length of text segment
	add.l	$14(a5),d0		; length of data segment
	add.l	$1c(a5),d0		; length of bss segment
	add.l	#$1000,d0		; length of stackpointer
	add.l	#$100,d0		; length of basepage
	move.l	a5,d1			; address to basepage
	add.l	d0,d1			; end of program
	and.l	#-2,d1			; make address even
	move.l	d1,sp			; new stackspace

	move.l	d0,-(sp)
	move.l	a5,-(sp)
	move.w	d0,-(sp)
	move.w	#$4a,-(sp)		; mshrink
	trap	#1
	lea	12(sp),sp

	move.l	#_screen1,d0
	clr.b	d0
	move.l	d0,screen1_ptr

	move.l	#_screen2,d0
	clr.b	d0
	move.l	d0,screen2_ptr

; Disable cursor
	move.w	#0,-(sp)		; not needed
	move.w	#0,-(sp)		; disable cursor
	move.w	#21,-(sp)
	trap	#14
	addq.l	#6,sp

; Enter SUPER mode
	clr.l	-(sp)
	move.w	#32,-(sp)
	trap	#1
	addq.l	#6,sp

	bsr	music			; init music

; Mask interrupts
	move.w	#$2700,sr

;	move.l	$70.w,oldvbl		; store old VBL
	move.l	#vbl,$70.w		; steal VBL

; Unmask interrupts
	move.w	#$2300,sr

; Get video mode and store it for lated
	move.b	$ff8260,previous_video_mode

; Read vram address (low byte is zero on the STE) and store it for later
	move.l	$ff8200,previous_video_ptr

; Save palette
	move.l	#$ff8240,a0
	lea	previous_palette,a1
	rept	7			; 16/2 - 1
	move.l	(a0)+,(a1)+
	endr

	wait_for_vbl

; Set 320x200x4 bitplanes mode
	clr.b	$ff8260

	wait_for_vbl

; Load palette
	lea palette,a0
	move.l #$ff8240,a1
	rept 16
	move.w (a0)+,(a1)+
	endr

	move.l screen1_ptr,d0
	lsr.w #8,d0
	move.l d0,$ff8200

; -- main loop
again:

	move.l #200,d5			; lines per block
	move.l #200,d6

	lea bitmap,a0
	move.l a0,d4

	moveq #0,d2
	moveq #0,d1

main_loop:
; Mask interrupts
;	move.w #$2700,sr

	bchg #0,d2
	beq swap_addr

	move.l screen1_ptr,d0
	bra.s swap_exit
swap_addr:
	move.l screen2_ptr,d0
swap_exit:
	add.l #(4*2),d0

	tst d6
	beq again
	sub.l #1,d6
	beq again

;	bchg #0,d1
;	beq skip_update_bgnd

	bsr update_bgnd

;skip_update_bgnd:

	swap_buffers
	wait_for_vbl

; check space key
	cmp.b #$39,$fffc02
	bne main_loop

; Exit
	bsr music+4			; release music

; Restore resolution
	move.b previous_video_mode,$ff8260

	wait_for_vbl

; Restore palette
	lea previous_palette,a0
	move.l #$ff8240,a1
	rept 7				; 16/2 - 1
	move.l (a0)+,(a1)+
	endr

; Restore vram pointer
	move.l previous_video_ptr,$ff8200

; Unmask interrupts
	move.w #$2300,sr

; Enter USER mode
	move.w #32,-(sp)
	trap #1
	addq.l #6,sp

; Exit
	clr.w -(sp)
	trap #1

; -----------------------------------------------------------------------------
vbl:
; Unmask interrupts
	move.w #$2300,sr

	bsr	music+8			; call music
;	move.l oldvbl(pc),-(sp)		; go to old vector
	addq.w #1,$466.w

; Mask interrupts
;	move.w #$2700,sr

	rte

oldvbl:	ds.l 1


update_bgnd:
	move.l d0,dst_addr

	move.l d4,src_addr

	move.w #72,words_per_line_count

	addi.l #160,d4			; source goes down 1 line

	move.w d5,lines_per_block

	move.w #2,src_x_inc		; offset to the next word in bytes
	move.w #9*2,src_y_inc		; offset from the last word to the first word in bytes

	move.w #2,dst_x_inc		; offset to the next word in bytes
	move.w #9*2,dst_y_inc		; offset from the last word to the first words in bytes

	move.w #$ffff,endmask1
	move.w #$ffff,endmask2
	move.w #$ffff,endmask3

	move.b #2,hop			; source
	move.b #3,op			; source
	move.b #0,skew

	move.b #%11000000,line_num	; run (BUSY | HOG)

	rts

music:			incbin "assets\1.snd"

	SECTION BSS
_alignment:	ds.b $ff
_screen1:		ds.b 32000
_screen2:		ds.b 32000


	align 2
screen1_ptr:		ds.l 1
screen2_ptr:		ds.l 1
previous_video_ptr:	ds.l 1
previous_palette:	ds.w 16
previous_video_mode:	ds.b 1


	SECTION DATA
bitmap:			incbin "assets\dw.raw"
				incbin "assets\sm.raw"
palette:		incbin "assets\dw.pal"

sin_tbl:
; 200
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 1
				db 2
				db 2
				db 2
				db 2
				db 2
				db 2
				db 2
				db 2
				db 2
				db 2
				db 2
				db 3
				db 3
				db 3
				db 3
				db 3
				db 3
				db 3
				db 3
				db 3
				db 4
				db 4
				db 4
				db 4
				db 4
				db 4
				db 4
				db 4
				db 4
				db 4
				db 5
				db 5
				db 5
				db 5
				db 5
				db 5
				db 5
				db 5
				db 5
				db 5
				db 5
				db 5
				db 5
				db 5
				db 0
