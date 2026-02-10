#include "../include/commons.h"

uint32_t data[] = {
    10, 20, 30, 40, 50, 
    60, 70, 80, 90, 100
};

int main() {
 
    __usart1_init ();
    printf ("value stored in data[1] is -> %\n\r", (uint32_t)(data));
    
    flash_write (data, 10, 7, 0x08060000);

    while (1);
}
