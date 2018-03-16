.cpu cortex-a53+fp+simd

PL011_UART0			= 0x1c090000
PL011_UARTFR		= 0x18

FVP_SYSREG			= 0x1c010000
FVP_SYSREG_SYSLEDS	= 0x0008

EL1t				= 0x4

DESCRIPTOR_SIZE		= 8			// 64 bits
TR_BLOCK_SIZE		= 0x200000	// 2MB

TYPE_BLOCK			= 1	// 0b01
TYPE_TABLE			= 3	// 0b11
TYPE_PAGE			= 3	// 0b11

T0_AS_START			= 0x00000000
T0_CODE				= 0x2e000000
T0_UART_MMIO		= 0x1c000000
T1_AS_START 		= 0x80000000
T1_LOOPHOLE_CODE	= 0x80000000
T1_LOOPHOLE_DATA	= 0x80200000

LOOPHOLE_CODE_VA	= 0xffffff8000000000
LOOPHOLE_DATA_VA	= 0xffffff8000200000

ZT_PAGE_VA				= LOOPHOLE_DATA_VA
Z_PAGE_VA				= (LOOPHOLE_DATA_VA+TR_BLOCK_SIZE)
DATA_TEST_SRCPAGE_VA	= (LOOPHOLE_DATA_VA+TR_BLOCK_SIZE+TR_BLOCK_SIZE)
DATA_TEST_DSTPAGE_VA	= (LOOPHOLE_DATA_VA+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE)
DATA_TEST_MAPPAGE_VA	= (LOOPHOLE_DATA_VA+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE)

FILL_PATTERN		= 0xb00b5a55beefcafe

TEST_IFAIL			= 0x12345678aabbcc41	// expecting i-subsystem failure
TEST_DFAIL			= 0x12345678aabbcc42	// expecting d-subsystem failure

.text
.align 2

	.global _start

_start:
	mrs x0, mpidr_el1
	tst x0, #0x0f				// not b0000 (not a primary CPU)
	b.ne .

	adr x0, banner
	mov x3, #8
more:
	bl writeln
	subs x3, x3, #1
	b.ne more

	bl write_current_el

	adr x0, initialize
	bl writeln

	bl init

	adr x0, trans_i_ok
	bl writeln

	mov x24, xzr		// fault addr
	mov x25, xzr		// return addr
	mov x26, xzr		// expectations marker

	ldr x0, =LOOPHOLE_CODE_VA
	ldr x1, =loophole
	ldr x1, [x1]
	str x1, [x0]
	dsb nsh
	isb
	blr x0

	adr x0, trans_ok_res
	bl writeln

	adr x0, trans_d_ok
	bl writeln

	ldr x0, =LOOPHOLE_DATA_VA
	ldr x1, =FILL_PATTERN
	str x1, [x0]
	dsb nsh
	ldr x0, [x0]
	cmp x0, x1
	b.eq ok

	adr x0, pattern_mismatch
	bl writeln
	adr x0, fail_res_unexpected
	bl writeln
	b .

ok:
	adr x0, trans_ok_res
	bl writeln

	adr x0, walk_off
	bl writeln

	tlbi vmalle1
	dsb sy
	isb

	mrs x0, tcr_el1
	orr x0, x0, #(1 << 23)	// set EPD1 - disable page tables walk
	msr tcr_el1, x0

	adr x0, flush_by_va_i
	bl writeln

	ldr x0, =LOOPHOLE_CODE_VA
	tlbi vae1, x0		// by VA
	dsb sy
	isb

	mov x28, x0
	adr x0, trans_i_fail
	bl writeln

	mov x24, x28				// fault addr
	adr x25, exit_from_ifault	// where to return after test case passes
	ldr x26, =TEST_IFAIL		// expectations

	blr x28
	adr x0, unexpected_res
	bl writeln

exit_from_ifault:

	adr x0, flush_by_va_d
	bl writeln

	ldr x0, =LOOPHOLE_DATA_VA
	tlbi vae1, x0		// by VA
	dsb sy
	isb

	mov x28, x0

	adr x0, trans_d_fail
	bl writeln

	mov x24, x28					// fault addr
	adr x25, exit_from_dfault_one	// where to return after test case passes
	ldr x26, =TEST_DFAIL			// expectations

	ldr x28, [x28]
	dsb nsh

	adr x0, unexpected_res
	bl writeln

