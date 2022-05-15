; bitmap 320x200x8bpp to Atari planar screen
; can specify number of planes for faster output

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

; Load palette
;	move.l #palette,-(sp)
;	move.w #6,-(sp)
;	trap #14
;	addq.l #6,sp

; Read vram logical address via XBIOS
	move.w #3,-(sp)
	trap #14
	addq.l #2,sp

	move.l d0,a1		; Screen pointer

	lea bitmap,a0

; ----------------------------------------
; TODO: implement b2p (a0 - src, a1 - dst)

;	move.w #(32000/4)-2,d0
;loop:
;	move.l (a0)+,(a1)+
;	dbra d0,loop
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
;palette:	incbin "dw.pal"
bitmap:		incbin "dw.raw"
