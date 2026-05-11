#include "core.h"
#include "defines.h"
#include "ring_buff.h"
#include "usart.h"
#include "flash.h"

#define MAX_RECURSION_DEPTH 2

/* _________________________ data structures __________________________*/

// store the address in a variable for dynamic setting
// although the actual address ends with 0;
// but the last bit must be 1 (while fetching instruction) to be in thumb mode
// .. else arm mode = hard fault (in cm)
firmware_t f1;
firmware_t f2;
volatile bool boot_f1 = true;
volatile uint32_t press_count = 0;
volatile uint32_t delay_count = 0;
volatile bool update_rec_complete = false; // flag to tell if update is recieved
volatile uint32_t update_size = 0;
volatile Ring_buff_t ringbuffer;
uint8_t write_buffer [WRITE_BUFF_SIZE];
uint16_t wb_size;
bool firmware_update_mode = false;
uint8_t recursion_depth = 0;

volatile bool recieve_size = false;
volatile bool flag_size_recieved = false;
volatile bool flag_wrong_size = false;
volatile bool flag_too_big_update = false;


void init_firmware_t(uint32_t address, firmware_t *f) {
  f->__flag = *(volatile uint32_t *)(address + 0x00);
  f->__crc = *((volatile uint32_t *)(address + 0x04));
  f->__vtable_end = *((volatile uint32_t *)(address + 0x08));
  f->__base_address = *((volatile uint32_t *)(address + 0x0c));
  f->__vtable_address = *((volatile uint32_t *)(address + 0x10));
  f->__firmware_end = *((volatile uint32_t *)(address + 0x14));
  f->__firmware_size = f->__firmware_end - f->__base_address;
  f->__crc_start_addr = address + 0x08;
  f->__crc_end_addr = f->__crc_start_addr - 0x08 + f->__firmware_size;
  f->__msp_value = *((volatile uint32_t *)(f->__vtable_address));
  f->__reset_handler = *((volatile uint32_t *)(f->__vtable_address + 0x4));
}

void copy_firmware_t(firmware_t *f_dest, firmware_t *f_src) {

  f_dest->__base_address = f_src->__base_address;
  f_dest->__flag = f_src->__flag;
  f_dest->__crc = f_src->__crc;
  f_dest->__vtable_end = f_src->__vtable_end;
  f_dest->__crc_start_addr = f_src->__crc_start_addr;
  f_dest->__crc_end_addr = f_src->__crc_end_addr;
  f_dest->__vtable_address = f_src->__vtable_address;
  f_dest->__firmware_end = f_src->__firmware_end;
  f_dest->__firmware_size = f_src->__firmware_size;
  f_dest->__msp_value = f_src->__msp_value;
  f_dest->__reset_handler = f_src->__reset_handler;
}

bool handle_update(void) {

  /************************* recieve update and store it in
   * UPDATE_ADDR in flash***********************/

  if (recieve_update()) {
    printf("ERROR in recieving update\n\r", 0x0);
    return 0;
  }
  firmware_t f;
  update_size = update_size / 4 * 4 + 4; // align update size by 4bytes

  if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_1_ADDRESS)
    copy_firmware_t(&f, &f1);

  else if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_2_ADDRESS)
    copy_firmware_t(&f, &f2);

  else {
    printf("wrong firmware base address !!!", 0x0);
    return 0;
  }

  /******************** store the update in UPDATE section
   * ***************************/

  printf("update has been saved in the update section !!!\n\r", 0x0);

  firmware_t uf;
  init_firmware_t(UPDATE_ADDR, &uf);

  printf("***************validating update***************\n\r", 0x0);

  // check flag field of the firmware
  if (uf.__flag != 0xffffffff) {
    printf("ERROR .... flag field of update must be 0xffffffff\n\r", 0x0);
    return 0;
  }
  if (!validate_firmware(&uf, UPDATE_ADDR)) {
    printf("ERROR .... update validation failed\n\r", 0x0);
    return 0;
  }

  /************************firmware to COPY section
   * ***********************************/

  if (erase_flash(COPY_ADDR)) {
    printf("could not erase COPY section\n\r", 0x0);
    return 0;
  }
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
                  f.__firmware_size, NO_DELAY)) {

    printf("could not write to the COPY section \n\r", 0x0);
    return 0;
  }
  printf("firmware is copied to copy section\n\r", 0x0);

  /********************* update to firmware
   * ********************************************/

  if (erase_flash(f.__base_address)) {
    printf("could not erase FIRMWARE section\n\r", 0x0);
    return 0;
  }
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
                  uf.__firmware_size, NO_DELAY)) {

    printf("could not write to the firmware section\n\r", 0x0);
    return 0;
  }

  const uint32_t end = 0xfffffffe;
  // mark the flag implying that firmware has been updated
  flash_write(f.__base_address, (const char *)(&end), 4, NO_DELAY);

  printf("new flag = %\n\r", f.__base_address);

  printf("updating firmware is done successfully!!!!\n\r", 0x0);

  return 1;
}

bool switch_press (bool f1_valid, bool f2_valid){

  while (!press_count)
    ;
  delay_count = 1000000;
  while (delay_count--)
    ;
  if (press_count >= 3) {
    erase_flash (UPDATE_ADDR);
    firmware_update_mode = true;
    bool status = handle_update();

    if (!status && recursion_depth < MAX_RECURSION_DEPTH) {
      printf ("error in update !!! retry\n\r", 0x0);
      recursion_depth ++;
      press_count = 0;

      flag_size_recieved = false;
      flag_wrong_size = false;
      flag_too_big_update = false;

      switch_press (f1_valid, f2_valid);
    }
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
  return true;
}


int main() {

    Ring_buff_init(&ringbuffer);

    // enable faults (without this any fault = hardfault)
    SCB->SHCSR |= SCB_SHCSR_BUSFAULTENA_Msk;
    SCB->SHCSR |= SCB_SHCSR_USGFAULTENA_Msk;
    SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;


  __usart1_init();

  printf("\n\n\nbooting....\n\n\n\r", 0x0);

  // check if fimrware is corrupted during update

  if (*(uint32_t *)FIRMWARE_1_ADDRESS & 1) {
    rollback();
  }
  if (*(uint32_t *)FIRMWARE_2_ADDRESS & 1) {
    rollback();
  }

  bool f1_valid = true;
  bool f2_valid = true;
  init_firmware_t(FIRMWARE_1_ADDRESS, &f1);
  init_firmware_t(FIRMWARE_2_ADDRESS, &f2);

  // printf("hii there %\n\r", f1.__vtable_address);

  printf("*************validating firmware1*************\n\r", 0x0);
  f1_valid = validate_firmware(&f1, FIRMWARE_1_ADDRESS);
  printf("*************validating firmware2*************\n\r", 0x0);
  f2_valid = validate_firmware(&f2, FIRMWARE_2_ADDRESS);

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

  // /* illegal memory access */
  // *(uint32_t *) (0xffffffff) = 0;
  
  bool status = switch_press (f1_valid, f2_valid);
  if (!status){
    printf ("too many wrong firmware update attempt !!!\n\r", 0x0);
  }
  while (1);
}
