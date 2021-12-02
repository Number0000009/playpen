/* Prints 'Hello World!' as a Linux userspace program
 * How to build: riscv64-linux-gnu-gcc test.s -nostdlib -static
 * How to run: qemu-riscv64 -strace a.out
 * Example output:
 * $ ~/qemu/build/qemu-riscv64 -strace a.out
 * Hello World!
 * 27333 write(0,0x11130,14) = 14
 * 27333 exit(0)
 */

# from asm-generic/unistd.h
	.equ	__NR_exit,	93
	.equ	__NR_write,	64

.data
msg:	.asciz "Hello World!\n"
	.equ msg_len, (. - msg)

.text
	.align 1
	.global _start
_start:
	mv	a0, x0			# stdout
	la	a1, msg			# addr(msg), GOT-relative addressing
	addi	a2, a0, msg_len		# length
	addi	a7, x0, __NR_write
	ecall

	mv	a0, x0
	addi	a7, x0, __NR_exit
	ecall
