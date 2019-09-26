; nasm -f bin ./bootsector.asm
; ndisasm -b 16 bootsector

sector_size	EQU 512	; bytes
; per Bochs
heads		EQU 16
sectors		EQU 63	; sectors per track
cylinders	EQU 1

		BITS 16

		global	_start
		section	.text

		org 0x7c00
		jmp _start

		times 0x3e - ($ - $$) db 0
_start:
		mov ax, 0x0003
		int 0x10

;		In Real Mode decoder opts 16-bit ops
;		The 0x66-prefix expands 16-bit registers into 32-bit registers
;		which is one byte longer

		xor edi, edi
		mov ebx, 0xb800
		mov ds, ebx

		mov eax, 0x07410741
		mov [ds:edi], eax

		mov ah, 0x0e
		mov al, 'Z'
		int 0x10

		jmp $

		times sector_size - 2 - ($ - $$) db 0
		dw 0xaa55

		times sector_size * sectors * heads * cylinders - ($ - $$) db 0
