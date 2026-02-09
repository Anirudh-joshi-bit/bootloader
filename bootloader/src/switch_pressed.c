#include "../include/commons.h"

/*_________________ switch pressed_________________*/
extern volatile uint32_t press_count;
extern volatile uint32_t delay_count;



void switch_pressed(void){  
    // clear the pending status (not done by hardware)
    EXTI-> PR = EXTI_PR_PR13_Msk;

    press_count++;
    if (press_count == 3){
        delay_count = 100;
        EXTI-> IMR &= ~EXTI_IMR_MR13_Msk;
    }
}
