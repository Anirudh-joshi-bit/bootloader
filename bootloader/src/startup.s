.syntax unified
.cpu cortex-m4
.thumb

.section .isr_vector, "a", %progbits
.global vector_table
.type vector_table, %object

vector_table:
    .word _estack           // msp value
    .word Reset_Handler     
    .rept 54
        .word Default_Handler
    .endr

    .word EXTI15_10_IRQ_handler

.size vector_table, . - vector_table

// use the exact name (not of your own)
// Reset_Handler, Default_Handler, EXTI15_10_IRQ_handler these are recognised by the 
// assembler and it set the lsb to 1 
// if you want to use name of your own -> add 1 to the address

.section .text.Reset_Handler
.global Reset_Handler
.type Reset_Handler, %function

Reset_Handler:                           
    LDR r0, =_sdata                     // _sdata in sram
    LDR r1, =_edata                     // _edata in sram
    LDR r2, =_sidata                    // _sidata in flash

    B copy

copy:
    CMP r0, r1
    BLT copy_helper

    // init .bss with 0
    LDR r0, =_sbss                       // _sbss present in sram
    LDR r1, =_ebss                       // _ebss present in sram
    MOV r2, #0 

    B init_zero

copy_helper:
    LDR r3, [r2], #4 
    STR r3, [r0], #4 

    B copy

init_zero:
    CMP r0, r1
    BLT init_zero_helper
    
    B call_entry


init_zero_helper:
    STR r2, [r0], #4 
    B init_zero
                

call_entry:
    B main

hang:
    B .

.size Reset_Handler, . - Reset_Handler

/************************ Switch_pressed_isr start********************/
.section .text.EXTI15_10_isr
.global EXTI15_10_IRQ_handler
.type EXTI15_10_IRQ_handler, %function
// must match the entry in the vector table
EXTI15_10_IRQ_handler:
    B switch_pressed

.size EXTI15_10_IRQ_handler, . - EXTI15_10_IRQ_handler


/************************ Default_Handler start**********************/
.section .text.Default_handler
.global Default_Handler
.type Default_Handler, %function
Default_Handler :
    B .

.size Default_Handler, . - Default_Handler
