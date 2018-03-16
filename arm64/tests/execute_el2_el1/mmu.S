#include "defs.h"

	.global setup_mmu
setup_mmu:

	adr	x0, mmu_init
	mov	x27, x30
	bl	writeln

// setup TTBR0_EL2
	adr	x0, el2_l1_t0table
	adr	x1, el2_l2_t0table

	msr	ttbr0_el2, x0
//			            _PS(0b000 = 32bit - 4GB)
//			            |||
	ldr	x2, =0b10000000000000000000000000100000	// 0 - 4GB (T0SZ = 32), 4KB TG0
	msr	tcr_el2, x2
	isb

	orr	x2, x1, #TYPE_TABLE
	str	x2, [x0]				// 0x00000000

// UART + LEDs (0x1c000000)
	add	x3, x1, #(DESCRIPTOR_SIZE * (T0_UART_MMIO / TR_BLOCK_SIZE))
	ldr	x2, =(T0_UART_MMIO | 0x441)		// RW, block
	str	x2, [x3]

// DRAM (0x80000000 - +4GB)
// code (0x80000000)
	add	x3, x1, #(DESCRIPTOR_SIZE * (T1_CODE / TR_BLOCK_SIZE))
	ldr	x2, =(T1_CODE | 0x441)			// RW, block
	str	x2, [x3]

	add	x0, x0, #DESCRIPTOR_SIZE		// 0x40000000
	add	x0, x0, #DESCRIPTOR_SIZE		// 0x80000000
	orr	x2, x3, #TYPE_TABLE
	str	x2, [x0]

// ZT page
	ldr	x3, =(DESCRIPTOR_SIZE * (ZT_PAGE / TR_BLOCK_SIZE))
	add	x3, x1, x3
	ldr	x2, =(ZT_PAGE | 0x441)			// RW, block
	str	x2, [x3]

// Z page
	ldr	x3, =(DESCRIPTOR_SIZE * (Z_PAGE / TR_BLOCK_SIZE))
	add	x3, x1, x3
	ldr	x2, =(Z_PAGE | 0x441)			// RW, block
	str	x2, [x3]

// ZEC srcpage
	ldr	x3, =(DESCRIPTOR_SIZE * (ZEC_SRCPAGE / TR_BLOCK_SIZE))
	add	x3, x1, x3
	ldr	x2, =(ZEC_SRCPAGE | 0x441)		// RW, block
	str	x2, [x3]

// ZEC dstpage
	ldr	x3, =(DESCRIPTOR_SIZE * (ZEC_DSTPAGE / TR_BLOCK_SIZE))
	add	x3, x1, x3
	ldr	x2, =(ZEC_DSTPAGE | 0x441)		// RW, block
	str	x2, [x3]

// loophole code srcpage
	ldr	x3, =(DESCRIPTOR_SIZE * (LOOPHOLE_CODE_SRCPAGE / TR_BLOCK_SIZE))
	add	x3, x1, x3
	ldr	x2, =(LOOPHOLE_CODE_SRCPAGE | 0x441)	// RW, block
	str	x2, [x3]

// loophole code dstpage
	ldr	x3, =(DESCRIPTOR_SIZE * (LOOPHOLE_CODE_DSTPAGE / TR_BLOCK_SIZE))
	add	x3, x1, x3
	ldr	x2, =(LOOPHOLE_CODE_DSTPAGE | 0x441)	// RW, block
	str	x2, [x3]

	tlbi	alle2
	dsb	sy

// setup VTTBR_EL2
	adr	x0, el2_l1_vt0table
	adr	x1, el2_l2_vt0table

	msr	vttbr_el2, x0
//			            _PS(0b000 = 32bit - 4GB)
//			            |||        || - SL0 (Start at level 1)
	ldr	x2, =0b10000000000000000000000001100000	// 0 - 4GB (T0SZ = 32), 4KB TG0
	msr	vtcr_el2, x2
	isb

	orr	x2, x1, #TYPE_TABLE
	str	x2, [x0]				// 0x00000000

// UART + LEDs (0x1c000000)
	add	x3, x1, #(DESCRIPTOR_SIZE * (T0_UART_MMIO / TR_BLOCK_SIZE))
	ldr	x2, =(T0_UART_MMIO | 0x4c1)		// RW, RW@EL*, block
	str	x2, [x3]

