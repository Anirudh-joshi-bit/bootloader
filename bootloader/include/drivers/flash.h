#include <stdint.h>

uint32_t erase_flash(uint32_t address);
uint32_t flash_write(uint32_t address, const char *buff, uint32_t size,
                     uint32_t simulate) ;

