#include "../include/commons.h"
#include <stdint.h>

bool validate_firmware(firmware_t *f) {


  // uint32_t crc_result = crc_calc(f->__vtable_address, f->__firmware_end);
  // return crc_result == f->__crc;
  return true;
}
