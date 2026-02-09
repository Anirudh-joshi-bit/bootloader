ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08010000, LENGTH = 64K
    RAM   (rwx) : ORIGIN = 0x20008000, LENGTH = 32K
}

SECTIONS
{
    .Header :
    {   
        KEEP(*(.Header))

    } > FLASH
    /*size of the header is fixed = 2w*/
    .padding ALIGN (256) :
    {
       /* do nothing */
    } > FLASH = 0XFF

    /*important allignment if adding headers into the firmware*/
     .isr_vector ALIGN (256) : 
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

/* remember .. all the symbol resolves into addresses these are not variables
 * hence thinking of storing size in a symbol is not resonable*/

    
    _firmware_start = ORIGIN (FLASH);

    .fw_end :
    {
        . = ALIGN (4);
        _firmware_end = .;

    }> FLASH


    /* .bss will not take any flash space */
    .bss (NOLOAD) :
    {
        _sbss = .;             
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > RAM

    _estack = ORIGIN(RAM) + LENGTH(RAM);
}

