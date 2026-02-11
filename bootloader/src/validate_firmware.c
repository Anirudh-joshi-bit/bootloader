#include "../include/commons.h"
#include <stdint.h>

bool validate_firmware(firmware_t *f) {

  uint32_t crc_result = crc_calc(f);
  printf ("crc value is -> %\n\r",(uint32_t)(&crc_result));
  return crc_result == f->__crc;
}
