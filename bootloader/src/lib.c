#include "../include/commons.h"
#include <stdint.h>
#define TX_PIN 9
#define RX_PIN 10
#define KEY1 0x45670123
#define KEY2 0xCDEF89AB

extern char fw_update[MAX_FW_SIZE];
extern volatile uint32_t update_size;

uint32_t strlen(const char *msg) {

  int i = 0;
  while (msg[i++] != '\0')
    ;
  return i - 1;
}

void delay(uint32_t count) {

  while (count--)
    ;
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

  // enable usart
  USART1->CR1 |= USART_CR1_UE;
  // set the baud rate (115200 in this case)
  USART1->BRR = 0x08B;

  // enable transmitter and reciever at the end
  USART1->CR1 |= USART_CR1_RE | USART_CR1_TE;
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

  uint32_t msg_size = strlen(msg);
  for (; i < msg_size; i++) {

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

  if (simulate) {
    printf("heavy delay is used here .. press the reset button for simulating "
           "power off in this stage\n\r",
           0x0);
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
  FLASH->CR |= FLASH_CR_PG;
  FLASH->CR &= ~(3 << FLASH_CR_PSIZE_Pos);
  // set PSIZE bit to 2 for 32 bit programming
  FLASH->CR |= 2 << FLASH_CR_PSIZE_Pos;

  uint32_t i = 0;
  while (i < size / 4) {

    if (i == size / 8) {
      delay(simulate);
    }

    *((uint32_t *)address) = ((const uint32_t *)buff)[i];
    i++;
    address += 4;
  }
  FLASH->CR &= ~(FLASH_CR_PG);
  FLASH->CR |= FLASH_CR_LOCK;

  return 0;
}

uint32_t recieve_update() {
  printf("enter the size of the update....\n\r", 0x0);

  for (uint32_t it = 0; it < 6; it++) { // max 6 characters....
    while (!(USART1->SR & USART_SR_RXNE))
      ;
    char digit = USART1->DR;
    if (digit == '\0') {
      printf("got the size !! -> %\n\r", (uint32_t)(&update_size));
      break;
    }
    if (digit < '0' || digit > '9') {
      printf("wrong size !!!\n\r", 0x0);
      return -1;
    }
    update_size = update_size * 10 + (digit - '0');
  }
  if (update_size > MAX_FW_SIZE) {
    printf("too large firmware update size !!! \n\r", 0x0);
    return -1;
  }

  printf("waiting for firmware update\n\r", 0x0);
  uint32_t i = 0;
  while (i < update_size) {

    // wait
    while (!(USART1->SR & USART_SR_RXNE))
      ;
    fw_update[i++] = USART1->DR;
  }
  printf("data recieved !!! yehhhh \n\n\r", 0x0);
  return 0;
}

void rollback(void) {

  firmware_t old_f;
  // old firmware is present in the COPY_ADDR section
  init_firmware_t(COPY_ADDR, &old_f);

  printf("startign rollback\n\n\r", 0x0);
  erase_flash(old_f.__base_address);
  printf("corupted firmware is erased\n\r", 0x0);

  uint32_t copy_size =
      (*(uint32_t *)(COPY_ADDR + 0x14)) - (*(uint32_t *)(COPY_ADDR + 0x0c));
  flash_write(old_f.__base_address + 0x04, (const char *)(COPY_ADDR + 0x04),
              copy_size - 0x04, NO_DELAY);

  // word write => size would be 4 (not 2)
  const uint32_t end = 0xfffffffe;
  // &end is of type -> uint32_t * ==> need type conversion
  flash_write(old_f.__base_address,(const char *)(&end), 4, NO_DELAY);
  printf("new flag = %\n\r", old_f.__base_address);

  printf("done recovering old firmware \n\r", 0x0);
}
