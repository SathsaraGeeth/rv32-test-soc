ENTRY(_start)

MEMORY
{
    rom  (rx)  : ORIGIN = 0x00000000, LENGTH = 0x1000     /* 4 KB Boot ROM */
    spm  (rwx) : ORIGIN = 0x00001000, LENGTH = 0x10000    /* 64 KB SPM (stack + firmware) */
    dram (rwx) : ORIGIN = 0x00011000, LENGTH = 0x20000000 /* 512 MB DRAM */
    uart0(rw)  : ORIGIN = 0x20001000, LENGTH = 0x1000
    uart1(rw)  : ORIGIN = 0x20011000, LENGTH = 0x1000
    gpio0(rw)  : ORIGIN = 0x20021000, LENGTH = 0x1000
}

/* Place stack at the top of SPM */
_estack = ORIGIN(spm) + LENGTH(spm);

SECTIONS
{
    /* Boot ROM */
    .text : ALIGN(4)
    {
        KEEP(*(.init))          /* KEEP startup code (_start) */
        *(.text .text.*)
        *(.rodata .rodata.*)
    } > spm

    /* Data section goes into SPM */
    .data : ALIGN(4)
    {
        __data_start = .;
        *(.data .data.*)
        __data_end = .;
    } > spm

    /* BSS section goes into SPM */
    .bss : ALIGN(4)
    {
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        __bss_end = .;
    } > spm
}
