.syntax unified
.cpu cortex-m4
.thumb

.equ BusFault_Identifier, 0x0
.equ MemManage_Identifier, 0x1
.equ UsageFault_Identifier, 0x2

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


/***********************BusFault_Handler start**********************/

// r0 -> pc, r1 -> fault type, r2 -> fault in kernel / userproc
.section .text.BusFault_Handler
.global BusFault_Handler
.type BusFault_Handler, %function
BusFault_Handler:
    mrs r0, msp

    /* find pc */
    ldr r0, [r0, #24]
    mov r1, BusFault_Identifier
    push {lr}
    bl fault_handler_helper
    pop {lr}

    bx lr

.size BusFault_Handler, . - BusFault_Handler

/***********************BusFault_Handler end************************/


/***********************MemManage_Handler start************************/
.section .text.MemManage_Handler
.global MemManage_Handler
.type MemManage_Handler, %function
MemManage_Handler:
    mrs r0, msp
    
    /* find pc */
    ldr r0, [r0, #24]
    mov r1, MemManage_Identifier
    push {lr}
    bl fault_handler_helper
    pop {lr}

    bx lr

.size MemManage_Handler, . - MemManage_Handler

/***********************MemManage_Handler end************************/

/***********************UsageFault_Handler start*********************/

.section .text.UsageFault_Handler
.global UsageFault_Handler 
.type UsageFault_Handler, %function
UsageFault_Handler:
    mrs r0, msp
    
    /* find pc */
    ldr r0, [r0, #24]
    mov r1, UsageFault_Identifier
    push {lr}
    bl fault_handler_helper
    pop {lr}
    
    bx lr

.size UsageFault_Handler, . - UsageFault_Handler



/***********************UsageFault_Handler end*********************/


/**********************HardFault_Handler start************************/
.section .text.HardFault_Handler
.global HardFault_Handler
.type HardFault_Handler, %function
HardFault_Handler:

    mrs r0, msp
    
    /* find pc */
    ldr r0, [r0, #24]
    
    /* after getting the pc, msp can be safely altered !!!*/
    ldr r1, =_estack
    msr msp, r1

    push {lr}
    bl HardFault_Handler_helper
    pop {lr}

    b .

.size HardFault_Handler, . - HardFault_Handler

/**********************SVC_Handler start************************/
.section .text.SVC_Handler
.global SVC_Handler
.type SVC_Handler, %function
SVC_Handler:

    b .

.size SVC_Handler, . - SVC_Handler



/**********************SysTick_Handler start************************/
.section .text.SysTick_Handler
.global SysTick_Handler
.type SysTick_Handler, %function
SysTick_Handler:

    b .

.size SysTick_Handler, . - SysTick_Handler


/**********************PendSV_Handler start************************/
.section .text.PendSV_Handler
.global PendSV_Handler
.type PendSV_Handler, %function
PendSV_Handler:

    b .

.size PendSV_Handler, . - PendSV_Handler


/**********************NMI_Handler start************************/
.section .text.NMI_Handler
.global NMI_Handler
.type NMI_Handler, %function
NMI_Handler:

    b .

.size NMI_Handler, . - NMI_Handler


/**********************DebugMon_Handler start************************/
.section .text.DebugMon_Handler
.global DebugMon_Handler
.type DebugMon_Handler, %function
DebugMon_Handler:

    b .

.size DebugMon_Handler, . - DebugMon_Handler


.section .isr_vector, "a", %progbits
.global vector_table
.type vector_table, %object

vector_table:
    .word _estack           // msp value
    .word Reset_Handler     
  
    
    .word NMI_Handler           /*  NMI handler */
    .word HardFault_Handler     /*  Hard fault handler */
    .word MemManage_Handler     /*  mem management handler */
    .word BusFault_Handler      /*  bus fault */
    .word UsageFault_Handler    /*  usage fault */
    .word Default_Handler       /*  reserved */
    .word Default_Handler       /*  reserved */
    .word Default_Handler       /*  reserved */
    .word Default_Handler       /*  reserved */
    .word SVC_Handler           /*  SVC call handler */
    .word DebugMon_Handler      /*  Debug moniter */
    .word Default_Handler       /*  reserver  */
    .word PendSV_Handler        /*  pend sv handler */
    .word SysTick_Handler       /*  systick timer handler */


    .rept 37
        .word Default_Handler
    .endr

    .word USART1_IRQHandler

    .rept 2
        .word Default_Handler
    .endr

    .word EXTI15_10_IRQ_handler

.size vector_table, . - vector_table


