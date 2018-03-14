MEMORY { .DRAM : ORIGIN = 0x80000000, LENGTH = 0xffffff }

OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
SECTIONS
{
       .text : {
                . = ALIGN(8);
                main.o (.text)
                *(.text*)
        } >.DRAM

        .rodata : {
                . = ALIGN(8);
                __rodata_start = .;
                *(.rodata)
                __rodata_end = .;
        } >.DRAM

        .data : {
                . = ALIGN(8);
                __data_start = .;
                *(.data)
                __data_end = .;
        } >.DRAM

        .bss : {
                . = ALIGN(8);
                __bss_start = .;
                *(.bss)
                __bss_end = .;
        } >.DRAM

        /DISCARD/ : { *(.dynstr*) }
        /DISCARD/ : { *(.dynamic*) }
        /DISCARD/ : { *(.plt*) }
        /DISCARD/ : { *(.interp*) }
        /DISCARD/ : { *(.gnu*) }
        /DISCARD/ : { *(.note*) }

        init_end = .;
}
