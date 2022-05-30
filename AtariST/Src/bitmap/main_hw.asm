	SECTION TEXT

	move.l #_screen,d0
	clr.b d0
	move.l d0,screen_ptr

	lea bitmap,a0
	movea.l screen_ptr,a1

	move.w #(32000/4),d0
loop:
	move.l (a0)+,(a1)+
	dbra d0,loop
	
; Disable cursor
	move.w #0,-(sp)		; not needed
	move.w #0,-(sp)		; disable cursor
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
bitmap:			incbin "dw.raw"
palette:		incbin "dw.pal"
