#include "../include/commons.h"

extern bool on_board_switch_falling;
void switch_on_isr(void) {

  if (on_board_switch_falling) {
    // switch is pressed !!!
    // on the led
    GPIOA->ODR |= 1 << LED_PIN;
  }
  else {
    // switch is released !!!!
    // off the led
    GPIOA->ODR &= ~(1 << LED_PIN);
  }
  on_board_switch_falling = !on_board_switch_falling;
}
