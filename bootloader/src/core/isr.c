#include "core.h"
#include "ring_buff.h"
#include "stm32f401xe.h"

/*_________________ switch pressed_________________*/
extern volatile uint32_t press_count;
extern volatile uint32_t delay_count;
extern bool firmware_update_mode;
extern volatile uint32_t fw_ar_ind;

extern volatile uint32_t update_size;
extern volatile bool recieve_size;
extern volatile bool flag_size_recieved;
extern volatile bool flag_wrong_size;
extern volatile bool flag_too_big_update;
extern volatile Ring_buff_t ringbuffer;




void switch_pressed(void){  
    // clear the pending status (not done by hardware)
    EXTI-> PR = EXTI_PR_PR13_Msk;

    press_count++;
    if (press_count == 3){
        delay_count = 100;
        recieve_size = true;
        EXTI-> IMR &= ~EXTI_IMR_MR13_Msk;
    }
}
void USART1_IRQHandler (void){
  if (!firmware_update_mode) return;
  if (USART1 -> SR & USART_SR_RXNE_Msk){
    if (recieve_size){
      char digit = '\0';
      digit = USART1-> DR;
      if (digit == '\n'){
        flag_size_recieved = true;
        return;
      }
      if (digit < '0' || digit > '9'){
        flag_wrong_size = true;
        return;
      }
      if (update_size > 128*1024){
        flag_too_big_update = true;
        return;
      }
      update_size = update_size * 10 + (digit-'0');

    }
    else {
      // if (fw_ar_ind >= update_size)
      //   return;
      // fw_update [fw_ar_ind++] = USART1 -> DR;
      uint8_t data = USART1 -> DR;
      Ring_buff_write(&ringbuffer, &data, 1);
    }
  }
}

