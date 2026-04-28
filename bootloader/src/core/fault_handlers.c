#include "core.h"
#include <stdint.h>


void fault_handler_helper(uint32_t pc, uint8_t fault_identifier,
                          uint32_t fault_place) {

  /* bus fault diagnosis */
  if (fault_identifier == BUSFAULT_IDENTIFIER) {
    printf("busdault !!\n\r", 0x0);
    if (SCB->CFSR & SCB_CFSR_BFARVALID_Msk)
      printf("busfault address -> %\n\r", (uint32_t)(&SCB->BFAR));
  }

  /* MemManagement diagnosis */
  else if (fault_identifier == MEMMANAGE_IDENTIFIER) {
    printf("MemManagement exception !!\n\r", 0x0);
    if (SCB->CFSR & SCB_CFSR_MMARVALID_Msk)
      printf("address caused MemManage Fault -> %\n\r", SCB->MMFAR);
  }

  /* UsageFault diagnosis */
  else if (fault_identifier == USAGEFAULT_IDENTIFIER) {
    printf("UsageFault !!\n\r", 0x0);
    /* there is no address access that can cause USAGE FAULT */
  } else {
    return;
  }

  uint32_t instruction = *(uint32_t *)(pc);

  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
         (uint32_t)(&SCB->CFSR));
  printf("PC -> %\n\r", (uint32_t)&pc);
  printf("instruction that caused the fault-> %\n\r", (uint32_t)(&instruction));


  /* cannot recover */
  while (1);


}

void HardFault_Handler_helper(uint32_t pc) {

  uint32_t instruction = *(uint32_t *)(pc);

  printf("HARD_FAULT !!!\n\r", 0x0);
  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
         (uint32_t)(&SCB->CFSR));
  printf("Hard Fault Status Register -> %\n\r", (uint32_t)(&SCB->HFSR));
  printf("PC -> %\n\r", (uint32_t)(&pc));
  printf("instruction that triggered HardFault -> %\n\r",
         (uint32_t)&instruction);

  /* cannot recover */
  while (1);

}
