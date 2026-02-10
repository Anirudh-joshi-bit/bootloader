#include "../include/commons.h"
#define TX_PIN 9
#define RX_PIN 10
#define MAX_STR_SIZE 100
#define KEY1 0x45670123
#define KEY2 0xCDEF89AB

uint32_t strlen(const char *msg) {

  int i = 0;
  while (msg[i++] != '\0')
    ;
  return i - 1;
}

void __usart1_init(void) {

  RCC->APB2ENR |= RCC_APB2ENR_USART1EN_Msk;
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
  // alternate function mode
  GPIOA->MODER &= ~((3 << (2 * TX_PIN)) | (3 << (2 * RX_PIN)));
  GPIOA->MODER |= 2 << (2 * TX_PIN) | 2 << (2 * RX_PIN);
  // high speed
  GPIOA->OSPEEDR |= (3 << (TX_PIN * 2)) | (3 << (RX_PIN * 2));
  // clear the bits in AFR register
  GPIOA->AFR[1] &= ~((0xf << 4) | (0xf << 8));
  // set for af7
  GPIOA->AFR[1] |= (7 << 4) | (7 << 8);

  // enable usart, reciever, transiever
  USART1->CR1 |= USART_CR1_TE | USART_CR1_RE | USART_CR1_UE;
  // set the baud rate (115200 in this case)
  USART1->BRR = 0x08B;
}

void __usart1_print(const char *msg, uint32_t size) {

  int i = 0;
  while (i < size && msg[i] != '\0') {
    while (!(USART1->SR & USART_SR_TXE))
      ;
    USART1->DR = msg[i++];
  }
  while (!(USART1->SR & USART_SR_TC)) {
  }
}

char *hex_str(uint32_t value, char *out) {

  char hex_char[] = "0123456789abcdef";
  out[0] = '0';
  out[1] = 'x';

  for (int i = 0; i < 8; i++) {
    uint32_t ind = (value & (15 << (i * 4))) >> (i * 4);
    int j = 9 - i;
    out[j] = hex_char[ind];
  }
}

void printf(const char *msg, uint32_t address) {

  uint32_t value = *((uint32_t *)address);

  if (strlen(msg) + 9 > MAX_STR_SIZE) {
    __usart1_print("too large error message !!\n\r", MAX_STR_SIZE);
    return;
  }
  char hex[10];
  char __msg[MAX_STR_SIZE];

  uint32_t i = 0;
  int p = 0, q = 0;
  bool single_sub = false;

  for (; i < strlen(msg); i++) {

    if (msg[i] == '%' && !single_sub) {
      hex_str(value, hex);

      while (q - p < 10) {
        __msg[q++] = hex[q - p];
      }
      p++;
      single_sub = true;
    } else
      __msg[q++] = msg[p++];
  }
  __msg[q] = '\0';
  __usart1_print(__msg, strlen(__msg));
}

void flash_write(const uint32_t *buff, uint32_t size, uint32_t sector,
                 uint32_t address) {

  if (address % 4) {
    printf("invalid address\n\r", 0x0);
    return;
  }
  if (sector > 7 || sector < 0) { // there are 8 sectors
    printf("sector does not exist\n\r", 0x0);
    return;
  }
  FLASH->SR |= FLASH_SR_EOP |    // End of operation
               FLASH_SR_OPERR |  // Operation error
               FLASH_SR_WRPERR | // Write protection error
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error
  // unlock the flash control register
  FLASH->KEYR = KEY1;
  FLASH->KEYR = KEY2;

  // wait for FLASH to be idle
  while (FLASH->SR & FLASH_SR_BSY)
    ;

  // erase ------------------------------------------
  // set he SER bit -> sector erase
  FLASH->CR |= FLASH_CR_SER;
  FLASH->CR &= ~(FLASH_CR_SNB);
  FLASH->CR |= (sector << FLASH_CR_SNB_Pos);
  FLASH->CR |= FLASH_CR_STRT; // start erasing, self cleaning  !!!

  // wait for the flash to complete erasing
  while (FLASH->SR & FLASH_SR_BSY)
    ;

  // clear the erase bit
  FLASH->CR &= ~(FLASH_CR_SER);

  // programming --------------------------------------
  // set the psize-> 
  FLASH-> CR |= FLASH_CR_PSIZE_1;       // 32 bit write;
  // program the PG bit
  FLASH->CR |= FLASH_CR_PG;

  // write into the flash
  uint32_t i = 0;
  while (i < size) {
    while (FLASH->SR & FLASH_SR_BSY)
      ;
    *((uint32_t *)address) = buff[i++];
    address += 4;
  }
  printf("wrote to the flash \n\r", 0x0);
  // wait for the writing to be complete
  while (FLASH->SR & FLASH_SR_BSY)
    ;

  FLASH->CR &= ~(FLASH_CR_PG);
  FLASH->CR |= FLASH_CR_LOCK;
}
