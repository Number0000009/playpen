ENTRY(_start)

SECTIONS
{
    . = 0x00000000;

    .vectors :
    {
        KEEP(*(.vectors))
        . = 0x400;        /* total .vectors size ends at 0x400 */
    } = 0

    .text 0x00000400 :
    {
        *(.text)
        *(.text.*)
        *(.rodata)
        *(.rodata.*)
    }
}
