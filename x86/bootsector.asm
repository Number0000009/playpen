; nasm -f bin ./bootsector.asm
; ndisasm -b 16 bootsector
; bochsdbg -q -f bochsrc.bxrc

%define PAGE_PRESENT    (1 << 0)
%define PAGE_WRITE      (1 << 1)

sector_size	EQU 512	; bytes
; per Bochs
heads		EQU 16
sectors		EQU 63	; sectors per track
cylinders	EQU 1

		BITS 16

		global	_start
		section	.text

		org 0x7c00
main:
		jmp _start


;		times 0x3e - ($ - $$) db 0
_start:
		cli
		cld





;		mov ax, 0x0003
;		int 0x10

;		In Real Mode decoder opts 16-bit ops
;		The 0x66-prefix expands 16-bit registers into 32-bit registers
;		which is one byte longer

;		xor edi, edi
;		mov ebx, 0xb800
;		mov ds, ebx

;		mov eax, 0x07410741
;		mov dword [ds:edi], eax

;		mov ah, 0x0e
;		mov al, 'Z'
;		int 0x10

;		in al, 0x92
;		test al, 2
;		jnz a20_after

;		or al, 2
;		and al, 0xFE
;		out 0x92, al
a20_after:

        ; Enable A20 Gate
;        in al, 0x92
;        or al, 0x02
;        out 0x92, al

    xor ax, ax

    ; Set up segment registers.
    mov ss, ax
    ; Set up stack so that it starts below Main.
    mov sp, main

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    cld



    ; Zero out the 16KiB buffer.
    ; Since we are doing a rep stosd, count should be bytes/4.

    %define FREE_SPACE 0x9000
    mov edi, FREE_SPACE

    push di                           ; REP STOSD alters DI.
    mov ecx, 0x1000
    xor eax, eax
    cld
    rep stosd
    pop di                            ; Get DI back.


    ; Build the Page Map Level 4.
    ; es:di points to the Page Map Level 4 table.

    lea eax, [es:di + 0x1000]         ; Put the address of the Page Directory Pointer Table in to EAX.
    or eax, PAGE_PRESENT | PAGE_WRITE ; Or EAX with the flags - present flag, writable flag.
    mov [es:di], eax                  ; Store the value of EAX as the first PML4E.


    ; Build the Page Directory Pointer Table.
    lea eax, [es:di + 0x2000]         ; Put the address of the Page Directory in to EAX.
    or eax, PAGE_PRESENT | PAGE_WRITE ; Or EAX with the flags - present flag, writable flag.
    mov [es:di + 0x1000], eax         ; Store the value of EAX as the first PDPTE.


    ; Build the Page Directory.
    lea eax, [es:di + 0x3000]         ; Put the address of the Page Table in to EAX.
    or eax, PAGE_PRESENT | PAGE_WRITE ; Or EAX with the flags - present flag, writeable flag.
    mov [es:di + 0x2000], eax         ; Store to value of EAX as the first PDE.


    push di                           ; Save DI for the time being.
    lea di, [di + 0x3000]             ; Point DI to the page table.
    mov eax, PAGE_PRESENT | PAGE_WRITE    ; Move the flags into EAX - and point it to 0x0000.


    ; Build the Page Table.
.LoopPageTable:
    mov [es:di], eax
    add eax, 0x1000
    add di, 8
    cmp eax, 0x200000                 ; If we did all 2MiB, end.
    jb .LoopPageTable

    pop di

; disable IRQs
mov al, 0xff
out 0xa1, al
out 0x21, al
nop
nop

;    lidt [IDT]                        ; Load a zero length IDT so that any NMI causes a triple fault.

;		mov edi, 0x1000
;		mov cr3, edi

;		xor eax, eax
;		mov ecx, 0x1000
;		rep stosd

;		mov edi, cr3

;		mov DWORD [edi], 0x2003      ; Set the uint32_t at the destination index to 0x3003.
;		add edi, 0x1000
;		mov DWORD [edi], 0x3003      ; Set the uint32_t at the destination index to 0x4003.
;		add edi, 0x1000
;		mov DWORD [edi], 0x4003      ; Set the uint32_t at the destination index to 0x5003.
;		add edi, 0x1000

;		mov ebx, 0x00000003
;		mov ecx, 512


;.SetEntry:
;		mov DWORD [edi], ebx         ; Set the uint32_t at the destination index to the B-register.
;		add ebx, 0x1000
;		add edi, 8
;		loop .SetEntry

;        ; Define one 2MB page at memory address 0.

