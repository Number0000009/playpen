/*
 * Assembler utilities for bare-metal tests.
 */

#ifndef UTILS_H
#define UTILS_H

// Get IPA of a virtual address
// PAR_EL1.PA[51:48].PA[47:12]
.macro translate_el1_s1, va
	at s1e1r, \va
	mrs \va, par_el1
	ubfm \va, \va, #12, #51
	ubfm \va, \va, #52, #51
.endm

// Get PA of a virtual address
// PAR_EL1.PA[51:48].PA[47:12]
.macro translate_el1_s12, va
	at s12e1r, \va
	mrs \va, par_el1
	ubfm \va, \va, #12, #51
	ubfm \va, \va, #52, #51
.endm

// Get PA of a virtual address
// PAR_EL1.PA[51:48].PA[47:12]
.macro translate_el2_s1, va
	at s1e2r, \va
	mrs \va, par_el1
	ubfm \va, \va, #12, #51
	ubfm \va, \va, #52, #51
.endm

#endif	// UTILS_H
