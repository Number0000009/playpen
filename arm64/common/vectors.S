/*
 * Exception vector table.
 */

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

.balign 0x800
	.global vectors

vectors:
vector_sync_sp0:
	adr	x0, abt_sync_sp0
	b	stop_machine_fail

	.balign 0x80
vector_irq_sp0:
	adr	x0, abt_irq_sp0
	b	stop_machine_fail

	.balign 0x80
vector_fiq_sp0:
	adr	x0, abt_fiq_sp0
	b	stop_machine_fail

	.balign 0x80
vector_serror_sp0:
	adr	x0, abt_serror_sp0
	b	stop_machine_fail

	.balign 0x80
vector_sync_spx:
	adr	x0, abt_sync_spx
	b	stop_machine_fail

	.balign 0x80
vector_irq_spx:
	adr	x0, abt_irq_spx
	b	stop_machine_fail

	.balign 0x80
vector_fiq_spx:
	adr	x0, abt_fiq_spx
	b	stop_machine_fail

	.balign 0x80
vector_serror_spx:
	adr	x0, abt_serror_spx
	b	stop_machine_fail

	.balign 0x80
vector_sync_lel:

	bl	check_esr_ec	// only returns if ESR_ELx.EC
				// is not as expected

	adr	x0, abt_sync_lel
	b	stop_machine_fail

	.balign 0x80
vector_irq_lel:
	adr	x0, abt_irq_lel
	b	stop_machine_fail

	.balign 0x80
vector_fiq_lel:
	adr	x0, abt_fiq_lel
	b	stop_machine_fail

	.balign 0x80
vector_serror_lel:
	adr	x0, abt_serror_lel
	b	stop_machine_fail

	.balign 0x80
vector_sync_lel_aarch32:
	adr	x0, abt_serror_lel_aarch32
	b	stop_machine_fail

	.balign 0x80
vector_irq_lel_aarch32:
	adr	x0, abt_irq_lel_aarch32
	b	stop_machine_fail

	.balign 0x80
vector_fiq_lel_aarch32:
	adr	x0, abt_fiq_lel_aarch32
	b	stop_machine_fail

	.balign 0x80
vector_serror_lel_aarch32:
	adr	x0, abt_serror_lel_aarch32
	b	stop_machine_fail
