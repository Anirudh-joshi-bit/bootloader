#include <stdint.h>

#define FLASH_ACR_RESET_VAL       0b0
#define FLASH_KEYR_RESET_VAL      0b0 
#define FLASH_OPTKEYR_RESET_VAL   0b0 
#define FLASH_SR_RESET_VAL        0b0  
#define FLASH_CR_RESET_VAL        (1U << 31) 
#define FLASH_OPTCR_RESET_VAL     0b00000000111111111010101011101101U

uint32_t erase_flash(uint32_t address);
uint32_t flash_write(uint32_t address, const char *buff, uint32_t size,
                     uint32_t simulate) ;
void flash_reg_reset (void);

