#include "../include/commons.h"

uint32_t crc_calc (volatile uint32_t base_addr, volatile uint32_t last_addr ){

    RCC-> AHB1ENR |= RCC_AHB1ENR_CRCEN;
    CRC-> CR |= CRC_CR_RESET;
    for (uint32_t i=base_addr; i<last_addr; i+=4){
        CRC-> DR = *((uint32_t*) i);
    }
    
    return CRC-> DR;
}
