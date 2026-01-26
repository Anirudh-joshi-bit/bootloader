#include "../include/commons.h"
volatile extern uint32_t delay_mag;
volatile extern uint32_t delay_mag_original;
volatile extern uint32_t levels;
volatile extern bool on_board_switch_falling;


void switch_on_isr(void) {

    if (levels == 6){
        delay_mag = delay_mag_original;
        levels = 1;
        return;
    }
    levels++;
    delay_mag -= 100000;
}
