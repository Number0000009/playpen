/*
 * MMU and page table initialisation routines for bare-metal tests.
 */

#include "defs.h"

	.global setup_mmu
setup_mmu:
	adr	x0, mmu_init
	mov	x27, x30
	bl writeln

// setup tables
// TTBR0
	adr	x0, l1_t0table
	adr	x1, l2_t0table

	orr	x2, x1, #TYPE_TABLE
	str	x2, [x0]

// code
	add	x3, x1, #(DESCRIPTOR_SIZE * ((T0_CODE - T0_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T0_CODE | 0x711)
	str	x2, [x3]
	orr	x3, x3, #TYPE_TABLE
	str	x3, [x0]

// UART + LEDs
	add	x3, x1, #(DESCRIPTOR_SIZE * ((T0_UART_MMIO - T0_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T0_UART_MMIO | 0x711)
	str	x2, [x3]
	orr	x3, x3, #TYPE_TABLE
	str	x3, [x0]

	msr	ttbr0_el1, x0

// TTBR1
	adr	x0, l1_t1table
	adr	x1, l2_t1table

	orr	x2, x1, #TYPE_TABLE
	str	x2, [x0]

// data
// ZT page
	add	x3, x1, #(DESCRIPTOR_SIZE * ((T1_AS_START - T1_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T1_AS_START | 0x711)	// R/W EL1 only, block
	str	x2, [x3]

// Z page
	add	x3, x1, #(DESCRIPTOR_SIZE * ((T1_AS_START+TR_BLOCK_SIZE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T1_AS_START+TR_BLOCK_SIZE | 0x711)	// R/W EL1 only, block
	str	x2, [x3]

// 'ZEC'
	add	x3, x1, #(DESCRIPTOR_SIZE * ((T1_AS_START+TR_BLOCK_SIZE+TR_BLOCK_SIZE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T1_AS_START+TR_BLOCK_SIZE+TR_BLOCK_SIZE | 0x711)	// R/W EL1 only, block
	str	x2, [x3]

// 'dstaddr'
	add	x3, x1, #(DESCRIPTOR_SIZE * ((T1_AS_START+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T1_AS_START+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE | 0x751)	// R/W all ELs, block
	str	x2, [x3]

// code
	add	x3, x1, #(DESCRIPTOR_SIZE * ((T1_AS_START+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T1_AS_START+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE | 0x711)	// R/W EL1 only, block
	str	x2, [x3]

// codedst
	add	x3, x1, #(DESCRIPTOR_SIZE * ((T1_AS_START+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T1_AS_START+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE | 0x751)	// R/W all ELs, block
	str	x2, [x3]

// UART
	add	x3, x1, #(DESCRIPTOR_SIZE * ((T1_AS_START+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+0x90000 - T1_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T0_UART_MMIO | 0x751)	// R/W all ELs, block
	str	x2, [x3]

	msr	ttbr1_el1, x0

	mov	x1, #0x19		// TG0 = 4KB, T0SZ = 0x0 - 0x8000000000
	orr	x0, x1, #(0x02 << 30)	// TG1 = 4KB
	lsl	x1, x1, 16		// T1SZ = 0xffffff8000000000 - 0xffffffffffffffff
	orr	x0, x0, x1
	msr	tcr_el1, x0

	tlbi	vmalle1
	dsb	nsh
	isb
	mrs	x0, sctlr_el1
	orr	x0, x0, #1		// set M-bit
	msr	sctlr_el1, x0
	isb

	ret	x27

mmu_init:
	.asciz "Setup MMU...\r\n"

// Translation tables
.balign 0x1000

// Code and UART and LEDs
l1_t0table:
.space (512*8), 0
l2_t0table:
.space (512*8), 0

// Loophole code and data
l1_t1table:
.space (512*8), 0
l2_t1table:
.space (512*8), 0
