	.c6xabi_attribute Tag_ABI_array_object_alignment, 0
	.c6xabi_attribute Tag_ABI_array_object_align_expected, 0
	.c6xabi_attribute Tag_ABI_stack_align_needed, 0
	.c6xabi_attribute Tag_ABI_stack_align_preserved, 0
	.c6xabi_attribute Tag_ABI_conformance, "1.0"

	.section .vectors
	.align 2
vectors:
		nop				; todo implement vectors if needed

.text
	.align 2
	.global _start
_start:
		mvk	.S1	text, a0	; 16-bit absolute address

loop:
		ldbu	.D1T1	*a0++, a1
		nop		4
[a1]		bnop	.S1	loop, 5		; is a0 is not zero

		b	.S1	.
		nop		5

	.align 2
text:	.asciz "hello"
