#include "../include/commons.h"

char data[10];

int main() {
 
    __usart1_init ();
    data[1] = 'A';

    printf ("value stored in data[1] is -> %", (uint32_t)(data+1));



    while (1);
}
