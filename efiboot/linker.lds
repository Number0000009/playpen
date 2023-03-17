ENTRY(start)

SECTIONS {
    .boot :
    {
        /* Ensure that the header is at the beginning */
        *(.efi_header)
    }

    .text :
    {
        *(.text)
    }

    .data :
    {
        *(.data)
    }

    /DISCARD/ : { *(.dynstr*) }
    /DISCARD/ : { *(.dynamic*) }
    /DISCARD/ : { *(.plt*) }
    /DISCARD/ : { *(.interp*) }
    /DISCARD/ : { *(.gnu*) }
    /DISCARD/ : { *(.note*) }

    _end = .;
}
