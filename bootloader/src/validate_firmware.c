#include "../include/commons.h"
#include <stdint.h>

bool validate_vtable(firmware_t *f) {

  // vtable end is the next free address
  // check from address ------->    [vtable_start, vtable_end)
  
  // vtable must be 128byte aligned => last 7 bits must be 0 (for stm32f401re)
  if (f->__vtable_address & ((1 << 7) - 1)) {
    printf("the vector table is not 128byte aligned !!!\n\r", 0x0);
    return false;
  }

  // all the "end" addresses are next free address => there should not be any
  // data in the "end" address !! all the addresses must lie in the range
  // [start, end)

  uint32_t RAM_start = 0x20000000;
  uint32_t RAM_size = 96 * 1024; // 96kB
  uint32_t RAM_end = RAM_start + RAM_size;
  uint32_t FLASH_start = f->__vtable_address;
  uint32_t FLASH_size;
  if (f->__base_address == FIRMWARE_1_ADDRESS)
    FLASH_size = 0x10000;
  else if (f->__base_address == FIRMWARE_2_ADDRESS)
    FLASH_size = 0x20000;
  else {
    printf("update _base address is not valid\n\r", 0x0);
    return false;
  }
  uint32_t FLASH_end = FLASH_start + FLASH_size;

  /*************************msp check*********************/
  
  // MSP value can be RAM end as MSP grows downword;
  if (f->__msp_value > RAM_end || f->__msp_value < RAM_start) {

      printf ("MSP value is -> %\n\r", (uint32_t)(&(f->__msp_value)));
    printf("MSP value is invalid\n\r", 0x0);
    return false;
  }
  // msp value must be word aligned !!!
  if (f->__msp_value & 3) {
    printf("MSP value is not word aligned\n\r", 0x0);
    return false;
  }

  /************************ vtable check************************/

  for (uint32_t vtable_entry = f->__vtable_address + 0x4;
       vtable_entry < f->__vtable_end; vtable_entry += 4) {

    uint32_t FLASH_address =
        *((uint32_t *)vtable_entry); // peek inside vtable_entry
    if (FLASH_address >= FLASH_end || FLASH_address < FLASH_start) {

      printf("% ---- in vtable entry does not exist in the allowed flash "
             "range\n\r", vtable_entry);
      return false;
    }
  }

  return true;
}

bool validate_firmware(firmware_t *f) {

  if (!validate_vtable(f)) {
    printf("vector table of the update is not valid\n\r", 0x0);
    return false;
  }

  uint32_t crc_result = crc_calc(f);
  printf("crc value is -> %\n\r", (uint32_t)(&crc_result));
  if (crc_result != f->__crc) {
    printf("CRC failed\n\r", 0x0);
    return false;
  }
  return true;
}
