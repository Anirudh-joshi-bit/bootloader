#include "../include/commons.h"

// refine !!!!

uint32_t crc_calc (firmware_t *fw){

    RCC-> AHB1ENR |= RCC_AHB1ENR_CRCEN;
    CRC-> CR |= CRC_CR_RESET;
    // last address is the next free address
    for (uint32_t i=fw->__crc_start_addr; i<fw->__crc_end_addr; i+=4){
        CRC-> DR = *((uint32_t*) i);
    }
    
    return CRC-> DR;
}
