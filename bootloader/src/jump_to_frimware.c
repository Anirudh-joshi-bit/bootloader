// 1. set msp
// 2. set vtor
// 3. call reset handler

/*
 * before jumping to the firmware, make sure to mask all the interrupts so that
 * jump is safe
 *
 * there is a possibility that after masking the interrupts, a new interrupt may
 * pend hence we need to clear the pading clear register
 *
 * if we dont disable all the possible interrupt before clearning pending
 * register a new interrupt may fire and be pended !!!
 *
 *
 * */

#include "../include/commons.h"

extern volatile bool boot_f1;
extern volatile firmware_t f1;
extern volatile firmware_t f2;

void jump_to_firmware() {

  __disable_irq();
  if (boot_f1) {
    printf("jumping to firmware1 \n\r", 0x0);

    NVIC_DisableIRQ(EXTI15_10_IRQn);
    // below this point no other interrupt can be pended !
    for (uint8_t i = 0; i < 8; i++) {
      NVIC->ICPR[i] = 0xffffffff;
    }

    __set_MSP(f1.__msp_value);
    SCB->VTOR = f1.__vtable_address;
    // before calling the reset handler, enable irqs
    __enable_irq();
    ((void (*)(void))f1.__reset_handler)();

  } else {
    printf("jumping to firmware2 \n\r", 0x0);

    NVIC_DisableIRQ(EXTI15_10_IRQn);
    // below this point, no new interrupt will be pended
    for (uint8_t i = 0; i < 8; i++) {
      NVIC->ICPR[i] = 0xffffffff;
    }
    __set_MSP(f2.__msp_value);
    SCB->VTOR = f2.__vtable_address;
    // before jumping the reset handler, enable irqs
    __enable_irq();
    ((void (*)(void))f2.__reset_handler)();
  }
}
