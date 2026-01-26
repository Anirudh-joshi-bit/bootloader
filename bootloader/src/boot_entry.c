#include "../include/commons.h"
#include <stdbool.h>

volatile bool boot_f1 = true;
// store the address in a variable for dynamic setting
// although the actual address ends with 0;
// but the last bit must be 1 (while fetching instruction) to be in thumb mode
// .. else arm mode = hard fault (in cm)
volatile firmware_t f1;
volatile firmware_t f2;
volatile uint32_t press_count = 0;
volatile uint32_t delay_count = 0;
volatile uint32_t _size_firmware1;
volatile uint32_t _size_firmware2;

void init_firmware_t(uint32_t address, volatile firmware_t *f) {
  f->__base_address = address;
  f->__crc = *((volatile uint32_t *)(address + 0x00));
  f->__digital_signature = *((volatile uint32_t *)(address + 0x04));
  f->__firmware_size = *((volatile uint32_t *)(address + 0x08));
  f->__vtable_address = *((volatile uint32_t *)(address + 0x0c));
  f->__last_address = *((volatile uint32_t *)(address + 0x10));
  f->__msp_value = *((volatile uint32_t *)(f->__vtable_address));
  f->__reset_handler = *((volatile uint32_t *)(f->__vtable_address + 0x4));
}

int main() {

  bool f1_valid = false;
  bool f2_valid = false;
  init_firmware_t(0x08004000, &f1);
  init_firmware_t(0x08008000, &f2);
    
  __usart1_init();
  __usart1_print ("hii there\n\r", 11);

  f1_valid = validate_firmware(&f1);
  f2_valid = validate_firmware(&f2);

  // init GPIOC (for on board switch)
  // init GPIOA (for on board led)
  // init SYSCGF (for using EXTI)

  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN_Msk;
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN_Msk;
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN_Msk;

  // set led to output
  GPIOA->MODER &= ~(3U << (2 * LED_PIN));
  GPIOA->MODER |= 1U << (2 * LED_PIN);

  // set switch to input
  GPIOC->MODER &= ~(3U << (2 * SWITCH_PIN));

  // falling edge detect
  EXTI->FTSR |= EXTI_FTSR_TR13_Msk;

  SYSCFG->EXTICR[3] &= ~(SYSCFG_EXTICR4_EXTI13_Msk);
  SYSCFG->EXTICR[3] |= SYSCFG_EXTICR4_EXTI13_PC;

  // enable mask at the end
  EXTI->IMR |= EXTI_IMR_MR13_Msk;

  NVIC_EnableIRQ(EXTI15_10_IRQn);

  if (!f1_valid && !f2_valid) {
    while (1)
      ;
  } else if (!f1_valid) {
    boot_f1 = false;
    jump_to_firmware();
  } else if (!f2_valid) {
    boot_f1 = true;
    jump_to_firmware();
  } else {

    while (!press_count)
      ;
    delay_count = 600000;
    while (delay_count--)
      ;
    if (press_count >= 2) {
      boot_f1 = false;
    } else {
      boot_f1 = true;
    }
    EXTI->IMR &= EXTI_IMR_MR13_Msk;
    jump_to_firmware();
  }
}
