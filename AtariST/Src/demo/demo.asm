; set tabstop=8

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
; d0 - destination address
; d4 - source address
; d5 - lines per block
; Outputs:
; None
; Corrupts:
; BLiTTER counters
update_bgnd	MACRO
		move.l d0,dst_addr
		move.l d4,src_addr
		move.w d5,lines_per_block
		move.b #%10000000,line_num	; run (BUSY)
		ENDM

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

; Setup BLiTTER
	move.w #$ffff,endmask1
	move.w #$ffff,endmask2
	move.w #$ffff,endmask3

	move.w #2,src_x_inc		; offset to the next word in bytes
	move.w #(9*2),src_y_inc		; offset from the last word to the first word in bytes

	move.w #2,dst_x_inc		; offset to the next word in bytes
	move.w #(9*2),dst_y_inc		; offset from the last word to the first words in bytes

	move.w #72,words_per_line_count

	move.b #2,hop			; source
	move.b #3,op			; source
	move.b #0,skew

; -------------

	moveq #0,d2			; back buffer or front buffer
	moveq #0,d1			; scrolling up or down

	move.l #bitmap,d4

; setup Lissajous table
	lea lissajous_table,a6

again:
; setup sine table
	lea sine_tbl,a0

	moveq #66,d6			; when to reset sine_tbl pointer

	bchg #0,d1

main_loop:
; Mask interrupts
;	move.w #$2700,sr

	move.l #200,d5			; lines per block

	tas line_num
	nop
	bmi blitter_busy

	bchg #0,d2
	beq swap_addr

	move.l screen2_ptr,d0
	bra.s swap_exit
swap_addr:
	move.l screen1_ptr,d0
swap_exit:

	add.l #(4*2),d0

; get_sine
	move.w (a0)+,d3

	tst d1
	beq scroll_down
scroll_up:
	add.l d3,d4
	bra.s scroll_direction_set
scroll_down:
	sub.l d3,d4
scroll_direction_set:

;	update_bgnd

	swap_buffers

; --- draw sides

; --- prepare sides pointers
	move.l screen1_ptr,a1
	move.l screen2_ptr,a2
	lea (320/2-8)+(199*160)(a1),a4
	lea (320/2-8)+(199*160)(a2),a5
	lea bitmap,a3
	lea (320/2-8)(a3),a3
; ---

; Left side
	moveq #0,d5
	move.w side_y,d5

	cmp.w #200*160,d5
	beq.s sides_finished

	add.w #160,side_y
	add.l d5,a1
	add.l d5,a2
	add.l d5,a3
	move.l (a3),(a1)+
	move.l (a3)+,(a2)+
	move.l (a3),(a1)+
	move.l (a3),(a2)+

; Right side
	lea -4(a3),a3

	sub.l d5,a4
	sub.l d5,a5
	move.l (a3),(a4)+
	move.l (a3)+,(a5)+
	move.l (a3),(a4)+
	move.l (a3),(a5)+

sides_finished:
; ---
; Lissajous

; corrupts d0, d1, d2, a0, a5

; save d0, d1, d2
	lea stack,a5
	movem.l d0-d2,-(a5)

	move.l screen1_ptr,a1
	move.l screen2_ptr,a2

	moveq #0,d0
	moveq #0,d1

	move.b (a6),d0		; x
	add.l #1,a6
	move.b (a6),d1		; y
	add.l #1,a6

loop:
; y*160 = y * 2^7 + 32*y => y<<7 + y<<5
	lsl.w #5,d1
	add.w d1,a1
	lsl.w #2,d1
	add.w d1,a1

; x
	move d0,d2
; d2/16 * 8 and drop last 3 bits

	lsr.w #1,d2
	andi.b #$f8,d2

; d2-th word

	add.l d2,a1

; x-th bit

; calculate the remainder
; x % 2^n == x & (2^n - 1) => x % 2^4 == x & (2^4 - 1) => x % 16 = x & 15

	andi.b #15,d0

	move.w #%1000000000000000,d1
	lsr.w d0,d1
	or.w d1,(a1)

	movem.l (a5)+,d0-d2
; ---

	wait_for_vbl

	tst d6
	beq again
	sub.l #1,d6
	beq again

blitter_busy:
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

oldvbl:			ds.l 1

music:			incbin "assets\music.snd"

	SECTION BSS
_alignment:		ds.b $ff
_screen1:		ds.b 32000
_screen2:		ds.b 32000


	align 2
screen1_ptr:		ds.l 1
screen2_ptr:		ds.l 1
previous_video_ptr:	ds.l 1
previous_palette:	ds.w 16
previous_video_mode:	ds.b 1

	align 2
			ds.l 4
stack:			; grows up

	SECTION DATA
bitmap:			incbin "assets\top.raw"
			incbin "assets\bottom.raw"
palette:		incbin "assets\palette.pal"

lissajous_table:	incbin "assets\table.bin"

sine_tbl:
		dw 0
		dw 0
		dw 0
		dw 0
		dw 160
		dw 160
		dw 160
		dw 160
		dw 320
		dw 320
		dw 320
		dw 320
		dw 320
		dw 480
		dw 480
		dw 480
		dw 480
		dw 480
		dw 640
		dw 640
		dw 640
		dw 640
		dw 640
		dw 640
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 800
		dw 640
		dw 640
		dw 640
		dw 640
		dw 640
		dw 640
		dw 480
		dw 480
		dw 480
		dw 480
		dw 480
		dw 320
		dw 320
		dw 320
		dw 320
		dw 160
		dw 160
		dw 160
		dw 160
		dw 0
		dw 0
		dw 0
		dw 0

side_y:		dw 0
