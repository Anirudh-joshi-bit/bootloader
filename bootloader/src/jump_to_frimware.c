        // 1. set msp
        // 2. set vtor
        // 3. call reset handler
        
#include "../include/commons.h"

extern volatile bool boot_f1;
extern volatile firmware_t  f1;
extern volatile firmware_t  f2;

void jump_to_firmware (){

    if (boot_f1){

        __set_MSP (f1.__msp_value);
        SCB-> VTOR = f1.__vtable_address;
        ((void(*)(void)) f1.__reset_handler) ();

    }
    else {
        __set_MSP (f2.__msp_value);
        SCB-> VTOR = f2.__vtable_address;
        ((void (*) (void)) f2.__reset_handler) ();
    }
}
