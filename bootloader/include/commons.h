#pragma once

#include <stdbool.h>
#include "device/stm32f401xe.h"
#include "defines.h"


// functions
void jump_to_firmware ();
bool validate_firmware (volatile firmware_t *f);
uint32_t crc_calc (volatile uint32_t base_addr, volatile uint32_t last_addr);
void __usart1_init (void);
void __usart1_print (const char *msg, uint32_t size);


