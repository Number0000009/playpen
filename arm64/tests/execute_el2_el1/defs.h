#ifndef DEFS_H
#define DEFS_H

#include <vmsa_defs.h>

T0_AS_START		= 0x00000000
T0_UART_MMIO		= 0x1c000000

T1_AS_START		= 0x80000000
T1_CODE			= 0x80000000

// 1-to-1 EL2 mapping
//CODE			= 0x80000000
ZT_PAGE		= (0x80000000+TR_BLOCK_SIZE)
Z_PAGE			= (ZT_PAGE+TR_BLOCK_SIZE)
ZEC_SRCPAGE		= (Z_PAGE+TR_BLOCK_SIZE)
ZEC_DSTPAGE		= (ZEC_SRCPAGE+TR_BLOCK_SIZE)
LOOPHOLE_CODE_SRCPAGE	= (ZEC_DSTPAGE+TR_BLOCK_SIZE)
LOOPHOLE_CODE_DSTPAGE	= (LOOPHOLE_CODE_SRCPAGE+TR_BLOCK_SIZE)

// EL1 mappings
ZEC_MAPPAGE_IPA			= (T1_AS_START+0x00200000+3*TR_BLOCK_SIZE)
LOOPHOLE_CODE_MAPPAGE_IPA	= (T1_AS_START+0x00200000+5*TR_BLOCK_SIZE)
ZEC_MAPPAGE_VA			= (0xffffff8000000000+0x00200000+3*TR_BLOCK_SIZE)
LOOPHOLE_CODE_MAPPAGE_VA	= (0xffffff8000000000+0x00200000+5*TR_BLOCK_SIZE)

#endif	// DEFS_H