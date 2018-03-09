/*
 * FVP hardware address-space definitions.
 */

#ifndef PLATFORM_HARDWARE_H
#define PLATFORM_HARDWARE_H

PL011_UART0		= 0x1c090000
PL011_UARTFR		= 0x18
UART_TXFE		= (1<<7)		// TXFE - Transmit FIFO empty.

FVP_SYSREG		= 0x1c010000
FVP_SYSREG_SYSLEDS	= 0x0008

#endif	// PLATFORM_HARDWARE_H
