#pragma once 

#define SWITCH_PIN 13
#define LED_PIN 5


typedef struct firmware_struct {
    
    volatile uint32_t __base_address;
    volatile uint32_t __crc;
    volatile uint32_t __digital_signature;
    volatile uint32_t __firmware_size;
    volatile uint32_t __vtable_address;
    volatile uint32_t __last_address;
    volatile uint32_t __msp_value;
    volatile uint32_t __reset_handler;

} firmware_t ;
