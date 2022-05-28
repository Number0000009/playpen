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

	move.l #320/16*200-1,d0
loop:
	move.l #%10000000000000000000000000000000,d5

	rept 16

	move.l #-1,d1
	dbra d1,*

	move.l d5,(a1)
	asr.l #1,d5
	endr

	addq #8,a1

	dbra d0,loop

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
bitmap:		incbin "logopouet.raw"
