#pragma once

#include <stddef.h>
#include <stdbool.h>
#include "device/stm32f401xe.h"
#include "defines.h"


// functions
void jump_to_firmware ();
bool validate_firmware (firmware_t *f);
uint32_t crc_calc (firmware_t *fw);
void printf (const char* msg, uint32_t addr);
uint32_t strlen (const char *msg);
uint32_t recieve_update (void);
void delay (uint32_t  count);
void rollback (void);
void init_firmware_t(uint32_t address, firmware_t *f);
