#include "../include/commons.h"

extern volatile uint32_t press_count;
extern volatile uint32_t delay_count;
void switch_pressed(void){  
    // clear the pending status (not done by hardware)
    EXTI-> PR = EXTI_PR_PR13_Msk;

    press_count++;
    delay_count = 100;
}