exit_from_dfault_one:

	mrs x0, tcr_el1
	bic x0, x0, #(1 << 23)	// clear EPD1 - enable page tables walk
	msr tcr_el1, x0
	isb
	dsb nsh

	adr x0, done
	b stop_machine_ok
// end

init:
	mrs x0, scr_el3
	orr x0, x0, #(1 << 10)		// SCL_EL3.RW
	orr x0, x0, #(1 << 0)		// SCL_EL3.NS
	msr scr_el3, x0

	mrs x0, hcr_el2
	orr x0, x0, #(1 << 31)		// HCR_EL2.RW
	msr hcr_el2, x0

	mov x28, x30
	bl go_to_el1

	adr x0, vectors
	msr vbar_el1, x0

	bl write_current_el
	bl setup_mmu

	ret x28

// input x0 - asciz string address
// destroys x0, x1, x2
writeln:
	mov x1, #PL011_UART0

writeln_txfe:
	ldrb w2, [x1, #PL011_UARTFR]
	ands x2, x2, #(1<<7)		// TXFE - Transmit FIFO empty.
	b.eq writeln_txfe

	ldrb w2, [x0], #1
	cbz w2, writeln_end

	strb w2, [x1]
	b writeln_txfe
writeln_end:
	ret

go_to_el1:
	adr x0, goto_el1
	mov x27, x30
	bl writeln
	mov x0, #EL1t
	msr spsr_el3, x0
	adr x0, go_in_el1
	msr elr_el3, x0
	eret
go_in_el1:
	ret x27

write_current_el:
	adr x0, current
	mov x27, x30
	bl writeln
	mrs x1, CurrentEL
	adr x0, el
	ubfm w1, w1, #2, #31
	add w1, w1, #'0'
	strb w1, [x0]
	bl writeln
	ret x27

setup_mmu:
	adr x0, mmu_init
	mov x27, x30
	bl writeln

// setup tables
// TTBR0
	adr x0, l1_t0table
	adr x1, l2_t0table

// code
	add x3, x1, #(DESCRIPTOR_SIZE * ((T0_CODE - T0_AS_START) / TR_BLOCK_SIZE))
	ldr x2, =(T0_CODE | 0x711)
	str x2, [x3]
	orr x3, x3, #TYPE_TABLE
	str x3, [x0]

// UART + LEDs
	add x3, x1, #(DESCRIPTOR_SIZE * ((T0_UART_MMIO - T0_AS_START) / TR_BLOCK_SIZE))
	ldr x2, =(T0_UART_MMIO | 0x711)
	str x2, [x3]
	orr x3, x3, #TYPE_TABLE
	str x3, [x0]

	msr ttbr0_el1, x0

// TTBR1
	adr x0, l1_t1table
	adr x1, l2_t1table

// code
	add x3, x1, #(DESCRIPTOR_SIZE * ((T1_LOOPHOLE_CODE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr x2, =(T1_LOOPHOLE_CODE | 0x711)
	str x2, [x3]
	orr x3, x3, #TYPE_TABLE
	str x3, [x0]

// data
// ZT page
	add x3, x1, #(DESCRIPTOR_SIZE * ((T1_LOOPHOLE_DATA - T1_AS_START) / TR_BLOCK_SIZE))
	ldr x2, =(T1_LOOPHOLE_DATA | 0x711)
	str x2, [x3]
	orr x3, x3, #TYPE_TABLE
	str x3, [x0]

// Z page
	add x3, x1, #(DESCRIPTOR_SIZE * ((T1_LOOPHOLE_DATA+TR_BLOCK_SIZE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr x2, =(T1_LOOPHOLE_DATA+TR_BLOCK_SIZE | 0x711)
	str x2, [x3]
	orr x3, x3, #TYPE_TABLE
	str x3, [x0]

// 'srcaddr'
	add x3, x1, #(DESCRIPTOR_SIZE * ((T1_LOOPHOLE_DATA+TR_BLOCK_SIZE+TR_BLOCK_SIZE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr x2, =(T1_LOOPHOLE_DATA+TR_BLOCK_SIZE+TR_BLOCK_SIZE | 0x711)
	str x2, [x3]
	orr x3, x3, #TYPE_TABLE
	str x3, [x0]

// 'dstaddr'
	add x3, x1, #(DESCRIPTOR_SIZE * ((T1_LOOPHOLE_DATA+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr x2, =(T1_LOOPHOLE_DATA+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE | 0x711)
	str x2, [x3]
	orr x3, x3, #TYPE_TABLE
	str x3, [x0]

// 'mapaddr'
	add x3, x1, #(DESCRIPTOR_SIZE * ((T1_LOOPHOLE_DATA+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE - T1_AS_START) / TR_BLOCK_SIZE))
	ldr x2, =(T1_LOOPHOLE_DATA+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE+TR_BLOCK_SIZE | 0x711)
	str x2, [x3]
	orr x3, x3, #TYPE_TABLE
	str x3, [x0]

	msr ttbr1_el1, x0

	mov x1, #0x19				// TG0 = 4KB, T0SZ = 0x0 - 0x8000000000
	orr x0, x1, #(0x02 << 30)	// TG1 = 4KB
	lsl x1, x1, 16				// T1SZ = 0xffffff8000000000 - 0xffffffffffffffff
	orr x0, x0, x1
	msr tcr_el1, x0

	tlbi vmalle1
	dsb sy

	mrs x0, sctlr_el1
	orr x0, x0, #1				// set M-bit
	msr sctlr_el1, x0
	isb

	ret x27

loophole:
	nop
	ret

.align 3
banner:
	.asciz " _____________________\r\n"
	.asciz "< [Redacted] TLB test >\r\n"
	.asciz " ---------------------\r\n"
	.asciz "        \\   ^__^\r\n"
	.asciz "         \\  (oo)\\_______\r\n"
	.asciz "            (__)\\       )\\/\\\r\n"
	.asciz "                \|\|----w \|\r\n"
	.asciz "                \|\|     \|\|\r\n"

current:
	.asciz "Currently in EL"
el:
	.asciz "?\r\n"

initialize:
	.asciz "Initialising...\r\n"
goto_el1:
	.asciz "Going to EL1...\r\n"
mmu_init:
	.asciz "Setup MMU...\r\n"

walk_off:
	.asciz "Disabling translation tables walk...\r\n"

flush_by_va_i:
	.asciz "Flushing by VA iTLB...\r\n"
flush_by_va_d:
	.asciz "Flushing by VA dTLB...\r\n"

trans_i_ok:
	.asciz "Translating by iTLB (should pass)...\r\n"
trans_d_ok:
	.asciz "Translating by dTLB (should pass)...\r\n"
trans_ok_res:
	.asciz "Passed (as expected)\r\n"

trans_i_fail:
	.asciz "Translating by iTLB (should fail with a Translation Fault)...\r\n"
trans_d_fail:
	.asciz "Translating by dTLB (should fail with a Translation Fault)...\r\n"
fail_res_expected:
	.asciz "Failed (as expected)\r\n"
fail_res_unexpected:
	.asciz "Failed (unexpected). HALTED.\r\n"

trans_iabort:
	.asciz "Syndrome: IABORT.Translation fault\r\n"
trans_dabort:
	.asciz "Syndrome: DABORT.Translation fault\r\n"

pattern_mismatch:
	.asciz "Pattern mismatch.\r\n"
unexpected_res:
	.asciz "Unexpected result.\r\n"

abt_sync_sp0:
	.asciz "Current EL with SP0: Synchronous abort!\r\n"
abt_irq_sp0:
	.asciz "Current EL with SP0: IRQ/vIRQ!\r\n"
abt_fiq_sp0:
	.asciz "Current EL with SP0: FIQ/vFIQ!\r\n"
abt_serror_sp0:
	.asciz "Current EL with SP0: SError/vSError!\r\n"

abt_sync_spx:
	.asciz "Current EL with SPx: Synchronous abort!\r\n"
abt_irq_spx:
	.asciz "Current EL with SPx: IRQ/vIRQ!\r\n"
abt_fiq_spx:
	.asciz "Current EL with SPx: FIQ/vFIQ!\r\n"
abt_serror_spx:
	.asciz "Current EL with SPx: SError/vSError!\r\n"

abt_sync_lel:
	.asciz "Lower EL using AArch64: Synchronous abort!\r\n"
abt_irq_lel:
	.asciz "Lower EL using AArch64: IRQ/vIRQ!\r\n"
abt_fiq_lel:
	.asciz "Lower EL using AArch64: FIQ/vFIQ!\r\n"
abt_serror_lel:
	.asciz "Lower EL using AArch64: SError/vSError!\r\n"

abt_sync_lel_aarch32:
	.asciz "Lower EL using AArch32: Synchronous abort!\r\n"
abt_irq_lel_aarch32:
	.asciz "Lower EL using AArch32: IRQ/vIRQ!\r\n"
abt_fiq_lel_aarch32:
	.asciz "Lower EL using AArch32: FIQ/vFIQ!\r\n"
abt_serror_lel_aarch32:
	.asciz "Lower EL using AArch32: SError/vSError!\r\n"

done:
	.asciz "All done.\r\n"

.balign 0x1000
vectors:
vector_sync_sp0:
							ldr x23, =TEST_IFAIL
							cmp x26, x23
							b.eq test_ifail_continue

							adr x0, fail_res_unexpected
							bl writeln

test_ifail_continue_unexpected:
							adr x0, abt_sync_sp0
							b stop_machine_fail
test_ifail_continue:
							mrs x0, esr_el1
							ubfx x1, x0, #26, #31	// ESR_EL1.EC ?= 0b100001
							cmp x1, 0x21			// Instruction Abort taken without a change in Exception level.
							b.ne test_ifail_continue_unexpected

							ubfx x0, x0, #0, #5		// IABORT.ISS.DFSC ?= 0b000100
							cmp x0, 0x4				// Translation fault, level 0
							b.ne test_ifail_continue_unexpected

							adr x0, trans_iabort
							bl writeln

							mrs x0, far_el1
							cmp x0, x24
							b.ne test_ifail_continue_unexpected

							adr x0, fail_res_expected
							bl writeln
							ret x25

							.balign 0x80
vector_irq_sp0:				adr x0, abt_irq_sp0
							b stop_machine_fail

							.balign 0x80
vector_fiq_sp0:				adr x0, abt_fiq_sp0
							b stop_machine_fail

							.balign 0x80
vector_serror_sp0:			adr x0, abt_serror_sp0
							b stop_machine_fail

							.balign 0x80
vector_sync_spx:
							ldr x23, =TEST_DFAIL
							cmp x26, x23
							b.eq test_dfail_continue

test_dfail_continue_unexpected:
							adr x0, abt_sync_spx
							b stop_machine_fail

test_dfail_continue:
							mrs x0, esr_el1
							ubfx x1, x0, #26, #31	// ESR_EL1.EC ?= 0b100101
							cmp x1, 0x25			// Data Abort taken without a change in Exception level.
							b.ne test_dfail_continue_unexpected

							ubfx x0, x0, #0, #5		// DABORT.ISS.DFSC ?= 0b000100
							cmp x0, 0x4				// Translation fault, level 0
							b.ne test_dfail_continue_unexpected

							adr x0, trans_dabort
							bl writeln

							mrs x0, far_el1
							cmp x0, x24
							b.ne test_dfail_continue_unexpected

							adr x0, fail_res_expected
							bl writeln
							ret x25

							.balign 0x80
vector_irq_spx:				adr x0, abt_irq_spx
							b stop_machine_fail

							.balign 0x80
vector_fiq_spx:				adr x0, abt_fiq_spx
							b stop_machine_fail

							.balign 0x80
vector_serror_spx:			adr x0, abt_serror_spx
							b stop_machine_fail

							.balign 0x80
vector_sync_lel:			adr x0, abt_sync_lel
							b stop_machine_fail

							.balign 0x80
vector_irq_lel:				adr x0, abt_irq_lel
							b stop_machine_fail

							.balign 0x80
vector_fiq_lel:				adr x0, abt_fiq_lel
							b stop_machine_fail

							.balign 0x80
vector_serror_lel:			adr x0, abt_serror_lel
							b stop_machine_fail

							.balign 0x80
vector_sync_lel_aarch32:	adr x0, abt_serror_lel_aarch32
							b stop_machine_fail

							.balign 0x80
vector_irq_lel_aarch32:		adr x0, abt_irq_lel_aarch32
							b stop_machine_fail

							.balign 0x80
vector_fiq_lel_aarch32:		adr x0, abt_fiq_lel_aarch32
							b stop_machine_fail

							.balign 0x80
vector_serror_lel_aarch32:	adr x0, abt_serror_lel_aarch32
							b stop_machine_fail

// input x0 - message addr
stop_machine_fail:
							mov w3, #0x55
							b stop_machine
stop_machine_ok:
							mov w3, #0xaa
stop_machine:
							bl writeln
							mov x0, #FVP_SYSREG
							strb w3, [x0, #FVP_SYSREG_SYSLEDS]
							dsb nsh
							b .

.balign 0x1000	// shouldn't it be 0x2000?

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

