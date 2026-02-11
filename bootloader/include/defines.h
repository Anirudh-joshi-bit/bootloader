#pragma once


#define FIRMWARE_1_ADDRESS 0x08010000
#define FIRMWARE_2_ADDRESS 0x08020000
#define SWITCH_PIN 13
#define LED_PIN 5
#define MAX_STR_SIZE 100
#define UPDATE_ADDR 0x08040000
#define COPY_ADDR 0x08060000
#define MAX_FW_SIZE 6000            // max size = 6000 chars
#define MAX_COMMAND_SIZE 10
#define DELAY 1000000000
#define NO_DELAY 0


typedef struct firmware_struct {
 

    volatile uint32_t __base_address;
    volatile uint32_t __flag;
    volatile uint32_t __crc;
    volatile uint32_t __digital_signature;
    volatile uint32_t __crc_start_addr;
    volatile uint32_t __vtable_address;
    volatile uint32_t __firmware_end;
    volatile uint32_t __firmware_size;
    volatile uint32_t __msp_value;
    volatile uint32_t __reset_handler;

} firmware_t ;
