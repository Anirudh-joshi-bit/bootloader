#include <stdint.h>


void __usart1_scan (char* buffer, uint16_t size);
void __usart1_init(void);
void __usart1_print(const char *msg, uint32_t size);
void __usart1_reset_reg (void);
