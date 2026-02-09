ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08020000, LENGTH = 128K
    RAM   (rwx) : ORIGIN = 0x20010000, LENGTH = 32K
}

SECTIONS
{
    .Header :
    {   
        _sfirmware = . ;
        KEEP(*(.Header))

    } > FLASH

    /*important allignment if adding headers into the firmware*/
    .isr_vector ALIGN(256) :
    {
        _svtable = . ;
        KEEP(*(.isr_vector))
        _evtable = . ;
    } > FLASH
     

    .text :
    {
        _stext = . ;
        *(.text*)
        _etext = . ;
    } > FLASH
    

    .rodata :
    {
        _srodata = . ;
        *(.rodata*)
        _erodata = . ;
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
    

    _firmware_start = ORIGIN (FLASH);

    .fw_end :
    {
        . = ALIGN (4);
        _firmware_end = . ;

    } > FLASH

    .bss (NOLOAD) :
    {
        _sbss = .;             
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > RAM

    _estack = ORIGIN(RAM) + LENGTH(RAM);
}

