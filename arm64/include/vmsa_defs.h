/*
 * Address-related definitions for baremetal tests, for FVP memory map.
 * Also includes VMSA translation descriptor definitions.
 */

#ifndef VMSA_DEFS_H
#define VMSA_DEFS_H

DESCRIPTOR_SIZE		= 8		// 64 bits
TR_BLOCK_SIZE		= 0x200000	// 2MB

TYPE_BLOCK		= 1		// 0b01
TYPE_TABLE		= 3		// 0b11
TYPE_PAGE		= 3		// 0b11

#endif	// VMSA_DEFS_H
