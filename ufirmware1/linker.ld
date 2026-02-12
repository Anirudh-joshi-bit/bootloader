ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08010000, LENGTH = 64K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 96K
}

SECTIONS
{
    _header_start = ORIGIN(FLASH);

    .Header :
    {
        KEEP (*(.HEADER))
    } > FLASH


    .isr_vector ALIGN (256) :
    {
        _svtable = . ;
        KEEP(*(.isr_vector))
        _evtable = .;
    } > FLASH

    .text :
    {
        *(.text*)
    } > FLASH

    .rodata :
    {
        *(.rodata*)
    } > FLASH

    .ARM.exidx :
    {
        *(.ARM.exidx*)
    } > FLASH

    _sidata = LOADADDR(.data);

    .data :
    {
        _sdata = .;
        *(.data*)
        . = ALIGN (4);
        _edata = .;
    } > RAM AT > FLASH

    .fw_end :
    {
        . = ALIGN (4);
        _firmware_end = .;

    }> FLASH


    .bss (NOLOAD) :
    {
        _sbss = .;             
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > RAM

    _estack = ORIGIN(RAM) + LENGTH(RAM);
}

