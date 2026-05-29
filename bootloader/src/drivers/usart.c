#include <stdint.h>
#include "stm32f401xe.h"
#include "usart.h"

#define TX_PIN 9
#define RX_PIN 10

void __usart1_scan (char* buffer, uint16_t size){
  
  uint16_t i = 0;
  while (i < size) {
    // wait
    while (!(USART1->SR & USART_SR_RXNE))
      ;
    buffer[i++] = USART1->DR;
  }
}

void __usart1_init(void) {

  RCC->APB2ENR |= RCC_APB2ENR_USART1EN_Msk;
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
  // alternate function mode
  GPIOA->MODER &= ~((3 << (2 * TX_PIN)) | (3 << (2 * RX_PIN)));
  GPIOA->MODER |= 2 << (2 * TX_PIN) | 2 << (2 * RX_PIN);
  // high speed
  GPIOA->OSPEEDR |= (3 << (TX_PIN * 2)) | (3 << (RX_PIN * 2));
  // clear the bits in AFR register
  GPIOA->AFR[1] &= ~((0xf << 4) | (0xf << 8));
  // set for af7
  GPIOA->AFR[1] |= (7 << 4) | (7 << 8);

  // set the baud rate (115200 in this case)
  USART1->BRR = 0x08B;

  // enable usart reciever interrupt;
  USART1->CR1 = USART_CR1_RXNEIE;

  NVIC_EnableIRQ (USART1_IRQn);

  // enable transmitter and reciever at the end
  USART1->CR1 |= USART_CR1_RE | USART_CR1_TE;

  // enable usart
  USART1->CR1 |= USART_CR1_UE;

}

void __usart1_print(const char *msg, uint32_t size) {

  int i = 0;
  while (i < size && msg[i] != '\0') {
    while (!(USART1->SR & USART_SR_TXE))
      ;
    USART1->DR = msg[i++];
  }
  while (!(USART1->SR & USART_SR_TC)) {
  }
}


// reset the registers of usart1;
void __usart1_reset_reg (void){
  RCC->APB1RSTR |= RCC_APB1RSTR_USART2RST;
  RCC->APB1RSTR &= ~RCC_APB1RSTR_USART2RST;
}
