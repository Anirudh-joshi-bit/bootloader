#pragma once
#include <stdint.h>

#define BUSFAULT_IDENTIFIER             0x0
#define MEMMANAGE_IDENTIFIER            0x1
#define USAGEFAULT_IDENTIFIER           0x2

#define FIRMWARE_1_ADDRESS 0x08004000     // sector 1, size = 112 KB
#define FIRMWARE_2_ADDRESS 0x08020000     // sector 5, size = 128 KB
#define SWITCH_PIN 13
#define LED_PIN 5
#define MAX_STR_SIZE 100
#define UPDATE_ADDR 0x08040000
#define COPY_ADDR 0x08060000
#define MAX_COMMAND_SIZE 10
#define DELAY 1000000000
#define NO_DELAY 0
#define WRITE_BUFF_SIZE 10*1024     // in bytes

typedef struct firmware_struct {
 

    volatile uint32_t __base_address;
    volatile uint32_t __flag;
    volatile uint32_t __crc;
    volatile uint32_t __vtable_end;
    volatile uint32_t __crc_start_addr;
    volatile uint32_t __vtable_address;
    volatile uint32_t __firmware_end;
    volatile uint32_t __firmware_size;
    volatile uint32_t __msp_value;
    volatile uint32_t __reset_handler;
    volatile uint32_t __crc_end_addr;

} firmware_t ;
