#include "../include/commons.h"

/* _________________________ data structures __________________________*/
char fw_update[MAX_FW_SIZE];

// store the address in a variable for dynamic setting
// although the actual address ends with 0;
// but the last bit must be 1 (while fetching instruction) to be in thumb mode
// .. else arm mode = hard fault (in cm)
volatile firmware_t f1;
volatile firmware_t f2;
volatile bool boot_f1 = true;
volatile uint32_t press_count = 0;
volatile uint32_t delay_count = 0;
volatile uint32_t _size_firmware1;
volatile uint32_t _size_firmware2;
volatile uint32_t fw_ar_ind = 0;
volatile bool update_rec_complete = false; // flag to tell if update is recieved
volatile uint32_t update_size = 0;

void init_firmware_t(uint32_t address, volatile firmware_t *f) {
  f->__flag = *(volatile uint32_t *)(address + 0x00);
  f->__crc = *((volatile uint32_t *)(address + 0x04));
  f->__digital_signature = *((volatile uint32_t *)(address + 0x08));
  f->__firmware_start = *((volatile uint32_t *)(address + 0x0c));
  f->__base_address = f->__firmware_start;
  f->__vtable_address = *((volatile uint32_t *)(address + 0x10));
  f->__firmware_end = *((volatile uint32_t *)(address + 0x14));
  f->__firmware_size = f->__firmware_end - f->__firmware_start;
  f->__msp_value = *((volatile uint32_t *)(f->__vtable_address));
  f->__reset_handler = *((volatile uint32_t *)(f->__vtable_address + 0x4));
}

void handle_update(void) {
    
    printf ("the value in address 0x08020394 is -> %\n\r", 0x08020394);


  if (recieve_update()) {
    printf("ERROR in recieving update\n\r", 0x0);
    return;
  }
  update_size = update_size / 4 * 4 + 4;    // align update size by 4bytes
  if (!erase_flash(UPDATE_ADDR)) {
    if (flash_write(UPDATE_ADDR, fw_update, update_size)) {
      printf("ERROR in flash_write\n\r", 0x0);
      return;
    }
  } else {
    printf("ERROR in erasing Flash\n\r", 0x0);
    return;
  }

  printf("update has been saved in the update section !!!\n\r", 0x0);

  if (*(uint32_t *)(fw_update + 0x0c) == FIRMWARE_1_ADDRESS) {
    firmware_t uf1;
    init_firmware_t(UPDATE_ADDR, &uf1);

    erase_flash(COPY_ADDR);
    flash_write(COPY_ADDR, (const char *)(FIRMWARE_1_ADDRESS),
                f1.__firmware_size);                        // check this !!
    printf("firmware_1 is copied to copy section\n\r", 0x0);

    erase_flash(FIRMWARE_1_ADDRESS);
    flash_write (FIRMWARE_1_ADDRESS, (const char *)(UPDATE_ADDR), uf1.__firmware_size);


    const char end = 0xfe;
    flash_write (FIRMWARE_1_ADDRESS, &end, 1);

    printf ("new flag = %\n\r", FIRMWARE_1_ADDRESS);

    printf ("updating firmware1 is done successfully!!!!\n\r", 0x0);


  } else if (*(uint32_t *)(fw_update + 0x0c) == FIRMWARE_2_ADDRESS) {
    firmware_t uf2;
    init_firmware_t(UPDATE_ADDR, &uf2);

    // fill the copy sector with firmware_2;

    erase_flash(COPY_ADDR);
    flash_write(COPY_ADDR, (const char *)(FIRMWARE_2_ADDRESS),
                f2.__firmware_size);                        // check this !!
    
    printf("firmware_2 is copied to copy section\n\r", 0x0);

    erase_flash(FIRMWARE_2_ADDRESS);
    flash_write(FIRMWARE_2_ADDRESS, (const char *)(UPDATE_ADDR), uf2.__firmware_size);
 
    const char end = 0xfe;
    flash_write(FIRMWARE_2_ADDRESS, &end, 1);

    printf ("new flag = %\n\r", FIRMWARE_2_ADDRESS);

    printf ("updating firmware2 is done successfully!!!!\n\r", 0x0);


  } else {

    printf("wrong firmware address !!!", 0x0);
    return;
  }
}

int main() {
  __usart1_init();

  bool f1_valid = true;
  bool f2_valid = true;
  init_firmware_t(FIRMWARE_1_ADDRESS, &f1);
  init_firmware_t(FIRMWARE_2_ADDRESS, &f2);

  // printf("hii there %\n\r", f1.__vtable_address);

  // f1_valid = validate_firmware(&f1);
  // f2_valid = validate_firmware(&f2);

  printf("both the firmwares are checked\n\r", 0x0);
  // init GPIOC (for on board switch)
  // init SYSCGF (for using EXTI)

  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN_Msk;
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN_Msk;

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
    printf("both the firmwares are not valid\n\n\r", 0x0);
    EXTI->IMR &= EXTI_IMR_MR13_Msk;
    handle_update();
  }

  while (!press_count)
    ;
  delay_count = 1000000;
  while (delay_count--)
    ;
  if (press_count >= 3) {
    handle_update();
  } else if (press_count == 2) {
    if (f2_valid) {
      boot_f1 = false;
      jump_to_firmware();
    } else {
      boot_f1 = true;
      jump_to_firmware();
    }
  } else {
    if (f1_valid) {
      boot_f1 = true;
      jump_to_firmware();
    } else {
      boot_f1 = false;
      jump_to_firmware();
    }
  }
}
