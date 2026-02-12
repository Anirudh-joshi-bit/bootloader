ENTRY(Reset_Handler)
MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08020000, LENGTH = 128K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 96K
}
/*
 *  add header section 
 *  add padding to the vtable
 *  add symbols
 *  change FLASH -> ORIGIN, SIZE
 *  change RAM -> ORIGIN, SIZE
 *  add padding in the end to make sure that the firmware is word align
 *
 * */


SECTIONS
{

    .Header : 
    {
        KEEP(*(.Header))
    }> FLASH

    .isr_vector ALIGN(256) :
    {
        _svtable = . ;
        KEEP(*(.isr_vector))
        _evtable = . ;
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
        _edata = .;
    } > RAM AT > FLASH

    _header_start = ORIGIN (FLASH);

    .fw_end :
    {
        . = ALIGN(4);
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

