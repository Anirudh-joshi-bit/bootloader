#pragma once

#include "defines.h"
#include "device/stm32f401xe.h"
#include <stdbool.h>

void printf(const char *msg, uint32_t address);
void __usart1_init(void);
void flash_write(const uint32_t *buff, uint32_t size, uint32_t sector,
                 uint32_t address);
