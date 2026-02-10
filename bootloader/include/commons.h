#pragma once

#include <stddef.h>
#include <stdbool.h>
#include "device/stm32f401xe.h"
#include "defines.h"


// functions
void jump_to_firmware ();
bool validate_firmware (firmware_t *f);
uint32_t crc_calc (volatile uint32_t base_addr, volatile uint32_t last_addr);
void __usart1_init (void);
void __usart1_print (const char *msg, uint32_t size);
void printf (const char* msg, uint32_t addr);
uint32_t strlen (const char *msg);
uint32_t recieve_update (void);
uint32_t erase_flash (uint32_t address);
uint32_t flash_write (uint32_t dest, const char* src, uint32_t size, uint32_t delay);
void delay (uint32_t  count);
void rollback (void);
void init_firmware_t(uint32_t address, firmware_t *f);
