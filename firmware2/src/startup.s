.syntax unified
.cpu cortex-m4
.thumb

.section .Header, "a", %progbits
.global Header
.type Header, %object
Header:
    .word 0xfffffffe
    .word 0xe01e0253
    .word _evtable
    .word _header_start
    .word _svtable
    .word _firmware_end

.size Header, . - Header


.section .isr_vector, "a", %progbits
.global g_pfnVectors
.type g_pfnVectors, %object

g_pfnVectors:
    .word _estack            
    .word Reset_Handler     

    .rept 54                    // jump straight to 0xE0 
        .word Default_Handler
    .endr

    .word EXTI15_10_IRQ_handler


.size g_pfnVectors, . - g_pfnVectors



.section .text.Reset_Handler
.global Reset_Handler
.type Reset_Handler, %function

Reset_Handler:
    
    LDR r0, =_sdata                 // VMA address
    LDR r1, =_edata                 // VMA address 
    LDR r2, =_sidata                // LMA address
    B copy_start


copy_start:
    // copy data from _sdata to _sidata while _sdata != _edata
    CMP r0, r1

    BLT copy

    LDR r0, =_sbss
    LDR r1, =_ebss
    MOV r2, #0

    B start_init_0

copy:
    LDR r3, [r2], #4   // load r3 with [r0]
    STR r3, [r0], #4   // store r3 in [r2]
    B copy_start

start_init_0:
   
    // put zero in [r0] while r0 != r1
    CMP r0, r1
    BLT helper_init_0
    B call_main

helper_init_0:
    // we cannot use MOV while writing/reading to/from memory
    // cannot use direct addressing mode for LDR, STR 
    STR r2, [r0], #4
    B start_init_0

call_main:
    B main
    // should never return from main 
    B hang

hang:
    // infinite loop (if forgot in main !!!)
    B hang

.size Reset_Handler, . - Reset_Handler

// ____________________________EXTI13_Handler_________________________ start
.section .text.EXTI15_10_IRQ_handler
.global EXTI15_10_IRQ_handler
.type EXTI15_10_IRQ_handler, %function

EXTI15_10_IRQ_handler:
    LDR r0, =0x40013C14   // EXTI_PR
    LDR r1, =0x00002000   // EXTI13
    STR r1, [r0]

    B switch_on_isr

.size EXTI15_10_IRQ_handler, . - EXTI15_10_IRQ_handler

// ____________________________EXTI13_Handler_________________________ end




.section .text.Default_Handler
.global Default_Handler
.type Default_Handler, %function

Default_Handler:
    B .

.size Default_Handler, . - Default_Handler

