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

	move.w #200-1,d1
loop1:
	move.w #320/16-1,d0

; the idea is to have table indexed by pixel number
; instead of colour numeber,
; tbl[pix][colour]
; per each pixel 16 colours per 8 bytes = 128 bytes per pixel
	lea c2p_tbl,a2

	move.l a2,a3			; pixel 0
	move.l a3,a4
	move.l a4,a5

	add.l #128,a3			; pixel 1
	add.l #128+128,a4		; pixel 2
	add.l #128+128+128,a5		; pixel 3
loop:
; Planes 0, 1
	move.b (a0)+,d2
	move.l (a2,d2),d3	; plane 0, 1
	move.l 4(a2,d2),d4	; plane 2, 3

	move.b (a0)+,d2
	or.l (a3,d2),d3
	or.l 4(a3,d2),d4

	move.b (a0)+,d2
	or.l (a4,d2),d3
	or.l 4(a4,d2),d4

	move.b (a0)+,d2
	or.l (a5,d2),d3
	or.l 4(a5,d2),d4

	add.l #128+128+128+128,a2	; pixel 4
	add.l #128+128+128+128,a3	; pixel 5
	add.l #128+128+128+128,a4	; pixel 6
	add.l #128+128+128+128,a5	; pixel 7

	move.b (a0)+,d2
	or.l (a2,d2),d3
	or.l 4(a2,d2),d4

	move.b (a0)+,d2
	or.l (a3,d2),d3
	or.l 4(a3,d2),d4

	move.b (a0)+,d2
	or.l (a4,d2),d3
	or.l 4(a4,d2),d4

	move.b (a0)+,d2
	or.l (a5,d2),d3
	or.l 4(a5,d2),d4

	add.l #128+128+128+128,a2
	add.l #128+128+128+128,a3
	add.l #128+128+128+128,a4
	add.l #128+128+128+128,a5

	move.b (a0)+,d2
	or.l (a2,d2),d3
	or.l 4(a2,d2),d4

	move.b (a0)+,d2
	or.l (a3,d2),d3
	or.l 4(a3,d2),d4

	move.b (a0)+,d2
	or.l (a4,d2),d3
	or.l 4(a4,d2),d4

	move.b (a0)+,d2
	or.l (a5,d2),d3
	or.l 4(a5,d2),d4

	add.l #128+128+128+128,a2
	add.l #128+128+128+128,a3
	add.l #128+128+128+128,a4
	add.l #128+128+128+128,a5

	move.b (a0)+,d2
	or.l (a2,d2),d3
	or.l 4(a2,d2),d4

	move.b (a0)+,d2
	or.l (a3,d2),d3
	or.l 4(a3,d2),d4

	move.b (a0)+,d2
	or.l (a4,d2),d3
	or.l 4(a4,d2),d4

	move.b (a0)+,d2
	or.l (a5,d2),d3
	or.l 4(a5,d2),d4

	move.l d3,(a1)
	move.l d4,4(a1)

	add.l #128+128+128+128,a2
	add.l #128+128+128+128,a3
	add.l #128+128+128+128,a4
	add.l #128+128+128+128,a5

	addq.l #8,a1

	dbra d0,loop

	dbra d1,loop1
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
c2p_tbl:	incbin "table.bin"
palette:	incbin "logopouet.pal"
bitmap:		incbin "logopouet_scaled.raw"