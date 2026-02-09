#include "../include/commons.h"
#include <stdint.h>

bool validate_firmware(volatile firmware_t *f) {

  if (f->__flag & 1) {
    // firmware update is corrupted!!! => rollback
    // copy the old firmware (from COPY section) to firmware section

    printf("power lost during previous update !!\n\r", 0x0);
    printf("start recovering old firmware\n\r", 0x0);

    erase_flash(f->__base_address);

    // copy size will definitely be word aligned
    uint32_t copy_size =
        (*(uint32_t *)(COPY_ADDR + 0x14)) - (*(uint32_t *)(COPY_ADDR + 0x0c));
    flash_write(f->__base_address, (const char *)(COPY_ADDR), copy_size);
    
    const char end = 0xfe;
    flash_write (f->__base_address, &end, 1);
    printf ("new flag = %\n\r", f->__base_address);

    printf("done recovering old firmware\n\r", 0x0);
  }

  uint32_t crc_result = crc_calc(f->__vtable_address, f->__firmware_end);
  return crc_result == f->__crc;
}
