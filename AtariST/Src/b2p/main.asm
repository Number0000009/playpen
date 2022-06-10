; bitmap 320x200x8bpp to Atari planar screen
; TODO: specify number of planes for faster output

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

; Set 320x200x4 bitplans mode
	move.w #0,-(sp)
	move.l #-1,-(sp)
	move.l #-1,-(sp)
	move.w #5,-(sp)
	trap #14
	add.l #12,sp

; Load palette
	move.l #palette,-(sp)
	move.w #6,-(sp)
	trap #14
	addq.l #6,sp

; Read vram logical address via XBIOS
	move.w #3,-(sp)
	trap #14
	addq.l #2,sp

	move.l d0,a1		; Screen pointer

	lea bitmap,a0

	move.l #320/16*200,d0
loop:
	lea c2p_tbl,a2

	rept 16
	moveq #0,d1
	move.b (a0)+,d1

	lsl.w #7,d1

	move.l 0(a2,d1),d2
	move.l 4(a2,d1),d3

	addq #8,a2

	or.l d2,(a1)
	or.l d3,4(a1)
	endr

	addq.l #8,a1

	dbra d0,loop

; ----------------------------------------

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

; TODO: restore system palette

; Exit
	clr.w -(sp)
	trap #1

previous_video_mode: dw 0

	align 4
palette:	incbin "logopouet.pal"
bitmap:		incbin "logopouet.raw"
	align 4
c2p_tbl:	incbin "table.bin"
