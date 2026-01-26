ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08008000, LENGTH = 16K
    RAM   (rwx) : ORIGIN = 0x20010000, LENGTH = 32K
}

SECTIONS
{
    _sfirmware = . ;
    .Header :
    {   
        KEEP(*(.Header))

    } > FLASH
    /*size of the header is fixed = 2w*/

    /*important allignment if adding headers into the firmware*/
    .isr_vector ALIGN(256) :
    {
        _svtable = . ;
        KEEP(*(.isr_vector))
        _evtable = . ;
    } > FLASH
    
    /*size of vector table*/
    _size_vtable = _evtable - _svtable ;
        
    .text :
    {
        _stext = . ;
        *(.text*)
        _etext = . ;
    } > FLASH
    
    /*size of the text segment*/
    _size_text = _etext - _stext ;


    .rodata :
    {
        _srodata = . ;
        *(.rodata*)
        _erodata = . ;
    } > FLASH

    /*size of read only data in flash*/
    _size_rodata = _erodata - _srodata;


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
    _eidata = LOADADDR (.data);

    /*size of the data section in falsh*/
    _size_data = _edata - _sdata;
    _size_firmware = LOADADDR (.data) + _size_data - ORIGIN (FLASH);

    .bss (NOLOAD) :
    {
        _sbss = .;             
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > RAM

    _estack = ORIGIN(RAM) + LENGTH(RAM);
}