// DRAM (0x80000000 - +4GB)
// translation tables (0x80000000)
	add	x0, x0, #DESCRIPTOR_SIZE		// 0x40000000
	add	x0, x0, #DESCRIPTOR_SIZE		// 0x80000000

	add	x3, x1, #(DESCRIPTOR_SIZE * (T1_CODE / TR_BLOCK_SIZE))
	ldr	x2, =(T1_CODE | 0x4c1)
	str	x2, [x3]

	orr	x2, x3, #TYPE_TABLE
	str	x2, [x0]

// ZEC dstpage
	ldr	x3, =(DESCRIPTOR_SIZE * (ZEC_DSTPAGE / TR_BLOCK_SIZE))
	add	x3, x1, x3
	ldr	x2, =(ZEC_DSTPAGE | 0x4c1)		// RW, RW@EL*, block
	str	x2, [x3]

// loophole code dstpage
	ldr	x3, =(DESCRIPTOR_SIZE * (LOOPHOLE_CODE_DSTPAGE / TR_BLOCK_SIZE))
	add	x3, x1, x3
	ldr	x2, =(LOOPHOLE_CODE_DSTPAGE | 0x4c1)	// RW, RW@EL*, block
	str	x2, [x3]

// setup TTBR0_EL1
	adr	x0, el1_l1_t0table
	adr	x1, el1_l2_t0table

	msr	ttbr0_el1, x0

// translation tables
	add	x3, x1, #(DESCRIPTOR_SIZE * (T1_CODE / TR_BLOCK_SIZE))
	ldr	x2, =(T1_CODE | 0x441)			// RW@EL*, block
	str	x2, [x3]

	add	x0, x0, #DESCRIPTOR_SIZE		// 0x40000000
	add	x0, x0, #DESCRIPTOR_SIZE		// 0x80000000
	orr	x2, x3, #TYPE_TABLE
	str	x2, [x0]

// setup TTBR1_EL1
	adr	x0, el1_l1_t1table
	adr	x1, el1_l2_t1table

	msr	ttbr1_el1, x0

	orr	x2, x1, #TYPE_TABLE
	str	x2, [x0]

	add	x3, x1, #(DESCRIPTOR_SIZE * ((T1_CODE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T1_CODE | 0x441)			// RW@EL*, block
	str	x2, [x3]

// ZEC map page
	ldr	x3, =(DESCRIPTOR_SIZE * ((ZEC_MAPPAGE_IPA - T1_AS_START) / TR_BLOCK_SIZE))
	add	x3, x1, x3
	ldr	x2, =(ZEC_MAPPAGE_IPA | 0x401)			// RW@EL1 only, block
	str	x2, [x3]

// loophole code map page
	ldr	x3, =(DESCRIPTOR_SIZE * ((LOOPHOLE_CODE_MAPPAGE_IPA - T1_AS_START) / TR_BLOCK_SIZE))
	add	x3, x1, x3
	ldr	x2, =(LOOPHOLE_CODE_MAPPAGE_IPA | 0x401)	// RW@EL1 only, block
	str	x2, [x3]

// UART
	add	x3, x1, #(DESCRIPTOR_SIZE * ((T1_AS_START+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+0x90000 - T1_AS_START) / TR_BLOCK_SIZE))
	ldr	x2, =(T0_UART_MMIO | 0x441)	// RW@EL*, block
	str	x2, [x3]

	ldr	x0, =0b10000000000110010000000000011001	// 0 - 1TB (T0SZ = 25), 4KB TG0, 4KB TG1
	msr	tcr_el1, x0

// Enable 2-stage translation
	mrs	x0, hcr_el2
	orr	x0, x0, #1		// set VM-bit
	msr	hcr_el2, x0

	tlbi	vmalls12e1
	dsb	sy

	mrs	x0, sctlr_el1
	orr	x0, x0, #1		// set M-bit
	msr	sctlr_el1, x0

	mrs	x0, sctlr_el2
	orr	x0, x0, #1		// set M-bit
	msr	sctlr_el2, x0

	isb

	ret	x27

mmu_init:
	.asciz "Setup MMU...\r\n"

// Translation tables
.balign 0x1000

// EL2 tables
el2_l1_t0table:
.space (512*8), 0
el2_l2_t0table:
.space (4096*8), 0

// VTTBR_EL2 tables
el2_l1_vt0table:
.space (512*8), 0
el2_l2_vt0table:
.space (4096*8), 0

// EL1 tables
el1_l1_t0table:
.space (512*8), 0
el1_l2_t0table:
.space (4096*8), 0

el1_l1_t1table:
.space (512*8), 0
el1_l2_t1table:
.space (4096*8), 0
