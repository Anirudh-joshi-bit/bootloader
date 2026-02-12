STM32F401RE Bootloader
=====================

* This project implements a custom bare-metal bootloader for the STM32F401RE microcontroller, designed to enable reliable and power-loss-safe firmware updates. The bootloader directly manages internal flash memory  and prevents execution of incomplete or corrupted firmware images. On reset, it validates the application using onboard crc, safely reinitializes the stack pointer and vector table, and transfers control to the application if a valid image is present. The system is developed entirely from the STM32 reference manual without using vendor bootloader frameworks.

# Features

* Jump to a firmware (1 or 2)
* validate firmwae before running it
* update a firmware using USART 
* Logging using USART 
* Rollback system for reliable firmware update 
 

# Flash Layout

* Bootloader -> 64kB (`0x08000000`-`0x0800fffff`) (sector 1,2,3,4)
* Firmware1  -> 64kB (`0x08010000`-`0x0801ffff`)  (sector 5)
* Firmware2  -> 128kB (`0x08020000`-`0x0803ffff`) (sector 6)
* Update section -> 128kB (`0x08040000`-`0x0805ffff`) (sector 7)
* Copy section -> 128kB (`0x08060000`-`0x0807ffff`)   (sector 8)

# Boot Flow ->

* bootloader initiate `USART1`
* check if any firmware is corrupted (power loss while writing update to the firmware section)
* check if firmwares are valid or not
*  enable `EXTI15_10` interrupt
* wait for user input
        switch pressed once -> jump to Firmware1
        switch pressed twice -> jump to Firmware2
        switch pressed thrice -> wait for firmware update

# firmware update process ->
* recieve size of the update via `USART1`
* recieve the update and store it in `RAM`
* copy the update from RAM to UPDATE section in `FLASH`
* copy the current firmware to `COPY` section
* here comes the risky part !! ----> 
    copy update from `UPDATE` section to firmware section
    clear the flag (to let the next reset sequence know that firmware update is completed .. if not cleared the next reset sequence will conclude that firmware update was unsuccessfull because power lost while performing the risky part !!)

`printf ("update succfull !!!\n\r");`
    
* if the above message is not printed, the user need to reupload the update 
    
# Roll Back strategy ->
*    if flag is not cleared , old fimrware is retrieved from the COPY section . At the end of this operation flag is cleared

# Vector table sanity check ->
* 1. for update, flag must be 0xffffffff
* 2. MSP (first entry of vtable) must lie in the allowed RAM range
* 3. MSP must be word aligned (cortex M4 rule)
* 4. vtable must be 128byte aligned (for STM32F401RE)
* 5. all the vtable entries must store addresses that are in allowed range of FLASH
    

# firmware check mechanism ->
*   onboard CRC calculates the crc of firmwares and compares it aginst CRC present in their header
*   bootloader scans through the vector table and check for the validity of addresses (vtable entries)

# Application Jump Mechanism ->
*  mask all the maskable interrupt (so that interrupt cannot be triggered in between step 1 and step 2 )
*    step1. change MSP to the first entry of the vector table
*    step2. write the vector table address in VTOR regist in NVIC
*    step3. branch to the address specified in second entry of the vector table (Reset_Handler)

# Possible Improvements ->
*    Secure boot can be implemented using digital signature
*    Encripted firmware update


