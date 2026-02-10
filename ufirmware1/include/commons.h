#pragma once

#include <stdbool.h>
#include "device/stm32f401xe.h"
#include "defines.h"

void printf (const char *msg, uint32_t address);
void __usart1_init (void);