;        mov di, 0x2000             ; PML4
;        mov ax, 0x3000 + 0xf
;        stosw
;        xor ax, ax
;        mov cx, 0x07ff
;        rep stosw

;        mov ax, 0x4000 + 0xf       ; PDP
;        stosw
;        xor ax, ax
;        mov cx, 0x07ff
;        rep stosw

;        mov ax, 0x018f             ; PD
;        stosw
;        xor ax, ax
;        mov cx, 0x07ff
;        rep stosw

	mov eax, 10100000b		; Set PAE and PG
	mov cr4, eax

;        mov eax, 0x2000             ; Assign PML4
;        mov cr3, eax

mov eax, edi
mov cr3, eax	; PML4 (should be set before enabling PG and PM)

	mov ecx, 0xC0000080		; EFER
	rdmsr
	or eax, 1 << 8			; Set LME
	wrmsr

	mov eax, cr0
	or eax, 1 << 31 | 1 << 0	; Enable PG and PM
	mov cr0, eax

	xchg bx, bx		; Bochs Magic breakpoint
	lgdt [gdt64.ptr]

%define CODE_SEG     0x0008
%define DATA_SEG     0x0010

	jmp CODE_SEG:Realm64


;align 4096
;gdt64:                           ; Global Descriptor Table (64-bit).
;    .null: equ $ - gdt64         ; The null descriptor.
;    dw 0xFFFF                    ; Limit (low).
;    dw 0                         ; Base (low).
;    db 0                         ; Base (middle)
;    db 0                         ; Access.
;    db 1                         ; Granularity.
;    db 0                         ; Base (high).
;    .code: equ $ - gdt64         ; The code descriptor.
;    dw 0                         ; Limit (low).
;    dw 0                         ; Base (low).
;    db 0                         ; Base (middle)
;    db 10011010b                 ; Access (exec/read).
;    db 10101111b                 ; Granularity, 64 bits flag, limit19:16.
;    db 0                         ; Base (high).
;    .data: equ $ - gdt64         ; The data descriptor.
;    dw 0                         ; Limit (low).
;    dw 0                         ; Base (low).
;    db 0                         ; Base (middle)
;    db 10010010b                 ; Access (read/write).
;    db 00000000b                 ; Granularity.
;    db 0                         ; Base (high).
;    .ptr:                        ; The GDT-pointer.
;    dw $ - gdt64 - 1             ; Limit.
;    dq gdt64                     ; Base.

; 64-bit GDT
;gdt64:
;        dq 0x0000000000000000       ; Null Descriptor
;.code equ $ - gdt64                 ; Code segment
;        dq 0x0020980000000000
;.data equ $ - gdt64                 ; Data segment
;        dq 0x0000920000000000
;
;.desc:
;        dw $ - gdt64 - 1            ; 16-bit Size (Limit)
;        dq gdt64                    ; 64-bit Base Address

gdt64:
.null:
    dq 0x0000000000000000             ; Null Descriptor - should be present.

.code:
    dq 0x00209A0000000000             ; 64-bit code descriptor (exec/read).
    dq 0x0000920000000000             ; 64-bit data descriptor (read/write).

ALIGN 4
    dw 0                              ; Padding to make the "address of the GDT" field aligned on a 4-byte boundary

.ptr:
    dw $ - gdt64 - 1                  ; 16-bit Size (Limit) of GDT.
    dd gdt64                          ; 32-bit Base Address of GDT. (CPU will zero extend to 64-bit)




		BITS 64

Realm64:
		mov rax, 0x0742074207420742

;		cli                           ; Clear the interrupt flag.
;		mov ax, gdt64.data            ; Set the A-register to the data descriptor.
;		mov ds, ax                    ; Set the data segment to the A-register.
;		mov es, ax                    ; Set the extra segment to the A-register.
;		mov fs, ax                    ; Set the F-segment to the A-register.
;		mov gs, ax                    ; Set the G-segment to the A-register.
;		mov ss, ax                    ; Set the stack segment to the A-register.
;		mov edi, 0xB8000              ; Set the destination index to 0xB8000.
;;		mov rax, 0x1F201F201F201F20   ; Set the A-register to 0x1F201F201F201F20.
;		mov rax, 0x0742074207420742
;		mov ecx, 500                  ; Set the C-register to 500.
;		rep stosq                     ; Clear the screen.

		hlt
		jmp $

ALIGN 4
IDT:
    .Length       dw 0
    .Base         dd 0


		times sector_size - 2 - ($ - $$) db 0
		dw 0xaa55

		times sector_size * sectors * heads * cylinders - ($ - $$) db 0
