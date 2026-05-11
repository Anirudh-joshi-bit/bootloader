
build/firmware.elf:     file format elf32-littlearm


Disassembly of section .text:

080000e4 <crc_calc>:
#include "core.h"

// refine !!!!

uint32_t crc_calc (firmware_t *fw){
 80000e4:	b480      	push	{r7}
 80000e6:	b085      	sub	sp, #20
 80000e8:	af00      	add	r7, sp, #0
 80000ea:	6078      	str	r0, [r7, #4]

    RCC-> AHB1ENR |= RCC_AHB1ENR_CRCEN;
 80000ec:	4b11      	ldr	r3, [pc, #68]	@ (8000134 <crc_calc+0x50>)
 80000ee:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 80000f0:	4a10      	ldr	r2, [pc, #64]	@ (8000134 <crc_calc+0x50>)
 80000f2:	f443 5380 	orr.w	r3, r3, #4096	@ 0x1000
 80000f6:	6313      	str	r3, [r2, #48]	@ 0x30
    CRC-> CR |= CRC_CR_RESET;
 80000f8:	4b0f      	ldr	r3, [pc, #60]	@ (8000138 <crc_calc+0x54>)
 80000fa:	689b      	ldr	r3, [r3, #8]
 80000fc:	4a0e      	ldr	r2, [pc, #56]	@ (8000138 <crc_calc+0x54>)
 80000fe:	f043 0301 	orr.w	r3, r3, #1
 8000102:	6093      	str	r3, [r2, #8]
    // last address is the next free address
    for (uint32_t i=fw->__crc_start_addr; i<fw->__crc_end_addr; i+=4){
 8000104:	687b      	ldr	r3, [r7, #4]
 8000106:	691b      	ldr	r3, [r3, #16]
 8000108:	60fb      	str	r3, [r7, #12]
 800010a:	e006      	b.n	800011a <crc_calc+0x36>
        CRC-> DR = *((uint32_t*) i);
 800010c:	68fb      	ldr	r3, [r7, #12]
 800010e:	4a0a      	ldr	r2, [pc, #40]	@ (8000138 <crc_calc+0x54>)
 8000110:	681b      	ldr	r3, [r3, #0]
 8000112:	6013      	str	r3, [r2, #0]
    for (uint32_t i=fw->__crc_start_addr; i<fw->__crc_end_addr; i+=4){
 8000114:	68fb      	ldr	r3, [r7, #12]
 8000116:	3304      	adds	r3, #4
 8000118:	60fb      	str	r3, [r7, #12]
 800011a:	687b      	ldr	r3, [r7, #4]
 800011c:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 800011e:	68fa      	ldr	r2, [r7, #12]
 8000120:	429a      	cmp	r2, r3
 8000122:	d3f3      	bcc.n	800010c <crc_calc+0x28>
    }
    
    return CRC-> DR;
 8000124:	4b04      	ldr	r3, [pc, #16]	@ (8000138 <crc_calc+0x54>)
 8000126:	681b      	ldr	r3, [r3, #0]
}
 8000128:	4618      	mov	r0, r3
 800012a:	3714      	adds	r7, #20
 800012c:	46bd      	mov	sp, r7
 800012e:	bc80      	pop	{r7}
 8000130:	4770      	bx	lr
 8000132:	bf00      	nop
 8000134:	40023800 	.word	0x40023800
 8000138:	40023000 	.word	0x40023000

0800013c <fault_handler_helper>:
#include "core.h"
#include <stdint.h>


void fault_handler_helper(uint32_t pc, uint8_t fault_identifier,
                          uint32_t fault_place) {
 800013c:	b580      	push	{r7, lr}
 800013e:	b086      	sub	sp, #24
 8000140:	af00      	add	r7, sp, #0
 8000142:	60f8      	str	r0, [r7, #12]
 8000144:	460b      	mov	r3, r1
 8000146:	607a      	str	r2, [r7, #4]
 8000148:	72fb      	strb	r3, [r7, #11]

  /* bus fault diagnosis */
  if (fault_identifier == BUSFAULT_IDENTIFIER) {
 800014a:	7afb      	ldrb	r3, [r7, #11]
 800014c:	2b00      	cmp	r3, #0
 800014e:	d10e      	bne.n	800016e <fault_handler_helper+0x32>
    printf("busdault !!\n\r", 0x0);
 8000150:	2100      	movs	r1, #0
 8000152:	4820      	ldr	r0, [pc, #128]	@ (80001d4 <fault_handler_helper+0x98>)
 8000154:	f000 fac0 	bl	80006d8 <printf>
    if (SCB->CFSR & SCB_CFSR_BFARVALID_Msk)
 8000158:	4b1f      	ldr	r3, [pc, #124]	@ (80001d8 <fault_handler_helper+0x9c>)
 800015a:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 800015c:	f403 4300 	and.w	r3, r3, #32768	@ 0x8000
 8000160:	2b00      	cmp	r3, #0
 8000162:	d01f      	beq.n	80001a4 <fault_handler_helper+0x68>
      printf("busfault address -> %\n\r", (uint32_t)(&SCB->BFAR));
 8000164:	491d      	ldr	r1, [pc, #116]	@ (80001dc <fault_handler_helper+0xa0>)
 8000166:	481e      	ldr	r0, [pc, #120]	@ (80001e0 <fault_handler_helper+0xa4>)
 8000168:	f000 fab6 	bl	80006d8 <printf>
 800016c:	e01a      	b.n	80001a4 <fault_handler_helper+0x68>
  }

  /* MemManagement diagnosis */
  else if (fault_identifier == MEMMANAGE_IDENTIFIER) {
 800016e:	7afb      	ldrb	r3, [r7, #11]
 8000170:	2b01      	cmp	r3, #1
 8000172:	d110      	bne.n	8000196 <fault_handler_helper+0x5a>
    printf("MemManagement exception !!\n\r", 0x0);
 8000174:	2100      	movs	r1, #0
 8000176:	481b      	ldr	r0, [pc, #108]	@ (80001e4 <fault_handler_helper+0xa8>)
 8000178:	f000 faae 	bl	80006d8 <printf>
    if (SCB->CFSR & SCB_CFSR_MMARVALID_Msk)
 800017c:	4b16      	ldr	r3, [pc, #88]	@ (80001d8 <fault_handler_helper+0x9c>)
 800017e:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 8000180:	f003 0380 	and.w	r3, r3, #128	@ 0x80
 8000184:	2b00      	cmp	r3, #0
 8000186:	d00d      	beq.n	80001a4 <fault_handler_helper+0x68>
      printf("address caused MemManage Fault -> %\n\r", SCB->MMFAR);
 8000188:	4b13      	ldr	r3, [pc, #76]	@ (80001d8 <fault_handler_helper+0x9c>)
 800018a:	6b5b      	ldr	r3, [r3, #52]	@ 0x34
 800018c:	4619      	mov	r1, r3
 800018e:	4816      	ldr	r0, [pc, #88]	@ (80001e8 <fault_handler_helper+0xac>)
 8000190:	f000 faa2 	bl	80006d8 <printf>
 8000194:	e006      	b.n	80001a4 <fault_handler_helper+0x68>
  }

  /* UsageFault diagnosis */
  else if (fault_identifier == USAGEFAULT_IDENTIFIER) {
 8000196:	7afb      	ldrb	r3, [r7, #11]
 8000198:	2b02      	cmp	r3, #2
 800019a:	d117      	bne.n	80001cc <fault_handler_helper+0x90>
    printf("UsageFault !!\n\r", 0x0);
 800019c:	2100      	movs	r1, #0
 800019e:	4813      	ldr	r0, [pc, #76]	@ (80001ec <fault_handler_helper+0xb0>)
 80001a0:	f000 fa9a 	bl	80006d8 <printf>
    /* there is no address access that can cause USAGE FAULT */
  } else {
    return;
  }

  uint32_t instruction = *(uint32_t *)(pc);
 80001a4:	68fb      	ldr	r3, [r7, #12]
 80001a6:	681b      	ldr	r3, [r3, #0]
 80001a8:	617b      	str	r3, [r7, #20]

  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
 80001aa:	4911      	ldr	r1, [pc, #68]	@ (80001f0 <fault_handler_helper+0xb4>)
 80001ac:	4811      	ldr	r0, [pc, #68]	@ (80001f4 <fault_handler_helper+0xb8>)
 80001ae:	f000 fa93 	bl	80006d8 <printf>
         (uint32_t)(&SCB->CFSR));
  printf("PC -> %\n\r", (uint32_t)&pc);
 80001b2:	f107 030c 	add.w	r3, r7, #12
 80001b6:	4619      	mov	r1, r3
 80001b8:	480f      	ldr	r0, [pc, #60]	@ (80001f8 <fault_handler_helper+0xbc>)
 80001ba:	f000 fa8d 	bl	80006d8 <printf>
  printf("instruction that caused the fault-> %\n\r", (uint32_t)(&instruction));
 80001be:	f107 0314 	add.w	r3, r7, #20
 80001c2:	4619      	mov	r1, r3
 80001c4:	480d      	ldr	r0, [pc, #52]	@ (80001fc <fault_handler_helper+0xc0>)
 80001c6:	f000 fa87 	bl	80006d8 <printf>


  /* cannot recover */
  while (1);
 80001ca:	e7fe      	b.n	80001ca <fault_handler_helper+0x8e>
    return;
 80001cc:	bf00      	nop


}
 80001ce:	3718      	adds	r7, #24
 80001d0:	46bd      	mov	sp, r7
 80001d2:	bd80      	pop	{r7, pc}
 80001d4:	08001518 	.word	0x08001518
 80001d8:	e000ed00 	.word	0xe000ed00
 80001dc:	e000ed38 	.word	0xe000ed38
 80001e0:	08001528 	.word	0x08001528
 80001e4:	08001540 	.word	0x08001540
 80001e8:	08001560 	.word	0x08001560
 80001ec:	08001588 	.word	0x08001588
 80001f0:	e000ed28 	.word	0xe000ed28
 80001f4:	08001598 	.word	0x08001598
 80001f8:	080015c8 	.word	0x080015c8
 80001fc:	080015d4 	.word	0x080015d4

08000200 <HardFault_Handler_helper>:

void HardFault_Handler_helper(uint32_t pc) {
 8000200:	b580      	push	{r7, lr}
 8000202:	b084      	sub	sp, #16
 8000204:	af00      	add	r7, sp, #0
 8000206:	6078      	str	r0, [r7, #4]

  uint32_t instruction = *(uint32_t *)(pc);
 8000208:	687b      	ldr	r3, [r7, #4]
 800020a:	681b      	ldr	r3, [r3, #0]
 800020c:	60fb      	str	r3, [r7, #12]

  printf("HARD_FAULT !!!\n\r", 0x0);
 800020e:	2100      	movs	r1, #0
 8000210:	480b      	ldr	r0, [pc, #44]	@ (8000240 <HardFault_Handler_helper+0x40>)
 8000212:	f000 fa61 	bl	80006d8 <printf>
  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
 8000216:	490b      	ldr	r1, [pc, #44]	@ (8000244 <HardFault_Handler_helper+0x44>)
 8000218:	480b      	ldr	r0, [pc, #44]	@ (8000248 <HardFault_Handler_helper+0x48>)
 800021a:	f000 fa5d 	bl	80006d8 <printf>
         (uint32_t)(&SCB->CFSR));
  printf("Hard Fault Status Register -> %\n\r", (uint32_t)(&SCB->HFSR));
 800021e:	490b      	ldr	r1, [pc, #44]	@ (800024c <HardFault_Handler_helper+0x4c>)
 8000220:	480b      	ldr	r0, [pc, #44]	@ (8000250 <HardFault_Handler_helper+0x50>)
 8000222:	f000 fa59 	bl	80006d8 <printf>
  printf("PC -> %\n\r", (uint32_t)(&pc));
 8000226:	1d3b      	adds	r3, r7, #4
 8000228:	4619      	mov	r1, r3
 800022a:	480a      	ldr	r0, [pc, #40]	@ (8000254 <HardFault_Handler_helper+0x54>)
 800022c:	f000 fa54 	bl	80006d8 <printf>
  printf("instruction that triggered HardFault -> %\n\r",
 8000230:	f107 030c 	add.w	r3, r7, #12
 8000234:	4619      	mov	r1, r3
 8000236:	4808      	ldr	r0, [pc, #32]	@ (8000258 <HardFault_Handler_helper+0x58>)
 8000238:	f000 fa4e 	bl	80006d8 <printf>
         (uint32_t)&instruction);

  /* cannot recover */
  while (1);
 800023c:	e7fe      	b.n	800023c <HardFault_Handler_helper+0x3c>
 800023e:	bf00      	nop
 8000240:	080015fc 	.word	0x080015fc
 8000244:	e000ed28 	.word	0xe000ed28
 8000248:	08001598 	.word	0x08001598
 800024c:	e000ed2c 	.word	0xe000ed2c
 8000250:	08001610 	.word	0x08001610
 8000254:	080015c8 	.word	0x080015c8
 8000258:	08001634 	.word	0x08001634

0800025c <__NVIC_DisableIRQ>:
  \details Disables a device specific interrupt in the NVIC interrupt controller.
  \param [in]      IRQn  Device specific interrupt number.
  \note    IRQn must not be negative.
 */
__STATIC_INLINE void __NVIC_DisableIRQ(IRQn_Type IRQn)
{
 800025c:	b480      	push	{r7}
 800025e:	b083      	sub	sp, #12
 8000260:	af00      	add	r7, sp, #0
 8000262:	4603      	mov	r3, r0
 8000264:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 8000266:	f997 3007 	ldrsb.w	r3, [r7, #7]
 800026a:	2b00      	cmp	r3, #0
 800026c:	db12      	blt.n	8000294 <__NVIC_DisableIRQ+0x38>
  {
    NVIC->ICER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 800026e:	79fb      	ldrb	r3, [r7, #7]
 8000270:	f003 021f 	and.w	r2, r3, #31
 8000274:	490a      	ldr	r1, [pc, #40]	@ (80002a0 <__NVIC_DisableIRQ+0x44>)
 8000276:	f997 3007 	ldrsb.w	r3, [r7, #7]
 800027a:	095b      	lsrs	r3, r3, #5
 800027c:	2001      	movs	r0, #1
 800027e:	fa00 f202 	lsl.w	r2, r0, r2
 8000282:	3320      	adds	r3, #32
 8000284:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
  \details Acts as a special kind of Data Memory Barrier.
           It completes when all explicit memory accesses before this instruction complete.
 */
__STATIC_FORCEINLINE void __DSB(void)
{
  __ASM volatile ("dsb 0xF":::"memory");
 8000288:	f3bf 8f4f 	dsb	sy
}
 800028c:	bf00      	nop
  __ASM volatile ("isb 0xF":::"memory");
 800028e:	f3bf 8f6f 	isb	sy
}
 8000292:	bf00      	nop
    __DSB();
    __ISB();
  }
}
 8000294:	bf00      	nop
 8000296:	370c      	adds	r7, #12
 8000298:	46bd      	mov	sp, r7
 800029a:	bc80      	pop	{r7}
 800029c:	4770      	bx	lr
 800029e:	bf00      	nop
 80002a0:	e000e100 	.word	0xe000e100

080002a4 <jump_to_firmware>:

extern volatile bool boot_f1;
extern volatile firmware_t f1;
extern volatile firmware_t f2;

void jump_to_firmware() {
 80002a4:	b580      	push	{r7, lr}
 80002a6:	b084      	sub	sp, #16
 80002a8:	af00      	add	r7, sp, #0
  \details Disables IRQ interrupts by setting special-purpose register PRIMASK.
           Can only be executed in Privileged modes.
 */
__STATIC_FORCEINLINE void __disable_irq(void)
{
  __ASM volatile ("cpsid i" : : : "memory");
 80002aa:	b672      	cpsid	i
}
 80002ac:	bf00      	nop

  __disable_irq();
  if (boot_f1) {
 80002ae:	4b2c      	ldr	r3, [pc, #176]	@ (8000360 <jump_to_firmware+0xbc>)
 80002b0:	781b      	ldrb	r3, [r3, #0]
 80002b2:	b2db      	uxtb	r3, r3
 80002b4:	2b00      	cmp	r3, #0
 80002b6:	d027      	beq.n	8000308 <jump_to_firmware+0x64>
    printf("jumping to firmware1 \n\r", 0x0);
 80002b8:	2100      	movs	r1, #0
 80002ba:	482a      	ldr	r0, [pc, #168]	@ (8000364 <jump_to_firmware+0xc0>)
 80002bc:	f000 fa0c 	bl	80006d8 <printf>

    NVIC_DisableIRQ(EXTI15_10_IRQn);
 80002c0:	2028      	movs	r0, #40	@ 0x28
 80002c2:	f7ff ffcb 	bl	800025c <__NVIC_DisableIRQ>
    // below this point no other interrupt can be pended !
    for (uint8_t i = 0; i < 8; i++) {
 80002c6:	2300      	movs	r3, #0
 80002c8:	73fb      	strb	r3, [r7, #15]
 80002ca:	e009      	b.n	80002e0 <jump_to_firmware+0x3c>
      NVIC->ICPR[i] = 0xffffffff;
 80002cc:	4a26      	ldr	r2, [pc, #152]	@ (8000368 <jump_to_firmware+0xc4>)
 80002ce:	7bfb      	ldrb	r3, [r7, #15]
 80002d0:	3360      	adds	r3, #96	@ 0x60
 80002d2:	f04f 31ff 	mov.w	r1, #4294967295	@ 0xffffffff
 80002d6:	f842 1023 	str.w	r1, [r2, r3, lsl #2]
    for (uint8_t i = 0; i < 8; i++) {
 80002da:	7bfb      	ldrb	r3, [r7, #15]
 80002dc:	3301      	adds	r3, #1
 80002de:	73fb      	strb	r3, [r7, #15]
 80002e0:	7bfb      	ldrb	r3, [r7, #15]
 80002e2:	2b07      	cmp	r3, #7
 80002e4:	d9f2      	bls.n	80002cc <jump_to_firmware+0x28>
    }

    __set_MSP(f1.__msp_value);
 80002e6:	4b21      	ldr	r3, [pc, #132]	@ (800036c <jump_to_firmware+0xc8>)
 80002e8:	6a1b      	ldr	r3, [r3, #32]
 80002ea:	60bb      	str	r3, [r7, #8]
  \details Assigns the given value to the Main Stack Pointer (MSP).
  \param [in]    topOfMainStack  Main Stack Pointer value to set
 */
__STATIC_FORCEINLINE void __set_MSP(uint32_t topOfMainStack)
{
  __ASM volatile ("MSR msp, %0" : : "r" (topOfMainStack) : );
 80002ec:	68bb      	ldr	r3, [r7, #8]
 80002ee:	f383 8808 	msr	MSP, r3
}
 80002f2:	bf00      	nop
    SCB->VTOR = f1.__vtable_address;
 80002f4:	4a1e      	ldr	r2, [pc, #120]	@ (8000370 <jump_to_firmware+0xcc>)
 80002f6:	4b1d      	ldr	r3, [pc, #116]	@ (800036c <jump_to_firmware+0xc8>)
 80002f8:	695b      	ldr	r3, [r3, #20]
 80002fa:	6093      	str	r3, [r2, #8]
  __ASM volatile ("cpsie i" : : : "memory");
 80002fc:	b662      	cpsie	i
}
 80002fe:	bf00      	nop
    // before calling the reset handler, enable irqs
    __enable_irq();
    ((void (*)(void))f1.__reset_handler)();
 8000300:	4b1a      	ldr	r3, [pc, #104]	@ (800036c <jump_to_firmware+0xc8>)
 8000302:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000304:	4798      	blx	r3
    SCB->VTOR = f2.__vtable_address;
    // before jumping the reset handler, enable irqs
    __enable_irq();
    ((void (*)(void))f2.__reset_handler)();
  }
}
 8000306:	e026      	b.n	8000356 <jump_to_firmware+0xb2>
    printf("jumping to firmware2 \n\r", 0x0);
 8000308:	2100      	movs	r1, #0
 800030a:	481a      	ldr	r0, [pc, #104]	@ (8000374 <jump_to_firmware+0xd0>)
 800030c:	f000 f9e4 	bl	80006d8 <printf>
    NVIC_DisableIRQ(EXTI15_10_IRQn);
 8000310:	2028      	movs	r0, #40	@ 0x28
 8000312:	f7ff ffa3 	bl	800025c <__NVIC_DisableIRQ>
    for (uint8_t i = 0; i < 8; i++) {
 8000316:	2300      	movs	r3, #0
 8000318:	73bb      	strb	r3, [r7, #14]
 800031a:	e009      	b.n	8000330 <jump_to_firmware+0x8c>
      NVIC->ICPR[i] = 0xffffffff;
 800031c:	4a12      	ldr	r2, [pc, #72]	@ (8000368 <jump_to_firmware+0xc4>)
 800031e:	7bbb      	ldrb	r3, [r7, #14]
 8000320:	3360      	adds	r3, #96	@ 0x60
 8000322:	f04f 31ff 	mov.w	r1, #4294967295	@ 0xffffffff
 8000326:	f842 1023 	str.w	r1, [r2, r3, lsl #2]
    for (uint8_t i = 0; i < 8; i++) {
 800032a:	7bbb      	ldrb	r3, [r7, #14]
 800032c:	3301      	adds	r3, #1
 800032e:	73bb      	strb	r3, [r7, #14]
 8000330:	7bbb      	ldrb	r3, [r7, #14]
 8000332:	2b07      	cmp	r3, #7
 8000334:	d9f2      	bls.n	800031c <jump_to_firmware+0x78>
    __set_MSP(f2.__msp_value);
 8000336:	4b10      	ldr	r3, [pc, #64]	@ (8000378 <jump_to_firmware+0xd4>)
 8000338:	6a1b      	ldr	r3, [r3, #32]
 800033a:	607b      	str	r3, [r7, #4]
  __ASM volatile ("MSR msp, %0" : : "r" (topOfMainStack) : );
 800033c:	687b      	ldr	r3, [r7, #4]
 800033e:	f383 8808 	msr	MSP, r3
}
 8000342:	bf00      	nop
    SCB->VTOR = f2.__vtable_address;
 8000344:	4a0a      	ldr	r2, [pc, #40]	@ (8000370 <jump_to_firmware+0xcc>)
 8000346:	4b0c      	ldr	r3, [pc, #48]	@ (8000378 <jump_to_firmware+0xd4>)
 8000348:	695b      	ldr	r3, [r3, #20]
 800034a:	6093      	str	r3, [r2, #8]
  __ASM volatile ("cpsie i" : : : "memory");
 800034c:	b662      	cpsie	i
}
 800034e:	bf00      	nop
    ((void (*)(void))f2.__reset_handler)();
 8000350:	4b09      	ldr	r3, [pc, #36]	@ (8000378 <jump_to_firmware+0xd4>)
 8000352:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000354:	4798      	blx	r3
}
 8000356:	bf00      	nop
 8000358:	3710      	adds	r7, #16
 800035a:	46bd      	mov	sp, r7
 800035c:	bd80      	pop	{r7, pc}
 800035e:	bf00      	nop
 8000360:	20000004 	.word	0x20000004
 8000364:	08001660 	.word	0x08001660
 8000368:	e000e100 	.word	0xe000e100
 800036c:	20000008 	.word	0x20000008
 8000370:	e000ed00 	.word	0xe000ed00
 8000374:	08001678 	.word	0x08001678
 8000378:	20000034 	.word	0x20000034

0800037c <Ring_buff_init>:
#include "ring_buff.h"
#include <stdint.h>
#include <stdbool.h>

void Ring_buff_init(volatile Ring_buff_t *rb) {
 800037c:	b480      	push	{r7}
 800037e:	b083      	sub	sp, #12
 8000380:	af00      	add	r7, sp, #0
 8000382:	6078      	str	r0, [r7, #4]
  rb->rear = 0;
 8000384:	687b      	ldr	r3, [r7, #4]
 8000386:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 800038a:	2200      	movs	r2, #0
 800038c:	f8a3 2800 	strh.w	r2, [r3, #2048]	@ 0x800
  rb->front = 0;
 8000390:	687b      	ldr	r3, [r7, #4]
 8000392:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000396:	2200      	movs	r2, #0
 8000398:	f8a3 2802 	strh.w	r2, [r3, #2050]	@ 0x802
}
 800039c:	bf00      	nop
 800039e:	370c      	adds	r7, #12
 80003a0:	46bd      	mov	sp, r7
 80003a2:	bc80      	pop	{r7}
 80003a4:	4770      	bx	lr

080003a6 <Ring_buff_empty>:
bool Ring_buff_empty (volatile Ring_buff_t* rb){
 80003a6:	b480      	push	{r7}
 80003a8:	b083      	sub	sp, #12
 80003aa:	af00      	add	r7, sp, #0
 80003ac:	6078      	str	r0, [r7, #4]
  return rb->front == rb->rear;
 80003ae:	687b      	ldr	r3, [r7, #4]
 80003b0:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 80003b4:	f8b3 3802 	ldrh.w	r3, [r3, #2050]	@ 0x802
 80003b8:	b29a      	uxth	r2, r3
 80003ba:	687b      	ldr	r3, [r7, #4]
 80003bc:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 80003c0:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 80003c4:	b29b      	uxth	r3, r3
 80003c6:	429a      	cmp	r2, r3
 80003c8:	bf0c      	ite	eq
 80003ca:	2301      	moveq	r3, #1
 80003cc:	2300      	movne	r3, #0
 80003ce:	b2db      	uxtb	r3, r3
}
 80003d0:	4618      	mov	r0, r3
 80003d2:	370c      	adds	r7, #12
 80003d4:	46bd      	mov	sp, r7
 80003d6:	bc80      	pop	{r7}
 80003d8:	4770      	bx	lr

080003da <Ring_buff_size>:
uint16_t Ring_buff_size (volatile Ring_buff_t* rb){
 80003da:	b480      	push	{r7}
 80003dc:	b085      	sub	sp, #20
 80003de:	af00      	add	r7, sp, #0
 80003e0:	6078      	str	r0, [r7, #4]
  uint16_t local_front = rb-> front;
 80003e2:	687b      	ldr	r3, [r7, #4]
 80003e4:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 80003e8:	f8b3 3802 	ldrh.w	r3, [r3, #2050]	@ 0x802
 80003ec:	81fb      	strh	r3, [r7, #14]
  uint16_t local_rear = rb-> rear;
 80003ee:	687b      	ldr	r3, [r7, #4]
 80003f0:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 80003f4:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 80003f8:	81bb      	strh	r3, [r7, #12]

  if (local_front <= local_rear){
 80003fa:	89fa      	ldrh	r2, [r7, #14]
 80003fc:	89bb      	ldrh	r3, [r7, #12]
 80003fe:	429a      	cmp	r2, r3
 8000400:	d804      	bhi.n	800040c <Ring_buff_size+0x32>
    return local_rear - local_front;
 8000402:	89ba      	ldrh	r2, [r7, #12]
 8000404:	89fb      	ldrh	r3, [r7, #14]
 8000406:	1ad3      	subs	r3, r2, r3
 8000408:	b29b      	uxth	r3, r3
 800040a:	e006      	b.n	800041a <Ring_buff_size+0x40>
  }
  return RING_BUFF_SIZE - local_front + local_rear;
 800040c:	89ba      	ldrh	r2, [r7, #12]
 800040e:	89fb      	ldrh	r3, [r7, #14]
 8000410:	1ad3      	subs	r3, r2, r3
 8000412:	b29b      	uxth	r3, r3
 8000414:	f503 5320 	add.w	r3, r3, #10240	@ 0x2800
 8000418:	b29b      	uxth	r3, r3
} 
 800041a:	4618      	mov	r0, r3
 800041c:	3714      	adds	r7, #20
 800041e:	46bd      	mov	sp, r7
 8000420:	bc80      	pop	{r7}
 8000422:	4770      	bx	lr

08000424 <Ring_buff_write>:

// the below functions should only be called by isr
// Use only REAR for write . donot read / write FRONT
// if ring buffer of overwhelmed ... then increase the size of Ringbuffer

void Ring_buff_write(volatile Ring_buff_t *rb, uint8_t *buff, uint16_t size) {
 8000424:	b480      	push	{r7}
 8000426:	b087      	sub	sp, #28
 8000428:	af00      	add	r7, sp, #0
 800042a:	60f8      	str	r0, [r7, #12]
 800042c:	60b9      	str	r1, [r7, #8]
 800042e:	4613      	mov	r3, r2
 8000430:	80fb      	strh	r3, [r7, #6]
  // data can be overwritten ... if this happens -> increase the size of the ring buffer
  
  uint16_t local_rear = rb->rear;
 8000432:	68fb      	ldr	r3, [r7, #12]
 8000434:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000438:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 800043c:	82fb      	strh	r3, [r7, #22]

  for (uint16_t ind = 0; ind < size; ind ++){
 800043e:	2300      	movs	r3, #0
 8000440:	82bb      	strh	r3, [r7, #20]
 8000442:	e012      	b.n	800046a <Ring_buff_write+0x46>
    rb-> buffer[local_rear] = buff [ind];
 8000444:	8abb      	ldrh	r3, [r7, #20]
 8000446:	68ba      	ldr	r2, [r7, #8]
 8000448:	441a      	add	r2, r3
 800044a:	8afb      	ldrh	r3, [r7, #22]
 800044c:	7811      	ldrb	r1, [r2, #0]
 800044e:	68fa      	ldr	r2, [r7, #12]
 8000450:	54d1      	strb	r1, [r2, r3]
    local_rear ++;
 8000452:	8afb      	ldrh	r3, [r7, #22]
 8000454:	3301      	adds	r3, #1
 8000456:	82fb      	strh	r3, [r7, #22]
    if (local_rear == RING_BUFF_SIZE)
 8000458:	8afb      	ldrh	r3, [r7, #22]
 800045a:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 800045e:	d101      	bne.n	8000464 <Ring_buff_write+0x40>
      local_rear = 0;
 8000460:	2300      	movs	r3, #0
 8000462:	82fb      	strh	r3, [r7, #22]
  for (uint16_t ind = 0; ind < size; ind ++){
 8000464:	8abb      	ldrh	r3, [r7, #20]
 8000466:	3301      	adds	r3, #1
 8000468:	82bb      	strh	r3, [r7, #20]
 800046a:	8aba      	ldrh	r2, [r7, #20]
 800046c:	88fb      	ldrh	r3, [r7, #6]
 800046e:	429a      	cmp	r2, r3
 8000470:	d3e8      	bcc.n	8000444 <Ring_buff_write+0x20>
  }

  rb-> rear = local_rear; 
 8000472:	68fb      	ldr	r3, [r7, #12]
 8000474:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000478:	461a      	mov	r2, r3
 800047a:	8afb      	ldrh	r3, [r7, #22]
 800047c:	f8a2 3800 	strh.w	r3, [r2, #2048]	@ 0x800
}
 8000480:	bf00      	nop
 8000482:	371c      	adds	r7, #28
 8000484:	46bd      	mov	sp, r7
 8000486:	bc80      	pop	{r7}
 8000488:	4770      	bx	lr

0800048a <Ring_buff_read>:

// read the whole Ring_buffer
uint16_t Ring_buff_read(volatile Ring_buff_t *rb, uint8_t *buff,
                        uint16_t buff_size) {
 800048a:	b480      	push	{r7}
 800048c:	b087      	sub	sp, #28
 800048e:	af00      	add	r7, sp, #0
 8000490:	60f8      	str	r0, [r7, #12]
 8000492:	60b9      	str	r1, [r7, #8]
 8000494:	4613      	mov	r3, r2
 8000496:	80fb      	strh	r3, [r7, #6]

  uint16_t local_front = rb->front;
 8000498:	68fb      	ldr	r3, [r7, #12]
 800049a:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 800049e:	f8b3 3802 	ldrh.w	r3, [r3, #2050]	@ 0x802
 80004a2:	82fb      	strh	r3, [r7, #22]
  uint16_t local_rear = rb->rear;
 80004a4:	68fb      	ldr	r3, [r7, #12]
 80004a6:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 80004aa:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 80004ae:	827b      	strh	r3, [r7, #18]

  uint16_t ind = 0;
 80004b0:	2300      	movs	r3, #0
 80004b2:	82bb      	strh	r3, [r7, #20]

  while (ind < buff_size && local_front != local_rear){
 80004b4:	e013      	b.n	80004de <Ring_buff_read+0x54>
    buff[ind] = rb-> buffer[local_front];
 80004b6:	8afa      	ldrh	r2, [r7, #22]
 80004b8:	8abb      	ldrh	r3, [r7, #20]
 80004ba:	68b9      	ldr	r1, [r7, #8]
 80004bc:	440b      	add	r3, r1
 80004be:	68f9      	ldr	r1, [r7, #12]
 80004c0:	5c8a      	ldrb	r2, [r1, r2]
 80004c2:	b2d2      	uxtb	r2, r2
 80004c4:	701a      	strb	r2, [r3, #0]
    local_front ++;
 80004c6:	8afb      	ldrh	r3, [r7, #22]
 80004c8:	3301      	adds	r3, #1
 80004ca:	82fb      	strh	r3, [r7, #22]
    if (local_front == RING_BUFF_SIZE)
 80004cc:	8afb      	ldrh	r3, [r7, #22]
 80004ce:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 80004d2:	d101      	bne.n	80004d8 <Ring_buff_read+0x4e>
      local_front = 0;
 80004d4:	2300      	movs	r3, #0
 80004d6:	82fb      	strh	r3, [r7, #22]
    ind ++;
 80004d8:	8abb      	ldrh	r3, [r7, #20]
 80004da:	3301      	adds	r3, #1
 80004dc:	82bb      	strh	r3, [r7, #20]
  while (ind < buff_size && local_front != local_rear){
 80004de:	8aba      	ldrh	r2, [r7, #20]
 80004e0:	88fb      	ldrh	r3, [r7, #6]
 80004e2:	429a      	cmp	r2, r3
 80004e4:	d203      	bcs.n	80004ee <Ring_buff_read+0x64>
 80004e6:	8afa      	ldrh	r2, [r7, #22]
 80004e8:	8a7b      	ldrh	r3, [r7, #18]
 80004ea:	429a      	cmp	r2, r3
 80004ec:	d1e3      	bne.n	80004b6 <Ring_buff_read+0x2c>
  }

  rb->front = local_front;
 80004ee:	68fb      	ldr	r3, [r7, #12]
 80004f0:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 80004f4:	461a      	mov	r2, r3
 80004f6:	8afb      	ldrh	r3, [r7, #22]
 80004f8:	f8a2 3802 	strh.w	r3, [r2, #2050]	@ 0x802

  return ind;
 80004fc:	8abb      	ldrh	r3, [r7, #20]
}
 80004fe:	4618      	mov	r0, r3
 8000500:	371c      	adds	r7, #28
 8000502:	46bd      	mov	sp, r7
 8000504:	bc80      	pop	{r7}
 8000506:	4770      	bx	lr

08000508 <switch_pressed>:
extern volatile Ring_buff_t ringbuffer;




void switch_pressed(void){  
 8000508:	b480      	push	{r7}
 800050a:	af00      	add	r7, sp, #0
    // clear the pending status (not done by hardware)
    EXTI-> PR = EXTI_PR_PR13_Msk;
 800050c:	4b0b      	ldr	r3, [pc, #44]	@ (800053c <switch_pressed+0x34>)
 800050e:	f44f 5200 	mov.w	r2, #8192	@ 0x2000
 8000512:	615a      	str	r2, [r3, #20]

    press_count++;
 8000514:	4b0a      	ldr	r3, [pc, #40]	@ (8000540 <switch_pressed+0x38>)
 8000516:	681b      	ldr	r3, [r3, #0]
 8000518:	3301      	adds	r3, #1
 800051a:	4a09      	ldr	r2, [pc, #36]	@ (8000540 <switch_pressed+0x38>)
 800051c:	6013      	str	r3, [r2, #0]
    if (press_count == 3){
 800051e:	4b08      	ldr	r3, [pc, #32]	@ (8000540 <switch_pressed+0x38>)
 8000520:	681b      	ldr	r3, [r3, #0]
 8000522:	2b03      	cmp	r3, #3
 8000524:	d105      	bne.n	8000532 <switch_pressed+0x2a>
        delay_count = 100;
 8000526:	4b07      	ldr	r3, [pc, #28]	@ (8000544 <switch_pressed+0x3c>)
 8000528:	2264      	movs	r2, #100	@ 0x64
 800052a:	601a      	str	r2, [r3, #0]
        recieve_size = true;
 800052c:	4b06      	ldr	r3, [pc, #24]	@ (8000548 <switch_pressed+0x40>)
 800052e:	2201      	movs	r2, #1
 8000530:	701a      	strb	r2, [r3, #0]
        //EXTI-> IMR &= ~EXTI_IMR_MR13_Msk;
    }
}
 8000532:	bf00      	nop
 8000534:	46bd      	mov	sp, r7
 8000536:	bc80      	pop	{r7}
 8000538:	4770      	bx	lr
 800053a:	bf00      	nop
 800053c:	40013c00 	.word	0x40013c00
 8000540:	20000060 	.word	0x20000060
 8000544:	20000064 	.word	0x20000064
 8000548:	20005078 	.word	0x20005078

0800054c <USART1_IRQHandler>:
void USART1_IRQHandler (void){
 800054c:	b580      	push	{r7, lr}
 800054e:	b082      	sub	sp, #8
 8000550:	af00      	add	r7, sp, #0
  if (!firmware_update_mode) return;
 8000552:	4b26      	ldr	r3, [pc, #152]	@ (80005ec <USART1_IRQHandler+0xa0>)
 8000554:	781b      	ldrb	r3, [r3, #0]
 8000556:	f083 0301 	eor.w	r3, r3, #1
 800055a:	b2db      	uxtb	r3, r3
 800055c:	2b00      	cmp	r3, #0
 800055e:	d141      	bne.n	80005e4 <USART1_IRQHandler+0x98>
  if (USART1 -> SR & USART_SR_RXNE_Msk){
 8000560:	4b23      	ldr	r3, [pc, #140]	@ (80005f0 <USART1_IRQHandler+0xa4>)
 8000562:	681b      	ldr	r3, [r3, #0]
 8000564:	f003 0320 	and.w	r3, r3, #32
 8000568:	2b00      	cmp	r3, #0
 800056a:	d03c      	beq.n	80005e6 <USART1_IRQHandler+0x9a>
    if (recieve_size){
 800056c:	4b21      	ldr	r3, [pc, #132]	@ (80005f4 <USART1_IRQHandler+0xa8>)
 800056e:	781b      	ldrb	r3, [r3, #0]
 8000570:	b2db      	uxtb	r3, r3
 8000572:	2b00      	cmp	r3, #0
 8000574:	d02b      	beq.n	80005ce <USART1_IRQHandler+0x82>
      char digit = '\0';
 8000576:	2300      	movs	r3, #0
 8000578:	71fb      	strb	r3, [r7, #7]
      digit = USART1-> DR;
 800057a:	4b1d      	ldr	r3, [pc, #116]	@ (80005f0 <USART1_IRQHandler+0xa4>)
 800057c:	685b      	ldr	r3, [r3, #4]
 800057e:	71fb      	strb	r3, [r7, #7]
      if (digit == '\n'){
 8000580:	79fb      	ldrb	r3, [r7, #7]
 8000582:	2b0a      	cmp	r3, #10
 8000584:	d103      	bne.n	800058e <USART1_IRQHandler+0x42>
        flag_size_recieved = true;
 8000586:	4b1c      	ldr	r3, [pc, #112]	@ (80005f8 <USART1_IRQHandler+0xac>)
 8000588:	2201      	movs	r2, #1
 800058a:	701a      	strb	r2, [r3, #0]
        return;
 800058c:	e02b      	b.n	80005e6 <USART1_IRQHandler+0x9a>
      }
      if (digit < '0' || digit > '9'){
 800058e:	79fb      	ldrb	r3, [r7, #7]
 8000590:	2b2f      	cmp	r3, #47	@ 0x2f
 8000592:	d902      	bls.n	800059a <USART1_IRQHandler+0x4e>
 8000594:	79fb      	ldrb	r3, [r7, #7]
 8000596:	2b39      	cmp	r3, #57	@ 0x39
 8000598:	d903      	bls.n	80005a2 <USART1_IRQHandler+0x56>
        flag_wrong_size = true;
 800059a:	4b18      	ldr	r3, [pc, #96]	@ (80005fc <USART1_IRQHandler+0xb0>)
 800059c:	2201      	movs	r2, #1
 800059e:	701a      	strb	r2, [r3, #0]
        return;
 80005a0:	e021      	b.n	80005e6 <USART1_IRQHandler+0x9a>
      }
      if (update_size > 128*1024){
 80005a2:	4b17      	ldr	r3, [pc, #92]	@ (8000600 <USART1_IRQHandler+0xb4>)
 80005a4:	681b      	ldr	r3, [r3, #0]
 80005a6:	f5b3 3f00 	cmp.w	r3, #131072	@ 0x20000
 80005aa:	d903      	bls.n	80005b4 <USART1_IRQHandler+0x68>
        flag_too_big_update = true;
 80005ac:	4b15      	ldr	r3, [pc, #84]	@ (8000604 <USART1_IRQHandler+0xb8>)
 80005ae:	2201      	movs	r2, #1
 80005b0:	701a      	strb	r2, [r3, #0]
        return;
 80005b2:	e018      	b.n	80005e6 <USART1_IRQHandler+0x9a>
      }
      update_size = update_size * 10 + (digit-'0');
 80005b4:	4b12      	ldr	r3, [pc, #72]	@ (8000600 <USART1_IRQHandler+0xb4>)
 80005b6:	681a      	ldr	r2, [r3, #0]
 80005b8:	4613      	mov	r3, r2
 80005ba:	009b      	lsls	r3, r3, #2
 80005bc:	4413      	add	r3, r2
 80005be:	005b      	lsls	r3, r3, #1
 80005c0:	461a      	mov	r2, r3
 80005c2:	79fb      	ldrb	r3, [r7, #7]
 80005c4:	4413      	add	r3, r2
 80005c6:	3b30      	subs	r3, #48	@ 0x30
 80005c8:	4a0d      	ldr	r2, [pc, #52]	@ (8000600 <USART1_IRQHandler+0xb4>)
 80005ca:	6013      	str	r3, [r2, #0]
 80005cc:	e00b      	b.n	80005e6 <USART1_IRQHandler+0x9a>
    }
    else {
      // if (fw_ar_ind >= update_size)
      //   return;
      // fw_update [fw_ar_ind++] = USART1 -> DR;
      uint8_t data = USART1 -> DR;
 80005ce:	4b08      	ldr	r3, [pc, #32]	@ (80005f0 <USART1_IRQHandler+0xa4>)
 80005d0:	685b      	ldr	r3, [r3, #4]
 80005d2:	b2db      	uxtb	r3, r3
 80005d4:	71bb      	strb	r3, [r7, #6]
      Ring_buff_write(&ringbuffer, &data, 1);
 80005d6:	1dbb      	adds	r3, r7, #6
 80005d8:	2201      	movs	r2, #1
 80005da:	4619      	mov	r1, r3
 80005dc:	480a      	ldr	r0, [pc, #40]	@ (8000608 <USART1_IRQHandler+0xbc>)
 80005de:	f7ff ff21 	bl	8000424 <Ring_buff_write>
 80005e2:	e000      	b.n	80005e6 <USART1_IRQHandler+0x9a>
  if (!firmware_update_mode) return;
 80005e4:	bf00      	nop
    }
  }
}
 80005e6:	3708      	adds	r7, #8
 80005e8:	46bd      	mov	sp, r7
 80005ea:	bd80      	pop	{r7, pc}
 80005ec:	20005076 	.word	0x20005076
 80005f0:	40011000 	.word	0x40011000
 80005f4:	20005078 	.word	0x20005078
 80005f8:	20005079 	.word	0x20005079
 80005fc:	2000507a 	.word	0x2000507a
 8000600:	2000006c 	.word	0x2000006c
 8000604:	2000507b 	.word	0x2000507b
 8000608:	20000070 	.word	0x20000070

0800060c <strlen>:
uint32_t update_section_end_address = UPDATE_ADDR;
extern volatile Ring_buff_t ringbuffer;
extern uint8_t write_buffer[WRITE_BUFF_SIZE];
volatile uint32_t fw_ar_ind = 0;

uint32_t strlen(const char *msg) {
 800060c:	b480      	push	{r7}
 800060e:	b085      	sub	sp, #20
 8000610:	af00      	add	r7, sp, #0
 8000612:	6078      	str	r0, [r7, #4]

  int i = 0;
 8000614:	2300      	movs	r3, #0
 8000616:	60fb      	str	r3, [r7, #12]
  while (msg[i++] != '\0')
 8000618:	bf00      	nop
 800061a:	68fb      	ldr	r3, [r7, #12]
 800061c:	1c5a      	adds	r2, r3, #1
 800061e:	60fa      	str	r2, [r7, #12]
 8000620:	461a      	mov	r2, r3
 8000622:	687b      	ldr	r3, [r7, #4]
 8000624:	4413      	add	r3, r2
 8000626:	781b      	ldrb	r3, [r3, #0]
 8000628:	2b00      	cmp	r3, #0
 800062a:	d1f6      	bne.n	800061a <strlen+0xe>
    ;
  return i - 1;
 800062c:	68fb      	ldr	r3, [r7, #12]
 800062e:	3b01      	subs	r3, #1
}
 8000630:	4618      	mov	r0, r3
 8000632:	3714      	adds	r7, #20
 8000634:	46bd      	mov	sp, r7
 8000636:	bc80      	pop	{r7}
 8000638:	4770      	bx	lr

0800063a <delay>:

void delay(uint32_t count) {
 800063a:	b480      	push	{r7}
 800063c:	b083      	sub	sp, #12
 800063e:	af00      	add	r7, sp, #0
 8000640:	6078      	str	r0, [r7, #4]

  while (count--)
 8000642:	bf00      	nop
 8000644:	687b      	ldr	r3, [r7, #4]
 8000646:	1e5a      	subs	r2, r3, #1
 8000648:	607a      	str	r2, [r7, #4]
 800064a:	2b00      	cmp	r3, #0
 800064c:	d1fa      	bne.n	8000644 <delay+0xa>
    ;
}
 800064e:	bf00      	nop
 8000650:	bf00      	nop
 8000652:	370c      	adds	r7, #12
 8000654:	46bd      	mov	sp, r7
 8000656:	bc80      	pop	{r7}
 8000658:	4770      	bx	lr

0800065a <hex_str>:
char *hex_str(uint32_t value, char *out) {
 800065a:	b4b0      	push	{r4, r5, r7}
 800065c:	b08b      	sub	sp, #44	@ 0x2c
 800065e:	af00      	add	r7, sp, #0
 8000660:	6078      	str	r0, [r7, #4]
 8000662:	6039      	str	r1, [r7, #0]

  char hex_char[] = "0123456789abcdef";
 8000664:	4b1b      	ldr	r3, [pc, #108]	@ (80006d4 <hex_str+0x7a>)
 8000666:	f107 0408 	add.w	r4, r7, #8
 800066a:	461d      	mov	r5, r3
 800066c:	cd0f      	ldmia	r5!, {r0, r1, r2, r3}
 800066e:	c40f      	stmia	r4!, {r0, r1, r2, r3}
 8000670:	682b      	ldr	r3, [r5, #0]
 8000672:	7023      	strb	r3, [r4, #0]
  out[0] = '0';
 8000674:	683b      	ldr	r3, [r7, #0]
 8000676:	2230      	movs	r2, #48	@ 0x30
 8000678:	701a      	strb	r2, [r3, #0]
  out[1] = 'x';
 800067a:	683b      	ldr	r3, [r7, #0]
 800067c:	3301      	adds	r3, #1
 800067e:	2278      	movs	r2, #120	@ 0x78
 8000680:	701a      	strb	r2, [r3, #0]

  for (int i = 0; i < 8; i++) {
 8000682:	2300      	movs	r3, #0
 8000684:	627b      	str	r3, [r7, #36]	@ 0x24
 8000686:	e01c      	b.n	80006c2 <hex_str+0x68>
    uint32_t ind = (value & (15 << (i * 4))) >> (i * 4);
 8000688:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800068a:	009b      	lsls	r3, r3, #2
 800068c:	220f      	movs	r2, #15
 800068e:	fa02 f303 	lsl.w	r3, r2, r3
 8000692:	461a      	mov	r2, r3
 8000694:	687b      	ldr	r3, [r7, #4]
 8000696:	401a      	ands	r2, r3
 8000698:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800069a:	009b      	lsls	r3, r3, #2
 800069c:	fa22 f303 	lsr.w	r3, r2, r3
 80006a0:	623b      	str	r3, [r7, #32]
    int j = 9 - i;
 80006a2:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80006a4:	f1c3 0309 	rsb	r3, r3, #9
 80006a8:	61fb      	str	r3, [r7, #28]
    out[j] = hex_char[ind];
 80006aa:	69fb      	ldr	r3, [r7, #28]
 80006ac:	683a      	ldr	r2, [r7, #0]
 80006ae:	4413      	add	r3, r2
 80006b0:	f107 0108 	add.w	r1, r7, #8
 80006b4:	6a3a      	ldr	r2, [r7, #32]
 80006b6:	440a      	add	r2, r1
 80006b8:	7812      	ldrb	r2, [r2, #0]
 80006ba:	701a      	strb	r2, [r3, #0]
  for (int i = 0; i < 8; i++) {
 80006bc:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80006be:	3301      	adds	r3, #1
 80006c0:	627b      	str	r3, [r7, #36]	@ 0x24
 80006c2:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80006c4:	2b07      	cmp	r3, #7
 80006c6:	dddf      	ble.n	8000688 <hex_str+0x2e>
  }
}
 80006c8:	bf00      	nop
 80006ca:	4618      	mov	r0, r3
 80006cc:	372c      	adds	r7, #44	@ 0x2c
 80006ce:	46bd      	mov	sp, r7
 80006d0:	bcb0      	pop	{r4, r5, r7}
 80006d2:	4770      	bx	lr
 80006d4:	08001690 	.word	0x08001690

080006d8 <printf>:

void printf(const char *msg, uint32_t address) {
 80006d8:	b580      	push	{r7, lr}
 80006da:	b0a4      	sub	sp, #144	@ 0x90
 80006dc:	af00      	add	r7, sp, #0
 80006de:	6078      	str	r0, [r7, #4]
 80006e0:	6039      	str	r1, [r7, #0]

  uint32_t value = *((uint32_t *)address);
 80006e2:	683b      	ldr	r3, [r7, #0]
 80006e4:	681b      	ldr	r3, [r3, #0]
 80006e6:	67fb      	str	r3, [r7, #124]	@ 0x7c

  if (strlen(msg) + 9 > MAX_STR_SIZE) {
 80006e8:	6878      	ldr	r0, [r7, #4]
 80006ea:	f7ff ff8f 	bl	800060c <strlen>
 80006ee:	4603      	mov	r3, r0
 80006f0:	3309      	adds	r3, #9
 80006f2:	2b64      	cmp	r3, #100	@ 0x64
 80006f4:	d904      	bls.n	8000700 <printf+0x28>
    __usart1_print("too large error message !!\n\r", MAX_STR_SIZE);
 80006f6:	2164      	movs	r1, #100	@ 0x64
 80006f8:	483e      	ldr	r0, [pc, #248]	@ (80007f4 <printf+0x11c>)
 80006fa:	f000 fe7f 	bl	80013fc <__usart1_print>
 80006fe:	e076      	b.n	80007ee <printf+0x116>
    return;
  }
  char hex[10];
  char __msg[MAX_STR_SIZE];

  uint32_t i = 0;
 8000700:	2300      	movs	r3, #0
 8000702:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
  int p = 0, q = 0;
 8000706:	2300      	movs	r3, #0
 8000708:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
 800070c:	2300      	movs	r3, #0
 800070e:	f8c7 3084 	str.w	r3, [r7, #132]	@ 0x84
  bool single_sub = false;
 8000712:	2300      	movs	r3, #0
 8000714:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83

  uint32_t msg_size = strlen(msg);
 8000718:	6878      	ldr	r0, [r7, #4]
 800071a:	f7ff ff77 	bl	800060c <strlen>
 800071e:	67b8      	str	r0, [r7, #120]	@ 0x78
  for (; i < msg_size; i++) {
 8000720:	e04d      	b.n	80007be <printf+0xe6>

    if (msg[i] == '%' && !single_sub) {
 8000722:	687a      	ldr	r2, [r7, #4]
 8000724:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 8000728:	4413      	add	r3, r2
 800072a:	781b      	ldrb	r3, [r3, #0]
 800072c:	2b25      	cmp	r3, #37	@ 0x25
 800072e:	d12f      	bne.n	8000790 <printf+0xb8>
 8000730:	f897 3083 	ldrb.w	r3, [r7, #131]	@ 0x83
 8000734:	f083 0301 	eor.w	r3, r3, #1
 8000738:	b2db      	uxtb	r3, r3
 800073a:	2b00      	cmp	r3, #0
 800073c:	d028      	beq.n	8000790 <printf+0xb8>
      hex_str(value, hex);
 800073e:	f107 036c 	add.w	r3, r7, #108	@ 0x6c
 8000742:	4619      	mov	r1, r3
 8000744:	6ff8      	ldr	r0, [r7, #124]	@ 0x7c
 8000746:	f7ff ff88 	bl	800065a <hex_str>

      while (q - p < 10) {
 800074a:	e011      	b.n	8000770 <printf+0x98>
        __msg[q++] = hex[q - p];
 800074c:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 8000750:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000754:	1ad2      	subs	r2, r2, r3
 8000756:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 800075a:	1c59      	adds	r1, r3, #1
 800075c:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 8000760:	3290      	adds	r2, #144	@ 0x90
 8000762:	443a      	add	r2, r7
 8000764:	f812 2c24 	ldrb.w	r2, [r2, #-36]
 8000768:	3390      	adds	r3, #144	@ 0x90
 800076a:	443b      	add	r3, r7
 800076c:	f803 2c88 	strb.w	r2, [r3, #-136]
      while (q - p < 10) {
 8000770:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 8000774:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000778:	1ad3      	subs	r3, r2, r3
 800077a:	2b09      	cmp	r3, #9
 800077c:	dde6      	ble.n	800074c <printf+0x74>
      }
      p++;
 800077e:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000782:	3301      	adds	r3, #1
 8000784:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
      single_sub = true;
 8000788:	2301      	movs	r3, #1
 800078a:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83
 800078e:	e011      	b.n	80007b4 <printf+0xdc>
    } else
      __msg[q++] = msg[p++];
 8000790:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000794:	1c5a      	adds	r2, r3, #1
 8000796:	f8c7 2088 	str.w	r2, [r7, #136]	@ 0x88
 800079a:	461a      	mov	r2, r3
 800079c:	687b      	ldr	r3, [r7, #4]
 800079e:	441a      	add	r2, r3
 80007a0:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 80007a4:	1c59      	adds	r1, r3, #1
 80007a6:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 80007aa:	7812      	ldrb	r2, [r2, #0]
 80007ac:	3390      	adds	r3, #144	@ 0x90
 80007ae:	443b      	add	r3, r7
 80007b0:	f803 2c88 	strb.w	r2, [r3, #-136]
  for (; i < msg_size; i++) {
 80007b4:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 80007b8:	3301      	adds	r3, #1
 80007ba:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
 80007be:	f8d7 208c 	ldr.w	r2, [r7, #140]	@ 0x8c
 80007c2:	6fbb      	ldr	r3, [r7, #120]	@ 0x78
 80007c4:	429a      	cmp	r2, r3
 80007c6:	d3ac      	bcc.n	8000722 <printf+0x4a>
  }
  __msg[q] = '\0';
 80007c8:	f107 0208 	add.w	r2, r7, #8
 80007cc:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 80007d0:	4413      	add	r3, r2
 80007d2:	2200      	movs	r2, #0
 80007d4:	701a      	strb	r2, [r3, #0]
  __usart1_print(__msg, strlen(__msg));
 80007d6:	f107 0308 	add.w	r3, r7, #8
 80007da:	4618      	mov	r0, r3
 80007dc:	f7ff ff16 	bl	800060c <strlen>
 80007e0:	4602      	mov	r2, r0
 80007e2:	f107 0308 	add.w	r3, r7, #8
 80007e6:	4611      	mov	r1, r2
 80007e8:	4618      	mov	r0, r3
 80007ea:	f000 fe07 	bl	80013fc <__usart1_print>
}
 80007ee:	3790      	adds	r7, #144	@ 0x90
 80007f0:	46bd      	mov	sp, r7
 80007f2:	bd80      	pop	{r7, pc}
 80007f4:	080016a4 	.word	0x080016a4

080007f8 <recieve_update>:
//   }
//   printf("data recieved !!! yehhhh \n\n\r", 0x0);
//   return 0;
// }

uint32_t recieve_update(void) {
 80007f8:	b580      	push	{r7, lr}
 80007fa:	b082      	sub	sp, #8
 80007fc:	af00      	add	r7, sp, #0

  // recieve update size

  printf("enter the size of the update....\n\r", 0x0);
 80007fe:	2100      	movs	r1, #0
 8000800:	483e      	ldr	r0, [pc, #248]	@ (80008fc <recieve_update+0x104>)
 8000802:	f7ff ff69 	bl	80006d8 <printf>

  recieve_size = true;
 8000806:	4b3e      	ldr	r3, [pc, #248]	@ (8000900 <recieve_update+0x108>)
 8000808:	2201      	movs	r2, #1
 800080a:	701a      	strb	r2, [r3, #0]
  while (1) {
    if (flag_wrong_size) {
 800080c:	4b3d      	ldr	r3, [pc, #244]	@ (8000904 <recieve_update+0x10c>)
 800080e:	781b      	ldrb	r3, [r3, #0]
 8000810:	b2db      	uxtb	r3, r3
 8000812:	2b00      	cmp	r3, #0
 8000814:	d006      	beq.n	8000824 <recieve_update+0x2c>
      printf("wrong size entered !!!\n\r", 0x0);
 8000816:	2100      	movs	r1, #0
 8000818:	483b      	ldr	r0, [pc, #236]	@ (8000908 <recieve_update+0x110>)
 800081a:	f7ff ff5d 	bl	80006d8 <printf>
      return -1;
 800081e:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 8000822:	e066      	b.n	80008f2 <recieve_update+0xfa>
    }
    if (flag_too_big_update) {
 8000824:	4b39      	ldr	r3, [pc, #228]	@ (800090c <recieve_update+0x114>)
 8000826:	781b      	ldrb	r3, [r3, #0]
 8000828:	b2db      	uxtb	r3, r3
 800082a:	2b00      	cmp	r3, #0
 800082c:	d006      	beq.n	800083c <recieve_update+0x44>
      printf("update size cannot exceed 128KB \n\r", 0x0);
 800082e:	2100      	movs	r1, #0
 8000830:	4837      	ldr	r0, [pc, #220]	@ (8000910 <recieve_update+0x118>)
 8000832:	f7ff ff51 	bl	80006d8 <printf>
      return -1;
 8000836:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 800083a:	e05a      	b.n	80008f2 <recieve_update+0xfa>
    }
    if (flag_size_recieved) {
 800083c:	4b35      	ldr	r3, [pc, #212]	@ (8000914 <recieve_update+0x11c>)
 800083e:	781b      	ldrb	r3, [r3, #0]
 8000840:	b2db      	uxtb	r3, r3
 8000842:	2b00      	cmp	r3, #0
 8000844:	d0e2      	beq.n	800080c <recieve_update+0x14>
      printf("update size recieved \n\r", 0x0);
 8000846:	2100      	movs	r1, #0
 8000848:	4833      	ldr	r0, [pc, #204]	@ (8000918 <recieve_update+0x120>)
 800084a:	f7ff ff45 	bl	80006d8 <printf>
      break;
 800084e:	bf00      	nop
    }
  }
  recieve_size = false;
 8000850:	4b2b      	ldr	r3, [pc, #172]	@ (8000900 <recieve_update+0x108>)
 8000852:	2200      	movs	r2, #0
 8000854:	701a      	strb	r2, [r3, #0]

  // recieve firmware update !!
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 8000856:	e041      	b.n	80008dc <recieve_update+0xe4>
    while (Ring_buff_empty(&ringbuffer))
 8000858:	bf00      	nop
 800085a:	4830      	ldr	r0, [pc, #192]	@ (800091c <recieve_update+0x124>)
 800085c:	f7ff fda3 	bl	80003a6 <Ring_buff_empty>
 8000860:	4603      	mov	r3, r0
 8000862:	2b00      	cmp	r3, #0
 8000864:	d1f9      	bne.n	800085a <recieve_update+0x62>
      ;
    //
    // problem
    uint16_t read_size = Ring_buff_read(&ringbuffer, write_buffer + wb_size,
 8000866:	4b2e      	ldr	r3, [pc, #184]	@ (8000920 <recieve_update+0x128>)
 8000868:	881b      	ldrh	r3, [r3, #0]
 800086a:	461a      	mov	r2, r3
 800086c:	4b2d      	ldr	r3, [pc, #180]	@ (8000924 <recieve_update+0x12c>)
 800086e:	18d1      	adds	r1, r2, r3
 8000870:	4b2b      	ldr	r3, [pc, #172]	@ (8000920 <recieve_update+0x128>)
 8000872:	881b      	ldrh	r3, [r3, #0]
 8000874:	f5c3 5320 	rsb	r3, r3, #10240	@ 0x2800
 8000878:	b29b      	uxth	r3, r3
 800087a:	461a      	mov	r2, r3
 800087c:	4827      	ldr	r0, [pc, #156]	@ (800091c <recieve_update+0x124>)
 800087e:	f7ff fe04 	bl	800048a <Ring_buff_read>
 8000882:	4603      	mov	r3, r0
 8000884:	80fb      	strh	r3, [r7, #6]
                                        WRITE_BUFF_SIZE - wb_size);
    wb_size += read_size;
 8000886:	4b26      	ldr	r3, [pc, #152]	@ (8000920 <recieve_update+0x128>)
 8000888:	881a      	ldrh	r2, [r3, #0]
 800088a:	88fb      	ldrh	r3, [r7, #6]
 800088c:	4413      	add	r3, r2
 800088e:	b29a      	uxth	r2, r3
 8000890:	4b23      	ldr	r3, [pc, #140]	@ (8000920 <recieve_update+0x128>)
 8000892:	801a      	strh	r2, [r3, #0]

    uint16_t update_in_flash_size = update_section_end_address - UPDATE_ADDR;
 8000894:	4b24      	ldr	r3, [pc, #144]	@ (8000928 <recieve_update+0x130>)
 8000896:	681b      	ldr	r3, [r3, #0]
 8000898:	80bb      	strh	r3, [r7, #4]
    //
    if (wb_size == WRITE_BUFF_SIZE ||
 800089a:	4b21      	ldr	r3, [pc, #132]	@ (8000920 <recieve_update+0x128>)
 800089c:	881b      	ldrh	r3, [r3, #0]
 800089e:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 80008a2:	d007      	beq.n	80008b4 <recieve_update+0xbc>
        update_size - update_in_flash_size == wb_size) {
 80008a4:	4b21      	ldr	r3, [pc, #132]	@ (800092c <recieve_update+0x134>)
 80008a6:	681a      	ldr	r2, [r3, #0]
 80008a8:	88bb      	ldrh	r3, [r7, #4]
 80008aa:	1ad3      	subs	r3, r2, r3
 80008ac:	4a1c      	ldr	r2, [pc, #112]	@ (8000920 <recieve_update+0x128>)
 80008ae:	8812      	ldrh	r2, [r2, #0]
    if (wb_size == WRITE_BUFF_SIZE ||
 80008b0:	4293      	cmp	r3, r2
 80008b2:	d113      	bne.n	80008dc <recieve_update+0xe4>
      // flash write, update end address, wb flush

      flash_write(update_section_end_address, write_buffer, wb_size, 0);
 80008b4:	4b1c      	ldr	r3, [pc, #112]	@ (8000928 <recieve_update+0x130>)
 80008b6:	6818      	ldr	r0, [r3, #0]
 80008b8:	4b19      	ldr	r3, [pc, #100]	@ (8000920 <recieve_update+0x128>)
 80008ba:	881b      	ldrh	r3, [r3, #0]
 80008bc:	461a      	mov	r2, r3
 80008be:	2300      	movs	r3, #0
 80008c0:	4918      	ldr	r1, [pc, #96]	@ (8000924 <recieve_update+0x12c>)
 80008c2:	f000 fcb5 	bl	8001230 <flash_write>

      update_section_end_address += wb_size;
 80008c6:	4b16      	ldr	r3, [pc, #88]	@ (8000920 <recieve_update+0x128>)
 80008c8:	881b      	ldrh	r3, [r3, #0]
 80008ca:	461a      	mov	r2, r3
 80008cc:	4b16      	ldr	r3, [pc, #88]	@ (8000928 <recieve_update+0x130>)
 80008ce:	681b      	ldr	r3, [r3, #0]
 80008d0:	4413      	add	r3, r2
 80008d2:	4a15      	ldr	r2, [pc, #84]	@ (8000928 <recieve_update+0x130>)
 80008d4:	6013      	str	r3, [r2, #0]
      wb_size = 0;
 80008d6:	4b12      	ldr	r3, [pc, #72]	@ (8000920 <recieve_update+0x128>)
 80008d8:	2200      	movs	r2, #0
 80008da:	801a      	strh	r2, [r3, #0]
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 80008dc:	4b12      	ldr	r3, [pc, #72]	@ (8000928 <recieve_update+0x130>)
 80008de:	681b      	ldr	r3, [r3, #0]
 80008e0:	f103 4377 	add.w	r3, r3, #4143972352	@ 0xf7000000
 80008e4:	f503 037c 	add.w	r3, r3, #16515072	@ 0xfc0000
 80008e8:	4a10      	ldr	r2, [pc, #64]	@ (800092c <recieve_update+0x134>)
 80008ea:	6812      	ldr	r2, [r2, #0]
 80008ec:	4293      	cmp	r3, r2
 80008ee:	d3b3      	bcc.n	8000858 <recieve_update+0x60>
    }
  }

  // while (fw_ar_ind < update_size);

  return 0;
 80008f0:	2300      	movs	r3, #0
}
 80008f2:	4618      	mov	r0, r3
 80008f4:	3708      	adds	r7, #8
 80008f6:	46bd      	mov	sp, r7
 80008f8:	bd80      	pop	{r7, pc}
 80008fa:	bf00      	nop
 80008fc:	080016c4 	.word	0x080016c4
 8000900:	20005078 	.word	0x20005078
 8000904:	2000507a 	.word	0x2000507a
 8000908:	080016e8 	.word	0x080016e8
 800090c:	2000507b 	.word	0x2000507b
 8000910:	08001704 	.word	0x08001704
 8000914:	20005079 	.word	0x20005079
 8000918:	08001728 	.word	0x08001728
 800091c:	20000070 	.word	0x20000070
 8000920:	20005074 	.word	0x20005074
 8000924:	20002874 	.word	0x20002874
 8000928:	20000000 	.word	0x20000000
 800092c:	2000006c 	.word	0x2000006c

08000930 <rollback>:

void rollback(void) {
 8000930:	b580      	push	{r7, lr}
 8000932:	b08e      	sub	sp, #56	@ 0x38
 8000934:	af00      	add	r7, sp, #0

  firmware_t old_f;
  // old firmware is present in the COPY_ADDR section
  init_firmware_t(COPY_ADDR, &old_f);
 8000936:	f107 0308 	add.w	r3, r7, #8
 800093a:	4619      	mov	r1, r3
 800093c:	4819      	ldr	r0, [pc, #100]	@ (80009a4 <rollback+0x74>)
 800093e:	f000 f911 	bl	8000b64 <init_firmware_t>

  printf("startign rollback\n\n\r", 0x0);
 8000942:	2100      	movs	r1, #0
 8000944:	4818      	ldr	r0, [pc, #96]	@ (80009a8 <rollback+0x78>)
 8000946:	f7ff fec7 	bl	80006d8 <printf>
  erase_flash(old_f.__base_address);
 800094a:	68bb      	ldr	r3, [r7, #8]
 800094c:	4618      	mov	r0, r3
 800094e:	f000 fbb5 	bl	80010bc <erase_flash>
  printf("corupted firmware is erased\n\r", 0x0);
 8000952:	2100      	movs	r1, #0
 8000954:	4815      	ldr	r0, [pc, #84]	@ (80009ac <rollback+0x7c>)
 8000956:	f7ff febf 	bl	80006d8 <printf>

  uint32_t copy_size =
      (*(uint32_t *)(COPY_ADDR + 0x14)) - (*(uint32_t *)(COPY_ADDR + 0x0c));
 800095a:	4b15      	ldr	r3, [pc, #84]	@ (80009b0 <rollback+0x80>)
 800095c:	681a      	ldr	r2, [r3, #0]
 800095e:	4b15      	ldr	r3, [pc, #84]	@ (80009b4 <rollback+0x84>)
 8000960:	681b      	ldr	r3, [r3, #0]
  uint32_t copy_size =
 8000962:	1ad3      	subs	r3, r2, r3
 8000964:	637b      	str	r3, [r7, #52]	@ 0x34
  flash_write(old_f.__base_address + 0x04, (const char *)(COPY_ADDR + 0x04),
 8000966:	68bb      	ldr	r3, [r7, #8]
 8000968:	1d18      	adds	r0, r3, #4
 800096a:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 800096c:	1f1a      	subs	r2, r3, #4
 800096e:	2300      	movs	r3, #0
 8000970:	4911      	ldr	r1, [pc, #68]	@ (80009b8 <rollback+0x88>)
 8000972:	f000 fc5d 	bl	8001230 <flash_write>
              copy_size - 0x04, NO_DELAY);

  // word write => size would be 4 (not 2)
  const uint32_t end = 0xfffffffe;
 8000976:	f06f 0301 	mvn.w	r3, #1
 800097a:	607b      	str	r3, [r7, #4]
  // &end is of type -> uint32_t * ==> need type conversion
  flash_write(old_f.__base_address, (const char *)(&end), 4, NO_DELAY);
 800097c:	68b8      	ldr	r0, [r7, #8]
 800097e:	1d39      	adds	r1, r7, #4
 8000980:	2300      	movs	r3, #0
 8000982:	2204      	movs	r2, #4
 8000984:	f000 fc54 	bl	8001230 <flash_write>
  printf("new flag = %\n\r", old_f.__base_address);
 8000988:	68bb      	ldr	r3, [r7, #8]
 800098a:	4619      	mov	r1, r3
 800098c:	480b      	ldr	r0, [pc, #44]	@ (80009bc <rollback+0x8c>)
 800098e:	f7ff fea3 	bl	80006d8 <printf>

  printf("done recovering old firmware \n\r", 0x0);
 8000992:	2100      	movs	r1, #0
 8000994:	480a      	ldr	r0, [pc, #40]	@ (80009c0 <rollback+0x90>)
 8000996:	f7ff fe9f 	bl	80006d8 <printf>
}
 800099a:	bf00      	nop
 800099c:	3738      	adds	r7, #56	@ 0x38
 800099e:	46bd      	mov	sp, r7
 80009a0:	bd80      	pop	{r7, pc}
 80009a2:	bf00      	nop
 80009a4:	08060000 	.word	0x08060000
 80009a8:	08001740 	.word	0x08001740
 80009ac:	08001758 	.word	0x08001758
 80009b0:	08060014 	.word	0x08060014
 80009b4:	0806000c 	.word	0x0806000c
 80009b8:	08060004 	.word	0x08060004
 80009bc:	08001778 	.word	0x08001778
 80009c0:	08001788 	.word	0x08001788

080009c4 <validate_vtable>:
#include "core.h"
#include <stdint.h>

bool validate_vtable(firmware_t *f, uint32_t address) {
 80009c4:	b580      	push	{r7, lr}
 80009c6:	b08a      	sub	sp, #40	@ 0x28
 80009c8:	af00      	add	r7, sp, #0
 80009ca:	6078      	str	r0, [r7, #4]
 80009cc:	6039      	str	r1, [r7, #0]

  // vtable end is the next free address
  // check from address ------->    [vtable_start, vtable_end)

  // vtable must be 128byte aligned => last 7 bits must be 0 (for stm32f401re)
  if (f->__vtable_address & ((1 << 7) - 1)) {
 80009ce:	687b      	ldr	r3, [r7, #4]
 80009d0:	695b      	ldr	r3, [r3, #20]
 80009d2:	f003 037f 	and.w	r3, r3, #127	@ 0x7f
 80009d6:	2b00      	cmp	r3, #0
 80009d8:	d005      	beq.n	80009e6 <validate_vtable+0x22>
    printf("the vector table is not 128byte aligned !!!\n\r", 0x0);
 80009da:	2100      	movs	r1, #0
 80009dc:	4833      	ldr	r0, [pc, #204]	@ (8000aac <validate_vtable+0xe8>)
 80009de:	f7ff fe7b 	bl	80006d8 <printf>
    return false;
 80009e2:	2300      	movs	r3, #0
 80009e4:	e05e      	b.n	8000aa4 <validate_vtable+0xe0>

  // all the "end" addresses are next free address => there should not be any
  // data in the "end" address !! all the addresses must lie in the range
  // [start, end)

  uint32_t RAM_start = 0x20000000;
 80009e6:	f04f 5300 	mov.w	r3, #536870912	@ 0x20000000
 80009ea:	623b      	str	r3, [r7, #32]
  uint32_t RAM_size = 96 * 1024; // 96kB
 80009ec:	f44f 33c0 	mov.w	r3, #98304	@ 0x18000
 80009f0:	61fb      	str	r3, [r7, #28]
  uint32_t RAM_end = RAM_start + RAM_size;
 80009f2:	6a3a      	ldr	r2, [r7, #32]
 80009f4:	69fb      	ldr	r3, [r7, #28]
 80009f6:	4413      	add	r3, r2
 80009f8:	61bb      	str	r3, [r7, #24]
  uint32_t FLASH_start = f->__vtable_address;
 80009fa:	687b      	ldr	r3, [r7, #4]
 80009fc:	695b      	ldr	r3, [r3, #20]
 80009fe:	617b      	str	r3, [r7, #20]
  uint32_t FLASH_end = f->__firmware_end;
 8000a00:	687b      	ldr	r3, [r7, #4]
 8000a02:	699b      	ldr	r3, [r3, #24]
 8000a04:	613b      	str	r3, [r7, #16]

  /*************************msp check*********************/

  // MSP value can be RAM end as MSP grows downword;
  if (f->__msp_value > RAM_end || f->__msp_value < RAM_start) {
 8000a06:	687b      	ldr	r3, [r7, #4]
 8000a08:	6a1b      	ldr	r3, [r3, #32]
 8000a0a:	69ba      	ldr	r2, [r7, #24]
 8000a0c:	429a      	cmp	r2, r3
 8000a0e:	d304      	bcc.n	8000a1a <validate_vtable+0x56>
 8000a10:	687b      	ldr	r3, [r7, #4]
 8000a12:	6a1b      	ldr	r3, [r3, #32]
 8000a14:	6a3a      	ldr	r2, [r7, #32]
 8000a16:	429a      	cmp	r2, r3
 8000a18:	d90b      	bls.n	8000a32 <validate_vtable+0x6e>

    printf("MSP value is -> %\n\r", (uint32_t)(&(f->__msp_value)));
 8000a1a:	687b      	ldr	r3, [r7, #4]
 8000a1c:	3320      	adds	r3, #32
 8000a1e:	4619      	mov	r1, r3
 8000a20:	4823      	ldr	r0, [pc, #140]	@ (8000ab0 <validate_vtable+0xec>)
 8000a22:	f7ff fe59 	bl	80006d8 <printf>
    printf("MSP value is invalid\n\r", 0x0);
 8000a26:	2100      	movs	r1, #0
 8000a28:	4822      	ldr	r0, [pc, #136]	@ (8000ab4 <validate_vtable+0xf0>)
 8000a2a:	f7ff fe55 	bl	80006d8 <printf>
    return false;
 8000a2e:	2300      	movs	r3, #0
 8000a30:	e038      	b.n	8000aa4 <validate_vtable+0xe0>
  }
  // msp value must be word aligned !!!
  if (f->__msp_value & 3) {
 8000a32:	687b      	ldr	r3, [r7, #4]
 8000a34:	6a1b      	ldr	r3, [r3, #32]
 8000a36:	f003 0303 	and.w	r3, r3, #3
 8000a3a:	2b00      	cmp	r3, #0
 8000a3c:	d005      	beq.n	8000a4a <validate_vtable+0x86>
    printf("MSP value is not word aligned\n\r", 0x0);
 8000a3e:	2100      	movs	r1, #0
 8000a40:	481d      	ldr	r0, [pc, #116]	@ (8000ab8 <validate_vtable+0xf4>)
 8000a42:	f7ff fe49 	bl	80006d8 <printf>
    return false;
 8000a46:	2300      	movs	r3, #0
 8000a48:	e02c      	b.n	8000aa4 <validate_vtable+0xe0>
  }

  /************************ vtable check************************/
  uint32_t vtable_entry =
      address + f->__vtable_address - f->__base_address + 0x4;
 8000a4a:	687b      	ldr	r3, [r7, #4]
 8000a4c:	695a      	ldr	r2, [r3, #20]
 8000a4e:	683b      	ldr	r3, [r7, #0]
 8000a50:	441a      	add	r2, r3
 8000a52:	687b      	ldr	r3, [r7, #4]
 8000a54:	681b      	ldr	r3, [r3, #0]
 8000a56:	1ad3      	subs	r3, r2, r3
  uint32_t vtable_entry =
 8000a58:	3304      	adds	r3, #4
 8000a5a:	627b      	str	r3, [r7, #36]	@ 0x24
  uint32_t vtable_end = address + f->__vtable_end - f->__base_address;
 8000a5c:	687b      	ldr	r3, [r7, #4]
 8000a5e:	68da      	ldr	r2, [r3, #12]
 8000a60:	683b      	ldr	r3, [r7, #0]
 8000a62:	441a      	add	r2, r3
 8000a64:	687b      	ldr	r3, [r7, #4]
 8000a66:	681b      	ldr	r3, [r3, #0]
 8000a68:	1ad3      	subs	r3, r2, r3
 8000a6a:	60fb      	str	r3, [r7, #12]

  for (; vtable_entry < vtable_end; vtable_entry += 4) {
 8000a6c:	e015      	b.n	8000a9a <validate_vtable+0xd6>

    uint32_t FLASH_address =
        (*((uint32_t *)vtable_entry)) & (~1U); // peek inside vtable_entry
 8000a6e:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000a70:	681b      	ldr	r3, [r3, #0]
    uint32_t FLASH_address =
 8000a72:	f023 0301 	bic.w	r3, r3, #1
 8000a76:	60bb      	str	r3, [r7, #8]
    if (FLASH_address >= FLASH_end || FLASH_address < FLASH_start) {
 8000a78:	68ba      	ldr	r2, [r7, #8]
 8000a7a:	693b      	ldr	r3, [r7, #16]
 8000a7c:	429a      	cmp	r2, r3
 8000a7e:	d203      	bcs.n	8000a88 <validate_vtable+0xc4>
 8000a80:	68ba      	ldr	r2, [r7, #8]
 8000a82:	697b      	ldr	r3, [r7, #20]
 8000a84:	429a      	cmp	r2, r3
 8000a86:	d205      	bcs.n	8000a94 <validate_vtable+0xd0>

      printf("% ---- in vtable entry does not exist in the allowed flash "
 8000a88:	6a79      	ldr	r1, [r7, #36]	@ 0x24
 8000a8a:	480c      	ldr	r0, [pc, #48]	@ (8000abc <validate_vtable+0xf8>)
 8000a8c:	f7ff fe24 	bl	80006d8 <printf>
             "range\n\r",
             vtable_entry);
      return false;
 8000a90:	2300      	movs	r3, #0
 8000a92:	e007      	b.n	8000aa4 <validate_vtable+0xe0>
  for (; vtable_entry < vtable_end; vtable_entry += 4) {
 8000a94:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000a96:	3304      	adds	r3, #4
 8000a98:	627b      	str	r3, [r7, #36]	@ 0x24
 8000a9a:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
 8000a9c:	68fb      	ldr	r3, [r7, #12]
 8000a9e:	429a      	cmp	r2, r3
 8000aa0:	d3e5      	bcc.n	8000a6e <validate_vtable+0xaa>
    }
  }

  return true;
 8000aa2:	2301      	movs	r3, #1
}
 8000aa4:	4618      	mov	r0, r3
 8000aa6:	3728      	adds	r7, #40	@ 0x28
 8000aa8:	46bd      	mov	sp, r7
 8000aaa:	bd80      	pop	{r7, pc}
 8000aac:	080017a8 	.word	0x080017a8
 8000ab0:	080017d8 	.word	0x080017d8
 8000ab4:	080017ec 	.word	0x080017ec
 8000ab8:	08001804 	.word	0x08001804
 8000abc:	08001824 	.word	0x08001824

08000ac0 <validate_firmware>:

bool validate_firmware(firmware_t *f, uint32_t address) {
 8000ac0:	b580      	push	{r7, lr}
 8000ac2:	b084      	sub	sp, #16
 8000ac4:	af00      	add	r7, sp, #0
 8000ac6:	6078      	str	r0, [r7, #4]
 8000ac8:	6039      	str	r1, [r7, #0]

  if (!validate_vtable(f, address)) {
 8000aca:	6839      	ldr	r1, [r7, #0]
 8000acc:	6878      	ldr	r0, [r7, #4]
 8000ace:	f7ff ff79 	bl	80009c4 <validate_vtable>
 8000ad2:	4603      	mov	r3, r0
 8000ad4:	f083 0301 	eor.w	r3, r3, #1
 8000ad8:	b2db      	uxtb	r3, r3
 8000ada:	2b00      	cmp	r3, #0
 8000adc:	d005      	beq.n	8000aea <validate_firmware+0x2a>

    printf("vector table of the update is not valid\n\r", 0x0);
 8000ade:	2100      	movs	r1, #0
 8000ae0:	480f      	ldr	r0, [pc, #60]	@ (8000b20 <validate_firmware+0x60>)
 8000ae2:	f7ff fdf9 	bl	80006d8 <printf>
    return false;
 8000ae6:	2300      	movs	r3, #0
 8000ae8:	e016      	b.n	8000b18 <validate_firmware+0x58>
  }

  uint32_t crc_result = crc_calc(f);
 8000aea:	6878      	ldr	r0, [r7, #4]
 8000aec:	f7ff fafa 	bl	80000e4 <crc_calc>
 8000af0:	4603      	mov	r3, r0
 8000af2:	60fb      	str	r3, [r7, #12]
  printf("crc value is -> %\n\r", (uint32_t)(&crc_result));
 8000af4:	f107 030c 	add.w	r3, r7, #12
 8000af8:	4619      	mov	r1, r3
 8000afa:	480a      	ldr	r0, [pc, #40]	@ (8000b24 <validate_firmware+0x64>)
 8000afc:	f7ff fdec 	bl	80006d8 <printf>
  if (crc_result != f->__crc) {
 8000b00:	687b      	ldr	r3, [r7, #4]
 8000b02:	689a      	ldr	r2, [r3, #8]
 8000b04:	68fb      	ldr	r3, [r7, #12]
 8000b06:	429a      	cmp	r2, r3
 8000b08:	d005      	beq.n	8000b16 <validate_firmware+0x56>
    printf("CRC failed\n\r", 0x0);
 8000b0a:	2100      	movs	r1, #0
 8000b0c:	4806      	ldr	r0, [pc, #24]	@ (8000b28 <validate_firmware+0x68>)
 8000b0e:	f7ff fde3 	bl	80006d8 <printf>
    return false;
 8000b12:	2300      	movs	r3, #0
 8000b14:	e000      	b.n	8000b18 <validate_firmware+0x58>
  }
  return true;
 8000b16:	2301      	movs	r3, #1
}
 8000b18:	4618      	mov	r0, r3
 8000b1a:	3710      	adds	r7, #16
 8000b1c:	46bd      	mov	sp, r7
 8000b1e:	bd80      	pop	{r7, pc}
 8000b20:	08001868 	.word	0x08001868
 8000b24:	08001894 	.word	0x08001894
 8000b28:	080018a8 	.word	0x080018a8

08000b2c <__NVIC_EnableIRQ>:
{
 8000b2c:	b480      	push	{r7}
 8000b2e:	b083      	sub	sp, #12
 8000b30:	af00      	add	r7, sp, #0
 8000b32:	4603      	mov	r3, r0
 8000b34:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 8000b36:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000b3a:	2b00      	cmp	r3, #0
 8000b3c:	db0b      	blt.n	8000b56 <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 8000b3e:	79fb      	ldrb	r3, [r7, #7]
 8000b40:	f003 021f 	and.w	r2, r3, #31
 8000b44:	4906      	ldr	r1, [pc, #24]	@ (8000b60 <__NVIC_EnableIRQ+0x34>)
 8000b46:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000b4a:	095b      	lsrs	r3, r3, #5
 8000b4c:	2001      	movs	r0, #1
 8000b4e:	fa00 f202 	lsl.w	r2, r0, r2
 8000b52:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 8000b56:	bf00      	nop
 8000b58:	370c      	adds	r7, #12
 8000b5a:	46bd      	mov	sp, r7
 8000b5c:	bc80      	pop	{r7}
 8000b5e:	4770      	bx	lr
 8000b60:	e000e100 	.word	0xe000e100

08000b64 <init_firmware_t>:
volatile bool flag_size_recieved = false;
volatile bool flag_wrong_size = false;
volatile bool flag_too_big_update = false;


void init_firmware_t(uint32_t address, firmware_t *f) {
 8000b64:	b480      	push	{r7}
 8000b66:	b083      	sub	sp, #12
 8000b68:	af00      	add	r7, sp, #0
 8000b6a:	6078      	str	r0, [r7, #4]
 8000b6c:	6039      	str	r1, [r7, #0]
  f->__flag = *(volatile uint32_t *)(address + 0x00);
 8000b6e:	687b      	ldr	r3, [r7, #4]
 8000b70:	681a      	ldr	r2, [r3, #0]
 8000b72:	683b      	ldr	r3, [r7, #0]
 8000b74:	605a      	str	r2, [r3, #4]
  f->__crc = *((volatile uint32_t *)(address + 0x04));
 8000b76:	687b      	ldr	r3, [r7, #4]
 8000b78:	3304      	adds	r3, #4
 8000b7a:	681a      	ldr	r2, [r3, #0]
 8000b7c:	683b      	ldr	r3, [r7, #0]
 8000b7e:	609a      	str	r2, [r3, #8]
  f->__vtable_end = *((volatile uint32_t *)(address + 0x08));
 8000b80:	687b      	ldr	r3, [r7, #4]
 8000b82:	3308      	adds	r3, #8
 8000b84:	681a      	ldr	r2, [r3, #0]
 8000b86:	683b      	ldr	r3, [r7, #0]
 8000b88:	60da      	str	r2, [r3, #12]
  f->__base_address = *((volatile uint32_t *)(address + 0x0c));
 8000b8a:	687b      	ldr	r3, [r7, #4]
 8000b8c:	330c      	adds	r3, #12
 8000b8e:	681a      	ldr	r2, [r3, #0]
 8000b90:	683b      	ldr	r3, [r7, #0]
 8000b92:	601a      	str	r2, [r3, #0]
  f->__vtable_address = *((volatile uint32_t *)(address + 0x10));
 8000b94:	687b      	ldr	r3, [r7, #4]
 8000b96:	3310      	adds	r3, #16
 8000b98:	681a      	ldr	r2, [r3, #0]
 8000b9a:	683b      	ldr	r3, [r7, #0]
 8000b9c:	615a      	str	r2, [r3, #20]
  f->__firmware_end = *((volatile uint32_t *)(address + 0x14));
 8000b9e:	687b      	ldr	r3, [r7, #4]
 8000ba0:	3314      	adds	r3, #20
 8000ba2:	681a      	ldr	r2, [r3, #0]
 8000ba4:	683b      	ldr	r3, [r7, #0]
 8000ba6:	619a      	str	r2, [r3, #24]
  f->__firmware_size = f->__firmware_end - f->__base_address;
 8000ba8:	683b      	ldr	r3, [r7, #0]
 8000baa:	699a      	ldr	r2, [r3, #24]
 8000bac:	683b      	ldr	r3, [r7, #0]
 8000bae:	681b      	ldr	r3, [r3, #0]
 8000bb0:	1ad2      	subs	r2, r2, r3
 8000bb2:	683b      	ldr	r3, [r7, #0]
 8000bb4:	61da      	str	r2, [r3, #28]
  f->__crc_start_addr = address + 0x08;
 8000bb6:	687b      	ldr	r3, [r7, #4]
 8000bb8:	f103 0208 	add.w	r2, r3, #8
 8000bbc:	683b      	ldr	r3, [r7, #0]
 8000bbe:	611a      	str	r2, [r3, #16]
  f->__crc_end_addr = f->__crc_start_addr - 0x08 + f->__firmware_size;
 8000bc0:	683b      	ldr	r3, [r7, #0]
 8000bc2:	691a      	ldr	r2, [r3, #16]
 8000bc4:	683b      	ldr	r3, [r7, #0]
 8000bc6:	69db      	ldr	r3, [r3, #28]
 8000bc8:	4413      	add	r3, r2
 8000bca:	f1a3 0208 	sub.w	r2, r3, #8
 8000bce:	683b      	ldr	r3, [r7, #0]
 8000bd0:	629a      	str	r2, [r3, #40]	@ 0x28
  f->__msp_value = *((volatile uint32_t *)(f->__vtable_address));
 8000bd2:	683b      	ldr	r3, [r7, #0]
 8000bd4:	695b      	ldr	r3, [r3, #20]
 8000bd6:	681a      	ldr	r2, [r3, #0]
 8000bd8:	683b      	ldr	r3, [r7, #0]
 8000bda:	621a      	str	r2, [r3, #32]
  f->__reset_handler = *((volatile uint32_t *)(f->__vtable_address + 0x4));
 8000bdc:	683b      	ldr	r3, [r7, #0]
 8000bde:	695b      	ldr	r3, [r3, #20]
 8000be0:	3304      	adds	r3, #4
 8000be2:	681a      	ldr	r2, [r3, #0]
 8000be4:	683b      	ldr	r3, [r7, #0]
 8000be6:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000be8:	bf00      	nop
 8000bea:	370c      	adds	r7, #12
 8000bec:	46bd      	mov	sp, r7
 8000bee:	bc80      	pop	{r7}
 8000bf0:	4770      	bx	lr

08000bf2 <copy_firmware_t>:

void copy_firmware_t(firmware_t *f_dest, firmware_t *f_src) {
 8000bf2:	b480      	push	{r7}
 8000bf4:	b083      	sub	sp, #12
 8000bf6:	af00      	add	r7, sp, #0
 8000bf8:	6078      	str	r0, [r7, #4]
 8000bfa:	6039      	str	r1, [r7, #0]

  f_dest->__base_address = f_src->__base_address;
 8000bfc:	683b      	ldr	r3, [r7, #0]
 8000bfe:	681a      	ldr	r2, [r3, #0]
 8000c00:	687b      	ldr	r3, [r7, #4]
 8000c02:	601a      	str	r2, [r3, #0]
  f_dest->__flag = f_src->__flag;
 8000c04:	683b      	ldr	r3, [r7, #0]
 8000c06:	685a      	ldr	r2, [r3, #4]
 8000c08:	687b      	ldr	r3, [r7, #4]
 8000c0a:	605a      	str	r2, [r3, #4]
  f_dest->__crc = f_src->__crc;
 8000c0c:	683b      	ldr	r3, [r7, #0]
 8000c0e:	689a      	ldr	r2, [r3, #8]
 8000c10:	687b      	ldr	r3, [r7, #4]
 8000c12:	609a      	str	r2, [r3, #8]
  f_dest->__vtable_end = f_src->__vtable_end;
 8000c14:	683b      	ldr	r3, [r7, #0]
 8000c16:	68da      	ldr	r2, [r3, #12]
 8000c18:	687b      	ldr	r3, [r7, #4]
 8000c1a:	60da      	str	r2, [r3, #12]
  f_dest->__crc_start_addr = f_src->__crc_start_addr;
 8000c1c:	683b      	ldr	r3, [r7, #0]
 8000c1e:	691a      	ldr	r2, [r3, #16]
 8000c20:	687b      	ldr	r3, [r7, #4]
 8000c22:	611a      	str	r2, [r3, #16]
  f_dest->__crc_end_addr = f_src->__crc_end_addr;
 8000c24:	683b      	ldr	r3, [r7, #0]
 8000c26:	6a9a      	ldr	r2, [r3, #40]	@ 0x28
 8000c28:	687b      	ldr	r3, [r7, #4]
 8000c2a:	629a      	str	r2, [r3, #40]	@ 0x28
  f_dest->__vtable_address = f_src->__vtable_address;
 8000c2c:	683b      	ldr	r3, [r7, #0]
 8000c2e:	695a      	ldr	r2, [r3, #20]
 8000c30:	687b      	ldr	r3, [r7, #4]
 8000c32:	615a      	str	r2, [r3, #20]
  f_dest->__firmware_end = f_src->__firmware_end;
 8000c34:	683b      	ldr	r3, [r7, #0]
 8000c36:	699a      	ldr	r2, [r3, #24]
 8000c38:	687b      	ldr	r3, [r7, #4]
 8000c3a:	619a      	str	r2, [r3, #24]
  f_dest->__firmware_size = f_src->__firmware_size;
 8000c3c:	683b      	ldr	r3, [r7, #0]
 8000c3e:	69da      	ldr	r2, [r3, #28]
 8000c40:	687b      	ldr	r3, [r7, #4]
 8000c42:	61da      	str	r2, [r3, #28]
  f_dest->__msp_value = f_src->__msp_value;
 8000c44:	683b      	ldr	r3, [r7, #0]
 8000c46:	6a1a      	ldr	r2, [r3, #32]
 8000c48:	687b      	ldr	r3, [r7, #4]
 8000c4a:	621a      	str	r2, [r3, #32]
  f_dest->__reset_handler = f_src->__reset_handler;
 8000c4c:	683b      	ldr	r3, [r7, #0]
 8000c4e:	6a5a      	ldr	r2, [r3, #36]	@ 0x24
 8000c50:	687b      	ldr	r3, [r7, #4]
 8000c52:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000c54:	bf00      	nop
 8000c56:	370c      	adds	r7, #12
 8000c58:	46bd      	mov	sp, r7
 8000c5a:	bc80      	pop	{r7}
 8000c5c:	4770      	bx	lr

08000c5e <handle_update>:

bool handle_update(void) {
 8000c5e:	b580      	push	{r7, lr}
 8000c60:	b098      	sub	sp, #96	@ 0x60
 8000c62:	af00      	add	r7, sp, #0

  /************************* recieve update and store it in
   * UPDATE_ADDR in flash***********************/

  if (recieve_update()) {
 8000c64:	f7ff fdc8 	bl	80007f8 <recieve_update>
 8000c68:	4603      	mov	r3, r0
 8000c6a:	2b00      	cmp	r3, #0
 8000c6c:	d005      	beq.n	8000c7a <handle_update+0x1c>
    printf("ERROR in recieving update\n\r", 0x0);
 8000c6e:	2100      	movs	r1, #0
 8000c70:	4853      	ldr	r0, [pc, #332]	@ (8000dc0 <handle_update+0x162>)
 8000c72:	f7ff fd31 	bl	80006d8 <printf>
    return 0;
 8000c76:	2300      	movs	r3, #0
 8000c78:	e09d      	b.n	8000db6 <handle_update+0x158>
  }
  firmware_t f;
  update_size = update_size / 4 * 4 + 4; // align update size by 4bytes
 8000c7a:	4b52      	ldr	r3, [pc, #328]	@ (8000dc4 <handle_update+0x166>)
 8000c7c:	681b      	ldr	r3, [r3, #0]
 8000c7e:	f023 0303 	bic.w	r3, r3, #3
 8000c82:	3304      	adds	r3, #4
 8000c84:	4a4f      	ldr	r2, [pc, #316]	@ (8000dc4 <handle_update+0x166>)
 8000c86:	6013      	str	r3, [r2, #0]

  if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_1_ADDRESS)
 8000c88:	4b4f      	ldr	r3, [pc, #316]	@ (8000dc8 <handle_update+0x16a>)
 8000c8a:	681b      	ldr	r3, [r3, #0]
 8000c8c:	4a4f      	ldr	r2, [pc, #316]	@ (8000dcc <handle_update+0x16e>)
 8000c8e:	4293      	cmp	r3, r2
 8000c90:	d106      	bne.n	8000ca0 <handle_update+0x42>
    copy_firmware_t(&f, &f1);
 8000c92:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000c96:	494e      	ldr	r1, [pc, #312]	@ (8000dd0 <handle_update+0x172>)
 8000c98:	4618      	mov	r0, r3
 8000c9a:	f7ff ffaa 	bl	8000bf2 <copy_firmware_t>
 8000c9e:	e011      	b.n	8000cc4 <handle_update+0x66>

  else if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_2_ADDRESS)
 8000ca0:	4b49      	ldr	r3, [pc, #292]	@ (8000dc8 <handle_update+0x16a>)
 8000ca2:	681b      	ldr	r3, [r3, #0]
 8000ca4:	4a4b      	ldr	r2, [pc, #300]	@ (8000dd4 <handle_update+0x176>)
 8000ca6:	4293      	cmp	r3, r2
 8000ca8:	d106      	bne.n	8000cb8 <handle_update+0x5a>
    copy_firmware_t(&f, &f2);
 8000caa:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000cae:	494a      	ldr	r1, [pc, #296]	@ (8000dd8 <handle_update+0x17a>)
 8000cb0:	4618      	mov	r0, r3
 8000cb2:	f7ff ff9e 	bl	8000bf2 <copy_firmware_t>
 8000cb6:	e005      	b.n	8000cc4 <handle_update+0x66>

  else {
    printf("wrong firmware base address !!!", 0x0);
 8000cb8:	2100      	movs	r1, #0
 8000cba:	4848      	ldr	r0, [pc, #288]	@ (8000ddc <handle_update+0x17e>)
 8000cbc:	f7ff fd0c 	bl	80006d8 <printf>
    return 0;
 8000cc0:	2300      	movs	r3, #0
 8000cc2:	e078      	b.n	8000db6 <handle_update+0x158>
  }

  /******************** store the update in UPDATE section
   * ***************************/

  printf("update has been saved in the update section !!!\n\r", 0x0);
 8000cc4:	2100      	movs	r1, #0
 8000cc6:	4846      	ldr	r0, [pc, #280]	@ (8000de0 <handle_update+0x182>)
 8000cc8:	f7ff fd06 	bl	80006d8 <printf>

  firmware_t uf;
  init_firmware_t(UPDATE_ADDR, &uf);
 8000ccc:	f107 0308 	add.w	r3, r7, #8
 8000cd0:	4619      	mov	r1, r3
 8000cd2:	4844      	ldr	r0, [pc, #272]	@ (8000de4 <handle_update+0x186>)
 8000cd4:	f7ff ff46 	bl	8000b64 <init_firmware_t>

  printf("***************validating update***************\n\r", 0x0);
 8000cd8:	2100      	movs	r1, #0
 8000cda:	4843      	ldr	r0, [pc, #268]	@ (8000de8 <handle_update+0x18a>)
 8000cdc:	f7ff fcfc 	bl	80006d8 <printf>

  // check flag field of the firmware
  if (uf.__flag != 0xffffffff) {
 8000ce0:	68fb      	ldr	r3, [r7, #12]
 8000ce2:	f1b3 3fff 	cmp.w	r3, #4294967295	@ 0xffffffff
 8000ce6:	d005      	beq.n	8000cf4 <handle_update+0x96>
    printf("ERROR .... flag field of update must be 0xffffffff\n\r", 0x0);
 8000ce8:	2100      	movs	r1, #0
 8000cea:	4840      	ldr	r0, [pc, #256]	@ (8000dec <handle_update+0x18e>)
 8000cec:	f7ff fcf4 	bl	80006d8 <printf>
    return 0;
 8000cf0:	2300      	movs	r3, #0
 8000cf2:	e060      	b.n	8000db6 <handle_update+0x158>
  }
  if (!validate_firmware(&uf, UPDATE_ADDR)) {
 8000cf4:	f107 0308 	add.w	r3, r7, #8
 8000cf8:	493a      	ldr	r1, [pc, #232]	@ (8000de4 <handle_update+0x186>)
 8000cfa:	4618      	mov	r0, r3
 8000cfc:	f7ff fee0 	bl	8000ac0 <validate_firmware>
 8000d00:	4603      	mov	r3, r0
 8000d02:	f083 0301 	eor.w	r3, r3, #1
 8000d06:	b2db      	uxtb	r3, r3
 8000d08:	2b00      	cmp	r3, #0
 8000d0a:	d005      	beq.n	8000d18 <handle_update+0xba>
    printf("ERROR .... update validation failed\n\r", 0x0);
 8000d0c:	2100      	movs	r1, #0
 8000d0e:	4838      	ldr	r0, [pc, #224]	@ (8000df0 <handle_update+0x192>)
 8000d10:	f7ff fce2 	bl	80006d8 <printf>
    return 0;
 8000d14:	2300      	movs	r3, #0
 8000d16:	e04e      	b.n	8000db6 <handle_update+0x158>
  }

  /************************firmware to COPY section
   * ***********************************/

  if (erase_flash(COPY_ADDR)) {
 8000d18:	4836      	ldr	r0, [pc, #216]	@ (8000df4 <handle_update+0x196>)
 8000d1a:	f000 f9cf 	bl	80010bc <erase_flash>
 8000d1e:	4603      	mov	r3, r0
 8000d20:	2b00      	cmp	r3, #0
 8000d22:	d005      	beq.n	8000d30 <handle_update+0xd2>
    printf("could not erase COPY section\n\r", 0x0);
 8000d24:	2100      	movs	r1, #0
 8000d26:	4834      	ldr	r0, [pc, #208]	@ (8000df8 <handle_update+0x19a>)
 8000d28:	f7ff fcd6 	bl	80006d8 <printf>
    return 0;
 8000d2c:	2300      	movs	r3, #0
 8000d2e:	e042      	b.n	8000db6 <handle_update+0x158>
  }
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000d30:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000d32:	4619      	mov	r1, r3
                  f.__firmware_size, NO_DELAY)) {
 8000d34:	6d3a      	ldr	r2, [r7, #80]	@ 0x50
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000d36:	2300      	movs	r3, #0
 8000d38:	482e      	ldr	r0, [pc, #184]	@ (8000df4 <handle_update+0x196>)
 8000d3a:	f000 fa79 	bl	8001230 <flash_write>
 8000d3e:	4603      	mov	r3, r0
 8000d40:	2b00      	cmp	r3, #0
 8000d42:	d005      	beq.n	8000d50 <handle_update+0xf2>

    printf("could not write to the COPY section \n\r", 0x0);
 8000d44:	2100      	movs	r1, #0
 8000d46:	482d      	ldr	r0, [pc, #180]	@ (8000dfc <handle_update+0x19e>)
 8000d48:	f7ff fcc6 	bl	80006d8 <printf>
    return 0;
 8000d4c:	2300      	movs	r3, #0
 8000d4e:	e032      	b.n	8000db6 <handle_update+0x158>
  }
  printf("firmware is copied to copy section\n\r", 0x0);
 8000d50:	2100      	movs	r1, #0
 8000d52:	482b      	ldr	r0, [pc, #172]	@ (8000e00 <handle_update+0x1a2>)
 8000d54:	f7ff fcc0 	bl	80006d8 <printf>

  /********************* update to firmware
   * ********************************************/

  if (erase_flash(f.__base_address)) {
 8000d58:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000d5a:	4618      	mov	r0, r3
 8000d5c:	f000 f9ae 	bl	80010bc <erase_flash>
 8000d60:	4603      	mov	r3, r0
 8000d62:	2b00      	cmp	r3, #0
 8000d64:	d005      	beq.n	8000d72 <handle_update+0x114>
    printf("could not erase FIRMWARE section\n\r", 0x0);
 8000d66:	2100      	movs	r1, #0
 8000d68:	4826      	ldr	r0, [pc, #152]	@ (8000e04 <handle_update+0x1a6>)
 8000d6a:	f7ff fcb5 	bl	80006d8 <printf>
    return 0;
 8000d6e:	2300      	movs	r3, #0
 8000d70:	e021      	b.n	8000db6 <handle_update+0x158>
  }
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000d72:	6b78      	ldr	r0, [r7, #52]	@ 0x34
                  uf.__firmware_size, NO_DELAY)) {
 8000d74:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000d76:	2300      	movs	r3, #0
 8000d78:	491a      	ldr	r1, [pc, #104]	@ (8000de4 <handle_update+0x186>)
 8000d7a:	f000 fa59 	bl	8001230 <flash_write>
 8000d7e:	4603      	mov	r3, r0
 8000d80:	2b00      	cmp	r3, #0
 8000d82:	d005      	beq.n	8000d90 <handle_update+0x132>

    printf("could not write to the firmware section\n\r", 0x0);
 8000d84:	2100      	movs	r1, #0
 8000d86:	4820      	ldr	r0, [pc, #128]	@ (8000e08 <handle_update+0x1aa>)
 8000d88:	f7ff fca6 	bl	80006d8 <printf>
    return 0;
 8000d8c:	2300      	movs	r3, #0
 8000d8e:	e012      	b.n	8000db6 <handle_update+0x158>
  }

  const uint32_t end = 0xfffffffe;
 8000d90:	f06f 0301 	mvn.w	r3, #1
 8000d94:	607b      	str	r3, [r7, #4]
  // mark the flag implying that firmware has been updated
  flash_write(f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000d96:	6b78      	ldr	r0, [r7, #52]	@ 0x34
 8000d98:	1d39      	adds	r1, r7, #4
 8000d9a:	2300      	movs	r3, #0
 8000d9c:	2204      	movs	r2, #4
 8000d9e:	f000 fa47 	bl	8001230 <flash_write>

  printf("new flag = %\n\r", f.__base_address);
 8000da2:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000da4:	4619      	mov	r1, r3
 8000da6:	4819      	ldr	r0, [pc, #100]	@ (8000e0c <handle_update+0x1ae>)
 8000da8:	f7ff fc96 	bl	80006d8 <printf>

  printf("updating firmware is done successfully!!!!\n\r", 0x0);
 8000dac:	2100      	movs	r1, #0
 8000dae:	4818      	ldr	r0, [pc, #96]	@ (8000e10 <handle_update+0x1b2>)
 8000db0:	f7ff fc92 	bl	80006d8 <printf>

  return 1;
 8000db4:	2301      	movs	r3, #1
}
 8000db6:	4618      	mov	r0, r3
 8000db8:	3760      	adds	r7, #96	@ 0x60
 8000dba:	46bd      	mov	sp, r7
 8000dbc:	bd80      	pop	{r7, pc}
 8000dbe:	bf00      	nop
 8000dc0:	080018b8 	.word	0x080018b8
 8000dc4:	2000006c 	.word	0x2000006c
 8000dc8:	0804000c 	.word	0x0804000c
 8000dcc:	08004000 	.word	0x08004000
 8000dd0:	20000008 	.word	0x20000008
 8000dd4:	08020000 	.word	0x08020000
 8000dd8:	20000034 	.word	0x20000034
 8000ddc:	080018d4 	.word	0x080018d4
 8000de0:	080018f4 	.word	0x080018f4
 8000de4:	08040000 	.word	0x08040000
 8000de8:	08001928 	.word	0x08001928
 8000dec:	0800195c 	.word	0x0800195c
 8000df0:	08001994 	.word	0x08001994
 8000df4:	08060000 	.word	0x08060000
 8000df8:	080019bc 	.word	0x080019bc
 8000dfc:	080019dc 	.word	0x080019dc
 8000e00:	08001a04 	.word	0x08001a04
 8000e04:	08001a2c 	.word	0x08001a2c
 8000e08:	08001a50 	.word	0x08001a50
 8000e0c:	08001a7c 	.word	0x08001a7c
 8000e10:	08001a8c 	.word	0x08001a8c

08000e14 <switch_press>:

bool switch_press (bool f1_valid, bool f2_valid){
 8000e14:	b580      	push	{r7, lr}
 8000e16:	b084      	sub	sp, #16
 8000e18:	af00      	add	r7, sp, #0
 8000e1a:	4603      	mov	r3, r0
 8000e1c:	460a      	mov	r2, r1
 8000e1e:	71fb      	strb	r3, [r7, #7]
 8000e20:	4613      	mov	r3, r2
 8000e22:	71bb      	strb	r3, [r7, #6]

  while (!press_count)
 8000e24:	bf00      	nop
 8000e26:	4b35      	ldr	r3, [pc, #212]	@ (8000efc <switch_press+0xe8>)
 8000e28:	681b      	ldr	r3, [r3, #0]
 8000e2a:	2b00      	cmp	r3, #0
 8000e2c:	d0fb      	beq.n	8000e26 <switch_press+0x12>
    ;
  delay_count = 1000000;
 8000e2e:	4b34      	ldr	r3, [pc, #208]	@ (8000f00 <switch_press+0xec>)
 8000e30:	4a34      	ldr	r2, [pc, #208]	@ (8000f04 <switch_press+0xf0>)
 8000e32:	601a      	str	r2, [r3, #0]
  while (delay_count--)
 8000e34:	bf00      	nop
 8000e36:	4b32      	ldr	r3, [pc, #200]	@ (8000f00 <switch_press+0xec>)
 8000e38:	681b      	ldr	r3, [r3, #0]
 8000e3a:	1e5a      	subs	r2, r3, #1
 8000e3c:	4930      	ldr	r1, [pc, #192]	@ (8000f00 <switch_press+0xec>)
 8000e3e:	600a      	str	r2, [r1, #0]
 8000e40:	2b00      	cmp	r3, #0
 8000e42:	d1f8      	bne.n	8000e36 <switch_press+0x22>
    ;
  if (press_count >= 3) {
 8000e44:	4b2d      	ldr	r3, [pc, #180]	@ (8000efc <switch_press+0xe8>)
 8000e46:	681b      	ldr	r3, [r3, #0]
 8000e48:	2b02      	cmp	r3, #2
 8000e4a:	d930      	bls.n	8000eae <switch_press+0x9a>
    erase_flash (UPDATE_ADDR);
 8000e4c:	482e      	ldr	r0, [pc, #184]	@ (8000f08 <switch_press+0xf4>)
 8000e4e:	f000 f935 	bl	80010bc <erase_flash>
    firmware_update_mode = true;
 8000e52:	4b2e      	ldr	r3, [pc, #184]	@ (8000f0c <switch_press+0xf8>)
 8000e54:	2201      	movs	r2, #1
 8000e56:	701a      	strb	r2, [r3, #0]
    bool status = handle_update();
 8000e58:	f7ff ff01 	bl	8000c5e <handle_update>
 8000e5c:	4603      	mov	r3, r0
 8000e5e:	73fb      	strb	r3, [r7, #15]

    if (!status && recursion_depth < MAX_RECURSION_DEPTH) {
 8000e60:	7bfb      	ldrb	r3, [r7, #15]
 8000e62:	f083 0301 	eor.w	r3, r3, #1
 8000e66:	b2db      	uxtb	r3, r3
 8000e68:	2b00      	cmp	r3, #0
 8000e6a:	d041      	beq.n	8000ef0 <switch_press+0xdc>
 8000e6c:	4b28      	ldr	r3, [pc, #160]	@ (8000f10 <switch_press+0xfc>)
 8000e6e:	781b      	ldrb	r3, [r3, #0]
 8000e70:	2b01      	cmp	r3, #1
 8000e72:	d83d      	bhi.n	8000ef0 <switch_press+0xdc>
      printf ("error in update !!! retry\n\r", 0x0);
 8000e74:	2100      	movs	r1, #0
 8000e76:	4827      	ldr	r0, [pc, #156]	@ (8000f14 <switch_press+0x100>)
 8000e78:	f7ff fc2e 	bl	80006d8 <printf>
      recursion_depth ++;
 8000e7c:	4b24      	ldr	r3, [pc, #144]	@ (8000f10 <switch_press+0xfc>)
 8000e7e:	781b      	ldrb	r3, [r3, #0]
 8000e80:	3301      	adds	r3, #1
 8000e82:	b2da      	uxtb	r2, r3
 8000e84:	4b22      	ldr	r3, [pc, #136]	@ (8000f10 <switch_press+0xfc>)
 8000e86:	701a      	strb	r2, [r3, #0]
      press_count = 0;
 8000e88:	4b1c      	ldr	r3, [pc, #112]	@ (8000efc <switch_press+0xe8>)
 8000e8a:	2200      	movs	r2, #0
 8000e8c:	601a      	str	r2, [r3, #0]

      flag_size_recieved = false;
 8000e8e:	4b22      	ldr	r3, [pc, #136]	@ (8000f18 <switch_press+0x104>)
 8000e90:	2200      	movs	r2, #0
 8000e92:	701a      	strb	r2, [r3, #0]
      flag_wrong_size = false;
 8000e94:	4b21      	ldr	r3, [pc, #132]	@ (8000f1c <switch_press+0x108>)
 8000e96:	2200      	movs	r2, #0
 8000e98:	701a      	strb	r2, [r3, #0]
      flag_too_big_update = false;
 8000e9a:	4b21      	ldr	r3, [pc, #132]	@ (8000f20 <switch_press+0x10c>)
 8000e9c:	2200      	movs	r2, #0
 8000e9e:	701a      	strb	r2, [r3, #0]

      switch_press (f1_valid, f2_valid);
 8000ea0:	79ba      	ldrb	r2, [r7, #6]
 8000ea2:	79fb      	ldrb	r3, [r7, #7]
 8000ea4:	4611      	mov	r1, r2
 8000ea6:	4618      	mov	r0, r3
 8000ea8:	f7ff ffb4 	bl	8000e14 <switch_press>
 8000eac:	e020      	b.n	8000ef0 <switch_press+0xdc>
    }
  } else if (press_count == 2) {
 8000eae:	4b13      	ldr	r3, [pc, #76]	@ (8000efc <switch_press+0xe8>)
 8000eb0:	681b      	ldr	r3, [r3, #0]
 8000eb2:	2b02      	cmp	r3, #2
 8000eb4:	d10e      	bne.n	8000ed4 <switch_press+0xc0>
    if (f2_valid) {
 8000eb6:	79bb      	ldrb	r3, [r7, #6]
 8000eb8:	2b00      	cmp	r3, #0
 8000eba:	d005      	beq.n	8000ec8 <switch_press+0xb4>
      boot_f1 = false;
 8000ebc:	4b19      	ldr	r3, [pc, #100]	@ (8000f24 <switch_press+0x110>)
 8000ebe:	2200      	movs	r2, #0
 8000ec0:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000ec2:	f7ff f9ef 	bl	80002a4 <jump_to_firmware>
 8000ec6:	e013      	b.n	8000ef0 <switch_press+0xdc>
    } else {
      boot_f1 = true;
 8000ec8:	4b16      	ldr	r3, [pc, #88]	@ (8000f24 <switch_press+0x110>)
 8000eca:	2201      	movs	r2, #1
 8000ecc:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000ece:	f7ff f9e9 	bl	80002a4 <jump_to_firmware>
 8000ed2:	e00d      	b.n	8000ef0 <switch_press+0xdc>
    }
  } else {
    if (f1_valid) {
 8000ed4:	79fb      	ldrb	r3, [r7, #7]
 8000ed6:	2b00      	cmp	r3, #0
 8000ed8:	d005      	beq.n	8000ee6 <switch_press+0xd2>
      boot_f1 = true;
 8000eda:	4b12      	ldr	r3, [pc, #72]	@ (8000f24 <switch_press+0x110>)
 8000edc:	2201      	movs	r2, #1
 8000ede:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000ee0:	f7ff f9e0 	bl	80002a4 <jump_to_firmware>
 8000ee4:	e004      	b.n	8000ef0 <switch_press+0xdc>
    } else {
      boot_f1 = false;
 8000ee6:	4b0f      	ldr	r3, [pc, #60]	@ (8000f24 <switch_press+0x110>)
 8000ee8:	2200      	movs	r2, #0
 8000eea:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000eec:	f7ff f9da 	bl	80002a4 <jump_to_firmware>
    }
  }
  return true;
 8000ef0:	2301      	movs	r3, #1
}
 8000ef2:	4618      	mov	r0, r3
 8000ef4:	3710      	adds	r7, #16
 8000ef6:	46bd      	mov	sp, r7
 8000ef8:	bd80      	pop	{r7, pc}
 8000efa:	bf00      	nop
 8000efc:	20000060 	.word	0x20000060
 8000f00:	20000064 	.word	0x20000064
 8000f04:	000f4240 	.word	0x000f4240
 8000f08:	08040000 	.word	0x08040000
 8000f0c:	20005076 	.word	0x20005076
 8000f10:	20005077 	.word	0x20005077
 8000f14:	08001abc 	.word	0x08001abc
 8000f18:	20005079 	.word	0x20005079
 8000f1c:	2000507a 	.word	0x2000507a
 8000f20:	2000507b 	.word	0x2000507b
 8000f24:	20000004 	.word	0x20000004

08000f28 <main>:


int main() {
 8000f28:	b580      	push	{r7, lr}
 8000f2a:	b082      	sub	sp, #8
 8000f2c:	af00      	add	r7, sp, #0

    Ring_buff_init(&ringbuffer);
 8000f2e:	4853      	ldr	r0, [pc, #332]	@ (800107c <main+0x154>)
 8000f30:	f7ff fa24 	bl	800037c <Ring_buff_init>

    // enable faults (without this any fault = hardfault)
    SCB->SHCSR |= SCB_SHCSR_BUSFAULTENA_Msk;
 8000f34:	4b52      	ldr	r3, [pc, #328]	@ (8001080 <main+0x158>)
 8000f36:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f38:	4a51      	ldr	r2, [pc, #324]	@ (8001080 <main+0x158>)
 8000f3a:	f443 3300 	orr.w	r3, r3, #131072	@ 0x20000
 8000f3e:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_USGFAULTENA_Msk;
 8000f40:	4b4f      	ldr	r3, [pc, #316]	@ (8001080 <main+0x158>)
 8000f42:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f44:	4a4e      	ldr	r2, [pc, #312]	@ (8001080 <main+0x158>)
 8000f46:	f443 2380 	orr.w	r3, r3, #262144	@ 0x40000
 8000f4a:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
 8000f4c:	4b4c      	ldr	r3, [pc, #304]	@ (8001080 <main+0x158>)
 8000f4e:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f50:	4a4b      	ldr	r2, [pc, #300]	@ (8001080 <main+0x158>)
 8000f52:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 8000f56:	6253      	str	r3, [r2, #36]	@ 0x24


  __usart1_init();
 8000f58:	f000 fa06 	bl	8001368 <__usart1_init>

  printf("\n\n\nbooting....\n\n\n\r", 0x0);
 8000f5c:	2100      	movs	r1, #0
 8000f5e:	4849      	ldr	r0, [pc, #292]	@ (8001084 <main+0x15c>)
 8000f60:	f7ff fbba 	bl	80006d8 <printf>

  // check if fimrware is corrupted during update

  if (*(uint32_t *)FIRMWARE_1_ADDRESS & 1) {
 8000f64:	4b48      	ldr	r3, [pc, #288]	@ (8001088 <main+0x160>)
 8000f66:	681b      	ldr	r3, [r3, #0]
 8000f68:	f003 0301 	and.w	r3, r3, #1
 8000f6c:	2b00      	cmp	r3, #0
 8000f6e:	d001      	beq.n	8000f74 <main+0x4c>
    rollback();
 8000f70:	f7ff fcde 	bl	8000930 <rollback>
  }
  if (*(uint32_t *)FIRMWARE_2_ADDRESS & 1) {
 8000f74:	4b45      	ldr	r3, [pc, #276]	@ (800108c <main+0x164>)
 8000f76:	681b      	ldr	r3, [r3, #0]
 8000f78:	f003 0301 	and.w	r3, r3, #1
 8000f7c:	2b00      	cmp	r3, #0
 8000f7e:	d001      	beq.n	8000f84 <main+0x5c>
    rollback();
 8000f80:	f7ff fcd6 	bl	8000930 <rollback>
  }

  bool f1_valid = true;
 8000f84:	2301      	movs	r3, #1
 8000f86:	71fb      	strb	r3, [r7, #7]
  bool f2_valid = true;
 8000f88:	2301      	movs	r3, #1
 8000f8a:	71bb      	strb	r3, [r7, #6]
  init_firmware_t(FIRMWARE_1_ADDRESS, &f1);
 8000f8c:	4940      	ldr	r1, [pc, #256]	@ (8001090 <main+0x168>)
 8000f8e:	483e      	ldr	r0, [pc, #248]	@ (8001088 <main+0x160>)
 8000f90:	f7ff fde8 	bl	8000b64 <init_firmware_t>
  init_firmware_t(FIRMWARE_2_ADDRESS, &f2);
 8000f94:	493f      	ldr	r1, [pc, #252]	@ (8001094 <main+0x16c>)
 8000f96:	483d      	ldr	r0, [pc, #244]	@ (800108c <main+0x164>)
 8000f98:	f7ff fde4 	bl	8000b64 <init_firmware_t>

  // printf("hii there %\n\r", f1.__vtable_address);

  printf("*************validating firmware1*************\n\r", 0x0);
 8000f9c:	2100      	movs	r1, #0
 8000f9e:	483e      	ldr	r0, [pc, #248]	@ (8001098 <main+0x170>)
 8000fa0:	f7ff fb9a 	bl	80006d8 <printf>
  f1_valid = validate_firmware(&f1, FIRMWARE_1_ADDRESS);
 8000fa4:	4938      	ldr	r1, [pc, #224]	@ (8001088 <main+0x160>)
 8000fa6:	483a      	ldr	r0, [pc, #232]	@ (8001090 <main+0x168>)
 8000fa8:	f7ff fd8a 	bl	8000ac0 <validate_firmware>
 8000fac:	4603      	mov	r3, r0
 8000fae:	71fb      	strb	r3, [r7, #7]
  printf("*************validating firmware2*************\n\r", 0x0);
 8000fb0:	2100      	movs	r1, #0
 8000fb2:	483a      	ldr	r0, [pc, #232]	@ (800109c <main+0x174>)
 8000fb4:	f7ff fb90 	bl	80006d8 <printf>
  f2_valid = validate_firmware(&f2, FIRMWARE_2_ADDRESS);
 8000fb8:	4934      	ldr	r1, [pc, #208]	@ (800108c <main+0x164>)
 8000fba:	4836      	ldr	r0, [pc, #216]	@ (8001094 <main+0x16c>)
 8000fbc:	f7ff fd80 	bl	8000ac0 <validate_firmware>
 8000fc0:	4603      	mov	r3, r0
 8000fc2:	71bb      	strb	r3, [r7, #6]

  printf("both the firmwares are checked\n\r", 0x0);
 8000fc4:	2100      	movs	r1, #0
 8000fc6:	4836      	ldr	r0, [pc, #216]	@ (80010a0 <main+0x178>)
 8000fc8:	f7ff fb86 	bl	80006d8 <printf>
  // init GPIOC (for on board switch)
  // init SYSCGF (for using EXTI)

  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN_Msk;
 8000fcc:	4b35      	ldr	r3, [pc, #212]	@ (80010a4 <main+0x17c>)
 8000fce:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8000fd0:	4a34      	ldr	r2, [pc, #208]	@ (80010a4 <main+0x17c>)
 8000fd2:	f443 4380 	orr.w	r3, r3, #16384	@ 0x4000
 8000fd6:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN_Msk;
 8000fd8:	4b32      	ldr	r3, [pc, #200]	@ (80010a4 <main+0x17c>)
 8000fda:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8000fdc:	4a31      	ldr	r2, [pc, #196]	@ (80010a4 <main+0x17c>)
 8000fde:	f043 0304 	orr.w	r3, r3, #4
 8000fe2:	6313      	str	r3, [r2, #48]	@ 0x30

  // set switch to input
  GPIOC->MODER &= ~(3U << (2 * SWITCH_PIN));
 8000fe4:	4b30      	ldr	r3, [pc, #192]	@ (80010a8 <main+0x180>)
 8000fe6:	681b      	ldr	r3, [r3, #0]
 8000fe8:	4a2f      	ldr	r2, [pc, #188]	@ (80010a8 <main+0x180>)
 8000fea:	f023 6340 	bic.w	r3, r3, #201326592	@ 0xc000000
 8000fee:	6013      	str	r3, [r2, #0]

  // falling edge detect
  EXTI->FTSR |= EXTI_FTSR_TR13_Msk;
 8000ff0:	4b2e      	ldr	r3, [pc, #184]	@ (80010ac <main+0x184>)
 8000ff2:	68db      	ldr	r3, [r3, #12]
 8000ff4:	4a2d      	ldr	r2, [pc, #180]	@ (80010ac <main+0x184>)
 8000ff6:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8000ffa:	60d3      	str	r3, [r2, #12]

  SYSCFG->EXTICR[3] &= ~(SYSCFG_EXTICR4_EXTI13_Msk);
 8000ffc:	4b2c      	ldr	r3, [pc, #176]	@ (80010b0 <main+0x188>)
 8000ffe:	695b      	ldr	r3, [r3, #20]
 8001000:	4a2b      	ldr	r2, [pc, #172]	@ (80010b0 <main+0x188>)
 8001002:	f023 03f0 	bic.w	r3, r3, #240	@ 0xf0
 8001006:	6153      	str	r3, [r2, #20]
  SYSCFG->EXTICR[3] |= SYSCFG_EXTICR4_EXTI13_PC;
 8001008:	4b29      	ldr	r3, [pc, #164]	@ (80010b0 <main+0x188>)
 800100a:	695b      	ldr	r3, [r3, #20]
 800100c:	4a28      	ldr	r2, [pc, #160]	@ (80010b0 <main+0x188>)
 800100e:	f043 0320 	orr.w	r3, r3, #32
 8001012:	6153      	str	r3, [r2, #20]

  // enable mask at the end
  EXTI->IMR |= EXTI_IMR_MR13_Msk;
 8001014:	4b25      	ldr	r3, [pc, #148]	@ (80010ac <main+0x184>)
 8001016:	681b      	ldr	r3, [r3, #0]
 8001018:	4a24      	ldr	r2, [pc, #144]	@ (80010ac <main+0x184>)
 800101a:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 800101e:	6013      	str	r3, [r2, #0]

  NVIC_EnableIRQ(EXTI15_10_IRQn);
 8001020:	2028      	movs	r0, #40	@ 0x28
 8001022:	f7ff fd83 	bl	8000b2c <__NVIC_EnableIRQ>

  if (!f1_valid && !f2_valid) {
 8001026:	79fb      	ldrb	r3, [r7, #7]
 8001028:	f083 0301 	eor.w	r3, r3, #1
 800102c:	b2db      	uxtb	r3, r3
 800102e:	2b00      	cmp	r3, #0
 8001030:	d011      	beq.n	8001056 <main+0x12e>
 8001032:	79bb      	ldrb	r3, [r7, #6]
 8001034:	f083 0301 	eor.w	r3, r3, #1
 8001038:	b2db      	uxtb	r3, r3
 800103a:	2b00      	cmp	r3, #0
 800103c:	d00b      	beq.n	8001056 <main+0x12e>
    printf("both the firmwares are not valid\n\n\r", 0x0);
 800103e:	2100      	movs	r1, #0
 8001040:	481c      	ldr	r0, [pc, #112]	@ (80010b4 <main+0x18c>)
 8001042:	f7ff fb49 	bl	80006d8 <printf>
    EXTI->IMR &= EXTI_IMR_MR13_Msk;
 8001046:	4b19      	ldr	r3, [pc, #100]	@ (80010ac <main+0x184>)
 8001048:	681b      	ldr	r3, [r3, #0]
 800104a:	4a18      	ldr	r2, [pc, #96]	@ (80010ac <main+0x184>)
 800104c:	f403 5300 	and.w	r3, r3, #8192	@ 0x2000
 8001050:	6013      	str	r3, [r2, #0]
    handle_update();
 8001052:	f7ff fe04 	bl	8000c5e <handle_update>
  }

  // /* illegal memory access */
  // *(uint32_t *) (0xffffffff) = 0;
  
  bool status = switch_press (f1_valid, f2_valid);
 8001056:	79ba      	ldrb	r2, [r7, #6]
 8001058:	79fb      	ldrb	r3, [r7, #7]
 800105a:	4611      	mov	r1, r2
 800105c:	4618      	mov	r0, r3
 800105e:	f7ff fed9 	bl	8000e14 <switch_press>
 8001062:	4603      	mov	r3, r0
 8001064:	717b      	strb	r3, [r7, #5]
  if (!status){
 8001066:	797b      	ldrb	r3, [r7, #5]
 8001068:	f083 0301 	eor.w	r3, r3, #1
 800106c:	b2db      	uxtb	r3, r3
 800106e:	2b00      	cmp	r3, #0
 8001070:	d003      	beq.n	800107a <main+0x152>
    printf ("too many wrong firmware update attempt !!!\n\r", 0x0);
 8001072:	2100      	movs	r1, #0
 8001074:	4810      	ldr	r0, [pc, #64]	@ (80010b8 <main+0x190>)
 8001076:	f7ff fb2f 	bl	80006d8 <printf>
  }
  while (1);
 800107a:	e7fe      	b.n	800107a <main+0x152>
 800107c:	20000070 	.word	0x20000070
 8001080:	e000ed00 	.word	0xe000ed00
 8001084:	08001ad8 	.word	0x08001ad8
 8001088:	08004000 	.word	0x08004000
 800108c:	08020000 	.word	0x08020000
 8001090:	20000008 	.word	0x20000008
 8001094:	20000034 	.word	0x20000034
 8001098:	08001aec 	.word	0x08001aec
 800109c:	08001b20 	.word	0x08001b20
 80010a0:	08001b54 	.word	0x08001b54
 80010a4:	40023800 	.word	0x40023800
 80010a8:	40020800 	.word	0x40020800
 80010ac:	40013c00 	.word	0x40013c00
 80010b0:	40013800 	.word	0x40013800
 80010b4:	08001b78 	.word	0x08001b78
 80010b8:	08001b9c 	.word	0x08001b9c

080010bc <erase_flash>:
#define KEY1 0x45670123
#define KEY2 0xCDEF89AB

void printf (const char *string, uint32_t addr);

uint32_t erase_flash(uint32_t address) {
 80010bc:	b580      	push	{r7, lr}
 80010be:	b084      	sub	sp, #16
 80010c0:	af00      	add	r7, sp, #0
 80010c2:	6078      	str	r0, [r7, #4]
  if (address >= 0x08080000 || address < 0x08000000) {
 80010c4:	687b      	ldr	r3, [r7, #4]
 80010c6:	4a4c      	ldr	r2, [pc, #304]	@ (80011f8 <erase_flash+0x13c>)
 80010c8:	4293      	cmp	r3, r2
 80010ca:	d803      	bhi.n	80010d4 <erase_flash+0x18>
 80010cc:	687b      	ldr	r3, [r7, #4]
 80010ce:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 80010d2:	d206      	bcs.n	80010e2 <erase_flash+0x26>
    printf("wrong address \n\r", 0x0);
 80010d4:	2100      	movs	r1, #0
 80010d6:	4849      	ldr	r0, [pc, #292]	@ (80011fc <erase_flash+0x140>)
 80010d8:	f7ff fafe 	bl	80006d8 <printf>
    return -1;
 80010dc:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80010e0:	e085      	b.n	80011ee <erase_flash+0x132>
  }

  uint32_t sector = 0;
 80010e2:	2300      	movs	r3, #0
 80010e4:	60fb      	str	r3, [r7, #12]
  if (address >= 0x08060000)
 80010e6:	687b      	ldr	r3, [r7, #4]
 80010e8:	4a45      	ldr	r2, [pc, #276]	@ (8001200 <erase_flash+0x144>)
 80010ea:	4293      	cmp	r3, r2
 80010ec:	d902      	bls.n	80010f4 <erase_flash+0x38>
    sector = 7;
 80010ee:	2307      	movs	r3, #7
 80010f0:	60fb      	str	r3, [r7, #12]
 80010f2:	e037      	b.n	8001164 <erase_flash+0xa8>
  else if (address >= 0x08040000)
 80010f4:	687b      	ldr	r3, [r7, #4]
 80010f6:	4a43      	ldr	r2, [pc, #268]	@ (8001204 <erase_flash+0x148>)
 80010f8:	4293      	cmp	r3, r2
 80010fa:	d902      	bls.n	8001102 <erase_flash+0x46>
    sector = 6;
 80010fc:	2306      	movs	r3, #6
 80010fe:	60fb      	str	r3, [r7, #12]
 8001100:	e030      	b.n	8001164 <erase_flash+0xa8>
  else if (address >= 0x08020000)
 8001102:	687b      	ldr	r3, [r7, #4]
 8001104:	4a40      	ldr	r2, [pc, #256]	@ (8001208 <erase_flash+0x14c>)
 8001106:	4293      	cmp	r3, r2
 8001108:	d902      	bls.n	8001110 <erase_flash+0x54>
    sector = 5;
 800110a:	2305      	movs	r3, #5
 800110c:	60fb      	str	r3, [r7, #12]
 800110e:	e029      	b.n	8001164 <erase_flash+0xa8>
  else if (address >= 0x08010000)
 8001110:	687b      	ldr	r3, [r7, #4]
 8001112:	4a3e      	ldr	r2, [pc, #248]	@ (800120c <erase_flash+0x150>)
 8001114:	4293      	cmp	r3, r2
 8001116:	d902      	bls.n	800111e <erase_flash+0x62>
    sector = 4;
 8001118:	2304      	movs	r3, #4
 800111a:	60fb      	str	r3, [r7, #12]
 800111c:	e022      	b.n	8001164 <erase_flash+0xa8>
  else if (address >= 0x0800c000)
 800111e:	687b      	ldr	r3, [r7, #4]
 8001120:	4a3b      	ldr	r2, [pc, #236]	@ (8001210 <erase_flash+0x154>)
 8001122:	4293      	cmp	r3, r2
 8001124:	d302      	bcc.n	800112c <erase_flash+0x70>
    sector = 3;
 8001126:	2303      	movs	r3, #3
 8001128:	60fb      	str	r3, [r7, #12]
 800112a:	e01b      	b.n	8001164 <erase_flash+0xa8>
  else if (address >= 0x08008000)
 800112c:	687b      	ldr	r3, [r7, #4]
 800112e:	4a39      	ldr	r2, [pc, #228]	@ (8001214 <erase_flash+0x158>)
 8001130:	4293      	cmp	r3, r2
 8001132:	d302      	bcc.n	800113a <erase_flash+0x7e>
    sector = 2;
 8001134:	2302      	movs	r3, #2
 8001136:	60fb      	str	r3, [r7, #12]
 8001138:	e014      	b.n	8001164 <erase_flash+0xa8>
  else if (address >= 0x08004000)
 800113a:	687b      	ldr	r3, [r7, #4]
 800113c:	4a36      	ldr	r2, [pc, #216]	@ (8001218 <erase_flash+0x15c>)
 800113e:	4293      	cmp	r3, r2
 8001140:	d302      	bcc.n	8001148 <erase_flash+0x8c>
    sector = 1;
 8001142:	2301      	movs	r3, #1
 8001144:	60fb      	str	r3, [r7, #12]
 8001146:	e00d      	b.n	8001164 <erase_flash+0xa8>
  else if (address >= 0x08000000)
 8001148:	687b      	ldr	r3, [r7, #4]
 800114a:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 800114e:	d302      	bcc.n	8001156 <erase_flash+0x9a>
    sector = 0;
 8001150:	2300      	movs	r3, #0
 8001152:	60fb      	str	r3, [r7, #12]
 8001154:	e006      	b.n	8001164 <erase_flash+0xa8>
  else {
    printf("wrong address\n\r", 0x0);
 8001156:	2100      	movs	r1, #0
 8001158:	4830      	ldr	r0, [pc, #192]	@ (800121c <erase_flash+0x160>)
 800115a:	f7ff fabd 	bl	80006d8 <printf>
    return -1;
 800115e:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 8001162:	e044      	b.n	80011ee <erase_flash+0x132>
  }
  // unlock
  FLASH->KEYR = KEY1;
 8001164:	4b2e      	ldr	r3, [pc, #184]	@ (8001220 <erase_flash+0x164>)
 8001166:	4a2f      	ldr	r2, [pc, #188]	@ (8001224 <erase_flash+0x168>)
 8001168:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 800116a:	4b2d      	ldr	r3, [pc, #180]	@ (8001220 <erase_flash+0x164>)
 800116c:	4a2e      	ldr	r2, [pc, #184]	@ (8001228 <erase_flash+0x16c>)
 800116e:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8001170:	4b2b      	ldr	r3, [pc, #172]	@ (8001220 <erase_flash+0x164>)
 8001172:	68db      	ldr	r3, [r3, #12]
 8001174:	4a2a      	ldr	r2, [pc, #168]	@ (8001220 <erase_flash+0x164>)
 8001176:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 800117a:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 800117c:	bf00      	nop
 800117e:	4b28      	ldr	r3, [pc, #160]	@ (8001220 <erase_flash+0x164>)
 8001180:	68db      	ldr	r3, [r3, #12]
 8001182:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 8001186:	2b00      	cmp	r3, #0
 8001188:	d1f9      	bne.n	800117e <erase_flash+0xc2>
    ;

  FLASH->CR |= FLASH_CR_SER;
 800118a:	4b25      	ldr	r3, [pc, #148]	@ (8001220 <erase_flash+0x164>)
 800118c:	691b      	ldr	r3, [r3, #16]
 800118e:	4a24      	ldr	r2, [pc, #144]	@ (8001220 <erase_flash+0x164>)
 8001190:	f043 0302 	orr.w	r3, r3, #2
 8001194:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(FLASH_CR_SNB);
 8001196:	4b22      	ldr	r3, [pc, #136]	@ (8001220 <erase_flash+0x164>)
 8001198:	691b      	ldr	r3, [r3, #16]
 800119a:	4a21      	ldr	r2, [pc, #132]	@ (8001220 <erase_flash+0x164>)
 800119c:	f023 03f8 	bic.w	r3, r3, #248	@ 0xf8
 80011a0:	6113      	str	r3, [r2, #16]
  FLASH->CR |= (sector << FLASH_CR_SNB_Pos);
 80011a2:	4b1f      	ldr	r3, [pc, #124]	@ (8001220 <erase_flash+0x164>)
 80011a4:	691a      	ldr	r2, [r3, #16]
 80011a6:	68fb      	ldr	r3, [r7, #12]
 80011a8:	00db      	lsls	r3, r3, #3
 80011aa:	491d      	ldr	r1, [pc, #116]	@ (8001220 <erase_flash+0x164>)
 80011ac:	4313      	orrs	r3, r2
 80011ae:	610b      	str	r3, [r1, #16]
  FLASH->CR |= FLASH_CR_STRT;
 80011b0:	4b1b      	ldr	r3, [pc, #108]	@ (8001220 <erase_flash+0x164>)
 80011b2:	691b      	ldr	r3, [r3, #16]
 80011b4:	4a1a      	ldr	r2, [pc, #104]	@ (8001220 <erase_flash+0x164>)
 80011b6:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 80011ba:	6113      	str	r3, [r2, #16]

  // wait for the flash to be erased;
  while (FLASH->SR & FLASH_SR_BSY)
 80011bc:	bf00      	nop
 80011be:	4b18      	ldr	r3, [pc, #96]	@ (8001220 <erase_flash+0x164>)
 80011c0:	68db      	ldr	r3, [r3, #12]
 80011c2:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 80011c6:	2b00      	cmp	r3, #0
 80011c8:	d1f9      	bne.n	80011be <erase_flash+0x102>
    ;

  // clear the erase bit
  FLASH->CR &= ~(FLASH_CR_SER);
 80011ca:	4b15      	ldr	r3, [pc, #84]	@ (8001220 <erase_flash+0x164>)
 80011cc:	691b      	ldr	r3, [r3, #16]
 80011ce:	4a14      	ldr	r2, [pc, #80]	@ (8001220 <erase_flash+0x164>)
 80011d0:	f023 0302 	bic.w	r3, r3, #2
 80011d4:	6113      	str	r3, [r2, #16]
  // lock the control register
  FLASH->CR |= FLASH_CR_LOCK;
 80011d6:	4b12      	ldr	r3, [pc, #72]	@ (8001220 <erase_flash+0x164>)
 80011d8:	691b      	ldr	r3, [r3, #16]
 80011da:	4a11      	ldr	r2, [pc, #68]	@ (8001220 <erase_flash+0x164>)
 80011dc:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 80011e0:	6113      	str	r3, [r2, #16]

  printf("done erasing flash (address = %)\n\r", (uint32_t)(&address));
 80011e2:	1d3b      	adds	r3, r7, #4
 80011e4:	4619      	mov	r1, r3
 80011e6:	4811      	ldr	r0, [pc, #68]	@ (800122c <erase_flash+0x170>)
 80011e8:	f7ff fa76 	bl	80006d8 <printf>
  return 0;
 80011ec:	2300      	movs	r3, #0
}
 80011ee:	4618      	mov	r0, r3
 80011f0:	3710      	adds	r7, #16
 80011f2:	46bd      	mov	sp, r7
 80011f4:	bd80      	pop	{r7, pc}
 80011f6:	bf00      	nop
 80011f8:	0807ffff 	.word	0x0807ffff
 80011fc:	08001bcc 	.word	0x08001bcc
 8001200:	0805ffff 	.word	0x0805ffff
 8001204:	0803ffff 	.word	0x0803ffff
 8001208:	0801ffff 	.word	0x0801ffff
 800120c:	0800ffff 	.word	0x0800ffff
 8001210:	0800c000 	.word	0x0800c000
 8001214:	08008000 	.word	0x08008000
 8001218:	08004000 	.word	0x08004000
 800121c:	08001be0 	.word	0x08001be0
 8001220:	40023c00 	.word	0x40023c00
 8001224:	45670123 	.word	0x45670123
 8001228:	cdef89ab 	.word	0xcdef89ab
 800122c:	08001bf0 	.word	0x08001bf0

08001230 <flash_write>:

uint32_t flash_write(uint32_t address, const char *buff, uint32_t size,
                     uint32_t simulate) {
 8001230:	b480      	push	{r7}
 8001232:	b087      	sub	sp, #28
 8001234:	af00      	add	r7, sp, #0
 8001236:	60f8      	str	r0, [r7, #12]
 8001238:	60b9      	str	r1, [r7, #8]
 800123a:	607a      	str	r2, [r7, #4]
 800123c:	603b      	str	r3, [r7, #0]


  // unlock
  FLASH->KEYR = KEY1;
 800123e:	4b26      	ldr	r3, [pc, #152]	@ (80012d8 <flash_write+0xa8>)
 8001240:	4a26      	ldr	r2, [pc, #152]	@ (80012dc <flash_write+0xac>)
 8001242:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 8001244:	4b24      	ldr	r3, [pc, #144]	@ (80012d8 <flash_write+0xa8>)
 8001246:	4a26      	ldr	r2, [pc, #152]	@ (80012e0 <flash_write+0xb0>)
 8001248:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 800124a:	4b23      	ldr	r3, [pc, #140]	@ (80012d8 <flash_write+0xa8>)
 800124c:	68db      	ldr	r3, [r3, #12]
 800124e:	4a22      	ldr	r2, [pc, #136]	@ (80012d8 <flash_write+0xa8>)
 8001250:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 8001254:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 8001256:	bf00      	nop
 8001258:	4b1f      	ldr	r3, [pc, #124]	@ (80012d8 <flash_write+0xa8>)
 800125a:	68db      	ldr	r3, [r3, #12]
 800125c:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 8001260:	2b00      	cmp	r3, #0
 8001262:	d1f9      	bne.n	8001258 <flash_write+0x28>
    ;
  FLASH->CR |= FLASH_CR_PG;
 8001264:	4b1c      	ldr	r3, [pc, #112]	@ (80012d8 <flash_write+0xa8>)
 8001266:	691b      	ldr	r3, [r3, #16]
 8001268:	4a1b      	ldr	r2, [pc, #108]	@ (80012d8 <flash_write+0xa8>)
 800126a:	f043 0301 	orr.w	r3, r3, #1
 800126e:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(3 << FLASH_CR_PSIZE_Pos);
 8001270:	4b19      	ldr	r3, [pc, #100]	@ (80012d8 <flash_write+0xa8>)
 8001272:	691b      	ldr	r3, [r3, #16]
 8001274:	4a18      	ldr	r2, [pc, #96]	@ (80012d8 <flash_write+0xa8>)
 8001276:	f423 7340 	bic.w	r3, r3, #768	@ 0x300
 800127a:	6113      	str	r3, [r2, #16]
  // set PSIZE bit to 2 for 32 bit programming
  FLASH->CR |= 2 << FLASH_CR_PSIZE_Pos;
 800127c:	4b16      	ldr	r3, [pc, #88]	@ (80012d8 <flash_write+0xa8>)
 800127e:	691b      	ldr	r3, [r3, #16]
 8001280:	4a15      	ldr	r2, [pc, #84]	@ (80012d8 <flash_write+0xa8>)
 8001282:	f443 7300 	orr.w	r3, r3, #512	@ 0x200
 8001286:	6113      	str	r3, [r2, #16]

  uint32_t i = 0;
 8001288:	2300      	movs	r3, #0
 800128a:	617b      	str	r3, [r7, #20]
  while (i < size / 4) {
 800128c:	e00c      	b.n	80012a8 <flash_write+0x78>

    *((uint32_t *)address) = ((const uint32_t *)buff)[i];
 800128e:	697b      	ldr	r3, [r7, #20]
 8001290:	009b      	lsls	r3, r3, #2
 8001292:	68ba      	ldr	r2, [r7, #8]
 8001294:	441a      	add	r2, r3
 8001296:	68fb      	ldr	r3, [r7, #12]
 8001298:	6812      	ldr	r2, [r2, #0]
 800129a:	601a      	str	r2, [r3, #0]
    i++;
 800129c:	697b      	ldr	r3, [r7, #20]
 800129e:	3301      	adds	r3, #1
 80012a0:	617b      	str	r3, [r7, #20]
    address += 4;
 80012a2:	68fb      	ldr	r3, [r7, #12]
 80012a4:	3304      	adds	r3, #4
 80012a6:	60fb      	str	r3, [r7, #12]
  while (i < size / 4) {
 80012a8:	687b      	ldr	r3, [r7, #4]
 80012aa:	089b      	lsrs	r3, r3, #2
 80012ac:	697a      	ldr	r2, [r7, #20]
 80012ae:	429a      	cmp	r2, r3
 80012b0:	d3ed      	bcc.n	800128e <flash_write+0x5e>
  }
  FLASH->CR &= ~(FLASH_CR_PG);
 80012b2:	4b09      	ldr	r3, [pc, #36]	@ (80012d8 <flash_write+0xa8>)
 80012b4:	691b      	ldr	r3, [r3, #16]
 80012b6:	4a08      	ldr	r2, [pc, #32]	@ (80012d8 <flash_write+0xa8>)
 80012b8:	f023 0301 	bic.w	r3, r3, #1
 80012bc:	6113      	str	r3, [r2, #16]
  FLASH->CR |= FLASH_CR_LOCK;
 80012be:	4b06      	ldr	r3, [pc, #24]	@ (80012d8 <flash_write+0xa8>)
 80012c0:	691b      	ldr	r3, [r3, #16]
 80012c2:	4a05      	ldr	r2, [pc, #20]	@ (80012d8 <flash_write+0xa8>)
 80012c4:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 80012c8:	6113      	str	r3, [r2, #16]

  return 0;
 80012ca:	2300      	movs	r3, #0
}
 80012cc:	4618      	mov	r0, r3
 80012ce:	371c      	adds	r7, #28
 80012d0:	46bd      	mov	sp, r7
 80012d2:	bc80      	pop	{r7}
 80012d4:	4770      	bx	lr
 80012d6:	bf00      	nop
 80012d8:	40023c00 	.word	0x40023c00
 80012dc:	45670123 	.word	0x45670123
 80012e0:	cdef89ab 	.word	0xcdef89ab

080012e4 <__NVIC_EnableIRQ>:
{
 80012e4:	b480      	push	{r7}
 80012e6:	b083      	sub	sp, #12
 80012e8:	af00      	add	r7, sp, #0
 80012ea:	4603      	mov	r3, r0
 80012ec:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 80012ee:	f997 3007 	ldrsb.w	r3, [r7, #7]
 80012f2:	2b00      	cmp	r3, #0
 80012f4:	db0b      	blt.n	800130e <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 80012f6:	79fb      	ldrb	r3, [r7, #7]
 80012f8:	f003 021f 	and.w	r2, r3, #31
 80012fc:	4906      	ldr	r1, [pc, #24]	@ (8001318 <__NVIC_EnableIRQ+0x34>)
 80012fe:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8001302:	095b      	lsrs	r3, r3, #5
 8001304:	2001      	movs	r0, #1
 8001306:	fa00 f202 	lsl.w	r2, r0, r2
 800130a:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 800130e:	bf00      	nop
 8001310:	370c      	adds	r7, #12
 8001312:	46bd      	mov	sp, r7
 8001314:	bc80      	pop	{r7}
 8001316:	4770      	bx	lr
 8001318:	e000e100 	.word	0xe000e100

0800131c <__usart1_scan>:
#include "stm32f401xe.h"

#define TX_PIN 9
#define RX_PIN 10

void __usart1_scan (char* buffer, uint16_t size){
 800131c:	b480      	push	{r7}
 800131e:	b085      	sub	sp, #20
 8001320:	af00      	add	r7, sp, #0
 8001322:	6078      	str	r0, [r7, #4]
 8001324:	460b      	mov	r3, r1
 8001326:	807b      	strh	r3, [r7, #2]
  
  uint16_t i = 0;
 8001328:	2300      	movs	r3, #0
 800132a:	81fb      	strh	r3, [r7, #14]
  while (i < size) {
 800132c:	e010      	b.n	8001350 <__usart1_scan+0x34>
    // wait
    while (!(USART1->SR & USART_SR_RXNE))
 800132e:	bf00      	nop
 8001330:	4b0c      	ldr	r3, [pc, #48]	@ (8001364 <__usart1_scan+0x48>)
 8001332:	681b      	ldr	r3, [r3, #0]
 8001334:	f003 0320 	and.w	r3, r3, #32
 8001338:	2b00      	cmp	r3, #0
 800133a:	d0f9      	beq.n	8001330 <__usart1_scan+0x14>
      ;
    buffer[i++] = USART1->DR;
 800133c:	4b09      	ldr	r3, [pc, #36]	@ (8001364 <__usart1_scan+0x48>)
 800133e:	685a      	ldr	r2, [r3, #4]
 8001340:	89fb      	ldrh	r3, [r7, #14]
 8001342:	1c59      	adds	r1, r3, #1
 8001344:	81f9      	strh	r1, [r7, #14]
 8001346:	4619      	mov	r1, r3
 8001348:	687b      	ldr	r3, [r7, #4]
 800134a:	440b      	add	r3, r1
 800134c:	b2d2      	uxtb	r2, r2
 800134e:	701a      	strb	r2, [r3, #0]
  while (i < size) {
 8001350:	89fa      	ldrh	r2, [r7, #14]
 8001352:	887b      	ldrh	r3, [r7, #2]
 8001354:	429a      	cmp	r2, r3
 8001356:	d3ea      	bcc.n	800132e <__usart1_scan+0x12>
  }
}
 8001358:	bf00      	nop
 800135a:	bf00      	nop
 800135c:	3714      	adds	r7, #20
 800135e:	46bd      	mov	sp, r7
 8001360:	bc80      	pop	{r7}
 8001362:	4770      	bx	lr
 8001364:	40011000 	.word	0x40011000

08001368 <__usart1_init>:

void __usart1_init(void) {
 8001368:	b580      	push	{r7, lr}
 800136a:	af00      	add	r7, sp, #0

  RCC->APB2ENR |= RCC_APB2ENR_USART1EN_Msk;
 800136c:	4b20      	ldr	r3, [pc, #128]	@ (80013f0 <__usart1_init+0x88>)
 800136e:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8001370:	4a1f      	ldr	r2, [pc, #124]	@ (80013f0 <__usart1_init+0x88>)
 8001372:	f043 0310 	orr.w	r3, r3, #16
 8001376:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
 8001378:	4b1d      	ldr	r3, [pc, #116]	@ (80013f0 <__usart1_init+0x88>)
 800137a:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 800137c:	4a1c      	ldr	r2, [pc, #112]	@ (80013f0 <__usart1_init+0x88>)
 800137e:	f043 0301 	orr.w	r3, r3, #1
 8001382:	6313      	str	r3, [r2, #48]	@ 0x30
  // alternate function mode
  GPIOA->MODER &= ~((3 << (2 * TX_PIN)) | (3 << (2 * RX_PIN)));
 8001384:	4b1b      	ldr	r3, [pc, #108]	@ (80013f4 <__usart1_init+0x8c>)
 8001386:	681b      	ldr	r3, [r3, #0]
 8001388:	4a1a      	ldr	r2, [pc, #104]	@ (80013f4 <__usart1_init+0x8c>)
 800138a:	f423 1370 	bic.w	r3, r3, #3932160	@ 0x3c0000
 800138e:	6013      	str	r3, [r2, #0]
  GPIOA->MODER |= 2 << (2 * TX_PIN) | 2 << (2 * RX_PIN);
 8001390:	4b18      	ldr	r3, [pc, #96]	@ (80013f4 <__usart1_init+0x8c>)
 8001392:	681b      	ldr	r3, [r3, #0]
 8001394:	4a17      	ldr	r2, [pc, #92]	@ (80013f4 <__usart1_init+0x8c>)
 8001396:	f443 1320 	orr.w	r3, r3, #2621440	@ 0x280000
 800139a:	6013      	str	r3, [r2, #0]
  // high speed
  GPIOA->OSPEEDR |= (3 << (TX_PIN * 2)) | (3 << (RX_PIN * 2));
 800139c:	4b15      	ldr	r3, [pc, #84]	@ (80013f4 <__usart1_init+0x8c>)
 800139e:	689b      	ldr	r3, [r3, #8]
 80013a0:	4a14      	ldr	r2, [pc, #80]	@ (80013f4 <__usart1_init+0x8c>)
 80013a2:	f443 1370 	orr.w	r3, r3, #3932160	@ 0x3c0000
 80013a6:	6093      	str	r3, [r2, #8]
  // clear the bits in AFR register
  GPIOA->AFR[1] &= ~((0xf << 4) | (0xf << 8));
 80013a8:	4b12      	ldr	r3, [pc, #72]	@ (80013f4 <__usart1_init+0x8c>)
 80013aa:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80013ac:	4a11      	ldr	r2, [pc, #68]	@ (80013f4 <__usart1_init+0x8c>)
 80013ae:	f423 637f 	bic.w	r3, r3, #4080	@ 0xff0
 80013b2:	6253      	str	r3, [r2, #36]	@ 0x24
  // set for af7
  GPIOA->AFR[1] |= (7 << 4) | (7 << 8);
 80013b4:	4b0f      	ldr	r3, [pc, #60]	@ (80013f4 <__usart1_init+0x8c>)
 80013b6:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80013b8:	4a0e      	ldr	r2, [pc, #56]	@ (80013f4 <__usart1_init+0x8c>)
 80013ba:	f443 63ee 	orr.w	r3, r3, #1904	@ 0x770
 80013be:	6253      	str	r3, [r2, #36]	@ 0x24

  // set the baud rate (115200 in this case)
  USART1->BRR = 0x08B;
 80013c0:	4b0d      	ldr	r3, [pc, #52]	@ (80013f8 <__usart1_init+0x90>)
 80013c2:	228b      	movs	r2, #139	@ 0x8b
 80013c4:	609a      	str	r2, [r3, #8]

  // enable usart reciever interrupt;
  USART1->CR1 = USART_CR1_RXNEIE;
 80013c6:	4b0c      	ldr	r3, [pc, #48]	@ (80013f8 <__usart1_init+0x90>)
 80013c8:	2220      	movs	r2, #32
 80013ca:	60da      	str	r2, [r3, #12]

  NVIC_EnableIRQ (USART1_IRQn);
 80013cc:	2025      	movs	r0, #37	@ 0x25
 80013ce:	f7ff ff89 	bl	80012e4 <__NVIC_EnableIRQ>

  // enable transmitter and reciever at the end
  USART1->CR1 |= USART_CR1_RE | USART_CR1_TE;
 80013d2:	4b09      	ldr	r3, [pc, #36]	@ (80013f8 <__usart1_init+0x90>)
 80013d4:	68db      	ldr	r3, [r3, #12]
 80013d6:	4a08      	ldr	r2, [pc, #32]	@ (80013f8 <__usart1_init+0x90>)
 80013d8:	f043 030c 	orr.w	r3, r3, #12
 80013dc:	60d3      	str	r3, [r2, #12]

  // enable usart
  USART1->CR1 |= USART_CR1_UE;
 80013de:	4b06      	ldr	r3, [pc, #24]	@ (80013f8 <__usart1_init+0x90>)
 80013e0:	68db      	ldr	r3, [r3, #12]
 80013e2:	4a05      	ldr	r2, [pc, #20]	@ (80013f8 <__usart1_init+0x90>)
 80013e4:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 80013e8:	60d3      	str	r3, [r2, #12]

}
 80013ea:	bf00      	nop
 80013ec:	bd80      	pop	{r7, pc}
 80013ee:	bf00      	nop
 80013f0:	40023800 	.word	0x40023800
 80013f4:	40020000 	.word	0x40020000
 80013f8:	40011000 	.word	0x40011000

080013fc <__usart1_print>:

void __usart1_print(const char *msg, uint32_t size) {
 80013fc:	b480      	push	{r7}
 80013fe:	b085      	sub	sp, #20
 8001400:	af00      	add	r7, sp, #0
 8001402:	6078      	str	r0, [r7, #4]
 8001404:	6039      	str	r1, [r7, #0]

  int i = 0;
 8001406:	2300      	movs	r3, #0
 8001408:	60fb      	str	r3, [r7, #12]
  while (i < size && msg[i] != '\0') {
 800140a:	e00f      	b.n	800142c <__usart1_print+0x30>
    while (!(USART1->SR & USART_SR_TXE))
 800140c:	bf00      	nop
 800140e:	4b13      	ldr	r3, [pc, #76]	@ (800145c <__usart1_print+0x60>)
 8001410:	681b      	ldr	r3, [r3, #0]
 8001412:	f003 0380 	and.w	r3, r3, #128	@ 0x80
 8001416:	2b00      	cmp	r3, #0
 8001418:	d0f9      	beq.n	800140e <__usart1_print+0x12>
      ;
    USART1->DR = msg[i++];
 800141a:	68fb      	ldr	r3, [r7, #12]
 800141c:	1c5a      	adds	r2, r3, #1
 800141e:	60fa      	str	r2, [r7, #12]
 8001420:	461a      	mov	r2, r3
 8001422:	687b      	ldr	r3, [r7, #4]
 8001424:	4413      	add	r3, r2
 8001426:	781a      	ldrb	r2, [r3, #0]
 8001428:	4b0c      	ldr	r3, [pc, #48]	@ (800145c <__usart1_print+0x60>)
 800142a:	605a      	str	r2, [r3, #4]
  while (i < size && msg[i] != '\0') {
 800142c:	68fb      	ldr	r3, [r7, #12]
 800142e:	683a      	ldr	r2, [r7, #0]
 8001430:	429a      	cmp	r2, r3
 8001432:	d905      	bls.n	8001440 <__usart1_print+0x44>
 8001434:	68fb      	ldr	r3, [r7, #12]
 8001436:	687a      	ldr	r2, [r7, #4]
 8001438:	4413      	add	r3, r2
 800143a:	781b      	ldrb	r3, [r3, #0]
 800143c:	2b00      	cmp	r3, #0
 800143e:	d1e5      	bne.n	800140c <__usart1_print+0x10>
  }
  while (!(USART1->SR & USART_SR_TC)) {
 8001440:	bf00      	nop
 8001442:	4b06      	ldr	r3, [pc, #24]	@ (800145c <__usart1_print+0x60>)
 8001444:	681b      	ldr	r3, [r3, #0]
 8001446:	f003 0340 	and.w	r3, r3, #64	@ 0x40
 800144a:	2b00      	cmp	r3, #0
 800144c:	d0f9      	beq.n	8001442 <__usart1_print+0x46>
  }
}
 800144e:	bf00      	nop
 8001450:	bf00      	nop
 8001452:	3714      	adds	r7, #20
 8001454:	46bd      	mov	sp, r7
 8001456:	bc80      	pop	{r7}
 8001458:	4770      	bx	lr
 800145a:	bf00      	nop
 800145c:	40011000 	.word	0x40011000

08001460 <Reset_Handler>:
 8001460:	480c      	ldr	r0, [pc, #48]	@ (8001494 <hang+0x4>)
 8001462:	490d      	ldr	r1, [pc, #52]	@ (8001498 <hang+0x8>)
 8001464:	4a0d      	ldr	r2, [pc, #52]	@ (800149c <hang+0xc>)
 8001466:	e7ff      	b.n	8001468 <copy>

08001468 <copy>:
 8001468:	4288      	cmp	r0, r1
 800146a:	db04      	blt.n	8001476 <copy_helper>
 800146c:	480c      	ldr	r0, [pc, #48]	@ (80014a0 <hang+0x10>)
 800146e:	490d      	ldr	r1, [pc, #52]	@ (80014a4 <hang+0x14>)
 8001470:	f04f 0200 	mov.w	r2, #0
 8001474:	e004      	b.n	8001480 <init_zero>

08001476 <copy_helper>:
 8001476:	f852 3b04 	ldr.w	r3, [r2], #4
 800147a:	f840 3b04 	str.w	r3, [r0], #4
 800147e:	e7f3      	b.n	8001468 <copy>

08001480 <init_zero>:
 8001480:	4288      	cmp	r0, r1
 8001482:	db00      	blt.n	8001486 <init_zero_helper>
 8001484:	e002      	b.n	800148c <call_entry>

08001486 <init_zero_helper>:
 8001486:	f840 2b04 	str.w	r2, [r0], #4
 800148a:	e7f9      	b.n	8001480 <init_zero>

0800148c <call_entry>:
 800148c:	f7ff bd4c 	b.w	8000f28 <main>

08001490 <hang>:
 8001490:	e7fe      	b.n	8001490 <hang>
 8001492:	0000      	.short	0x0000
 8001494:	20000000 	.word	0x20000000
 8001498:	20000005 	.word	0x20000005
 800149c:	08001c13 	.word	0x08001c13
 80014a0:	20000008 	.word	0x20000008
 80014a4:	2000507c 	.word	0x2000507c

080014a8 <EXTI15_10_IRQ_handler>:
 80014a8:	f7ff b82e 	b.w	8000508 <switch_pressed>

080014ac <Default_Handler>:
 80014ac:	e7fe      	b.n	80014ac <Default_Handler>

080014ae <BusFault_Handler>:
 80014ae:	f3ef 8008 	mrs	r0, MSP
 80014b2:	6980      	ldr	r0, [r0, #24]
 80014b4:	f04f 0100 	mov.w	r1, #0
 80014b8:	b500      	push	{lr}
 80014ba:	f7fe fe3f 	bl	800013c <fault_handler_helper>
 80014be:	f85d eb04 	ldr.w	lr, [sp], #4
 80014c2:	4770      	bx	lr

080014c4 <MemManage_Handler>:
 80014c4:	f3ef 8008 	mrs	r0, MSP
 80014c8:	6980      	ldr	r0, [r0, #24]
 80014ca:	f04f 0101 	mov.w	r1, #1
 80014ce:	b500      	push	{lr}
 80014d0:	f7fe fe34 	bl	800013c <fault_handler_helper>
 80014d4:	f85d eb04 	ldr.w	lr, [sp], #4
 80014d8:	4770      	bx	lr

080014da <UsageFault_Handler>:
 80014da:	f3ef 8008 	mrs	r0, MSP
 80014de:	6980      	ldr	r0, [r0, #24]
 80014e0:	f04f 0102 	mov.w	r1, #2
 80014e4:	b500      	push	{lr}
 80014e6:	f7fe fe29 	bl	800013c <fault_handler_helper>
 80014ea:	f85d eb04 	ldr.w	lr, [sp], #4
 80014ee:	4770      	bx	lr

080014f0 <HardFault_Handler>:
 80014f0:	f3ef 8008 	mrs	r0, MSP
 80014f4:	6980      	ldr	r0, [r0, #24]
 80014f6:	4904      	ldr	r1, [pc, #16]	@ (8001508 <HardFault_Handler+0x18>)
 80014f8:	f381 8808 	msr	MSP, r1
 80014fc:	b500      	push	{lr}
 80014fe:	f7fe fe7f 	bl	8000200 <HardFault_Handler_helper>
 8001502:	f85d eb04 	ldr.w	lr, [sp], #4
 8001506:	e7fe      	b.n	8001506 <HardFault_Handler+0x16>
 8001508:	20017000 	.word	0x20017000

0800150c <SVC_Handler>:
 800150c:	e7fe      	b.n	800150c <SVC_Handler>

0800150e <SysTick_Handler>:
 800150e:	e7fe      	b.n	800150e <SysTick_Handler>

08001510 <PendSV_Handler>:
 8001510:	e7fe      	b.n	8001510 <PendSV_Handler>

08001512 <NMI_Handler>:
 8001512:	e7fe      	b.n	8001512 <NMI_Handler>

08001514 <DebugMon_Handler>:
 8001514:	e7fe      	b.n	8001514 <DebugMon_Handler>
