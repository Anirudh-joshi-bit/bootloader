#include "core.h"
#include "defines.h"
#include "flash.h"
#include "ring_buff.h"
#include "usart.h"

#include <stdint.h>

// extern char fw_update[MAX_FW_SIZE];
extern volatile uint32_t update_size;
extern volatile bool recieve_size;
extern volatile bool flag_size_recieved;
extern volatile bool flag_wrong_size;
extern volatile bool flag_too_big_update;
extern uint16_t wb_size;
static uint32_t update_section_end_address = UPDATE_ADDR;
extern volatile Ring_buff_t ringbuffer;
extern uint8_t write_buffer[WRITE_BUFF_SIZE];
volatile uint32_t fw_ar_ind = 0;

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

uint32_t recieve_update(void) {

  // recieve update size

  printf("enter the size of the update....\n\r", 0x0);
  update_size = 0;
  recieve_size = true;
  while (1) {
    if (flag_wrong_size) {
      printf("wrong size entered !!!\n\r", 0x0);
      return -1;
    }
    if (flag_too_big_update) {
      printf("update size cannot exceed 128KB \n\r", 0x0);
      return -1;
    }
    if (flag_size_recieved) {
      printf("update size recieved \n\r", 0x0);
      break;
    }
  }
  recieve_size = false;

  update_section_end_address = UPDATE_ADDR;

  // recieve firmware update !!
  while (update_section_end_address - UPDATE_ADDR < update_size) {
    while (Ring_buff_empty(&ringbuffer))
      ;
    //
    // problem
    uint16_t read_size = Ring_buff_read(&ringbuffer, write_buffer + wb_size,
                                        WRITE_BUFF_SIZE - wb_size);
    wb_size += read_size;

    uint16_t update_in_flash_size = update_section_end_address - UPDATE_ADDR;
    //
    if (wb_size == WRITE_BUFF_SIZE ||
        update_size - update_in_flash_size == wb_size) {
      // flash write, update end address, wb flush

      flash_write(update_section_end_address, write_buffer, wb_size, 0);

      update_section_end_address += wb_size;
      wb_size = 0;
    }
  }

  // while (fw_ar_ind < update_size);

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
  flash_write(old_f.__base_address, (const char *)(&end), 4, NO_DELAY);
  printf("new flag = %\n\r", old_f.__base_address);

  printf("done recovering old firmware \n\r", 0x0);
}
