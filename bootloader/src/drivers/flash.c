#include "stm32f401xe.h"
#include <stdint.h>

#define KEY1 0x45670123
#define KEY2 0xCDEF89AB

void printf (const char *string, uint32_t addr);

uint32_t erase_flash(uint32_t address) {
  if (address >= 0x08080000 || address < 0x08000000) {
    printf("wrong address \n\r", 0x0);
    return -1;
  }

  uint32_t sector = 0;
  if (address >= 0x08060000)
    sector = 7;
  else if (address >= 0x08040000)
    sector = 6;
  else if (address >= 0x08020000)
    sector = 5;
  else if (address >= 0x08010000)
    sector = 4;
  else if (address >= 0x0800c000)
    sector = 3;
  else if (address >= 0x08008000)
    sector = 2;
  else if (address >= 0x08004000)
    sector = 1;
  else if (address >= 0x08000000)
    sector = 0;
  else {
    printf("wrong address\n\r", 0x0);
    return -1;
  }
  // unlock
  FLASH->KEYR = KEY1;
  FLASH->KEYR = KEY2;

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
               FLASH_SR_OPERR |  // Operation error
               FLASH_SR_WRPERR | // Write protection error
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
    ;

  FLASH->CR |= FLASH_CR_SER;
  FLASH->CR &= ~(FLASH_CR_SNB);
  FLASH->CR |= (sector << FLASH_CR_SNB_Pos);
  FLASH->CR |= FLASH_CR_STRT;

  // wait for the flash to be erased;
  while (FLASH->SR & FLASH_SR_BSY)
    ;

  // clear the erase bit
  FLASH->CR &= ~(FLASH_CR_SER);
  // lock the control register
  FLASH->CR |= FLASH_CR_LOCK;

  printf("done erasing flash (address = %)\n\r", (uint32_t)(&address));
  return 0;
}

uint32_t flash_write(uint32_t address, const char *buff, uint32_t size,
                     uint32_t simulate) {


  // unlock
  FLASH->KEYR = KEY1;
  FLASH->KEYR = KEY2;

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
               FLASH_SR_OPERR |  // Operation error
               FLASH_SR_WRPERR | // Write protection error
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
    ;
  FLASH->CR |= FLASH_CR_PG;
  FLASH->CR &= ~(3 << FLASH_CR_PSIZE_Pos);
  // set PSIZE bit to 2 for 32 bit programming
  FLASH->CR |= 2 << FLASH_CR_PSIZE_Pos;

  uint32_t i = 0;
  while (i < size / 4) {

    *((uint32_t *)address) = ((const uint32_t *)buff)[i];
    i++;
    address += 4;
  }
  FLASH->CR &= ~(FLASH_CR_PG);
  FLASH->CR |= FLASH_CR_LOCK;

  return 0;
}
