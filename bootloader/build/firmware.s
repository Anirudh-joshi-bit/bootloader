
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
 8000154:	f000 fb82 	bl	800085c <printf>
    if (SCB->CFSR & SCB_CFSR_BFARVALID_Msk)
 8000158:	4b1f      	ldr	r3, [pc, #124]	@ (80001d8 <fault_handler_helper+0x9c>)
 800015a:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 800015c:	f403 4300 	and.w	r3, r3, #32768	@ 0x8000
 8000160:	2b00      	cmp	r3, #0
 8000162:	d01f      	beq.n	80001a4 <fault_handler_helper+0x68>
      printf("busfault address -> %\n\r", (uint32_t)(&SCB->BFAR));
 8000164:	491d      	ldr	r1, [pc, #116]	@ (80001dc <fault_handler_helper+0xa0>)
 8000166:	481e      	ldr	r0, [pc, #120]	@ (80001e0 <fault_handler_helper+0xa4>)
 8000168:	f000 fb78 	bl	800085c <printf>
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
 8000178:	f000 fb70 	bl	800085c <printf>
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
 8000190:	f000 fb64 	bl	800085c <printf>
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
 80001a0:	f000 fb5c 	bl	800085c <printf>
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
 80001ae:	f000 fb55 	bl	800085c <printf>
         (uint32_t)(&SCB->CFSR));
  printf("PC -> %\n\r", (uint32_t)&pc);
 80001b2:	f107 030c 	add.w	r3, r7, #12
 80001b6:	4619      	mov	r1, r3
 80001b8:	480f      	ldr	r0, [pc, #60]	@ (80001f8 <fault_handler_helper+0xbc>)
 80001ba:	f000 fb4f 	bl	800085c <printf>
  printf("instruction that caused the fault-> %\n\r", (uint32_t)(&instruction));
 80001be:	f107 0314 	add.w	r3, r7, #20
 80001c2:	4619      	mov	r1, r3
 80001c4:	480d      	ldr	r0, [pc, #52]	@ (80001fc <fault_handler_helper+0xc0>)
 80001c6:	f000 fb49 	bl	800085c <printf>


  /* cannot recover */
  while (1);
 80001ca:	e7fe      	b.n	80001ca <fault_handler_helper+0x8e>
    return;
 80001cc:	bf00      	nop


}
 80001ce:	3718      	adds	r7, #24
 80001d0:	46bd      	mov	sp, r7
 80001d2:	bd80      	pop	{r7, pc}
 80001d4:	08001530 	.word	0x08001530
 80001d8:	e000ed00 	.word	0xe000ed00
 80001dc:	e000ed38 	.word	0xe000ed38
 80001e0:	08001540 	.word	0x08001540
 80001e4:	08001558 	.word	0x08001558
 80001e8:	08001578 	.word	0x08001578
 80001ec:	080015a0 	.word	0x080015a0
 80001f0:	e000ed28 	.word	0xe000ed28
 80001f4:	080015b0 	.word	0x080015b0
 80001f8:	080015e0 	.word	0x080015e0
 80001fc:	080015ec 	.word	0x080015ec

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
 8000212:	f000 fb23 	bl	800085c <printf>
  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
 8000216:	490b      	ldr	r1, [pc, #44]	@ (8000244 <HardFault_Handler_helper+0x44>)
 8000218:	480b      	ldr	r0, [pc, #44]	@ (8000248 <HardFault_Handler_helper+0x48>)
 800021a:	f000 fb1f 	bl	800085c <printf>
         (uint32_t)(&SCB->CFSR));
  printf("Hard Fault Status Register -> %\n\r", (uint32_t)(&SCB->HFSR));
 800021e:	490b      	ldr	r1, [pc, #44]	@ (800024c <HardFault_Handler_helper+0x4c>)
 8000220:	480b      	ldr	r0, [pc, #44]	@ (8000250 <HardFault_Handler_helper+0x50>)
 8000222:	f000 fb1b 	bl	800085c <printf>
  printf("PC -> %\n\r", (uint32_t)(&pc));
 8000226:	1d3b      	adds	r3, r7, #4
 8000228:	4619      	mov	r1, r3
 800022a:	480a      	ldr	r0, [pc, #40]	@ (8000254 <HardFault_Handler_helper+0x54>)
 800022c:	f000 fb16 	bl	800085c <printf>
  printf("instruction that triggered HardFault -> %\n\r",
 8000230:	f107 030c 	add.w	r3, r7, #12
 8000234:	4619      	mov	r1, r3
 8000236:	4808      	ldr	r0, [pc, #32]	@ (8000258 <HardFault_Handler_helper+0x58>)
 8000238:	f000 fb10 	bl	800085c <printf>
         (uint32_t)&instruction);

  /* cannot recover */
  while (1);
 800023c:	e7fe      	b.n	800023c <HardFault_Handler_helper+0x3c>
 800023e:	bf00      	nop
 8000240:	08001614 	.word	0x08001614
 8000244:	e000ed28 	.word	0xe000ed28
 8000248:	080015b0 	.word	0x080015b0
 800024c:	e000ed2c 	.word	0xe000ed2c
 8000250:	08001628 	.word	0x08001628
 8000254:	080015e0 	.word	0x080015e0
 8000258:	0800164c 	.word	0x0800164c

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
 80002bc:	f000 face 	bl	800085c <printf>

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
 800030c:	f000 faa6 	bl	800085c <printf>
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
 8000364:	08001678 	.word	0x08001678
 8000368:	e000e100 	.word	0xe000e100
 800036c:	20000008 	.word	0x20000008
 8000370:	e000ed00 	.word	0xe000ed00
 8000374:	08001690 	.word	0x08001690
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

08000508 <validate_vtable>:
#include "core.h"
#include <stdint.h>

bool validate_vtable(firmware_t *f) {
 8000508:	b580      	push	{r7, lr}
 800050a:	b08a      	sub	sp, #40	@ 0x28
 800050c:	af00      	add	r7, sp, #0
 800050e:	6078      	str	r0, [r7, #4]

  // vtable end is the next free address
  // check from address ------->    [vtable_start, vtable_end)
  
  // vtable must be 128byte aligned => last 7 bits must be 0 (for stm32f401re)
  if (f->__vtable_address & ((1 << 7) - 1)) {
 8000510:	687b      	ldr	r3, [r7, #4]
 8000512:	695b      	ldr	r3, [r3, #20]
 8000514:	f003 037f 	and.w	r3, r3, #127	@ 0x7f
 8000518:	2b00      	cmp	r3, #0
 800051a:	d005      	beq.n	8000528 <validate_vtable+0x20>
    printf("the vector table is not 128byte aligned !!!\n\r", 0x0);
 800051c:	2100      	movs	r1, #0
 800051e:	4839      	ldr	r0, [pc, #228]	@ (8000604 <validate_vtable+0xfc>)
 8000520:	f000 f99c 	bl	800085c <printf>
    return false;
 8000524:	2300      	movs	r3, #0
 8000526:	e068      	b.n	80005fa <validate_vtable+0xf2>

  // all the "end" addresses are next free address => there should not be any
  // data in the "end" address !! all the addresses must lie in the range
  // [start, end)

  uint32_t RAM_start = 0x20000000;
 8000528:	f04f 5300 	mov.w	r3, #536870912	@ 0x20000000
 800052c:	623b      	str	r3, [r7, #32]
  uint32_t RAM_size = 96 * 1024; // 96kB
 800052e:	f44f 33c0 	mov.w	r3, #98304	@ 0x18000
 8000532:	61fb      	str	r3, [r7, #28]
  uint32_t RAM_end = RAM_start + RAM_size;
 8000534:	6a3a      	ldr	r2, [r7, #32]
 8000536:	69fb      	ldr	r3, [r7, #28]
 8000538:	4413      	add	r3, r2
 800053a:	61bb      	str	r3, [r7, #24]
  uint32_t FLASH_start = f->__vtable_address;
 800053c:	687b      	ldr	r3, [r7, #4]
 800053e:	695b      	ldr	r3, [r3, #20]
 8000540:	617b      	str	r3, [r7, #20]
  uint32_t FLASH_size;
  if (f->__base_address == FIRMWARE_1_ADDRESS)
 8000542:	687b      	ldr	r3, [r7, #4]
 8000544:	681b      	ldr	r3, [r3, #0]
 8000546:	4a30      	ldr	r2, [pc, #192]	@ (8000608 <validate_vtable+0x100>)
 8000548:	4293      	cmp	r3, r2
 800054a:	d103      	bne.n	8000554 <validate_vtable+0x4c>
    FLASH_size = f->__firmware_size;
 800054c:	687b      	ldr	r3, [r7, #4]
 800054e:	69db      	ldr	r3, [r3, #28]
 8000550:	613b      	str	r3, [r7, #16]
 8000552:	e00e      	b.n	8000572 <validate_vtable+0x6a>
  else if (f->__base_address == FIRMWARE_2_ADDRESS)
 8000554:	687b      	ldr	r3, [r7, #4]
 8000556:	681b      	ldr	r3, [r3, #0]
 8000558:	4a2c      	ldr	r2, [pc, #176]	@ (800060c <validate_vtable+0x104>)
 800055a:	4293      	cmp	r3, r2
 800055c:	d103      	bne.n	8000566 <validate_vtable+0x5e>
    FLASH_size = f->__firmware_size;
 800055e:	687b      	ldr	r3, [r7, #4]
 8000560:	69db      	ldr	r3, [r3, #28]
 8000562:	613b      	str	r3, [r7, #16]
 8000564:	e005      	b.n	8000572 <validate_vtable+0x6a>
  else {
    printf("update _base address is not valid\n\r", 0x0);
 8000566:	2100      	movs	r1, #0
 8000568:	4829      	ldr	r0, [pc, #164]	@ (8000610 <validate_vtable+0x108>)
 800056a:	f000 f977 	bl	800085c <printf>
    return false;
 800056e:	2300      	movs	r3, #0
 8000570:	e043      	b.n	80005fa <validate_vtable+0xf2>
  }
  uint32_t FLASH_end = f->__firmware_end;
 8000572:	687b      	ldr	r3, [r7, #4]
 8000574:	699b      	ldr	r3, [r3, #24]
 8000576:	60fb      	str	r3, [r7, #12]

  /*************************msp check*********************/
  
  // MSP value can be RAM end as MSP grows downword;
  if (f->__msp_value > RAM_end || f->__msp_value < RAM_start) {
 8000578:	687b      	ldr	r3, [r7, #4]
 800057a:	6a1b      	ldr	r3, [r3, #32]
 800057c:	69ba      	ldr	r2, [r7, #24]
 800057e:	429a      	cmp	r2, r3
 8000580:	d304      	bcc.n	800058c <validate_vtable+0x84>
 8000582:	687b      	ldr	r3, [r7, #4]
 8000584:	6a1b      	ldr	r3, [r3, #32]
 8000586:	6a3a      	ldr	r2, [r7, #32]
 8000588:	429a      	cmp	r2, r3
 800058a:	d90b      	bls.n	80005a4 <validate_vtable+0x9c>

      printf ("MSP value is -> %\n\r", (uint32_t)(&(f->__msp_value)));
 800058c:	687b      	ldr	r3, [r7, #4]
 800058e:	3320      	adds	r3, #32
 8000590:	4619      	mov	r1, r3
 8000592:	4820      	ldr	r0, [pc, #128]	@ (8000614 <validate_vtable+0x10c>)
 8000594:	f000 f962 	bl	800085c <printf>
    printf("MSP value is invalid\n\r", 0x0);
 8000598:	2100      	movs	r1, #0
 800059a:	481f      	ldr	r0, [pc, #124]	@ (8000618 <validate_vtable+0x110>)
 800059c:	f000 f95e 	bl	800085c <printf>
    return false;
 80005a0:	2300      	movs	r3, #0
 80005a2:	e02a      	b.n	80005fa <validate_vtable+0xf2>
  }
  // msp value must be word aligned !!!
  if (f->__msp_value & 3) {
 80005a4:	687b      	ldr	r3, [r7, #4]
 80005a6:	6a1b      	ldr	r3, [r3, #32]
 80005a8:	f003 0303 	and.w	r3, r3, #3
 80005ac:	2b00      	cmp	r3, #0
 80005ae:	d005      	beq.n	80005bc <validate_vtable+0xb4>
    printf("MSP value is not word aligned\n\r", 0x0);
 80005b0:	2100      	movs	r1, #0
 80005b2:	481a      	ldr	r0, [pc, #104]	@ (800061c <validate_vtable+0x114>)
 80005b4:	f000 f952 	bl	800085c <printf>
    return false;
 80005b8:	2300      	movs	r3, #0
 80005ba:	e01e      	b.n	80005fa <validate_vtable+0xf2>
  }

  /************************ vtable check************************/

  for (uint32_t vtable_entry = f->__vtable_address + 0x4;
 80005bc:	687b      	ldr	r3, [r7, #4]
 80005be:	695b      	ldr	r3, [r3, #20]
 80005c0:	3304      	adds	r3, #4
 80005c2:	627b      	str	r3, [r7, #36]	@ 0x24
 80005c4:	e013      	b.n	80005ee <validate_vtable+0xe6>
       vtable_entry < f->__vtable_end; vtable_entry += 4) {

    uint32_t FLASH_address =
        *((uint32_t *)vtable_entry); // peek inside vtable_entry
 80005c6:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
    uint32_t FLASH_address =
 80005c8:	681b      	ldr	r3, [r3, #0]
 80005ca:	60bb      	str	r3, [r7, #8]
    if (FLASH_address >= FLASH_end || FLASH_address < FLASH_start) {
 80005cc:	68ba      	ldr	r2, [r7, #8]
 80005ce:	68fb      	ldr	r3, [r7, #12]
 80005d0:	429a      	cmp	r2, r3
 80005d2:	d203      	bcs.n	80005dc <validate_vtable+0xd4>
 80005d4:	68ba      	ldr	r2, [r7, #8]
 80005d6:	697b      	ldr	r3, [r7, #20]
 80005d8:	429a      	cmp	r2, r3
 80005da:	d205      	bcs.n	80005e8 <validate_vtable+0xe0>

      printf("% ---- in vtable entry does not exist in the allowed flash "
 80005dc:	6a79      	ldr	r1, [r7, #36]	@ 0x24
 80005de:	4810      	ldr	r0, [pc, #64]	@ (8000620 <validate_vtable+0x118>)
 80005e0:	f000 f93c 	bl	800085c <printf>
             "range\n\r", vtable_entry);
      return false;
 80005e4:	2300      	movs	r3, #0
 80005e6:	e008      	b.n	80005fa <validate_vtable+0xf2>
       vtable_entry < f->__vtable_end; vtable_entry += 4) {
 80005e8:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80005ea:	3304      	adds	r3, #4
 80005ec:	627b      	str	r3, [r7, #36]	@ 0x24
 80005ee:	687b      	ldr	r3, [r7, #4]
 80005f0:	68db      	ldr	r3, [r3, #12]
 80005f2:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
 80005f4:	429a      	cmp	r2, r3
 80005f6:	d3e6      	bcc.n	80005c6 <validate_vtable+0xbe>
    }
  }

  return true;
 80005f8:	2301      	movs	r3, #1
}
 80005fa:	4618      	mov	r0, r3
 80005fc:	3728      	adds	r7, #40	@ 0x28
 80005fe:	46bd      	mov	sp, r7
 8000600:	bd80      	pop	{r7, pc}
 8000602:	bf00      	nop
 8000604:	080016a8 	.word	0x080016a8
 8000608:	08010000 	.word	0x08010000
 800060c:	08020000 	.word	0x08020000
 8000610:	080016d8 	.word	0x080016d8
 8000614:	080016fc 	.word	0x080016fc
 8000618:	08001710 	.word	0x08001710
 800061c:	08001728 	.word	0x08001728
 8000620:	08001748 	.word	0x08001748

08000624 <validate_firmware>:

bool validate_firmware(firmware_t *f) {
 8000624:	b580      	push	{r7, lr}
 8000626:	b084      	sub	sp, #16
 8000628:	af00      	add	r7, sp, #0
 800062a:	6078      	str	r0, [r7, #4]

  if (!validate_vtable(f)) {
 800062c:	6878      	ldr	r0, [r7, #4]
 800062e:	f7ff ff6b 	bl	8000508 <validate_vtable>
 8000632:	4603      	mov	r3, r0
 8000634:	f083 0301 	eor.w	r3, r3, #1
 8000638:	b2db      	uxtb	r3, r3
 800063a:	2b00      	cmp	r3, #0
 800063c:	d005      	beq.n	800064a <validate_firmware+0x26>
    printf("vector table of the update is not valid\n\r", 0x0);
 800063e:	2100      	movs	r1, #0
 8000640:	480f      	ldr	r0, [pc, #60]	@ (8000680 <validate_firmware+0x5c>)
 8000642:	f000 f90b 	bl	800085c <printf>
    return false;
 8000646:	2300      	movs	r3, #0
 8000648:	e016      	b.n	8000678 <validate_firmware+0x54>
  }

  uint32_t crc_result = crc_calc(f);
 800064a:	6878      	ldr	r0, [r7, #4]
 800064c:	f7ff fd4a 	bl	80000e4 <crc_calc>
 8000650:	4603      	mov	r3, r0
 8000652:	60fb      	str	r3, [r7, #12]
  printf("crc value is -> %\n\r", (uint32_t)(&crc_result));
 8000654:	f107 030c 	add.w	r3, r7, #12
 8000658:	4619      	mov	r1, r3
 800065a:	480a      	ldr	r0, [pc, #40]	@ (8000684 <validate_firmware+0x60>)
 800065c:	f000 f8fe 	bl	800085c <printf>
  if (crc_result != f->__crc) {
 8000660:	687b      	ldr	r3, [r7, #4]
 8000662:	689a      	ldr	r2, [r3, #8]
 8000664:	68fb      	ldr	r3, [r7, #12]
 8000666:	429a      	cmp	r2, r3
 8000668:	d005      	beq.n	8000676 <validate_firmware+0x52>
    printf("CRC failed\n\r", 0x0);
 800066a:	2100      	movs	r1, #0
 800066c:	4806      	ldr	r0, [pc, #24]	@ (8000688 <validate_firmware+0x64>)
 800066e:	f000 f8f5 	bl	800085c <printf>
    return false;
 8000672:	2300      	movs	r3, #0
 8000674:	e000      	b.n	8000678 <validate_firmware+0x54>
  }
  return true;
 8000676:	2301      	movs	r3, #1
}
 8000678:	4618      	mov	r0, r3
 800067a:	3710      	adds	r7, #16
 800067c:	46bd      	mov	sp, r7
 800067e:	bd80      	pop	{r7, pc}
 8000680:	0800178c 	.word	0x0800178c
 8000684:	080017b8 	.word	0x080017b8
 8000688:	080017cc 	.word	0x080017cc

0800068c <switch_pressed>:
extern volatile Ring_buff_t ringbuffer;




void switch_pressed(void){  
 800068c:	b480      	push	{r7}
 800068e:	af00      	add	r7, sp, #0
    // clear the pending status (not done by hardware)
    EXTI-> PR = EXTI_PR_PR13_Msk;
 8000690:	4b0b      	ldr	r3, [pc, #44]	@ (80006c0 <switch_pressed+0x34>)
 8000692:	f44f 5200 	mov.w	r2, #8192	@ 0x2000
 8000696:	615a      	str	r2, [r3, #20]

    press_count++;
 8000698:	4b0a      	ldr	r3, [pc, #40]	@ (80006c4 <switch_pressed+0x38>)
 800069a:	681b      	ldr	r3, [r3, #0]
 800069c:	3301      	adds	r3, #1
 800069e:	4a09      	ldr	r2, [pc, #36]	@ (80006c4 <switch_pressed+0x38>)
 80006a0:	6013      	str	r3, [r2, #0]
    if (press_count == 3){
 80006a2:	4b08      	ldr	r3, [pc, #32]	@ (80006c4 <switch_pressed+0x38>)
 80006a4:	681b      	ldr	r3, [r3, #0]
 80006a6:	2b03      	cmp	r3, #3
 80006a8:	d105      	bne.n	80006b6 <switch_pressed+0x2a>
        delay_count = 100;
 80006aa:	4b07      	ldr	r3, [pc, #28]	@ (80006c8 <switch_pressed+0x3c>)
 80006ac:	2264      	movs	r2, #100	@ 0x64
 80006ae:	601a      	str	r2, [r3, #0]
        recieve_size = true;
 80006b0:	4b06      	ldr	r3, [pc, #24]	@ (80006cc <switch_pressed+0x40>)
 80006b2:	2201      	movs	r2, #1
 80006b4:	701a      	strb	r2, [r3, #0]
        //EXTI-> IMR &= ~EXTI_IMR_MR13_Msk;
    }
}
 80006b6:	bf00      	nop
 80006b8:	46bd      	mov	sp, r7
 80006ba:	bc80      	pop	{r7}
 80006bc:	4770      	bx	lr
 80006be:	bf00      	nop
 80006c0:	40013c00 	.word	0x40013c00
 80006c4:	20000060 	.word	0x20000060
 80006c8:	20000064 	.word	0x20000064
 80006cc:	20005080 	.word	0x20005080

080006d0 <USART1_IRQHandler>:
void USART1_IRQHandler (void){
 80006d0:	b580      	push	{r7, lr}
 80006d2:	b082      	sub	sp, #8
 80006d4:	af00      	add	r7, sp, #0
  if (!firmware_update_mode) return;
 80006d6:	4b26      	ldr	r3, [pc, #152]	@ (8000770 <USART1_IRQHandler+0xa0>)
 80006d8:	781b      	ldrb	r3, [r3, #0]
 80006da:	f083 0301 	eor.w	r3, r3, #1
 80006de:	b2db      	uxtb	r3, r3
 80006e0:	2b00      	cmp	r3, #0
 80006e2:	d141      	bne.n	8000768 <USART1_IRQHandler+0x98>
  if (USART1 -> SR & USART_SR_RXNE_Msk){
 80006e4:	4b23      	ldr	r3, [pc, #140]	@ (8000774 <USART1_IRQHandler+0xa4>)
 80006e6:	681b      	ldr	r3, [r3, #0]
 80006e8:	f003 0320 	and.w	r3, r3, #32
 80006ec:	2b00      	cmp	r3, #0
 80006ee:	d03c      	beq.n	800076a <USART1_IRQHandler+0x9a>
    if (recieve_size){
 80006f0:	4b21      	ldr	r3, [pc, #132]	@ (8000778 <USART1_IRQHandler+0xa8>)
 80006f2:	781b      	ldrb	r3, [r3, #0]
 80006f4:	b2db      	uxtb	r3, r3
 80006f6:	2b00      	cmp	r3, #0
 80006f8:	d02b      	beq.n	8000752 <USART1_IRQHandler+0x82>
      char digit = '\0';
 80006fa:	2300      	movs	r3, #0
 80006fc:	71fb      	strb	r3, [r7, #7]
      digit = USART1-> DR;
 80006fe:	4b1d      	ldr	r3, [pc, #116]	@ (8000774 <USART1_IRQHandler+0xa4>)
 8000700:	685b      	ldr	r3, [r3, #4]
 8000702:	71fb      	strb	r3, [r7, #7]
      if (digit == '\n'){
 8000704:	79fb      	ldrb	r3, [r7, #7]
 8000706:	2b0a      	cmp	r3, #10
 8000708:	d103      	bne.n	8000712 <USART1_IRQHandler+0x42>
        flag_size_recieved = true;
 800070a:	4b1c      	ldr	r3, [pc, #112]	@ (800077c <USART1_IRQHandler+0xac>)
 800070c:	2201      	movs	r2, #1
 800070e:	701a      	strb	r2, [r3, #0]
        return;
 8000710:	e02b      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      if (digit < '0' || digit > '9'){
 8000712:	79fb      	ldrb	r3, [r7, #7]
 8000714:	2b2f      	cmp	r3, #47	@ 0x2f
 8000716:	d902      	bls.n	800071e <USART1_IRQHandler+0x4e>
 8000718:	79fb      	ldrb	r3, [r7, #7]
 800071a:	2b39      	cmp	r3, #57	@ 0x39
 800071c:	d903      	bls.n	8000726 <USART1_IRQHandler+0x56>
        flag_wrong_size = true;
 800071e:	4b18      	ldr	r3, [pc, #96]	@ (8000780 <USART1_IRQHandler+0xb0>)
 8000720:	2201      	movs	r2, #1
 8000722:	701a      	strb	r2, [r3, #0]
        return;
 8000724:	e021      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      if (update_size > 128*1024){
 8000726:	4b17      	ldr	r3, [pc, #92]	@ (8000784 <USART1_IRQHandler+0xb4>)
 8000728:	681b      	ldr	r3, [r3, #0]
 800072a:	f5b3 3f00 	cmp.w	r3, #131072	@ 0x20000
 800072e:	d903      	bls.n	8000738 <USART1_IRQHandler+0x68>
        flag_too_big_update = true;
 8000730:	4b15      	ldr	r3, [pc, #84]	@ (8000788 <USART1_IRQHandler+0xb8>)
 8000732:	2201      	movs	r2, #1
 8000734:	701a      	strb	r2, [r3, #0]
        return;
 8000736:	e018      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      update_size = update_size * 10 + (digit-'0');
 8000738:	4b12      	ldr	r3, [pc, #72]	@ (8000784 <USART1_IRQHandler+0xb4>)
 800073a:	681a      	ldr	r2, [r3, #0]
 800073c:	4613      	mov	r3, r2
 800073e:	009b      	lsls	r3, r3, #2
 8000740:	4413      	add	r3, r2
 8000742:	005b      	lsls	r3, r3, #1
 8000744:	461a      	mov	r2, r3
 8000746:	79fb      	ldrb	r3, [r7, #7]
 8000748:	4413      	add	r3, r2
 800074a:	3b30      	subs	r3, #48	@ 0x30
 800074c:	4a0d      	ldr	r2, [pc, #52]	@ (8000784 <USART1_IRQHandler+0xb4>)
 800074e:	6013      	str	r3, [r2, #0]
 8000750:	e00b      	b.n	800076a <USART1_IRQHandler+0x9a>
    }
    else {
      // if (fw_ar_ind >= update_size)
      //   return;
      // fw_update [fw_ar_ind++] = USART1 -> DR;
      uint8_t data = USART1 -> DR;
 8000752:	4b08      	ldr	r3, [pc, #32]	@ (8000774 <USART1_IRQHandler+0xa4>)
 8000754:	685b      	ldr	r3, [r3, #4]
 8000756:	b2db      	uxtb	r3, r3
 8000758:	71bb      	strb	r3, [r7, #6]
      Ring_buff_write(&ringbuffer, &data, 1);
 800075a:	1dbb      	adds	r3, r7, #6
 800075c:	2201      	movs	r2, #1
 800075e:	4619      	mov	r1, r3
 8000760:	480a      	ldr	r0, [pc, #40]	@ (800078c <USART1_IRQHandler+0xbc>)
 8000762:	f7ff fe5f 	bl	8000424 <Ring_buff_write>
 8000766:	e000      	b.n	800076a <USART1_IRQHandler+0x9a>
  if (!firmware_update_mode) return;
 8000768:	bf00      	nop
    }
  }
}
 800076a:	3708      	adds	r7, #8
 800076c:	46bd      	mov	sp, r7
 800076e:	bd80      	pop	{r7, pc}
 8000770:	2000507e 	.word	0x2000507e
 8000774:	40011000 	.word	0x40011000
 8000778:	20005080 	.word	0x20005080
 800077c:	20005081 	.word	0x20005081
 8000780:	20005082 	.word	0x20005082
 8000784:	20000074 	.word	0x20000074
 8000788:	20005083 	.word	0x20005083
 800078c:	20000078 	.word	0x20000078

08000790 <strlen>:
uint32_t update_section_end_address = UPDATE_ADDR;
extern volatile Ring_buff_t ringbuffer;
extern uint8_t write_buffer[WRITE_BUFF_SIZE];
volatile uint32_t fw_ar_ind = 0;

uint32_t strlen(const char *msg) {
 8000790:	b480      	push	{r7}
 8000792:	b085      	sub	sp, #20
 8000794:	af00      	add	r7, sp, #0
 8000796:	6078      	str	r0, [r7, #4]

  int i = 0;
 8000798:	2300      	movs	r3, #0
 800079a:	60fb      	str	r3, [r7, #12]
  while (msg[i++] != '\0')
 800079c:	bf00      	nop
 800079e:	68fb      	ldr	r3, [r7, #12]
 80007a0:	1c5a      	adds	r2, r3, #1
 80007a2:	60fa      	str	r2, [r7, #12]
 80007a4:	461a      	mov	r2, r3
 80007a6:	687b      	ldr	r3, [r7, #4]
 80007a8:	4413      	add	r3, r2
 80007aa:	781b      	ldrb	r3, [r3, #0]
 80007ac:	2b00      	cmp	r3, #0
 80007ae:	d1f6      	bne.n	800079e <strlen+0xe>
    ;
  return i - 1;
 80007b0:	68fb      	ldr	r3, [r7, #12]
 80007b2:	3b01      	subs	r3, #1
}
 80007b4:	4618      	mov	r0, r3
 80007b6:	3714      	adds	r7, #20
 80007b8:	46bd      	mov	sp, r7
 80007ba:	bc80      	pop	{r7}
 80007bc:	4770      	bx	lr

080007be <delay>:

void delay(uint32_t count) {
 80007be:	b480      	push	{r7}
 80007c0:	b083      	sub	sp, #12
 80007c2:	af00      	add	r7, sp, #0
 80007c4:	6078      	str	r0, [r7, #4]

  while (count--)
 80007c6:	bf00      	nop
 80007c8:	687b      	ldr	r3, [r7, #4]
 80007ca:	1e5a      	subs	r2, r3, #1
 80007cc:	607a      	str	r2, [r7, #4]
 80007ce:	2b00      	cmp	r3, #0
 80007d0:	d1fa      	bne.n	80007c8 <delay+0xa>
    ;
}
 80007d2:	bf00      	nop
 80007d4:	bf00      	nop
 80007d6:	370c      	adds	r7, #12
 80007d8:	46bd      	mov	sp, r7
 80007da:	bc80      	pop	{r7}
 80007dc:	4770      	bx	lr

080007de <hex_str>:
char *hex_str(uint32_t value, char *out) {
 80007de:	b4b0      	push	{r4, r5, r7}
 80007e0:	b08b      	sub	sp, #44	@ 0x2c
 80007e2:	af00      	add	r7, sp, #0
 80007e4:	6078      	str	r0, [r7, #4]
 80007e6:	6039      	str	r1, [r7, #0]

  char hex_char[] = "0123456789abcdef";
 80007e8:	4b1b      	ldr	r3, [pc, #108]	@ (8000858 <hex_str+0x7a>)
 80007ea:	f107 0408 	add.w	r4, r7, #8
 80007ee:	461d      	mov	r5, r3
 80007f0:	cd0f      	ldmia	r5!, {r0, r1, r2, r3}
 80007f2:	c40f      	stmia	r4!, {r0, r1, r2, r3}
 80007f4:	682b      	ldr	r3, [r5, #0]
 80007f6:	7023      	strb	r3, [r4, #0]
  out[0] = '0';
 80007f8:	683b      	ldr	r3, [r7, #0]
 80007fa:	2230      	movs	r2, #48	@ 0x30
 80007fc:	701a      	strb	r2, [r3, #0]
  out[1] = 'x';
 80007fe:	683b      	ldr	r3, [r7, #0]
 8000800:	3301      	adds	r3, #1
 8000802:	2278      	movs	r2, #120	@ 0x78
 8000804:	701a      	strb	r2, [r3, #0]

  for (int i = 0; i < 8; i++) {
 8000806:	2300      	movs	r3, #0
 8000808:	627b      	str	r3, [r7, #36]	@ 0x24
 800080a:	e01c      	b.n	8000846 <hex_str+0x68>
    uint32_t ind = (value & (15 << (i * 4))) >> (i * 4);
 800080c:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800080e:	009b      	lsls	r3, r3, #2
 8000810:	220f      	movs	r2, #15
 8000812:	fa02 f303 	lsl.w	r3, r2, r3
 8000816:	461a      	mov	r2, r3
 8000818:	687b      	ldr	r3, [r7, #4]
 800081a:	401a      	ands	r2, r3
 800081c:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800081e:	009b      	lsls	r3, r3, #2
 8000820:	fa22 f303 	lsr.w	r3, r2, r3
 8000824:	623b      	str	r3, [r7, #32]
    int j = 9 - i;
 8000826:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000828:	f1c3 0309 	rsb	r3, r3, #9
 800082c:	61fb      	str	r3, [r7, #28]
    out[j] = hex_char[ind];
 800082e:	69fb      	ldr	r3, [r7, #28]
 8000830:	683a      	ldr	r2, [r7, #0]
 8000832:	4413      	add	r3, r2
 8000834:	f107 0108 	add.w	r1, r7, #8
 8000838:	6a3a      	ldr	r2, [r7, #32]
 800083a:	440a      	add	r2, r1
 800083c:	7812      	ldrb	r2, [r2, #0]
 800083e:	701a      	strb	r2, [r3, #0]
  for (int i = 0; i < 8; i++) {
 8000840:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000842:	3301      	adds	r3, #1
 8000844:	627b      	str	r3, [r7, #36]	@ 0x24
 8000846:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000848:	2b07      	cmp	r3, #7
 800084a:	dddf      	ble.n	800080c <hex_str+0x2e>
  }
}
 800084c:	bf00      	nop
 800084e:	4618      	mov	r0, r3
 8000850:	372c      	adds	r7, #44	@ 0x2c
 8000852:	46bd      	mov	sp, r7
 8000854:	bcb0      	pop	{r4, r5, r7}
 8000856:	4770      	bx	lr
 8000858:	080017dc 	.word	0x080017dc

0800085c <printf>:

void printf(const char *msg, uint32_t address) {
 800085c:	b580      	push	{r7, lr}
 800085e:	b0a4      	sub	sp, #144	@ 0x90
 8000860:	af00      	add	r7, sp, #0
 8000862:	6078      	str	r0, [r7, #4]
 8000864:	6039      	str	r1, [r7, #0]

  uint32_t value = *((uint32_t *)address);
 8000866:	683b      	ldr	r3, [r7, #0]
 8000868:	681b      	ldr	r3, [r3, #0]
 800086a:	67fb      	str	r3, [r7, #124]	@ 0x7c

  if (strlen(msg) + 9 > MAX_STR_SIZE) {
 800086c:	6878      	ldr	r0, [r7, #4]
 800086e:	f7ff ff8f 	bl	8000790 <strlen>
 8000872:	4603      	mov	r3, r0
 8000874:	3309      	adds	r3, #9
 8000876:	2b64      	cmp	r3, #100	@ 0x64
 8000878:	d904      	bls.n	8000884 <printf+0x28>
    __usart1_print("too large error message !!\n\r", MAX_STR_SIZE);
 800087a:	2164      	movs	r1, #100	@ 0x64
 800087c:	483e      	ldr	r0, [pc, #248]	@ (8000978 <printf+0x11c>)
 800087e:	f000 fdc9 	bl	8001414 <__usart1_print>
 8000882:	e076      	b.n	8000972 <printf+0x116>
    return;
  }
  char hex[10];
  char __msg[MAX_STR_SIZE];

  uint32_t i = 0;
 8000884:	2300      	movs	r3, #0
 8000886:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
  int p = 0, q = 0;
 800088a:	2300      	movs	r3, #0
 800088c:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
 8000890:	2300      	movs	r3, #0
 8000892:	f8c7 3084 	str.w	r3, [r7, #132]	@ 0x84
  bool single_sub = false;
 8000896:	2300      	movs	r3, #0
 8000898:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83

  uint32_t msg_size = strlen(msg);
 800089c:	6878      	ldr	r0, [r7, #4]
 800089e:	f7ff ff77 	bl	8000790 <strlen>
 80008a2:	67b8      	str	r0, [r7, #120]	@ 0x78
  for (; i < msg_size; i++) {
 80008a4:	e04d      	b.n	8000942 <printf+0xe6>

    if (msg[i] == '%' && !single_sub) {
 80008a6:	687a      	ldr	r2, [r7, #4]
 80008a8:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 80008ac:	4413      	add	r3, r2
 80008ae:	781b      	ldrb	r3, [r3, #0]
 80008b0:	2b25      	cmp	r3, #37	@ 0x25
 80008b2:	d12f      	bne.n	8000914 <printf+0xb8>
 80008b4:	f897 3083 	ldrb.w	r3, [r7, #131]	@ 0x83
 80008b8:	f083 0301 	eor.w	r3, r3, #1
 80008bc:	b2db      	uxtb	r3, r3
 80008be:	2b00      	cmp	r3, #0
 80008c0:	d028      	beq.n	8000914 <printf+0xb8>
      hex_str(value, hex);
 80008c2:	f107 036c 	add.w	r3, r7, #108	@ 0x6c
 80008c6:	4619      	mov	r1, r3
 80008c8:	6ff8      	ldr	r0, [r7, #124]	@ 0x7c
 80008ca:	f7ff ff88 	bl	80007de <hex_str>

      while (q - p < 10) {
 80008ce:	e011      	b.n	80008f4 <printf+0x98>
        __msg[q++] = hex[q - p];
 80008d0:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 80008d4:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 80008d8:	1ad2      	subs	r2, r2, r3
 80008da:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 80008de:	1c59      	adds	r1, r3, #1
 80008e0:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 80008e4:	3290      	adds	r2, #144	@ 0x90
 80008e6:	443a      	add	r2, r7
 80008e8:	f812 2c24 	ldrb.w	r2, [r2, #-36]
 80008ec:	3390      	adds	r3, #144	@ 0x90
 80008ee:	443b      	add	r3, r7
 80008f0:	f803 2c88 	strb.w	r2, [r3, #-136]
      while (q - p < 10) {
 80008f4:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 80008f8:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 80008fc:	1ad3      	subs	r3, r2, r3
 80008fe:	2b09      	cmp	r3, #9
 8000900:	dde6      	ble.n	80008d0 <printf+0x74>
      }
      p++;
 8000902:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000906:	3301      	adds	r3, #1
 8000908:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
      single_sub = true;
 800090c:	2301      	movs	r3, #1
 800090e:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83
 8000912:	e011      	b.n	8000938 <printf+0xdc>
    } else
      __msg[q++] = msg[p++];
 8000914:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000918:	1c5a      	adds	r2, r3, #1
 800091a:	f8c7 2088 	str.w	r2, [r7, #136]	@ 0x88
 800091e:	461a      	mov	r2, r3
 8000920:	687b      	ldr	r3, [r7, #4]
 8000922:	441a      	add	r2, r3
 8000924:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000928:	1c59      	adds	r1, r3, #1
 800092a:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 800092e:	7812      	ldrb	r2, [r2, #0]
 8000930:	3390      	adds	r3, #144	@ 0x90
 8000932:	443b      	add	r3, r7
 8000934:	f803 2c88 	strb.w	r2, [r3, #-136]
  for (; i < msg_size; i++) {
 8000938:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 800093c:	3301      	adds	r3, #1
 800093e:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
 8000942:	f8d7 208c 	ldr.w	r2, [r7, #140]	@ 0x8c
 8000946:	6fbb      	ldr	r3, [r7, #120]	@ 0x78
 8000948:	429a      	cmp	r2, r3
 800094a:	d3ac      	bcc.n	80008a6 <printf+0x4a>
  }
  __msg[q] = '\0';
 800094c:	f107 0208 	add.w	r2, r7, #8
 8000950:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000954:	4413      	add	r3, r2
 8000956:	2200      	movs	r2, #0
 8000958:	701a      	strb	r2, [r3, #0]
  __usart1_print(__msg, strlen(__msg));
 800095a:	f107 0308 	add.w	r3, r7, #8
 800095e:	4618      	mov	r0, r3
 8000960:	f7ff ff16 	bl	8000790 <strlen>
 8000964:	4602      	mov	r2, r0
 8000966:	f107 0308 	add.w	r3, r7, #8
 800096a:	4611      	mov	r1, r2
 800096c:	4618      	mov	r0, r3
 800096e:	f000 fd51 	bl	8001414 <__usart1_print>
}
 8000972:	3790      	adds	r7, #144	@ 0x90
 8000974:	46bd      	mov	sp, r7
 8000976:	bd80      	pop	{r7, pc}
 8000978:	080017f0 	.word	0x080017f0

0800097c <recieve_update>:
//   }
//   printf("data recieved !!! yehhhh \n\n\r", 0x0);
//   return 0;
// }

uint32_t recieve_update(void) {
 800097c:	b580      	push	{r7, lr}
 800097e:	b082      	sub	sp, #8
 8000980:	af00      	add	r7, sp, #0

  // recieve update size

  printf("enter the size of the update....\n\r", 0x0);
 8000982:	2100      	movs	r1, #0
 8000984:	483e      	ldr	r0, [pc, #248]	@ (8000a80 <recieve_update+0x104>)
 8000986:	f7ff ff69 	bl	800085c <printf>

  recieve_size = true;
 800098a:	4b3e      	ldr	r3, [pc, #248]	@ (8000a84 <recieve_update+0x108>)
 800098c:	2201      	movs	r2, #1
 800098e:	701a      	strb	r2, [r3, #0]
  while (1) {
    if (flag_wrong_size) {
 8000990:	4b3d      	ldr	r3, [pc, #244]	@ (8000a88 <recieve_update+0x10c>)
 8000992:	781b      	ldrb	r3, [r3, #0]
 8000994:	b2db      	uxtb	r3, r3
 8000996:	2b00      	cmp	r3, #0
 8000998:	d006      	beq.n	80009a8 <recieve_update+0x2c>
      printf("wrong size entered !!!\n\r", 0x0);
 800099a:	2100      	movs	r1, #0
 800099c:	483b      	ldr	r0, [pc, #236]	@ (8000a8c <recieve_update+0x110>)
 800099e:	f7ff ff5d 	bl	800085c <printf>
      return -1;
 80009a2:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80009a6:	e066      	b.n	8000a76 <recieve_update+0xfa>
    }
    if (flag_too_big_update) {
 80009a8:	4b39      	ldr	r3, [pc, #228]	@ (8000a90 <recieve_update+0x114>)
 80009aa:	781b      	ldrb	r3, [r3, #0]
 80009ac:	b2db      	uxtb	r3, r3
 80009ae:	2b00      	cmp	r3, #0
 80009b0:	d006      	beq.n	80009c0 <recieve_update+0x44>
      printf("update size cannot exceed 128KB \n\r", 0x0);
 80009b2:	2100      	movs	r1, #0
 80009b4:	4837      	ldr	r0, [pc, #220]	@ (8000a94 <recieve_update+0x118>)
 80009b6:	f7ff ff51 	bl	800085c <printf>
      return -1;
 80009ba:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80009be:	e05a      	b.n	8000a76 <recieve_update+0xfa>
    }
    if (flag_size_recieved) {
 80009c0:	4b35      	ldr	r3, [pc, #212]	@ (8000a98 <recieve_update+0x11c>)
 80009c2:	781b      	ldrb	r3, [r3, #0]
 80009c4:	b2db      	uxtb	r3, r3
 80009c6:	2b00      	cmp	r3, #0
 80009c8:	d0e2      	beq.n	8000990 <recieve_update+0x14>
      printf("update size recieved \n\r", 0x0);
 80009ca:	2100      	movs	r1, #0
 80009cc:	4833      	ldr	r0, [pc, #204]	@ (8000a9c <recieve_update+0x120>)
 80009ce:	f7ff ff45 	bl	800085c <printf>
      break;
 80009d2:	bf00      	nop
    }
  }
  recieve_size = false;
 80009d4:	4b2b      	ldr	r3, [pc, #172]	@ (8000a84 <recieve_update+0x108>)
 80009d6:	2200      	movs	r2, #0
 80009d8:	701a      	strb	r2, [r3, #0]

  // recieve firmware update !!
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 80009da:	e041      	b.n	8000a60 <recieve_update+0xe4>
    while (Ring_buff_empty(&ringbuffer))
 80009dc:	bf00      	nop
 80009de:	4830      	ldr	r0, [pc, #192]	@ (8000aa0 <recieve_update+0x124>)
 80009e0:	f7ff fce1 	bl	80003a6 <Ring_buff_empty>
 80009e4:	4603      	mov	r3, r0
 80009e6:	2b00      	cmp	r3, #0
 80009e8:	d1f9      	bne.n	80009de <recieve_update+0x62>
      ;
    //
    // problem
    uint16_t read_size = Ring_buff_read(&ringbuffer, write_buffer + wb_size,
 80009ea:	4b2e      	ldr	r3, [pc, #184]	@ (8000aa4 <recieve_update+0x128>)
 80009ec:	881b      	ldrh	r3, [r3, #0]
 80009ee:	461a      	mov	r2, r3
 80009f0:	4b2d      	ldr	r3, [pc, #180]	@ (8000aa8 <recieve_update+0x12c>)
 80009f2:	18d1      	adds	r1, r2, r3
 80009f4:	4b2b      	ldr	r3, [pc, #172]	@ (8000aa4 <recieve_update+0x128>)
 80009f6:	881b      	ldrh	r3, [r3, #0]
 80009f8:	f5c3 5320 	rsb	r3, r3, #10240	@ 0x2800
 80009fc:	b29b      	uxth	r3, r3
 80009fe:	461a      	mov	r2, r3
 8000a00:	4827      	ldr	r0, [pc, #156]	@ (8000aa0 <recieve_update+0x124>)
 8000a02:	f7ff fd42 	bl	800048a <Ring_buff_read>
 8000a06:	4603      	mov	r3, r0
 8000a08:	80fb      	strh	r3, [r7, #6]
                                        WRITE_BUFF_SIZE - wb_size);
    wb_size += read_size;
 8000a0a:	4b26      	ldr	r3, [pc, #152]	@ (8000aa4 <recieve_update+0x128>)
 8000a0c:	881a      	ldrh	r2, [r3, #0]
 8000a0e:	88fb      	ldrh	r3, [r7, #6]
 8000a10:	4413      	add	r3, r2
 8000a12:	b29a      	uxth	r2, r3
 8000a14:	4b23      	ldr	r3, [pc, #140]	@ (8000aa4 <recieve_update+0x128>)
 8000a16:	801a      	strh	r2, [r3, #0]

    uint16_t update_in_flash_size = update_section_end_address - UPDATE_ADDR;
 8000a18:	4b24      	ldr	r3, [pc, #144]	@ (8000aac <recieve_update+0x130>)
 8000a1a:	681b      	ldr	r3, [r3, #0]
 8000a1c:	80bb      	strh	r3, [r7, #4]
    //
    if (wb_size == WRITE_BUFF_SIZE ||
 8000a1e:	4b21      	ldr	r3, [pc, #132]	@ (8000aa4 <recieve_update+0x128>)
 8000a20:	881b      	ldrh	r3, [r3, #0]
 8000a22:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 8000a26:	d007      	beq.n	8000a38 <recieve_update+0xbc>
        update_size - update_in_flash_size == wb_size) {
 8000a28:	4b21      	ldr	r3, [pc, #132]	@ (8000ab0 <recieve_update+0x134>)
 8000a2a:	681a      	ldr	r2, [r3, #0]
 8000a2c:	88bb      	ldrh	r3, [r7, #4]
 8000a2e:	1ad3      	subs	r3, r2, r3
 8000a30:	4a1c      	ldr	r2, [pc, #112]	@ (8000aa4 <recieve_update+0x128>)
 8000a32:	8812      	ldrh	r2, [r2, #0]
    if (wb_size == WRITE_BUFF_SIZE ||
 8000a34:	4293      	cmp	r3, r2
 8000a36:	d113      	bne.n	8000a60 <recieve_update+0xe4>
      // flash write, update end address, wb flush

      flash_write(update_section_end_address, write_buffer, wb_size, 0);
 8000a38:	4b1c      	ldr	r3, [pc, #112]	@ (8000aac <recieve_update+0x130>)
 8000a3a:	6818      	ldr	r0, [r3, #0]
 8000a3c:	4b19      	ldr	r3, [pc, #100]	@ (8000aa4 <recieve_update+0x128>)
 8000a3e:	881b      	ldrh	r3, [r3, #0]
 8000a40:	461a      	mov	r2, r3
 8000a42:	2300      	movs	r3, #0
 8000a44:	4918      	ldr	r1, [pc, #96]	@ (8000aa8 <recieve_update+0x12c>)
 8000a46:	f000 fbff 	bl	8001248 <flash_write>

      update_section_end_address += wb_size;
 8000a4a:	4b16      	ldr	r3, [pc, #88]	@ (8000aa4 <recieve_update+0x128>)
 8000a4c:	881b      	ldrh	r3, [r3, #0]
 8000a4e:	461a      	mov	r2, r3
 8000a50:	4b16      	ldr	r3, [pc, #88]	@ (8000aac <recieve_update+0x130>)
 8000a52:	681b      	ldr	r3, [r3, #0]
 8000a54:	4413      	add	r3, r2
 8000a56:	4a15      	ldr	r2, [pc, #84]	@ (8000aac <recieve_update+0x130>)
 8000a58:	6013      	str	r3, [r2, #0]
      wb_size = 0;
 8000a5a:	4b12      	ldr	r3, [pc, #72]	@ (8000aa4 <recieve_update+0x128>)
 8000a5c:	2200      	movs	r2, #0
 8000a5e:	801a      	strh	r2, [r3, #0]
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 8000a60:	4b12      	ldr	r3, [pc, #72]	@ (8000aac <recieve_update+0x130>)
 8000a62:	681b      	ldr	r3, [r3, #0]
 8000a64:	f103 4377 	add.w	r3, r3, #4143972352	@ 0xf7000000
 8000a68:	f503 037c 	add.w	r3, r3, #16515072	@ 0xfc0000
 8000a6c:	4a10      	ldr	r2, [pc, #64]	@ (8000ab0 <recieve_update+0x134>)
 8000a6e:	6812      	ldr	r2, [r2, #0]
 8000a70:	4293      	cmp	r3, r2
 8000a72:	d3b3      	bcc.n	80009dc <recieve_update+0x60>
    }
  }

  // while (fw_ar_ind < update_size);

  return 0;
 8000a74:	2300      	movs	r3, #0
}
 8000a76:	4618      	mov	r0, r3
 8000a78:	3708      	adds	r7, #8
 8000a7a:	46bd      	mov	sp, r7
 8000a7c:	bd80      	pop	{r7, pc}
 8000a7e:	bf00      	nop
 8000a80:	08001810 	.word	0x08001810
 8000a84:	20005080 	.word	0x20005080
 8000a88:	20005082 	.word	0x20005082
 8000a8c:	08001834 	.word	0x08001834
 8000a90:	20005083 	.word	0x20005083
 8000a94:	08001850 	.word	0x08001850
 8000a98:	20005081 	.word	0x20005081
 8000a9c:	08001874 	.word	0x08001874
 8000aa0:	20000078 	.word	0x20000078
 8000aa4:	2000507c 	.word	0x2000507c
 8000aa8:	2000287c 	.word	0x2000287c
 8000aac:	20000000 	.word	0x20000000
 8000ab0:	20000074 	.word	0x20000074

08000ab4 <rollback>:

void rollback(void) {
 8000ab4:	b580      	push	{r7, lr}
 8000ab6:	b08e      	sub	sp, #56	@ 0x38
 8000ab8:	af00      	add	r7, sp, #0

  firmware_t old_f;
  // old firmware is present in the COPY_ADDR section
  init_firmware_t(COPY_ADDR, &old_f);
 8000aba:	f107 0308 	add.w	r3, r7, #8
 8000abe:	4619      	mov	r1, r3
 8000ac0:	4819      	ldr	r0, [pc, #100]	@ (8000b28 <rollback+0x74>)
 8000ac2:	f000 f85d 	bl	8000b80 <init_firmware_t>

  printf("startign rollback\n\n\r", 0x0);
 8000ac6:	2100      	movs	r1, #0
 8000ac8:	4818      	ldr	r0, [pc, #96]	@ (8000b2c <rollback+0x78>)
 8000aca:	f7ff fec7 	bl	800085c <printf>
  erase_flash(old_f.__base_address);
 8000ace:	68bb      	ldr	r3, [r7, #8]
 8000ad0:	4618      	mov	r0, r3
 8000ad2:	f000 faff 	bl	80010d4 <erase_flash>
  printf("corupted firmware is erased\n\r", 0x0);
 8000ad6:	2100      	movs	r1, #0
 8000ad8:	4815      	ldr	r0, [pc, #84]	@ (8000b30 <rollback+0x7c>)
 8000ada:	f7ff febf 	bl	800085c <printf>

  uint32_t copy_size =
      (*(uint32_t *)(COPY_ADDR + 0x14)) - (*(uint32_t *)(COPY_ADDR + 0x0c));
 8000ade:	4b15      	ldr	r3, [pc, #84]	@ (8000b34 <rollback+0x80>)
 8000ae0:	681a      	ldr	r2, [r3, #0]
 8000ae2:	4b15      	ldr	r3, [pc, #84]	@ (8000b38 <rollback+0x84>)
 8000ae4:	681b      	ldr	r3, [r3, #0]
  uint32_t copy_size =
 8000ae6:	1ad3      	subs	r3, r2, r3
 8000ae8:	637b      	str	r3, [r7, #52]	@ 0x34
  flash_write(old_f.__base_address + 0x04, (const char *)(COPY_ADDR + 0x04),
 8000aea:	68bb      	ldr	r3, [r7, #8]
 8000aec:	1d18      	adds	r0, r3, #4
 8000aee:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000af0:	1f1a      	subs	r2, r3, #4
 8000af2:	2300      	movs	r3, #0
 8000af4:	4911      	ldr	r1, [pc, #68]	@ (8000b3c <rollback+0x88>)
 8000af6:	f000 fba7 	bl	8001248 <flash_write>
              copy_size - 0x04, NO_DELAY);

  // word write => size would be 4 (not 2)
  const uint32_t end = 0xfffffffe;
 8000afa:	f06f 0301 	mvn.w	r3, #1
 8000afe:	607b      	str	r3, [r7, #4]
  // &end is of type -> uint32_t * ==> need type conversion
  flash_write(old_f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000b00:	68b8      	ldr	r0, [r7, #8]
 8000b02:	1d39      	adds	r1, r7, #4
 8000b04:	2300      	movs	r3, #0
 8000b06:	2204      	movs	r2, #4
 8000b08:	f000 fb9e 	bl	8001248 <flash_write>
  printf("new flag = %\n\r", old_f.__base_address);
 8000b0c:	68bb      	ldr	r3, [r7, #8]
 8000b0e:	4619      	mov	r1, r3
 8000b10:	480b      	ldr	r0, [pc, #44]	@ (8000b40 <rollback+0x8c>)
 8000b12:	f7ff fea3 	bl	800085c <printf>

  printf("done recovering old firmware \n\r", 0x0);
 8000b16:	2100      	movs	r1, #0
 8000b18:	480a      	ldr	r0, [pc, #40]	@ (8000b44 <rollback+0x90>)
 8000b1a:	f7ff fe9f 	bl	800085c <printf>
}
 8000b1e:	bf00      	nop
 8000b20:	3738      	adds	r7, #56	@ 0x38
 8000b22:	46bd      	mov	sp, r7
 8000b24:	bd80      	pop	{r7, pc}
 8000b26:	bf00      	nop
 8000b28:	08060000 	.word	0x08060000
 8000b2c:	0800188c 	.word	0x0800188c
 8000b30:	080018a4 	.word	0x080018a4
 8000b34:	08060014 	.word	0x08060014
 8000b38:	0806000c 	.word	0x0806000c
 8000b3c:	08060004 	.word	0x08060004
 8000b40:	080018c4 	.word	0x080018c4
 8000b44:	080018d4 	.word	0x080018d4

08000b48 <__NVIC_EnableIRQ>:
{
 8000b48:	b480      	push	{r7}
 8000b4a:	b083      	sub	sp, #12
 8000b4c:	af00      	add	r7, sp, #0
 8000b4e:	4603      	mov	r3, r0
 8000b50:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 8000b52:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000b56:	2b00      	cmp	r3, #0
 8000b58:	db0b      	blt.n	8000b72 <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 8000b5a:	79fb      	ldrb	r3, [r7, #7]
 8000b5c:	f003 021f 	and.w	r2, r3, #31
 8000b60:	4906      	ldr	r1, [pc, #24]	@ (8000b7c <__NVIC_EnableIRQ+0x34>)
 8000b62:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000b66:	095b      	lsrs	r3, r3, #5
 8000b68:	2001      	movs	r0, #1
 8000b6a:	fa00 f202 	lsl.w	r2, r0, r2
 8000b6e:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 8000b72:	bf00      	nop
 8000b74:	370c      	adds	r7, #12
 8000b76:	46bd      	mov	sp, r7
 8000b78:	bc80      	pop	{r7}
 8000b7a:	4770      	bx	lr
 8000b7c:	e000e100 	.word	0xe000e100

08000b80 <init_firmware_t>:
volatile bool flag_size_recieved = false;
volatile bool flag_wrong_size = false;
volatile bool flag_too_big_update = false;


void init_firmware_t(uint32_t address, firmware_t *f) {
 8000b80:	b480      	push	{r7}
 8000b82:	b083      	sub	sp, #12
 8000b84:	af00      	add	r7, sp, #0
 8000b86:	6078      	str	r0, [r7, #4]
 8000b88:	6039      	str	r1, [r7, #0]
  f->__flag = *(volatile uint32_t *)(address + 0x00);
 8000b8a:	687b      	ldr	r3, [r7, #4]
 8000b8c:	681a      	ldr	r2, [r3, #0]
 8000b8e:	683b      	ldr	r3, [r7, #0]
 8000b90:	605a      	str	r2, [r3, #4]
  f->__crc = *((volatile uint32_t *)(address + 0x04));
 8000b92:	687b      	ldr	r3, [r7, #4]
 8000b94:	3304      	adds	r3, #4
 8000b96:	681a      	ldr	r2, [r3, #0]
 8000b98:	683b      	ldr	r3, [r7, #0]
 8000b9a:	609a      	str	r2, [r3, #8]
  f->__vtable_end = *((volatile uint32_t *)(address + 0x08));
 8000b9c:	687b      	ldr	r3, [r7, #4]
 8000b9e:	3308      	adds	r3, #8
 8000ba0:	681a      	ldr	r2, [r3, #0]
 8000ba2:	683b      	ldr	r3, [r7, #0]
 8000ba4:	60da      	str	r2, [r3, #12]
  f->__base_address = *((volatile uint32_t *)(address + 0x0c));
 8000ba6:	687b      	ldr	r3, [r7, #4]
 8000ba8:	330c      	adds	r3, #12
 8000baa:	681a      	ldr	r2, [r3, #0]
 8000bac:	683b      	ldr	r3, [r7, #0]
 8000bae:	601a      	str	r2, [r3, #0]
  f->__vtable_address = *((volatile uint32_t *)(address + 0x10));
 8000bb0:	687b      	ldr	r3, [r7, #4]
 8000bb2:	3310      	adds	r3, #16
 8000bb4:	681a      	ldr	r2, [r3, #0]
 8000bb6:	683b      	ldr	r3, [r7, #0]
 8000bb8:	615a      	str	r2, [r3, #20]
  f->__firmware_end = *((volatile uint32_t *)(address + 0x14));
 8000bba:	687b      	ldr	r3, [r7, #4]
 8000bbc:	3314      	adds	r3, #20
 8000bbe:	681a      	ldr	r2, [r3, #0]
 8000bc0:	683b      	ldr	r3, [r7, #0]
 8000bc2:	619a      	str	r2, [r3, #24]
  f->__firmware_size = f->__firmware_end - f->__base_address;
 8000bc4:	683b      	ldr	r3, [r7, #0]
 8000bc6:	699a      	ldr	r2, [r3, #24]
 8000bc8:	683b      	ldr	r3, [r7, #0]
 8000bca:	681b      	ldr	r3, [r3, #0]
 8000bcc:	1ad2      	subs	r2, r2, r3
 8000bce:	683b      	ldr	r3, [r7, #0]
 8000bd0:	61da      	str	r2, [r3, #28]
  f->__crc_start_addr = address + 0x08;
 8000bd2:	687b      	ldr	r3, [r7, #4]
 8000bd4:	f103 0208 	add.w	r2, r3, #8
 8000bd8:	683b      	ldr	r3, [r7, #0]
 8000bda:	611a      	str	r2, [r3, #16]
  f->__crc_end_addr = f->__crc_start_addr - 0x08 + f->__firmware_size;
 8000bdc:	683b      	ldr	r3, [r7, #0]
 8000bde:	691a      	ldr	r2, [r3, #16]
 8000be0:	683b      	ldr	r3, [r7, #0]
 8000be2:	69db      	ldr	r3, [r3, #28]
 8000be4:	4413      	add	r3, r2
 8000be6:	f1a3 0208 	sub.w	r2, r3, #8
 8000bea:	683b      	ldr	r3, [r7, #0]
 8000bec:	629a      	str	r2, [r3, #40]	@ 0x28
  f->__msp_value = *((volatile uint32_t *)(f->__vtable_address));
 8000bee:	683b      	ldr	r3, [r7, #0]
 8000bf0:	695b      	ldr	r3, [r3, #20]
 8000bf2:	681a      	ldr	r2, [r3, #0]
 8000bf4:	683b      	ldr	r3, [r7, #0]
 8000bf6:	621a      	str	r2, [r3, #32]
  f->__reset_handler = *((volatile uint32_t *)(f->__vtable_address + 0x4));
 8000bf8:	683b      	ldr	r3, [r7, #0]
 8000bfa:	695b      	ldr	r3, [r3, #20]
 8000bfc:	3304      	adds	r3, #4
 8000bfe:	681a      	ldr	r2, [r3, #0]
 8000c00:	683b      	ldr	r3, [r7, #0]
 8000c02:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000c04:	bf00      	nop
 8000c06:	370c      	adds	r7, #12
 8000c08:	46bd      	mov	sp, r7
 8000c0a:	bc80      	pop	{r7}
 8000c0c:	4770      	bx	lr

08000c0e <copy_firmware_t>:

void copy_firmware_t(firmware_t *f_dest, firmware_t *f_src) {
 8000c0e:	b480      	push	{r7}
 8000c10:	b083      	sub	sp, #12
 8000c12:	af00      	add	r7, sp, #0
 8000c14:	6078      	str	r0, [r7, #4]
 8000c16:	6039      	str	r1, [r7, #0]

  f_dest->__base_address = f_src->__base_address;
 8000c18:	683b      	ldr	r3, [r7, #0]
 8000c1a:	681a      	ldr	r2, [r3, #0]
 8000c1c:	687b      	ldr	r3, [r7, #4]
 8000c1e:	601a      	str	r2, [r3, #0]
  f_dest->__flag = f_src->__flag;
 8000c20:	683b      	ldr	r3, [r7, #0]
 8000c22:	685a      	ldr	r2, [r3, #4]
 8000c24:	687b      	ldr	r3, [r7, #4]
 8000c26:	605a      	str	r2, [r3, #4]
  f_dest->__crc = f_src->__crc;
 8000c28:	683b      	ldr	r3, [r7, #0]
 8000c2a:	689a      	ldr	r2, [r3, #8]
 8000c2c:	687b      	ldr	r3, [r7, #4]
 8000c2e:	609a      	str	r2, [r3, #8]
  f_dest->__vtable_end = f_src->__vtable_end;
 8000c30:	683b      	ldr	r3, [r7, #0]
 8000c32:	68da      	ldr	r2, [r3, #12]
 8000c34:	687b      	ldr	r3, [r7, #4]
 8000c36:	60da      	str	r2, [r3, #12]
  f_dest->__crc_start_addr = f_src->__crc_start_addr;
 8000c38:	683b      	ldr	r3, [r7, #0]
 8000c3a:	691a      	ldr	r2, [r3, #16]
 8000c3c:	687b      	ldr	r3, [r7, #4]
 8000c3e:	611a      	str	r2, [r3, #16]
  f_dest->__crc_end_addr = f_src->__crc_end_addr;
 8000c40:	683b      	ldr	r3, [r7, #0]
 8000c42:	6a9a      	ldr	r2, [r3, #40]	@ 0x28
 8000c44:	687b      	ldr	r3, [r7, #4]
 8000c46:	629a      	str	r2, [r3, #40]	@ 0x28
  f_dest->__vtable_address = f_src->__vtable_address;
 8000c48:	683b      	ldr	r3, [r7, #0]
 8000c4a:	695a      	ldr	r2, [r3, #20]
 8000c4c:	687b      	ldr	r3, [r7, #4]
 8000c4e:	615a      	str	r2, [r3, #20]
  f_dest->__firmware_end = f_src->__firmware_end;
 8000c50:	683b      	ldr	r3, [r7, #0]
 8000c52:	699a      	ldr	r2, [r3, #24]
 8000c54:	687b      	ldr	r3, [r7, #4]
 8000c56:	619a      	str	r2, [r3, #24]
  f_dest->__firmware_size = f_src->__firmware_size;
 8000c58:	683b      	ldr	r3, [r7, #0]
 8000c5a:	69da      	ldr	r2, [r3, #28]
 8000c5c:	687b      	ldr	r3, [r7, #4]
 8000c5e:	61da      	str	r2, [r3, #28]
  f_dest->__msp_value = f_src->__msp_value;
 8000c60:	683b      	ldr	r3, [r7, #0]
 8000c62:	6a1a      	ldr	r2, [r3, #32]
 8000c64:	687b      	ldr	r3, [r7, #4]
 8000c66:	621a      	str	r2, [r3, #32]
  f_dest->__reset_handler = f_src->__reset_handler;
 8000c68:	683b      	ldr	r3, [r7, #0]
 8000c6a:	6a5a      	ldr	r2, [r3, #36]	@ 0x24
 8000c6c:	687b      	ldr	r3, [r7, #4]
 8000c6e:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000c70:	bf00      	nop
 8000c72:	370c      	adds	r7, #12
 8000c74:	46bd      	mov	sp, r7
 8000c76:	bc80      	pop	{r7}
 8000c78:	4770      	bx	lr

08000c7a <handle_update>:

bool handle_update(void) {
 8000c7a:	b580      	push	{r7, lr}
 8000c7c:	b098      	sub	sp, #96	@ 0x60
 8000c7e:	af00      	add	r7, sp, #0

  /************************* recieve update and store it in
   * UPDATE_ADDR in flash***********************/

  if (recieve_update()) {
 8000c80:	f7ff fe7c 	bl	800097c <recieve_update>
 8000c84:	4603      	mov	r3, r0
 8000c86:	2b00      	cmp	r3, #0
 8000c88:	d005      	beq.n	8000c96 <handle_update+0x1c>
    printf("ERROR in recieving update\n\r", 0x0);
 8000c8a:	2100      	movs	r1, #0
 8000c8c:	4852      	ldr	r0, [pc, #328]	@ (8000dd8 <handle_update+0x15e>)
 8000c8e:	f7ff fde5 	bl	800085c <printf>
    return 0;
 8000c92:	2300      	movs	r3, #0
 8000c94:	e09c      	b.n	8000dd0 <handle_update+0x156>
  }
  firmware_t f;
  update_size = update_size / 4 * 4 + 4; // align update size by 4bytes
 8000c96:	4b51      	ldr	r3, [pc, #324]	@ (8000ddc <handle_update+0x162>)
 8000c98:	681b      	ldr	r3, [r3, #0]
 8000c9a:	f023 0303 	bic.w	r3, r3, #3
 8000c9e:	3304      	adds	r3, #4
 8000ca0:	4a4e      	ldr	r2, [pc, #312]	@ (8000ddc <handle_update+0x162>)
 8000ca2:	6013      	str	r3, [r2, #0]

  if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_1_ADDRESS)
 8000ca4:	4b4e      	ldr	r3, [pc, #312]	@ (8000de0 <handle_update+0x166>)
 8000ca6:	681b      	ldr	r3, [r3, #0]
 8000ca8:	4a4e      	ldr	r2, [pc, #312]	@ (8000de4 <handle_update+0x16a>)
 8000caa:	4293      	cmp	r3, r2
 8000cac:	d106      	bne.n	8000cbc <handle_update+0x42>
    copy_firmware_t(&f, &f1);
 8000cae:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000cb2:	494d      	ldr	r1, [pc, #308]	@ (8000de8 <handle_update+0x16e>)
 8000cb4:	4618      	mov	r0, r3
 8000cb6:	f7ff ffaa 	bl	8000c0e <copy_firmware_t>
 8000cba:	e011      	b.n	8000ce0 <handle_update+0x66>

  else if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_2_ADDRESS)
 8000cbc:	4b48      	ldr	r3, [pc, #288]	@ (8000de0 <handle_update+0x166>)
 8000cbe:	681b      	ldr	r3, [r3, #0]
 8000cc0:	4a4a      	ldr	r2, [pc, #296]	@ (8000dec <handle_update+0x172>)
 8000cc2:	4293      	cmp	r3, r2
 8000cc4:	d106      	bne.n	8000cd4 <handle_update+0x5a>
    copy_firmware_t(&f, &f2);
 8000cc6:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000cca:	4949      	ldr	r1, [pc, #292]	@ (8000df0 <handle_update+0x176>)
 8000ccc:	4618      	mov	r0, r3
 8000cce:	f7ff ff9e 	bl	8000c0e <copy_firmware_t>
 8000cd2:	e005      	b.n	8000ce0 <handle_update+0x66>

  else {
    printf("wrong firmware base address !!!", 0x0);
 8000cd4:	2100      	movs	r1, #0
 8000cd6:	4847      	ldr	r0, [pc, #284]	@ (8000df4 <handle_update+0x17a>)
 8000cd8:	f7ff fdc0 	bl	800085c <printf>
    return 0;
 8000cdc:	2300      	movs	r3, #0
 8000cde:	e077      	b.n	8000dd0 <handle_update+0x156>
  // if (flash_write(UPDATE_ADDR, fw_update, update_size, NO_DELAY)) {
  //   printf("ERROR in flash_write\n\r", 0x0);
  //   return;
  // }

  printf("update has been saved in the update section !!!\n\r", 0x0);
 8000ce0:	2100      	movs	r1, #0
 8000ce2:	4845      	ldr	r0, [pc, #276]	@ (8000df8 <handle_update+0x17e>)
 8000ce4:	f7ff fdba 	bl	800085c <printf>

  firmware_t uf;
  init_firmware_t(UPDATE_ADDR, &uf);
 8000ce8:	f107 0308 	add.w	r3, r7, #8
 8000cec:	4619      	mov	r1, r3
 8000cee:	4843      	ldr	r0, [pc, #268]	@ (8000dfc <handle_update+0x182>)
 8000cf0:	f7ff ff46 	bl	8000b80 <init_firmware_t>

  printf("***************validating update***************\n\r", 0x0);
 8000cf4:	2100      	movs	r1, #0
 8000cf6:	4842      	ldr	r0, [pc, #264]	@ (8000e00 <handle_update+0x186>)
 8000cf8:	f7ff fdb0 	bl	800085c <printf>

  // check flag field of the firmware
  if (uf.__flag != 0xffffffff) {
 8000cfc:	68fb      	ldr	r3, [r7, #12]
 8000cfe:	f1b3 3fff 	cmp.w	r3, #4294967295	@ 0xffffffff
 8000d02:	d005      	beq.n	8000d10 <handle_update+0x96>
    printf("ERROR .... flag field of update must be 0xffffffff\n\r", 0x0);
 8000d04:	2100      	movs	r1, #0
 8000d06:	483f      	ldr	r0, [pc, #252]	@ (8000e04 <handle_update+0x18a>)
 8000d08:	f7ff fda8 	bl	800085c <printf>
    return 0;
 8000d0c:	2300      	movs	r3, #0
 8000d0e:	e05f      	b.n	8000dd0 <handle_update+0x156>
  }
  if (!validate_firmware(&uf)) {
 8000d10:	f107 0308 	add.w	r3, r7, #8
 8000d14:	4618      	mov	r0, r3
 8000d16:	f7ff fc85 	bl	8000624 <validate_firmware>
 8000d1a:	4603      	mov	r3, r0
 8000d1c:	f083 0301 	eor.w	r3, r3, #1
 8000d20:	b2db      	uxtb	r3, r3
 8000d22:	2b00      	cmp	r3, #0
 8000d24:	d005      	beq.n	8000d32 <handle_update+0xb8>
    printf("ERROR .... update validation failed\n\r", 0x0);
 8000d26:	2100      	movs	r1, #0
 8000d28:	4837      	ldr	r0, [pc, #220]	@ (8000e08 <handle_update+0x18e>)
 8000d2a:	f7ff fd97 	bl	800085c <printf>
    return 0;
 8000d2e:	2300      	movs	r3, #0
 8000d30:	e04e      	b.n	8000dd0 <handle_update+0x156>
  }

  /************************firmware to COPY section
   * ***********************************/

  if (erase_flash(COPY_ADDR)) {
 8000d32:	4836      	ldr	r0, [pc, #216]	@ (8000e0c <handle_update+0x192>)
 8000d34:	f000 f9ce 	bl	80010d4 <erase_flash>
 8000d38:	4603      	mov	r3, r0
 8000d3a:	2b00      	cmp	r3, #0
 8000d3c:	d005      	beq.n	8000d4a <handle_update+0xd0>
    printf("could not erase COPY section\n\r", 0x0);
 8000d3e:	2100      	movs	r1, #0
 8000d40:	4833      	ldr	r0, [pc, #204]	@ (8000e10 <handle_update+0x196>)
 8000d42:	f7ff fd8b 	bl	800085c <printf>
    return 0;
 8000d46:	2300      	movs	r3, #0
 8000d48:	e042      	b.n	8000dd0 <handle_update+0x156>
  }
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000d4a:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000d4c:	4619      	mov	r1, r3
                  f.__firmware_size, NO_DELAY)) {
 8000d4e:	6d3a      	ldr	r2, [r7, #80]	@ 0x50
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000d50:	2300      	movs	r3, #0
 8000d52:	482e      	ldr	r0, [pc, #184]	@ (8000e0c <handle_update+0x192>)
 8000d54:	f000 fa78 	bl	8001248 <flash_write>
 8000d58:	4603      	mov	r3, r0
 8000d5a:	2b00      	cmp	r3, #0
 8000d5c:	d005      	beq.n	8000d6a <handle_update+0xf0>

    printf("could not write to the COPY section \n\r", 0x0);
 8000d5e:	2100      	movs	r1, #0
 8000d60:	482c      	ldr	r0, [pc, #176]	@ (8000e14 <handle_update+0x19a>)
 8000d62:	f7ff fd7b 	bl	800085c <printf>
    return 0;
 8000d66:	2300      	movs	r3, #0
 8000d68:	e032      	b.n	8000dd0 <handle_update+0x156>
  }
  printf("firmware is copied to copy section\n\r", 0x0);
 8000d6a:	2100      	movs	r1, #0
 8000d6c:	482a      	ldr	r0, [pc, #168]	@ (8000e18 <handle_update+0x19e>)
 8000d6e:	f7ff fd75 	bl	800085c <printf>

  /********************* update to firmware
   * ********************************************/

  if (erase_flash(f.__base_address)) {
 8000d72:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000d74:	4618      	mov	r0, r3
 8000d76:	f000 f9ad 	bl	80010d4 <erase_flash>
 8000d7a:	4603      	mov	r3, r0
 8000d7c:	2b00      	cmp	r3, #0
 8000d7e:	d005      	beq.n	8000d8c <handle_update+0x112>
    printf("could not erase FIRMWARE section\n\r", 0x0);
 8000d80:	2100      	movs	r1, #0
 8000d82:	4826      	ldr	r0, [pc, #152]	@ (8000e1c <handle_update+0x1a2>)
 8000d84:	f7ff fd6a 	bl	800085c <printf>
    return 0;
 8000d88:	2300      	movs	r3, #0
 8000d8a:	e021      	b.n	8000dd0 <handle_update+0x156>
  }
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000d8c:	6b78      	ldr	r0, [r7, #52]	@ 0x34
                  uf.__firmware_size, NO_DELAY)) {
 8000d8e:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000d90:	2300      	movs	r3, #0
 8000d92:	491a      	ldr	r1, [pc, #104]	@ (8000dfc <handle_update+0x182>)
 8000d94:	f000 fa58 	bl	8001248 <flash_write>
 8000d98:	4603      	mov	r3, r0
 8000d9a:	2b00      	cmp	r3, #0
 8000d9c:	d005      	beq.n	8000daa <handle_update+0x130>

    printf("could not write to the firmware section\n\r", 0x0);
 8000d9e:	2100      	movs	r1, #0
 8000da0:	481f      	ldr	r0, [pc, #124]	@ (8000e20 <handle_update+0x1a6>)
 8000da2:	f7ff fd5b 	bl	800085c <printf>
    return 0;
 8000da6:	2300      	movs	r3, #0
 8000da8:	e012      	b.n	8000dd0 <handle_update+0x156>
  }

  const uint32_t end = 0xfffffffe;
 8000daa:	f06f 0301 	mvn.w	r3, #1
 8000dae:	607b      	str	r3, [r7, #4]
  // mark the flag implying that firmware has been updated
  flash_write(f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000db0:	6b78      	ldr	r0, [r7, #52]	@ 0x34
 8000db2:	1d39      	adds	r1, r7, #4
 8000db4:	2300      	movs	r3, #0
 8000db6:	2204      	movs	r2, #4
 8000db8:	f000 fa46 	bl	8001248 <flash_write>

  printf("new flag = %\n\r", f.__base_address);
 8000dbc:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000dbe:	4619      	mov	r1, r3
 8000dc0:	4818      	ldr	r0, [pc, #96]	@ (8000e24 <handle_update+0x1aa>)
 8000dc2:	f7ff fd4b 	bl	800085c <printf>

  printf("updating firmware is done successfully!!!!\n\r", 0x0);
 8000dc6:	2100      	movs	r1, #0
 8000dc8:	4817      	ldr	r0, [pc, #92]	@ (8000e28 <handle_update+0x1ae>)
 8000dca:	f7ff fd47 	bl	800085c <printf>

  return 1;
 8000dce:	2301      	movs	r3, #1
}
 8000dd0:	4618      	mov	r0, r3
 8000dd2:	3760      	adds	r7, #96	@ 0x60
 8000dd4:	46bd      	mov	sp, r7
 8000dd6:	bd80      	pop	{r7, pc}
 8000dd8:	080018f4 	.word	0x080018f4
 8000ddc:	20000074 	.word	0x20000074
 8000de0:	0804000c 	.word	0x0804000c
 8000de4:	08010000 	.word	0x08010000
 8000de8:	20000008 	.word	0x20000008
 8000dec:	08020000 	.word	0x08020000
 8000df0:	20000034 	.word	0x20000034
 8000df4:	08001910 	.word	0x08001910
 8000df8:	08001930 	.word	0x08001930
 8000dfc:	08040000 	.word	0x08040000
 8000e00:	08001964 	.word	0x08001964
 8000e04:	08001998 	.word	0x08001998
 8000e08:	080019d0 	.word	0x080019d0
 8000e0c:	08060000 	.word	0x08060000
 8000e10:	080019f8 	.word	0x080019f8
 8000e14:	08001a18 	.word	0x08001a18
 8000e18:	08001a40 	.word	0x08001a40
 8000e1c:	08001a68 	.word	0x08001a68
 8000e20:	08001a8c 	.word	0x08001a8c
 8000e24:	08001ab8 	.word	0x08001ab8
 8000e28:	08001ac8 	.word	0x08001ac8

08000e2c <switch_press>:

bool switch_press (bool f1_valid, bool f2_valid){
 8000e2c:	b580      	push	{r7, lr}
 8000e2e:	b084      	sub	sp, #16
 8000e30:	af00      	add	r7, sp, #0
 8000e32:	4603      	mov	r3, r0
 8000e34:	460a      	mov	r2, r1
 8000e36:	71fb      	strb	r3, [r7, #7]
 8000e38:	4613      	mov	r3, r2
 8000e3a:	71bb      	strb	r3, [r7, #6]

  while (!press_count)
 8000e3c:	bf00      	nop
 8000e3e:	4b36      	ldr	r3, [pc, #216]	@ (8000f18 <switch_press+0xec>)
 8000e40:	681b      	ldr	r3, [r3, #0]
 8000e42:	2b00      	cmp	r3, #0
 8000e44:	d0fb      	beq.n	8000e3e <switch_press+0x12>
    ;
  delay_count = 1000000;
 8000e46:	4b35      	ldr	r3, [pc, #212]	@ (8000f1c <switch_press+0xf0>)
 8000e48:	4a35      	ldr	r2, [pc, #212]	@ (8000f20 <switch_press+0xf4>)
 8000e4a:	601a      	str	r2, [r3, #0]
  while (delay_count--)
 8000e4c:	bf00      	nop
 8000e4e:	4b33      	ldr	r3, [pc, #204]	@ (8000f1c <switch_press+0xf0>)
 8000e50:	681b      	ldr	r3, [r3, #0]
 8000e52:	1e5a      	subs	r2, r3, #1
 8000e54:	4931      	ldr	r1, [pc, #196]	@ (8000f1c <switch_press+0xf0>)
 8000e56:	600a      	str	r2, [r1, #0]
 8000e58:	2b00      	cmp	r3, #0
 8000e5a:	d1f8      	bne.n	8000e4e <switch_press+0x22>
    ;
  if (press_count >= 3) {
 8000e5c:	4b2e      	ldr	r3, [pc, #184]	@ (8000f18 <switch_press+0xec>)
 8000e5e:	681b      	ldr	r3, [r3, #0]
 8000e60:	2b02      	cmp	r3, #2
 8000e62:	d932      	bls.n	8000eca <switch_press+0x9e>
    erase_flash (UPDATE_ADDR);
 8000e64:	482f      	ldr	r0, [pc, #188]	@ (8000f24 <switch_press+0xf8>)
 8000e66:	f000 f935 	bl	80010d4 <erase_flash>
    firmware_update_mode = true;
 8000e6a:	4b2f      	ldr	r3, [pc, #188]	@ (8000f28 <switch_press+0xfc>)
 8000e6c:	2201      	movs	r2, #1
 8000e6e:	701a      	strb	r2, [r3, #0]
    bool status = handle_update();
 8000e70:	f7ff ff03 	bl	8000c7a <handle_update>
 8000e74:	4603      	mov	r3, r0
 8000e76:	73fb      	strb	r3, [r7, #15]

    if (!status && recursion_depth < MAX_RECURSION_DEPTH) {
 8000e78:	7bfb      	ldrb	r3, [r7, #15]
 8000e7a:	f083 0301 	eor.w	r3, r3, #1
 8000e7e:	b2db      	uxtb	r3, r3
 8000e80:	2b00      	cmp	r3, #0
 8000e82:	d020      	beq.n	8000ec6 <switch_press+0x9a>
 8000e84:	4b29      	ldr	r3, [pc, #164]	@ (8000f2c <switch_press+0x100>)
 8000e86:	781b      	ldrb	r3, [r3, #0]
 8000e88:	2b01      	cmp	r3, #1
 8000e8a:	d81c      	bhi.n	8000ec6 <switch_press+0x9a>
      printf ("error in update !!! retry\n\r", 0x0);
 8000e8c:	2100      	movs	r1, #0
 8000e8e:	4828      	ldr	r0, [pc, #160]	@ (8000f30 <switch_press+0x104>)
 8000e90:	f7ff fce4 	bl	800085c <printf>
      recursion_depth ++;
 8000e94:	4b25      	ldr	r3, [pc, #148]	@ (8000f2c <switch_press+0x100>)
 8000e96:	781b      	ldrb	r3, [r3, #0]
 8000e98:	3301      	adds	r3, #1
 8000e9a:	b2da      	uxtb	r2, r3
 8000e9c:	4b23      	ldr	r3, [pc, #140]	@ (8000f2c <switch_press+0x100>)
 8000e9e:	701a      	strb	r2, [r3, #0]
      press_count = 0;
 8000ea0:	4b1d      	ldr	r3, [pc, #116]	@ (8000f18 <switch_press+0xec>)
 8000ea2:	2200      	movs	r2, #0
 8000ea4:	601a      	str	r2, [r3, #0]
      flag_size_recieved = false;
 8000ea6:	4b23      	ldr	r3, [pc, #140]	@ (8000f34 <switch_press+0x108>)
 8000ea8:	2200      	movs	r2, #0
 8000eaa:	701a      	strb	r2, [r3, #0]
      flag_wrong_size = false;
 8000eac:	4b22      	ldr	r3, [pc, #136]	@ (8000f38 <switch_press+0x10c>)
 8000eae:	2200      	movs	r2, #0
 8000eb0:	701a      	strb	r2, [r3, #0]
      flag_too_big_update = false;
 8000eb2:	4b22      	ldr	r3, [pc, #136]	@ (8000f3c <switch_press+0x110>)
 8000eb4:	2200      	movs	r2, #0
 8000eb6:	701a      	strb	r2, [r3, #0]

      switch_press (f1_valid, f2_valid);
 8000eb8:	79ba      	ldrb	r2, [r7, #6]
 8000eba:	79fb      	ldrb	r3, [r7, #7]
 8000ebc:	4611      	mov	r1, r2
 8000ebe:	4618      	mov	r0, r3
 8000ec0:	f7ff ffb4 	bl	8000e2c <switch_press>
 8000ec4:	e022      	b.n	8000f0c <switch_press+0xe0>
    }
    else return false;
 8000ec6:	2300      	movs	r3, #0
 8000ec8:	e021      	b.n	8000f0e <switch_press+0xe2>
  } else if (press_count == 2) {
 8000eca:	4b13      	ldr	r3, [pc, #76]	@ (8000f18 <switch_press+0xec>)
 8000ecc:	681b      	ldr	r3, [r3, #0]
 8000ece:	2b02      	cmp	r3, #2
 8000ed0:	d10e      	bne.n	8000ef0 <switch_press+0xc4>
    if (f2_valid) {
 8000ed2:	79bb      	ldrb	r3, [r7, #6]
 8000ed4:	2b00      	cmp	r3, #0
 8000ed6:	d005      	beq.n	8000ee4 <switch_press+0xb8>
      boot_f1 = false;
 8000ed8:	4b19      	ldr	r3, [pc, #100]	@ (8000f40 <switch_press+0x114>)
 8000eda:	2200      	movs	r2, #0
 8000edc:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000ede:	f7ff f9e1 	bl	80002a4 <jump_to_firmware>
 8000ee2:	e013      	b.n	8000f0c <switch_press+0xe0>
    } else {
      boot_f1 = true;
 8000ee4:	4b16      	ldr	r3, [pc, #88]	@ (8000f40 <switch_press+0x114>)
 8000ee6:	2201      	movs	r2, #1
 8000ee8:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000eea:	f7ff f9db 	bl	80002a4 <jump_to_firmware>
 8000eee:	e00d      	b.n	8000f0c <switch_press+0xe0>
    }
  } else {
    if (f1_valid) {
 8000ef0:	79fb      	ldrb	r3, [r7, #7]
 8000ef2:	2b00      	cmp	r3, #0
 8000ef4:	d005      	beq.n	8000f02 <switch_press+0xd6>
      boot_f1 = true;
 8000ef6:	4b12      	ldr	r3, [pc, #72]	@ (8000f40 <switch_press+0x114>)
 8000ef8:	2201      	movs	r2, #1
 8000efa:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000efc:	f7ff f9d2 	bl	80002a4 <jump_to_firmware>
 8000f00:	e004      	b.n	8000f0c <switch_press+0xe0>
    } else {
      boot_f1 = false;
 8000f02:	4b0f      	ldr	r3, [pc, #60]	@ (8000f40 <switch_press+0x114>)
 8000f04:	2200      	movs	r2, #0
 8000f06:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000f08:	f7ff f9cc 	bl	80002a4 <jump_to_firmware>
    }
  }
  return true;
 8000f0c:	2301      	movs	r3, #1
}
 8000f0e:	4618      	mov	r0, r3
 8000f10:	3710      	adds	r7, #16
 8000f12:	46bd      	mov	sp, r7
 8000f14:	bd80      	pop	{r7, pc}
 8000f16:	bf00      	nop
 8000f18:	20000060 	.word	0x20000060
 8000f1c:	20000064 	.word	0x20000064
 8000f20:	000f4240 	.word	0x000f4240
 8000f24:	08040000 	.word	0x08040000
 8000f28:	2000507e 	.word	0x2000507e
 8000f2c:	2000507f 	.word	0x2000507f
 8000f30:	08001af8 	.word	0x08001af8
 8000f34:	20005081 	.word	0x20005081
 8000f38:	20005082 	.word	0x20005082
 8000f3c:	20005083 	.word	0x20005083
 8000f40:	20000004 	.word	0x20000004

08000f44 <main>:


int main() {
 8000f44:	b580      	push	{r7, lr}
 8000f46:	b082      	sub	sp, #8
 8000f48:	af00      	add	r7, sp, #0

    Ring_buff_init(&ringbuffer);
 8000f4a:	4852      	ldr	r0, [pc, #328]	@ (8001094 <main+0x150>)
 8000f4c:	f7ff fa16 	bl	800037c <Ring_buff_init>

    // enable faults (without this any fault = hardfault)
    SCB->SHCSR |= SCB_SHCSR_BUSFAULTENA_Msk;
 8000f50:	4b51      	ldr	r3, [pc, #324]	@ (8001098 <main+0x154>)
 8000f52:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f54:	4a50      	ldr	r2, [pc, #320]	@ (8001098 <main+0x154>)
 8000f56:	f443 3300 	orr.w	r3, r3, #131072	@ 0x20000
 8000f5a:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_USGFAULTENA_Msk;
 8000f5c:	4b4e      	ldr	r3, [pc, #312]	@ (8001098 <main+0x154>)
 8000f5e:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f60:	4a4d      	ldr	r2, [pc, #308]	@ (8001098 <main+0x154>)
 8000f62:	f443 2380 	orr.w	r3, r3, #262144	@ 0x40000
 8000f66:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
 8000f68:	4b4b      	ldr	r3, [pc, #300]	@ (8001098 <main+0x154>)
 8000f6a:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f6c:	4a4a      	ldr	r2, [pc, #296]	@ (8001098 <main+0x154>)
 8000f6e:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 8000f72:	6253      	str	r3, [r2, #36]	@ 0x24


  __usart1_init();
 8000f74:	f000 fa04 	bl	8001380 <__usart1_init>

  printf("\n\n\nbooting....\n\n\n\r", 0x0);
 8000f78:	2100      	movs	r1, #0
 8000f7a:	4848      	ldr	r0, [pc, #288]	@ (800109c <main+0x158>)
 8000f7c:	f7ff fc6e 	bl	800085c <printf>

  // check if fimrware is corrupted during update

  if (*(uint32_t *)FIRMWARE_1_ADDRESS & 1) {
 8000f80:	4b47      	ldr	r3, [pc, #284]	@ (80010a0 <main+0x15c>)
 8000f82:	681b      	ldr	r3, [r3, #0]
 8000f84:	f003 0301 	and.w	r3, r3, #1
 8000f88:	2b00      	cmp	r3, #0
 8000f8a:	d001      	beq.n	8000f90 <main+0x4c>
    rollback();
 8000f8c:	f7ff fd92 	bl	8000ab4 <rollback>
  }
  if (*(uint32_t *)FIRMWARE_2_ADDRESS & 1) {
 8000f90:	4b44      	ldr	r3, [pc, #272]	@ (80010a4 <main+0x160>)
 8000f92:	681b      	ldr	r3, [r3, #0]
 8000f94:	f003 0301 	and.w	r3, r3, #1
 8000f98:	2b00      	cmp	r3, #0
 8000f9a:	d001      	beq.n	8000fa0 <main+0x5c>
    rollback();
 8000f9c:	f7ff fd8a 	bl	8000ab4 <rollback>
  }

  bool f1_valid = true;
 8000fa0:	2301      	movs	r3, #1
 8000fa2:	71fb      	strb	r3, [r7, #7]
  bool f2_valid = true;
 8000fa4:	2301      	movs	r3, #1
 8000fa6:	71bb      	strb	r3, [r7, #6]
  init_firmware_t(FIRMWARE_1_ADDRESS, &f1);
 8000fa8:	493f      	ldr	r1, [pc, #252]	@ (80010a8 <main+0x164>)
 8000faa:	483d      	ldr	r0, [pc, #244]	@ (80010a0 <main+0x15c>)
 8000fac:	f7ff fde8 	bl	8000b80 <init_firmware_t>
  init_firmware_t(FIRMWARE_2_ADDRESS, &f2);
 8000fb0:	493e      	ldr	r1, [pc, #248]	@ (80010ac <main+0x168>)
 8000fb2:	483c      	ldr	r0, [pc, #240]	@ (80010a4 <main+0x160>)
 8000fb4:	f7ff fde4 	bl	8000b80 <init_firmware_t>

  // printf("hii there %\n\r", f1.__vtable_address);

  printf("*************validating firmware1*************\n\r", 0x0);
 8000fb8:	2100      	movs	r1, #0
 8000fba:	483d      	ldr	r0, [pc, #244]	@ (80010b0 <main+0x16c>)
 8000fbc:	f7ff fc4e 	bl	800085c <printf>
  f1_valid = validate_firmware(&f1);
 8000fc0:	4839      	ldr	r0, [pc, #228]	@ (80010a8 <main+0x164>)
 8000fc2:	f7ff fb2f 	bl	8000624 <validate_firmware>
 8000fc6:	4603      	mov	r3, r0
 8000fc8:	71fb      	strb	r3, [r7, #7]
  printf("*************validating firmware2*************\n\r", 0x0);
 8000fca:	2100      	movs	r1, #0
 8000fcc:	4839      	ldr	r0, [pc, #228]	@ (80010b4 <main+0x170>)
 8000fce:	f7ff fc45 	bl	800085c <printf>
  f2_valid = validate_firmware(&f2);
 8000fd2:	4836      	ldr	r0, [pc, #216]	@ (80010ac <main+0x168>)
 8000fd4:	f7ff fb26 	bl	8000624 <validate_firmware>
 8000fd8:	4603      	mov	r3, r0
 8000fda:	71bb      	strb	r3, [r7, #6]

  printf("both the firmwares are checked\n\r", 0x0);
 8000fdc:	2100      	movs	r1, #0
 8000fde:	4836      	ldr	r0, [pc, #216]	@ (80010b8 <main+0x174>)
 8000fe0:	f7ff fc3c 	bl	800085c <printf>
  // init GPIOC (for on board switch)
  // init SYSCGF (for using EXTI)

  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN_Msk;
 8000fe4:	4b35      	ldr	r3, [pc, #212]	@ (80010bc <main+0x178>)
 8000fe6:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8000fe8:	4a34      	ldr	r2, [pc, #208]	@ (80010bc <main+0x178>)
 8000fea:	f443 4380 	orr.w	r3, r3, #16384	@ 0x4000
 8000fee:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN_Msk;
 8000ff0:	4b32      	ldr	r3, [pc, #200]	@ (80010bc <main+0x178>)
 8000ff2:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8000ff4:	4a31      	ldr	r2, [pc, #196]	@ (80010bc <main+0x178>)
 8000ff6:	f043 0304 	orr.w	r3, r3, #4
 8000ffa:	6313      	str	r3, [r2, #48]	@ 0x30

  // set switch to input
  GPIOC->MODER &= ~(3U << (2 * SWITCH_PIN));
 8000ffc:	4b30      	ldr	r3, [pc, #192]	@ (80010c0 <main+0x17c>)
 8000ffe:	681b      	ldr	r3, [r3, #0]
 8001000:	4a2f      	ldr	r2, [pc, #188]	@ (80010c0 <main+0x17c>)
 8001002:	f023 6340 	bic.w	r3, r3, #201326592	@ 0xc000000
 8001006:	6013      	str	r3, [r2, #0]

  // falling edge detect
  EXTI->FTSR |= EXTI_FTSR_TR13_Msk;
 8001008:	4b2e      	ldr	r3, [pc, #184]	@ (80010c4 <main+0x180>)
 800100a:	68db      	ldr	r3, [r3, #12]
 800100c:	4a2d      	ldr	r2, [pc, #180]	@ (80010c4 <main+0x180>)
 800100e:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8001012:	60d3      	str	r3, [r2, #12]

  SYSCFG->EXTICR[3] &= ~(SYSCFG_EXTICR4_EXTI13_Msk);
 8001014:	4b2c      	ldr	r3, [pc, #176]	@ (80010c8 <main+0x184>)
 8001016:	695b      	ldr	r3, [r3, #20]
 8001018:	4a2b      	ldr	r2, [pc, #172]	@ (80010c8 <main+0x184>)
 800101a:	f023 03f0 	bic.w	r3, r3, #240	@ 0xf0
 800101e:	6153      	str	r3, [r2, #20]
  SYSCFG->EXTICR[3] |= SYSCFG_EXTICR4_EXTI13_PC;
 8001020:	4b29      	ldr	r3, [pc, #164]	@ (80010c8 <main+0x184>)
 8001022:	695b      	ldr	r3, [r3, #20]
 8001024:	4a28      	ldr	r2, [pc, #160]	@ (80010c8 <main+0x184>)
 8001026:	f043 0320 	orr.w	r3, r3, #32
 800102a:	6153      	str	r3, [r2, #20]

  // enable mask at the end
  EXTI->IMR |= EXTI_IMR_MR13_Msk;
 800102c:	4b25      	ldr	r3, [pc, #148]	@ (80010c4 <main+0x180>)
 800102e:	681b      	ldr	r3, [r3, #0]
 8001030:	4a24      	ldr	r2, [pc, #144]	@ (80010c4 <main+0x180>)
 8001032:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8001036:	6013      	str	r3, [r2, #0]

  NVIC_EnableIRQ(EXTI15_10_IRQn);
 8001038:	2028      	movs	r0, #40	@ 0x28
 800103a:	f7ff fd85 	bl	8000b48 <__NVIC_EnableIRQ>

  if (!f1_valid && !f2_valid) {
 800103e:	79fb      	ldrb	r3, [r7, #7]
 8001040:	f083 0301 	eor.w	r3, r3, #1
 8001044:	b2db      	uxtb	r3, r3
 8001046:	2b00      	cmp	r3, #0
 8001048:	d011      	beq.n	800106e <main+0x12a>
 800104a:	79bb      	ldrb	r3, [r7, #6]
 800104c:	f083 0301 	eor.w	r3, r3, #1
 8001050:	b2db      	uxtb	r3, r3
 8001052:	2b00      	cmp	r3, #0
 8001054:	d00b      	beq.n	800106e <main+0x12a>
    printf("both the firmwares are not valid\n\n\r", 0x0);
 8001056:	2100      	movs	r1, #0
 8001058:	481c      	ldr	r0, [pc, #112]	@ (80010cc <main+0x188>)
 800105a:	f7ff fbff 	bl	800085c <printf>
    EXTI->IMR &= EXTI_IMR_MR13_Msk;
 800105e:	4b19      	ldr	r3, [pc, #100]	@ (80010c4 <main+0x180>)
 8001060:	681b      	ldr	r3, [r3, #0]
 8001062:	4a18      	ldr	r2, [pc, #96]	@ (80010c4 <main+0x180>)
 8001064:	f403 5300 	and.w	r3, r3, #8192	@ 0x2000
 8001068:	6013      	str	r3, [r2, #0]
    handle_update();
 800106a:	f7ff fe06 	bl	8000c7a <handle_update>
  }

  // /* illegal memory access */
  // *(uint32_t *) (0xffffffff) = 0;
  
  bool status = switch_press (f1_valid, f2_valid);
 800106e:	79ba      	ldrb	r2, [r7, #6]
 8001070:	79fb      	ldrb	r3, [r7, #7]
 8001072:	4611      	mov	r1, r2
 8001074:	4618      	mov	r0, r3
 8001076:	f7ff fed9 	bl	8000e2c <switch_press>
 800107a:	4603      	mov	r3, r0
 800107c:	717b      	strb	r3, [r7, #5]
  if (!status){
 800107e:	797b      	ldrb	r3, [r7, #5]
 8001080:	f083 0301 	eor.w	r3, r3, #1
 8001084:	b2db      	uxtb	r3, r3
 8001086:	2b00      	cmp	r3, #0
 8001088:	d003      	beq.n	8001092 <main+0x14e>
    printf ("too many wrong firmware update attempt !!!\n\r", 0x0);
 800108a:	2100      	movs	r1, #0
 800108c:	4810      	ldr	r0, [pc, #64]	@ (80010d0 <main+0x18c>)
 800108e:	f7ff fbe5 	bl	800085c <printf>
  }
  while (1);
 8001092:	e7fe      	b.n	8001092 <main+0x14e>
 8001094:	20000078 	.word	0x20000078
 8001098:	e000ed00 	.word	0xe000ed00
 800109c:	08001b14 	.word	0x08001b14
 80010a0:	08010000 	.word	0x08010000
 80010a4:	08020000 	.word	0x08020000
 80010a8:	20000008 	.word	0x20000008
 80010ac:	20000034 	.word	0x20000034
 80010b0:	08001b28 	.word	0x08001b28
 80010b4:	08001b5c 	.word	0x08001b5c
 80010b8:	08001b90 	.word	0x08001b90
 80010bc:	40023800 	.word	0x40023800
 80010c0:	40020800 	.word	0x40020800
 80010c4:	40013c00 	.word	0x40013c00
 80010c8:	40013800 	.word	0x40013800
 80010cc:	08001bb4 	.word	0x08001bb4
 80010d0:	08001bd8 	.word	0x08001bd8

080010d4 <erase_flash>:
#define KEY1 0x45670123
#define KEY2 0xCDEF89AB

void printf (const char *string, uint32_t addr);

uint32_t erase_flash(uint32_t address) {
 80010d4:	b580      	push	{r7, lr}
 80010d6:	b084      	sub	sp, #16
 80010d8:	af00      	add	r7, sp, #0
 80010da:	6078      	str	r0, [r7, #4]
  if (address >= 0x08080000 || address < 0x08000000) {
 80010dc:	687b      	ldr	r3, [r7, #4]
 80010de:	4a4c      	ldr	r2, [pc, #304]	@ (8001210 <erase_flash+0x13c>)
 80010e0:	4293      	cmp	r3, r2
 80010e2:	d803      	bhi.n	80010ec <erase_flash+0x18>
 80010e4:	687b      	ldr	r3, [r7, #4]
 80010e6:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 80010ea:	d206      	bcs.n	80010fa <erase_flash+0x26>
    printf("wrong address \n\r", 0x0);
 80010ec:	2100      	movs	r1, #0
 80010ee:	4849      	ldr	r0, [pc, #292]	@ (8001214 <erase_flash+0x140>)
 80010f0:	f7ff fbb4 	bl	800085c <printf>
    return -1;
 80010f4:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80010f8:	e085      	b.n	8001206 <erase_flash+0x132>
  }

  uint32_t sector = 0;
 80010fa:	2300      	movs	r3, #0
 80010fc:	60fb      	str	r3, [r7, #12]
  if (address >= 0x08060000)
 80010fe:	687b      	ldr	r3, [r7, #4]
 8001100:	4a45      	ldr	r2, [pc, #276]	@ (8001218 <erase_flash+0x144>)
 8001102:	4293      	cmp	r3, r2
 8001104:	d902      	bls.n	800110c <erase_flash+0x38>
    sector = 7;
 8001106:	2307      	movs	r3, #7
 8001108:	60fb      	str	r3, [r7, #12]
 800110a:	e037      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08040000)
 800110c:	687b      	ldr	r3, [r7, #4]
 800110e:	4a43      	ldr	r2, [pc, #268]	@ (800121c <erase_flash+0x148>)
 8001110:	4293      	cmp	r3, r2
 8001112:	d902      	bls.n	800111a <erase_flash+0x46>
    sector = 6;
 8001114:	2306      	movs	r3, #6
 8001116:	60fb      	str	r3, [r7, #12]
 8001118:	e030      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08020000)
 800111a:	687b      	ldr	r3, [r7, #4]
 800111c:	4a40      	ldr	r2, [pc, #256]	@ (8001220 <erase_flash+0x14c>)
 800111e:	4293      	cmp	r3, r2
 8001120:	d902      	bls.n	8001128 <erase_flash+0x54>
    sector = 5;
 8001122:	2305      	movs	r3, #5
 8001124:	60fb      	str	r3, [r7, #12]
 8001126:	e029      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08010000)
 8001128:	687b      	ldr	r3, [r7, #4]
 800112a:	4a3e      	ldr	r2, [pc, #248]	@ (8001224 <erase_flash+0x150>)
 800112c:	4293      	cmp	r3, r2
 800112e:	d902      	bls.n	8001136 <erase_flash+0x62>
    sector = 4;
 8001130:	2304      	movs	r3, #4
 8001132:	60fb      	str	r3, [r7, #12]
 8001134:	e022      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x0800c000)
 8001136:	687b      	ldr	r3, [r7, #4]
 8001138:	4a3b      	ldr	r2, [pc, #236]	@ (8001228 <erase_flash+0x154>)
 800113a:	4293      	cmp	r3, r2
 800113c:	d302      	bcc.n	8001144 <erase_flash+0x70>
    sector = 3;
 800113e:	2303      	movs	r3, #3
 8001140:	60fb      	str	r3, [r7, #12]
 8001142:	e01b      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08008000)
 8001144:	687b      	ldr	r3, [r7, #4]
 8001146:	4a39      	ldr	r2, [pc, #228]	@ (800122c <erase_flash+0x158>)
 8001148:	4293      	cmp	r3, r2
 800114a:	d302      	bcc.n	8001152 <erase_flash+0x7e>
    sector = 2;
 800114c:	2302      	movs	r3, #2
 800114e:	60fb      	str	r3, [r7, #12]
 8001150:	e014      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08004000)
 8001152:	687b      	ldr	r3, [r7, #4]
 8001154:	4a36      	ldr	r2, [pc, #216]	@ (8001230 <erase_flash+0x15c>)
 8001156:	4293      	cmp	r3, r2
 8001158:	d302      	bcc.n	8001160 <erase_flash+0x8c>
    sector = 1;
 800115a:	2301      	movs	r3, #1
 800115c:	60fb      	str	r3, [r7, #12]
 800115e:	e00d      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08000000)
 8001160:	687b      	ldr	r3, [r7, #4]
 8001162:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 8001166:	d302      	bcc.n	800116e <erase_flash+0x9a>
    sector = 0;
 8001168:	2300      	movs	r3, #0
 800116a:	60fb      	str	r3, [r7, #12]
 800116c:	e006      	b.n	800117c <erase_flash+0xa8>
  else {
    printf("wrong address\n\r", 0x0);
 800116e:	2100      	movs	r1, #0
 8001170:	4830      	ldr	r0, [pc, #192]	@ (8001234 <erase_flash+0x160>)
 8001172:	f7ff fb73 	bl	800085c <printf>
    return -1;
 8001176:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 800117a:	e044      	b.n	8001206 <erase_flash+0x132>
  }
  // unlock
  FLASH->KEYR = KEY1;
 800117c:	4b2e      	ldr	r3, [pc, #184]	@ (8001238 <erase_flash+0x164>)
 800117e:	4a2f      	ldr	r2, [pc, #188]	@ (800123c <erase_flash+0x168>)
 8001180:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 8001182:	4b2d      	ldr	r3, [pc, #180]	@ (8001238 <erase_flash+0x164>)
 8001184:	4a2e      	ldr	r2, [pc, #184]	@ (8001240 <erase_flash+0x16c>)
 8001186:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8001188:	4b2b      	ldr	r3, [pc, #172]	@ (8001238 <erase_flash+0x164>)
 800118a:	68db      	ldr	r3, [r3, #12]
 800118c:	4a2a      	ldr	r2, [pc, #168]	@ (8001238 <erase_flash+0x164>)
 800118e:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 8001192:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 8001194:	bf00      	nop
 8001196:	4b28      	ldr	r3, [pc, #160]	@ (8001238 <erase_flash+0x164>)
 8001198:	68db      	ldr	r3, [r3, #12]
 800119a:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 800119e:	2b00      	cmp	r3, #0
 80011a0:	d1f9      	bne.n	8001196 <erase_flash+0xc2>
    ;

  FLASH->CR |= FLASH_CR_SER;
 80011a2:	4b25      	ldr	r3, [pc, #148]	@ (8001238 <erase_flash+0x164>)
 80011a4:	691b      	ldr	r3, [r3, #16]
 80011a6:	4a24      	ldr	r2, [pc, #144]	@ (8001238 <erase_flash+0x164>)
 80011a8:	f043 0302 	orr.w	r3, r3, #2
 80011ac:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(FLASH_CR_SNB);
 80011ae:	4b22      	ldr	r3, [pc, #136]	@ (8001238 <erase_flash+0x164>)
 80011b0:	691b      	ldr	r3, [r3, #16]
 80011b2:	4a21      	ldr	r2, [pc, #132]	@ (8001238 <erase_flash+0x164>)
 80011b4:	f023 03f8 	bic.w	r3, r3, #248	@ 0xf8
 80011b8:	6113      	str	r3, [r2, #16]
  FLASH->CR |= (sector << FLASH_CR_SNB_Pos);
 80011ba:	4b1f      	ldr	r3, [pc, #124]	@ (8001238 <erase_flash+0x164>)
 80011bc:	691a      	ldr	r2, [r3, #16]
 80011be:	68fb      	ldr	r3, [r7, #12]
 80011c0:	00db      	lsls	r3, r3, #3
 80011c2:	491d      	ldr	r1, [pc, #116]	@ (8001238 <erase_flash+0x164>)
 80011c4:	4313      	orrs	r3, r2
 80011c6:	610b      	str	r3, [r1, #16]
  FLASH->CR |= FLASH_CR_STRT;
 80011c8:	4b1b      	ldr	r3, [pc, #108]	@ (8001238 <erase_flash+0x164>)
 80011ca:	691b      	ldr	r3, [r3, #16]
 80011cc:	4a1a      	ldr	r2, [pc, #104]	@ (8001238 <erase_flash+0x164>)
 80011ce:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 80011d2:	6113      	str	r3, [r2, #16]

  // wait for the flash to be erased;
  while (FLASH->SR & FLASH_SR_BSY)
 80011d4:	bf00      	nop
 80011d6:	4b18      	ldr	r3, [pc, #96]	@ (8001238 <erase_flash+0x164>)
 80011d8:	68db      	ldr	r3, [r3, #12]
 80011da:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 80011de:	2b00      	cmp	r3, #0
 80011e0:	d1f9      	bne.n	80011d6 <erase_flash+0x102>
    ;

  // clear the erase bit
  FLASH->CR &= ~(FLASH_CR_SER);
 80011e2:	4b15      	ldr	r3, [pc, #84]	@ (8001238 <erase_flash+0x164>)
 80011e4:	691b      	ldr	r3, [r3, #16]
 80011e6:	4a14      	ldr	r2, [pc, #80]	@ (8001238 <erase_flash+0x164>)
 80011e8:	f023 0302 	bic.w	r3, r3, #2
 80011ec:	6113      	str	r3, [r2, #16]
  // lock the control register
  FLASH->CR |= FLASH_CR_LOCK;
 80011ee:	4b12      	ldr	r3, [pc, #72]	@ (8001238 <erase_flash+0x164>)
 80011f0:	691b      	ldr	r3, [r3, #16]
 80011f2:	4a11      	ldr	r2, [pc, #68]	@ (8001238 <erase_flash+0x164>)
 80011f4:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 80011f8:	6113      	str	r3, [r2, #16]

  printf("done erasing flash (address = %)\n\r", (uint32_t)(&address));
 80011fa:	1d3b      	adds	r3, r7, #4
 80011fc:	4619      	mov	r1, r3
 80011fe:	4811      	ldr	r0, [pc, #68]	@ (8001244 <erase_flash+0x170>)
 8001200:	f7ff fb2c 	bl	800085c <printf>
  return 0;
 8001204:	2300      	movs	r3, #0
}
 8001206:	4618      	mov	r0, r3
 8001208:	3710      	adds	r7, #16
 800120a:	46bd      	mov	sp, r7
 800120c:	bd80      	pop	{r7, pc}
 800120e:	bf00      	nop
 8001210:	0807ffff 	.word	0x0807ffff
 8001214:	08001c08 	.word	0x08001c08
 8001218:	0805ffff 	.word	0x0805ffff
 800121c:	0803ffff 	.word	0x0803ffff
 8001220:	0801ffff 	.word	0x0801ffff
 8001224:	0800ffff 	.word	0x0800ffff
 8001228:	0800c000 	.word	0x0800c000
 800122c:	08008000 	.word	0x08008000
 8001230:	08004000 	.word	0x08004000
 8001234:	08001c1c 	.word	0x08001c1c
 8001238:	40023c00 	.word	0x40023c00
 800123c:	45670123 	.word	0x45670123
 8001240:	cdef89ab 	.word	0xcdef89ab
 8001244:	08001c2c 	.word	0x08001c2c

08001248 <flash_write>:

uint32_t flash_write(uint32_t address, const char *buff, uint32_t size,
                     uint32_t simulate) {
 8001248:	b480      	push	{r7}
 800124a:	b087      	sub	sp, #28
 800124c:	af00      	add	r7, sp, #0
 800124e:	60f8      	str	r0, [r7, #12]
 8001250:	60b9      	str	r1, [r7, #8]
 8001252:	607a      	str	r2, [r7, #4]
 8001254:	603b      	str	r3, [r7, #0]


  // unlock
  FLASH->KEYR = KEY1;
 8001256:	4b26      	ldr	r3, [pc, #152]	@ (80012f0 <flash_write+0xa8>)
 8001258:	4a26      	ldr	r2, [pc, #152]	@ (80012f4 <flash_write+0xac>)
 800125a:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 800125c:	4b24      	ldr	r3, [pc, #144]	@ (80012f0 <flash_write+0xa8>)
 800125e:	4a26      	ldr	r2, [pc, #152]	@ (80012f8 <flash_write+0xb0>)
 8001260:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8001262:	4b23      	ldr	r3, [pc, #140]	@ (80012f0 <flash_write+0xa8>)
 8001264:	68db      	ldr	r3, [r3, #12]
 8001266:	4a22      	ldr	r2, [pc, #136]	@ (80012f0 <flash_write+0xa8>)
 8001268:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 800126c:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 800126e:	bf00      	nop
 8001270:	4b1f      	ldr	r3, [pc, #124]	@ (80012f0 <flash_write+0xa8>)
 8001272:	68db      	ldr	r3, [r3, #12]
 8001274:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 8001278:	2b00      	cmp	r3, #0
 800127a:	d1f9      	bne.n	8001270 <flash_write+0x28>
    ;
  FLASH->CR |= FLASH_CR_PG;
 800127c:	4b1c      	ldr	r3, [pc, #112]	@ (80012f0 <flash_write+0xa8>)
 800127e:	691b      	ldr	r3, [r3, #16]
 8001280:	4a1b      	ldr	r2, [pc, #108]	@ (80012f0 <flash_write+0xa8>)
 8001282:	f043 0301 	orr.w	r3, r3, #1
 8001286:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(3 << FLASH_CR_PSIZE_Pos);
 8001288:	4b19      	ldr	r3, [pc, #100]	@ (80012f0 <flash_write+0xa8>)
 800128a:	691b      	ldr	r3, [r3, #16]
 800128c:	4a18      	ldr	r2, [pc, #96]	@ (80012f0 <flash_write+0xa8>)
 800128e:	f423 7340 	bic.w	r3, r3, #768	@ 0x300
 8001292:	6113      	str	r3, [r2, #16]
  // set PSIZE bit to 2 for 32 bit programming
  FLASH->CR |= 2 << FLASH_CR_PSIZE_Pos;
 8001294:	4b16      	ldr	r3, [pc, #88]	@ (80012f0 <flash_write+0xa8>)
 8001296:	691b      	ldr	r3, [r3, #16]
 8001298:	4a15      	ldr	r2, [pc, #84]	@ (80012f0 <flash_write+0xa8>)
 800129a:	f443 7300 	orr.w	r3, r3, #512	@ 0x200
 800129e:	6113      	str	r3, [r2, #16]

  uint32_t i = 0;
 80012a0:	2300      	movs	r3, #0
 80012a2:	617b      	str	r3, [r7, #20]
  while (i < size / 4) {
 80012a4:	e00c      	b.n	80012c0 <flash_write+0x78>

    *((uint32_t *)address) = ((const uint32_t *)buff)[i];
 80012a6:	697b      	ldr	r3, [r7, #20]
 80012a8:	009b      	lsls	r3, r3, #2
 80012aa:	68ba      	ldr	r2, [r7, #8]
 80012ac:	441a      	add	r2, r3
 80012ae:	68fb      	ldr	r3, [r7, #12]
 80012b0:	6812      	ldr	r2, [r2, #0]
 80012b2:	601a      	str	r2, [r3, #0]
    i++;
 80012b4:	697b      	ldr	r3, [r7, #20]
 80012b6:	3301      	adds	r3, #1
 80012b8:	617b      	str	r3, [r7, #20]
    address += 4;
 80012ba:	68fb      	ldr	r3, [r7, #12]
 80012bc:	3304      	adds	r3, #4
 80012be:	60fb      	str	r3, [r7, #12]
  while (i < size / 4) {
 80012c0:	687b      	ldr	r3, [r7, #4]
 80012c2:	089b      	lsrs	r3, r3, #2
 80012c4:	697a      	ldr	r2, [r7, #20]
 80012c6:	429a      	cmp	r2, r3
 80012c8:	d3ed      	bcc.n	80012a6 <flash_write+0x5e>
  }
  FLASH->CR &= ~(FLASH_CR_PG);
 80012ca:	4b09      	ldr	r3, [pc, #36]	@ (80012f0 <flash_write+0xa8>)
 80012cc:	691b      	ldr	r3, [r3, #16]
 80012ce:	4a08      	ldr	r2, [pc, #32]	@ (80012f0 <flash_write+0xa8>)
 80012d0:	f023 0301 	bic.w	r3, r3, #1
 80012d4:	6113      	str	r3, [r2, #16]
  FLASH->CR |= FLASH_CR_LOCK;
 80012d6:	4b06      	ldr	r3, [pc, #24]	@ (80012f0 <flash_write+0xa8>)
 80012d8:	691b      	ldr	r3, [r3, #16]
 80012da:	4a05      	ldr	r2, [pc, #20]	@ (80012f0 <flash_write+0xa8>)
 80012dc:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 80012e0:	6113      	str	r3, [r2, #16]

  return 0;
 80012e2:	2300      	movs	r3, #0
}
 80012e4:	4618      	mov	r0, r3
 80012e6:	371c      	adds	r7, #28
 80012e8:	46bd      	mov	sp, r7
 80012ea:	bc80      	pop	{r7}
 80012ec:	4770      	bx	lr
 80012ee:	bf00      	nop
 80012f0:	40023c00 	.word	0x40023c00
 80012f4:	45670123 	.word	0x45670123
 80012f8:	cdef89ab 	.word	0xcdef89ab

080012fc <__NVIC_EnableIRQ>:
{
 80012fc:	b480      	push	{r7}
 80012fe:	b083      	sub	sp, #12
 8001300:	af00      	add	r7, sp, #0
 8001302:	4603      	mov	r3, r0
 8001304:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 8001306:	f997 3007 	ldrsb.w	r3, [r7, #7]
 800130a:	2b00      	cmp	r3, #0
 800130c:	db0b      	blt.n	8001326 <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 800130e:	79fb      	ldrb	r3, [r7, #7]
 8001310:	f003 021f 	and.w	r2, r3, #31
 8001314:	4906      	ldr	r1, [pc, #24]	@ (8001330 <__NVIC_EnableIRQ+0x34>)
 8001316:	f997 3007 	ldrsb.w	r3, [r7, #7]
 800131a:	095b      	lsrs	r3, r3, #5
 800131c:	2001      	movs	r0, #1
 800131e:	fa00 f202 	lsl.w	r2, r0, r2
 8001322:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 8001326:	bf00      	nop
 8001328:	370c      	adds	r7, #12
 800132a:	46bd      	mov	sp, r7
 800132c:	bc80      	pop	{r7}
 800132e:	4770      	bx	lr
 8001330:	e000e100 	.word	0xe000e100

08001334 <__usart1_scan>:
#include "stm32f401xe.h"

#define TX_PIN 9
#define RX_PIN 10

void __usart1_scan (char* buffer, uint16_t size){
 8001334:	b480      	push	{r7}
 8001336:	b085      	sub	sp, #20
 8001338:	af00      	add	r7, sp, #0
 800133a:	6078      	str	r0, [r7, #4]
 800133c:	460b      	mov	r3, r1
 800133e:	807b      	strh	r3, [r7, #2]
  
  uint16_t i = 0;
 8001340:	2300      	movs	r3, #0
 8001342:	81fb      	strh	r3, [r7, #14]
  while (i < size) {
 8001344:	e010      	b.n	8001368 <__usart1_scan+0x34>
    // wait
    while (!(USART1->SR & USART_SR_RXNE))
 8001346:	bf00      	nop
 8001348:	4b0c      	ldr	r3, [pc, #48]	@ (800137c <__usart1_scan+0x48>)
 800134a:	681b      	ldr	r3, [r3, #0]
 800134c:	f003 0320 	and.w	r3, r3, #32
 8001350:	2b00      	cmp	r3, #0
 8001352:	d0f9      	beq.n	8001348 <__usart1_scan+0x14>
      ;
    buffer[i++] = USART1->DR;
 8001354:	4b09      	ldr	r3, [pc, #36]	@ (800137c <__usart1_scan+0x48>)
 8001356:	685a      	ldr	r2, [r3, #4]
 8001358:	89fb      	ldrh	r3, [r7, #14]
 800135a:	1c59      	adds	r1, r3, #1
 800135c:	81f9      	strh	r1, [r7, #14]
 800135e:	4619      	mov	r1, r3
 8001360:	687b      	ldr	r3, [r7, #4]
 8001362:	440b      	add	r3, r1
 8001364:	b2d2      	uxtb	r2, r2
 8001366:	701a      	strb	r2, [r3, #0]
  while (i < size) {
 8001368:	89fa      	ldrh	r2, [r7, #14]
 800136a:	887b      	ldrh	r3, [r7, #2]
 800136c:	429a      	cmp	r2, r3
 800136e:	d3ea      	bcc.n	8001346 <__usart1_scan+0x12>
  }
}
 8001370:	bf00      	nop
 8001372:	bf00      	nop
 8001374:	3714      	adds	r7, #20
 8001376:	46bd      	mov	sp, r7
 8001378:	bc80      	pop	{r7}
 800137a:	4770      	bx	lr
 800137c:	40011000 	.word	0x40011000

08001380 <__usart1_init>:

void __usart1_init(void) {
 8001380:	b580      	push	{r7, lr}
 8001382:	af00      	add	r7, sp, #0

  RCC->APB2ENR |= RCC_APB2ENR_USART1EN_Msk;
 8001384:	4b20      	ldr	r3, [pc, #128]	@ (8001408 <__usart1_init+0x88>)
 8001386:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8001388:	4a1f      	ldr	r2, [pc, #124]	@ (8001408 <__usart1_init+0x88>)
 800138a:	f043 0310 	orr.w	r3, r3, #16
 800138e:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
 8001390:	4b1d      	ldr	r3, [pc, #116]	@ (8001408 <__usart1_init+0x88>)
 8001392:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8001394:	4a1c      	ldr	r2, [pc, #112]	@ (8001408 <__usart1_init+0x88>)
 8001396:	f043 0301 	orr.w	r3, r3, #1
 800139a:	6313      	str	r3, [r2, #48]	@ 0x30
  // alternate function mode
  GPIOA->MODER &= ~((3 << (2 * TX_PIN)) | (3 << (2 * RX_PIN)));
 800139c:	4b1b      	ldr	r3, [pc, #108]	@ (800140c <__usart1_init+0x8c>)
 800139e:	681b      	ldr	r3, [r3, #0]
 80013a0:	4a1a      	ldr	r2, [pc, #104]	@ (800140c <__usart1_init+0x8c>)
 80013a2:	f423 1370 	bic.w	r3, r3, #3932160	@ 0x3c0000
 80013a6:	6013      	str	r3, [r2, #0]
  GPIOA->MODER |= 2 << (2 * TX_PIN) | 2 << (2 * RX_PIN);
 80013a8:	4b18      	ldr	r3, [pc, #96]	@ (800140c <__usart1_init+0x8c>)
 80013aa:	681b      	ldr	r3, [r3, #0]
 80013ac:	4a17      	ldr	r2, [pc, #92]	@ (800140c <__usart1_init+0x8c>)
 80013ae:	f443 1320 	orr.w	r3, r3, #2621440	@ 0x280000
 80013b2:	6013      	str	r3, [r2, #0]
  // high speed
  GPIOA->OSPEEDR |= (3 << (TX_PIN * 2)) | (3 << (RX_PIN * 2));
 80013b4:	4b15      	ldr	r3, [pc, #84]	@ (800140c <__usart1_init+0x8c>)
 80013b6:	689b      	ldr	r3, [r3, #8]
 80013b8:	4a14      	ldr	r2, [pc, #80]	@ (800140c <__usart1_init+0x8c>)
 80013ba:	f443 1370 	orr.w	r3, r3, #3932160	@ 0x3c0000
 80013be:	6093      	str	r3, [r2, #8]
  // clear the bits in AFR register
  GPIOA->AFR[1] &= ~((0xf << 4) | (0xf << 8));
 80013c0:	4b12      	ldr	r3, [pc, #72]	@ (800140c <__usart1_init+0x8c>)
 80013c2:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80013c4:	4a11      	ldr	r2, [pc, #68]	@ (800140c <__usart1_init+0x8c>)
 80013c6:	f423 637f 	bic.w	r3, r3, #4080	@ 0xff0
 80013ca:	6253      	str	r3, [r2, #36]	@ 0x24
  // set for af7
  GPIOA->AFR[1] |= (7 << 4) | (7 << 8);
 80013cc:	4b0f      	ldr	r3, [pc, #60]	@ (800140c <__usart1_init+0x8c>)
 80013ce:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80013d0:	4a0e      	ldr	r2, [pc, #56]	@ (800140c <__usart1_init+0x8c>)
 80013d2:	f443 63ee 	orr.w	r3, r3, #1904	@ 0x770
 80013d6:	6253      	str	r3, [r2, #36]	@ 0x24

  // set the baud rate (115200 in this case)
  USART1->BRR = 0x08B;
 80013d8:	4b0d      	ldr	r3, [pc, #52]	@ (8001410 <__usart1_init+0x90>)
 80013da:	228b      	movs	r2, #139	@ 0x8b
 80013dc:	609a      	str	r2, [r3, #8]

  // enable usart reciever interrupt;
  USART1->CR1 = USART_CR1_RXNEIE;
 80013de:	4b0c      	ldr	r3, [pc, #48]	@ (8001410 <__usart1_init+0x90>)
 80013e0:	2220      	movs	r2, #32
 80013e2:	60da      	str	r2, [r3, #12]

  NVIC_EnableIRQ (USART1_IRQn);
 80013e4:	2025      	movs	r0, #37	@ 0x25
 80013e6:	f7ff ff89 	bl	80012fc <__NVIC_EnableIRQ>

  // enable transmitter and reciever at the end
  USART1->CR1 |= USART_CR1_RE | USART_CR1_TE;
 80013ea:	4b09      	ldr	r3, [pc, #36]	@ (8001410 <__usart1_init+0x90>)
 80013ec:	68db      	ldr	r3, [r3, #12]
 80013ee:	4a08      	ldr	r2, [pc, #32]	@ (8001410 <__usart1_init+0x90>)
 80013f0:	f043 030c 	orr.w	r3, r3, #12
 80013f4:	60d3      	str	r3, [r2, #12]

  // enable usart
  USART1->CR1 |= USART_CR1_UE;
 80013f6:	4b06      	ldr	r3, [pc, #24]	@ (8001410 <__usart1_init+0x90>)
 80013f8:	68db      	ldr	r3, [r3, #12]
 80013fa:	4a05      	ldr	r2, [pc, #20]	@ (8001410 <__usart1_init+0x90>)
 80013fc:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8001400:	60d3      	str	r3, [r2, #12]

}
 8001402:	bf00      	nop
 8001404:	bd80      	pop	{r7, pc}
 8001406:	bf00      	nop
 8001408:	40023800 	.word	0x40023800
 800140c:	40020000 	.word	0x40020000
 8001410:	40011000 	.word	0x40011000

08001414 <__usart1_print>:

void __usart1_print(const char *msg, uint32_t size) {
 8001414:	b480      	push	{r7}
 8001416:	b085      	sub	sp, #20
 8001418:	af00      	add	r7, sp, #0
 800141a:	6078      	str	r0, [r7, #4]
 800141c:	6039      	str	r1, [r7, #0]

  int i = 0;
 800141e:	2300      	movs	r3, #0
 8001420:	60fb      	str	r3, [r7, #12]
  while (i < size && msg[i] != '\0') {
 8001422:	e00f      	b.n	8001444 <__usart1_print+0x30>
    while (!(USART1->SR & USART_SR_TXE))
 8001424:	bf00      	nop
 8001426:	4b13      	ldr	r3, [pc, #76]	@ (8001474 <__usart1_print+0x60>)
 8001428:	681b      	ldr	r3, [r3, #0]
 800142a:	f003 0380 	and.w	r3, r3, #128	@ 0x80
 800142e:	2b00      	cmp	r3, #0
 8001430:	d0f9      	beq.n	8001426 <__usart1_print+0x12>
      ;
    USART1->DR = msg[i++];
 8001432:	68fb      	ldr	r3, [r7, #12]
 8001434:	1c5a      	adds	r2, r3, #1
 8001436:	60fa      	str	r2, [r7, #12]
 8001438:	461a      	mov	r2, r3
 800143a:	687b      	ldr	r3, [r7, #4]
 800143c:	4413      	add	r3, r2
 800143e:	781a      	ldrb	r2, [r3, #0]
 8001440:	4b0c      	ldr	r3, [pc, #48]	@ (8001474 <__usart1_print+0x60>)
 8001442:	605a      	str	r2, [r3, #4]
  while (i < size && msg[i] != '\0') {
 8001444:	68fb      	ldr	r3, [r7, #12]
 8001446:	683a      	ldr	r2, [r7, #0]
 8001448:	429a      	cmp	r2, r3
 800144a:	d905      	bls.n	8001458 <__usart1_print+0x44>
 800144c:	68fb      	ldr	r3, [r7, #12]
 800144e:	687a      	ldr	r2, [r7, #4]
 8001450:	4413      	add	r3, r2
 8001452:	781b      	ldrb	r3, [r3, #0]
 8001454:	2b00      	cmp	r3, #0
 8001456:	d1e5      	bne.n	8001424 <__usart1_print+0x10>
  }
  while (!(USART1->SR & USART_SR_TC)) {
 8001458:	bf00      	nop
 800145a:	4b06      	ldr	r3, [pc, #24]	@ (8001474 <__usart1_print+0x60>)
 800145c:	681b      	ldr	r3, [r3, #0]
 800145e:	f003 0340 	and.w	r3, r3, #64	@ 0x40
 8001462:	2b00      	cmp	r3, #0
 8001464:	d0f9      	beq.n	800145a <__usart1_print+0x46>
  }
}
 8001466:	bf00      	nop
 8001468:	bf00      	nop
 800146a:	3714      	adds	r7, #20
 800146c:	46bd      	mov	sp, r7
 800146e:	bc80      	pop	{r7}
 8001470:	4770      	bx	lr
 8001472:	bf00      	nop
 8001474:	40011000 	.word	0x40011000

08001478 <Reset_Handler>:
 8001478:	480c      	ldr	r0, [pc, #48]	@ (80014ac <hang+0x4>)
 800147a:	490d      	ldr	r1, [pc, #52]	@ (80014b0 <hang+0x8>)
 800147c:	4a0d      	ldr	r2, [pc, #52]	@ (80014b4 <hang+0xc>)
 800147e:	e7ff      	b.n	8001480 <copy>

08001480 <copy>:
 8001480:	4288      	cmp	r0, r1
 8001482:	db04      	blt.n	800148e <copy_helper>
 8001484:	480c      	ldr	r0, [pc, #48]	@ (80014b8 <hang+0x10>)
 8001486:	490d      	ldr	r1, [pc, #52]	@ (80014bc <hang+0x14>)
 8001488:	f04f 0200 	mov.w	r2, #0
 800148c:	e004      	b.n	8001498 <init_zero>

0800148e <copy_helper>:
 800148e:	f852 3b04 	ldr.w	r3, [r2], #4
 8001492:	f840 3b04 	str.w	r3, [r0], #4
 8001496:	e7f3      	b.n	8001480 <copy>

08001498 <init_zero>:
 8001498:	4288      	cmp	r0, r1
 800149a:	db00      	blt.n	800149e <init_zero_helper>
 800149c:	e002      	b.n	80014a4 <call_entry>

0800149e <init_zero_helper>:
 800149e:	f840 2b04 	str.w	r2, [r0], #4
 80014a2:	e7f9      	b.n	8001498 <init_zero>

080014a4 <call_entry>:
 80014a4:	f7ff bd4e 	b.w	8000f44 <main>

080014a8 <hang>:
 80014a8:	e7fe      	b.n	80014a8 <hang>
 80014aa:	0000      	.short	0x0000
 80014ac:	20000000 	.word	0x20000000
 80014b0:	20000005 	.word	0x20000005
 80014b4:	08001c4f 	.word	0x08001c4f
 80014b8:	20000008 	.word	0x20000008
 80014bc:	20005084 	.word	0x20005084

080014c0 <EXTI15_10_IRQ_handler>:
 80014c0:	f7ff b8e4 	b.w	800068c <switch_pressed>

080014c4 <Default_Handler>:
 80014c4:	e7fe      	b.n	80014c4 <Default_Handler>

080014c6 <BusFault_Handler>:
 80014c6:	f3ef 8008 	mrs	r0, MSP
 80014ca:	6980      	ldr	r0, [r0, #24]
 80014cc:	f04f 0100 	mov.w	r1, #0
 80014d0:	b500      	push	{lr}
 80014d2:	f7fe fe33 	bl	800013c <fault_handler_helper>
 80014d6:	f85d eb04 	ldr.w	lr, [sp], #4
 80014da:	4770      	bx	lr

080014dc <MemManage_Handler>:
 80014dc:	f3ef 8008 	mrs	r0, MSP
 80014e0:	6980      	ldr	r0, [r0, #24]
 80014e2:	f04f 0101 	mov.w	r1, #1
 80014e6:	b500      	push	{lr}
 80014e8:	f7fe fe28 	bl	800013c <fault_handler_helper>
 80014ec:	f85d eb04 	ldr.w	lr, [sp], #4
 80014f0:	4770      	bx	lr

080014f2 <UsageFault_Handler>:
 80014f2:	f3ef 8008 	mrs	r0, MSP
 80014f6:	6980      	ldr	r0, [r0, #24]
 80014f8:	f04f 0102 	mov.w	r1, #2
 80014fc:	b500      	push	{lr}
 80014fe:	f7fe fe1d 	bl	800013c <fault_handler_helper>
 8001502:	f85d eb04 	ldr.w	lr, [sp], #4
 8001506:	4770      	bx	lr

08001508 <HardFault_Handler>:
 8001508:	f3ef 8008 	mrs	r0, MSP
 800150c:	6980      	ldr	r0, [r0, #24]
 800150e:	4904      	ldr	r1, [pc, #16]	@ (8001520 <HardFault_Handler+0x18>)
 8001510:	f381 8808 	msr	MSP, r1
 8001514:	b500      	push	{lr}
 8001516:	f7fe fe73 	bl	8000200 <HardFault_Handler_helper>
 800151a:	f85d eb04 	ldr.w	lr, [sp], #4
 800151e:	e7fe      	b.n	800151e <HardFault_Handler+0x16>
 8001520:	20017000 	.word	0x20017000

08001524 <SVC_Handler>:
 8001524:	e7fe      	b.n	8001524 <SVC_Handler>

08001526 <SysTick_Handler>:
 8001526:	e7fe      	b.n	8001526 <SysTick_Handler>

08001528 <PendSV_Handler>:
 8001528:	e7fe      	b.n	8001528 <PendSV_Handler>

0800152a <NMI_Handler>:
 800152a:	e7fe      	b.n	800152a <NMI_Handler>

0800152c <DebugMon_Handler>:
 800152c:	e7fe      	b.n	800152c <DebugMon_Handler>

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
 8000154:	f000 fb82 	bl	800085c <printf>
    if (SCB->CFSR & SCB_CFSR_BFARVALID_Msk)
 8000158:	4b1f      	ldr	r3, [pc, #124]	@ (80001d8 <fault_handler_helper+0x9c>)
 800015a:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 800015c:	f403 4300 	and.w	r3, r3, #32768	@ 0x8000
 8000160:	2b00      	cmp	r3, #0
 8000162:	d01f      	beq.n	80001a4 <fault_handler_helper+0x68>
      printf("busfault address -> %\n\r", (uint32_t)(&SCB->BFAR));
 8000164:	491d      	ldr	r1, [pc, #116]	@ (80001dc <fault_handler_helper+0xa0>)
 8000166:	481e      	ldr	r0, [pc, #120]	@ (80001e0 <fault_handler_helper+0xa4>)
 8000168:	f000 fb78 	bl	800085c <printf>
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
 8000178:	f000 fb70 	bl	800085c <printf>
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
 8000190:	f000 fb64 	bl	800085c <printf>
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
 80001a0:	f000 fb5c 	bl	800085c <printf>
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
 80001ae:	f000 fb55 	bl	800085c <printf>
         (uint32_t)(&SCB->CFSR));
  printf("PC -> %\n\r", (uint32_t)&pc);
 80001b2:	f107 030c 	add.w	r3, r7, #12
 80001b6:	4619      	mov	r1, r3
 80001b8:	480f      	ldr	r0, [pc, #60]	@ (80001f8 <fault_handler_helper+0xbc>)
 80001ba:	f000 fb4f 	bl	800085c <printf>
  printf("instruction that caused the fault-> %\n\r", (uint32_t)(&instruction));
 80001be:	f107 0314 	add.w	r3, r7, #20
 80001c2:	4619      	mov	r1, r3
 80001c4:	480d      	ldr	r0, [pc, #52]	@ (80001fc <fault_handler_helper+0xc0>)
 80001c6:	f000 fb49 	bl	800085c <printf>


  /* cannot recover */
  while (1);
 80001ca:	e7fe      	b.n	80001ca <fault_handler_helper+0x8e>
    return;
 80001cc:	bf00      	nop


}
 80001ce:	3718      	adds	r7, #24
 80001d0:	46bd      	mov	sp, r7
 80001d2:	bd80      	pop	{r7, pc}
 80001d4:	08001510 	.word	0x08001510
 80001d8:	e000ed00 	.word	0xe000ed00
 80001dc:	e000ed38 	.word	0xe000ed38
 80001e0:	08001520 	.word	0x08001520
 80001e4:	08001538 	.word	0x08001538
 80001e8:	08001558 	.word	0x08001558
 80001ec:	08001580 	.word	0x08001580
 80001f0:	e000ed28 	.word	0xe000ed28
 80001f4:	08001590 	.word	0x08001590
 80001f8:	080015c0 	.word	0x080015c0
 80001fc:	080015cc 	.word	0x080015cc

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
 8000212:	f000 fb23 	bl	800085c <printf>
  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
 8000216:	490b      	ldr	r1, [pc, #44]	@ (8000244 <HardFault_Handler_helper+0x44>)
 8000218:	480b      	ldr	r0, [pc, #44]	@ (8000248 <HardFault_Handler_helper+0x48>)
 800021a:	f000 fb1f 	bl	800085c <printf>
         (uint32_t)(&SCB->CFSR));
  printf("Hard Fault Status Register -> %\n\r", (uint32_t)(&SCB->HFSR));
 800021e:	490b      	ldr	r1, [pc, #44]	@ (800024c <HardFault_Handler_helper+0x4c>)
 8000220:	480b      	ldr	r0, [pc, #44]	@ (8000250 <HardFault_Handler_helper+0x50>)
 8000222:	f000 fb1b 	bl	800085c <printf>
  printf("PC -> %\n\r", (uint32_t)(&pc));
 8000226:	1d3b      	adds	r3, r7, #4
 8000228:	4619      	mov	r1, r3
 800022a:	480a      	ldr	r0, [pc, #40]	@ (8000254 <HardFault_Handler_helper+0x54>)
 800022c:	f000 fb16 	bl	800085c <printf>
  printf("instruction that triggered HardFault -> %\n\r",
 8000230:	f107 030c 	add.w	r3, r7, #12
 8000234:	4619      	mov	r1, r3
 8000236:	4808      	ldr	r0, [pc, #32]	@ (8000258 <HardFault_Handler_helper+0x58>)
 8000238:	f000 fb10 	bl	800085c <printf>
         (uint32_t)&instruction);

  /* cannot recover */
  while (1);
 800023c:	e7fe      	b.n	800023c <HardFault_Handler_helper+0x3c>
 800023e:	bf00      	nop
 8000240:	080015f4 	.word	0x080015f4
 8000244:	e000ed28 	.word	0xe000ed28
 8000248:	08001590 	.word	0x08001590
 800024c:	e000ed2c 	.word	0xe000ed2c
 8000250:	08001608 	.word	0x08001608
 8000254:	080015c0 	.word	0x080015c0
 8000258:	0800162c 	.word	0x0800162c

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
 80002bc:	f000 face 	bl	800085c <printf>

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
 800030c:	f000 faa6 	bl	800085c <printf>
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
 8000364:	08001658 	.word	0x08001658
 8000368:	e000e100 	.word	0xe000e100
 800036c:	20000008 	.word	0x20000008
 8000370:	e000ed00 	.word	0xe000ed00
 8000374:	08001670 	.word	0x08001670
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

08000508 <validate_vtable>:
#include "core.h"
#include <stdint.h>

bool validate_vtable(firmware_t *f) {
 8000508:	b580      	push	{r7, lr}
 800050a:	b08a      	sub	sp, #40	@ 0x28
 800050c:	af00      	add	r7, sp, #0
 800050e:	6078      	str	r0, [r7, #4]

  // vtable end is the next free address
  // check from address ------->    [vtable_start, vtable_end)
  
  // vtable must be 128byte aligned => last 7 bits must be 0 (for stm32f401re)
  if (f->__vtable_address & ((1 << 7) - 1)) {
 8000510:	687b      	ldr	r3, [r7, #4]
 8000512:	695b      	ldr	r3, [r3, #20]
 8000514:	f003 037f 	and.w	r3, r3, #127	@ 0x7f
 8000518:	2b00      	cmp	r3, #0
 800051a:	d005      	beq.n	8000528 <validate_vtable+0x20>
    printf("the vector table is not 128byte aligned !!!\n\r", 0x0);
 800051c:	2100      	movs	r1, #0
 800051e:	4839      	ldr	r0, [pc, #228]	@ (8000604 <validate_vtable+0xfc>)
 8000520:	f000 f99c 	bl	800085c <printf>
    return false;
 8000524:	2300      	movs	r3, #0
 8000526:	e068      	b.n	80005fa <validate_vtable+0xf2>

  // all the "end" addresses are next free address => there should not be any
  // data in the "end" address !! all the addresses must lie in the range
  // [start, end)

  uint32_t RAM_start = 0x20000000;
 8000528:	f04f 5300 	mov.w	r3, #536870912	@ 0x20000000
 800052c:	623b      	str	r3, [r7, #32]
  uint32_t RAM_size = 96 * 1024; // 96kB
 800052e:	f44f 33c0 	mov.w	r3, #98304	@ 0x18000
 8000532:	61fb      	str	r3, [r7, #28]
  uint32_t RAM_end = RAM_start + RAM_size;
 8000534:	6a3a      	ldr	r2, [r7, #32]
 8000536:	69fb      	ldr	r3, [r7, #28]
 8000538:	4413      	add	r3, r2
 800053a:	61bb      	str	r3, [r7, #24]
  uint32_t FLASH_start = f->__vtable_address;
 800053c:	687b      	ldr	r3, [r7, #4]
 800053e:	695b      	ldr	r3, [r3, #20]
 8000540:	617b      	str	r3, [r7, #20]
  uint32_t FLASH_size;
  if (f->__base_address == FIRMWARE_1_ADDRESS)
 8000542:	687b      	ldr	r3, [r7, #4]
 8000544:	681b      	ldr	r3, [r3, #0]
 8000546:	4a30      	ldr	r2, [pc, #192]	@ (8000608 <validate_vtable+0x100>)
 8000548:	4293      	cmp	r3, r2
 800054a:	d103      	bne.n	8000554 <validate_vtable+0x4c>
    FLASH_size = f->__firmware_size;
 800054c:	687b      	ldr	r3, [r7, #4]
 800054e:	69db      	ldr	r3, [r3, #28]
 8000550:	613b      	str	r3, [r7, #16]
 8000552:	e00e      	b.n	8000572 <validate_vtable+0x6a>
  else if (f->__base_address == FIRMWARE_2_ADDRESS)
 8000554:	687b      	ldr	r3, [r7, #4]
 8000556:	681b      	ldr	r3, [r3, #0]
 8000558:	4a2c      	ldr	r2, [pc, #176]	@ (800060c <validate_vtable+0x104>)
 800055a:	4293      	cmp	r3, r2
 800055c:	d103      	bne.n	8000566 <validate_vtable+0x5e>
    FLASH_size = f->__firmware_size;
 800055e:	687b      	ldr	r3, [r7, #4]
 8000560:	69db      	ldr	r3, [r3, #28]
 8000562:	613b      	str	r3, [r7, #16]
 8000564:	e005      	b.n	8000572 <validate_vtable+0x6a>
  else {
    printf("update _base address is not valid\n\r", 0x0);
 8000566:	2100      	movs	r1, #0
 8000568:	4829      	ldr	r0, [pc, #164]	@ (8000610 <validate_vtable+0x108>)
 800056a:	f000 f977 	bl	800085c <printf>
    return false;
 800056e:	2300      	movs	r3, #0
 8000570:	e043      	b.n	80005fa <validate_vtable+0xf2>
  }
  uint32_t FLASH_end = f->__firmware_end;
 8000572:	687b      	ldr	r3, [r7, #4]
 8000574:	699b      	ldr	r3, [r3, #24]
 8000576:	60fb      	str	r3, [r7, #12]

  /*************************msp check*********************/
  
  // MSP value can be RAM end as MSP grows downword;
  if (f->__msp_value > RAM_end || f->__msp_value < RAM_start) {
 8000578:	687b      	ldr	r3, [r7, #4]
 800057a:	6a1b      	ldr	r3, [r3, #32]
 800057c:	69ba      	ldr	r2, [r7, #24]
 800057e:	429a      	cmp	r2, r3
 8000580:	d304      	bcc.n	800058c <validate_vtable+0x84>
 8000582:	687b      	ldr	r3, [r7, #4]
 8000584:	6a1b      	ldr	r3, [r3, #32]
 8000586:	6a3a      	ldr	r2, [r7, #32]
 8000588:	429a      	cmp	r2, r3
 800058a:	d90b      	bls.n	80005a4 <validate_vtable+0x9c>

      printf ("MSP value is -> %\n\r", (uint32_t)(&(f->__msp_value)));
 800058c:	687b      	ldr	r3, [r7, #4]
 800058e:	3320      	adds	r3, #32
 8000590:	4619      	mov	r1, r3
 8000592:	4820      	ldr	r0, [pc, #128]	@ (8000614 <validate_vtable+0x10c>)
 8000594:	f000 f962 	bl	800085c <printf>
    printf("MSP value is invalid\n\r", 0x0);
 8000598:	2100      	movs	r1, #0
 800059a:	481f      	ldr	r0, [pc, #124]	@ (8000618 <validate_vtable+0x110>)
 800059c:	f000 f95e 	bl	800085c <printf>
    return false;
 80005a0:	2300      	movs	r3, #0
 80005a2:	e02a      	b.n	80005fa <validate_vtable+0xf2>
  }
  // msp value must be word aligned !!!
  if (f->__msp_value & 3) {
 80005a4:	687b      	ldr	r3, [r7, #4]
 80005a6:	6a1b      	ldr	r3, [r3, #32]
 80005a8:	f003 0303 	and.w	r3, r3, #3
 80005ac:	2b00      	cmp	r3, #0
 80005ae:	d005      	beq.n	80005bc <validate_vtable+0xb4>
    printf("MSP value is not word aligned\n\r", 0x0);
 80005b0:	2100      	movs	r1, #0
 80005b2:	481a      	ldr	r0, [pc, #104]	@ (800061c <validate_vtable+0x114>)
 80005b4:	f000 f952 	bl	800085c <printf>
    return false;
 80005b8:	2300      	movs	r3, #0
 80005ba:	e01e      	b.n	80005fa <validate_vtable+0xf2>
  }

  /************************ vtable check************************/

  for (uint32_t vtable_entry = f->__vtable_address + 0x4;
 80005bc:	687b      	ldr	r3, [r7, #4]
 80005be:	695b      	ldr	r3, [r3, #20]
 80005c0:	3304      	adds	r3, #4
 80005c2:	627b      	str	r3, [r7, #36]	@ 0x24
 80005c4:	e013      	b.n	80005ee <validate_vtable+0xe6>
       vtable_entry < f->__vtable_end; vtable_entry += 4) {

    uint32_t FLASH_address =
        *((uint32_t *)vtable_entry); // peek inside vtable_entry
 80005c6:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
    uint32_t FLASH_address =
 80005c8:	681b      	ldr	r3, [r3, #0]
 80005ca:	60bb      	str	r3, [r7, #8]
    if (FLASH_address >= FLASH_end || FLASH_address < FLASH_start) {
 80005cc:	68ba      	ldr	r2, [r7, #8]
 80005ce:	68fb      	ldr	r3, [r7, #12]
 80005d0:	429a      	cmp	r2, r3
 80005d2:	d203      	bcs.n	80005dc <validate_vtable+0xd4>
 80005d4:	68ba      	ldr	r2, [r7, #8]
 80005d6:	697b      	ldr	r3, [r7, #20]
 80005d8:	429a      	cmp	r2, r3
 80005da:	d205      	bcs.n	80005e8 <validate_vtable+0xe0>

      printf("% ---- in vtable entry does not exist in the allowed flash "
 80005dc:	6a79      	ldr	r1, [r7, #36]	@ 0x24
 80005de:	4810      	ldr	r0, [pc, #64]	@ (8000620 <validate_vtable+0x118>)
 80005e0:	f000 f93c 	bl	800085c <printf>
             "range\n\r", vtable_entry);
      return false;
 80005e4:	2300      	movs	r3, #0
 80005e6:	e008      	b.n	80005fa <validate_vtable+0xf2>
       vtable_entry < f->__vtable_end; vtable_entry += 4) {
 80005e8:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80005ea:	3304      	adds	r3, #4
 80005ec:	627b      	str	r3, [r7, #36]	@ 0x24
 80005ee:	687b      	ldr	r3, [r7, #4]
 80005f0:	68db      	ldr	r3, [r3, #12]
 80005f2:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
 80005f4:	429a      	cmp	r2, r3
 80005f6:	d3e6      	bcc.n	80005c6 <validate_vtable+0xbe>
    }
  }

  return true;
 80005f8:	2301      	movs	r3, #1
}
 80005fa:	4618      	mov	r0, r3
 80005fc:	3728      	adds	r7, #40	@ 0x28
 80005fe:	46bd      	mov	sp, r7
 8000600:	bd80      	pop	{r7, pc}
 8000602:	bf00      	nop
 8000604:	08001688 	.word	0x08001688
 8000608:	08010000 	.word	0x08010000
 800060c:	08020000 	.word	0x08020000
 8000610:	080016b8 	.word	0x080016b8
 8000614:	080016dc 	.word	0x080016dc
 8000618:	080016f0 	.word	0x080016f0
 800061c:	08001708 	.word	0x08001708
 8000620:	08001728 	.word	0x08001728

08000624 <validate_firmware>:

bool validate_firmware(firmware_t *f) {
 8000624:	b580      	push	{r7, lr}
 8000626:	b084      	sub	sp, #16
 8000628:	af00      	add	r7, sp, #0
 800062a:	6078      	str	r0, [r7, #4]

  if (!validate_vtable(f)) {
 800062c:	6878      	ldr	r0, [r7, #4]
 800062e:	f7ff ff6b 	bl	8000508 <validate_vtable>
 8000632:	4603      	mov	r3, r0
 8000634:	f083 0301 	eor.w	r3, r3, #1
 8000638:	b2db      	uxtb	r3, r3
 800063a:	2b00      	cmp	r3, #0
 800063c:	d005      	beq.n	800064a <validate_firmware+0x26>
    printf("vector table of the update is not valid\n\r", 0x0);
 800063e:	2100      	movs	r1, #0
 8000640:	480f      	ldr	r0, [pc, #60]	@ (8000680 <validate_firmware+0x5c>)
 8000642:	f000 f90b 	bl	800085c <printf>
    return false;
 8000646:	2300      	movs	r3, #0
 8000648:	e016      	b.n	8000678 <validate_firmware+0x54>
  }

  uint32_t crc_result = crc_calc(f);
 800064a:	6878      	ldr	r0, [r7, #4]
 800064c:	f7ff fd4a 	bl	80000e4 <crc_calc>
 8000650:	4603      	mov	r3, r0
 8000652:	60fb      	str	r3, [r7, #12]
  printf("crc value is -> %\n\r", (uint32_t)(&crc_result));
 8000654:	f107 030c 	add.w	r3, r7, #12
 8000658:	4619      	mov	r1, r3
 800065a:	480a      	ldr	r0, [pc, #40]	@ (8000684 <validate_firmware+0x60>)
 800065c:	f000 f8fe 	bl	800085c <printf>
  if (crc_result != f->__crc) {
 8000660:	687b      	ldr	r3, [r7, #4]
 8000662:	689a      	ldr	r2, [r3, #8]
 8000664:	68fb      	ldr	r3, [r7, #12]
 8000666:	429a      	cmp	r2, r3
 8000668:	d005      	beq.n	8000676 <validate_firmware+0x52>
    printf("CRC failed\n\r", 0x0);
 800066a:	2100      	movs	r1, #0
 800066c:	4806      	ldr	r0, [pc, #24]	@ (8000688 <validate_firmware+0x64>)
 800066e:	f000 f8f5 	bl	800085c <printf>
    return false;
 8000672:	2300      	movs	r3, #0
 8000674:	e000      	b.n	8000678 <validate_firmware+0x54>
  }
  return true;
 8000676:	2301      	movs	r3, #1
}
 8000678:	4618      	mov	r0, r3
 800067a:	3710      	adds	r7, #16
 800067c:	46bd      	mov	sp, r7
 800067e:	bd80      	pop	{r7, pc}
 8000680:	0800176c 	.word	0x0800176c
 8000684:	08001798 	.word	0x08001798
 8000688:	080017ac 	.word	0x080017ac

0800068c <switch_pressed>:
extern volatile Ring_buff_t ringbuffer;




void switch_pressed(void){  
 800068c:	b480      	push	{r7}
 800068e:	af00      	add	r7, sp, #0
    // clear the pending status (not done by hardware)
    EXTI-> PR = EXTI_PR_PR13_Msk;
 8000690:	4b0b      	ldr	r3, [pc, #44]	@ (80006c0 <switch_pressed+0x34>)
 8000692:	f44f 5200 	mov.w	r2, #8192	@ 0x2000
 8000696:	615a      	str	r2, [r3, #20]

    press_count++;
 8000698:	4b0a      	ldr	r3, [pc, #40]	@ (80006c4 <switch_pressed+0x38>)
 800069a:	681b      	ldr	r3, [r3, #0]
 800069c:	3301      	adds	r3, #1
 800069e:	4a09      	ldr	r2, [pc, #36]	@ (80006c4 <switch_pressed+0x38>)
 80006a0:	6013      	str	r3, [r2, #0]
    if (press_count == 3){
 80006a2:	4b08      	ldr	r3, [pc, #32]	@ (80006c4 <switch_pressed+0x38>)
 80006a4:	681b      	ldr	r3, [r3, #0]
 80006a6:	2b03      	cmp	r3, #3
 80006a8:	d105      	bne.n	80006b6 <switch_pressed+0x2a>
        delay_count = 100;
 80006aa:	4b07      	ldr	r3, [pc, #28]	@ (80006c8 <switch_pressed+0x3c>)
 80006ac:	2264      	movs	r2, #100	@ 0x64
 80006ae:	601a      	str	r2, [r3, #0]
        recieve_size = true;
 80006b0:	4b06      	ldr	r3, [pc, #24]	@ (80006cc <switch_pressed+0x40>)
 80006b2:	2201      	movs	r2, #1
 80006b4:	701a      	strb	r2, [r3, #0]
        //EXTI-> IMR &= ~EXTI_IMR_MR13_Msk;
    }
}
 80006b6:	bf00      	nop
 80006b8:	46bd      	mov	sp, r7
 80006ba:	bc80      	pop	{r7}
 80006bc:	4770      	bx	lr
 80006be:	bf00      	nop
 80006c0:	40013c00 	.word	0x40013c00
 80006c4:	20000060 	.word	0x20000060
 80006c8:	20000064 	.word	0x20000064
 80006cc:	20005080 	.word	0x20005080

080006d0 <USART1_IRQHandler>:
void USART1_IRQHandler (void){
 80006d0:	b580      	push	{r7, lr}
 80006d2:	b082      	sub	sp, #8
 80006d4:	af00      	add	r7, sp, #0
  if (!firmware_update_mode) return;
 80006d6:	4b26      	ldr	r3, [pc, #152]	@ (8000770 <USART1_IRQHandler+0xa0>)
 80006d8:	781b      	ldrb	r3, [r3, #0]
 80006da:	f083 0301 	eor.w	r3, r3, #1
 80006de:	b2db      	uxtb	r3, r3
 80006e0:	2b00      	cmp	r3, #0
 80006e2:	d141      	bne.n	8000768 <USART1_IRQHandler+0x98>
  if (USART1 -> SR & USART_SR_RXNE_Msk){
 80006e4:	4b23      	ldr	r3, [pc, #140]	@ (8000774 <USART1_IRQHandler+0xa4>)
 80006e6:	681b      	ldr	r3, [r3, #0]
 80006e8:	f003 0320 	and.w	r3, r3, #32
 80006ec:	2b00      	cmp	r3, #0
 80006ee:	d03c      	beq.n	800076a <USART1_IRQHandler+0x9a>
    if (recieve_size){
 80006f0:	4b21      	ldr	r3, [pc, #132]	@ (8000778 <USART1_IRQHandler+0xa8>)
 80006f2:	781b      	ldrb	r3, [r3, #0]
 80006f4:	b2db      	uxtb	r3, r3
 80006f6:	2b00      	cmp	r3, #0
 80006f8:	d02b      	beq.n	8000752 <USART1_IRQHandler+0x82>
      char digit = '\0';
 80006fa:	2300      	movs	r3, #0
 80006fc:	71fb      	strb	r3, [r7, #7]
      digit = USART1-> DR;
 80006fe:	4b1d      	ldr	r3, [pc, #116]	@ (8000774 <USART1_IRQHandler+0xa4>)
 8000700:	685b      	ldr	r3, [r3, #4]
 8000702:	71fb      	strb	r3, [r7, #7]
      if (digit == '\n'){
 8000704:	79fb      	ldrb	r3, [r7, #7]
 8000706:	2b0a      	cmp	r3, #10
 8000708:	d103      	bne.n	8000712 <USART1_IRQHandler+0x42>
        flag_size_recieved = true;
 800070a:	4b1c      	ldr	r3, [pc, #112]	@ (800077c <USART1_IRQHandler+0xac>)
 800070c:	2201      	movs	r2, #1
 800070e:	701a      	strb	r2, [r3, #0]
        return;
 8000710:	e02b      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      if (digit < '0' || digit > '9'){
 8000712:	79fb      	ldrb	r3, [r7, #7]
 8000714:	2b2f      	cmp	r3, #47	@ 0x2f
 8000716:	d902      	bls.n	800071e <USART1_IRQHandler+0x4e>
 8000718:	79fb      	ldrb	r3, [r7, #7]
 800071a:	2b39      	cmp	r3, #57	@ 0x39
 800071c:	d903      	bls.n	8000726 <USART1_IRQHandler+0x56>
        flag_wrong_size = true;
 800071e:	4b18      	ldr	r3, [pc, #96]	@ (8000780 <USART1_IRQHandler+0xb0>)
 8000720:	2201      	movs	r2, #1
 8000722:	701a      	strb	r2, [r3, #0]
        return;
 8000724:	e021      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      if (update_size > 128*1024){
 8000726:	4b17      	ldr	r3, [pc, #92]	@ (8000784 <USART1_IRQHandler+0xb4>)
 8000728:	681b      	ldr	r3, [r3, #0]
 800072a:	f5b3 3f00 	cmp.w	r3, #131072	@ 0x20000
 800072e:	d903      	bls.n	8000738 <USART1_IRQHandler+0x68>
        flag_too_big_update = true;
 8000730:	4b15      	ldr	r3, [pc, #84]	@ (8000788 <USART1_IRQHandler+0xb8>)
 8000732:	2201      	movs	r2, #1
 8000734:	701a      	strb	r2, [r3, #0]
        return;
 8000736:	e018      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      update_size = update_size * 10 + (digit-'0');
 8000738:	4b12      	ldr	r3, [pc, #72]	@ (8000784 <USART1_IRQHandler+0xb4>)
 800073a:	681a      	ldr	r2, [r3, #0]
 800073c:	4613      	mov	r3, r2
 800073e:	009b      	lsls	r3, r3, #2
 8000740:	4413      	add	r3, r2
 8000742:	005b      	lsls	r3, r3, #1
 8000744:	461a      	mov	r2, r3
 8000746:	79fb      	ldrb	r3, [r7, #7]
 8000748:	4413      	add	r3, r2
 800074a:	3b30      	subs	r3, #48	@ 0x30
 800074c:	4a0d      	ldr	r2, [pc, #52]	@ (8000784 <USART1_IRQHandler+0xb4>)
 800074e:	6013      	str	r3, [r2, #0]
 8000750:	e00b      	b.n	800076a <USART1_IRQHandler+0x9a>
    }
    else {
      // if (fw_ar_ind >= update_size)
      //   return;
      // fw_update [fw_ar_ind++] = USART1 -> DR;
      uint8_t data = USART1 -> DR;
 8000752:	4b08      	ldr	r3, [pc, #32]	@ (8000774 <USART1_IRQHandler+0xa4>)
 8000754:	685b      	ldr	r3, [r3, #4]
 8000756:	b2db      	uxtb	r3, r3
 8000758:	71bb      	strb	r3, [r7, #6]
      Ring_buff_write(&ringbuffer, &data, 1);
 800075a:	1dbb      	adds	r3, r7, #6
 800075c:	2201      	movs	r2, #1
 800075e:	4619      	mov	r1, r3
 8000760:	480a      	ldr	r0, [pc, #40]	@ (800078c <USART1_IRQHandler+0xbc>)
 8000762:	f7ff fe5f 	bl	8000424 <Ring_buff_write>
 8000766:	e000      	b.n	800076a <USART1_IRQHandler+0x9a>
  if (!firmware_update_mode) return;
 8000768:	bf00      	nop
    }
  }
}
 800076a:	3708      	adds	r7, #8
 800076c:	46bd      	mov	sp, r7
 800076e:	bd80      	pop	{r7, pc}
 8000770:	2000507e 	.word	0x2000507e
 8000774:	40011000 	.word	0x40011000
 8000778:	20005080 	.word	0x20005080
 800077c:	20005081 	.word	0x20005081
 8000780:	20005082 	.word	0x20005082
 8000784:	20000074 	.word	0x20000074
 8000788:	20005083 	.word	0x20005083
 800078c:	20000078 	.word	0x20000078

08000790 <strlen>:
uint32_t update_section_end_address = UPDATE_ADDR;
extern volatile Ring_buff_t ringbuffer;
extern uint8_t write_buffer[WRITE_BUFF_SIZE];
volatile uint32_t fw_ar_ind = 0;

uint32_t strlen(const char *msg) {
 8000790:	b480      	push	{r7}
 8000792:	b085      	sub	sp, #20
 8000794:	af00      	add	r7, sp, #0
 8000796:	6078      	str	r0, [r7, #4]

  int i = 0;
 8000798:	2300      	movs	r3, #0
 800079a:	60fb      	str	r3, [r7, #12]
  while (msg[i++] != '\0')
 800079c:	bf00      	nop
 800079e:	68fb      	ldr	r3, [r7, #12]
 80007a0:	1c5a      	adds	r2, r3, #1
 80007a2:	60fa      	str	r2, [r7, #12]
 80007a4:	461a      	mov	r2, r3
 80007a6:	687b      	ldr	r3, [r7, #4]
 80007a8:	4413      	add	r3, r2
 80007aa:	781b      	ldrb	r3, [r3, #0]
 80007ac:	2b00      	cmp	r3, #0
 80007ae:	d1f6      	bne.n	800079e <strlen+0xe>
    ;
  return i - 1;
 80007b0:	68fb      	ldr	r3, [r7, #12]
 80007b2:	3b01      	subs	r3, #1
}
 80007b4:	4618      	mov	r0, r3
 80007b6:	3714      	adds	r7, #20
 80007b8:	46bd      	mov	sp, r7
 80007ba:	bc80      	pop	{r7}
 80007bc:	4770      	bx	lr

080007be <delay>:

void delay(uint32_t count) {
 80007be:	b480      	push	{r7}
 80007c0:	b083      	sub	sp, #12
 80007c2:	af00      	add	r7, sp, #0
 80007c4:	6078      	str	r0, [r7, #4]

  while (count--)
 80007c6:	bf00      	nop
 80007c8:	687b      	ldr	r3, [r7, #4]
 80007ca:	1e5a      	subs	r2, r3, #1
 80007cc:	607a      	str	r2, [r7, #4]
 80007ce:	2b00      	cmp	r3, #0
 80007d0:	d1fa      	bne.n	80007c8 <delay+0xa>
    ;
}
 80007d2:	bf00      	nop
 80007d4:	bf00      	nop
 80007d6:	370c      	adds	r7, #12
 80007d8:	46bd      	mov	sp, r7
 80007da:	bc80      	pop	{r7}
 80007dc:	4770      	bx	lr

080007de <hex_str>:
char *hex_str(uint32_t value, char *out) {
 80007de:	b4b0      	push	{r4, r5, r7}
 80007e0:	b08b      	sub	sp, #44	@ 0x2c
 80007e2:	af00      	add	r7, sp, #0
 80007e4:	6078      	str	r0, [r7, #4]
 80007e6:	6039      	str	r1, [r7, #0]

  char hex_char[] = "0123456789abcdef";
 80007e8:	4b1b      	ldr	r3, [pc, #108]	@ (8000858 <hex_str+0x7a>)
 80007ea:	f107 0408 	add.w	r4, r7, #8
 80007ee:	461d      	mov	r5, r3
 80007f0:	cd0f      	ldmia	r5!, {r0, r1, r2, r3}
 80007f2:	c40f      	stmia	r4!, {r0, r1, r2, r3}
 80007f4:	682b      	ldr	r3, [r5, #0]
 80007f6:	7023      	strb	r3, [r4, #0]
  out[0] = '0';
 80007f8:	683b      	ldr	r3, [r7, #0]
 80007fa:	2230      	movs	r2, #48	@ 0x30
 80007fc:	701a      	strb	r2, [r3, #0]
  out[1] = 'x';
 80007fe:	683b      	ldr	r3, [r7, #0]
 8000800:	3301      	adds	r3, #1
 8000802:	2278      	movs	r2, #120	@ 0x78
 8000804:	701a      	strb	r2, [r3, #0]

  for (int i = 0; i < 8; i++) {
 8000806:	2300      	movs	r3, #0
 8000808:	627b      	str	r3, [r7, #36]	@ 0x24
 800080a:	e01c      	b.n	8000846 <hex_str+0x68>
    uint32_t ind = (value & (15 << (i * 4))) >> (i * 4);
 800080c:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800080e:	009b      	lsls	r3, r3, #2
 8000810:	220f      	movs	r2, #15
 8000812:	fa02 f303 	lsl.w	r3, r2, r3
 8000816:	461a      	mov	r2, r3
 8000818:	687b      	ldr	r3, [r7, #4]
 800081a:	401a      	ands	r2, r3
 800081c:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800081e:	009b      	lsls	r3, r3, #2
 8000820:	fa22 f303 	lsr.w	r3, r2, r3
 8000824:	623b      	str	r3, [r7, #32]
    int j = 9 - i;
 8000826:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000828:	f1c3 0309 	rsb	r3, r3, #9
 800082c:	61fb      	str	r3, [r7, #28]
    out[j] = hex_char[ind];
 800082e:	69fb      	ldr	r3, [r7, #28]
 8000830:	683a      	ldr	r2, [r7, #0]
 8000832:	4413      	add	r3, r2
 8000834:	f107 0108 	add.w	r1, r7, #8
 8000838:	6a3a      	ldr	r2, [r7, #32]
 800083a:	440a      	add	r2, r1
 800083c:	7812      	ldrb	r2, [r2, #0]
 800083e:	701a      	strb	r2, [r3, #0]
  for (int i = 0; i < 8; i++) {
 8000840:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000842:	3301      	adds	r3, #1
 8000844:	627b      	str	r3, [r7, #36]	@ 0x24
 8000846:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000848:	2b07      	cmp	r3, #7
 800084a:	dddf      	ble.n	800080c <hex_str+0x2e>
  }
}
 800084c:	bf00      	nop
 800084e:	4618      	mov	r0, r3
 8000850:	372c      	adds	r7, #44	@ 0x2c
 8000852:	46bd      	mov	sp, r7
 8000854:	bcb0      	pop	{r4, r5, r7}
 8000856:	4770      	bx	lr
 8000858:	080017bc 	.word	0x080017bc

0800085c <printf>:

void printf(const char *msg, uint32_t address) {
 800085c:	b580      	push	{r7, lr}
 800085e:	b0a4      	sub	sp, #144	@ 0x90
 8000860:	af00      	add	r7, sp, #0
 8000862:	6078      	str	r0, [r7, #4]
 8000864:	6039      	str	r1, [r7, #0]

  uint32_t value = *((uint32_t *)address);
 8000866:	683b      	ldr	r3, [r7, #0]
 8000868:	681b      	ldr	r3, [r3, #0]
 800086a:	67fb      	str	r3, [r7, #124]	@ 0x7c

  if (strlen(msg) + 9 > MAX_STR_SIZE) {
 800086c:	6878      	ldr	r0, [r7, #4]
 800086e:	f7ff ff8f 	bl	8000790 <strlen>
 8000872:	4603      	mov	r3, r0
 8000874:	3309      	adds	r3, #9
 8000876:	2b64      	cmp	r3, #100	@ 0x64
 8000878:	d904      	bls.n	8000884 <printf+0x28>
    __usart1_print("too large error message !!\n\r", MAX_STR_SIZE);
 800087a:	2164      	movs	r1, #100	@ 0x64
 800087c:	483e      	ldr	r0, [pc, #248]	@ (8000978 <printf+0x11c>)
 800087e:	f000 fdb9 	bl	80013f4 <__usart1_print>
 8000882:	e076      	b.n	8000972 <printf+0x116>
    return;
  }
  char hex[10];
  char __msg[MAX_STR_SIZE];

  uint32_t i = 0;
 8000884:	2300      	movs	r3, #0
 8000886:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
  int p = 0, q = 0;
 800088a:	2300      	movs	r3, #0
 800088c:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
 8000890:	2300      	movs	r3, #0
 8000892:	f8c7 3084 	str.w	r3, [r7, #132]	@ 0x84
  bool single_sub = false;
 8000896:	2300      	movs	r3, #0
 8000898:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83

  uint32_t msg_size = strlen(msg);
 800089c:	6878      	ldr	r0, [r7, #4]
 800089e:	f7ff ff77 	bl	8000790 <strlen>
 80008a2:	67b8      	str	r0, [r7, #120]	@ 0x78
  for (; i < msg_size; i++) {
 80008a4:	e04d      	b.n	8000942 <printf+0xe6>

    if (msg[i] == '%' && !single_sub) {
 80008a6:	687a      	ldr	r2, [r7, #4]
 80008a8:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 80008ac:	4413      	add	r3, r2
 80008ae:	781b      	ldrb	r3, [r3, #0]
 80008b0:	2b25      	cmp	r3, #37	@ 0x25
 80008b2:	d12f      	bne.n	8000914 <printf+0xb8>
 80008b4:	f897 3083 	ldrb.w	r3, [r7, #131]	@ 0x83
 80008b8:	f083 0301 	eor.w	r3, r3, #1
 80008bc:	b2db      	uxtb	r3, r3
 80008be:	2b00      	cmp	r3, #0
 80008c0:	d028      	beq.n	8000914 <printf+0xb8>
      hex_str(value, hex);
 80008c2:	f107 036c 	add.w	r3, r7, #108	@ 0x6c
 80008c6:	4619      	mov	r1, r3
 80008c8:	6ff8      	ldr	r0, [r7, #124]	@ 0x7c
 80008ca:	f7ff ff88 	bl	80007de <hex_str>

      while (q - p < 10) {
 80008ce:	e011      	b.n	80008f4 <printf+0x98>
        __msg[q++] = hex[q - p];
 80008d0:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 80008d4:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 80008d8:	1ad2      	subs	r2, r2, r3
 80008da:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 80008de:	1c59      	adds	r1, r3, #1
 80008e0:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 80008e4:	3290      	adds	r2, #144	@ 0x90
 80008e6:	443a      	add	r2, r7
 80008e8:	f812 2c24 	ldrb.w	r2, [r2, #-36]
 80008ec:	3390      	adds	r3, #144	@ 0x90
 80008ee:	443b      	add	r3, r7
 80008f0:	f803 2c88 	strb.w	r2, [r3, #-136]
      while (q - p < 10) {
 80008f4:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 80008f8:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 80008fc:	1ad3      	subs	r3, r2, r3
 80008fe:	2b09      	cmp	r3, #9
 8000900:	dde6      	ble.n	80008d0 <printf+0x74>
      }
      p++;
 8000902:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000906:	3301      	adds	r3, #1
 8000908:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
      single_sub = true;
 800090c:	2301      	movs	r3, #1
 800090e:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83
 8000912:	e011      	b.n	8000938 <printf+0xdc>
    } else
      __msg[q++] = msg[p++];
 8000914:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000918:	1c5a      	adds	r2, r3, #1
 800091a:	f8c7 2088 	str.w	r2, [r7, #136]	@ 0x88
 800091e:	461a      	mov	r2, r3
 8000920:	687b      	ldr	r3, [r7, #4]
 8000922:	441a      	add	r2, r3
 8000924:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000928:	1c59      	adds	r1, r3, #1
 800092a:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 800092e:	7812      	ldrb	r2, [r2, #0]
 8000930:	3390      	adds	r3, #144	@ 0x90
 8000932:	443b      	add	r3, r7
 8000934:	f803 2c88 	strb.w	r2, [r3, #-136]
  for (; i < msg_size; i++) {
 8000938:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 800093c:	3301      	adds	r3, #1
 800093e:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
 8000942:	f8d7 208c 	ldr.w	r2, [r7, #140]	@ 0x8c
 8000946:	6fbb      	ldr	r3, [r7, #120]	@ 0x78
 8000948:	429a      	cmp	r2, r3
 800094a:	d3ac      	bcc.n	80008a6 <printf+0x4a>
  }
  __msg[q] = '\0';
 800094c:	f107 0208 	add.w	r2, r7, #8
 8000950:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000954:	4413      	add	r3, r2
 8000956:	2200      	movs	r2, #0
 8000958:	701a      	strb	r2, [r3, #0]
  __usart1_print(__msg, strlen(__msg));
 800095a:	f107 0308 	add.w	r3, r7, #8
 800095e:	4618      	mov	r0, r3
 8000960:	f7ff ff16 	bl	8000790 <strlen>
 8000964:	4602      	mov	r2, r0
 8000966:	f107 0308 	add.w	r3, r7, #8
 800096a:	4611      	mov	r1, r2
 800096c:	4618      	mov	r0, r3
 800096e:	f000 fd41 	bl	80013f4 <__usart1_print>
}
 8000972:	3790      	adds	r7, #144	@ 0x90
 8000974:	46bd      	mov	sp, r7
 8000976:	bd80      	pop	{r7, pc}
 8000978:	080017d0 	.word	0x080017d0

0800097c <recieve_update>:
//   }
//   printf("data recieved !!! yehhhh \n\n\r", 0x0);
//   return 0;
// }

uint32_t recieve_update(void) {
 800097c:	b580      	push	{r7, lr}
 800097e:	b082      	sub	sp, #8
 8000980:	af00      	add	r7, sp, #0

  // recieve update size

  printf("enter the size of the update....\n\r", 0x0);
 8000982:	2100      	movs	r1, #0
 8000984:	483e      	ldr	r0, [pc, #248]	@ (8000a80 <recieve_update+0x104>)
 8000986:	f7ff ff69 	bl	800085c <printf>

  recieve_size = true;
 800098a:	4b3e      	ldr	r3, [pc, #248]	@ (8000a84 <recieve_update+0x108>)
 800098c:	2201      	movs	r2, #1
 800098e:	701a      	strb	r2, [r3, #0]
  while (1) {
    if (flag_wrong_size) {
 8000990:	4b3d      	ldr	r3, [pc, #244]	@ (8000a88 <recieve_update+0x10c>)
 8000992:	781b      	ldrb	r3, [r3, #0]
 8000994:	b2db      	uxtb	r3, r3
 8000996:	2b00      	cmp	r3, #0
 8000998:	d006      	beq.n	80009a8 <recieve_update+0x2c>
      printf("wrong size entered !!!\n\r", 0x0);
 800099a:	2100      	movs	r1, #0
 800099c:	483b      	ldr	r0, [pc, #236]	@ (8000a8c <recieve_update+0x110>)
 800099e:	f7ff ff5d 	bl	800085c <printf>
      return -1;
 80009a2:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80009a6:	e066      	b.n	8000a76 <recieve_update+0xfa>
    }
    if (flag_too_big_update) {
 80009a8:	4b39      	ldr	r3, [pc, #228]	@ (8000a90 <recieve_update+0x114>)
 80009aa:	781b      	ldrb	r3, [r3, #0]
 80009ac:	b2db      	uxtb	r3, r3
 80009ae:	2b00      	cmp	r3, #0
 80009b0:	d006      	beq.n	80009c0 <recieve_update+0x44>
      printf("update size cannot exceed 128KB \n\r", 0x0);
 80009b2:	2100      	movs	r1, #0
 80009b4:	4837      	ldr	r0, [pc, #220]	@ (8000a94 <recieve_update+0x118>)
 80009b6:	f7ff ff51 	bl	800085c <printf>
      return -1;
 80009ba:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80009be:	e05a      	b.n	8000a76 <recieve_update+0xfa>
    }
    if (flag_size_recieved) {
 80009c0:	4b35      	ldr	r3, [pc, #212]	@ (8000a98 <recieve_update+0x11c>)
 80009c2:	781b      	ldrb	r3, [r3, #0]
 80009c4:	b2db      	uxtb	r3, r3
 80009c6:	2b00      	cmp	r3, #0
 80009c8:	d0e2      	beq.n	8000990 <recieve_update+0x14>
      printf("update size recieved \n\r", 0x0);
 80009ca:	2100      	movs	r1, #0
 80009cc:	4833      	ldr	r0, [pc, #204]	@ (8000a9c <recieve_update+0x120>)
 80009ce:	f7ff ff45 	bl	800085c <printf>
      break;
 80009d2:	bf00      	nop
    }
  }
  recieve_size = false;
 80009d4:	4b2b      	ldr	r3, [pc, #172]	@ (8000a84 <recieve_update+0x108>)
 80009d6:	2200      	movs	r2, #0
 80009d8:	701a      	strb	r2, [r3, #0]

  // recieve firmware update !!
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 80009da:	e041      	b.n	8000a60 <recieve_update+0xe4>
    while (Ring_buff_empty(&ringbuffer))
 80009dc:	bf00      	nop
 80009de:	4830      	ldr	r0, [pc, #192]	@ (8000aa0 <recieve_update+0x124>)
 80009e0:	f7ff fce1 	bl	80003a6 <Ring_buff_empty>
 80009e4:	4603      	mov	r3, r0
 80009e6:	2b00      	cmp	r3, #0
 80009e8:	d1f9      	bne.n	80009de <recieve_update+0x62>
      ;
    //
    // problem
    uint16_t read_size = Ring_buff_read(&ringbuffer, write_buffer + wb_size,
 80009ea:	4b2e      	ldr	r3, [pc, #184]	@ (8000aa4 <recieve_update+0x128>)
 80009ec:	881b      	ldrh	r3, [r3, #0]
 80009ee:	461a      	mov	r2, r3
 80009f0:	4b2d      	ldr	r3, [pc, #180]	@ (8000aa8 <recieve_update+0x12c>)
 80009f2:	18d1      	adds	r1, r2, r3
 80009f4:	4b2b      	ldr	r3, [pc, #172]	@ (8000aa4 <recieve_update+0x128>)
 80009f6:	881b      	ldrh	r3, [r3, #0]
 80009f8:	f5c3 5320 	rsb	r3, r3, #10240	@ 0x2800
 80009fc:	b29b      	uxth	r3, r3
 80009fe:	461a      	mov	r2, r3
 8000a00:	4827      	ldr	r0, [pc, #156]	@ (8000aa0 <recieve_update+0x124>)
 8000a02:	f7ff fd42 	bl	800048a <Ring_buff_read>
 8000a06:	4603      	mov	r3, r0
 8000a08:	80fb      	strh	r3, [r7, #6]
                                        WRITE_BUFF_SIZE - wb_size);
    wb_size += read_size;
 8000a0a:	4b26      	ldr	r3, [pc, #152]	@ (8000aa4 <recieve_update+0x128>)
 8000a0c:	881a      	ldrh	r2, [r3, #0]
 8000a0e:	88fb      	ldrh	r3, [r7, #6]
 8000a10:	4413      	add	r3, r2
 8000a12:	b29a      	uxth	r2, r3
 8000a14:	4b23      	ldr	r3, [pc, #140]	@ (8000aa4 <recieve_update+0x128>)
 8000a16:	801a      	strh	r2, [r3, #0]

    uint16_t update_in_flash_size = update_section_end_address - UPDATE_ADDR;
 8000a18:	4b24      	ldr	r3, [pc, #144]	@ (8000aac <recieve_update+0x130>)
 8000a1a:	681b      	ldr	r3, [r3, #0]
 8000a1c:	80bb      	strh	r3, [r7, #4]
    //
    if (wb_size == WRITE_BUFF_SIZE ||
 8000a1e:	4b21      	ldr	r3, [pc, #132]	@ (8000aa4 <recieve_update+0x128>)
 8000a20:	881b      	ldrh	r3, [r3, #0]
 8000a22:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 8000a26:	d007      	beq.n	8000a38 <recieve_update+0xbc>
        update_size - update_in_flash_size == wb_size) {
 8000a28:	4b21      	ldr	r3, [pc, #132]	@ (8000ab0 <recieve_update+0x134>)
 8000a2a:	681a      	ldr	r2, [r3, #0]
 8000a2c:	88bb      	ldrh	r3, [r7, #4]
 8000a2e:	1ad3      	subs	r3, r2, r3
 8000a30:	4a1c      	ldr	r2, [pc, #112]	@ (8000aa4 <recieve_update+0x128>)
 8000a32:	8812      	ldrh	r2, [r2, #0]
    if (wb_size == WRITE_BUFF_SIZE ||
 8000a34:	4293      	cmp	r3, r2
 8000a36:	d113      	bne.n	8000a60 <recieve_update+0xe4>
      // flash write, update end address, wb flush

      flash_write(update_section_end_address, write_buffer, wb_size, 0);
 8000a38:	4b1c      	ldr	r3, [pc, #112]	@ (8000aac <recieve_update+0x130>)
 8000a3a:	6818      	ldr	r0, [r3, #0]
 8000a3c:	4b19      	ldr	r3, [pc, #100]	@ (8000aa4 <recieve_update+0x128>)
 8000a3e:	881b      	ldrh	r3, [r3, #0]
 8000a40:	461a      	mov	r2, r3
 8000a42:	2300      	movs	r3, #0
 8000a44:	4918      	ldr	r1, [pc, #96]	@ (8000aa8 <recieve_update+0x12c>)
 8000a46:	f000 fbef 	bl	8001228 <flash_write>

      update_section_end_address += wb_size;
 8000a4a:	4b16      	ldr	r3, [pc, #88]	@ (8000aa4 <recieve_update+0x128>)
 8000a4c:	881b      	ldrh	r3, [r3, #0]
 8000a4e:	461a      	mov	r2, r3
 8000a50:	4b16      	ldr	r3, [pc, #88]	@ (8000aac <recieve_update+0x130>)
 8000a52:	681b      	ldr	r3, [r3, #0]
 8000a54:	4413      	add	r3, r2
 8000a56:	4a15      	ldr	r2, [pc, #84]	@ (8000aac <recieve_update+0x130>)
 8000a58:	6013      	str	r3, [r2, #0]
      wb_size = 0;
 8000a5a:	4b12      	ldr	r3, [pc, #72]	@ (8000aa4 <recieve_update+0x128>)
 8000a5c:	2200      	movs	r2, #0
 8000a5e:	801a      	strh	r2, [r3, #0]
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 8000a60:	4b12      	ldr	r3, [pc, #72]	@ (8000aac <recieve_update+0x130>)
 8000a62:	681b      	ldr	r3, [r3, #0]
 8000a64:	f103 4377 	add.w	r3, r3, #4143972352	@ 0xf7000000
 8000a68:	f503 037c 	add.w	r3, r3, #16515072	@ 0xfc0000
 8000a6c:	4a10      	ldr	r2, [pc, #64]	@ (8000ab0 <recieve_update+0x134>)
 8000a6e:	6812      	ldr	r2, [r2, #0]
 8000a70:	4293      	cmp	r3, r2
 8000a72:	d3b3      	bcc.n	80009dc <recieve_update+0x60>
    }
  }

  // while (fw_ar_ind < update_size);

  return 0;
 8000a74:	2300      	movs	r3, #0
}
 8000a76:	4618      	mov	r0, r3
 8000a78:	3708      	adds	r7, #8
 8000a7a:	46bd      	mov	sp, r7
 8000a7c:	bd80      	pop	{r7, pc}
 8000a7e:	bf00      	nop
 8000a80:	080017f0 	.word	0x080017f0
 8000a84:	20005080 	.word	0x20005080
 8000a88:	20005082 	.word	0x20005082
 8000a8c:	08001814 	.word	0x08001814
 8000a90:	20005083 	.word	0x20005083
 8000a94:	08001830 	.word	0x08001830
 8000a98:	20005081 	.word	0x20005081
 8000a9c:	08001854 	.word	0x08001854
 8000aa0:	20000078 	.word	0x20000078
 8000aa4:	2000507c 	.word	0x2000507c
 8000aa8:	2000287c 	.word	0x2000287c
 8000aac:	20000000 	.word	0x20000000
 8000ab0:	20000074 	.word	0x20000074

08000ab4 <rollback>:

void rollback(void) {
 8000ab4:	b580      	push	{r7, lr}
 8000ab6:	b08e      	sub	sp, #56	@ 0x38
 8000ab8:	af00      	add	r7, sp, #0

  firmware_t old_f;
  // old firmware is present in the COPY_ADDR section
  init_firmware_t(COPY_ADDR, &old_f);
 8000aba:	f107 0308 	add.w	r3, r7, #8
 8000abe:	4619      	mov	r1, r3
 8000ac0:	4819      	ldr	r0, [pc, #100]	@ (8000b28 <rollback+0x74>)
 8000ac2:	f000 f85d 	bl	8000b80 <init_firmware_t>

  printf("startign rollback\n\n\r", 0x0);
 8000ac6:	2100      	movs	r1, #0
 8000ac8:	4818      	ldr	r0, [pc, #96]	@ (8000b2c <rollback+0x78>)
 8000aca:	f7ff fec7 	bl	800085c <printf>
  erase_flash(old_f.__base_address);
 8000ace:	68bb      	ldr	r3, [r7, #8]
 8000ad0:	4618      	mov	r0, r3
 8000ad2:	f000 faef 	bl	80010b4 <erase_flash>
  printf("corupted firmware is erased\n\r", 0x0);
 8000ad6:	2100      	movs	r1, #0
 8000ad8:	4815      	ldr	r0, [pc, #84]	@ (8000b30 <rollback+0x7c>)
 8000ada:	f7ff febf 	bl	800085c <printf>

  uint32_t copy_size =
      (*(uint32_t *)(COPY_ADDR + 0x14)) - (*(uint32_t *)(COPY_ADDR + 0x0c));
 8000ade:	4b15      	ldr	r3, [pc, #84]	@ (8000b34 <rollback+0x80>)
 8000ae0:	681a      	ldr	r2, [r3, #0]
 8000ae2:	4b15      	ldr	r3, [pc, #84]	@ (8000b38 <rollback+0x84>)
 8000ae4:	681b      	ldr	r3, [r3, #0]
  uint32_t copy_size =
 8000ae6:	1ad3      	subs	r3, r2, r3
 8000ae8:	637b      	str	r3, [r7, #52]	@ 0x34
  flash_write(old_f.__base_address + 0x04, (const char *)(COPY_ADDR + 0x04),
 8000aea:	68bb      	ldr	r3, [r7, #8]
 8000aec:	1d18      	adds	r0, r3, #4
 8000aee:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000af0:	1f1a      	subs	r2, r3, #4
 8000af2:	2300      	movs	r3, #0
 8000af4:	4911      	ldr	r1, [pc, #68]	@ (8000b3c <rollback+0x88>)
 8000af6:	f000 fb97 	bl	8001228 <flash_write>
              copy_size - 0x04, NO_DELAY);

  // word write => size would be 4 (not 2)
  const uint32_t end = 0xfffffffe;
 8000afa:	f06f 0301 	mvn.w	r3, #1
 8000afe:	607b      	str	r3, [r7, #4]
  // &end is of type -> uint32_t * ==> need type conversion
  flash_write(old_f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000b00:	68b8      	ldr	r0, [r7, #8]
 8000b02:	1d39      	adds	r1, r7, #4
 8000b04:	2300      	movs	r3, #0
 8000b06:	2204      	movs	r2, #4
 8000b08:	f000 fb8e 	bl	8001228 <flash_write>
  printf("new flag = %\n\r", old_f.__base_address);
 8000b0c:	68bb      	ldr	r3, [r7, #8]
 8000b0e:	4619      	mov	r1, r3
 8000b10:	480b      	ldr	r0, [pc, #44]	@ (8000b40 <rollback+0x8c>)
 8000b12:	f7ff fea3 	bl	800085c <printf>

  printf("done recovering old firmware \n\r", 0x0);
 8000b16:	2100      	movs	r1, #0
 8000b18:	480a      	ldr	r0, [pc, #40]	@ (8000b44 <rollback+0x90>)
 8000b1a:	f7ff fe9f 	bl	800085c <printf>
}
 8000b1e:	bf00      	nop
 8000b20:	3738      	adds	r7, #56	@ 0x38
 8000b22:	46bd      	mov	sp, r7
 8000b24:	bd80      	pop	{r7, pc}
 8000b26:	bf00      	nop
 8000b28:	08060000 	.word	0x08060000
 8000b2c:	0800186c 	.word	0x0800186c
 8000b30:	08001884 	.word	0x08001884
 8000b34:	08060014 	.word	0x08060014
 8000b38:	0806000c 	.word	0x0806000c
 8000b3c:	08060004 	.word	0x08060004
 8000b40:	080018a4 	.word	0x080018a4
 8000b44:	080018b4 	.word	0x080018b4

08000b48 <__NVIC_EnableIRQ>:
{
 8000b48:	b480      	push	{r7}
 8000b4a:	b083      	sub	sp, #12
 8000b4c:	af00      	add	r7, sp, #0
 8000b4e:	4603      	mov	r3, r0
 8000b50:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 8000b52:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000b56:	2b00      	cmp	r3, #0
 8000b58:	db0b      	blt.n	8000b72 <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 8000b5a:	79fb      	ldrb	r3, [r7, #7]
 8000b5c:	f003 021f 	and.w	r2, r3, #31
 8000b60:	4906      	ldr	r1, [pc, #24]	@ (8000b7c <__NVIC_EnableIRQ+0x34>)
 8000b62:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000b66:	095b      	lsrs	r3, r3, #5
 8000b68:	2001      	movs	r0, #1
 8000b6a:	fa00 f202 	lsl.w	r2, r0, r2
 8000b6e:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 8000b72:	bf00      	nop
 8000b74:	370c      	adds	r7, #12
 8000b76:	46bd      	mov	sp, r7
 8000b78:	bc80      	pop	{r7}
 8000b7a:	4770      	bx	lr
 8000b7c:	e000e100 	.word	0xe000e100

08000b80 <init_firmware_t>:
volatile bool flag_size_recieved = false;
volatile bool flag_wrong_size = false;
volatile bool flag_too_big_update = false;


void init_firmware_t(uint32_t address, firmware_t *f) {
 8000b80:	b480      	push	{r7}
 8000b82:	b083      	sub	sp, #12
 8000b84:	af00      	add	r7, sp, #0
 8000b86:	6078      	str	r0, [r7, #4]
 8000b88:	6039      	str	r1, [r7, #0]
  f->__flag = *(volatile uint32_t *)(address + 0x00);
 8000b8a:	687b      	ldr	r3, [r7, #4]
 8000b8c:	681a      	ldr	r2, [r3, #0]
 8000b8e:	683b      	ldr	r3, [r7, #0]
 8000b90:	605a      	str	r2, [r3, #4]
  f->__crc = *((volatile uint32_t *)(address + 0x04));
 8000b92:	687b      	ldr	r3, [r7, #4]
 8000b94:	3304      	adds	r3, #4
 8000b96:	681a      	ldr	r2, [r3, #0]
 8000b98:	683b      	ldr	r3, [r7, #0]
 8000b9a:	609a      	str	r2, [r3, #8]
  f->__vtable_end = *((volatile uint32_t *)(address + 0x08));
 8000b9c:	687b      	ldr	r3, [r7, #4]
 8000b9e:	3308      	adds	r3, #8
 8000ba0:	681a      	ldr	r2, [r3, #0]
 8000ba2:	683b      	ldr	r3, [r7, #0]
 8000ba4:	60da      	str	r2, [r3, #12]
  f->__base_address = *((volatile uint32_t *)(address + 0x0c));
 8000ba6:	687b      	ldr	r3, [r7, #4]
 8000ba8:	330c      	adds	r3, #12
 8000baa:	681a      	ldr	r2, [r3, #0]
 8000bac:	683b      	ldr	r3, [r7, #0]
 8000bae:	601a      	str	r2, [r3, #0]
  f->__vtable_address = *((volatile uint32_t *)(address + 0x10));
 8000bb0:	687b      	ldr	r3, [r7, #4]
 8000bb2:	3310      	adds	r3, #16
 8000bb4:	681a      	ldr	r2, [r3, #0]
 8000bb6:	683b      	ldr	r3, [r7, #0]
 8000bb8:	615a      	str	r2, [r3, #20]
  f->__firmware_end = *((volatile uint32_t *)(address + 0x14));
 8000bba:	687b      	ldr	r3, [r7, #4]
 8000bbc:	3314      	adds	r3, #20
 8000bbe:	681a      	ldr	r2, [r3, #0]
 8000bc0:	683b      	ldr	r3, [r7, #0]
 8000bc2:	619a      	str	r2, [r3, #24]
  f->__firmware_size = f->__firmware_end - f->__base_address;
 8000bc4:	683b      	ldr	r3, [r7, #0]
 8000bc6:	699a      	ldr	r2, [r3, #24]
 8000bc8:	683b      	ldr	r3, [r7, #0]
 8000bca:	681b      	ldr	r3, [r3, #0]
 8000bcc:	1ad2      	subs	r2, r2, r3
 8000bce:	683b      	ldr	r3, [r7, #0]
 8000bd0:	61da      	str	r2, [r3, #28]
  f->__crc_start_addr = address + 0x08;
 8000bd2:	687b      	ldr	r3, [r7, #4]
 8000bd4:	f103 0208 	add.w	r2, r3, #8
 8000bd8:	683b      	ldr	r3, [r7, #0]
 8000bda:	611a      	str	r2, [r3, #16]
  f->__crc_end_addr = f->__crc_start_addr - 0x08 + f->__firmware_size;
 8000bdc:	683b      	ldr	r3, [r7, #0]
 8000bde:	691a      	ldr	r2, [r3, #16]
 8000be0:	683b      	ldr	r3, [r7, #0]
 8000be2:	69db      	ldr	r3, [r3, #28]
 8000be4:	4413      	add	r3, r2
 8000be6:	f1a3 0208 	sub.w	r2, r3, #8
 8000bea:	683b      	ldr	r3, [r7, #0]
 8000bec:	629a      	str	r2, [r3, #40]	@ 0x28
  f->__msp_value = *((volatile uint32_t *)(f->__vtable_address));
 8000bee:	683b      	ldr	r3, [r7, #0]
 8000bf0:	695b      	ldr	r3, [r3, #20]
 8000bf2:	681a      	ldr	r2, [r3, #0]
 8000bf4:	683b      	ldr	r3, [r7, #0]
 8000bf6:	621a      	str	r2, [r3, #32]
  f->__reset_handler = *((volatile uint32_t *)(f->__vtable_address + 0x4));
 8000bf8:	683b      	ldr	r3, [r7, #0]
 8000bfa:	695b      	ldr	r3, [r3, #20]
 8000bfc:	3304      	adds	r3, #4
 8000bfe:	681a      	ldr	r2, [r3, #0]
 8000c00:	683b      	ldr	r3, [r7, #0]
 8000c02:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000c04:	bf00      	nop
 8000c06:	370c      	adds	r7, #12
 8000c08:	46bd      	mov	sp, r7
 8000c0a:	bc80      	pop	{r7}
 8000c0c:	4770      	bx	lr

08000c0e <copy_firmware_t>:

void copy_firmware_t(firmware_t *f_dest, firmware_t *f_src) {
 8000c0e:	b480      	push	{r7}
 8000c10:	b083      	sub	sp, #12
 8000c12:	af00      	add	r7, sp, #0
 8000c14:	6078      	str	r0, [r7, #4]
 8000c16:	6039      	str	r1, [r7, #0]

  f_dest->__base_address = f_src->__base_address;
 8000c18:	683b      	ldr	r3, [r7, #0]
 8000c1a:	681a      	ldr	r2, [r3, #0]
 8000c1c:	687b      	ldr	r3, [r7, #4]
 8000c1e:	601a      	str	r2, [r3, #0]
  f_dest->__flag = f_src->__flag;
 8000c20:	683b      	ldr	r3, [r7, #0]
 8000c22:	685a      	ldr	r2, [r3, #4]
 8000c24:	687b      	ldr	r3, [r7, #4]
 8000c26:	605a      	str	r2, [r3, #4]
  f_dest->__crc = f_src->__crc;
 8000c28:	683b      	ldr	r3, [r7, #0]
 8000c2a:	689a      	ldr	r2, [r3, #8]
 8000c2c:	687b      	ldr	r3, [r7, #4]
 8000c2e:	609a      	str	r2, [r3, #8]
  f_dest->__vtable_end = f_src->__vtable_end;
 8000c30:	683b      	ldr	r3, [r7, #0]
 8000c32:	68da      	ldr	r2, [r3, #12]
 8000c34:	687b      	ldr	r3, [r7, #4]
 8000c36:	60da      	str	r2, [r3, #12]
  f_dest->__crc_start_addr = f_src->__crc_start_addr;
 8000c38:	683b      	ldr	r3, [r7, #0]
 8000c3a:	691a      	ldr	r2, [r3, #16]
 8000c3c:	687b      	ldr	r3, [r7, #4]
 8000c3e:	611a      	str	r2, [r3, #16]
  f_dest->__crc_end_addr = f_src->__crc_end_addr;
 8000c40:	683b      	ldr	r3, [r7, #0]
 8000c42:	6a9a      	ldr	r2, [r3, #40]	@ 0x28
 8000c44:	687b      	ldr	r3, [r7, #4]
 8000c46:	629a      	str	r2, [r3, #40]	@ 0x28
  f_dest->__vtable_address = f_src->__vtable_address;
 8000c48:	683b      	ldr	r3, [r7, #0]
 8000c4a:	695a      	ldr	r2, [r3, #20]
 8000c4c:	687b      	ldr	r3, [r7, #4]
 8000c4e:	615a      	str	r2, [r3, #20]
  f_dest->__firmware_end = f_src->__firmware_end;
 8000c50:	683b      	ldr	r3, [r7, #0]
 8000c52:	699a      	ldr	r2, [r3, #24]
 8000c54:	687b      	ldr	r3, [r7, #4]
 8000c56:	619a      	str	r2, [r3, #24]
  f_dest->__firmware_size = f_src->__firmware_size;
 8000c58:	683b      	ldr	r3, [r7, #0]
 8000c5a:	69da      	ldr	r2, [r3, #28]
 8000c5c:	687b      	ldr	r3, [r7, #4]
 8000c5e:	61da      	str	r2, [r3, #28]
  f_dest->__msp_value = f_src->__msp_value;
 8000c60:	683b      	ldr	r3, [r7, #0]
 8000c62:	6a1a      	ldr	r2, [r3, #32]
 8000c64:	687b      	ldr	r3, [r7, #4]
 8000c66:	621a      	str	r2, [r3, #32]
  f_dest->__reset_handler = f_src->__reset_handler;
 8000c68:	683b      	ldr	r3, [r7, #0]
 8000c6a:	6a5a      	ldr	r2, [r3, #36]	@ 0x24
 8000c6c:	687b      	ldr	r3, [r7, #4]
 8000c6e:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000c70:	bf00      	nop
 8000c72:	370c      	adds	r7, #12
 8000c74:	46bd      	mov	sp, r7
 8000c76:	bc80      	pop	{r7}
 8000c78:	4770      	bx	lr

08000c7a <handle_update>:

bool handle_update(void) {
 8000c7a:	b580      	push	{r7, lr}
 8000c7c:	b098      	sub	sp, #96	@ 0x60
 8000c7e:	af00      	add	r7, sp, #0

  /************************* recieve update and store it in
   * UPDATE_ADDR in flash***********************/

  if (recieve_update()) {
 8000c80:	f7ff fe7c 	bl	800097c <recieve_update>
 8000c84:	4603      	mov	r3, r0
 8000c86:	2b00      	cmp	r3, #0
 8000c88:	d005      	beq.n	8000c96 <handle_update+0x1c>
    printf("ERROR in recieving update\n\r", 0x0);
 8000c8a:	2100      	movs	r1, #0
 8000c8c:	4852      	ldr	r0, [pc, #328]	@ (8000dd8 <handle_update+0x15e>)
 8000c8e:	f7ff fde5 	bl	800085c <printf>
    return 0;
 8000c92:	2300      	movs	r3, #0
 8000c94:	e09c      	b.n	8000dd0 <handle_update+0x156>
  }
  firmware_t f;
  update_size = update_size / 4 * 4 + 4; // align update size by 4bytes
 8000c96:	4b51      	ldr	r3, [pc, #324]	@ (8000ddc <handle_update+0x162>)
 8000c98:	681b      	ldr	r3, [r3, #0]
 8000c9a:	f023 0303 	bic.w	r3, r3, #3
 8000c9e:	3304      	adds	r3, #4
 8000ca0:	4a4e      	ldr	r2, [pc, #312]	@ (8000ddc <handle_update+0x162>)
 8000ca2:	6013      	str	r3, [r2, #0]

  if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_1_ADDRESS)
 8000ca4:	4b4e      	ldr	r3, [pc, #312]	@ (8000de0 <handle_update+0x166>)
 8000ca6:	681b      	ldr	r3, [r3, #0]
 8000ca8:	4a4e      	ldr	r2, [pc, #312]	@ (8000de4 <handle_update+0x16a>)
 8000caa:	4293      	cmp	r3, r2
 8000cac:	d106      	bne.n	8000cbc <handle_update+0x42>
    copy_firmware_t(&f, &f1);
 8000cae:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000cb2:	494d      	ldr	r1, [pc, #308]	@ (8000de8 <handle_update+0x16e>)
 8000cb4:	4618      	mov	r0, r3
 8000cb6:	f7ff ffaa 	bl	8000c0e <copy_firmware_t>
 8000cba:	e011      	b.n	8000ce0 <handle_update+0x66>

  else if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_2_ADDRESS)
 8000cbc:	4b48      	ldr	r3, [pc, #288]	@ (8000de0 <handle_update+0x166>)
 8000cbe:	681b      	ldr	r3, [r3, #0]
 8000cc0:	4a4a      	ldr	r2, [pc, #296]	@ (8000dec <handle_update+0x172>)
 8000cc2:	4293      	cmp	r3, r2
 8000cc4:	d106      	bne.n	8000cd4 <handle_update+0x5a>
    copy_firmware_t(&f, &f2);
 8000cc6:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000cca:	4949      	ldr	r1, [pc, #292]	@ (8000df0 <handle_update+0x176>)
 8000ccc:	4618      	mov	r0, r3
 8000cce:	f7ff ff9e 	bl	8000c0e <copy_firmware_t>
 8000cd2:	e005      	b.n	8000ce0 <handle_update+0x66>

  else {
    printf("wrong firmware base address !!!", 0x0);
 8000cd4:	2100      	movs	r1, #0
 8000cd6:	4847      	ldr	r0, [pc, #284]	@ (8000df4 <handle_update+0x17a>)
 8000cd8:	f7ff fdc0 	bl	800085c <printf>
    return 0;
 8000cdc:	2300      	movs	r3, #0
 8000cde:	e077      	b.n	8000dd0 <handle_update+0x156>
  // if (flash_write(UPDATE_ADDR, fw_update, update_size, NO_DELAY)) {
  //   printf("ERROR in flash_write\n\r", 0x0);
  //   return;
  // }

  printf("update has been saved in the update section !!!\n\r", 0x0);
 8000ce0:	2100      	movs	r1, #0
 8000ce2:	4845      	ldr	r0, [pc, #276]	@ (8000df8 <handle_update+0x17e>)
 8000ce4:	f7ff fdba 	bl	800085c <printf>

  firmware_t uf;
  init_firmware_t(UPDATE_ADDR, &uf);
 8000ce8:	f107 0308 	add.w	r3, r7, #8
 8000cec:	4619      	mov	r1, r3
 8000cee:	4843      	ldr	r0, [pc, #268]	@ (8000dfc <handle_update+0x182>)
 8000cf0:	f7ff ff46 	bl	8000b80 <init_firmware_t>

  printf("***************validating update***************\n\r", 0x0);
 8000cf4:	2100      	movs	r1, #0
 8000cf6:	4842      	ldr	r0, [pc, #264]	@ (8000e00 <handle_update+0x186>)
 8000cf8:	f7ff fdb0 	bl	800085c <printf>

  // check flag field of the firmware
  if (uf.__flag != 0xffffffff) {
 8000cfc:	68fb      	ldr	r3, [r7, #12]
 8000cfe:	f1b3 3fff 	cmp.w	r3, #4294967295	@ 0xffffffff
 8000d02:	d005      	beq.n	8000d10 <handle_update+0x96>
    printf("ERROR .... flag field of update must be 0xffffffff\n\r", 0x0);
 8000d04:	2100      	movs	r1, #0
 8000d06:	483f      	ldr	r0, [pc, #252]	@ (8000e04 <handle_update+0x18a>)
 8000d08:	f7ff fda8 	bl	800085c <printf>
    return 0;
 8000d0c:	2300      	movs	r3, #0
 8000d0e:	e05f      	b.n	8000dd0 <handle_update+0x156>
  }
  if (!validate_firmware(&uf)) {
 8000d10:	f107 0308 	add.w	r3, r7, #8
 8000d14:	4618      	mov	r0, r3
 8000d16:	f7ff fc85 	bl	8000624 <validate_firmware>
 8000d1a:	4603      	mov	r3, r0
 8000d1c:	f083 0301 	eor.w	r3, r3, #1
 8000d20:	b2db      	uxtb	r3, r3
 8000d22:	2b00      	cmp	r3, #0
 8000d24:	d005      	beq.n	8000d32 <handle_update+0xb8>
    printf("ERROR .... update validation failed\n\r", 0x0);
 8000d26:	2100      	movs	r1, #0
 8000d28:	4837      	ldr	r0, [pc, #220]	@ (8000e08 <handle_update+0x18e>)
 8000d2a:	f7ff fd97 	bl	800085c <printf>
    return 0;
 8000d2e:	2300      	movs	r3, #0
 8000d30:	e04e      	b.n	8000dd0 <handle_update+0x156>
  }

  /************************firmware to COPY section
   * ***********************************/

  if (erase_flash(COPY_ADDR)) {
 8000d32:	4836      	ldr	r0, [pc, #216]	@ (8000e0c <handle_update+0x192>)
 8000d34:	f000 f9be 	bl	80010b4 <erase_flash>
 8000d38:	4603      	mov	r3, r0
 8000d3a:	2b00      	cmp	r3, #0
 8000d3c:	d005      	beq.n	8000d4a <handle_update+0xd0>
    printf("could not erase COPY section\n\r", 0x0);
 8000d3e:	2100      	movs	r1, #0
 8000d40:	4833      	ldr	r0, [pc, #204]	@ (8000e10 <handle_update+0x196>)
 8000d42:	f7ff fd8b 	bl	800085c <printf>
    return 0;
 8000d46:	2300      	movs	r3, #0
 8000d48:	e042      	b.n	8000dd0 <handle_update+0x156>
  }
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000d4a:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000d4c:	4619      	mov	r1, r3
                  f.__firmware_size, NO_DELAY)) {
 8000d4e:	6d3a      	ldr	r2, [r7, #80]	@ 0x50
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000d50:	2300      	movs	r3, #0
 8000d52:	482e      	ldr	r0, [pc, #184]	@ (8000e0c <handle_update+0x192>)
 8000d54:	f000 fa68 	bl	8001228 <flash_write>
 8000d58:	4603      	mov	r3, r0
 8000d5a:	2b00      	cmp	r3, #0
 8000d5c:	d005      	beq.n	8000d6a <handle_update+0xf0>

    printf("could not write to the COPY section \n\r", 0x0);
 8000d5e:	2100      	movs	r1, #0
 8000d60:	482c      	ldr	r0, [pc, #176]	@ (8000e14 <handle_update+0x19a>)
 8000d62:	f7ff fd7b 	bl	800085c <printf>
    return 0;
 8000d66:	2300      	movs	r3, #0
 8000d68:	e032      	b.n	8000dd0 <handle_update+0x156>
  }
  printf("firmware is copied to copy section\n\r", 0x0);
 8000d6a:	2100      	movs	r1, #0
 8000d6c:	482a      	ldr	r0, [pc, #168]	@ (8000e18 <handle_update+0x19e>)
 8000d6e:	f7ff fd75 	bl	800085c <printf>

  /********************* update to firmware
   * ********************************************/

  if (erase_flash(f.__base_address)) {
 8000d72:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000d74:	4618      	mov	r0, r3
 8000d76:	f000 f99d 	bl	80010b4 <erase_flash>
 8000d7a:	4603      	mov	r3, r0
 8000d7c:	2b00      	cmp	r3, #0
 8000d7e:	d005      	beq.n	8000d8c <handle_update+0x112>
    printf("could not erase FIRMWARE section\n\r", 0x0);
 8000d80:	2100      	movs	r1, #0
 8000d82:	4826      	ldr	r0, [pc, #152]	@ (8000e1c <handle_update+0x1a2>)
 8000d84:	f7ff fd6a 	bl	800085c <printf>
    return 0;
 8000d88:	2300      	movs	r3, #0
 8000d8a:	e021      	b.n	8000dd0 <handle_update+0x156>
  }
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000d8c:	6b78      	ldr	r0, [r7, #52]	@ 0x34
                  uf.__firmware_size, NO_DELAY)) {
 8000d8e:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000d90:	2300      	movs	r3, #0
 8000d92:	491a      	ldr	r1, [pc, #104]	@ (8000dfc <handle_update+0x182>)
 8000d94:	f000 fa48 	bl	8001228 <flash_write>
 8000d98:	4603      	mov	r3, r0
 8000d9a:	2b00      	cmp	r3, #0
 8000d9c:	d005      	beq.n	8000daa <handle_update+0x130>

    printf("could not write to the firmware section\n\r", 0x0);
 8000d9e:	2100      	movs	r1, #0
 8000da0:	481f      	ldr	r0, [pc, #124]	@ (8000e20 <handle_update+0x1a6>)
 8000da2:	f7ff fd5b 	bl	800085c <printf>
    return 0;
 8000da6:	2300      	movs	r3, #0
 8000da8:	e012      	b.n	8000dd0 <handle_update+0x156>
  }

  const uint32_t end = 0xfffffffe;
 8000daa:	f06f 0301 	mvn.w	r3, #1
 8000dae:	607b      	str	r3, [r7, #4]
  // mark the flag implying that firmware has been updated
  flash_write(f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000db0:	6b78      	ldr	r0, [r7, #52]	@ 0x34
 8000db2:	1d39      	adds	r1, r7, #4
 8000db4:	2300      	movs	r3, #0
 8000db6:	2204      	movs	r2, #4
 8000db8:	f000 fa36 	bl	8001228 <flash_write>

  printf("new flag = %\n\r", f.__base_address);
 8000dbc:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000dbe:	4619      	mov	r1, r3
 8000dc0:	4818      	ldr	r0, [pc, #96]	@ (8000e24 <handle_update+0x1aa>)
 8000dc2:	f7ff fd4b 	bl	800085c <printf>

  printf("updating firmware is done successfully!!!!\n\r", 0x0);
 8000dc6:	2100      	movs	r1, #0
 8000dc8:	4817      	ldr	r0, [pc, #92]	@ (8000e28 <handle_update+0x1ae>)
 8000dca:	f7ff fd47 	bl	800085c <printf>

  return 1;
 8000dce:	2301      	movs	r3, #1
}
 8000dd0:	4618      	mov	r0, r3
 8000dd2:	3760      	adds	r7, #96	@ 0x60
 8000dd4:	46bd      	mov	sp, r7
 8000dd6:	bd80      	pop	{r7, pc}
 8000dd8:	080018d4 	.word	0x080018d4
 8000ddc:	20000074 	.word	0x20000074
 8000de0:	0804000c 	.word	0x0804000c
 8000de4:	08010000 	.word	0x08010000
 8000de8:	20000008 	.word	0x20000008
 8000dec:	08020000 	.word	0x08020000
 8000df0:	20000034 	.word	0x20000034
 8000df4:	080018f0 	.word	0x080018f0
 8000df8:	08001910 	.word	0x08001910
 8000dfc:	08040000 	.word	0x08040000
 8000e00:	08001944 	.word	0x08001944
 8000e04:	08001978 	.word	0x08001978
 8000e08:	080019b0 	.word	0x080019b0
 8000e0c:	08060000 	.word	0x08060000
 8000e10:	080019d8 	.word	0x080019d8
 8000e14:	080019f8 	.word	0x080019f8
 8000e18:	08001a20 	.word	0x08001a20
 8000e1c:	08001a48 	.word	0x08001a48
 8000e20:	08001a6c 	.word	0x08001a6c
 8000e24:	08001a98 	.word	0x08001a98
 8000e28:	08001aa8 	.word	0x08001aa8

08000e2c <switch_press>:

bool switch_press (bool f1_valid, bool f2_valid){
 8000e2c:	b580      	push	{r7, lr}
 8000e2e:	b084      	sub	sp, #16
 8000e30:	af00      	add	r7, sp, #0
 8000e32:	4603      	mov	r3, r0
 8000e34:	460a      	mov	r2, r1
 8000e36:	71fb      	strb	r3, [r7, #7]
 8000e38:	4613      	mov	r3, r2
 8000e3a:	71bb      	strb	r3, [r7, #6]

  while (!press_count)
 8000e3c:	bf00      	nop
 8000e3e:	4b31      	ldr	r3, [pc, #196]	@ (8000f04 <switch_press+0xd8>)
 8000e40:	681b      	ldr	r3, [r3, #0]
 8000e42:	2b00      	cmp	r3, #0
 8000e44:	d0fb      	beq.n	8000e3e <switch_press+0x12>
    ;
  delay_count = 1000000;
 8000e46:	4b30      	ldr	r3, [pc, #192]	@ (8000f08 <switch_press+0xdc>)
 8000e48:	4a30      	ldr	r2, [pc, #192]	@ (8000f0c <switch_press+0xe0>)
 8000e4a:	601a      	str	r2, [r3, #0]
  while (delay_count--)
 8000e4c:	bf00      	nop
 8000e4e:	4b2e      	ldr	r3, [pc, #184]	@ (8000f08 <switch_press+0xdc>)
 8000e50:	681b      	ldr	r3, [r3, #0]
 8000e52:	1e5a      	subs	r2, r3, #1
 8000e54:	492c      	ldr	r1, [pc, #176]	@ (8000f08 <switch_press+0xdc>)
 8000e56:	600a      	str	r2, [r1, #0]
 8000e58:	2b00      	cmp	r3, #0
 8000e5a:	d1f8      	bne.n	8000e4e <switch_press+0x22>
    ;
  if (press_count >= 3) {
 8000e5c:	4b29      	ldr	r3, [pc, #164]	@ (8000f04 <switch_press+0xd8>)
 8000e5e:	681b      	ldr	r3, [r3, #0]
 8000e60:	2b02      	cmp	r3, #2
 8000e62:	d929      	bls.n	8000eb8 <switch_press+0x8c>
    erase_flash (UPDATE_ADDR);
 8000e64:	482a      	ldr	r0, [pc, #168]	@ (8000f10 <switch_press+0xe4>)
 8000e66:	f000 f925 	bl	80010b4 <erase_flash>
    firmware_update_mode = true;
 8000e6a:	4b2a      	ldr	r3, [pc, #168]	@ (8000f14 <switch_press+0xe8>)
 8000e6c:	2201      	movs	r2, #1
 8000e6e:	701a      	strb	r2, [r3, #0]
    bool status = handle_update();
 8000e70:	f7ff ff03 	bl	8000c7a <handle_update>
 8000e74:	4603      	mov	r3, r0
 8000e76:	73fb      	strb	r3, [r7, #15]

    if (!status && recursion_depth < MAX_RECURSION_DEPTH) {
 8000e78:	7bfb      	ldrb	r3, [r7, #15]
 8000e7a:	f083 0301 	eor.w	r3, r3, #1
 8000e7e:	b2db      	uxtb	r3, r3
 8000e80:	2b00      	cmp	r3, #0
 8000e82:	d017      	beq.n	8000eb4 <switch_press+0x88>
 8000e84:	4b24      	ldr	r3, [pc, #144]	@ (8000f18 <switch_press+0xec>)
 8000e86:	781b      	ldrb	r3, [r3, #0]
 8000e88:	2b01      	cmp	r3, #1
 8000e8a:	d813      	bhi.n	8000eb4 <switch_press+0x88>
      printf ("error in update !!! retry\n\r", 0x0);
 8000e8c:	2100      	movs	r1, #0
 8000e8e:	4823      	ldr	r0, [pc, #140]	@ (8000f1c <switch_press+0xf0>)
 8000e90:	f7ff fce4 	bl	800085c <printf>
      recursion_depth ++;
 8000e94:	4b20      	ldr	r3, [pc, #128]	@ (8000f18 <switch_press+0xec>)
 8000e96:	781b      	ldrb	r3, [r3, #0]
 8000e98:	3301      	adds	r3, #1
 8000e9a:	b2da      	uxtb	r2, r3
 8000e9c:	4b1e      	ldr	r3, [pc, #120]	@ (8000f18 <switch_press+0xec>)
 8000e9e:	701a      	strb	r2, [r3, #0]
      press_count = 0;
 8000ea0:	4b18      	ldr	r3, [pc, #96]	@ (8000f04 <switch_press+0xd8>)
 8000ea2:	2200      	movs	r2, #0
 8000ea4:	601a      	str	r2, [r3, #0]
      // flag_size_recieved = false;
      // flag_wrong_size = false;
      // flag_too_big_update = false;

      switch_press (f1_valid, f2_valid);
 8000ea6:	79ba      	ldrb	r2, [r7, #6]
 8000ea8:	79fb      	ldrb	r3, [r7, #7]
 8000eaa:	4611      	mov	r1, r2
 8000eac:	4618      	mov	r0, r3
 8000eae:	f7ff ffbd 	bl	8000e2c <switch_press>
 8000eb2:	e022      	b.n	8000efa <switch_press+0xce>
    }
    else return false;
 8000eb4:	2300      	movs	r3, #0
 8000eb6:	e021      	b.n	8000efc <switch_press+0xd0>
  } else if (press_count == 2) {
 8000eb8:	4b12      	ldr	r3, [pc, #72]	@ (8000f04 <switch_press+0xd8>)
 8000eba:	681b      	ldr	r3, [r3, #0]
 8000ebc:	2b02      	cmp	r3, #2
 8000ebe:	d10e      	bne.n	8000ede <switch_press+0xb2>
    if (f2_valid) {
 8000ec0:	79bb      	ldrb	r3, [r7, #6]
 8000ec2:	2b00      	cmp	r3, #0
 8000ec4:	d005      	beq.n	8000ed2 <switch_press+0xa6>
      boot_f1 = false;
 8000ec6:	4b16      	ldr	r3, [pc, #88]	@ (8000f20 <switch_press+0xf4>)
 8000ec8:	2200      	movs	r2, #0
 8000eca:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000ecc:	f7ff f9ea 	bl	80002a4 <jump_to_firmware>
 8000ed0:	e013      	b.n	8000efa <switch_press+0xce>
    } else {
      boot_f1 = true;
 8000ed2:	4b13      	ldr	r3, [pc, #76]	@ (8000f20 <switch_press+0xf4>)
 8000ed4:	2201      	movs	r2, #1
 8000ed6:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000ed8:	f7ff f9e4 	bl	80002a4 <jump_to_firmware>
 8000edc:	e00d      	b.n	8000efa <switch_press+0xce>
    }
  } else {
    if (f1_valid) {
 8000ede:	79fb      	ldrb	r3, [r7, #7]
 8000ee0:	2b00      	cmp	r3, #0
 8000ee2:	d005      	beq.n	8000ef0 <switch_press+0xc4>
      boot_f1 = true;
 8000ee4:	4b0e      	ldr	r3, [pc, #56]	@ (8000f20 <switch_press+0xf4>)
 8000ee6:	2201      	movs	r2, #1
 8000ee8:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000eea:	f7ff f9db 	bl	80002a4 <jump_to_firmware>
 8000eee:	e004      	b.n	8000efa <switch_press+0xce>
    } else {
      boot_f1 = false;
 8000ef0:	4b0b      	ldr	r3, [pc, #44]	@ (8000f20 <switch_press+0xf4>)
 8000ef2:	2200      	movs	r2, #0
 8000ef4:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000ef6:	f7ff f9d5 	bl	80002a4 <jump_to_firmware>
    }
  }
  return true;
 8000efa:	2301      	movs	r3, #1
}
 8000efc:	4618      	mov	r0, r3
 8000efe:	3710      	adds	r7, #16
 8000f00:	46bd      	mov	sp, r7
 8000f02:	bd80      	pop	{r7, pc}
 8000f04:	20000060 	.word	0x20000060
 8000f08:	20000064 	.word	0x20000064
 8000f0c:	000f4240 	.word	0x000f4240
 8000f10:	08040000 	.word	0x08040000
 8000f14:	2000507e 	.word	0x2000507e
 8000f18:	2000507f 	.word	0x2000507f
 8000f1c:	08001ad8 	.word	0x08001ad8
 8000f20:	20000004 	.word	0x20000004

08000f24 <main>:


int main() {
 8000f24:	b580      	push	{r7, lr}
 8000f26:	b082      	sub	sp, #8
 8000f28:	af00      	add	r7, sp, #0

    Ring_buff_init(&ringbuffer);
 8000f2a:	4852      	ldr	r0, [pc, #328]	@ (8001074 <main+0x150>)
 8000f2c:	f7ff fa26 	bl	800037c <Ring_buff_init>

    // enable faults (without this any fault = hardfault)
    SCB->SHCSR |= SCB_SHCSR_BUSFAULTENA_Msk;
 8000f30:	4b51      	ldr	r3, [pc, #324]	@ (8001078 <main+0x154>)
 8000f32:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f34:	4a50      	ldr	r2, [pc, #320]	@ (8001078 <main+0x154>)
 8000f36:	f443 3300 	orr.w	r3, r3, #131072	@ 0x20000
 8000f3a:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_USGFAULTENA_Msk;
 8000f3c:	4b4e      	ldr	r3, [pc, #312]	@ (8001078 <main+0x154>)
 8000f3e:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f40:	4a4d      	ldr	r2, [pc, #308]	@ (8001078 <main+0x154>)
 8000f42:	f443 2380 	orr.w	r3, r3, #262144	@ 0x40000
 8000f46:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
 8000f48:	4b4b      	ldr	r3, [pc, #300]	@ (8001078 <main+0x154>)
 8000f4a:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f4c:	4a4a      	ldr	r2, [pc, #296]	@ (8001078 <main+0x154>)
 8000f4e:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 8000f52:	6253      	str	r3, [r2, #36]	@ 0x24


  __usart1_init();
 8000f54:	f000 fa04 	bl	8001360 <__usart1_init>

  printf("\n\n\nbooting....\n\n\n\r", 0x0);
 8000f58:	2100      	movs	r1, #0
 8000f5a:	4848      	ldr	r0, [pc, #288]	@ (800107c <main+0x158>)
 8000f5c:	f7ff fc7e 	bl	800085c <printf>

  // check if fimrware is corrupted during update

  if (*(uint32_t *)FIRMWARE_1_ADDRESS & 1) {
 8000f60:	4b47      	ldr	r3, [pc, #284]	@ (8001080 <main+0x15c>)
 8000f62:	681b      	ldr	r3, [r3, #0]
 8000f64:	f003 0301 	and.w	r3, r3, #1
 8000f68:	2b00      	cmp	r3, #0
 8000f6a:	d001      	beq.n	8000f70 <main+0x4c>
    rollback();
 8000f6c:	f7ff fda2 	bl	8000ab4 <rollback>
  }
  if (*(uint32_t *)FIRMWARE_2_ADDRESS & 1) {
 8000f70:	4b44      	ldr	r3, [pc, #272]	@ (8001084 <main+0x160>)
 8000f72:	681b      	ldr	r3, [r3, #0]
 8000f74:	f003 0301 	and.w	r3, r3, #1
 8000f78:	2b00      	cmp	r3, #0
 8000f7a:	d001      	beq.n	8000f80 <main+0x5c>
    rollback();
 8000f7c:	f7ff fd9a 	bl	8000ab4 <rollback>
  }

  bool f1_valid = true;
 8000f80:	2301      	movs	r3, #1
 8000f82:	71fb      	strb	r3, [r7, #7]
  bool f2_valid = true;
 8000f84:	2301      	movs	r3, #1
 8000f86:	71bb      	strb	r3, [r7, #6]
  init_firmware_t(FIRMWARE_1_ADDRESS, &f1);
 8000f88:	493f      	ldr	r1, [pc, #252]	@ (8001088 <main+0x164>)
 8000f8a:	483d      	ldr	r0, [pc, #244]	@ (8001080 <main+0x15c>)
 8000f8c:	f7ff fdf8 	bl	8000b80 <init_firmware_t>
  init_firmware_t(FIRMWARE_2_ADDRESS, &f2);
 8000f90:	493e      	ldr	r1, [pc, #248]	@ (800108c <main+0x168>)
 8000f92:	483c      	ldr	r0, [pc, #240]	@ (8001084 <main+0x160>)
 8000f94:	f7ff fdf4 	bl	8000b80 <init_firmware_t>

  // printf("hii there %\n\r", f1.__vtable_address);

  printf("*************validating firmware1*************\n\r", 0x0);
 8000f98:	2100      	movs	r1, #0
 8000f9a:	483d      	ldr	r0, [pc, #244]	@ (8001090 <main+0x16c>)
 8000f9c:	f7ff fc5e 	bl	800085c <printf>
  f1_valid = validate_firmware(&f1);
 8000fa0:	4839      	ldr	r0, [pc, #228]	@ (8001088 <main+0x164>)
 8000fa2:	f7ff fb3f 	bl	8000624 <validate_firmware>
 8000fa6:	4603      	mov	r3, r0
 8000fa8:	71fb      	strb	r3, [r7, #7]
  printf("*************validating firmware2*************\n\r", 0x0);
 8000faa:	2100      	movs	r1, #0
 8000fac:	4839      	ldr	r0, [pc, #228]	@ (8001094 <main+0x170>)
 8000fae:	f7ff fc55 	bl	800085c <printf>
  f2_valid = validate_firmware(&f2);
 8000fb2:	4836      	ldr	r0, [pc, #216]	@ (800108c <main+0x168>)
 8000fb4:	f7ff fb36 	bl	8000624 <validate_firmware>
 8000fb8:	4603      	mov	r3, r0
 8000fba:	71bb      	strb	r3, [r7, #6]

  printf("both the firmwares are checked\n\r", 0x0);
 8000fbc:	2100      	movs	r1, #0
 8000fbe:	4836      	ldr	r0, [pc, #216]	@ (8001098 <main+0x174>)
 8000fc0:	f7ff fc4c 	bl	800085c <printf>
  // init GPIOC (for on board switch)
  // init SYSCGF (for using EXTI)

  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN_Msk;
 8000fc4:	4b35      	ldr	r3, [pc, #212]	@ (800109c <main+0x178>)
 8000fc6:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8000fc8:	4a34      	ldr	r2, [pc, #208]	@ (800109c <main+0x178>)
 8000fca:	f443 4380 	orr.w	r3, r3, #16384	@ 0x4000
 8000fce:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN_Msk;
 8000fd0:	4b32      	ldr	r3, [pc, #200]	@ (800109c <main+0x178>)
 8000fd2:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8000fd4:	4a31      	ldr	r2, [pc, #196]	@ (800109c <main+0x178>)
 8000fd6:	f043 0304 	orr.w	r3, r3, #4
 8000fda:	6313      	str	r3, [r2, #48]	@ 0x30

  // set switch to input
  GPIOC->MODER &= ~(3U << (2 * SWITCH_PIN));
 8000fdc:	4b30      	ldr	r3, [pc, #192]	@ (80010a0 <main+0x17c>)
 8000fde:	681b      	ldr	r3, [r3, #0]
 8000fe0:	4a2f      	ldr	r2, [pc, #188]	@ (80010a0 <main+0x17c>)
 8000fe2:	f023 6340 	bic.w	r3, r3, #201326592	@ 0xc000000
 8000fe6:	6013      	str	r3, [r2, #0]

  // falling edge detect
  EXTI->FTSR |= EXTI_FTSR_TR13_Msk;
 8000fe8:	4b2e      	ldr	r3, [pc, #184]	@ (80010a4 <main+0x180>)
 8000fea:	68db      	ldr	r3, [r3, #12]
 8000fec:	4a2d      	ldr	r2, [pc, #180]	@ (80010a4 <main+0x180>)
 8000fee:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8000ff2:	60d3      	str	r3, [r2, #12]

  SYSCFG->EXTICR[3] &= ~(SYSCFG_EXTICR4_EXTI13_Msk);
 8000ff4:	4b2c      	ldr	r3, [pc, #176]	@ (80010a8 <main+0x184>)
 8000ff6:	695b      	ldr	r3, [r3, #20]
 8000ff8:	4a2b      	ldr	r2, [pc, #172]	@ (80010a8 <main+0x184>)
 8000ffa:	f023 03f0 	bic.w	r3, r3, #240	@ 0xf0
 8000ffe:	6153      	str	r3, [r2, #20]
  SYSCFG->EXTICR[3] |= SYSCFG_EXTICR4_EXTI13_PC;
 8001000:	4b29      	ldr	r3, [pc, #164]	@ (80010a8 <main+0x184>)
 8001002:	695b      	ldr	r3, [r3, #20]
 8001004:	4a28      	ldr	r2, [pc, #160]	@ (80010a8 <main+0x184>)
 8001006:	f043 0320 	orr.w	r3, r3, #32
 800100a:	6153      	str	r3, [r2, #20]

  // enable mask at the end
  EXTI->IMR |= EXTI_IMR_MR13_Msk;
 800100c:	4b25      	ldr	r3, [pc, #148]	@ (80010a4 <main+0x180>)
 800100e:	681b      	ldr	r3, [r3, #0]
 8001010:	4a24      	ldr	r2, [pc, #144]	@ (80010a4 <main+0x180>)
 8001012:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8001016:	6013      	str	r3, [r2, #0]

  NVIC_EnableIRQ(EXTI15_10_IRQn);
 8001018:	2028      	movs	r0, #40	@ 0x28
 800101a:	f7ff fd95 	bl	8000b48 <__NVIC_EnableIRQ>

  if (!f1_valid && !f2_valid) {
 800101e:	79fb      	ldrb	r3, [r7, #7]
 8001020:	f083 0301 	eor.w	r3, r3, #1
 8001024:	b2db      	uxtb	r3, r3
 8001026:	2b00      	cmp	r3, #0
 8001028:	d011      	beq.n	800104e <main+0x12a>
 800102a:	79bb      	ldrb	r3, [r7, #6]
 800102c:	f083 0301 	eor.w	r3, r3, #1
 8001030:	b2db      	uxtb	r3, r3
 8001032:	2b00      	cmp	r3, #0
 8001034:	d00b      	beq.n	800104e <main+0x12a>
    printf("both the firmwares are not valid\n\n\r", 0x0);
 8001036:	2100      	movs	r1, #0
 8001038:	481c      	ldr	r0, [pc, #112]	@ (80010ac <main+0x188>)
 800103a:	f7ff fc0f 	bl	800085c <printf>
    EXTI->IMR &= EXTI_IMR_MR13_Msk;
 800103e:	4b19      	ldr	r3, [pc, #100]	@ (80010a4 <main+0x180>)
 8001040:	681b      	ldr	r3, [r3, #0]
 8001042:	4a18      	ldr	r2, [pc, #96]	@ (80010a4 <main+0x180>)
 8001044:	f403 5300 	and.w	r3, r3, #8192	@ 0x2000
 8001048:	6013      	str	r3, [r2, #0]
    handle_update();
 800104a:	f7ff fe16 	bl	8000c7a <handle_update>
  }

  // /* illegal memory access */
  // *(uint32_t *) (0xffffffff) = 0;
  
  bool status = switch_press (f1_valid, f2_valid);
 800104e:	79ba      	ldrb	r2, [r7, #6]
 8001050:	79fb      	ldrb	r3, [r7, #7]
 8001052:	4611      	mov	r1, r2
 8001054:	4618      	mov	r0, r3
 8001056:	f7ff fee9 	bl	8000e2c <switch_press>
 800105a:	4603      	mov	r3, r0
 800105c:	717b      	strb	r3, [r7, #5]
  if (!status){
 800105e:	797b      	ldrb	r3, [r7, #5]
 8001060:	f083 0301 	eor.w	r3, r3, #1
 8001064:	b2db      	uxtb	r3, r3
 8001066:	2b00      	cmp	r3, #0
 8001068:	d003      	beq.n	8001072 <main+0x14e>
    printf ("too many wrong firmware update attempt !!!\n\r", 0x0);
 800106a:	2100      	movs	r1, #0
 800106c:	4810      	ldr	r0, [pc, #64]	@ (80010b0 <main+0x18c>)
 800106e:	f7ff fbf5 	bl	800085c <printf>
  }
  while (1);
 8001072:	e7fe      	b.n	8001072 <main+0x14e>
 8001074:	20000078 	.word	0x20000078
 8001078:	e000ed00 	.word	0xe000ed00
 800107c:	08001af4 	.word	0x08001af4
 8001080:	08010000 	.word	0x08010000
 8001084:	08020000 	.word	0x08020000
 8001088:	20000008 	.word	0x20000008
 800108c:	20000034 	.word	0x20000034
 8001090:	08001b08 	.word	0x08001b08
 8001094:	08001b3c 	.word	0x08001b3c
 8001098:	08001b70 	.word	0x08001b70
 800109c:	40023800 	.word	0x40023800
 80010a0:	40020800 	.word	0x40020800
 80010a4:	40013c00 	.word	0x40013c00
 80010a8:	40013800 	.word	0x40013800
 80010ac:	08001b94 	.word	0x08001b94
 80010b0:	08001bb8 	.word	0x08001bb8

080010b4 <erase_flash>:
#define KEY1 0x45670123
#define KEY2 0xCDEF89AB

void printf (const char *string, uint32_t addr);

uint32_t erase_flash(uint32_t address) {
 80010b4:	b580      	push	{r7, lr}
 80010b6:	b084      	sub	sp, #16
 80010b8:	af00      	add	r7, sp, #0
 80010ba:	6078      	str	r0, [r7, #4]
  if (address >= 0x08080000 || address < 0x08000000) {
 80010bc:	687b      	ldr	r3, [r7, #4]
 80010be:	4a4c      	ldr	r2, [pc, #304]	@ (80011f0 <erase_flash+0x13c>)
 80010c0:	4293      	cmp	r3, r2
 80010c2:	d803      	bhi.n	80010cc <erase_flash+0x18>
 80010c4:	687b      	ldr	r3, [r7, #4]
 80010c6:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 80010ca:	d206      	bcs.n	80010da <erase_flash+0x26>
    printf("wrong address \n\r", 0x0);
 80010cc:	2100      	movs	r1, #0
 80010ce:	4849      	ldr	r0, [pc, #292]	@ (80011f4 <erase_flash+0x140>)
 80010d0:	f7ff fbc4 	bl	800085c <printf>
    return -1;
 80010d4:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80010d8:	e085      	b.n	80011e6 <erase_flash+0x132>
  }

  uint32_t sector = 0;
 80010da:	2300      	movs	r3, #0
 80010dc:	60fb      	str	r3, [r7, #12]
  if (address >= 0x08060000)
 80010de:	687b      	ldr	r3, [r7, #4]
 80010e0:	4a45      	ldr	r2, [pc, #276]	@ (80011f8 <erase_flash+0x144>)
 80010e2:	4293      	cmp	r3, r2
 80010e4:	d902      	bls.n	80010ec <erase_flash+0x38>
    sector = 7;
 80010e6:	2307      	movs	r3, #7
 80010e8:	60fb      	str	r3, [r7, #12]
 80010ea:	e037      	b.n	800115c <erase_flash+0xa8>
  else if (address >= 0x08040000)
 80010ec:	687b      	ldr	r3, [r7, #4]
 80010ee:	4a43      	ldr	r2, [pc, #268]	@ (80011fc <erase_flash+0x148>)
 80010f0:	4293      	cmp	r3, r2
 80010f2:	d902      	bls.n	80010fa <erase_flash+0x46>
    sector = 6;
 80010f4:	2306      	movs	r3, #6
 80010f6:	60fb      	str	r3, [r7, #12]
 80010f8:	e030      	b.n	800115c <erase_flash+0xa8>
  else if (address >= 0x08020000)
 80010fa:	687b      	ldr	r3, [r7, #4]
 80010fc:	4a40      	ldr	r2, [pc, #256]	@ (8001200 <erase_flash+0x14c>)
 80010fe:	4293      	cmp	r3, r2
 8001100:	d902      	bls.n	8001108 <erase_flash+0x54>
    sector = 5;
 8001102:	2305      	movs	r3, #5
 8001104:	60fb      	str	r3, [r7, #12]
 8001106:	e029      	b.n	800115c <erase_flash+0xa8>
  else if (address >= 0x08010000)
 8001108:	687b      	ldr	r3, [r7, #4]
 800110a:	4a3e      	ldr	r2, [pc, #248]	@ (8001204 <erase_flash+0x150>)
 800110c:	4293      	cmp	r3, r2
 800110e:	d902      	bls.n	8001116 <erase_flash+0x62>
    sector = 4;
 8001110:	2304      	movs	r3, #4
 8001112:	60fb      	str	r3, [r7, #12]
 8001114:	e022      	b.n	800115c <erase_flash+0xa8>
  else if (address >= 0x0800c000)
 8001116:	687b      	ldr	r3, [r7, #4]
 8001118:	4a3b      	ldr	r2, [pc, #236]	@ (8001208 <erase_flash+0x154>)
 800111a:	4293      	cmp	r3, r2
 800111c:	d302      	bcc.n	8001124 <erase_flash+0x70>
    sector = 3;
 800111e:	2303      	movs	r3, #3
 8001120:	60fb      	str	r3, [r7, #12]
 8001122:	e01b      	b.n	800115c <erase_flash+0xa8>
  else if (address >= 0x08008000)
 8001124:	687b      	ldr	r3, [r7, #4]
 8001126:	4a39      	ldr	r2, [pc, #228]	@ (800120c <erase_flash+0x158>)
 8001128:	4293      	cmp	r3, r2
 800112a:	d302      	bcc.n	8001132 <erase_flash+0x7e>
    sector = 2;
 800112c:	2302      	movs	r3, #2
 800112e:	60fb      	str	r3, [r7, #12]
 8001130:	e014      	b.n	800115c <erase_flash+0xa8>
  else if (address >= 0x08004000)
 8001132:	687b      	ldr	r3, [r7, #4]
 8001134:	4a36      	ldr	r2, [pc, #216]	@ (8001210 <erase_flash+0x15c>)
 8001136:	4293      	cmp	r3, r2
 8001138:	d302      	bcc.n	8001140 <erase_flash+0x8c>
    sector = 1;
 800113a:	2301      	movs	r3, #1
 800113c:	60fb      	str	r3, [r7, #12]
 800113e:	e00d      	b.n	800115c <erase_flash+0xa8>
  else if (address >= 0x08000000)
 8001140:	687b      	ldr	r3, [r7, #4]
 8001142:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 8001146:	d302      	bcc.n	800114e <erase_flash+0x9a>
    sector = 0;
 8001148:	2300      	movs	r3, #0
 800114a:	60fb      	str	r3, [r7, #12]
 800114c:	e006      	b.n	800115c <erase_flash+0xa8>
  else {
    printf("wrong address\n\r", 0x0);
 800114e:	2100      	movs	r1, #0
 8001150:	4830      	ldr	r0, [pc, #192]	@ (8001214 <erase_flash+0x160>)
 8001152:	f7ff fb83 	bl	800085c <printf>
    return -1;
 8001156:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 800115a:	e044      	b.n	80011e6 <erase_flash+0x132>
  }
  // unlock
  FLASH->KEYR = KEY1;
 800115c:	4b2e      	ldr	r3, [pc, #184]	@ (8001218 <erase_flash+0x164>)
 800115e:	4a2f      	ldr	r2, [pc, #188]	@ (800121c <erase_flash+0x168>)
 8001160:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 8001162:	4b2d      	ldr	r3, [pc, #180]	@ (8001218 <erase_flash+0x164>)
 8001164:	4a2e      	ldr	r2, [pc, #184]	@ (8001220 <erase_flash+0x16c>)
 8001166:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8001168:	4b2b      	ldr	r3, [pc, #172]	@ (8001218 <erase_flash+0x164>)
 800116a:	68db      	ldr	r3, [r3, #12]
 800116c:	4a2a      	ldr	r2, [pc, #168]	@ (8001218 <erase_flash+0x164>)
 800116e:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 8001172:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 8001174:	bf00      	nop
 8001176:	4b28      	ldr	r3, [pc, #160]	@ (8001218 <erase_flash+0x164>)
 8001178:	68db      	ldr	r3, [r3, #12]
 800117a:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 800117e:	2b00      	cmp	r3, #0
 8001180:	d1f9      	bne.n	8001176 <erase_flash+0xc2>
    ;

  FLASH->CR |= FLASH_CR_SER;
 8001182:	4b25      	ldr	r3, [pc, #148]	@ (8001218 <erase_flash+0x164>)
 8001184:	691b      	ldr	r3, [r3, #16]
 8001186:	4a24      	ldr	r2, [pc, #144]	@ (8001218 <erase_flash+0x164>)
 8001188:	f043 0302 	orr.w	r3, r3, #2
 800118c:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(FLASH_CR_SNB);
 800118e:	4b22      	ldr	r3, [pc, #136]	@ (8001218 <erase_flash+0x164>)
 8001190:	691b      	ldr	r3, [r3, #16]
 8001192:	4a21      	ldr	r2, [pc, #132]	@ (8001218 <erase_flash+0x164>)
 8001194:	f023 03f8 	bic.w	r3, r3, #248	@ 0xf8
 8001198:	6113      	str	r3, [r2, #16]
  FLASH->CR |= (sector << FLASH_CR_SNB_Pos);
 800119a:	4b1f      	ldr	r3, [pc, #124]	@ (8001218 <erase_flash+0x164>)
 800119c:	691a      	ldr	r2, [r3, #16]
 800119e:	68fb      	ldr	r3, [r7, #12]
 80011a0:	00db      	lsls	r3, r3, #3
 80011a2:	491d      	ldr	r1, [pc, #116]	@ (8001218 <erase_flash+0x164>)
 80011a4:	4313      	orrs	r3, r2
 80011a6:	610b      	str	r3, [r1, #16]
  FLASH->CR |= FLASH_CR_STRT;
 80011a8:	4b1b      	ldr	r3, [pc, #108]	@ (8001218 <erase_flash+0x164>)
 80011aa:	691b      	ldr	r3, [r3, #16]
 80011ac:	4a1a      	ldr	r2, [pc, #104]	@ (8001218 <erase_flash+0x164>)
 80011ae:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 80011b2:	6113      	str	r3, [r2, #16]

  // wait for the flash to be erased;
  while (FLASH->SR & FLASH_SR_BSY)
 80011b4:	bf00      	nop
 80011b6:	4b18      	ldr	r3, [pc, #96]	@ (8001218 <erase_flash+0x164>)
 80011b8:	68db      	ldr	r3, [r3, #12]
 80011ba:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 80011be:	2b00      	cmp	r3, #0
 80011c0:	d1f9      	bne.n	80011b6 <erase_flash+0x102>
    ;

  // clear the erase bit
  FLASH->CR &= ~(FLASH_CR_SER);
 80011c2:	4b15      	ldr	r3, [pc, #84]	@ (8001218 <erase_flash+0x164>)
 80011c4:	691b      	ldr	r3, [r3, #16]
 80011c6:	4a14      	ldr	r2, [pc, #80]	@ (8001218 <erase_flash+0x164>)
 80011c8:	f023 0302 	bic.w	r3, r3, #2
 80011cc:	6113      	str	r3, [r2, #16]
  // lock the control register
  FLASH->CR |= FLASH_CR_LOCK;
 80011ce:	4b12      	ldr	r3, [pc, #72]	@ (8001218 <erase_flash+0x164>)
 80011d0:	691b      	ldr	r3, [r3, #16]
 80011d2:	4a11      	ldr	r2, [pc, #68]	@ (8001218 <erase_flash+0x164>)
 80011d4:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 80011d8:	6113      	str	r3, [r2, #16]

  printf("done erasing flash (address = %)\n\r", (uint32_t)(&address));
 80011da:	1d3b      	adds	r3, r7, #4
 80011dc:	4619      	mov	r1, r3
 80011de:	4811      	ldr	r0, [pc, #68]	@ (8001224 <erase_flash+0x170>)
 80011e0:	f7ff fb3c 	bl	800085c <printf>
  return 0;
 80011e4:	2300      	movs	r3, #0
}
 80011e6:	4618      	mov	r0, r3
 80011e8:	3710      	adds	r7, #16
 80011ea:	46bd      	mov	sp, r7
 80011ec:	bd80      	pop	{r7, pc}
 80011ee:	bf00      	nop
 80011f0:	0807ffff 	.word	0x0807ffff
 80011f4:	08001be8 	.word	0x08001be8
 80011f8:	0805ffff 	.word	0x0805ffff
 80011fc:	0803ffff 	.word	0x0803ffff
 8001200:	0801ffff 	.word	0x0801ffff
 8001204:	0800ffff 	.word	0x0800ffff
 8001208:	0800c000 	.word	0x0800c000
 800120c:	08008000 	.word	0x08008000
 8001210:	08004000 	.word	0x08004000
 8001214:	08001bfc 	.word	0x08001bfc
 8001218:	40023c00 	.word	0x40023c00
 800121c:	45670123 	.word	0x45670123
 8001220:	cdef89ab 	.word	0xcdef89ab
 8001224:	08001c0c 	.word	0x08001c0c

08001228 <flash_write>:

uint32_t flash_write(uint32_t address, const char *buff, uint32_t size,
                     uint32_t simulate) {
 8001228:	b480      	push	{r7}
 800122a:	b087      	sub	sp, #28
 800122c:	af00      	add	r7, sp, #0
 800122e:	60f8      	str	r0, [r7, #12]
 8001230:	60b9      	str	r1, [r7, #8]
 8001232:	607a      	str	r2, [r7, #4]
 8001234:	603b      	str	r3, [r7, #0]


  // unlock
  FLASH->KEYR = KEY1;
 8001236:	4b26      	ldr	r3, [pc, #152]	@ (80012d0 <flash_write+0xa8>)
 8001238:	4a26      	ldr	r2, [pc, #152]	@ (80012d4 <flash_write+0xac>)
 800123a:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 800123c:	4b24      	ldr	r3, [pc, #144]	@ (80012d0 <flash_write+0xa8>)
 800123e:	4a26      	ldr	r2, [pc, #152]	@ (80012d8 <flash_write+0xb0>)
 8001240:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8001242:	4b23      	ldr	r3, [pc, #140]	@ (80012d0 <flash_write+0xa8>)
 8001244:	68db      	ldr	r3, [r3, #12]
 8001246:	4a22      	ldr	r2, [pc, #136]	@ (80012d0 <flash_write+0xa8>)
 8001248:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 800124c:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 800124e:	bf00      	nop
 8001250:	4b1f      	ldr	r3, [pc, #124]	@ (80012d0 <flash_write+0xa8>)
 8001252:	68db      	ldr	r3, [r3, #12]
 8001254:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 8001258:	2b00      	cmp	r3, #0
 800125a:	d1f9      	bne.n	8001250 <flash_write+0x28>
    ;
  FLASH->CR |= FLASH_CR_PG;
 800125c:	4b1c      	ldr	r3, [pc, #112]	@ (80012d0 <flash_write+0xa8>)
 800125e:	691b      	ldr	r3, [r3, #16]
 8001260:	4a1b      	ldr	r2, [pc, #108]	@ (80012d0 <flash_write+0xa8>)
 8001262:	f043 0301 	orr.w	r3, r3, #1
 8001266:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(3 << FLASH_CR_PSIZE_Pos);
 8001268:	4b19      	ldr	r3, [pc, #100]	@ (80012d0 <flash_write+0xa8>)
 800126a:	691b      	ldr	r3, [r3, #16]
 800126c:	4a18      	ldr	r2, [pc, #96]	@ (80012d0 <flash_write+0xa8>)
 800126e:	f423 7340 	bic.w	r3, r3, #768	@ 0x300
 8001272:	6113      	str	r3, [r2, #16]
  // set PSIZE bit to 2 for 32 bit programming
  FLASH->CR |= 2 << FLASH_CR_PSIZE_Pos;
 8001274:	4b16      	ldr	r3, [pc, #88]	@ (80012d0 <flash_write+0xa8>)
 8001276:	691b      	ldr	r3, [r3, #16]
 8001278:	4a15      	ldr	r2, [pc, #84]	@ (80012d0 <flash_write+0xa8>)
 800127a:	f443 7300 	orr.w	r3, r3, #512	@ 0x200
 800127e:	6113      	str	r3, [r2, #16]

  uint32_t i = 0;
 8001280:	2300      	movs	r3, #0
 8001282:	617b      	str	r3, [r7, #20]
  while (i < size / 4) {
 8001284:	e00c      	b.n	80012a0 <flash_write+0x78>

    *((uint32_t *)address) = ((const uint32_t *)buff)[i];
 8001286:	697b      	ldr	r3, [r7, #20]
 8001288:	009b      	lsls	r3, r3, #2
 800128a:	68ba      	ldr	r2, [r7, #8]
 800128c:	441a      	add	r2, r3
 800128e:	68fb      	ldr	r3, [r7, #12]
 8001290:	6812      	ldr	r2, [r2, #0]
 8001292:	601a      	str	r2, [r3, #0]
    i++;
 8001294:	697b      	ldr	r3, [r7, #20]
 8001296:	3301      	adds	r3, #1
 8001298:	617b      	str	r3, [r7, #20]
    address += 4;
 800129a:	68fb      	ldr	r3, [r7, #12]
 800129c:	3304      	adds	r3, #4
 800129e:	60fb      	str	r3, [r7, #12]
  while (i < size / 4) {
 80012a0:	687b      	ldr	r3, [r7, #4]
 80012a2:	089b      	lsrs	r3, r3, #2
 80012a4:	697a      	ldr	r2, [r7, #20]
 80012a6:	429a      	cmp	r2, r3
 80012a8:	d3ed      	bcc.n	8001286 <flash_write+0x5e>
  }
  FLASH->CR &= ~(FLASH_CR_PG);
 80012aa:	4b09      	ldr	r3, [pc, #36]	@ (80012d0 <flash_write+0xa8>)
 80012ac:	691b      	ldr	r3, [r3, #16]
 80012ae:	4a08      	ldr	r2, [pc, #32]	@ (80012d0 <flash_write+0xa8>)
 80012b0:	f023 0301 	bic.w	r3, r3, #1
 80012b4:	6113      	str	r3, [r2, #16]
  FLASH->CR |= FLASH_CR_LOCK;
 80012b6:	4b06      	ldr	r3, [pc, #24]	@ (80012d0 <flash_write+0xa8>)
 80012b8:	691b      	ldr	r3, [r3, #16]
 80012ba:	4a05      	ldr	r2, [pc, #20]	@ (80012d0 <flash_write+0xa8>)
 80012bc:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 80012c0:	6113      	str	r3, [r2, #16]

  return 0;
 80012c2:	2300      	movs	r3, #0
}
 80012c4:	4618      	mov	r0, r3
 80012c6:	371c      	adds	r7, #28
 80012c8:	46bd      	mov	sp, r7
 80012ca:	bc80      	pop	{r7}
 80012cc:	4770      	bx	lr
 80012ce:	bf00      	nop
 80012d0:	40023c00 	.word	0x40023c00
 80012d4:	45670123 	.word	0x45670123
 80012d8:	cdef89ab 	.word	0xcdef89ab

080012dc <__NVIC_EnableIRQ>:
{
 80012dc:	b480      	push	{r7}
 80012de:	b083      	sub	sp, #12
 80012e0:	af00      	add	r7, sp, #0
 80012e2:	4603      	mov	r3, r0
 80012e4:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 80012e6:	f997 3007 	ldrsb.w	r3, [r7, #7]
 80012ea:	2b00      	cmp	r3, #0
 80012ec:	db0b      	blt.n	8001306 <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 80012ee:	79fb      	ldrb	r3, [r7, #7]
 80012f0:	f003 021f 	and.w	r2, r3, #31
 80012f4:	4906      	ldr	r1, [pc, #24]	@ (8001310 <__NVIC_EnableIRQ+0x34>)
 80012f6:	f997 3007 	ldrsb.w	r3, [r7, #7]
 80012fa:	095b      	lsrs	r3, r3, #5
 80012fc:	2001      	movs	r0, #1
 80012fe:	fa00 f202 	lsl.w	r2, r0, r2
 8001302:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 8001306:	bf00      	nop
 8001308:	370c      	adds	r7, #12
 800130a:	46bd      	mov	sp, r7
 800130c:	bc80      	pop	{r7}
 800130e:	4770      	bx	lr
 8001310:	e000e100 	.word	0xe000e100

08001314 <__usart1_scan>:
#include "stm32f401xe.h"

#define TX_PIN 9
#define RX_PIN 10

void __usart1_scan (char* buffer, uint16_t size){
 8001314:	b480      	push	{r7}
 8001316:	b085      	sub	sp, #20
 8001318:	af00      	add	r7, sp, #0
 800131a:	6078      	str	r0, [r7, #4]
 800131c:	460b      	mov	r3, r1
 800131e:	807b      	strh	r3, [r7, #2]
  
  uint16_t i = 0;
 8001320:	2300      	movs	r3, #0
 8001322:	81fb      	strh	r3, [r7, #14]
  while (i < size) {
 8001324:	e010      	b.n	8001348 <__usart1_scan+0x34>
    // wait
    while (!(USART1->SR & USART_SR_RXNE))
 8001326:	bf00      	nop
 8001328:	4b0c      	ldr	r3, [pc, #48]	@ (800135c <__usart1_scan+0x48>)
 800132a:	681b      	ldr	r3, [r3, #0]
 800132c:	f003 0320 	and.w	r3, r3, #32
 8001330:	2b00      	cmp	r3, #0
 8001332:	d0f9      	beq.n	8001328 <__usart1_scan+0x14>
      ;
    buffer[i++] = USART1->DR;
 8001334:	4b09      	ldr	r3, [pc, #36]	@ (800135c <__usart1_scan+0x48>)
 8001336:	685a      	ldr	r2, [r3, #4]
 8001338:	89fb      	ldrh	r3, [r7, #14]
 800133a:	1c59      	adds	r1, r3, #1
 800133c:	81f9      	strh	r1, [r7, #14]
 800133e:	4619      	mov	r1, r3
 8001340:	687b      	ldr	r3, [r7, #4]
 8001342:	440b      	add	r3, r1
 8001344:	b2d2      	uxtb	r2, r2
 8001346:	701a      	strb	r2, [r3, #0]
  while (i < size) {
 8001348:	89fa      	ldrh	r2, [r7, #14]
 800134a:	887b      	ldrh	r3, [r7, #2]
 800134c:	429a      	cmp	r2, r3
 800134e:	d3ea      	bcc.n	8001326 <__usart1_scan+0x12>
  }
}
 8001350:	bf00      	nop
 8001352:	bf00      	nop
 8001354:	3714      	adds	r7, #20
 8001356:	46bd      	mov	sp, r7
 8001358:	bc80      	pop	{r7}
 800135a:	4770      	bx	lr
 800135c:	40011000 	.word	0x40011000

08001360 <__usart1_init>:

void __usart1_init(void) {
 8001360:	b580      	push	{r7, lr}
 8001362:	af00      	add	r7, sp, #0

  RCC->APB2ENR |= RCC_APB2ENR_USART1EN_Msk;
 8001364:	4b20      	ldr	r3, [pc, #128]	@ (80013e8 <__usart1_init+0x88>)
 8001366:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8001368:	4a1f      	ldr	r2, [pc, #124]	@ (80013e8 <__usart1_init+0x88>)
 800136a:	f043 0310 	orr.w	r3, r3, #16
 800136e:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
 8001370:	4b1d      	ldr	r3, [pc, #116]	@ (80013e8 <__usart1_init+0x88>)
 8001372:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8001374:	4a1c      	ldr	r2, [pc, #112]	@ (80013e8 <__usart1_init+0x88>)
 8001376:	f043 0301 	orr.w	r3, r3, #1
 800137a:	6313      	str	r3, [r2, #48]	@ 0x30
  // alternate function mode
  GPIOA->MODER &= ~((3 << (2 * TX_PIN)) | (3 << (2 * RX_PIN)));
 800137c:	4b1b      	ldr	r3, [pc, #108]	@ (80013ec <__usart1_init+0x8c>)
 800137e:	681b      	ldr	r3, [r3, #0]
 8001380:	4a1a      	ldr	r2, [pc, #104]	@ (80013ec <__usart1_init+0x8c>)
 8001382:	f423 1370 	bic.w	r3, r3, #3932160	@ 0x3c0000
 8001386:	6013      	str	r3, [r2, #0]
  GPIOA->MODER |= 2 << (2 * TX_PIN) | 2 << (2 * RX_PIN);
 8001388:	4b18      	ldr	r3, [pc, #96]	@ (80013ec <__usart1_init+0x8c>)
 800138a:	681b      	ldr	r3, [r3, #0]
 800138c:	4a17      	ldr	r2, [pc, #92]	@ (80013ec <__usart1_init+0x8c>)
 800138e:	f443 1320 	orr.w	r3, r3, #2621440	@ 0x280000
 8001392:	6013      	str	r3, [r2, #0]
  // high speed
  GPIOA->OSPEEDR |= (3 << (TX_PIN * 2)) | (3 << (RX_PIN * 2));
 8001394:	4b15      	ldr	r3, [pc, #84]	@ (80013ec <__usart1_init+0x8c>)
 8001396:	689b      	ldr	r3, [r3, #8]
 8001398:	4a14      	ldr	r2, [pc, #80]	@ (80013ec <__usart1_init+0x8c>)
 800139a:	f443 1370 	orr.w	r3, r3, #3932160	@ 0x3c0000
 800139e:	6093      	str	r3, [r2, #8]
  // clear the bits in AFR register
  GPIOA->AFR[1] &= ~((0xf << 4) | (0xf << 8));
 80013a0:	4b12      	ldr	r3, [pc, #72]	@ (80013ec <__usart1_init+0x8c>)
 80013a2:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80013a4:	4a11      	ldr	r2, [pc, #68]	@ (80013ec <__usart1_init+0x8c>)
 80013a6:	f423 637f 	bic.w	r3, r3, #4080	@ 0xff0
 80013aa:	6253      	str	r3, [r2, #36]	@ 0x24
  // set for af7
  GPIOA->AFR[1] |= (7 << 4) | (7 << 8);
 80013ac:	4b0f      	ldr	r3, [pc, #60]	@ (80013ec <__usart1_init+0x8c>)
 80013ae:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80013b0:	4a0e      	ldr	r2, [pc, #56]	@ (80013ec <__usart1_init+0x8c>)
 80013b2:	f443 63ee 	orr.w	r3, r3, #1904	@ 0x770
 80013b6:	6253      	str	r3, [r2, #36]	@ 0x24

  // set the baud rate (115200 in this case)
  USART1->BRR = 0x08B;
 80013b8:	4b0d      	ldr	r3, [pc, #52]	@ (80013f0 <__usart1_init+0x90>)
 80013ba:	228b      	movs	r2, #139	@ 0x8b
 80013bc:	609a      	str	r2, [r3, #8]

  // enable usart reciever interrupt;
  USART1->CR1 = USART_CR1_RXNEIE;
 80013be:	4b0c      	ldr	r3, [pc, #48]	@ (80013f0 <__usart1_init+0x90>)
 80013c0:	2220      	movs	r2, #32
 80013c2:	60da      	str	r2, [r3, #12]

  NVIC_EnableIRQ (USART1_IRQn);
 80013c4:	2025      	movs	r0, #37	@ 0x25
 80013c6:	f7ff ff89 	bl	80012dc <__NVIC_EnableIRQ>

  // enable transmitter and reciever at the end
  USART1->CR1 |= USART_CR1_RE | USART_CR1_TE;
 80013ca:	4b09      	ldr	r3, [pc, #36]	@ (80013f0 <__usart1_init+0x90>)
 80013cc:	68db      	ldr	r3, [r3, #12]
 80013ce:	4a08      	ldr	r2, [pc, #32]	@ (80013f0 <__usart1_init+0x90>)
 80013d0:	f043 030c 	orr.w	r3, r3, #12
 80013d4:	60d3      	str	r3, [r2, #12]

  // enable usart
  USART1->CR1 |= USART_CR1_UE;
 80013d6:	4b06      	ldr	r3, [pc, #24]	@ (80013f0 <__usart1_init+0x90>)
 80013d8:	68db      	ldr	r3, [r3, #12]
 80013da:	4a05      	ldr	r2, [pc, #20]	@ (80013f0 <__usart1_init+0x90>)
 80013dc:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 80013e0:	60d3      	str	r3, [r2, #12]

}
 80013e2:	bf00      	nop
 80013e4:	bd80      	pop	{r7, pc}
 80013e6:	bf00      	nop
 80013e8:	40023800 	.word	0x40023800
 80013ec:	40020000 	.word	0x40020000
 80013f0:	40011000 	.word	0x40011000

080013f4 <__usart1_print>:

void __usart1_print(const char *msg, uint32_t size) {
 80013f4:	b480      	push	{r7}
 80013f6:	b085      	sub	sp, #20
 80013f8:	af00      	add	r7, sp, #0
 80013fa:	6078      	str	r0, [r7, #4]
 80013fc:	6039      	str	r1, [r7, #0]

  int i = 0;
 80013fe:	2300      	movs	r3, #0
 8001400:	60fb      	str	r3, [r7, #12]
  while (i < size && msg[i] != '\0') {
 8001402:	e00f      	b.n	8001424 <__usart1_print+0x30>
    while (!(USART1->SR & USART_SR_TXE))
 8001404:	bf00      	nop
 8001406:	4b13      	ldr	r3, [pc, #76]	@ (8001454 <__usart1_print+0x60>)
 8001408:	681b      	ldr	r3, [r3, #0]
 800140a:	f003 0380 	and.w	r3, r3, #128	@ 0x80
 800140e:	2b00      	cmp	r3, #0
 8001410:	d0f9      	beq.n	8001406 <__usart1_print+0x12>
      ;
    USART1->DR = msg[i++];
 8001412:	68fb      	ldr	r3, [r7, #12]
 8001414:	1c5a      	adds	r2, r3, #1
 8001416:	60fa      	str	r2, [r7, #12]
 8001418:	461a      	mov	r2, r3
 800141a:	687b      	ldr	r3, [r7, #4]
 800141c:	4413      	add	r3, r2
 800141e:	781a      	ldrb	r2, [r3, #0]
 8001420:	4b0c      	ldr	r3, [pc, #48]	@ (8001454 <__usart1_print+0x60>)
 8001422:	605a      	str	r2, [r3, #4]
  while (i < size && msg[i] != '\0') {
 8001424:	68fb      	ldr	r3, [r7, #12]
 8001426:	683a      	ldr	r2, [r7, #0]
 8001428:	429a      	cmp	r2, r3
 800142a:	d905      	bls.n	8001438 <__usart1_print+0x44>
 800142c:	68fb      	ldr	r3, [r7, #12]
 800142e:	687a      	ldr	r2, [r7, #4]
 8001430:	4413      	add	r3, r2
 8001432:	781b      	ldrb	r3, [r3, #0]
 8001434:	2b00      	cmp	r3, #0
 8001436:	d1e5      	bne.n	8001404 <__usart1_print+0x10>
  }
  while (!(USART1->SR & USART_SR_TC)) {
 8001438:	bf00      	nop
 800143a:	4b06      	ldr	r3, [pc, #24]	@ (8001454 <__usart1_print+0x60>)
 800143c:	681b      	ldr	r3, [r3, #0]
 800143e:	f003 0340 	and.w	r3, r3, #64	@ 0x40
 8001442:	2b00      	cmp	r3, #0
 8001444:	d0f9      	beq.n	800143a <__usart1_print+0x46>
  }
}
 8001446:	bf00      	nop
 8001448:	bf00      	nop
 800144a:	3714      	adds	r7, #20
 800144c:	46bd      	mov	sp, r7
 800144e:	bc80      	pop	{r7}
 8001450:	4770      	bx	lr
 8001452:	bf00      	nop
 8001454:	40011000 	.word	0x40011000

08001458 <Reset_Handler>:
 8001458:	480c      	ldr	r0, [pc, #48]	@ (800148c <hang+0x4>)
 800145a:	490d      	ldr	r1, [pc, #52]	@ (8001490 <hang+0x8>)
 800145c:	4a0d      	ldr	r2, [pc, #52]	@ (8001494 <hang+0xc>)
 800145e:	e7ff      	b.n	8001460 <copy>

08001460 <copy>:
 8001460:	4288      	cmp	r0, r1
 8001462:	db04      	blt.n	800146e <copy_helper>
 8001464:	480c      	ldr	r0, [pc, #48]	@ (8001498 <hang+0x10>)
 8001466:	490d      	ldr	r1, [pc, #52]	@ (800149c <hang+0x14>)
 8001468:	f04f 0200 	mov.w	r2, #0
 800146c:	e004      	b.n	8001478 <init_zero>

0800146e <copy_helper>:
 800146e:	f852 3b04 	ldr.w	r3, [r2], #4
 8001472:	f840 3b04 	str.w	r3, [r0], #4
 8001476:	e7f3      	b.n	8001460 <copy>

08001478 <init_zero>:
 8001478:	4288      	cmp	r0, r1
 800147a:	db00      	blt.n	800147e <init_zero_helper>
 800147c:	e002      	b.n	8001484 <call_entry>

0800147e <init_zero_helper>:
 800147e:	f840 2b04 	str.w	r2, [r0], #4
 8001482:	e7f9      	b.n	8001478 <init_zero>

08001484 <call_entry>:
 8001484:	f7ff bd4e 	b.w	8000f24 <main>

08001488 <hang>:
 8001488:	e7fe      	b.n	8001488 <hang>
 800148a:	0000      	.short	0x0000
 800148c:	20000000 	.word	0x20000000
 8001490:	20000005 	.word	0x20000005
 8001494:	08001c2f 	.word	0x08001c2f
 8001498:	20000008 	.word	0x20000008
 800149c:	20005084 	.word	0x20005084

080014a0 <EXTI15_10_IRQ_handler>:
 80014a0:	f7ff b8f4 	b.w	800068c <switch_pressed>

080014a4 <Default_Handler>:
 80014a4:	e7fe      	b.n	80014a4 <Default_Handler>

080014a6 <BusFault_Handler>:
 80014a6:	f3ef 8008 	mrs	r0, MSP
 80014aa:	6980      	ldr	r0, [r0, #24]
 80014ac:	f04f 0100 	mov.w	r1, #0
 80014b0:	b500      	push	{lr}
 80014b2:	f7fe fe43 	bl	800013c <fault_handler_helper>
 80014b6:	f85d eb04 	ldr.w	lr, [sp], #4
 80014ba:	4770      	bx	lr

080014bc <MemManage_Handler>:
 80014bc:	f3ef 8008 	mrs	r0, MSP
 80014c0:	6980      	ldr	r0, [r0, #24]
 80014c2:	f04f 0101 	mov.w	r1, #1
 80014c6:	b500      	push	{lr}
 80014c8:	f7fe fe38 	bl	800013c <fault_handler_helper>
 80014cc:	f85d eb04 	ldr.w	lr, [sp], #4
 80014d0:	4770      	bx	lr

080014d2 <UsageFault_Handler>:
 80014d2:	f3ef 8008 	mrs	r0, MSP
 80014d6:	6980      	ldr	r0, [r0, #24]
 80014d8:	f04f 0102 	mov.w	r1, #2
 80014dc:	b500      	push	{lr}
 80014de:	f7fe fe2d 	bl	800013c <fault_handler_helper>
 80014e2:	f85d eb04 	ldr.w	lr, [sp], #4
 80014e6:	4770      	bx	lr

080014e8 <HardFault_Handler>:
 80014e8:	f3ef 8008 	mrs	r0, MSP
 80014ec:	6980      	ldr	r0, [r0, #24]
 80014ee:	4904      	ldr	r1, [pc, #16]	@ (8001500 <HardFault_Handler+0x18>)
 80014f0:	f381 8808 	msr	MSP, r1
 80014f4:	b500      	push	{lr}
 80014f6:	f7fe fe83 	bl	8000200 <HardFault_Handler_helper>
 80014fa:	f85d eb04 	ldr.w	lr, [sp], #4
 80014fe:	e7fe      	b.n	80014fe <HardFault_Handler+0x16>
 8001500:	20017000 	.word	0x20017000

08001504 <SVC_Handler>:
 8001504:	e7fe      	b.n	8001504 <SVC_Handler>

08001506 <SysTick_Handler>:
 8001506:	e7fe      	b.n	8001506 <SysTick_Handler>

08001508 <PendSV_Handler>:
 8001508:	e7fe      	b.n	8001508 <PendSV_Handler>

0800150a <NMI_Handler>:
 800150a:	e7fe      	b.n	800150a <NMI_Handler>

0800150c <DebugMon_Handler>:
 800150c:	e7fe      	b.n	800150c <DebugMon_Handler>

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
 8000154:	f000 fb82 	bl	800085c <printf>
    if (SCB->CFSR & SCB_CFSR_BFARVALID_Msk)
 8000158:	4b1f      	ldr	r3, [pc, #124]	@ (80001d8 <fault_handler_helper+0x9c>)
 800015a:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 800015c:	f403 4300 	and.w	r3, r3, #32768	@ 0x8000
 8000160:	2b00      	cmp	r3, #0
 8000162:	d01f      	beq.n	80001a4 <fault_handler_helper+0x68>
      printf("busfault address -> %\n\r", (uint32_t)(&SCB->BFAR));
 8000164:	491d      	ldr	r1, [pc, #116]	@ (80001dc <fault_handler_helper+0xa0>)
 8000166:	481e      	ldr	r0, [pc, #120]	@ (80001e0 <fault_handler_helper+0xa4>)
 8000168:	f000 fb78 	bl	800085c <printf>
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
 8000178:	f000 fb70 	bl	800085c <printf>
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
 8000190:	f000 fb64 	bl	800085c <printf>
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
 80001a0:	f000 fb5c 	bl	800085c <printf>
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
 80001ae:	f000 fb55 	bl	800085c <printf>
         (uint32_t)(&SCB->CFSR));
  printf("PC -> %\n\r", (uint32_t)&pc);
 80001b2:	f107 030c 	add.w	r3, r7, #12
 80001b6:	4619      	mov	r1, r3
 80001b8:	480f      	ldr	r0, [pc, #60]	@ (80001f8 <fault_handler_helper+0xbc>)
 80001ba:	f000 fb4f 	bl	800085c <printf>
  printf("instruction that caused the fault-> %\n\r", (uint32_t)(&instruction));
 80001be:	f107 0314 	add.w	r3, r7, #20
 80001c2:	4619      	mov	r1, r3
 80001c4:	480d      	ldr	r0, [pc, #52]	@ (80001fc <fault_handler_helper+0xc0>)
 80001c6:	f000 fb49 	bl	800085c <printf>


  /* cannot recover */
  while (1);
 80001ca:	e7fe      	b.n	80001ca <fault_handler_helper+0x8e>
    return;
 80001cc:	bf00      	nop


}
 80001ce:	3718      	adds	r7, #24
 80001d0:	46bd      	mov	sp, r7
 80001d2:	bd80      	pop	{r7, pc}
 80001d4:	08001530 	.word	0x08001530
 80001d8:	e000ed00 	.word	0xe000ed00
 80001dc:	e000ed38 	.word	0xe000ed38
 80001e0:	08001540 	.word	0x08001540
 80001e4:	08001558 	.word	0x08001558
 80001e8:	08001578 	.word	0x08001578
 80001ec:	080015a0 	.word	0x080015a0
 80001f0:	e000ed28 	.word	0xe000ed28
 80001f4:	080015b0 	.word	0x080015b0
 80001f8:	080015e0 	.word	0x080015e0
 80001fc:	080015ec 	.word	0x080015ec

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
 8000212:	f000 fb23 	bl	800085c <printf>
  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
 8000216:	490b      	ldr	r1, [pc, #44]	@ (8000244 <HardFault_Handler_helper+0x44>)
 8000218:	480b      	ldr	r0, [pc, #44]	@ (8000248 <HardFault_Handler_helper+0x48>)
 800021a:	f000 fb1f 	bl	800085c <printf>
         (uint32_t)(&SCB->CFSR));
  printf("Hard Fault Status Register -> %\n\r", (uint32_t)(&SCB->HFSR));
 800021e:	490b      	ldr	r1, [pc, #44]	@ (800024c <HardFault_Handler_helper+0x4c>)
 8000220:	480b      	ldr	r0, [pc, #44]	@ (8000250 <HardFault_Handler_helper+0x50>)
 8000222:	f000 fb1b 	bl	800085c <printf>
  printf("PC -> %\n\r", (uint32_t)(&pc));
 8000226:	1d3b      	adds	r3, r7, #4
 8000228:	4619      	mov	r1, r3
 800022a:	480a      	ldr	r0, [pc, #40]	@ (8000254 <HardFault_Handler_helper+0x54>)
 800022c:	f000 fb16 	bl	800085c <printf>
  printf("instruction that triggered HardFault -> %\n\r",
 8000230:	f107 030c 	add.w	r3, r7, #12
 8000234:	4619      	mov	r1, r3
 8000236:	4808      	ldr	r0, [pc, #32]	@ (8000258 <HardFault_Handler_helper+0x58>)
 8000238:	f000 fb10 	bl	800085c <printf>
         (uint32_t)&instruction);

  /* cannot recover */
  while (1);
 800023c:	e7fe      	b.n	800023c <HardFault_Handler_helper+0x3c>
 800023e:	bf00      	nop
 8000240:	08001614 	.word	0x08001614
 8000244:	e000ed28 	.word	0xe000ed28
 8000248:	080015b0 	.word	0x080015b0
 800024c:	e000ed2c 	.word	0xe000ed2c
 8000250:	08001628 	.word	0x08001628
 8000254:	080015e0 	.word	0x080015e0
 8000258:	0800164c 	.word	0x0800164c

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
 80002bc:	f000 face 	bl	800085c <printf>

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
 800030c:	f000 faa6 	bl	800085c <printf>
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
 8000364:	08001678 	.word	0x08001678
 8000368:	e000e100 	.word	0xe000e100
 800036c:	20000008 	.word	0x20000008
 8000370:	e000ed00 	.word	0xe000ed00
 8000374:	08001690 	.word	0x08001690
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

08000508 <validate_vtable>:
#include "core.h"
#include <stdint.h>

bool validate_vtable(firmware_t *f) {
 8000508:	b580      	push	{r7, lr}
 800050a:	b08a      	sub	sp, #40	@ 0x28
 800050c:	af00      	add	r7, sp, #0
 800050e:	6078      	str	r0, [r7, #4]

  // vtable end is the next free address
  // check from address ------->    [vtable_start, vtable_end)
  
  // vtable must be 128byte aligned => last 7 bits must be 0 (for stm32f401re)
  if (f->__vtable_address & ((1 << 7) - 1)) {
 8000510:	687b      	ldr	r3, [r7, #4]
 8000512:	695b      	ldr	r3, [r3, #20]
 8000514:	f003 037f 	and.w	r3, r3, #127	@ 0x7f
 8000518:	2b00      	cmp	r3, #0
 800051a:	d005      	beq.n	8000528 <validate_vtable+0x20>
    printf("the vector table is not 128byte aligned !!!\n\r", 0x0);
 800051c:	2100      	movs	r1, #0
 800051e:	4839      	ldr	r0, [pc, #228]	@ (8000604 <validate_vtable+0xfc>)
 8000520:	f000 f99c 	bl	800085c <printf>
    return false;
 8000524:	2300      	movs	r3, #0
 8000526:	e068      	b.n	80005fa <validate_vtable+0xf2>

  // all the "end" addresses are next free address => there should not be any
  // data in the "end" address !! all the addresses must lie in the range
  // [start, end)

  uint32_t RAM_start = 0x20000000;
 8000528:	f04f 5300 	mov.w	r3, #536870912	@ 0x20000000
 800052c:	623b      	str	r3, [r7, #32]
  uint32_t RAM_size = 96 * 1024; // 96kB
 800052e:	f44f 33c0 	mov.w	r3, #98304	@ 0x18000
 8000532:	61fb      	str	r3, [r7, #28]
  uint32_t RAM_end = RAM_start + RAM_size;
 8000534:	6a3a      	ldr	r2, [r7, #32]
 8000536:	69fb      	ldr	r3, [r7, #28]
 8000538:	4413      	add	r3, r2
 800053a:	61bb      	str	r3, [r7, #24]
  uint32_t FLASH_start = f->__vtable_address;
 800053c:	687b      	ldr	r3, [r7, #4]
 800053e:	695b      	ldr	r3, [r3, #20]
 8000540:	617b      	str	r3, [r7, #20]
  uint32_t FLASH_size;
  if (f->__base_address == FIRMWARE_1_ADDRESS)
 8000542:	687b      	ldr	r3, [r7, #4]
 8000544:	681b      	ldr	r3, [r3, #0]
 8000546:	4a30      	ldr	r2, [pc, #192]	@ (8000608 <validate_vtable+0x100>)
 8000548:	4293      	cmp	r3, r2
 800054a:	d103      	bne.n	8000554 <validate_vtable+0x4c>
    FLASH_size = f->__firmware_size;
 800054c:	687b      	ldr	r3, [r7, #4]
 800054e:	69db      	ldr	r3, [r3, #28]
 8000550:	613b      	str	r3, [r7, #16]
 8000552:	e00e      	b.n	8000572 <validate_vtable+0x6a>
  else if (f->__base_address == FIRMWARE_2_ADDRESS)
 8000554:	687b      	ldr	r3, [r7, #4]
 8000556:	681b      	ldr	r3, [r3, #0]
 8000558:	4a2c      	ldr	r2, [pc, #176]	@ (800060c <validate_vtable+0x104>)
 800055a:	4293      	cmp	r3, r2
 800055c:	d103      	bne.n	8000566 <validate_vtable+0x5e>
    FLASH_size = f->__firmware_size;
 800055e:	687b      	ldr	r3, [r7, #4]
 8000560:	69db      	ldr	r3, [r3, #28]
 8000562:	613b      	str	r3, [r7, #16]
 8000564:	e005      	b.n	8000572 <validate_vtable+0x6a>
  else {
    printf("update _base address is not valid\n\r", 0x0);
 8000566:	2100      	movs	r1, #0
 8000568:	4829      	ldr	r0, [pc, #164]	@ (8000610 <validate_vtable+0x108>)
 800056a:	f000 f977 	bl	800085c <printf>
    return false;
 800056e:	2300      	movs	r3, #0
 8000570:	e043      	b.n	80005fa <validate_vtable+0xf2>
  }
  uint32_t FLASH_end = f->__firmware_end;
 8000572:	687b      	ldr	r3, [r7, #4]
 8000574:	699b      	ldr	r3, [r3, #24]
 8000576:	60fb      	str	r3, [r7, #12]

  /*************************msp check*********************/
  
  // MSP value can be RAM end as MSP grows downword;
  if (f->__msp_value > RAM_end || f->__msp_value < RAM_start) {
 8000578:	687b      	ldr	r3, [r7, #4]
 800057a:	6a1b      	ldr	r3, [r3, #32]
 800057c:	69ba      	ldr	r2, [r7, #24]
 800057e:	429a      	cmp	r2, r3
 8000580:	d304      	bcc.n	800058c <validate_vtable+0x84>
 8000582:	687b      	ldr	r3, [r7, #4]
 8000584:	6a1b      	ldr	r3, [r3, #32]
 8000586:	6a3a      	ldr	r2, [r7, #32]
 8000588:	429a      	cmp	r2, r3
 800058a:	d90b      	bls.n	80005a4 <validate_vtable+0x9c>

      printf ("MSP value is -> %\n\r", (uint32_t)(&(f->__msp_value)));
 800058c:	687b      	ldr	r3, [r7, #4]
 800058e:	3320      	adds	r3, #32
 8000590:	4619      	mov	r1, r3
 8000592:	4820      	ldr	r0, [pc, #128]	@ (8000614 <validate_vtable+0x10c>)
 8000594:	f000 f962 	bl	800085c <printf>
    printf("MSP value is invalid\n\r", 0x0);
 8000598:	2100      	movs	r1, #0
 800059a:	481f      	ldr	r0, [pc, #124]	@ (8000618 <validate_vtable+0x110>)
 800059c:	f000 f95e 	bl	800085c <printf>
    return false;
 80005a0:	2300      	movs	r3, #0
 80005a2:	e02a      	b.n	80005fa <validate_vtable+0xf2>
  }
  // msp value must be word aligned !!!
  if (f->__msp_value & 3) {
 80005a4:	687b      	ldr	r3, [r7, #4]
 80005a6:	6a1b      	ldr	r3, [r3, #32]
 80005a8:	f003 0303 	and.w	r3, r3, #3
 80005ac:	2b00      	cmp	r3, #0
 80005ae:	d005      	beq.n	80005bc <validate_vtable+0xb4>
    printf("MSP value is not word aligned\n\r", 0x0);
 80005b0:	2100      	movs	r1, #0
 80005b2:	481a      	ldr	r0, [pc, #104]	@ (800061c <validate_vtable+0x114>)
 80005b4:	f000 f952 	bl	800085c <printf>
    return false;
 80005b8:	2300      	movs	r3, #0
 80005ba:	e01e      	b.n	80005fa <validate_vtable+0xf2>
  }

  /************************ vtable check************************/

  for (uint32_t vtable_entry = f->__vtable_address + 0x4;
 80005bc:	687b      	ldr	r3, [r7, #4]
 80005be:	695b      	ldr	r3, [r3, #20]
 80005c0:	3304      	adds	r3, #4
 80005c2:	627b      	str	r3, [r7, #36]	@ 0x24
 80005c4:	e013      	b.n	80005ee <validate_vtable+0xe6>
       vtable_entry < f->__vtable_end; vtable_entry += 4) {

    uint32_t FLASH_address =
        *((uint32_t *)vtable_entry); // peek inside vtable_entry
 80005c6:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
    uint32_t FLASH_address =
 80005c8:	681b      	ldr	r3, [r3, #0]
 80005ca:	60bb      	str	r3, [r7, #8]
    if (FLASH_address >= FLASH_end || FLASH_address < FLASH_start) {
 80005cc:	68ba      	ldr	r2, [r7, #8]
 80005ce:	68fb      	ldr	r3, [r7, #12]
 80005d0:	429a      	cmp	r2, r3
 80005d2:	d203      	bcs.n	80005dc <validate_vtable+0xd4>
 80005d4:	68ba      	ldr	r2, [r7, #8]
 80005d6:	697b      	ldr	r3, [r7, #20]
 80005d8:	429a      	cmp	r2, r3
 80005da:	d205      	bcs.n	80005e8 <validate_vtable+0xe0>

      printf("% ---- in vtable entry does not exist in the allowed flash "
 80005dc:	6a79      	ldr	r1, [r7, #36]	@ 0x24
 80005de:	4810      	ldr	r0, [pc, #64]	@ (8000620 <validate_vtable+0x118>)
 80005e0:	f000 f93c 	bl	800085c <printf>
             "range\n\r", vtable_entry);
      return false;
 80005e4:	2300      	movs	r3, #0
 80005e6:	e008      	b.n	80005fa <validate_vtable+0xf2>
       vtable_entry < f->__vtable_end; vtable_entry += 4) {
 80005e8:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80005ea:	3304      	adds	r3, #4
 80005ec:	627b      	str	r3, [r7, #36]	@ 0x24
 80005ee:	687b      	ldr	r3, [r7, #4]
 80005f0:	68db      	ldr	r3, [r3, #12]
 80005f2:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
 80005f4:	429a      	cmp	r2, r3
 80005f6:	d3e6      	bcc.n	80005c6 <validate_vtable+0xbe>
    }
  }

  return true;
 80005f8:	2301      	movs	r3, #1
}
 80005fa:	4618      	mov	r0, r3
 80005fc:	3728      	adds	r7, #40	@ 0x28
 80005fe:	46bd      	mov	sp, r7
 8000600:	bd80      	pop	{r7, pc}
 8000602:	bf00      	nop
 8000604:	080016a8 	.word	0x080016a8
 8000608:	08010000 	.word	0x08010000
 800060c:	08020000 	.word	0x08020000
 8000610:	080016d8 	.word	0x080016d8
 8000614:	080016fc 	.word	0x080016fc
 8000618:	08001710 	.word	0x08001710
 800061c:	08001728 	.word	0x08001728
 8000620:	08001748 	.word	0x08001748

08000624 <validate_firmware>:

bool validate_firmware(firmware_t *f) {
 8000624:	b580      	push	{r7, lr}
 8000626:	b084      	sub	sp, #16
 8000628:	af00      	add	r7, sp, #0
 800062a:	6078      	str	r0, [r7, #4]

  if (!validate_vtable(f)) {
 800062c:	6878      	ldr	r0, [r7, #4]
 800062e:	f7ff ff6b 	bl	8000508 <validate_vtable>
 8000632:	4603      	mov	r3, r0
 8000634:	f083 0301 	eor.w	r3, r3, #1
 8000638:	b2db      	uxtb	r3, r3
 800063a:	2b00      	cmp	r3, #0
 800063c:	d005      	beq.n	800064a <validate_firmware+0x26>
    printf("vector table of the update is not valid\n\r", 0x0);
 800063e:	2100      	movs	r1, #0
 8000640:	480f      	ldr	r0, [pc, #60]	@ (8000680 <validate_firmware+0x5c>)
 8000642:	f000 f90b 	bl	800085c <printf>
    return false;
 8000646:	2300      	movs	r3, #0
 8000648:	e016      	b.n	8000678 <validate_firmware+0x54>
  }

  uint32_t crc_result = crc_calc(f);
 800064a:	6878      	ldr	r0, [r7, #4]
 800064c:	f7ff fd4a 	bl	80000e4 <crc_calc>
 8000650:	4603      	mov	r3, r0
 8000652:	60fb      	str	r3, [r7, #12]
  printf("crc value is -> %\n\r", (uint32_t)(&crc_result));
 8000654:	f107 030c 	add.w	r3, r7, #12
 8000658:	4619      	mov	r1, r3
 800065a:	480a      	ldr	r0, [pc, #40]	@ (8000684 <validate_firmware+0x60>)
 800065c:	f000 f8fe 	bl	800085c <printf>
  if (crc_result != f->__crc) {
 8000660:	687b      	ldr	r3, [r7, #4]
 8000662:	689a      	ldr	r2, [r3, #8]
 8000664:	68fb      	ldr	r3, [r7, #12]
 8000666:	429a      	cmp	r2, r3
 8000668:	d005      	beq.n	8000676 <validate_firmware+0x52>
    printf("CRC failed\n\r", 0x0);
 800066a:	2100      	movs	r1, #0
 800066c:	4806      	ldr	r0, [pc, #24]	@ (8000688 <validate_firmware+0x64>)
 800066e:	f000 f8f5 	bl	800085c <printf>
    return false;
 8000672:	2300      	movs	r3, #0
 8000674:	e000      	b.n	8000678 <validate_firmware+0x54>
  }
  return true;
 8000676:	2301      	movs	r3, #1
}
 8000678:	4618      	mov	r0, r3
 800067a:	3710      	adds	r7, #16
 800067c:	46bd      	mov	sp, r7
 800067e:	bd80      	pop	{r7, pc}
 8000680:	0800178c 	.word	0x0800178c
 8000684:	080017b8 	.word	0x080017b8
 8000688:	080017cc 	.word	0x080017cc

0800068c <switch_pressed>:
extern volatile Ring_buff_t ringbuffer;




void switch_pressed(void){  
 800068c:	b480      	push	{r7}
 800068e:	af00      	add	r7, sp, #0
    // clear the pending status (not done by hardware)
    EXTI-> PR = EXTI_PR_PR13_Msk;
 8000690:	4b0b      	ldr	r3, [pc, #44]	@ (80006c0 <switch_pressed+0x34>)
 8000692:	f44f 5200 	mov.w	r2, #8192	@ 0x2000
 8000696:	615a      	str	r2, [r3, #20]

    press_count++;
 8000698:	4b0a      	ldr	r3, [pc, #40]	@ (80006c4 <switch_pressed+0x38>)
 800069a:	681b      	ldr	r3, [r3, #0]
 800069c:	3301      	adds	r3, #1
 800069e:	4a09      	ldr	r2, [pc, #36]	@ (80006c4 <switch_pressed+0x38>)
 80006a0:	6013      	str	r3, [r2, #0]
    if (press_count == 3){
 80006a2:	4b08      	ldr	r3, [pc, #32]	@ (80006c4 <switch_pressed+0x38>)
 80006a4:	681b      	ldr	r3, [r3, #0]
 80006a6:	2b03      	cmp	r3, #3
 80006a8:	d105      	bne.n	80006b6 <switch_pressed+0x2a>
        delay_count = 100;
 80006aa:	4b07      	ldr	r3, [pc, #28]	@ (80006c8 <switch_pressed+0x3c>)
 80006ac:	2264      	movs	r2, #100	@ 0x64
 80006ae:	601a      	str	r2, [r3, #0]
        recieve_size = true;
 80006b0:	4b06      	ldr	r3, [pc, #24]	@ (80006cc <switch_pressed+0x40>)
 80006b2:	2201      	movs	r2, #1
 80006b4:	701a      	strb	r2, [r3, #0]
        //EXTI-> IMR &= ~EXTI_IMR_MR13_Msk;
    }
}
 80006b6:	bf00      	nop
 80006b8:	46bd      	mov	sp, r7
 80006ba:	bc80      	pop	{r7}
 80006bc:	4770      	bx	lr
 80006be:	bf00      	nop
 80006c0:	40013c00 	.word	0x40013c00
 80006c4:	20000060 	.word	0x20000060
 80006c8:	20000064 	.word	0x20000064
 80006cc:	20005080 	.word	0x20005080

080006d0 <USART1_IRQHandler>:
void USART1_IRQHandler (void){
 80006d0:	b580      	push	{r7, lr}
 80006d2:	b082      	sub	sp, #8
 80006d4:	af00      	add	r7, sp, #0
  if (!firmware_update_mode) return;
 80006d6:	4b26      	ldr	r3, [pc, #152]	@ (8000770 <USART1_IRQHandler+0xa0>)
 80006d8:	781b      	ldrb	r3, [r3, #0]
 80006da:	f083 0301 	eor.w	r3, r3, #1
 80006de:	b2db      	uxtb	r3, r3
 80006e0:	2b00      	cmp	r3, #0
 80006e2:	d141      	bne.n	8000768 <USART1_IRQHandler+0x98>
  if (USART1 -> SR & USART_SR_RXNE_Msk){
 80006e4:	4b23      	ldr	r3, [pc, #140]	@ (8000774 <USART1_IRQHandler+0xa4>)
 80006e6:	681b      	ldr	r3, [r3, #0]
 80006e8:	f003 0320 	and.w	r3, r3, #32
 80006ec:	2b00      	cmp	r3, #0
 80006ee:	d03c      	beq.n	800076a <USART1_IRQHandler+0x9a>
    if (recieve_size){
 80006f0:	4b21      	ldr	r3, [pc, #132]	@ (8000778 <USART1_IRQHandler+0xa8>)
 80006f2:	781b      	ldrb	r3, [r3, #0]
 80006f4:	b2db      	uxtb	r3, r3
 80006f6:	2b00      	cmp	r3, #0
 80006f8:	d02b      	beq.n	8000752 <USART1_IRQHandler+0x82>
      char digit = '\0';
 80006fa:	2300      	movs	r3, #0
 80006fc:	71fb      	strb	r3, [r7, #7]
      digit = USART1-> DR;
 80006fe:	4b1d      	ldr	r3, [pc, #116]	@ (8000774 <USART1_IRQHandler+0xa4>)
 8000700:	685b      	ldr	r3, [r3, #4]
 8000702:	71fb      	strb	r3, [r7, #7]
      if (digit == '\n'){
 8000704:	79fb      	ldrb	r3, [r7, #7]
 8000706:	2b0a      	cmp	r3, #10
 8000708:	d103      	bne.n	8000712 <USART1_IRQHandler+0x42>
        flag_size_recieved = true;
 800070a:	4b1c      	ldr	r3, [pc, #112]	@ (800077c <USART1_IRQHandler+0xac>)
 800070c:	2201      	movs	r2, #1
 800070e:	701a      	strb	r2, [r3, #0]
        return;
 8000710:	e02b      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      if (digit < '0' || digit > '9'){
 8000712:	79fb      	ldrb	r3, [r7, #7]
 8000714:	2b2f      	cmp	r3, #47	@ 0x2f
 8000716:	d902      	bls.n	800071e <USART1_IRQHandler+0x4e>
 8000718:	79fb      	ldrb	r3, [r7, #7]
 800071a:	2b39      	cmp	r3, #57	@ 0x39
 800071c:	d903      	bls.n	8000726 <USART1_IRQHandler+0x56>
        flag_wrong_size = true;
 800071e:	4b18      	ldr	r3, [pc, #96]	@ (8000780 <USART1_IRQHandler+0xb0>)
 8000720:	2201      	movs	r2, #1
 8000722:	701a      	strb	r2, [r3, #0]
        return;
 8000724:	e021      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      if (update_size > 128*1024){
 8000726:	4b17      	ldr	r3, [pc, #92]	@ (8000784 <USART1_IRQHandler+0xb4>)
 8000728:	681b      	ldr	r3, [r3, #0]
 800072a:	f5b3 3f00 	cmp.w	r3, #131072	@ 0x20000
 800072e:	d903      	bls.n	8000738 <USART1_IRQHandler+0x68>
        flag_too_big_update = true;
 8000730:	4b15      	ldr	r3, [pc, #84]	@ (8000788 <USART1_IRQHandler+0xb8>)
 8000732:	2201      	movs	r2, #1
 8000734:	701a      	strb	r2, [r3, #0]
        return;
 8000736:	e018      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      update_size = update_size * 10 + (digit-'0');
 8000738:	4b12      	ldr	r3, [pc, #72]	@ (8000784 <USART1_IRQHandler+0xb4>)
 800073a:	681a      	ldr	r2, [r3, #0]
 800073c:	4613      	mov	r3, r2
 800073e:	009b      	lsls	r3, r3, #2
 8000740:	4413      	add	r3, r2
 8000742:	005b      	lsls	r3, r3, #1
 8000744:	461a      	mov	r2, r3
 8000746:	79fb      	ldrb	r3, [r7, #7]
 8000748:	4413      	add	r3, r2
 800074a:	3b30      	subs	r3, #48	@ 0x30
 800074c:	4a0d      	ldr	r2, [pc, #52]	@ (8000784 <USART1_IRQHandler+0xb4>)
 800074e:	6013      	str	r3, [r2, #0]
 8000750:	e00b      	b.n	800076a <USART1_IRQHandler+0x9a>
    }
    else {
      // if (fw_ar_ind >= update_size)
      //   return;
      // fw_update [fw_ar_ind++] = USART1 -> DR;
      uint8_t data = USART1 -> DR;
 8000752:	4b08      	ldr	r3, [pc, #32]	@ (8000774 <USART1_IRQHandler+0xa4>)
 8000754:	685b      	ldr	r3, [r3, #4]
 8000756:	b2db      	uxtb	r3, r3
 8000758:	71bb      	strb	r3, [r7, #6]
      Ring_buff_write(&ringbuffer, &data, 1);
 800075a:	1dbb      	adds	r3, r7, #6
 800075c:	2201      	movs	r2, #1
 800075e:	4619      	mov	r1, r3
 8000760:	480a      	ldr	r0, [pc, #40]	@ (800078c <USART1_IRQHandler+0xbc>)
 8000762:	f7ff fe5f 	bl	8000424 <Ring_buff_write>
 8000766:	e000      	b.n	800076a <USART1_IRQHandler+0x9a>
  if (!firmware_update_mode) return;
 8000768:	bf00      	nop
    }
  }
}
 800076a:	3708      	adds	r7, #8
 800076c:	46bd      	mov	sp, r7
 800076e:	bd80      	pop	{r7, pc}
 8000770:	2000507e 	.word	0x2000507e
 8000774:	40011000 	.word	0x40011000
 8000778:	20005080 	.word	0x20005080
 800077c:	20005081 	.word	0x20005081
 8000780:	20005082 	.word	0x20005082
 8000784:	20000074 	.word	0x20000074
 8000788:	20005083 	.word	0x20005083
 800078c:	20000078 	.word	0x20000078

08000790 <strlen>:
uint32_t update_section_end_address = UPDATE_ADDR;
extern volatile Ring_buff_t ringbuffer;
extern uint8_t write_buffer[WRITE_BUFF_SIZE];
volatile uint32_t fw_ar_ind = 0;

uint32_t strlen(const char *msg) {
 8000790:	b480      	push	{r7}
 8000792:	b085      	sub	sp, #20
 8000794:	af00      	add	r7, sp, #0
 8000796:	6078      	str	r0, [r7, #4]

  int i = 0;
 8000798:	2300      	movs	r3, #0
 800079a:	60fb      	str	r3, [r7, #12]
  while (msg[i++] != '\0')
 800079c:	bf00      	nop
 800079e:	68fb      	ldr	r3, [r7, #12]
 80007a0:	1c5a      	adds	r2, r3, #1
 80007a2:	60fa      	str	r2, [r7, #12]
 80007a4:	461a      	mov	r2, r3
 80007a6:	687b      	ldr	r3, [r7, #4]
 80007a8:	4413      	add	r3, r2
 80007aa:	781b      	ldrb	r3, [r3, #0]
 80007ac:	2b00      	cmp	r3, #0
 80007ae:	d1f6      	bne.n	800079e <strlen+0xe>
    ;
  return i - 1;
 80007b0:	68fb      	ldr	r3, [r7, #12]
 80007b2:	3b01      	subs	r3, #1
}
 80007b4:	4618      	mov	r0, r3
 80007b6:	3714      	adds	r7, #20
 80007b8:	46bd      	mov	sp, r7
 80007ba:	bc80      	pop	{r7}
 80007bc:	4770      	bx	lr

080007be <delay>:

void delay(uint32_t count) {
 80007be:	b480      	push	{r7}
 80007c0:	b083      	sub	sp, #12
 80007c2:	af00      	add	r7, sp, #0
 80007c4:	6078      	str	r0, [r7, #4]

  while (count--)
 80007c6:	bf00      	nop
 80007c8:	687b      	ldr	r3, [r7, #4]
 80007ca:	1e5a      	subs	r2, r3, #1
 80007cc:	607a      	str	r2, [r7, #4]
 80007ce:	2b00      	cmp	r3, #0
 80007d0:	d1fa      	bne.n	80007c8 <delay+0xa>
    ;
}
 80007d2:	bf00      	nop
 80007d4:	bf00      	nop
 80007d6:	370c      	adds	r7, #12
 80007d8:	46bd      	mov	sp, r7
 80007da:	bc80      	pop	{r7}
 80007dc:	4770      	bx	lr

080007de <hex_str>:
char *hex_str(uint32_t value, char *out) {
 80007de:	b4b0      	push	{r4, r5, r7}
 80007e0:	b08b      	sub	sp, #44	@ 0x2c
 80007e2:	af00      	add	r7, sp, #0
 80007e4:	6078      	str	r0, [r7, #4]
 80007e6:	6039      	str	r1, [r7, #0]

  char hex_char[] = "0123456789abcdef";
 80007e8:	4b1b      	ldr	r3, [pc, #108]	@ (8000858 <hex_str+0x7a>)
 80007ea:	f107 0408 	add.w	r4, r7, #8
 80007ee:	461d      	mov	r5, r3
 80007f0:	cd0f      	ldmia	r5!, {r0, r1, r2, r3}
 80007f2:	c40f      	stmia	r4!, {r0, r1, r2, r3}
 80007f4:	682b      	ldr	r3, [r5, #0]
 80007f6:	7023      	strb	r3, [r4, #0]
  out[0] = '0';
 80007f8:	683b      	ldr	r3, [r7, #0]
 80007fa:	2230      	movs	r2, #48	@ 0x30
 80007fc:	701a      	strb	r2, [r3, #0]
  out[1] = 'x';
 80007fe:	683b      	ldr	r3, [r7, #0]
 8000800:	3301      	adds	r3, #1
 8000802:	2278      	movs	r2, #120	@ 0x78
 8000804:	701a      	strb	r2, [r3, #0]

  for (int i = 0; i < 8; i++) {
 8000806:	2300      	movs	r3, #0
 8000808:	627b      	str	r3, [r7, #36]	@ 0x24
 800080a:	e01c      	b.n	8000846 <hex_str+0x68>
    uint32_t ind = (value & (15 << (i * 4))) >> (i * 4);
 800080c:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800080e:	009b      	lsls	r3, r3, #2
 8000810:	220f      	movs	r2, #15
 8000812:	fa02 f303 	lsl.w	r3, r2, r3
 8000816:	461a      	mov	r2, r3
 8000818:	687b      	ldr	r3, [r7, #4]
 800081a:	401a      	ands	r2, r3
 800081c:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800081e:	009b      	lsls	r3, r3, #2
 8000820:	fa22 f303 	lsr.w	r3, r2, r3
 8000824:	623b      	str	r3, [r7, #32]
    int j = 9 - i;
 8000826:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000828:	f1c3 0309 	rsb	r3, r3, #9
 800082c:	61fb      	str	r3, [r7, #28]
    out[j] = hex_char[ind];
 800082e:	69fb      	ldr	r3, [r7, #28]
 8000830:	683a      	ldr	r2, [r7, #0]
 8000832:	4413      	add	r3, r2
 8000834:	f107 0108 	add.w	r1, r7, #8
 8000838:	6a3a      	ldr	r2, [r7, #32]
 800083a:	440a      	add	r2, r1
 800083c:	7812      	ldrb	r2, [r2, #0]
 800083e:	701a      	strb	r2, [r3, #0]
  for (int i = 0; i < 8; i++) {
 8000840:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000842:	3301      	adds	r3, #1
 8000844:	627b      	str	r3, [r7, #36]	@ 0x24
 8000846:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000848:	2b07      	cmp	r3, #7
 800084a:	dddf      	ble.n	800080c <hex_str+0x2e>
  }
}
 800084c:	bf00      	nop
 800084e:	4618      	mov	r0, r3
 8000850:	372c      	adds	r7, #44	@ 0x2c
 8000852:	46bd      	mov	sp, r7
 8000854:	bcb0      	pop	{r4, r5, r7}
 8000856:	4770      	bx	lr
 8000858:	080017dc 	.word	0x080017dc

0800085c <printf>:

void printf(const char *msg, uint32_t address) {
 800085c:	b580      	push	{r7, lr}
 800085e:	b0a4      	sub	sp, #144	@ 0x90
 8000860:	af00      	add	r7, sp, #0
 8000862:	6078      	str	r0, [r7, #4]
 8000864:	6039      	str	r1, [r7, #0]

  uint32_t value = *((uint32_t *)address);
 8000866:	683b      	ldr	r3, [r7, #0]
 8000868:	681b      	ldr	r3, [r3, #0]
 800086a:	67fb      	str	r3, [r7, #124]	@ 0x7c

  if (strlen(msg) + 9 > MAX_STR_SIZE) {
 800086c:	6878      	ldr	r0, [r7, #4]
 800086e:	f7ff ff8f 	bl	8000790 <strlen>
 8000872:	4603      	mov	r3, r0
 8000874:	3309      	adds	r3, #9
 8000876:	2b64      	cmp	r3, #100	@ 0x64
 8000878:	d904      	bls.n	8000884 <printf+0x28>
    __usart1_print("too large error message !!\n\r", MAX_STR_SIZE);
 800087a:	2164      	movs	r1, #100	@ 0x64
 800087c:	483e      	ldr	r0, [pc, #248]	@ (8000978 <printf+0x11c>)
 800087e:	f000 fdc9 	bl	8001414 <__usart1_print>
 8000882:	e076      	b.n	8000972 <printf+0x116>
    return;
  }
  char hex[10];
  char __msg[MAX_STR_SIZE];

  uint32_t i = 0;
 8000884:	2300      	movs	r3, #0
 8000886:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
  int p = 0, q = 0;
 800088a:	2300      	movs	r3, #0
 800088c:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
 8000890:	2300      	movs	r3, #0
 8000892:	f8c7 3084 	str.w	r3, [r7, #132]	@ 0x84
  bool single_sub = false;
 8000896:	2300      	movs	r3, #0
 8000898:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83

  uint32_t msg_size = strlen(msg);
 800089c:	6878      	ldr	r0, [r7, #4]
 800089e:	f7ff ff77 	bl	8000790 <strlen>
 80008a2:	67b8      	str	r0, [r7, #120]	@ 0x78
  for (; i < msg_size; i++) {
 80008a4:	e04d      	b.n	8000942 <printf+0xe6>

    if (msg[i] == '%' && !single_sub) {
 80008a6:	687a      	ldr	r2, [r7, #4]
 80008a8:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 80008ac:	4413      	add	r3, r2
 80008ae:	781b      	ldrb	r3, [r3, #0]
 80008b0:	2b25      	cmp	r3, #37	@ 0x25
 80008b2:	d12f      	bne.n	8000914 <printf+0xb8>
 80008b4:	f897 3083 	ldrb.w	r3, [r7, #131]	@ 0x83
 80008b8:	f083 0301 	eor.w	r3, r3, #1
 80008bc:	b2db      	uxtb	r3, r3
 80008be:	2b00      	cmp	r3, #0
 80008c0:	d028      	beq.n	8000914 <printf+0xb8>
      hex_str(value, hex);
 80008c2:	f107 036c 	add.w	r3, r7, #108	@ 0x6c
 80008c6:	4619      	mov	r1, r3
 80008c8:	6ff8      	ldr	r0, [r7, #124]	@ 0x7c
 80008ca:	f7ff ff88 	bl	80007de <hex_str>

      while (q - p < 10) {
 80008ce:	e011      	b.n	80008f4 <printf+0x98>
        __msg[q++] = hex[q - p];
 80008d0:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 80008d4:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 80008d8:	1ad2      	subs	r2, r2, r3
 80008da:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 80008de:	1c59      	adds	r1, r3, #1
 80008e0:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 80008e4:	3290      	adds	r2, #144	@ 0x90
 80008e6:	443a      	add	r2, r7
 80008e8:	f812 2c24 	ldrb.w	r2, [r2, #-36]
 80008ec:	3390      	adds	r3, #144	@ 0x90
 80008ee:	443b      	add	r3, r7
 80008f0:	f803 2c88 	strb.w	r2, [r3, #-136]
      while (q - p < 10) {
 80008f4:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 80008f8:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 80008fc:	1ad3      	subs	r3, r2, r3
 80008fe:	2b09      	cmp	r3, #9
 8000900:	dde6      	ble.n	80008d0 <printf+0x74>
      }
      p++;
 8000902:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000906:	3301      	adds	r3, #1
 8000908:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
      single_sub = true;
 800090c:	2301      	movs	r3, #1
 800090e:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83
 8000912:	e011      	b.n	8000938 <printf+0xdc>
    } else
      __msg[q++] = msg[p++];
 8000914:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000918:	1c5a      	adds	r2, r3, #1
 800091a:	f8c7 2088 	str.w	r2, [r7, #136]	@ 0x88
 800091e:	461a      	mov	r2, r3
 8000920:	687b      	ldr	r3, [r7, #4]
 8000922:	441a      	add	r2, r3
 8000924:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000928:	1c59      	adds	r1, r3, #1
 800092a:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 800092e:	7812      	ldrb	r2, [r2, #0]
 8000930:	3390      	adds	r3, #144	@ 0x90
 8000932:	443b      	add	r3, r7
 8000934:	f803 2c88 	strb.w	r2, [r3, #-136]
  for (; i < msg_size; i++) {
 8000938:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 800093c:	3301      	adds	r3, #1
 800093e:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
 8000942:	f8d7 208c 	ldr.w	r2, [r7, #140]	@ 0x8c
 8000946:	6fbb      	ldr	r3, [r7, #120]	@ 0x78
 8000948:	429a      	cmp	r2, r3
 800094a:	d3ac      	bcc.n	80008a6 <printf+0x4a>
  }
  __msg[q] = '\0';
 800094c:	f107 0208 	add.w	r2, r7, #8
 8000950:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000954:	4413      	add	r3, r2
 8000956:	2200      	movs	r2, #0
 8000958:	701a      	strb	r2, [r3, #0]
  __usart1_print(__msg, strlen(__msg));
 800095a:	f107 0308 	add.w	r3, r7, #8
 800095e:	4618      	mov	r0, r3
 8000960:	f7ff ff16 	bl	8000790 <strlen>
 8000964:	4602      	mov	r2, r0
 8000966:	f107 0308 	add.w	r3, r7, #8
 800096a:	4611      	mov	r1, r2
 800096c:	4618      	mov	r0, r3
 800096e:	f000 fd51 	bl	8001414 <__usart1_print>
}
 8000972:	3790      	adds	r7, #144	@ 0x90
 8000974:	46bd      	mov	sp, r7
 8000976:	bd80      	pop	{r7, pc}
 8000978:	080017f0 	.word	0x080017f0

0800097c <recieve_update>:
//   }
//   printf("data recieved !!! yehhhh \n\n\r", 0x0);
//   return 0;
// }

uint32_t recieve_update(void) {
 800097c:	b580      	push	{r7, lr}
 800097e:	b082      	sub	sp, #8
 8000980:	af00      	add	r7, sp, #0

  // recieve update size

  printf("enter the size of the update....\n\r", 0x0);
 8000982:	2100      	movs	r1, #0
 8000984:	483e      	ldr	r0, [pc, #248]	@ (8000a80 <recieve_update+0x104>)
 8000986:	f7ff ff69 	bl	800085c <printf>

  recieve_size = true;
 800098a:	4b3e      	ldr	r3, [pc, #248]	@ (8000a84 <recieve_update+0x108>)
 800098c:	2201      	movs	r2, #1
 800098e:	701a      	strb	r2, [r3, #0]
  while (1) {
    if (flag_wrong_size) {
 8000990:	4b3d      	ldr	r3, [pc, #244]	@ (8000a88 <recieve_update+0x10c>)
 8000992:	781b      	ldrb	r3, [r3, #0]
 8000994:	b2db      	uxtb	r3, r3
 8000996:	2b00      	cmp	r3, #0
 8000998:	d006      	beq.n	80009a8 <recieve_update+0x2c>
      printf("wrong size entered !!!\n\r", 0x0);
 800099a:	2100      	movs	r1, #0
 800099c:	483b      	ldr	r0, [pc, #236]	@ (8000a8c <recieve_update+0x110>)
 800099e:	f7ff ff5d 	bl	800085c <printf>
      return -1;
 80009a2:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80009a6:	e066      	b.n	8000a76 <recieve_update+0xfa>
    }
    if (flag_too_big_update) {
 80009a8:	4b39      	ldr	r3, [pc, #228]	@ (8000a90 <recieve_update+0x114>)
 80009aa:	781b      	ldrb	r3, [r3, #0]
 80009ac:	b2db      	uxtb	r3, r3
 80009ae:	2b00      	cmp	r3, #0
 80009b0:	d006      	beq.n	80009c0 <recieve_update+0x44>
      printf("update size cannot exceed 128KB \n\r", 0x0);
 80009b2:	2100      	movs	r1, #0
 80009b4:	4837      	ldr	r0, [pc, #220]	@ (8000a94 <recieve_update+0x118>)
 80009b6:	f7ff ff51 	bl	800085c <printf>
      return -1;
 80009ba:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80009be:	e05a      	b.n	8000a76 <recieve_update+0xfa>
    }
    if (flag_size_recieved) {
 80009c0:	4b35      	ldr	r3, [pc, #212]	@ (8000a98 <recieve_update+0x11c>)
 80009c2:	781b      	ldrb	r3, [r3, #0]
 80009c4:	b2db      	uxtb	r3, r3
 80009c6:	2b00      	cmp	r3, #0
 80009c8:	d0e2      	beq.n	8000990 <recieve_update+0x14>
      printf("update size recieved \n\r", 0x0);
 80009ca:	2100      	movs	r1, #0
 80009cc:	4833      	ldr	r0, [pc, #204]	@ (8000a9c <recieve_update+0x120>)
 80009ce:	f7ff ff45 	bl	800085c <printf>
      break;
 80009d2:	bf00      	nop
    }
  }
  recieve_size = false;
 80009d4:	4b2b      	ldr	r3, [pc, #172]	@ (8000a84 <recieve_update+0x108>)
 80009d6:	2200      	movs	r2, #0
 80009d8:	701a      	strb	r2, [r3, #0]

  // recieve firmware update !!
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 80009da:	e041      	b.n	8000a60 <recieve_update+0xe4>
    while (Ring_buff_empty(&ringbuffer))
 80009dc:	bf00      	nop
 80009de:	4830      	ldr	r0, [pc, #192]	@ (8000aa0 <recieve_update+0x124>)
 80009e0:	f7ff fce1 	bl	80003a6 <Ring_buff_empty>
 80009e4:	4603      	mov	r3, r0
 80009e6:	2b00      	cmp	r3, #0
 80009e8:	d1f9      	bne.n	80009de <recieve_update+0x62>
      ;
    //
    // problem
    uint16_t read_size = Ring_buff_read(&ringbuffer, write_buffer + wb_size,
 80009ea:	4b2e      	ldr	r3, [pc, #184]	@ (8000aa4 <recieve_update+0x128>)
 80009ec:	881b      	ldrh	r3, [r3, #0]
 80009ee:	461a      	mov	r2, r3
 80009f0:	4b2d      	ldr	r3, [pc, #180]	@ (8000aa8 <recieve_update+0x12c>)
 80009f2:	18d1      	adds	r1, r2, r3
 80009f4:	4b2b      	ldr	r3, [pc, #172]	@ (8000aa4 <recieve_update+0x128>)
 80009f6:	881b      	ldrh	r3, [r3, #0]
 80009f8:	f5c3 5320 	rsb	r3, r3, #10240	@ 0x2800
 80009fc:	b29b      	uxth	r3, r3
 80009fe:	461a      	mov	r2, r3
 8000a00:	4827      	ldr	r0, [pc, #156]	@ (8000aa0 <recieve_update+0x124>)
 8000a02:	f7ff fd42 	bl	800048a <Ring_buff_read>
 8000a06:	4603      	mov	r3, r0
 8000a08:	80fb      	strh	r3, [r7, #6]
                                        WRITE_BUFF_SIZE - wb_size);
    wb_size += read_size;
 8000a0a:	4b26      	ldr	r3, [pc, #152]	@ (8000aa4 <recieve_update+0x128>)
 8000a0c:	881a      	ldrh	r2, [r3, #0]
 8000a0e:	88fb      	ldrh	r3, [r7, #6]
 8000a10:	4413      	add	r3, r2
 8000a12:	b29a      	uxth	r2, r3
 8000a14:	4b23      	ldr	r3, [pc, #140]	@ (8000aa4 <recieve_update+0x128>)
 8000a16:	801a      	strh	r2, [r3, #0]

    uint16_t update_in_flash_size = update_section_end_address - UPDATE_ADDR;
 8000a18:	4b24      	ldr	r3, [pc, #144]	@ (8000aac <recieve_update+0x130>)
 8000a1a:	681b      	ldr	r3, [r3, #0]
 8000a1c:	80bb      	strh	r3, [r7, #4]
    //
    if (wb_size == WRITE_BUFF_SIZE ||
 8000a1e:	4b21      	ldr	r3, [pc, #132]	@ (8000aa4 <recieve_update+0x128>)
 8000a20:	881b      	ldrh	r3, [r3, #0]
 8000a22:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 8000a26:	d007      	beq.n	8000a38 <recieve_update+0xbc>
        update_size - update_in_flash_size == wb_size) {
 8000a28:	4b21      	ldr	r3, [pc, #132]	@ (8000ab0 <recieve_update+0x134>)
 8000a2a:	681a      	ldr	r2, [r3, #0]
 8000a2c:	88bb      	ldrh	r3, [r7, #4]
 8000a2e:	1ad3      	subs	r3, r2, r3
 8000a30:	4a1c      	ldr	r2, [pc, #112]	@ (8000aa4 <recieve_update+0x128>)
 8000a32:	8812      	ldrh	r2, [r2, #0]
    if (wb_size == WRITE_BUFF_SIZE ||
 8000a34:	4293      	cmp	r3, r2
 8000a36:	d113      	bne.n	8000a60 <recieve_update+0xe4>
      // flash write, update end address, wb flush

      flash_write(update_section_end_address, write_buffer, wb_size, 0);
 8000a38:	4b1c      	ldr	r3, [pc, #112]	@ (8000aac <recieve_update+0x130>)
 8000a3a:	6818      	ldr	r0, [r3, #0]
 8000a3c:	4b19      	ldr	r3, [pc, #100]	@ (8000aa4 <recieve_update+0x128>)
 8000a3e:	881b      	ldrh	r3, [r3, #0]
 8000a40:	461a      	mov	r2, r3
 8000a42:	2300      	movs	r3, #0
 8000a44:	4918      	ldr	r1, [pc, #96]	@ (8000aa8 <recieve_update+0x12c>)
 8000a46:	f000 fbff 	bl	8001248 <flash_write>

      update_section_end_address += wb_size;
 8000a4a:	4b16      	ldr	r3, [pc, #88]	@ (8000aa4 <recieve_update+0x128>)
 8000a4c:	881b      	ldrh	r3, [r3, #0]
 8000a4e:	461a      	mov	r2, r3
 8000a50:	4b16      	ldr	r3, [pc, #88]	@ (8000aac <recieve_update+0x130>)
 8000a52:	681b      	ldr	r3, [r3, #0]
 8000a54:	4413      	add	r3, r2
 8000a56:	4a15      	ldr	r2, [pc, #84]	@ (8000aac <recieve_update+0x130>)
 8000a58:	6013      	str	r3, [r2, #0]
      wb_size = 0;
 8000a5a:	4b12      	ldr	r3, [pc, #72]	@ (8000aa4 <recieve_update+0x128>)
 8000a5c:	2200      	movs	r2, #0
 8000a5e:	801a      	strh	r2, [r3, #0]
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 8000a60:	4b12      	ldr	r3, [pc, #72]	@ (8000aac <recieve_update+0x130>)
 8000a62:	681b      	ldr	r3, [r3, #0]
 8000a64:	f103 4377 	add.w	r3, r3, #4143972352	@ 0xf7000000
 8000a68:	f503 037c 	add.w	r3, r3, #16515072	@ 0xfc0000
 8000a6c:	4a10      	ldr	r2, [pc, #64]	@ (8000ab0 <recieve_update+0x134>)
 8000a6e:	6812      	ldr	r2, [r2, #0]
 8000a70:	4293      	cmp	r3, r2
 8000a72:	d3b3      	bcc.n	80009dc <recieve_update+0x60>
    }
  }

  // while (fw_ar_ind < update_size);

  return 0;
 8000a74:	2300      	movs	r3, #0
}
 8000a76:	4618      	mov	r0, r3
 8000a78:	3708      	adds	r7, #8
 8000a7a:	46bd      	mov	sp, r7
 8000a7c:	bd80      	pop	{r7, pc}
 8000a7e:	bf00      	nop
 8000a80:	08001810 	.word	0x08001810
 8000a84:	20005080 	.word	0x20005080
 8000a88:	20005082 	.word	0x20005082
 8000a8c:	08001834 	.word	0x08001834
 8000a90:	20005083 	.word	0x20005083
 8000a94:	08001850 	.word	0x08001850
 8000a98:	20005081 	.word	0x20005081
 8000a9c:	08001874 	.word	0x08001874
 8000aa0:	20000078 	.word	0x20000078
 8000aa4:	2000507c 	.word	0x2000507c
 8000aa8:	2000287c 	.word	0x2000287c
 8000aac:	20000000 	.word	0x20000000
 8000ab0:	20000074 	.word	0x20000074

08000ab4 <rollback>:

void rollback(void) {
 8000ab4:	b580      	push	{r7, lr}
 8000ab6:	b08e      	sub	sp, #56	@ 0x38
 8000ab8:	af00      	add	r7, sp, #0

  firmware_t old_f;
  // old firmware is present in the COPY_ADDR section
  init_firmware_t(COPY_ADDR, &old_f);
 8000aba:	f107 0308 	add.w	r3, r7, #8
 8000abe:	4619      	mov	r1, r3
 8000ac0:	4819      	ldr	r0, [pc, #100]	@ (8000b28 <rollback+0x74>)
 8000ac2:	f000 f85d 	bl	8000b80 <init_firmware_t>

  printf("startign rollback\n\n\r", 0x0);
 8000ac6:	2100      	movs	r1, #0
 8000ac8:	4818      	ldr	r0, [pc, #96]	@ (8000b2c <rollback+0x78>)
 8000aca:	f7ff fec7 	bl	800085c <printf>
  erase_flash(old_f.__base_address);
 8000ace:	68bb      	ldr	r3, [r7, #8]
 8000ad0:	4618      	mov	r0, r3
 8000ad2:	f000 faff 	bl	80010d4 <erase_flash>
  printf("corupted firmware is erased\n\r", 0x0);
 8000ad6:	2100      	movs	r1, #0
 8000ad8:	4815      	ldr	r0, [pc, #84]	@ (8000b30 <rollback+0x7c>)
 8000ada:	f7ff febf 	bl	800085c <printf>

  uint32_t copy_size =
      (*(uint32_t *)(COPY_ADDR + 0x14)) - (*(uint32_t *)(COPY_ADDR + 0x0c));
 8000ade:	4b15      	ldr	r3, [pc, #84]	@ (8000b34 <rollback+0x80>)
 8000ae0:	681a      	ldr	r2, [r3, #0]
 8000ae2:	4b15      	ldr	r3, [pc, #84]	@ (8000b38 <rollback+0x84>)
 8000ae4:	681b      	ldr	r3, [r3, #0]
  uint32_t copy_size =
 8000ae6:	1ad3      	subs	r3, r2, r3
 8000ae8:	637b      	str	r3, [r7, #52]	@ 0x34
  flash_write(old_f.__base_address + 0x04, (const char *)(COPY_ADDR + 0x04),
 8000aea:	68bb      	ldr	r3, [r7, #8]
 8000aec:	1d18      	adds	r0, r3, #4
 8000aee:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000af0:	1f1a      	subs	r2, r3, #4
 8000af2:	2300      	movs	r3, #0
 8000af4:	4911      	ldr	r1, [pc, #68]	@ (8000b3c <rollback+0x88>)
 8000af6:	f000 fba7 	bl	8001248 <flash_write>
              copy_size - 0x04, NO_DELAY);

  // word write => size would be 4 (not 2)
  const uint32_t end = 0xfffffffe;
 8000afa:	f06f 0301 	mvn.w	r3, #1
 8000afe:	607b      	str	r3, [r7, #4]
  // &end is of type -> uint32_t * ==> need type conversion
  flash_write(old_f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000b00:	68b8      	ldr	r0, [r7, #8]
 8000b02:	1d39      	adds	r1, r7, #4
 8000b04:	2300      	movs	r3, #0
 8000b06:	2204      	movs	r2, #4
 8000b08:	f000 fb9e 	bl	8001248 <flash_write>
  printf("new flag = %\n\r", old_f.__base_address);
 8000b0c:	68bb      	ldr	r3, [r7, #8]
 8000b0e:	4619      	mov	r1, r3
 8000b10:	480b      	ldr	r0, [pc, #44]	@ (8000b40 <rollback+0x8c>)
 8000b12:	f7ff fea3 	bl	800085c <printf>

  printf("done recovering old firmware \n\r", 0x0);
 8000b16:	2100      	movs	r1, #0
 8000b18:	480a      	ldr	r0, [pc, #40]	@ (8000b44 <rollback+0x90>)
 8000b1a:	f7ff fe9f 	bl	800085c <printf>
}
 8000b1e:	bf00      	nop
 8000b20:	3738      	adds	r7, #56	@ 0x38
 8000b22:	46bd      	mov	sp, r7
 8000b24:	bd80      	pop	{r7, pc}
 8000b26:	bf00      	nop
 8000b28:	08060000 	.word	0x08060000
 8000b2c:	0800188c 	.word	0x0800188c
 8000b30:	080018a4 	.word	0x080018a4
 8000b34:	08060014 	.word	0x08060014
 8000b38:	0806000c 	.word	0x0806000c
 8000b3c:	08060004 	.word	0x08060004
 8000b40:	080018c4 	.word	0x080018c4
 8000b44:	080018d4 	.word	0x080018d4

08000b48 <__NVIC_EnableIRQ>:
{
 8000b48:	b480      	push	{r7}
 8000b4a:	b083      	sub	sp, #12
 8000b4c:	af00      	add	r7, sp, #0
 8000b4e:	4603      	mov	r3, r0
 8000b50:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 8000b52:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000b56:	2b00      	cmp	r3, #0
 8000b58:	db0b      	blt.n	8000b72 <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 8000b5a:	79fb      	ldrb	r3, [r7, #7]
 8000b5c:	f003 021f 	and.w	r2, r3, #31
 8000b60:	4906      	ldr	r1, [pc, #24]	@ (8000b7c <__NVIC_EnableIRQ+0x34>)
 8000b62:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000b66:	095b      	lsrs	r3, r3, #5
 8000b68:	2001      	movs	r0, #1
 8000b6a:	fa00 f202 	lsl.w	r2, r0, r2
 8000b6e:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 8000b72:	bf00      	nop
 8000b74:	370c      	adds	r7, #12
 8000b76:	46bd      	mov	sp, r7
 8000b78:	bc80      	pop	{r7}
 8000b7a:	4770      	bx	lr
 8000b7c:	e000e100 	.word	0xe000e100

08000b80 <init_firmware_t>:
volatile bool flag_size_recieved = false;
volatile bool flag_wrong_size = false;
volatile bool flag_too_big_update = false;


void init_firmware_t(uint32_t address, firmware_t *f) {
 8000b80:	b480      	push	{r7}
 8000b82:	b083      	sub	sp, #12
 8000b84:	af00      	add	r7, sp, #0
 8000b86:	6078      	str	r0, [r7, #4]
 8000b88:	6039      	str	r1, [r7, #0]
  f->__flag = *(volatile uint32_t *)(address + 0x00);
 8000b8a:	687b      	ldr	r3, [r7, #4]
 8000b8c:	681a      	ldr	r2, [r3, #0]
 8000b8e:	683b      	ldr	r3, [r7, #0]
 8000b90:	605a      	str	r2, [r3, #4]
  f->__crc = *((volatile uint32_t *)(address + 0x04));
 8000b92:	687b      	ldr	r3, [r7, #4]
 8000b94:	3304      	adds	r3, #4
 8000b96:	681a      	ldr	r2, [r3, #0]
 8000b98:	683b      	ldr	r3, [r7, #0]
 8000b9a:	609a      	str	r2, [r3, #8]
  f->__vtable_end = *((volatile uint32_t *)(address + 0x08));
 8000b9c:	687b      	ldr	r3, [r7, #4]
 8000b9e:	3308      	adds	r3, #8
 8000ba0:	681a      	ldr	r2, [r3, #0]
 8000ba2:	683b      	ldr	r3, [r7, #0]
 8000ba4:	60da      	str	r2, [r3, #12]
  f->__base_address = *((volatile uint32_t *)(address + 0x0c));
 8000ba6:	687b      	ldr	r3, [r7, #4]
 8000ba8:	330c      	adds	r3, #12
 8000baa:	681a      	ldr	r2, [r3, #0]
 8000bac:	683b      	ldr	r3, [r7, #0]
 8000bae:	601a      	str	r2, [r3, #0]
  f->__vtable_address = *((volatile uint32_t *)(address + 0x10));
 8000bb0:	687b      	ldr	r3, [r7, #4]
 8000bb2:	3310      	adds	r3, #16
 8000bb4:	681a      	ldr	r2, [r3, #0]
 8000bb6:	683b      	ldr	r3, [r7, #0]
 8000bb8:	615a      	str	r2, [r3, #20]
  f->__firmware_end = *((volatile uint32_t *)(address + 0x14));
 8000bba:	687b      	ldr	r3, [r7, #4]
 8000bbc:	3314      	adds	r3, #20
 8000bbe:	681a      	ldr	r2, [r3, #0]
 8000bc0:	683b      	ldr	r3, [r7, #0]
 8000bc2:	619a      	str	r2, [r3, #24]
  f->__firmware_size = f->__firmware_end - f->__base_address;
 8000bc4:	683b      	ldr	r3, [r7, #0]
 8000bc6:	699a      	ldr	r2, [r3, #24]
 8000bc8:	683b      	ldr	r3, [r7, #0]
 8000bca:	681b      	ldr	r3, [r3, #0]
 8000bcc:	1ad2      	subs	r2, r2, r3
 8000bce:	683b      	ldr	r3, [r7, #0]
 8000bd0:	61da      	str	r2, [r3, #28]
  f->__crc_start_addr = address + 0x08;
 8000bd2:	687b      	ldr	r3, [r7, #4]
 8000bd4:	f103 0208 	add.w	r2, r3, #8
 8000bd8:	683b      	ldr	r3, [r7, #0]
 8000bda:	611a      	str	r2, [r3, #16]
  f->__crc_end_addr = f->__crc_start_addr - 0x08 + f->__firmware_size;
 8000bdc:	683b      	ldr	r3, [r7, #0]
 8000bde:	691a      	ldr	r2, [r3, #16]
 8000be0:	683b      	ldr	r3, [r7, #0]
 8000be2:	69db      	ldr	r3, [r3, #28]
 8000be4:	4413      	add	r3, r2
 8000be6:	f1a3 0208 	sub.w	r2, r3, #8
 8000bea:	683b      	ldr	r3, [r7, #0]
 8000bec:	629a      	str	r2, [r3, #40]	@ 0x28
  f->__msp_value = *((volatile uint32_t *)(f->__vtable_address));
 8000bee:	683b      	ldr	r3, [r7, #0]
 8000bf0:	695b      	ldr	r3, [r3, #20]
 8000bf2:	681a      	ldr	r2, [r3, #0]
 8000bf4:	683b      	ldr	r3, [r7, #0]
 8000bf6:	621a      	str	r2, [r3, #32]
  f->__reset_handler = *((volatile uint32_t *)(f->__vtable_address + 0x4));
 8000bf8:	683b      	ldr	r3, [r7, #0]
 8000bfa:	695b      	ldr	r3, [r3, #20]
 8000bfc:	3304      	adds	r3, #4
 8000bfe:	681a      	ldr	r2, [r3, #0]
 8000c00:	683b      	ldr	r3, [r7, #0]
 8000c02:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000c04:	bf00      	nop
 8000c06:	370c      	adds	r7, #12
 8000c08:	46bd      	mov	sp, r7
 8000c0a:	bc80      	pop	{r7}
 8000c0c:	4770      	bx	lr

08000c0e <copy_firmware_t>:

void copy_firmware_t(firmware_t *f_dest, firmware_t *f_src) {
 8000c0e:	b480      	push	{r7}
 8000c10:	b083      	sub	sp, #12
 8000c12:	af00      	add	r7, sp, #0
 8000c14:	6078      	str	r0, [r7, #4]
 8000c16:	6039      	str	r1, [r7, #0]

  f_dest->__base_address = f_src->__base_address;
 8000c18:	683b      	ldr	r3, [r7, #0]
 8000c1a:	681a      	ldr	r2, [r3, #0]
 8000c1c:	687b      	ldr	r3, [r7, #4]
 8000c1e:	601a      	str	r2, [r3, #0]
  f_dest->__flag = f_src->__flag;
 8000c20:	683b      	ldr	r3, [r7, #0]
 8000c22:	685a      	ldr	r2, [r3, #4]
 8000c24:	687b      	ldr	r3, [r7, #4]
 8000c26:	605a      	str	r2, [r3, #4]
  f_dest->__crc = f_src->__crc;
 8000c28:	683b      	ldr	r3, [r7, #0]
 8000c2a:	689a      	ldr	r2, [r3, #8]
 8000c2c:	687b      	ldr	r3, [r7, #4]
 8000c2e:	609a      	str	r2, [r3, #8]
  f_dest->__vtable_end = f_src->__vtable_end;
 8000c30:	683b      	ldr	r3, [r7, #0]
 8000c32:	68da      	ldr	r2, [r3, #12]
 8000c34:	687b      	ldr	r3, [r7, #4]
 8000c36:	60da      	str	r2, [r3, #12]
  f_dest->__crc_start_addr = f_src->__crc_start_addr;
 8000c38:	683b      	ldr	r3, [r7, #0]
 8000c3a:	691a      	ldr	r2, [r3, #16]
 8000c3c:	687b      	ldr	r3, [r7, #4]
 8000c3e:	611a      	str	r2, [r3, #16]
  f_dest->__crc_end_addr = f_src->__crc_end_addr;
 8000c40:	683b      	ldr	r3, [r7, #0]
 8000c42:	6a9a      	ldr	r2, [r3, #40]	@ 0x28
 8000c44:	687b      	ldr	r3, [r7, #4]
 8000c46:	629a      	str	r2, [r3, #40]	@ 0x28
  f_dest->__vtable_address = f_src->__vtable_address;
 8000c48:	683b      	ldr	r3, [r7, #0]
 8000c4a:	695a      	ldr	r2, [r3, #20]
 8000c4c:	687b      	ldr	r3, [r7, #4]
 8000c4e:	615a      	str	r2, [r3, #20]
  f_dest->__firmware_end = f_src->__firmware_end;
 8000c50:	683b      	ldr	r3, [r7, #0]
 8000c52:	699a      	ldr	r2, [r3, #24]
 8000c54:	687b      	ldr	r3, [r7, #4]
 8000c56:	619a      	str	r2, [r3, #24]
  f_dest->__firmware_size = f_src->__firmware_size;
 8000c58:	683b      	ldr	r3, [r7, #0]
 8000c5a:	69da      	ldr	r2, [r3, #28]
 8000c5c:	687b      	ldr	r3, [r7, #4]
 8000c5e:	61da      	str	r2, [r3, #28]
  f_dest->__msp_value = f_src->__msp_value;
 8000c60:	683b      	ldr	r3, [r7, #0]
 8000c62:	6a1a      	ldr	r2, [r3, #32]
 8000c64:	687b      	ldr	r3, [r7, #4]
 8000c66:	621a      	str	r2, [r3, #32]
  f_dest->__reset_handler = f_src->__reset_handler;
 8000c68:	683b      	ldr	r3, [r7, #0]
 8000c6a:	6a5a      	ldr	r2, [r3, #36]	@ 0x24
 8000c6c:	687b      	ldr	r3, [r7, #4]
 8000c6e:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000c70:	bf00      	nop
 8000c72:	370c      	adds	r7, #12
 8000c74:	46bd      	mov	sp, r7
 8000c76:	bc80      	pop	{r7}
 8000c78:	4770      	bx	lr

08000c7a <handle_update>:

bool handle_update(void) {
 8000c7a:	b580      	push	{r7, lr}
 8000c7c:	b098      	sub	sp, #96	@ 0x60
 8000c7e:	af00      	add	r7, sp, #0

  /************************* recieve update and store it in
   * UPDATE_ADDR in flash***********************/

  if (recieve_update()) {
 8000c80:	f7ff fe7c 	bl	800097c <recieve_update>
 8000c84:	4603      	mov	r3, r0
 8000c86:	2b00      	cmp	r3, #0
 8000c88:	d005      	beq.n	8000c96 <handle_update+0x1c>
    printf("ERROR in recieving update\n\r", 0x0);
 8000c8a:	2100      	movs	r1, #0
 8000c8c:	4852      	ldr	r0, [pc, #328]	@ (8000dd8 <handle_update+0x15e>)
 8000c8e:	f7ff fde5 	bl	800085c <printf>
    return 0;
 8000c92:	2300      	movs	r3, #0
 8000c94:	e09c      	b.n	8000dd0 <handle_update+0x156>
  }
  firmware_t f;
  update_size = update_size / 4 * 4 + 4; // align update size by 4bytes
 8000c96:	4b51      	ldr	r3, [pc, #324]	@ (8000ddc <handle_update+0x162>)
 8000c98:	681b      	ldr	r3, [r3, #0]
 8000c9a:	f023 0303 	bic.w	r3, r3, #3
 8000c9e:	3304      	adds	r3, #4
 8000ca0:	4a4e      	ldr	r2, [pc, #312]	@ (8000ddc <handle_update+0x162>)
 8000ca2:	6013      	str	r3, [r2, #0]

  if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_1_ADDRESS)
 8000ca4:	4b4e      	ldr	r3, [pc, #312]	@ (8000de0 <handle_update+0x166>)
 8000ca6:	681b      	ldr	r3, [r3, #0]
 8000ca8:	4a4e      	ldr	r2, [pc, #312]	@ (8000de4 <handle_update+0x16a>)
 8000caa:	4293      	cmp	r3, r2
 8000cac:	d106      	bne.n	8000cbc <handle_update+0x42>
    copy_firmware_t(&f, &f1);
 8000cae:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000cb2:	494d      	ldr	r1, [pc, #308]	@ (8000de8 <handle_update+0x16e>)
 8000cb4:	4618      	mov	r0, r3
 8000cb6:	f7ff ffaa 	bl	8000c0e <copy_firmware_t>
 8000cba:	e011      	b.n	8000ce0 <handle_update+0x66>

  else if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_2_ADDRESS)
 8000cbc:	4b48      	ldr	r3, [pc, #288]	@ (8000de0 <handle_update+0x166>)
 8000cbe:	681b      	ldr	r3, [r3, #0]
 8000cc0:	4a4a      	ldr	r2, [pc, #296]	@ (8000dec <handle_update+0x172>)
 8000cc2:	4293      	cmp	r3, r2
 8000cc4:	d106      	bne.n	8000cd4 <handle_update+0x5a>
    copy_firmware_t(&f, &f2);
 8000cc6:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000cca:	4949      	ldr	r1, [pc, #292]	@ (8000df0 <handle_update+0x176>)
 8000ccc:	4618      	mov	r0, r3
 8000cce:	f7ff ff9e 	bl	8000c0e <copy_firmware_t>
 8000cd2:	e005      	b.n	8000ce0 <handle_update+0x66>

  else {
    printf("wrong firmware base address !!!", 0x0);
 8000cd4:	2100      	movs	r1, #0
 8000cd6:	4847      	ldr	r0, [pc, #284]	@ (8000df4 <handle_update+0x17a>)
 8000cd8:	f7ff fdc0 	bl	800085c <printf>
    return 0;
 8000cdc:	2300      	movs	r3, #0
 8000cde:	e077      	b.n	8000dd0 <handle_update+0x156>
  // if (flash_write(UPDATE_ADDR, fw_update, update_size, NO_DELAY)) {
  //   printf("ERROR in flash_write\n\r", 0x0);
  //   return;
  // }

  printf("update has been saved in the update section !!!\n\r", 0x0);
 8000ce0:	2100      	movs	r1, #0
 8000ce2:	4845      	ldr	r0, [pc, #276]	@ (8000df8 <handle_update+0x17e>)
 8000ce4:	f7ff fdba 	bl	800085c <printf>

  firmware_t uf;
  init_firmware_t(UPDATE_ADDR, &uf);
 8000ce8:	f107 0308 	add.w	r3, r7, #8
 8000cec:	4619      	mov	r1, r3
 8000cee:	4843      	ldr	r0, [pc, #268]	@ (8000dfc <handle_update+0x182>)
 8000cf0:	f7ff ff46 	bl	8000b80 <init_firmware_t>

  printf("***************validating update***************\n\r", 0x0);
 8000cf4:	2100      	movs	r1, #0
 8000cf6:	4842      	ldr	r0, [pc, #264]	@ (8000e00 <handle_update+0x186>)
 8000cf8:	f7ff fdb0 	bl	800085c <printf>

  // check flag field of the firmware
  if (uf.__flag != 0xffffffff) {
 8000cfc:	68fb      	ldr	r3, [r7, #12]
 8000cfe:	f1b3 3fff 	cmp.w	r3, #4294967295	@ 0xffffffff
 8000d02:	d005      	beq.n	8000d10 <handle_update+0x96>
    printf("ERROR .... flag field of update must be 0xffffffff\n\r", 0x0);
 8000d04:	2100      	movs	r1, #0
 8000d06:	483f      	ldr	r0, [pc, #252]	@ (8000e04 <handle_update+0x18a>)
 8000d08:	f7ff fda8 	bl	800085c <printf>
    return 0;
 8000d0c:	2300      	movs	r3, #0
 8000d0e:	e05f      	b.n	8000dd0 <handle_update+0x156>
  }
  if (!validate_firmware(&uf)) {
 8000d10:	f107 0308 	add.w	r3, r7, #8
 8000d14:	4618      	mov	r0, r3
 8000d16:	f7ff fc85 	bl	8000624 <validate_firmware>
 8000d1a:	4603      	mov	r3, r0
 8000d1c:	f083 0301 	eor.w	r3, r3, #1
 8000d20:	b2db      	uxtb	r3, r3
 8000d22:	2b00      	cmp	r3, #0
 8000d24:	d005      	beq.n	8000d32 <handle_update+0xb8>
    printf("ERROR .... update validation failed\n\r", 0x0);
 8000d26:	2100      	movs	r1, #0
 8000d28:	4837      	ldr	r0, [pc, #220]	@ (8000e08 <handle_update+0x18e>)
 8000d2a:	f7ff fd97 	bl	800085c <printf>
    return 0;
 8000d2e:	2300      	movs	r3, #0
 8000d30:	e04e      	b.n	8000dd0 <handle_update+0x156>
  }

  /************************firmware to COPY section
   * ***********************************/

  if (erase_flash(COPY_ADDR)) {
 8000d32:	4836      	ldr	r0, [pc, #216]	@ (8000e0c <handle_update+0x192>)
 8000d34:	f000 f9ce 	bl	80010d4 <erase_flash>
 8000d38:	4603      	mov	r3, r0
 8000d3a:	2b00      	cmp	r3, #0
 8000d3c:	d005      	beq.n	8000d4a <handle_update+0xd0>
    printf("could not erase COPY section\n\r", 0x0);
 8000d3e:	2100      	movs	r1, #0
 8000d40:	4833      	ldr	r0, [pc, #204]	@ (8000e10 <handle_update+0x196>)
 8000d42:	f7ff fd8b 	bl	800085c <printf>
    return 0;
 8000d46:	2300      	movs	r3, #0
 8000d48:	e042      	b.n	8000dd0 <handle_update+0x156>
  }
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000d4a:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000d4c:	4619      	mov	r1, r3
                  f.__firmware_size, NO_DELAY)) {
 8000d4e:	6d3a      	ldr	r2, [r7, #80]	@ 0x50
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000d50:	2300      	movs	r3, #0
 8000d52:	482e      	ldr	r0, [pc, #184]	@ (8000e0c <handle_update+0x192>)
 8000d54:	f000 fa78 	bl	8001248 <flash_write>
 8000d58:	4603      	mov	r3, r0
 8000d5a:	2b00      	cmp	r3, #0
 8000d5c:	d005      	beq.n	8000d6a <handle_update+0xf0>

    printf("could not write to the COPY section \n\r", 0x0);
 8000d5e:	2100      	movs	r1, #0
 8000d60:	482c      	ldr	r0, [pc, #176]	@ (8000e14 <handle_update+0x19a>)
 8000d62:	f7ff fd7b 	bl	800085c <printf>
    return 0;
 8000d66:	2300      	movs	r3, #0
 8000d68:	e032      	b.n	8000dd0 <handle_update+0x156>
  }
  printf("firmware is copied to copy section\n\r", 0x0);
 8000d6a:	2100      	movs	r1, #0
 8000d6c:	482a      	ldr	r0, [pc, #168]	@ (8000e18 <handle_update+0x19e>)
 8000d6e:	f7ff fd75 	bl	800085c <printf>

  /********************* update to firmware
   * ********************************************/

  if (erase_flash(f.__base_address)) {
 8000d72:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000d74:	4618      	mov	r0, r3
 8000d76:	f000 f9ad 	bl	80010d4 <erase_flash>
 8000d7a:	4603      	mov	r3, r0
 8000d7c:	2b00      	cmp	r3, #0
 8000d7e:	d005      	beq.n	8000d8c <handle_update+0x112>
    printf("could not erase FIRMWARE section\n\r", 0x0);
 8000d80:	2100      	movs	r1, #0
 8000d82:	4826      	ldr	r0, [pc, #152]	@ (8000e1c <handle_update+0x1a2>)
 8000d84:	f7ff fd6a 	bl	800085c <printf>
    return 0;
 8000d88:	2300      	movs	r3, #0
 8000d8a:	e021      	b.n	8000dd0 <handle_update+0x156>
  }
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000d8c:	6b78      	ldr	r0, [r7, #52]	@ 0x34
                  uf.__firmware_size, NO_DELAY)) {
 8000d8e:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000d90:	2300      	movs	r3, #0
 8000d92:	491a      	ldr	r1, [pc, #104]	@ (8000dfc <handle_update+0x182>)
 8000d94:	f000 fa58 	bl	8001248 <flash_write>
 8000d98:	4603      	mov	r3, r0
 8000d9a:	2b00      	cmp	r3, #0
 8000d9c:	d005      	beq.n	8000daa <handle_update+0x130>

    printf("could not write to the firmware section\n\r", 0x0);
 8000d9e:	2100      	movs	r1, #0
 8000da0:	481f      	ldr	r0, [pc, #124]	@ (8000e20 <handle_update+0x1a6>)
 8000da2:	f7ff fd5b 	bl	800085c <printf>
    return 0;
 8000da6:	2300      	movs	r3, #0
 8000da8:	e012      	b.n	8000dd0 <handle_update+0x156>
  }

  const uint32_t end = 0xfffffffe;
 8000daa:	f06f 0301 	mvn.w	r3, #1
 8000dae:	607b      	str	r3, [r7, #4]
  // mark the flag implying that firmware has been updated
  flash_write(f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000db0:	6b78      	ldr	r0, [r7, #52]	@ 0x34
 8000db2:	1d39      	adds	r1, r7, #4
 8000db4:	2300      	movs	r3, #0
 8000db6:	2204      	movs	r2, #4
 8000db8:	f000 fa46 	bl	8001248 <flash_write>

  printf("new flag = %\n\r", f.__base_address);
 8000dbc:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000dbe:	4619      	mov	r1, r3
 8000dc0:	4818      	ldr	r0, [pc, #96]	@ (8000e24 <handle_update+0x1aa>)
 8000dc2:	f7ff fd4b 	bl	800085c <printf>

  printf("updating firmware is done successfully!!!!\n\r", 0x0);
 8000dc6:	2100      	movs	r1, #0
 8000dc8:	4817      	ldr	r0, [pc, #92]	@ (8000e28 <handle_update+0x1ae>)
 8000dca:	f7ff fd47 	bl	800085c <printf>

  return 1;
 8000dce:	2301      	movs	r3, #1
}
 8000dd0:	4618      	mov	r0, r3
 8000dd2:	3760      	adds	r7, #96	@ 0x60
 8000dd4:	46bd      	mov	sp, r7
 8000dd6:	bd80      	pop	{r7, pc}
 8000dd8:	080018f4 	.word	0x080018f4
 8000ddc:	20000074 	.word	0x20000074
 8000de0:	0804000c 	.word	0x0804000c
 8000de4:	08010000 	.word	0x08010000
 8000de8:	20000008 	.word	0x20000008
 8000dec:	08020000 	.word	0x08020000
 8000df0:	20000034 	.word	0x20000034
 8000df4:	08001910 	.word	0x08001910
 8000df8:	08001930 	.word	0x08001930
 8000dfc:	08040000 	.word	0x08040000
 8000e00:	08001964 	.word	0x08001964
 8000e04:	08001998 	.word	0x08001998
 8000e08:	080019d0 	.word	0x080019d0
 8000e0c:	08060000 	.word	0x08060000
 8000e10:	080019f8 	.word	0x080019f8
 8000e14:	08001a18 	.word	0x08001a18
 8000e18:	08001a40 	.word	0x08001a40
 8000e1c:	08001a68 	.word	0x08001a68
 8000e20:	08001a8c 	.word	0x08001a8c
 8000e24:	08001ab8 	.word	0x08001ab8
 8000e28:	08001ac8 	.word	0x08001ac8

08000e2c <switch_press>:

bool switch_press (bool f1_valid, bool f2_valid){
 8000e2c:	b580      	push	{r7, lr}
 8000e2e:	b084      	sub	sp, #16
 8000e30:	af00      	add	r7, sp, #0
 8000e32:	4603      	mov	r3, r0
 8000e34:	460a      	mov	r2, r1
 8000e36:	71fb      	strb	r3, [r7, #7]
 8000e38:	4613      	mov	r3, r2
 8000e3a:	71bb      	strb	r3, [r7, #6]

  while (!press_count)
 8000e3c:	bf00      	nop
 8000e3e:	4b36      	ldr	r3, [pc, #216]	@ (8000f18 <switch_press+0xec>)
 8000e40:	681b      	ldr	r3, [r3, #0]
 8000e42:	2b00      	cmp	r3, #0
 8000e44:	d0fb      	beq.n	8000e3e <switch_press+0x12>
    ;
  delay_count = 1000000;
 8000e46:	4b35      	ldr	r3, [pc, #212]	@ (8000f1c <switch_press+0xf0>)
 8000e48:	4a35      	ldr	r2, [pc, #212]	@ (8000f20 <switch_press+0xf4>)
 8000e4a:	601a      	str	r2, [r3, #0]
  while (delay_count--)
 8000e4c:	bf00      	nop
 8000e4e:	4b33      	ldr	r3, [pc, #204]	@ (8000f1c <switch_press+0xf0>)
 8000e50:	681b      	ldr	r3, [r3, #0]
 8000e52:	1e5a      	subs	r2, r3, #1
 8000e54:	4931      	ldr	r1, [pc, #196]	@ (8000f1c <switch_press+0xf0>)
 8000e56:	600a      	str	r2, [r1, #0]
 8000e58:	2b00      	cmp	r3, #0
 8000e5a:	d1f8      	bne.n	8000e4e <switch_press+0x22>
    ;
  if (press_count >= 3) {
 8000e5c:	4b2e      	ldr	r3, [pc, #184]	@ (8000f18 <switch_press+0xec>)
 8000e5e:	681b      	ldr	r3, [r3, #0]
 8000e60:	2b02      	cmp	r3, #2
 8000e62:	d932      	bls.n	8000eca <switch_press+0x9e>
    erase_flash (UPDATE_ADDR);
 8000e64:	482f      	ldr	r0, [pc, #188]	@ (8000f24 <switch_press+0xf8>)
 8000e66:	f000 f935 	bl	80010d4 <erase_flash>
    firmware_update_mode = true;
 8000e6a:	4b2f      	ldr	r3, [pc, #188]	@ (8000f28 <switch_press+0xfc>)
 8000e6c:	2201      	movs	r2, #1
 8000e6e:	701a      	strb	r2, [r3, #0]
    bool status = handle_update();
 8000e70:	f7ff ff03 	bl	8000c7a <handle_update>
 8000e74:	4603      	mov	r3, r0
 8000e76:	73fb      	strb	r3, [r7, #15]

    if (!status && recursion_depth < MAX_RECURSION_DEPTH) {
 8000e78:	7bfb      	ldrb	r3, [r7, #15]
 8000e7a:	f083 0301 	eor.w	r3, r3, #1
 8000e7e:	b2db      	uxtb	r3, r3
 8000e80:	2b00      	cmp	r3, #0
 8000e82:	d020      	beq.n	8000ec6 <switch_press+0x9a>
 8000e84:	4b29      	ldr	r3, [pc, #164]	@ (8000f2c <switch_press+0x100>)
 8000e86:	781b      	ldrb	r3, [r3, #0]
 8000e88:	2b01      	cmp	r3, #1
 8000e8a:	d81c      	bhi.n	8000ec6 <switch_press+0x9a>
      printf ("error in update !!! retry\n\r", 0x0);
 8000e8c:	2100      	movs	r1, #0
 8000e8e:	4828      	ldr	r0, [pc, #160]	@ (8000f30 <switch_press+0x104>)
 8000e90:	f7ff fce4 	bl	800085c <printf>
      recursion_depth ++;
 8000e94:	4b25      	ldr	r3, [pc, #148]	@ (8000f2c <switch_press+0x100>)
 8000e96:	781b      	ldrb	r3, [r3, #0]
 8000e98:	3301      	adds	r3, #1
 8000e9a:	b2da      	uxtb	r2, r3
 8000e9c:	4b23      	ldr	r3, [pc, #140]	@ (8000f2c <switch_press+0x100>)
 8000e9e:	701a      	strb	r2, [r3, #0]
      press_count = 0;
 8000ea0:	4b1d      	ldr	r3, [pc, #116]	@ (8000f18 <switch_press+0xec>)
 8000ea2:	2200      	movs	r2, #0
 8000ea4:	601a      	str	r2, [r3, #0]

      flag_size_recieved = false;
 8000ea6:	4b23      	ldr	r3, [pc, #140]	@ (8000f34 <switch_press+0x108>)
 8000ea8:	2200      	movs	r2, #0
 8000eaa:	701a      	strb	r2, [r3, #0]
      flag_wrong_size = false;
 8000eac:	4b22      	ldr	r3, [pc, #136]	@ (8000f38 <switch_press+0x10c>)
 8000eae:	2200      	movs	r2, #0
 8000eb0:	701a      	strb	r2, [r3, #0]
      flag_too_big_update = false;
 8000eb2:	4b22      	ldr	r3, [pc, #136]	@ (8000f3c <switch_press+0x110>)
 8000eb4:	2200      	movs	r2, #0
 8000eb6:	701a      	strb	r2, [r3, #0]

      switch_press (f1_valid, f2_valid);
 8000eb8:	79ba      	ldrb	r2, [r7, #6]
 8000eba:	79fb      	ldrb	r3, [r7, #7]
 8000ebc:	4611      	mov	r1, r2
 8000ebe:	4618      	mov	r0, r3
 8000ec0:	f7ff ffb4 	bl	8000e2c <switch_press>
 8000ec4:	e022      	b.n	8000f0c <switch_press+0xe0>
    }
    else return false;
 8000ec6:	2300      	movs	r3, #0
 8000ec8:	e021      	b.n	8000f0e <switch_press+0xe2>
  } else if (press_count == 2) {
 8000eca:	4b13      	ldr	r3, [pc, #76]	@ (8000f18 <switch_press+0xec>)
 8000ecc:	681b      	ldr	r3, [r3, #0]
 8000ece:	2b02      	cmp	r3, #2
 8000ed0:	d10e      	bne.n	8000ef0 <switch_press+0xc4>
    if (f2_valid) {
 8000ed2:	79bb      	ldrb	r3, [r7, #6]
 8000ed4:	2b00      	cmp	r3, #0
 8000ed6:	d005      	beq.n	8000ee4 <switch_press+0xb8>
      boot_f1 = false;
 8000ed8:	4b19      	ldr	r3, [pc, #100]	@ (8000f40 <switch_press+0x114>)
 8000eda:	2200      	movs	r2, #0
 8000edc:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000ede:	f7ff f9e1 	bl	80002a4 <jump_to_firmware>
 8000ee2:	e013      	b.n	8000f0c <switch_press+0xe0>
    } else {
      boot_f1 = true;
 8000ee4:	4b16      	ldr	r3, [pc, #88]	@ (8000f40 <switch_press+0x114>)
 8000ee6:	2201      	movs	r2, #1
 8000ee8:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000eea:	f7ff f9db 	bl	80002a4 <jump_to_firmware>
 8000eee:	e00d      	b.n	8000f0c <switch_press+0xe0>
    }
  } else {
    if (f1_valid) {
 8000ef0:	79fb      	ldrb	r3, [r7, #7]
 8000ef2:	2b00      	cmp	r3, #0
 8000ef4:	d005      	beq.n	8000f02 <switch_press+0xd6>
      boot_f1 = true;
 8000ef6:	4b12      	ldr	r3, [pc, #72]	@ (8000f40 <switch_press+0x114>)
 8000ef8:	2201      	movs	r2, #1
 8000efa:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000efc:	f7ff f9d2 	bl	80002a4 <jump_to_firmware>
 8000f00:	e004      	b.n	8000f0c <switch_press+0xe0>
    } else {
      boot_f1 = false;
 8000f02:	4b0f      	ldr	r3, [pc, #60]	@ (8000f40 <switch_press+0x114>)
 8000f04:	2200      	movs	r2, #0
 8000f06:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000f08:	f7ff f9cc 	bl	80002a4 <jump_to_firmware>
    }
  }
  return true;
 8000f0c:	2301      	movs	r3, #1
}
 8000f0e:	4618      	mov	r0, r3
 8000f10:	3710      	adds	r7, #16
 8000f12:	46bd      	mov	sp, r7
 8000f14:	bd80      	pop	{r7, pc}
 8000f16:	bf00      	nop
 8000f18:	20000060 	.word	0x20000060
 8000f1c:	20000064 	.word	0x20000064
 8000f20:	000f4240 	.word	0x000f4240
 8000f24:	08040000 	.word	0x08040000
 8000f28:	2000507e 	.word	0x2000507e
 8000f2c:	2000507f 	.word	0x2000507f
 8000f30:	08001af8 	.word	0x08001af8
 8000f34:	20005081 	.word	0x20005081
 8000f38:	20005082 	.word	0x20005082
 8000f3c:	20005083 	.word	0x20005083
 8000f40:	20000004 	.word	0x20000004

08000f44 <main>:


int main() {
 8000f44:	b580      	push	{r7, lr}
 8000f46:	b082      	sub	sp, #8
 8000f48:	af00      	add	r7, sp, #0

    Ring_buff_init(&ringbuffer);
 8000f4a:	4852      	ldr	r0, [pc, #328]	@ (8001094 <main+0x150>)
 8000f4c:	f7ff fa16 	bl	800037c <Ring_buff_init>

    // enable faults (without this any fault = hardfault)
    SCB->SHCSR |= SCB_SHCSR_BUSFAULTENA_Msk;
 8000f50:	4b51      	ldr	r3, [pc, #324]	@ (8001098 <main+0x154>)
 8000f52:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f54:	4a50      	ldr	r2, [pc, #320]	@ (8001098 <main+0x154>)
 8000f56:	f443 3300 	orr.w	r3, r3, #131072	@ 0x20000
 8000f5a:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_USGFAULTENA_Msk;
 8000f5c:	4b4e      	ldr	r3, [pc, #312]	@ (8001098 <main+0x154>)
 8000f5e:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f60:	4a4d      	ldr	r2, [pc, #308]	@ (8001098 <main+0x154>)
 8000f62:	f443 2380 	orr.w	r3, r3, #262144	@ 0x40000
 8000f66:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
 8000f68:	4b4b      	ldr	r3, [pc, #300]	@ (8001098 <main+0x154>)
 8000f6a:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f6c:	4a4a      	ldr	r2, [pc, #296]	@ (8001098 <main+0x154>)
 8000f6e:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 8000f72:	6253      	str	r3, [r2, #36]	@ 0x24


  __usart1_init();
 8000f74:	f000 fa04 	bl	8001380 <__usart1_init>

  printf("\n\n\nbooting....\n\n\n\r", 0x0);
 8000f78:	2100      	movs	r1, #0
 8000f7a:	4848      	ldr	r0, [pc, #288]	@ (800109c <main+0x158>)
 8000f7c:	f7ff fc6e 	bl	800085c <printf>

  // check if fimrware is corrupted during update

  if (*(uint32_t *)FIRMWARE_1_ADDRESS & 1) {
 8000f80:	4b47      	ldr	r3, [pc, #284]	@ (80010a0 <main+0x15c>)
 8000f82:	681b      	ldr	r3, [r3, #0]
 8000f84:	f003 0301 	and.w	r3, r3, #1
 8000f88:	2b00      	cmp	r3, #0
 8000f8a:	d001      	beq.n	8000f90 <main+0x4c>
    rollback();
 8000f8c:	f7ff fd92 	bl	8000ab4 <rollback>
  }
  if (*(uint32_t *)FIRMWARE_2_ADDRESS & 1) {
 8000f90:	4b44      	ldr	r3, [pc, #272]	@ (80010a4 <main+0x160>)
 8000f92:	681b      	ldr	r3, [r3, #0]
 8000f94:	f003 0301 	and.w	r3, r3, #1
 8000f98:	2b00      	cmp	r3, #0
 8000f9a:	d001      	beq.n	8000fa0 <main+0x5c>
    rollback();
 8000f9c:	f7ff fd8a 	bl	8000ab4 <rollback>
  }

  bool f1_valid = true;
 8000fa0:	2301      	movs	r3, #1
 8000fa2:	71fb      	strb	r3, [r7, #7]
  bool f2_valid = true;
 8000fa4:	2301      	movs	r3, #1
 8000fa6:	71bb      	strb	r3, [r7, #6]
  init_firmware_t(FIRMWARE_1_ADDRESS, &f1);
 8000fa8:	493f      	ldr	r1, [pc, #252]	@ (80010a8 <main+0x164>)
 8000faa:	483d      	ldr	r0, [pc, #244]	@ (80010a0 <main+0x15c>)
 8000fac:	f7ff fde8 	bl	8000b80 <init_firmware_t>
  init_firmware_t(FIRMWARE_2_ADDRESS, &f2);
 8000fb0:	493e      	ldr	r1, [pc, #248]	@ (80010ac <main+0x168>)
 8000fb2:	483c      	ldr	r0, [pc, #240]	@ (80010a4 <main+0x160>)
 8000fb4:	f7ff fde4 	bl	8000b80 <init_firmware_t>

  // printf("hii there %\n\r", f1.__vtable_address);

  printf("*************validating firmware1*************\n\r", 0x0);
 8000fb8:	2100      	movs	r1, #0
 8000fba:	483d      	ldr	r0, [pc, #244]	@ (80010b0 <main+0x16c>)
 8000fbc:	f7ff fc4e 	bl	800085c <printf>
  f1_valid = validate_firmware(&f1);
 8000fc0:	4839      	ldr	r0, [pc, #228]	@ (80010a8 <main+0x164>)
 8000fc2:	f7ff fb2f 	bl	8000624 <validate_firmware>
 8000fc6:	4603      	mov	r3, r0
 8000fc8:	71fb      	strb	r3, [r7, #7]
  printf("*************validating firmware2*************\n\r", 0x0);
 8000fca:	2100      	movs	r1, #0
 8000fcc:	4839      	ldr	r0, [pc, #228]	@ (80010b4 <main+0x170>)
 8000fce:	f7ff fc45 	bl	800085c <printf>
  f2_valid = validate_firmware(&f2);
 8000fd2:	4836      	ldr	r0, [pc, #216]	@ (80010ac <main+0x168>)
 8000fd4:	f7ff fb26 	bl	8000624 <validate_firmware>
 8000fd8:	4603      	mov	r3, r0
 8000fda:	71bb      	strb	r3, [r7, #6]

  printf("both the firmwares are checked\n\r", 0x0);
 8000fdc:	2100      	movs	r1, #0
 8000fde:	4836      	ldr	r0, [pc, #216]	@ (80010b8 <main+0x174>)
 8000fe0:	f7ff fc3c 	bl	800085c <printf>
  // init GPIOC (for on board switch)
  // init SYSCGF (for using EXTI)

  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN_Msk;
 8000fe4:	4b35      	ldr	r3, [pc, #212]	@ (80010bc <main+0x178>)
 8000fe6:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8000fe8:	4a34      	ldr	r2, [pc, #208]	@ (80010bc <main+0x178>)
 8000fea:	f443 4380 	orr.w	r3, r3, #16384	@ 0x4000
 8000fee:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN_Msk;
 8000ff0:	4b32      	ldr	r3, [pc, #200]	@ (80010bc <main+0x178>)
 8000ff2:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8000ff4:	4a31      	ldr	r2, [pc, #196]	@ (80010bc <main+0x178>)
 8000ff6:	f043 0304 	orr.w	r3, r3, #4
 8000ffa:	6313      	str	r3, [r2, #48]	@ 0x30

  // set switch to input
  GPIOC->MODER &= ~(3U << (2 * SWITCH_PIN));
 8000ffc:	4b30      	ldr	r3, [pc, #192]	@ (80010c0 <main+0x17c>)
 8000ffe:	681b      	ldr	r3, [r3, #0]
 8001000:	4a2f      	ldr	r2, [pc, #188]	@ (80010c0 <main+0x17c>)
 8001002:	f023 6340 	bic.w	r3, r3, #201326592	@ 0xc000000
 8001006:	6013      	str	r3, [r2, #0]

  // falling edge detect
  EXTI->FTSR |= EXTI_FTSR_TR13_Msk;
 8001008:	4b2e      	ldr	r3, [pc, #184]	@ (80010c4 <main+0x180>)
 800100a:	68db      	ldr	r3, [r3, #12]
 800100c:	4a2d      	ldr	r2, [pc, #180]	@ (80010c4 <main+0x180>)
 800100e:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8001012:	60d3      	str	r3, [r2, #12]

  SYSCFG->EXTICR[3] &= ~(SYSCFG_EXTICR4_EXTI13_Msk);
 8001014:	4b2c      	ldr	r3, [pc, #176]	@ (80010c8 <main+0x184>)
 8001016:	695b      	ldr	r3, [r3, #20]
 8001018:	4a2b      	ldr	r2, [pc, #172]	@ (80010c8 <main+0x184>)
 800101a:	f023 03f0 	bic.w	r3, r3, #240	@ 0xf0
 800101e:	6153      	str	r3, [r2, #20]
  SYSCFG->EXTICR[3] |= SYSCFG_EXTICR4_EXTI13_PC;
 8001020:	4b29      	ldr	r3, [pc, #164]	@ (80010c8 <main+0x184>)
 8001022:	695b      	ldr	r3, [r3, #20]
 8001024:	4a28      	ldr	r2, [pc, #160]	@ (80010c8 <main+0x184>)
 8001026:	f043 0320 	orr.w	r3, r3, #32
 800102a:	6153      	str	r3, [r2, #20]

  // enable mask at the end
  EXTI->IMR |= EXTI_IMR_MR13_Msk;
 800102c:	4b25      	ldr	r3, [pc, #148]	@ (80010c4 <main+0x180>)
 800102e:	681b      	ldr	r3, [r3, #0]
 8001030:	4a24      	ldr	r2, [pc, #144]	@ (80010c4 <main+0x180>)
 8001032:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8001036:	6013      	str	r3, [r2, #0]

  NVIC_EnableIRQ(EXTI15_10_IRQn);
 8001038:	2028      	movs	r0, #40	@ 0x28
 800103a:	f7ff fd85 	bl	8000b48 <__NVIC_EnableIRQ>

  if (!f1_valid && !f2_valid) {
 800103e:	79fb      	ldrb	r3, [r7, #7]
 8001040:	f083 0301 	eor.w	r3, r3, #1
 8001044:	b2db      	uxtb	r3, r3
 8001046:	2b00      	cmp	r3, #0
 8001048:	d011      	beq.n	800106e <main+0x12a>
 800104a:	79bb      	ldrb	r3, [r7, #6]
 800104c:	f083 0301 	eor.w	r3, r3, #1
 8001050:	b2db      	uxtb	r3, r3
 8001052:	2b00      	cmp	r3, #0
 8001054:	d00b      	beq.n	800106e <main+0x12a>
    printf("both the firmwares are not valid\n\n\r", 0x0);
 8001056:	2100      	movs	r1, #0
 8001058:	481c      	ldr	r0, [pc, #112]	@ (80010cc <main+0x188>)
 800105a:	f7ff fbff 	bl	800085c <printf>
    EXTI->IMR &= EXTI_IMR_MR13_Msk;
 800105e:	4b19      	ldr	r3, [pc, #100]	@ (80010c4 <main+0x180>)
 8001060:	681b      	ldr	r3, [r3, #0]
 8001062:	4a18      	ldr	r2, [pc, #96]	@ (80010c4 <main+0x180>)
 8001064:	f403 5300 	and.w	r3, r3, #8192	@ 0x2000
 8001068:	6013      	str	r3, [r2, #0]
    handle_update();
 800106a:	f7ff fe06 	bl	8000c7a <handle_update>
  }

  // /* illegal memory access */
  // *(uint32_t *) (0xffffffff) = 0;
  
  bool status = switch_press (f1_valid, f2_valid);
 800106e:	79ba      	ldrb	r2, [r7, #6]
 8001070:	79fb      	ldrb	r3, [r7, #7]
 8001072:	4611      	mov	r1, r2
 8001074:	4618      	mov	r0, r3
 8001076:	f7ff fed9 	bl	8000e2c <switch_press>
 800107a:	4603      	mov	r3, r0
 800107c:	717b      	strb	r3, [r7, #5]
  if (!status){
 800107e:	797b      	ldrb	r3, [r7, #5]
 8001080:	f083 0301 	eor.w	r3, r3, #1
 8001084:	b2db      	uxtb	r3, r3
 8001086:	2b00      	cmp	r3, #0
 8001088:	d003      	beq.n	8001092 <main+0x14e>
    printf ("too many wrong firmware update attempt !!!\n\r", 0x0);
 800108a:	2100      	movs	r1, #0
 800108c:	4810      	ldr	r0, [pc, #64]	@ (80010d0 <main+0x18c>)
 800108e:	f7ff fbe5 	bl	800085c <printf>
  }
  while (1);
 8001092:	e7fe      	b.n	8001092 <main+0x14e>
 8001094:	20000078 	.word	0x20000078
 8001098:	e000ed00 	.word	0xe000ed00
 800109c:	08001b14 	.word	0x08001b14
 80010a0:	08010000 	.word	0x08010000
 80010a4:	08020000 	.word	0x08020000
 80010a8:	20000008 	.word	0x20000008
 80010ac:	20000034 	.word	0x20000034
 80010b0:	08001b28 	.word	0x08001b28
 80010b4:	08001b5c 	.word	0x08001b5c
 80010b8:	08001b90 	.word	0x08001b90
 80010bc:	40023800 	.word	0x40023800
 80010c0:	40020800 	.word	0x40020800
 80010c4:	40013c00 	.word	0x40013c00
 80010c8:	40013800 	.word	0x40013800
 80010cc:	08001bb4 	.word	0x08001bb4
 80010d0:	08001bd8 	.word	0x08001bd8

080010d4 <erase_flash>:
#define KEY1 0x45670123
#define KEY2 0xCDEF89AB

void printf (const char *string, uint32_t addr);

uint32_t erase_flash(uint32_t address) {
 80010d4:	b580      	push	{r7, lr}
 80010d6:	b084      	sub	sp, #16
 80010d8:	af00      	add	r7, sp, #0
 80010da:	6078      	str	r0, [r7, #4]
  if (address >= 0x08080000 || address < 0x08000000) {
 80010dc:	687b      	ldr	r3, [r7, #4]
 80010de:	4a4c      	ldr	r2, [pc, #304]	@ (8001210 <erase_flash+0x13c>)
 80010e0:	4293      	cmp	r3, r2
 80010e2:	d803      	bhi.n	80010ec <erase_flash+0x18>
 80010e4:	687b      	ldr	r3, [r7, #4]
 80010e6:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 80010ea:	d206      	bcs.n	80010fa <erase_flash+0x26>
    printf("wrong address \n\r", 0x0);
 80010ec:	2100      	movs	r1, #0
 80010ee:	4849      	ldr	r0, [pc, #292]	@ (8001214 <erase_flash+0x140>)
 80010f0:	f7ff fbb4 	bl	800085c <printf>
    return -1;
 80010f4:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80010f8:	e085      	b.n	8001206 <erase_flash+0x132>
  }

  uint32_t sector = 0;
 80010fa:	2300      	movs	r3, #0
 80010fc:	60fb      	str	r3, [r7, #12]
  if (address >= 0x08060000)
 80010fe:	687b      	ldr	r3, [r7, #4]
 8001100:	4a45      	ldr	r2, [pc, #276]	@ (8001218 <erase_flash+0x144>)
 8001102:	4293      	cmp	r3, r2
 8001104:	d902      	bls.n	800110c <erase_flash+0x38>
    sector = 7;
 8001106:	2307      	movs	r3, #7
 8001108:	60fb      	str	r3, [r7, #12]
 800110a:	e037      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08040000)
 800110c:	687b      	ldr	r3, [r7, #4]
 800110e:	4a43      	ldr	r2, [pc, #268]	@ (800121c <erase_flash+0x148>)
 8001110:	4293      	cmp	r3, r2
 8001112:	d902      	bls.n	800111a <erase_flash+0x46>
    sector = 6;
 8001114:	2306      	movs	r3, #6
 8001116:	60fb      	str	r3, [r7, #12]
 8001118:	e030      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08020000)
 800111a:	687b      	ldr	r3, [r7, #4]
 800111c:	4a40      	ldr	r2, [pc, #256]	@ (8001220 <erase_flash+0x14c>)
 800111e:	4293      	cmp	r3, r2
 8001120:	d902      	bls.n	8001128 <erase_flash+0x54>
    sector = 5;
 8001122:	2305      	movs	r3, #5
 8001124:	60fb      	str	r3, [r7, #12]
 8001126:	e029      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08010000)
 8001128:	687b      	ldr	r3, [r7, #4]
 800112a:	4a3e      	ldr	r2, [pc, #248]	@ (8001224 <erase_flash+0x150>)
 800112c:	4293      	cmp	r3, r2
 800112e:	d902      	bls.n	8001136 <erase_flash+0x62>
    sector = 4;
 8001130:	2304      	movs	r3, #4
 8001132:	60fb      	str	r3, [r7, #12]
 8001134:	e022      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x0800c000)
 8001136:	687b      	ldr	r3, [r7, #4]
 8001138:	4a3b      	ldr	r2, [pc, #236]	@ (8001228 <erase_flash+0x154>)
 800113a:	4293      	cmp	r3, r2
 800113c:	d302      	bcc.n	8001144 <erase_flash+0x70>
    sector = 3;
 800113e:	2303      	movs	r3, #3
 8001140:	60fb      	str	r3, [r7, #12]
 8001142:	e01b      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08008000)
 8001144:	687b      	ldr	r3, [r7, #4]
 8001146:	4a39      	ldr	r2, [pc, #228]	@ (800122c <erase_flash+0x158>)
 8001148:	4293      	cmp	r3, r2
 800114a:	d302      	bcc.n	8001152 <erase_flash+0x7e>
    sector = 2;
 800114c:	2302      	movs	r3, #2
 800114e:	60fb      	str	r3, [r7, #12]
 8001150:	e014      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08004000)
 8001152:	687b      	ldr	r3, [r7, #4]
 8001154:	4a36      	ldr	r2, [pc, #216]	@ (8001230 <erase_flash+0x15c>)
 8001156:	4293      	cmp	r3, r2
 8001158:	d302      	bcc.n	8001160 <erase_flash+0x8c>
    sector = 1;
 800115a:	2301      	movs	r3, #1
 800115c:	60fb      	str	r3, [r7, #12]
 800115e:	e00d      	b.n	800117c <erase_flash+0xa8>
  else if (address >= 0x08000000)
 8001160:	687b      	ldr	r3, [r7, #4]
 8001162:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 8001166:	d302      	bcc.n	800116e <erase_flash+0x9a>
    sector = 0;
 8001168:	2300      	movs	r3, #0
 800116a:	60fb      	str	r3, [r7, #12]
 800116c:	e006      	b.n	800117c <erase_flash+0xa8>
  else {
    printf("wrong address\n\r", 0x0);
 800116e:	2100      	movs	r1, #0
 8001170:	4830      	ldr	r0, [pc, #192]	@ (8001234 <erase_flash+0x160>)
 8001172:	f7ff fb73 	bl	800085c <printf>
    return -1;
 8001176:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 800117a:	e044      	b.n	8001206 <erase_flash+0x132>
  }
  // unlock
  FLASH->KEYR = KEY1;
 800117c:	4b2e      	ldr	r3, [pc, #184]	@ (8001238 <erase_flash+0x164>)
 800117e:	4a2f      	ldr	r2, [pc, #188]	@ (800123c <erase_flash+0x168>)
 8001180:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 8001182:	4b2d      	ldr	r3, [pc, #180]	@ (8001238 <erase_flash+0x164>)
 8001184:	4a2e      	ldr	r2, [pc, #184]	@ (8001240 <erase_flash+0x16c>)
 8001186:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8001188:	4b2b      	ldr	r3, [pc, #172]	@ (8001238 <erase_flash+0x164>)
 800118a:	68db      	ldr	r3, [r3, #12]
 800118c:	4a2a      	ldr	r2, [pc, #168]	@ (8001238 <erase_flash+0x164>)
 800118e:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 8001192:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 8001194:	bf00      	nop
 8001196:	4b28      	ldr	r3, [pc, #160]	@ (8001238 <erase_flash+0x164>)
 8001198:	68db      	ldr	r3, [r3, #12]
 800119a:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 800119e:	2b00      	cmp	r3, #0
 80011a0:	d1f9      	bne.n	8001196 <erase_flash+0xc2>
    ;

  FLASH->CR |= FLASH_CR_SER;
 80011a2:	4b25      	ldr	r3, [pc, #148]	@ (8001238 <erase_flash+0x164>)
 80011a4:	691b      	ldr	r3, [r3, #16]
 80011a6:	4a24      	ldr	r2, [pc, #144]	@ (8001238 <erase_flash+0x164>)
 80011a8:	f043 0302 	orr.w	r3, r3, #2
 80011ac:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(FLASH_CR_SNB);
 80011ae:	4b22      	ldr	r3, [pc, #136]	@ (8001238 <erase_flash+0x164>)
 80011b0:	691b      	ldr	r3, [r3, #16]
 80011b2:	4a21      	ldr	r2, [pc, #132]	@ (8001238 <erase_flash+0x164>)
 80011b4:	f023 03f8 	bic.w	r3, r3, #248	@ 0xf8
 80011b8:	6113      	str	r3, [r2, #16]
  FLASH->CR |= (sector << FLASH_CR_SNB_Pos);
 80011ba:	4b1f      	ldr	r3, [pc, #124]	@ (8001238 <erase_flash+0x164>)
 80011bc:	691a      	ldr	r2, [r3, #16]
 80011be:	68fb      	ldr	r3, [r7, #12]
 80011c0:	00db      	lsls	r3, r3, #3
 80011c2:	491d      	ldr	r1, [pc, #116]	@ (8001238 <erase_flash+0x164>)
 80011c4:	4313      	orrs	r3, r2
 80011c6:	610b      	str	r3, [r1, #16]
  FLASH->CR |= FLASH_CR_STRT;
 80011c8:	4b1b      	ldr	r3, [pc, #108]	@ (8001238 <erase_flash+0x164>)
 80011ca:	691b      	ldr	r3, [r3, #16]
 80011cc:	4a1a      	ldr	r2, [pc, #104]	@ (8001238 <erase_flash+0x164>)
 80011ce:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 80011d2:	6113      	str	r3, [r2, #16]

  // wait for the flash to be erased;
  while (FLASH->SR & FLASH_SR_BSY)
 80011d4:	bf00      	nop
 80011d6:	4b18      	ldr	r3, [pc, #96]	@ (8001238 <erase_flash+0x164>)
 80011d8:	68db      	ldr	r3, [r3, #12]
 80011da:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 80011de:	2b00      	cmp	r3, #0
 80011e0:	d1f9      	bne.n	80011d6 <erase_flash+0x102>
    ;

  // clear the erase bit
  FLASH->CR &= ~(FLASH_CR_SER);
 80011e2:	4b15      	ldr	r3, [pc, #84]	@ (8001238 <erase_flash+0x164>)
 80011e4:	691b      	ldr	r3, [r3, #16]
 80011e6:	4a14      	ldr	r2, [pc, #80]	@ (8001238 <erase_flash+0x164>)
 80011e8:	f023 0302 	bic.w	r3, r3, #2
 80011ec:	6113      	str	r3, [r2, #16]
  // lock the control register
  FLASH->CR |= FLASH_CR_LOCK;
 80011ee:	4b12      	ldr	r3, [pc, #72]	@ (8001238 <erase_flash+0x164>)
 80011f0:	691b      	ldr	r3, [r3, #16]
 80011f2:	4a11      	ldr	r2, [pc, #68]	@ (8001238 <erase_flash+0x164>)
 80011f4:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 80011f8:	6113      	str	r3, [r2, #16]

  printf("done erasing flash (address = %)\n\r", (uint32_t)(&address));
 80011fa:	1d3b      	adds	r3, r7, #4
 80011fc:	4619      	mov	r1, r3
 80011fe:	4811      	ldr	r0, [pc, #68]	@ (8001244 <erase_flash+0x170>)
 8001200:	f7ff fb2c 	bl	800085c <printf>
  return 0;
 8001204:	2300      	movs	r3, #0
}
 8001206:	4618      	mov	r0, r3
 8001208:	3710      	adds	r7, #16
 800120a:	46bd      	mov	sp, r7
 800120c:	bd80      	pop	{r7, pc}
 800120e:	bf00      	nop
 8001210:	0807ffff 	.word	0x0807ffff
 8001214:	08001c08 	.word	0x08001c08
 8001218:	0805ffff 	.word	0x0805ffff
 800121c:	0803ffff 	.word	0x0803ffff
 8001220:	0801ffff 	.word	0x0801ffff
 8001224:	0800ffff 	.word	0x0800ffff
 8001228:	0800c000 	.word	0x0800c000
 800122c:	08008000 	.word	0x08008000
 8001230:	08004000 	.word	0x08004000
 8001234:	08001c1c 	.word	0x08001c1c
 8001238:	40023c00 	.word	0x40023c00
 800123c:	45670123 	.word	0x45670123
 8001240:	cdef89ab 	.word	0xcdef89ab
 8001244:	08001c2c 	.word	0x08001c2c

08001248 <flash_write>:

uint32_t flash_write(uint32_t address, const char *buff, uint32_t size,
                     uint32_t simulate) {
 8001248:	b480      	push	{r7}
 800124a:	b087      	sub	sp, #28
 800124c:	af00      	add	r7, sp, #0
 800124e:	60f8      	str	r0, [r7, #12]
 8001250:	60b9      	str	r1, [r7, #8]
 8001252:	607a      	str	r2, [r7, #4]
 8001254:	603b      	str	r3, [r7, #0]


  // unlock
  FLASH->KEYR = KEY1;
 8001256:	4b26      	ldr	r3, [pc, #152]	@ (80012f0 <flash_write+0xa8>)
 8001258:	4a26      	ldr	r2, [pc, #152]	@ (80012f4 <flash_write+0xac>)
 800125a:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 800125c:	4b24      	ldr	r3, [pc, #144]	@ (80012f0 <flash_write+0xa8>)
 800125e:	4a26      	ldr	r2, [pc, #152]	@ (80012f8 <flash_write+0xb0>)
 8001260:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8001262:	4b23      	ldr	r3, [pc, #140]	@ (80012f0 <flash_write+0xa8>)
 8001264:	68db      	ldr	r3, [r3, #12]
 8001266:	4a22      	ldr	r2, [pc, #136]	@ (80012f0 <flash_write+0xa8>)
 8001268:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 800126c:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 800126e:	bf00      	nop
 8001270:	4b1f      	ldr	r3, [pc, #124]	@ (80012f0 <flash_write+0xa8>)
 8001272:	68db      	ldr	r3, [r3, #12]
 8001274:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 8001278:	2b00      	cmp	r3, #0
 800127a:	d1f9      	bne.n	8001270 <flash_write+0x28>
    ;
  FLASH->CR |= FLASH_CR_PG;
 800127c:	4b1c      	ldr	r3, [pc, #112]	@ (80012f0 <flash_write+0xa8>)
 800127e:	691b      	ldr	r3, [r3, #16]
 8001280:	4a1b      	ldr	r2, [pc, #108]	@ (80012f0 <flash_write+0xa8>)
 8001282:	f043 0301 	orr.w	r3, r3, #1
 8001286:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(3 << FLASH_CR_PSIZE_Pos);
 8001288:	4b19      	ldr	r3, [pc, #100]	@ (80012f0 <flash_write+0xa8>)
 800128a:	691b      	ldr	r3, [r3, #16]
 800128c:	4a18      	ldr	r2, [pc, #96]	@ (80012f0 <flash_write+0xa8>)
 800128e:	f423 7340 	bic.w	r3, r3, #768	@ 0x300
 8001292:	6113      	str	r3, [r2, #16]
  // set PSIZE bit to 2 for 32 bit programming
  FLASH->CR |= 2 << FLASH_CR_PSIZE_Pos;
 8001294:	4b16      	ldr	r3, [pc, #88]	@ (80012f0 <flash_write+0xa8>)
 8001296:	691b      	ldr	r3, [r3, #16]
 8001298:	4a15      	ldr	r2, [pc, #84]	@ (80012f0 <flash_write+0xa8>)
 800129a:	f443 7300 	orr.w	r3, r3, #512	@ 0x200
 800129e:	6113      	str	r3, [r2, #16]

  uint32_t i = 0;
 80012a0:	2300      	movs	r3, #0
 80012a2:	617b      	str	r3, [r7, #20]
  while (i < size / 4) {
 80012a4:	e00c      	b.n	80012c0 <flash_write+0x78>

    *((uint32_t *)address) = ((const uint32_t *)buff)[i];
 80012a6:	697b      	ldr	r3, [r7, #20]
 80012a8:	009b      	lsls	r3, r3, #2
 80012aa:	68ba      	ldr	r2, [r7, #8]
 80012ac:	441a      	add	r2, r3
 80012ae:	68fb      	ldr	r3, [r7, #12]
 80012b0:	6812      	ldr	r2, [r2, #0]
 80012b2:	601a      	str	r2, [r3, #0]
    i++;
 80012b4:	697b      	ldr	r3, [r7, #20]
 80012b6:	3301      	adds	r3, #1
 80012b8:	617b      	str	r3, [r7, #20]
    address += 4;
 80012ba:	68fb      	ldr	r3, [r7, #12]
 80012bc:	3304      	adds	r3, #4
 80012be:	60fb      	str	r3, [r7, #12]
  while (i < size / 4) {
 80012c0:	687b      	ldr	r3, [r7, #4]
 80012c2:	089b      	lsrs	r3, r3, #2
 80012c4:	697a      	ldr	r2, [r7, #20]
 80012c6:	429a      	cmp	r2, r3
 80012c8:	d3ed      	bcc.n	80012a6 <flash_write+0x5e>
  }
  FLASH->CR &= ~(FLASH_CR_PG);
 80012ca:	4b09      	ldr	r3, [pc, #36]	@ (80012f0 <flash_write+0xa8>)
 80012cc:	691b      	ldr	r3, [r3, #16]
 80012ce:	4a08      	ldr	r2, [pc, #32]	@ (80012f0 <flash_write+0xa8>)
 80012d0:	f023 0301 	bic.w	r3, r3, #1
 80012d4:	6113      	str	r3, [r2, #16]
  FLASH->CR |= FLASH_CR_LOCK;
 80012d6:	4b06      	ldr	r3, [pc, #24]	@ (80012f0 <flash_write+0xa8>)
 80012d8:	691b      	ldr	r3, [r3, #16]
 80012da:	4a05      	ldr	r2, [pc, #20]	@ (80012f0 <flash_write+0xa8>)
 80012dc:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 80012e0:	6113      	str	r3, [r2, #16]

  return 0;
 80012e2:	2300      	movs	r3, #0
}
 80012e4:	4618      	mov	r0, r3
 80012e6:	371c      	adds	r7, #28
 80012e8:	46bd      	mov	sp, r7
 80012ea:	bc80      	pop	{r7}
 80012ec:	4770      	bx	lr
 80012ee:	bf00      	nop
 80012f0:	40023c00 	.word	0x40023c00
 80012f4:	45670123 	.word	0x45670123
 80012f8:	cdef89ab 	.word	0xcdef89ab

080012fc <__NVIC_EnableIRQ>:
{
 80012fc:	b480      	push	{r7}
 80012fe:	b083      	sub	sp, #12
 8001300:	af00      	add	r7, sp, #0
 8001302:	4603      	mov	r3, r0
 8001304:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 8001306:	f997 3007 	ldrsb.w	r3, [r7, #7]
 800130a:	2b00      	cmp	r3, #0
 800130c:	db0b      	blt.n	8001326 <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 800130e:	79fb      	ldrb	r3, [r7, #7]
 8001310:	f003 021f 	and.w	r2, r3, #31
 8001314:	4906      	ldr	r1, [pc, #24]	@ (8001330 <__NVIC_EnableIRQ+0x34>)
 8001316:	f997 3007 	ldrsb.w	r3, [r7, #7]
 800131a:	095b      	lsrs	r3, r3, #5
 800131c:	2001      	movs	r0, #1
 800131e:	fa00 f202 	lsl.w	r2, r0, r2
 8001322:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 8001326:	bf00      	nop
 8001328:	370c      	adds	r7, #12
 800132a:	46bd      	mov	sp, r7
 800132c:	bc80      	pop	{r7}
 800132e:	4770      	bx	lr
 8001330:	e000e100 	.word	0xe000e100

08001334 <__usart1_scan>:
#include "stm32f401xe.h"

#define TX_PIN 9
#define RX_PIN 10

void __usart1_scan (char* buffer, uint16_t size){
 8001334:	b480      	push	{r7}
 8001336:	b085      	sub	sp, #20
 8001338:	af00      	add	r7, sp, #0
 800133a:	6078      	str	r0, [r7, #4]
 800133c:	460b      	mov	r3, r1
 800133e:	807b      	strh	r3, [r7, #2]
  
  uint16_t i = 0;
 8001340:	2300      	movs	r3, #0
 8001342:	81fb      	strh	r3, [r7, #14]
  while (i < size) {
 8001344:	e010      	b.n	8001368 <__usart1_scan+0x34>
    // wait
    while (!(USART1->SR & USART_SR_RXNE))
 8001346:	bf00      	nop
 8001348:	4b0c      	ldr	r3, [pc, #48]	@ (800137c <__usart1_scan+0x48>)
 800134a:	681b      	ldr	r3, [r3, #0]
 800134c:	f003 0320 	and.w	r3, r3, #32
 8001350:	2b00      	cmp	r3, #0
 8001352:	d0f9      	beq.n	8001348 <__usart1_scan+0x14>
      ;
    buffer[i++] = USART1->DR;
 8001354:	4b09      	ldr	r3, [pc, #36]	@ (800137c <__usart1_scan+0x48>)
 8001356:	685a      	ldr	r2, [r3, #4]
 8001358:	89fb      	ldrh	r3, [r7, #14]
 800135a:	1c59      	adds	r1, r3, #1
 800135c:	81f9      	strh	r1, [r7, #14]
 800135e:	4619      	mov	r1, r3
 8001360:	687b      	ldr	r3, [r7, #4]
 8001362:	440b      	add	r3, r1
 8001364:	b2d2      	uxtb	r2, r2
 8001366:	701a      	strb	r2, [r3, #0]
  while (i < size) {
 8001368:	89fa      	ldrh	r2, [r7, #14]
 800136a:	887b      	ldrh	r3, [r7, #2]
 800136c:	429a      	cmp	r2, r3
 800136e:	d3ea      	bcc.n	8001346 <__usart1_scan+0x12>
  }
}
 8001370:	bf00      	nop
 8001372:	bf00      	nop
 8001374:	3714      	adds	r7, #20
 8001376:	46bd      	mov	sp, r7
 8001378:	bc80      	pop	{r7}
 800137a:	4770      	bx	lr
 800137c:	40011000 	.word	0x40011000

08001380 <__usart1_init>:

void __usart1_init(void) {
 8001380:	b580      	push	{r7, lr}
 8001382:	af00      	add	r7, sp, #0

  RCC->APB2ENR |= RCC_APB2ENR_USART1EN_Msk;
 8001384:	4b20      	ldr	r3, [pc, #128]	@ (8001408 <__usart1_init+0x88>)
 8001386:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8001388:	4a1f      	ldr	r2, [pc, #124]	@ (8001408 <__usart1_init+0x88>)
 800138a:	f043 0310 	orr.w	r3, r3, #16
 800138e:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
 8001390:	4b1d      	ldr	r3, [pc, #116]	@ (8001408 <__usart1_init+0x88>)
 8001392:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8001394:	4a1c      	ldr	r2, [pc, #112]	@ (8001408 <__usart1_init+0x88>)
 8001396:	f043 0301 	orr.w	r3, r3, #1
 800139a:	6313      	str	r3, [r2, #48]	@ 0x30
  // alternate function mode
  GPIOA->MODER &= ~((3 << (2 * TX_PIN)) | (3 << (2 * RX_PIN)));
 800139c:	4b1b      	ldr	r3, [pc, #108]	@ (800140c <__usart1_init+0x8c>)
 800139e:	681b      	ldr	r3, [r3, #0]
 80013a0:	4a1a      	ldr	r2, [pc, #104]	@ (800140c <__usart1_init+0x8c>)
 80013a2:	f423 1370 	bic.w	r3, r3, #3932160	@ 0x3c0000
 80013a6:	6013      	str	r3, [r2, #0]
  GPIOA->MODER |= 2 << (2 * TX_PIN) | 2 << (2 * RX_PIN);
 80013a8:	4b18      	ldr	r3, [pc, #96]	@ (800140c <__usart1_init+0x8c>)
 80013aa:	681b      	ldr	r3, [r3, #0]
 80013ac:	4a17      	ldr	r2, [pc, #92]	@ (800140c <__usart1_init+0x8c>)
 80013ae:	f443 1320 	orr.w	r3, r3, #2621440	@ 0x280000
 80013b2:	6013      	str	r3, [r2, #0]
  // high speed
  GPIOA->OSPEEDR |= (3 << (TX_PIN * 2)) | (3 << (RX_PIN * 2));
 80013b4:	4b15      	ldr	r3, [pc, #84]	@ (800140c <__usart1_init+0x8c>)
 80013b6:	689b      	ldr	r3, [r3, #8]
 80013b8:	4a14      	ldr	r2, [pc, #80]	@ (800140c <__usart1_init+0x8c>)
 80013ba:	f443 1370 	orr.w	r3, r3, #3932160	@ 0x3c0000
 80013be:	6093      	str	r3, [r2, #8]
  // clear the bits in AFR register
  GPIOA->AFR[1] &= ~((0xf << 4) | (0xf << 8));
 80013c0:	4b12      	ldr	r3, [pc, #72]	@ (800140c <__usart1_init+0x8c>)
 80013c2:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80013c4:	4a11      	ldr	r2, [pc, #68]	@ (800140c <__usart1_init+0x8c>)
 80013c6:	f423 637f 	bic.w	r3, r3, #4080	@ 0xff0
 80013ca:	6253      	str	r3, [r2, #36]	@ 0x24
  // set for af7
  GPIOA->AFR[1] |= (7 << 4) | (7 << 8);
 80013cc:	4b0f      	ldr	r3, [pc, #60]	@ (800140c <__usart1_init+0x8c>)
 80013ce:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80013d0:	4a0e      	ldr	r2, [pc, #56]	@ (800140c <__usart1_init+0x8c>)
 80013d2:	f443 63ee 	orr.w	r3, r3, #1904	@ 0x770
 80013d6:	6253      	str	r3, [r2, #36]	@ 0x24

  // set the baud rate (115200 in this case)
  USART1->BRR = 0x08B;
 80013d8:	4b0d      	ldr	r3, [pc, #52]	@ (8001410 <__usart1_init+0x90>)
 80013da:	228b      	movs	r2, #139	@ 0x8b
 80013dc:	609a      	str	r2, [r3, #8]

  // enable usart reciever interrupt;
  USART1->CR1 = USART_CR1_RXNEIE;
 80013de:	4b0c      	ldr	r3, [pc, #48]	@ (8001410 <__usart1_init+0x90>)
 80013e0:	2220      	movs	r2, #32
 80013e2:	60da      	str	r2, [r3, #12]

  NVIC_EnableIRQ (USART1_IRQn);
 80013e4:	2025      	movs	r0, #37	@ 0x25
 80013e6:	f7ff ff89 	bl	80012fc <__NVIC_EnableIRQ>

  // enable transmitter and reciever at the end
  USART1->CR1 |= USART_CR1_RE | USART_CR1_TE;
 80013ea:	4b09      	ldr	r3, [pc, #36]	@ (8001410 <__usart1_init+0x90>)
 80013ec:	68db      	ldr	r3, [r3, #12]
 80013ee:	4a08      	ldr	r2, [pc, #32]	@ (8001410 <__usart1_init+0x90>)
 80013f0:	f043 030c 	orr.w	r3, r3, #12
 80013f4:	60d3      	str	r3, [r2, #12]

  // enable usart
  USART1->CR1 |= USART_CR1_UE;
 80013f6:	4b06      	ldr	r3, [pc, #24]	@ (8001410 <__usart1_init+0x90>)
 80013f8:	68db      	ldr	r3, [r3, #12]
 80013fa:	4a05      	ldr	r2, [pc, #20]	@ (8001410 <__usart1_init+0x90>)
 80013fc:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8001400:	60d3      	str	r3, [r2, #12]

}
 8001402:	bf00      	nop
 8001404:	bd80      	pop	{r7, pc}
 8001406:	bf00      	nop
 8001408:	40023800 	.word	0x40023800
 800140c:	40020000 	.word	0x40020000
 8001410:	40011000 	.word	0x40011000

08001414 <__usart1_print>:

void __usart1_print(const char *msg, uint32_t size) {
 8001414:	b480      	push	{r7}
 8001416:	b085      	sub	sp, #20
 8001418:	af00      	add	r7, sp, #0
 800141a:	6078      	str	r0, [r7, #4]
 800141c:	6039      	str	r1, [r7, #0]

  int i = 0;
 800141e:	2300      	movs	r3, #0
 8001420:	60fb      	str	r3, [r7, #12]
  while (i < size && msg[i] != '\0') {
 8001422:	e00f      	b.n	8001444 <__usart1_print+0x30>
    while (!(USART1->SR & USART_SR_TXE))
 8001424:	bf00      	nop
 8001426:	4b13      	ldr	r3, [pc, #76]	@ (8001474 <__usart1_print+0x60>)
 8001428:	681b      	ldr	r3, [r3, #0]
 800142a:	f003 0380 	and.w	r3, r3, #128	@ 0x80
 800142e:	2b00      	cmp	r3, #0
 8001430:	d0f9      	beq.n	8001426 <__usart1_print+0x12>
      ;
    USART1->DR = msg[i++];
 8001432:	68fb      	ldr	r3, [r7, #12]
 8001434:	1c5a      	adds	r2, r3, #1
 8001436:	60fa      	str	r2, [r7, #12]
 8001438:	461a      	mov	r2, r3
 800143a:	687b      	ldr	r3, [r7, #4]
 800143c:	4413      	add	r3, r2
 800143e:	781a      	ldrb	r2, [r3, #0]
 8001440:	4b0c      	ldr	r3, [pc, #48]	@ (8001474 <__usart1_print+0x60>)
 8001442:	605a      	str	r2, [r3, #4]
  while (i < size && msg[i] != '\0') {
 8001444:	68fb      	ldr	r3, [r7, #12]
 8001446:	683a      	ldr	r2, [r7, #0]
 8001448:	429a      	cmp	r2, r3
 800144a:	d905      	bls.n	8001458 <__usart1_print+0x44>
 800144c:	68fb      	ldr	r3, [r7, #12]
 800144e:	687a      	ldr	r2, [r7, #4]
 8001450:	4413      	add	r3, r2
 8001452:	781b      	ldrb	r3, [r3, #0]
 8001454:	2b00      	cmp	r3, #0
 8001456:	d1e5      	bne.n	8001424 <__usart1_print+0x10>
  }
  while (!(USART1->SR & USART_SR_TC)) {
 8001458:	bf00      	nop
 800145a:	4b06      	ldr	r3, [pc, #24]	@ (8001474 <__usart1_print+0x60>)
 800145c:	681b      	ldr	r3, [r3, #0]
 800145e:	f003 0340 	and.w	r3, r3, #64	@ 0x40
 8001462:	2b00      	cmp	r3, #0
 8001464:	d0f9      	beq.n	800145a <__usart1_print+0x46>
  }
}
 8001466:	bf00      	nop
 8001468:	bf00      	nop
 800146a:	3714      	adds	r7, #20
 800146c:	46bd      	mov	sp, r7
 800146e:	bc80      	pop	{r7}
 8001470:	4770      	bx	lr
 8001472:	bf00      	nop
 8001474:	40011000 	.word	0x40011000

08001478 <Reset_Handler>:
 8001478:	480c      	ldr	r0, [pc, #48]	@ (80014ac <hang+0x4>)
 800147a:	490d      	ldr	r1, [pc, #52]	@ (80014b0 <hang+0x8>)
 800147c:	4a0d      	ldr	r2, [pc, #52]	@ (80014b4 <hang+0xc>)
 800147e:	e7ff      	b.n	8001480 <copy>

08001480 <copy>:
 8001480:	4288      	cmp	r0, r1
 8001482:	db04      	blt.n	800148e <copy_helper>
 8001484:	480c      	ldr	r0, [pc, #48]	@ (80014b8 <hang+0x10>)
 8001486:	490d      	ldr	r1, [pc, #52]	@ (80014bc <hang+0x14>)
 8001488:	f04f 0200 	mov.w	r2, #0
 800148c:	e004      	b.n	8001498 <init_zero>

0800148e <copy_helper>:
 800148e:	f852 3b04 	ldr.w	r3, [r2], #4
 8001492:	f840 3b04 	str.w	r3, [r0], #4
 8001496:	e7f3      	b.n	8001480 <copy>

08001498 <init_zero>:
 8001498:	4288      	cmp	r0, r1
 800149a:	db00      	blt.n	800149e <init_zero_helper>
 800149c:	e002      	b.n	80014a4 <call_entry>

0800149e <init_zero_helper>:
 800149e:	f840 2b04 	str.w	r2, [r0], #4
 80014a2:	e7f9      	b.n	8001498 <init_zero>

080014a4 <call_entry>:
 80014a4:	f7ff bd4e 	b.w	8000f44 <main>

080014a8 <hang>:
 80014a8:	e7fe      	b.n	80014a8 <hang>
 80014aa:	0000      	.short	0x0000
 80014ac:	20000000 	.word	0x20000000
 80014b0:	20000005 	.word	0x20000005
 80014b4:	08001c4f 	.word	0x08001c4f
 80014b8:	20000008 	.word	0x20000008
 80014bc:	20005084 	.word	0x20005084

080014c0 <EXTI15_10_IRQ_handler>:
 80014c0:	f7ff b8e4 	b.w	800068c <switch_pressed>

080014c4 <Default_Handler>:
 80014c4:	e7fe      	b.n	80014c4 <Default_Handler>

080014c6 <BusFault_Handler>:
 80014c6:	f3ef 8008 	mrs	r0, MSP
 80014ca:	6980      	ldr	r0, [r0, #24]
 80014cc:	f04f 0100 	mov.w	r1, #0
 80014d0:	b500      	push	{lr}
 80014d2:	f7fe fe33 	bl	800013c <fault_handler_helper>
 80014d6:	f85d eb04 	ldr.w	lr, [sp], #4
 80014da:	4770      	bx	lr

080014dc <MemManage_Handler>:
 80014dc:	f3ef 8008 	mrs	r0, MSP
 80014e0:	6980      	ldr	r0, [r0, #24]
 80014e2:	f04f 0101 	mov.w	r1, #1
 80014e6:	b500      	push	{lr}
 80014e8:	f7fe fe28 	bl	800013c <fault_handler_helper>
 80014ec:	f85d eb04 	ldr.w	lr, [sp], #4
 80014f0:	4770      	bx	lr

080014f2 <UsageFault_Handler>:
 80014f2:	f3ef 8008 	mrs	r0, MSP
 80014f6:	6980      	ldr	r0, [r0, #24]
 80014f8:	f04f 0102 	mov.w	r1, #2
 80014fc:	b500      	push	{lr}
 80014fe:	f7fe fe1d 	bl	800013c <fault_handler_helper>
 8001502:	f85d eb04 	ldr.w	lr, [sp], #4
 8001506:	4770      	bx	lr

08001508 <HardFault_Handler>:
 8001508:	f3ef 8008 	mrs	r0, MSP
 800150c:	6980      	ldr	r0, [r0, #24]
 800150e:	4904      	ldr	r1, [pc, #16]	@ (8001520 <HardFault_Handler+0x18>)
 8001510:	f381 8808 	msr	MSP, r1
 8001514:	b500      	push	{lr}
 8001516:	f7fe fe73 	bl	8000200 <HardFault_Handler_helper>
 800151a:	f85d eb04 	ldr.w	lr, [sp], #4
 800151e:	e7fe      	b.n	800151e <HardFault_Handler+0x16>
 8001520:	20017000 	.word	0x20017000

08001524 <SVC_Handler>:
 8001524:	e7fe      	b.n	8001524 <SVC_Handler>

08001526 <SysTick_Handler>:
 8001526:	e7fe      	b.n	8001526 <SysTick_Handler>

08001528 <PendSV_Handler>:
 8001528:	e7fe      	b.n	8001528 <PendSV_Handler>

0800152a <NMI_Handler>:
 800152a:	e7fe      	b.n	800152a <NMI_Handler>

0800152c <DebugMon_Handler>:
 800152c:	e7fe      	b.n	800152c <DebugMon_Handler>

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
 8000154:	f000 fb82 	bl	800085c <printf>
    if (SCB->CFSR & SCB_CFSR_BFARVALID_Msk)
 8000158:	4b1f      	ldr	r3, [pc, #124]	@ (80001d8 <fault_handler_helper+0x9c>)
 800015a:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 800015c:	f403 4300 	and.w	r3, r3, #32768	@ 0x8000
 8000160:	2b00      	cmp	r3, #0
 8000162:	d01f      	beq.n	80001a4 <fault_handler_helper+0x68>
      printf("busfault address -> %\n\r", (uint32_t)(&SCB->BFAR));
 8000164:	491d      	ldr	r1, [pc, #116]	@ (80001dc <fault_handler_helper+0xa0>)
 8000166:	481e      	ldr	r0, [pc, #120]	@ (80001e0 <fault_handler_helper+0xa4>)
 8000168:	f000 fb78 	bl	800085c <printf>
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
 8000178:	f000 fb70 	bl	800085c <printf>
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
 8000190:	f000 fb64 	bl	800085c <printf>
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
 80001a0:	f000 fb5c 	bl	800085c <printf>
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
 80001ae:	f000 fb55 	bl	800085c <printf>
         (uint32_t)(&SCB->CFSR));
  printf("PC -> %\n\r", (uint32_t)&pc);
 80001b2:	f107 030c 	add.w	r3, r7, #12
 80001b6:	4619      	mov	r1, r3
 80001b8:	480f      	ldr	r0, [pc, #60]	@ (80001f8 <fault_handler_helper+0xbc>)
 80001ba:	f000 fb4f 	bl	800085c <printf>
  printf("instruction that caused the fault-> %\n\r", (uint32_t)(&instruction));
 80001be:	f107 0314 	add.w	r3, r7, #20
 80001c2:	4619      	mov	r1, r3
 80001c4:	480d      	ldr	r0, [pc, #52]	@ (80001fc <fault_handler_helper+0xc0>)
 80001c6:	f000 fb49 	bl	800085c <printf>


  /* cannot recover */
  while (1);
 80001ca:	e7fe      	b.n	80001ca <fault_handler_helper+0x8e>
    return;
 80001cc:	bf00      	nop


}
 80001ce:	3718      	adds	r7, #24
 80001d0:	46bd      	mov	sp, r7
 80001d2:	bd80      	pop	{r7, pc}
 80001d4:	0800152c 	.word	0x0800152c
 80001d8:	e000ed00 	.word	0xe000ed00
 80001dc:	e000ed38 	.word	0xe000ed38
 80001e0:	0800153c 	.word	0x0800153c
 80001e4:	08001554 	.word	0x08001554
 80001e8:	08001574 	.word	0x08001574
 80001ec:	0800159c 	.word	0x0800159c
 80001f0:	e000ed28 	.word	0xe000ed28
 80001f4:	080015ac 	.word	0x080015ac
 80001f8:	080015dc 	.word	0x080015dc
 80001fc:	080015e8 	.word	0x080015e8

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
 8000212:	f000 fb23 	bl	800085c <printf>
  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
 8000216:	490b      	ldr	r1, [pc, #44]	@ (8000244 <HardFault_Handler_helper+0x44>)
 8000218:	480b      	ldr	r0, [pc, #44]	@ (8000248 <HardFault_Handler_helper+0x48>)
 800021a:	f000 fb1f 	bl	800085c <printf>
         (uint32_t)(&SCB->CFSR));
  printf("Hard Fault Status Register -> %\n\r", (uint32_t)(&SCB->HFSR));
 800021e:	490b      	ldr	r1, [pc, #44]	@ (800024c <HardFault_Handler_helper+0x4c>)
 8000220:	480b      	ldr	r0, [pc, #44]	@ (8000250 <HardFault_Handler_helper+0x50>)
 8000222:	f000 fb1b 	bl	800085c <printf>
  printf("PC -> %\n\r", (uint32_t)(&pc));
 8000226:	1d3b      	adds	r3, r7, #4
 8000228:	4619      	mov	r1, r3
 800022a:	480a      	ldr	r0, [pc, #40]	@ (8000254 <HardFault_Handler_helper+0x54>)
 800022c:	f000 fb16 	bl	800085c <printf>
  printf("instruction that triggered HardFault -> %\n\r",
 8000230:	f107 030c 	add.w	r3, r7, #12
 8000234:	4619      	mov	r1, r3
 8000236:	4808      	ldr	r0, [pc, #32]	@ (8000258 <HardFault_Handler_helper+0x58>)
 8000238:	f000 fb10 	bl	800085c <printf>
         (uint32_t)&instruction);

  /* cannot recover */
  while (1);
 800023c:	e7fe      	b.n	800023c <HardFault_Handler_helper+0x3c>
 800023e:	bf00      	nop
 8000240:	08001610 	.word	0x08001610
 8000244:	e000ed28 	.word	0xe000ed28
 8000248:	080015ac 	.word	0x080015ac
 800024c:	e000ed2c 	.word	0xe000ed2c
 8000250:	08001624 	.word	0x08001624
 8000254:	080015dc 	.word	0x080015dc
 8000258:	08001648 	.word	0x08001648

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
 80002bc:	f000 face 	bl	800085c <printf>

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
 800030c:	f000 faa6 	bl	800085c <printf>
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
 8000364:	08001674 	.word	0x08001674
 8000368:	e000e100 	.word	0xe000e100
 800036c:	20000008 	.word	0x20000008
 8000370:	e000ed00 	.word	0xe000ed00
 8000374:	0800168c 	.word	0x0800168c
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

08000508 <validate_vtable>:
#include "core.h"
#include <stdint.h>

bool validate_vtable(firmware_t *f) {
 8000508:	b580      	push	{r7, lr}
 800050a:	b08a      	sub	sp, #40	@ 0x28
 800050c:	af00      	add	r7, sp, #0
 800050e:	6078      	str	r0, [r7, #4]

  // vtable end is the next free address
  // check from address ------->    [vtable_start, vtable_end)
  
  // vtable must be 128byte aligned => last 7 bits must be 0 (for stm32f401re)
  if (f->__vtable_address & ((1 << 7) - 1)) {
 8000510:	687b      	ldr	r3, [r7, #4]
 8000512:	695b      	ldr	r3, [r3, #20]
 8000514:	f003 037f 	and.w	r3, r3, #127	@ 0x7f
 8000518:	2b00      	cmp	r3, #0
 800051a:	d005      	beq.n	8000528 <validate_vtable+0x20>
    printf("the vector table is not 128byte aligned !!!\n\r", 0x0);
 800051c:	2100      	movs	r1, #0
 800051e:	4839      	ldr	r0, [pc, #228]	@ (8000604 <validate_vtable+0xfc>)
 8000520:	f000 f99c 	bl	800085c <printf>
    return false;
 8000524:	2300      	movs	r3, #0
 8000526:	e068      	b.n	80005fa <validate_vtable+0xf2>

  // all the "end" addresses are next free address => there should not be any
  // data in the "end" address !! all the addresses must lie in the range
  // [start, end)

  uint32_t RAM_start = 0x20000000;
 8000528:	f04f 5300 	mov.w	r3, #536870912	@ 0x20000000
 800052c:	623b      	str	r3, [r7, #32]
  uint32_t RAM_size = 96 * 1024; // 96kB
 800052e:	f44f 33c0 	mov.w	r3, #98304	@ 0x18000
 8000532:	61fb      	str	r3, [r7, #28]
  uint32_t RAM_end = RAM_start + RAM_size;
 8000534:	6a3a      	ldr	r2, [r7, #32]
 8000536:	69fb      	ldr	r3, [r7, #28]
 8000538:	4413      	add	r3, r2
 800053a:	61bb      	str	r3, [r7, #24]
  uint32_t FLASH_start = f->__vtable_address;
 800053c:	687b      	ldr	r3, [r7, #4]
 800053e:	695b      	ldr	r3, [r3, #20]
 8000540:	617b      	str	r3, [r7, #20]
  uint32_t FLASH_size;
  if (f->__base_address == FIRMWARE_1_ADDRESS)
 8000542:	687b      	ldr	r3, [r7, #4]
 8000544:	681b      	ldr	r3, [r3, #0]
 8000546:	4a30      	ldr	r2, [pc, #192]	@ (8000608 <validate_vtable+0x100>)
 8000548:	4293      	cmp	r3, r2
 800054a:	d103      	bne.n	8000554 <validate_vtable+0x4c>
    FLASH_size = f->__firmware_size;
 800054c:	687b      	ldr	r3, [r7, #4]
 800054e:	69db      	ldr	r3, [r3, #28]
 8000550:	613b      	str	r3, [r7, #16]
 8000552:	e00e      	b.n	8000572 <validate_vtable+0x6a>
  else if (f->__base_address == FIRMWARE_2_ADDRESS)
 8000554:	687b      	ldr	r3, [r7, #4]
 8000556:	681b      	ldr	r3, [r3, #0]
 8000558:	4a2c      	ldr	r2, [pc, #176]	@ (800060c <validate_vtable+0x104>)
 800055a:	4293      	cmp	r3, r2
 800055c:	d103      	bne.n	8000566 <validate_vtable+0x5e>
    FLASH_size = f->__firmware_size;
 800055e:	687b      	ldr	r3, [r7, #4]
 8000560:	69db      	ldr	r3, [r3, #28]
 8000562:	613b      	str	r3, [r7, #16]
 8000564:	e005      	b.n	8000572 <validate_vtable+0x6a>
  else {
    printf("update _base address is not valid\n\r", 0x0);
 8000566:	2100      	movs	r1, #0
 8000568:	4829      	ldr	r0, [pc, #164]	@ (8000610 <validate_vtable+0x108>)
 800056a:	f000 f977 	bl	800085c <printf>
    return false;
 800056e:	2300      	movs	r3, #0
 8000570:	e043      	b.n	80005fa <validate_vtable+0xf2>
  }
  uint32_t FLASH_end = f->__firmware_end;
 8000572:	687b      	ldr	r3, [r7, #4]
 8000574:	699b      	ldr	r3, [r3, #24]
 8000576:	60fb      	str	r3, [r7, #12]

  /*************************msp check*********************/
  
  // MSP value can be RAM end as MSP grows downword;
  if (f->__msp_value > RAM_end || f->__msp_value < RAM_start) {
 8000578:	687b      	ldr	r3, [r7, #4]
 800057a:	6a1b      	ldr	r3, [r3, #32]
 800057c:	69ba      	ldr	r2, [r7, #24]
 800057e:	429a      	cmp	r2, r3
 8000580:	d304      	bcc.n	800058c <validate_vtable+0x84>
 8000582:	687b      	ldr	r3, [r7, #4]
 8000584:	6a1b      	ldr	r3, [r3, #32]
 8000586:	6a3a      	ldr	r2, [r7, #32]
 8000588:	429a      	cmp	r2, r3
 800058a:	d90b      	bls.n	80005a4 <validate_vtable+0x9c>

      printf ("MSP value is -> %\n\r", (uint32_t)(&(f->__msp_value)));
 800058c:	687b      	ldr	r3, [r7, #4]
 800058e:	3320      	adds	r3, #32
 8000590:	4619      	mov	r1, r3
 8000592:	4820      	ldr	r0, [pc, #128]	@ (8000614 <validate_vtable+0x10c>)
 8000594:	f000 f962 	bl	800085c <printf>
    printf("MSP value is invalid\n\r", 0x0);
 8000598:	2100      	movs	r1, #0
 800059a:	481f      	ldr	r0, [pc, #124]	@ (8000618 <validate_vtable+0x110>)
 800059c:	f000 f95e 	bl	800085c <printf>
    return false;
 80005a0:	2300      	movs	r3, #0
 80005a2:	e02a      	b.n	80005fa <validate_vtable+0xf2>
  }
  // msp value must be word aligned !!!
  if (f->__msp_value & 3) {
 80005a4:	687b      	ldr	r3, [r7, #4]
 80005a6:	6a1b      	ldr	r3, [r3, #32]
 80005a8:	f003 0303 	and.w	r3, r3, #3
 80005ac:	2b00      	cmp	r3, #0
 80005ae:	d005      	beq.n	80005bc <validate_vtable+0xb4>
    printf("MSP value is not word aligned\n\r", 0x0);
 80005b0:	2100      	movs	r1, #0
 80005b2:	481a      	ldr	r0, [pc, #104]	@ (800061c <validate_vtable+0x114>)
 80005b4:	f000 f952 	bl	800085c <printf>
    return false;
 80005b8:	2300      	movs	r3, #0
 80005ba:	e01e      	b.n	80005fa <validate_vtable+0xf2>
  }

  /************************ vtable check************************/

  for (uint32_t vtable_entry = f->__vtable_address + 0x4;
 80005bc:	687b      	ldr	r3, [r7, #4]
 80005be:	695b      	ldr	r3, [r3, #20]
 80005c0:	3304      	adds	r3, #4
 80005c2:	627b      	str	r3, [r7, #36]	@ 0x24
 80005c4:	e013      	b.n	80005ee <validate_vtable+0xe6>
       vtable_entry < f->__vtable_end; vtable_entry += 4) {

    uint32_t FLASH_address =
        *((uint32_t *)vtable_entry); // peek inside vtable_entry
 80005c6:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
    uint32_t FLASH_address =
 80005c8:	681b      	ldr	r3, [r3, #0]
 80005ca:	60bb      	str	r3, [r7, #8]
    if (FLASH_address >= FLASH_end || FLASH_address < FLASH_start) {
 80005cc:	68ba      	ldr	r2, [r7, #8]
 80005ce:	68fb      	ldr	r3, [r7, #12]
 80005d0:	429a      	cmp	r2, r3
 80005d2:	d203      	bcs.n	80005dc <validate_vtable+0xd4>
 80005d4:	68ba      	ldr	r2, [r7, #8]
 80005d6:	697b      	ldr	r3, [r7, #20]
 80005d8:	429a      	cmp	r2, r3
 80005da:	d205      	bcs.n	80005e8 <validate_vtable+0xe0>

      printf("% ---- in vtable entry does not exist in the allowed flash "
 80005dc:	6a79      	ldr	r1, [r7, #36]	@ 0x24
 80005de:	4810      	ldr	r0, [pc, #64]	@ (8000620 <validate_vtable+0x118>)
 80005e0:	f000 f93c 	bl	800085c <printf>
             "range\n\r", vtable_entry);
      return false;
 80005e4:	2300      	movs	r3, #0
 80005e6:	e008      	b.n	80005fa <validate_vtable+0xf2>
       vtable_entry < f->__vtable_end; vtable_entry += 4) {
 80005e8:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80005ea:	3304      	adds	r3, #4
 80005ec:	627b      	str	r3, [r7, #36]	@ 0x24
 80005ee:	687b      	ldr	r3, [r7, #4]
 80005f0:	68db      	ldr	r3, [r3, #12]
 80005f2:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
 80005f4:	429a      	cmp	r2, r3
 80005f6:	d3e6      	bcc.n	80005c6 <validate_vtable+0xbe>
    }
  }

  return true;
 80005f8:	2301      	movs	r3, #1
}
 80005fa:	4618      	mov	r0, r3
 80005fc:	3728      	adds	r7, #40	@ 0x28
 80005fe:	46bd      	mov	sp, r7
 8000600:	bd80      	pop	{r7, pc}
 8000602:	bf00      	nop
 8000604:	080016a4 	.word	0x080016a4
 8000608:	08010000 	.word	0x08010000
 800060c:	08020000 	.word	0x08020000
 8000610:	080016d4 	.word	0x080016d4
 8000614:	080016f8 	.word	0x080016f8
 8000618:	0800170c 	.word	0x0800170c
 800061c:	08001724 	.word	0x08001724
 8000620:	08001744 	.word	0x08001744

08000624 <validate_firmware>:

bool validate_firmware(firmware_t *f) {
 8000624:	b580      	push	{r7, lr}
 8000626:	b084      	sub	sp, #16
 8000628:	af00      	add	r7, sp, #0
 800062a:	6078      	str	r0, [r7, #4]

  if (!validate_vtable(f)) {
 800062c:	6878      	ldr	r0, [r7, #4]
 800062e:	f7ff ff6b 	bl	8000508 <validate_vtable>
 8000632:	4603      	mov	r3, r0
 8000634:	f083 0301 	eor.w	r3, r3, #1
 8000638:	b2db      	uxtb	r3, r3
 800063a:	2b00      	cmp	r3, #0
 800063c:	d005      	beq.n	800064a <validate_firmware+0x26>
    printf("vector table of the update is not valid\n\r", 0x0);
 800063e:	2100      	movs	r1, #0
 8000640:	480f      	ldr	r0, [pc, #60]	@ (8000680 <validate_firmware+0x5c>)
 8000642:	f000 f90b 	bl	800085c <printf>
    return false;
 8000646:	2300      	movs	r3, #0
 8000648:	e016      	b.n	8000678 <validate_firmware+0x54>
  }

  uint32_t crc_result = crc_calc(f);
 800064a:	6878      	ldr	r0, [r7, #4]
 800064c:	f7ff fd4a 	bl	80000e4 <crc_calc>
 8000650:	4603      	mov	r3, r0
 8000652:	60fb      	str	r3, [r7, #12]
  printf("crc value is -> %\n\r", (uint32_t)(&crc_result));
 8000654:	f107 030c 	add.w	r3, r7, #12
 8000658:	4619      	mov	r1, r3
 800065a:	480a      	ldr	r0, [pc, #40]	@ (8000684 <validate_firmware+0x60>)
 800065c:	f000 f8fe 	bl	800085c <printf>
  if (crc_result != f->__crc) {
 8000660:	687b      	ldr	r3, [r7, #4]
 8000662:	689a      	ldr	r2, [r3, #8]
 8000664:	68fb      	ldr	r3, [r7, #12]
 8000666:	429a      	cmp	r2, r3
 8000668:	d005      	beq.n	8000676 <validate_firmware+0x52>
    printf("CRC failed\n\r", 0x0);
 800066a:	2100      	movs	r1, #0
 800066c:	4806      	ldr	r0, [pc, #24]	@ (8000688 <validate_firmware+0x64>)
 800066e:	f000 f8f5 	bl	800085c <printf>
    return false;
 8000672:	2300      	movs	r3, #0
 8000674:	e000      	b.n	8000678 <validate_firmware+0x54>
  }
  return true;
 8000676:	2301      	movs	r3, #1
}
 8000678:	4618      	mov	r0, r3
 800067a:	3710      	adds	r7, #16
 800067c:	46bd      	mov	sp, r7
 800067e:	bd80      	pop	{r7, pc}
 8000680:	08001788 	.word	0x08001788
 8000684:	080017b4 	.word	0x080017b4
 8000688:	080017c8 	.word	0x080017c8

0800068c <switch_pressed>:
extern volatile Ring_buff_t ringbuffer;




void switch_pressed(void){  
 800068c:	b480      	push	{r7}
 800068e:	af00      	add	r7, sp, #0
    // clear the pending status (not done by hardware)
    EXTI-> PR = EXTI_PR_PR13_Msk;
 8000690:	4b0b      	ldr	r3, [pc, #44]	@ (80006c0 <switch_pressed+0x34>)
 8000692:	f44f 5200 	mov.w	r2, #8192	@ 0x2000
 8000696:	615a      	str	r2, [r3, #20]

    press_count++;
 8000698:	4b0a      	ldr	r3, [pc, #40]	@ (80006c4 <switch_pressed+0x38>)
 800069a:	681b      	ldr	r3, [r3, #0]
 800069c:	3301      	adds	r3, #1
 800069e:	4a09      	ldr	r2, [pc, #36]	@ (80006c4 <switch_pressed+0x38>)
 80006a0:	6013      	str	r3, [r2, #0]
    if (press_count == 3){
 80006a2:	4b08      	ldr	r3, [pc, #32]	@ (80006c4 <switch_pressed+0x38>)
 80006a4:	681b      	ldr	r3, [r3, #0]
 80006a6:	2b03      	cmp	r3, #3
 80006a8:	d105      	bne.n	80006b6 <switch_pressed+0x2a>
        delay_count = 100;
 80006aa:	4b07      	ldr	r3, [pc, #28]	@ (80006c8 <switch_pressed+0x3c>)
 80006ac:	2264      	movs	r2, #100	@ 0x64
 80006ae:	601a      	str	r2, [r3, #0]
        recieve_size = true;
 80006b0:	4b06      	ldr	r3, [pc, #24]	@ (80006cc <switch_pressed+0x40>)
 80006b2:	2201      	movs	r2, #1
 80006b4:	701a      	strb	r2, [r3, #0]
        //EXTI-> IMR &= ~EXTI_IMR_MR13_Msk;
    }
}
 80006b6:	bf00      	nop
 80006b8:	46bd      	mov	sp, r7
 80006ba:	bc80      	pop	{r7}
 80006bc:	4770      	bx	lr
 80006be:	bf00      	nop
 80006c0:	40013c00 	.word	0x40013c00
 80006c4:	20000060 	.word	0x20000060
 80006c8:	20000064 	.word	0x20000064
 80006cc:	20005080 	.word	0x20005080

080006d0 <USART1_IRQHandler>:
void USART1_IRQHandler (void){
 80006d0:	b580      	push	{r7, lr}
 80006d2:	b082      	sub	sp, #8
 80006d4:	af00      	add	r7, sp, #0
  if (!firmware_update_mode) return;
 80006d6:	4b26      	ldr	r3, [pc, #152]	@ (8000770 <USART1_IRQHandler+0xa0>)
 80006d8:	781b      	ldrb	r3, [r3, #0]
 80006da:	f083 0301 	eor.w	r3, r3, #1
 80006de:	b2db      	uxtb	r3, r3
 80006e0:	2b00      	cmp	r3, #0
 80006e2:	d141      	bne.n	8000768 <USART1_IRQHandler+0x98>
  if (USART1 -> SR & USART_SR_RXNE_Msk){
 80006e4:	4b23      	ldr	r3, [pc, #140]	@ (8000774 <USART1_IRQHandler+0xa4>)
 80006e6:	681b      	ldr	r3, [r3, #0]
 80006e8:	f003 0320 	and.w	r3, r3, #32
 80006ec:	2b00      	cmp	r3, #0
 80006ee:	d03c      	beq.n	800076a <USART1_IRQHandler+0x9a>
    if (recieve_size){
 80006f0:	4b21      	ldr	r3, [pc, #132]	@ (8000778 <USART1_IRQHandler+0xa8>)
 80006f2:	781b      	ldrb	r3, [r3, #0]
 80006f4:	b2db      	uxtb	r3, r3
 80006f6:	2b00      	cmp	r3, #0
 80006f8:	d02b      	beq.n	8000752 <USART1_IRQHandler+0x82>
      char digit = '\0';
 80006fa:	2300      	movs	r3, #0
 80006fc:	71fb      	strb	r3, [r7, #7]
      digit = USART1-> DR;
 80006fe:	4b1d      	ldr	r3, [pc, #116]	@ (8000774 <USART1_IRQHandler+0xa4>)
 8000700:	685b      	ldr	r3, [r3, #4]
 8000702:	71fb      	strb	r3, [r7, #7]
      if (digit == '\n'){
 8000704:	79fb      	ldrb	r3, [r7, #7]
 8000706:	2b0a      	cmp	r3, #10
 8000708:	d103      	bne.n	8000712 <USART1_IRQHandler+0x42>
        flag_size_recieved = true;
 800070a:	4b1c      	ldr	r3, [pc, #112]	@ (800077c <USART1_IRQHandler+0xac>)
 800070c:	2201      	movs	r2, #1
 800070e:	701a      	strb	r2, [r3, #0]
        return;
 8000710:	e02b      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      if (digit < '0' || digit > '9'){
 8000712:	79fb      	ldrb	r3, [r7, #7]
 8000714:	2b2f      	cmp	r3, #47	@ 0x2f
 8000716:	d902      	bls.n	800071e <USART1_IRQHandler+0x4e>
 8000718:	79fb      	ldrb	r3, [r7, #7]
 800071a:	2b39      	cmp	r3, #57	@ 0x39
 800071c:	d903      	bls.n	8000726 <USART1_IRQHandler+0x56>
        flag_wrong_size = true;
 800071e:	4b18      	ldr	r3, [pc, #96]	@ (8000780 <USART1_IRQHandler+0xb0>)
 8000720:	2201      	movs	r2, #1
 8000722:	701a      	strb	r2, [r3, #0]
        return;
 8000724:	e021      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      if (update_size > 128*1024){
 8000726:	4b17      	ldr	r3, [pc, #92]	@ (8000784 <USART1_IRQHandler+0xb4>)
 8000728:	681b      	ldr	r3, [r3, #0]
 800072a:	f5b3 3f00 	cmp.w	r3, #131072	@ 0x20000
 800072e:	d903      	bls.n	8000738 <USART1_IRQHandler+0x68>
        flag_too_big_update = true;
 8000730:	4b15      	ldr	r3, [pc, #84]	@ (8000788 <USART1_IRQHandler+0xb8>)
 8000732:	2201      	movs	r2, #1
 8000734:	701a      	strb	r2, [r3, #0]
        return;
 8000736:	e018      	b.n	800076a <USART1_IRQHandler+0x9a>
      }
      update_size = update_size * 10 + (digit-'0');
 8000738:	4b12      	ldr	r3, [pc, #72]	@ (8000784 <USART1_IRQHandler+0xb4>)
 800073a:	681a      	ldr	r2, [r3, #0]
 800073c:	4613      	mov	r3, r2
 800073e:	009b      	lsls	r3, r3, #2
 8000740:	4413      	add	r3, r2
 8000742:	005b      	lsls	r3, r3, #1
 8000744:	461a      	mov	r2, r3
 8000746:	79fb      	ldrb	r3, [r7, #7]
 8000748:	4413      	add	r3, r2
 800074a:	3b30      	subs	r3, #48	@ 0x30
 800074c:	4a0d      	ldr	r2, [pc, #52]	@ (8000784 <USART1_IRQHandler+0xb4>)
 800074e:	6013      	str	r3, [r2, #0]
 8000750:	e00b      	b.n	800076a <USART1_IRQHandler+0x9a>
    }
    else {
      // if (fw_ar_ind >= update_size)
      //   return;
      // fw_update [fw_ar_ind++] = USART1 -> DR;
      uint8_t data = USART1 -> DR;
 8000752:	4b08      	ldr	r3, [pc, #32]	@ (8000774 <USART1_IRQHandler+0xa4>)
 8000754:	685b      	ldr	r3, [r3, #4]
 8000756:	b2db      	uxtb	r3, r3
 8000758:	71bb      	strb	r3, [r7, #6]
      Ring_buff_write(&ringbuffer, &data, 1);
 800075a:	1dbb      	adds	r3, r7, #6
 800075c:	2201      	movs	r2, #1
 800075e:	4619      	mov	r1, r3
 8000760:	480a      	ldr	r0, [pc, #40]	@ (800078c <USART1_IRQHandler+0xbc>)
 8000762:	f7ff fe5f 	bl	8000424 <Ring_buff_write>
 8000766:	e000      	b.n	800076a <USART1_IRQHandler+0x9a>
  if (!firmware_update_mode) return;
 8000768:	bf00      	nop
    }
  }
}
 800076a:	3708      	adds	r7, #8
 800076c:	46bd      	mov	sp, r7
 800076e:	bd80      	pop	{r7, pc}
 8000770:	2000507e 	.word	0x2000507e
 8000774:	40011000 	.word	0x40011000
 8000778:	20005080 	.word	0x20005080
 800077c:	20005081 	.word	0x20005081
 8000780:	20005082 	.word	0x20005082
 8000784:	20000074 	.word	0x20000074
 8000788:	20005083 	.word	0x20005083
 800078c:	20000078 	.word	0x20000078

08000790 <strlen>:
uint32_t update_section_end_address = UPDATE_ADDR;
extern volatile Ring_buff_t ringbuffer;
extern uint8_t write_buffer[WRITE_BUFF_SIZE];
volatile uint32_t fw_ar_ind = 0;

uint32_t strlen(const char *msg) {
 8000790:	b480      	push	{r7}
 8000792:	b085      	sub	sp, #20
 8000794:	af00      	add	r7, sp, #0
 8000796:	6078      	str	r0, [r7, #4]

  int i = 0;
 8000798:	2300      	movs	r3, #0
 800079a:	60fb      	str	r3, [r7, #12]
  while (msg[i++] != '\0')
 800079c:	bf00      	nop
 800079e:	68fb      	ldr	r3, [r7, #12]
 80007a0:	1c5a      	adds	r2, r3, #1
 80007a2:	60fa      	str	r2, [r7, #12]
 80007a4:	461a      	mov	r2, r3
 80007a6:	687b      	ldr	r3, [r7, #4]
 80007a8:	4413      	add	r3, r2
 80007aa:	781b      	ldrb	r3, [r3, #0]
 80007ac:	2b00      	cmp	r3, #0
 80007ae:	d1f6      	bne.n	800079e <strlen+0xe>
    ;
  return i - 1;
 80007b0:	68fb      	ldr	r3, [r7, #12]
 80007b2:	3b01      	subs	r3, #1
}
 80007b4:	4618      	mov	r0, r3
 80007b6:	3714      	adds	r7, #20
 80007b8:	46bd      	mov	sp, r7
 80007ba:	bc80      	pop	{r7}
 80007bc:	4770      	bx	lr

080007be <delay>:

void delay(uint32_t count) {
 80007be:	b480      	push	{r7}
 80007c0:	b083      	sub	sp, #12
 80007c2:	af00      	add	r7, sp, #0
 80007c4:	6078      	str	r0, [r7, #4]

  while (count--)
 80007c6:	bf00      	nop
 80007c8:	687b      	ldr	r3, [r7, #4]
 80007ca:	1e5a      	subs	r2, r3, #1
 80007cc:	607a      	str	r2, [r7, #4]
 80007ce:	2b00      	cmp	r3, #0
 80007d0:	d1fa      	bne.n	80007c8 <delay+0xa>
    ;
}
 80007d2:	bf00      	nop
 80007d4:	bf00      	nop
 80007d6:	370c      	adds	r7, #12
 80007d8:	46bd      	mov	sp, r7
 80007da:	bc80      	pop	{r7}
 80007dc:	4770      	bx	lr

080007de <hex_str>:
char *hex_str(uint32_t value, char *out) {
 80007de:	b4b0      	push	{r4, r5, r7}
 80007e0:	b08b      	sub	sp, #44	@ 0x2c
 80007e2:	af00      	add	r7, sp, #0
 80007e4:	6078      	str	r0, [r7, #4]
 80007e6:	6039      	str	r1, [r7, #0]

  char hex_char[] = "0123456789abcdef";
 80007e8:	4b1b      	ldr	r3, [pc, #108]	@ (8000858 <hex_str+0x7a>)
 80007ea:	f107 0408 	add.w	r4, r7, #8
 80007ee:	461d      	mov	r5, r3
 80007f0:	cd0f      	ldmia	r5!, {r0, r1, r2, r3}
 80007f2:	c40f      	stmia	r4!, {r0, r1, r2, r3}
 80007f4:	682b      	ldr	r3, [r5, #0]
 80007f6:	7023      	strb	r3, [r4, #0]
  out[0] = '0';
 80007f8:	683b      	ldr	r3, [r7, #0]
 80007fa:	2230      	movs	r2, #48	@ 0x30
 80007fc:	701a      	strb	r2, [r3, #0]
  out[1] = 'x';
 80007fe:	683b      	ldr	r3, [r7, #0]
 8000800:	3301      	adds	r3, #1
 8000802:	2278      	movs	r2, #120	@ 0x78
 8000804:	701a      	strb	r2, [r3, #0]

  for (int i = 0; i < 8; i++) {
 8000806:	2300      	movs	r3, #0
 8000808:	627b      	str	r3, [r7, #36]	@ 0x24
 800080a:	e01c      	b.n	8000846 <hex_str+0x68>
    uint32_t ind = (value & (15 << (i * 4))) >> (i * 4);
 800080c:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800080e:	009b      	lsls	r3, r3, #2
 8000810:	220f      	movs	r2, #15
 8000812:	fa02 f303 	lsl.w	r3, r2, r3
 8000816:	461a      	mov	r2, r3
 8000818:	687b      	ldr	r3, [r7, #4]
 800081a:	401a      	ands	r2, r3
 800081c:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800081e:	009b      	lsls	r3, r3, #2
 8000820:	fa22 f303 	lsr.w	r3, r2, r3
 8000824:	623b      	str	r3, [r7, #32]
    int j = 9 - i;
 8000826:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000828:	f1c3 0309 	rsb	r3, r3, #9
 800082c:	61fb      	str	r3, [r7, #28]
    out[j] = hex_char[ind];
 800082e:	69fb      	ldr	r3, [r7, #28]
 8000830:	683a      	ldr	r2, [r7, #0]
 8000832:	4413      	add	r3, r2
 8000834:	f107 0108 	add.w	r1, r7, #8
 8000838:	6a3a      	ldr	r2, [r7, #32]
 800083a:	440a      	add	r2, r1
 800083c:	7812      	ldrb	r2, [r2, #0]
 800083e:	701a      	strb	r2, [r3, #0]
  for (int i = 0; i < 8; i++) {
 8000840:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000842:	3301      	adds	r3, #1
 8000844:	627b      	str	r3, [r7, #36]	@ 0x24
 8000846:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000848:	2b07      	cmp	r3, #7
 800084a:	dddf      	ble.n	800080c <hex_str+0x2e>
  }
}
 800084c:	bf00      	nop
 800084e:	4618      	mov	r0, r3
 8000850:	372c      	adds	r7, #44	@ 0x2c
 8000852:	46bd      	mov	sp, r7
 8000854:	bcb0      	pop	{r4, r5, r7}
 8000856:	4770      	bx	lr
 8000858:	080017d8 	.word	0x080017d8

0800085c <printf>:

void printf(const char *msg, uint32_t address) {
 800085c:	b580      	push	{r7, lr}
 800085e:	b0a4      	sub	sp, #144	@ 0x90
 8000860:	af00      	add	r7, sp, #0
 8000862:	6078      	str	r0, [r7, #4]
 8000864:	6039      	str	r1, [r7, #0]

  uint32_t value = *((uint32_t *)address);
 8000866:	683b      	ldr	r3, [r7, #0]
 8000868:	681b      	ldr	r3, [r3, #0]
 800086a:	67fb      	str	r3, [r7, #124]	@ 0x7c

  if (strlen(msg) + 9 > MAX_STR_SIZE) {
 800086c:	6878      	ldr	r0, [r7, #4]
 800086e:	f7ff ff8f 	bl	8000790 <strlen>
 8000872:	4603      	mov	r3, r0
 8000874:	3309      	adds	r3, #9
 8000876:	2b64      	cmp	r3, #100	@ 0x64
 8000878:	d904      	bls.n	8000884 <printf+0x28>
    __usart1_print("too large error message !!\n\r", MAX_STR_SIZE);
 800087a:	2164      	movs	r1, #100	@ 0x64
 800087c:	483e      	ldr	r0, [pc, #248]	@ (8000978 <printf+0x11c>)
 800087e:	f000 fdc7 	bl	8001410 <__usart1_print>
 8000882:	e076      	b.n	8000972 <printf+0x116>
    return;
  }
  char hex[10];
  char __msg[MAX_STR_SIZE];

  uint32_t i = 0;
 8000884:	2300      	movs	r3, #0
 8000886:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
  int p = 0, q = 0;
 800088a:	2300      	movs	r3, #0
 800088c:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
 8000890:	2300      	movs	r3, #0
 8000892:	f8c7 3084 	str.w	r3, [r7, #132]	@ 0x84
  bool single_sub = false;
 8000896:	2300      	movs	r3, #0
 8000898:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83

  uint32_t msg_size = strlen(msg);
 800089c:	6878      	ldr	r0, [r7, #4]
 800089e:	f7ff ff77 	bl	8000790 <strlen>
 80008a2:	67b8      	str	r0, [r7, #120]	@ 0x78
  for (; i < msg_size; i++) {
 80008a4:	e04d      	b.n	8000942 <printf+0xe6>

    if (msg[i] == '%' && !single_sub) {
 80008a6:	687a      	ldr	r2, [r7, #4]
 80008a8:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 80008ac:	4413      	add	r3, r2
 80008ae:	781b      	ldrb	r3, [r3, #0]
 80008b0:	2b25      	cmp	r3, #37	@ 0x25
 80008b2:	d12f      	bne.n	8000914 <printf+0xb8>
 80008b4:	f897 3083 	ldrb.w	r3, [r7, #131]	@ 0x83
 80008b8:	f083 0301 	eor.w	r3, r3, #1
 80008bc:	b2db      	uxtb	r3, r3
 80008be:	2b00      	cmp	r3, #0
 80008c0:	d028      	beq.n	8000914 <printf+0xb8>
      hex_str(value, hex);
 80008c2:	f107 036c 	add.w	r3, r7, #108	@ 0x6c
 80008c6:	4619      	mov	r1, r3
 80008c8:	6ff8      	ldr	r0, [r7, #124]	@ 0x7c
 80008ca:	f7ff ff88 	bl	80007de <hex_str>

      while (q - p < 10) {
 80008ce:	e011      	b.n	80008f4 <printf+0x98>
        __msg[q++] = hex[q - p];
 80008d0:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 80008d4:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 80008d8:	1ad2      	subs	r2, r2, r3
 80008da:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 80008de:	1c59      	adds	r1, r3, #1
 80008e0:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 80008e4:	3290      	adds	r2, #144	@ 0x90
 80008e6:	443a      	add	r2, r7
 80008e8:	f812 2c24 	ldrb.w	r2, [r2, #-36]
 80008ec:	3390      	adds	r3, #144	@ 0x90
 80008ee:	443b      	add	r3, r7
 80008f0:	f803 2c88 	strb.w	r2, [r3, #-136]
      while (q - p < 10) {
 80008f4:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 80008f8:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 80008fc:	1ad3      	subs	r3, r2, r3
 80008fe:	2b09      	cmp	r3, #9
 8000900:	dde6      	ble.n	80008d0 <printf+0x74>
      }
      p++;
 8000902:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000906:	3301      	adds	r3, #1
 8000908:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
      single_sub = true;
 800090c:	2301      	movs	r3, #1
 800090e:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83
 8000912:	e011      	b.n	8000938 <printf+0xdc>
    } else
      __msg[q++] = msg[p++];
 8000914:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000918:	1c5a      	adds	r2, r3, #1
 800091a:	f8c7 2088 	str.w	r2, [r7, #136]	@ 0x88
 800091e:	461a      	mov	r2, r3
 8000920:	687b      	ldr	r3, [r7, #4]
 8000922:	441a      	add	r2, r3
 8000924:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000928:	1c59      	adds	r1, r3, #1
 800092a:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 800092e:	7812      	ldrb	r2, [r2, #0]
 8000930:	3390      	adds	r3, #144	@ 0x90
 8000932:	443b      	add	r3, r7
 8000934:	f803 2c88 	strb.w	r2, [r3, #-136]
  for (; i < msg_size; i++) {
 8000938:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 800093c:	3301      	adds	r3, #1
 800093e:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
 8000942:	f8d7 208c 	ldr.w	r2, [r7, #140]	@ 0x8c
 8000946:	6fbb      	ldr	r3, [r7, #120]	@ 0x78
 8000948:	429a      	cmp	r2, r3
 800094a:	d3ac      	bcc.n	80008a6 <printf+0x4a>
  }
  __msg[q] = '\0';
 800094c:	f107 0208 	add.w	r2, r7, #8
 8000950:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000954:	4413      	add	r3, r2
 8000956:	2200      	movs	r2, #0
 8000958:	701a      	strb	r2, [r3, #0]
  __usart1_print(__msg, strlen(__msg));
 800095a:	f107 0308 	add.w	r3, r7, #8
 800095e:	4618      	mov	r0, r3
 8000960:	f7ff ff16 	bl	8000790 <strlen>
 8000964:	4602      	mov	r2, r0
 8000966:	f107 0308 	add.w	r3, r7, #8
 800096a:	4611      	mov	r1, r2
 800096c:	4618      	mov	r0, r3
 800096e:	f000 fd4f 	bl	8001410 <__usart1_print>
}
 8000972:	3790      	adds	r7, #144	@ 0x90
 8000974:	46bd      	mov	sp, r7
 8000976:	bd80      	pop	{r7, pc}
 8000978:	080017ec 	.word	0x080017ec

0800097c <recieve_update>:
//   }
//   printf("data recieved !!! yehhhh \n\n\r", 0x0);
//   return 0;
// }

uint32_t recieve_update(void) {
 800097c:	b580      	push	{r7, lr}
 800097e:	b082      	sub	sp, #8
 8000980:	af00      	add	r7, sp, #0

  // recieve update size

  printf("enter the size of the update....\n\r", 0x0);
 8000982:	2100      	movs	r1, #0
 8000984:	483e      	ldr	r0, [pc, #248]	@ (8000a80 <recieve_update+0x104>)
 8000986:	f7ff ff69 	bl	800085c <printf>

  recieve_size = true;
 800098a:	4b3e      	ldr	r3, [pc, #248]	@ (8000a84 <recieve_update+0x108>)
 800098c:	2201      	movs	r2, #1
 800098e:	701a      	strb	r2, [r3, #0]
  while (1) {
    if (flag_wrong_size) {
 8000990:	4b3d      	ldr	r3, [pc, #244]	@ (8000a88 <recieve_update+0x10c>)
 8000992:	781b      	ldrb	r3, [r3, #0]
 8000994:	b2db      	uxtb	r3, r3
 8000996:	2b00      	cmp	r3, #0
 8000998:	d006      	beq.n	80009a8 <recieve_update+0x2c>
      printf("wrong size entered !!!\n\r", 0x0);
 800099a:	2100      	movs	r1, #0
 800099c:	483b      	ldr	r0, [pc, #236]	@ (8000a8c <recieve_update+0x110>)
 800099e:	f7ff ff5d 	bl	800085c <printf>
      return -1;
 80009a2:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80009a6:	e066      	b.n	8000a76 <recieve_update+0xfa>
    }
    if (flag_too_big_update) {
 80009a8:	4b39      	ldr	r3, [pc, #228]	@ (8000a90 <recieve_update+0x114>)
 80009aa:	781b      	ldrb	r3, [r3, #0]
 80009ac:	b2db      	uxtb	r3, r3
 80009ae:	2b00      	cmp	r3, #0
 80009b0:	d006      	beq.n	80009c0 <recieve_update+0x44>
      printf("update size cannot exceed 128KB \n\r", 0x0);
 80009b2:	2100      	movs	r1, #0
 80009b4:	4837      	ldr	r0, [pc, #220]	@ (8000a94 <recieve_update+0x118>)
 80009b6:	f7ff ff51 	bl	800085c <printf>
      return -1;
 80009ba:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80009be:	e05a      	b.n	8000a76 <recieve_update+0xfa>
    }
    if (flag_size_recieved) {
 80009c0:	4b35      	ldr	r3, [pc, #212]	@ (8000a98 <recieve_update+0x11c>)
 80009c2:	781b      	ldrb	r3, [r3, #0]
 80009c4:	b2db      	uxtb	r3, r3
 80009c6:	2b00      	cmp	r3, #0
 80009c8:	d0e2      	beq.n	8000990 <recieve_update+0x14>
      printf("update size recieved \n\r", 0x0);
 80009ca:	2100      	movs	r1, #0
 80009cc:	4833      	ldr	r0, [pc, #204]	@ (8000a9c <recieve_update+0x120>)
 80009ce:	f7ff ff45 	bl	800085c <printf>
      break;
 80009d2:	bf00      	nop
    }
  }
  recieve_size = false;
 80009d4:	4b2b      	ldr	r3, [pc, #172]	@ (8000a84 <recieve_update+0x108>)
 80009d6:	2200      	movs	r2, #0
 80009d8:	701a      	strb	r2, [r3, #0]

  // recieve firmware update !!
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 80009da:	e041      	b.n	8000a60 <recieve_update+0xe4>
    while (Ring_buff_empty(&ringbuffer))
 80009dc:	bf00      	nop
 80009de:	4830      	ldr	r0, [pc, #192]	@ (8000aa0 <recieve_update+0x124>)
 80009e0:	f7ff fce1 	bl	80003a6 <Ring_buff_empty>
 80009e4:	4603      	mov	r3, r0
 80009e6:	2b00      	cmp	r3, #0
 80009e8:	d1f9      	bne.n	80009de <recieve_update+0x62>
      ;
    //
    // problem
    uint16_t read_size = Ring_buff_read(&ringbuffer, write_buffer + wb_size,
 80009ea:	4b2e      	ldr	r3, [pc, #184]	@ (8000aa4 <recieve_update+0x128>)
 80009ec:	881b      	ldrh	r3, [r3, #0]
 80009ee:	461a      	mov	r2, r3
 80009f0:	4b2d      	ldr	r3, [pc, #180]	@ (8000aa8 <recieve_update+0x12c>)
 80009f2:	18d1      	adds	r1, r2, r3
 80009f4:	4b2b      	ldr	r3, [pc, #172]	@ (8000aa4 <recieve_update+0x128>)
 80009f6:	881b      	ldrh	r3, [r3, #0]
 80009f8:	f5c3 5320 	rsb	r3, r3, #10240	@ 0x2800
 80009fc:	b29b      	uxth	r3, r3
 80009fe:	461a      	mov	r2, r3
 8000a00:	4827      	ldr	r0, [pc, #156]	@ (8000aa0 <recieve_update+0x124>)
 8000a02:	f7ff fd42 	bl	800048a <Ring_buff_read>
 8000a06:	4603      	mov	r3, r0
 8000a08:	80fb      	strh	r3, [r7, #6]
                                        WRITE_BUFF_SIZE - wb_size);
    wb_size += read_size;
 8000a0a:	4b26      	ldr	r3, [pc, #152]	@ (8000aa4 <recieve_update+0x128>)
 8000a0c:	881a      	ldrh	r2, [r3, #0]
 8000a0e:	88fb      	ldrh	r3, [r7, #6]
 8000a10:	4413      	add	r3, r2
 8000a12:	b29a      	uxth	r2, r3
 8000a14:	4b23      	ldr	r3, [pc, #140]	@ (8000aa4 <recieve_update+0x128>)
 8000a16:	801a      	strh	r2, [r3, #0]

    uint16_t update_in_flash_size = update_section_end_address - UPDATE_ADDR;
 8000a18:	4b24      	ldr	r3, [pc, #144]	@ (8000aac <recieve_update+0x130>)
 8000a1a:	681b      	ldr	r3, [r3, #0]
 8000a1c:	80bb      	strh	r3, [r7, #4]
    //
    if (wb_size == WRITE_BUFF_SIZE ||
 8000a1e:	4b21      	ldr	r3, [pc, #132]	@ (8000aa4 <recieve_update+0x128>)
 8000a20:	881b      	ldrh	r3, [r3, #0]
 8000a22:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 8000a26:	d007      	beq.n	8000a38 <recieve_update+0xbc>
        update_size - update_in_flash_size == wb_size) {
 8000a28:	4b21      	ldr	r3, [pc, #132]	@ (8000ab0 <recieve_update+0x134>)
 8000a2a:	681a      	ldr	r2, [r3, #0]
 8000a2c:	88bb      	ldrh	r3, [r7, #4]
 8000a2e:	1ad3      	subs	r3, r2, r3
 8000a30:	4a1c      	ldr	r2, [pc, #112]	@ (8000aa4 <recieve_update+0x128>)
 8000a32:	8812      	ldrh	r2, [r2, #0]
    if (wb_size == WRITE_BUFF_SIZE ||
 8000a34:	4293      	cmp	r3, r2
 8000a36:	d113      	bne.n	8000a60 <recieve_update+0xe4>
      // flash write, update end address, wb flush

      flash_write(update_section_end_address, write_buffer, wb_size, 0);
 8000a38:	4b1c      	ldr	r3, [pc, #112]	@ (8000aac <recieve_update+0x130>)
 8000a3a:	6818      	ldr	r0, [r3, #0]
 8000a3c:	4b19      	ldr	r3, [pc, #100]	@ (8000aa4 <recieve_update+0x128>)
 8000a3e:	881b      	ldrh	r3, [r3, #0]
 8000a40:	461a      	mov	r2, r3
 8000a42:	2300      	movs	r3, #0
 8000a44:	4918      	ldr	r1, [pc, #96]	@ (8000aa8 <recieve_update+0x12c>)
 8000a46:	f000 fbfd 	bl	8001244 <flash_write>

      update_section_end_address += wb_size;
 8000a4a:	4b16      	ldr	r3, [pc, #88]	@ (8000aa4 <recieve_update+0x128>)
 8000a4c:	881b      	ldrh	r3, [r3, #0]
 8000a4e:	461a      	mov	r2, r3
 8000a50:	4b16      	ldr	r3, [pc, #88]	@ (8000aac <recieve_update+0x130>)
 8000a52:	681b      	ldr	r3, [r3, #0]
 8000a54:	4413      	add	r3, r2
 8000a56:	4a15      	ldr	r2, [pc, #84]	@ (8000aac <recieve_update+0x130>)
 8000a58:	6013      	str	r3, [r2, #0]
      wb_size = 0;
 8000a5a:	4b12      	ldr	r3, [pc, #72]	@ (8000aa4 <recieve_update+0x128>)
 8000a5c:	2200      	movs	r2, #0
 8000a5e:	801a      	strh	r2, [r3, #0]
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 8000a60:	4b12      	ldr	r3, [pc, #72]	@ (8000aac <recieve_update+0x130>)
 8000a62:	681b      	ldr	r3, [r3, #0]
 8000a64:	f103 4377 	add.w	r3, r3, #4143972352	@ 0xf7000000
 8000a68:	f503 037c 	add.w	r3, r3, #16515072	@ 0xfc0000
 8000a6c:	4a10      	ldr	r2, [pc, #64]	@ (8000ab0 <recieve_update+0x134>)
 8000a6e:	6812      	ldr	r2, [r2, #0]
 8000a70:	4293      	cmp	r3, r2
 8000a72:	d3b3      	bcc.n	80009dc <recieve_update+0x60>
    }
  }

  // while (fw_ar_ind < update_size);

  return 0;
 8000a74:	2300      	movs	r3, #0
}
 8000a76:	4618      	mov	r0, r3
 8000a78:	3708      	adds	r7, #8
 8000a7a:	46bd      	mov	sp, r7
 8000a7c:	bd80      	pop	{r7, pc}
 8000a7e:	bf00      	nop
 8000a80:	0800180c 	.word	0x0800180c
 8000a84:	20005080 	.word	0x20005080
 8000a88:	20005082 	.word	0x20005082
 8000a8c:	08001830 	.word	0x08001830
 8000a90:	20005083 	.word	0x20005083
 8000a94:	0800184c 	.word	0x0800184c
 8000a98:	20005081 	.word	0x20005081
 8000a9c:	08001870 	.word	0x08001870
 8000aa0:	20000078 	.word	0x20000078
 8000aa4:	2000507c 	.word	0x2000507c
 8000aa8:	2000287c 	.word	0x2000287c
 8000aac:	20000000 	.word	0x20000000
 8000ab0:	20000074 	.word	0x20000074

08000ab4 <rollback>:

void rollback(void) {
 8000ab4:	b580      	push	{r7, lr}
 8000ab6:	b08e      	sub	sp, #56	@ 0x38
 8000ab8:	af00      	add	r7, sp, #0

  firmware_t old_f;
  // old firmware is present in the COPY_ADDR section
  init_firmware_t(COPY_ADDR, &old_f);
 8000aba:	f107 0308 	add.w	r3, r7, #8
 8000abe:	4619      	mov	r1, r3
 8000ac0:	4819      	ldr	r0, [pc, #100]	@ (8000b28 <rollback+0x74>)
 8000ac2:	f000 f85d 	bl	8000b80 <init_firmware_t>

  printf("startign rollback\n\n\r", 0x0);
 8000ac6:	2100      	movs	r1, #0
 8000ac8:	4818      	ldr	r0, [pc, #96]	@ (8000b2c <rollback+0x78>)
 8000aca:	f7ff fec7 	bl	800085c <printf>
  erase_flash(old_f.__base_address);
 8000ace:	68bb      	ldr	r3, [r7, #8]
 8000ad0:	4618      	mov	r0, r3
 8000ad2:	f000 fafd 	bl	80010d0 <erase_flash>
  printf("corupted firmware is erased\n\r", 0x0);
 8000ad6:	2100      	movs	r1, #0
 8000ad8:	4815      	ldr	r0, [pc, #84]	@ (8000b30 <rollback+0x7c>)
 8000ada:	f7ff febf 	bl	800085c <printf>

  uint32_t copy_size =
      (*(uint32_t *)(COPY_ADDR + 0x14)) - (*(uint32_t *)(COPY_ADDR + 0x0c));
 8000ade:	4b15      	ldr	r3, [pc, #84]	@ (8000b34 <rollback+0x80>)
 8000ae0:	681a      	ldr	r2, [r3, #0]
 8000ae2:	4b15      	ldr	r3, [pc, #84]	@ (8000b38 <rollback+0x84>)
 8000ae4:	681b      	ldr	r3, [r3, #0]
  uint32_t copy_size =
 8000ae6:	1ad3      	subs	r3, r2, r3
 8000ae8:	637b      	str	r3, [r7, #52]	@ 0x34
  flash_write(old_f.__base_address + 0x04, (const char *)(COPY_ADDR + 0x04),
 8000aea:	68bb      	ldr	r3, [r7, #8]
 8000aec:	1d18      	adds	r0, r3, #4
 8000aee:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000af0:	1f1a      	subs	r2, r3, #4
 8000af2:	2300      	movs	r3, #0
 8000af4:	4911      	ldr	r1, [pc, #68]	@ (8000b3c <rollback+0x88>)
 8000af6:	f000 fba5 	bl	8001244 <flash_write>
              copy_size - 0x04, NO_DELAY);

  // word write => size would be 4 (not 2)
  const uint32_t end = 0xfffffffe;
 8000afa:	f06f 0301 	mvn.w	r3, #1
 8000afe:	607b      	str	r3, [r7, #4]
  // &end is of type -> uint32_t * ==> need type conversion
  flash_write(old_f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000b00:	68b8      	ldr	r0, [r7, #8]
 8000b02:	1d39      	adds	r1, r7, #4
 8000b04:	2300      	movs	r3, #0
 8000b06:	2204      	movs	r2, #4
 8000b08:	f000 fb9c 	bl	8001244 <flash_write>
  printf("new flag = %\n\r", old_f.__base_address);
 8000b0c:	68bb      	ldr	r3, [r7, #8]
 8000b0e:	4619      	mov	r1, r3
 8000b10:	480b      	ldr	r0, [pc, #44]	@ (8000b40 <rollback+0x8c>)
 8000b12:	f7ff fea3 	bl	800085c <printf>

  printf("done recovering old firmware \n\r", 0x0);
 8000b16:	2100      	movs	r1, #0
 8000b18:	480a      	ldr	r0, [pc, #40]	@ (8000b44 <rollback+0x90>)
 8000b1a:	f7ff fe9f 	bl	800085c <printf>
}
 8000b1e:	bf00      	nop
 8000b20:	3738      	adds	r7, #56	@ 0x38
 8000b22:	46bd      	mov	sp, r7
 8000b24:	bd80      	pop	{r7, pc}
 8000b26:	bf00      	nop
 8000b28:	08060000 	.word	0x08060000
 8000b2c:	08001888 	.word	0x08001888
 8000b30:	080018a0 	.word	0x080018a0
 8000b34:	08060014 	.word	0x08060014
 8000b38:	0806000c 	.word	0x0806000c
 8000b3c:	08060004 	.word	0x08060004
 8000b40:	080018c0 	.word	0x080018c0
 8000b44:	080018d0 	.word	0x080018d0

08000b48 <__NVIC_EnableIRQ>:
{
 8000b48:	b480      	push	{r7}
 8000b4a:	b083      	sub	sp, #12
 8000b4c:	af00      	add	r7, sp, #0
 8000b4e:	4603      	mov	r3, r0
 8000b50:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 8000b52:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000b56:	2b00      	cmp	r3, #0
 8000b58:	db0b      	blt.n	8000b72 <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 8000b5a:	79fb      	ldrb	r3, [r7, #7]
 8000b5c:	f003 021f 	and.w	r2, r3, #31
 8000b60:	4906      	ldr	r1, [pc, #24]	@ (8000b7c <__NVIC_EnableIRQ+0x34>)
 8000b62:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000b66:	095b      	lsrs	r3, r3, #5
 8000b68:	2001      	movs	r0, #1
 8000b6a:	fa00 f202 	lsl.w	r2, r0, r2
 8000b6e:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 8000b72:	bf00      	nop
 8000b74:	370c      	adds	r7, #12
 8000b76:	46bd      	mov	sp, r7
 8000b78:	bc80      	pop	{r7}
 8000b7a:	4770      	bx	lr
 8000b7c:	e000e100 	.word	0xe000e100

08000b80 <init_firmware_t>:
volatile bool flag_size_recieved = false;
volatile bool flag_wrong_size = false;
volatile bool flag_too_big_update = false;


void init_firmware_t(uint32_t address, firmware_t *f) {
 8000b80:	b480      	push	{r7}
 8000b82:	b083      	sub	sp, #12
 8000b84:	af00      	add	r7, sp, #0
 8000b86:	6078      	str	r0, [r7, #4]
 8000b88:	6039      	str	r1, [r7, #0]
  f->__flag = *(volatile uint32_t *)(address + 0x00);
 8000b8a:	687b      	ldr	r3, [r7, #4]
 8000b8c:	681a      	ldr	r2, [r3, #0]
 8000b8e:	683b      	ldr	r3, [r7, #0]
 8000b90:	605a      	str	r2, [r3, #4]
  f->__crc = *((volatile uint32_t *)(address + 0x04));
 8000b92:	687b      	ldr	r3, [r7, #4]
 8000b94:	3304      	adds	r3, #4
 8000b96:	681a      	ldr	r2, [r3, #0]
 8000b98:	683b      	ldr	r3, [r7, #0]
 8000b9a:	609a      	str	r2, [r3, #8]
  f->__vtable_end = *((volatile uint32_t *)(address + 0x08));
 8000b9c:	687b      	ldr	r3, [r7, #4]
 8000b9e:	3308      	adds	r3, #8
 8000ba0:	681a      	ldr	r2, [r3, #0]
 8000ba2:	683b      	ldr	r3, [r7, #0]
 8000ba4:	60da      	str	r2, [r3, #12]
  f->__base_address = *((volatile uint32_t *)(address + 0x0c));
 8000ba6:	687b      	ldr	r3, [r7, #4]
 8000ba8:	330c      	adds	r3, #12
 8000baa:	681a      	ldr	r2, [r3, #0]
 8000bac:	683b      	ldr	r3, [r7, #0]
 8000bae:	601a      	str	r2, [r3, #0]
  f->__vtable_address = *((volatile uint32_t *)(address + 0x10));
 8000bb0:	687b      	ldr	r3, [r7, #4]
 8000bb2:	3310      	adds	r3, #16
 8000bb4:	681a      	ldr	r2, [r3, #0]
 8000bb6:	683b      	ldr	r3, [r7, #0]
 8000bb8:	615a      	str	r2, [r3, #20]
  f->__firmware_end = *((volatile uint32_t *)(address + 0x14));
 8000bba:	687b      	ldr	r3, [r7, #4]
 8000bbc:	3314      	adds	r3, #20
 8000bbe:	681a      	ldr	r2, [r3, #0]
 8000bc0:	683b      	ldr	r3, [r7, #0]
 8000bc2:	619a      	str	r2, [r3, #24]
  f->__firmware_size = f->__firmware_end - f->__base_address;
 8000bc4:	683b      	ldr	r3, [r7, #0]
 8000bc6:	699a      	ldr	r2, [r3, #24]
 8000bc8:	683b      	ldr	r3, [r7, #0]
 8000bca:	681b      	ldr	r3, [r3, #0]
 8000bcc:	1ad2      	subs	r2, r2, r3
 8000bce:	683b      	ldr	r3, [r7, #0]
 8000bd0:	61da      	str	r2, [r3, #28]
  f->__crc_start_addr = address + 0x08;
 8000bd2:	687b      	ldr	r3, [r7, #4]
 8000bd4:	f103 0208 	add.w	r2, r3, #8
 8000bd8:	683b      	ldr	r3, [r7, #0]
 8000bda:	611a      	str	r2, [r3, #16]
  f->__crc_end_addr = f->__crc_start_addr - 0x08 + f->__firmware_size;
 8000bdc:	683b      	ldr	r3, [r7, #0]
 8000bde:	691a      	ldr	r2, [r3, #16]
 8000be0:	683b      	ldr	r3, [r7, #0]
 8000be2:	69db      	ldr	r3, [r3, #28]
 8000be4:	4413      	add	r3, r2
 8000be6:	f1a3 0208 	sub.w	r2, r3, #8
 8000bea:	683b      	ldr	r3, [r7, #0]
 8000bec:	629a      	str	r2, [r3, #40]	@ 0x28
  f->__msp_value = *((volatile uint32_t *)(f->__vtable_address));
 8000bee:	683b      	ldr	r3, [r7, #0]
 8000bf0:	695b      	ldr	r3, [r3, #20]
 8000bf2:	681a      	ldr	r2, [r3, #0]
 8000bf4:	683b      	ldr	r3, [r7, #0]
 8000bf6:	621a      	str	r2, [r3, #32]
  f->__reset_handler = *((volatile uint32_t *)(f->__vtable_address + 0x4));
 8000bf8:	683b      	ldr	r3, [r7, #0]
 8000bfa:	695b      	ldr	r3, [r3, #20]
 8000bfc:	3304      	adds	r3, #4
 8000bfe:	681a      	ldr	r2, [r3, #0]
 8000c00:	683b      	ldr	r3, [r7, #0]
 8000c02:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000c04:	bf00      	nop
 8000c06:	370c      	adds	r7, #12
 8000c08:	46bd      	mov	sp, r7
 8000c0a:	bc80      	pop	{r7}
 8000c0c:	4770      	bx	lr

08000c0e <copy_firmware_t>:

void copy_firmware_t(firmware_t *f_dest, firmware_t *f_src) {
 8000c0e:	b480      	push	{r7}
 8000c10:	b083      	sub	sp, #12
 8000c12:	af00      	add	r7, sp, #0
 8000c14:	6078      	str	r0, [r7, #4]
 8000c16:	6039      	str	r1, [r7, #0]

  f_dest->__base_address = f_src->__base_address;
 8000c18:	683b      	ldr	r3, [r7, #0]
 8000c1a:	681a      	ldr	r2, [r3, #0]
 8000c1c:	687b      	ldr	r3, [r7, #4]
 8000c1e:	601a      	str	r2, [r3, #0]
  f_dest->__flag = f_src->__flag;
 8000c20:	683b      	ldr	r3, [r7, #0]
 8000c22:	685a      	ldr	r2, [r3, #4]
 8000c24:	687b      	ldr	r3, [r7, #4]
 8000c26:	605a      	str	r2, [r3, #4]
  f_dest->__crc = f_src->__crc;
 8000c28:	683b      	ldr	r3, [r7, #0]
 8000c2a:	689a      	ldr	r2, [r3, #8]
 8000c2c:	687b      	ldr	r3, [r7, #4]
 8000c2e:	609a      	str	r2, [r3, #8]
  f_dest->__vtable_end = f_src->__vtable_end;
 8000c30:	683b      	ldr	r3, [r7, #0]
 8000c32:	68da      	ldr	r2, [r3, #12]
 8000c34:	687b      	ldr	r3, [r7, #4]
 8000c36:	60da      	str	r2, [r3, #12]
  f_dest->__crc_start_addr = f_src->__crc_start_addr;
 8000c38:	683b      	ldr	r3, [r7, #0]
 8000c3a:	691a      	ldr	r2, [r3, #16]
 8000c3c:	687b      	ldr	r3, [r7, #4]
 8000c3e:	611a      	str	r2, [r3, #16]
  f_dest->__crc_end_addr = f_src->__crc_end_addr;
 8000c40:	683b      	ldr	r3, [r7, #0]
 8000c42:	6a9a      	ldr	r2, [r3, #40]	@ 0x28
 8000c44:	687b      	ldr	r3, [r7, #4]
 8000c46:	629a      	str	r2, [r3, #40]	@ 0x28
  f_dest->__vtable_address = f_src->__vtable_address;
 8000c48:	683b      	ldr	r3, [r7, #0]
 8000c4a:	695a      	ldr	r2, [r3, #20]
 8000c4c:	687b      	ldr	r3, [r7, #4]
 8000c4e:	615a      	str	r2, [r3, #20]
  f_dest->__firmware_end = f_src->__firmware_end;
 8000c50:	683b      	ldr	r3, [r7, #0]
 8000c52:	699a      	ldr	r2, [r3, #24]
 8000c54:	687b      	ldr	r3, [r7, #4]
 8000c56:	619a      	str	r2, [r3, #24]
  f_dest->__firmware_size = f_src->__firmware_size;
 8000c58:	683b      	ldr	r3, [r7, #0]
 8000c5a:	69da      	ldr	r2, [r3, #28]
 8000c5c:	687b      	ldr	r3, [r7, #4]
 8000c5e:	61da      	str	r2, [r3, #28]
  f_dest->__msp_value = f_src->__msp_value;
 8000c60:	683b      	ldr	r3, [r7, #0]
 8000c62:	6a1a      	ldr	r2, [r3, #32]
 8000c64:	687b      	ldr	r3, [r7, #4]
 8000c66:	621a      	str	r2, [r3, #32]
  f_dest->__reset_handler = f_src->__reset_handler;
 8000c68:	683b      	ldr	r3, [r7, #0]
 8000c6a:	6a5a      	ldr	r2, [r3, #36]	@ 0x24
 8000c6c:	687b      	ldr	r3, [r7, #4]
 8000c6e:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000c70:	bf00      	nop
 8000c72:	370c      	adds	r7, #12
 8000c74:	46bd      	mov	sp, r7
 8000c76:	bc80      	pop	{r7}
 8000c78:	4770      	bx	lr

08000c7a <handle_update>:

bool handle_update(void) {
 8000c7a:	b580      	push	{r7, lr}
 8000c7c:	b098      	sub	sp, #96	@ 0x60
 8000c7e:	af00      	add	r7, sp, #0

  /************************* recieve update and store it in
   * UPDATE_ADDR in flash***********************/

  if (recieve_update()) {
 8000c80:	f7ff fe7c 	bl	800097c <recieve_update>
 8000c84:	4603      	mov	r3, r0
 8000c86:	2b00      	cmp	r3, #0
 8000c88:	d005      	beq.n	8000c96 <handle_update+0x1c>
    printf("ERROR in recieving update\n\r", 0x0);
 8000c8a:	2100      	movs	r1, #0
 8000c8c:	4852      	ldr	r0, [pc, #328]	@ (8000dd8 <handle_update+0x15e>)
 8000c8e:	f7ff fde5 	bl	800085c <printf>
    return 0;
 8000c92:	2300      	movs	r3, #0
 8000c94:	e09c      	b.n	8000dd0 <handle_update+0x156>
  }
  firmware_t f;
  update_size = update_size / 4 * 4 + 4; // align update size by 4bytes
 8000c96:	4b51      	ldr	r3, [pc, #324]	@ (8000ddc <handle_update+0x162>)
 8000c98:	681b      	ldr	r3, [r3, #0]
 8000c9a:	f023 0303 	bic.w	r3, r3, #3
 8000c9e:	3304      	adds	r3, #4
 8000ca0:	4a4e      	ldr	r2, [pc, #312]	@ (8000ddc <handle_update+0x162>)
 8000ca2:	6013      	str	r3, [r2, #0]

  if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_1_ADDRESS)
 8000ca4:	4b4e      	ldr	r3, [pc, #312]	@ (8000de0 <handle_update+0x166>)
 8000ca6:	681b      	ldr	r3, [r3, #0]
 8000ca8:	4a4e      	ldr	r2, [pc, #312]	@ (8000de4 <handle_update+0x16a>)
 8000caa:	4293      	cmp	r3, r2
 8000cac:	d106      	bne.n	8000cbc <handle_update+0x42>
    copy_firmware_t(&f, &f1);
 8000cae:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000cb2:	494d      	ldr	r1, [pc, #308]	@ (8000de8 <handle_update+0x16e>)
 8000cb4:	4618      	mov	r0, r3
 8000cb6:	f7ff ffaa 	bl	8000c0e <copy_firmware_t>
 8000cba:	e011      	b.n	8000ce0 <handle_update+0x66>

  else if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_2_ADDRESS)
 8000cbc:	4b48      	ldr	r3, [pc, #288]	@ (8000de0 <handle_update+0x166>)
 8000cbe:	681b      	ldr	r3, [r3, #0]
 8000cc0:	4a4a      	ldr	r2, [pc, #296]	@ (8000dec <handle_update+0x172>)
 8000cc2:	4293      	cmp	r3, r2
 8000cc4:	d106      	bne.n	8000cd4 <handle_update+0x5a>
    copy_firmware_t(&f, &f2);
 8000cc6:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000cca:	4949      	ldr	r1, [pc, #292]	@ (8000df0 <handle_update+0x176>)
 8000ccc:	4618      	mov	r0, r3
 8000cce:	f7ff ff9e 	bl	8000c0e <copy_firmware_t>
 8000cd2:	e005      	b.n	8000ce0 <handle_update+0x66>

  else {
    printf("wrong firmware base address !!!", 0x0);
 8000cd4:	2100      	movs	r1, #0
 8000cd6:	4847      	ldr	r0, [pc, #284]	@ (8000df4 <handle_update+0x17a>)
 8000cd8:	f7ff fdc0 	bl	800085c <printf>
    return 0;
 8000cdc:	2300      	movs	r3, #0
 8000cde:	e077      	b.n	8000dd0 <handle_update+0x156>
  // if (flash_write(UPDATE_ADDR, fw_update, update_size, NO_DELAY)) {
  //   printf("ERROR in flash_write\n\r", 0x0);
  //   return;
  // }

  printf("update has been saved in the update section !!!\n\r", 0x0);
 8000ce0:	2100      	movs	r1, #0
 8000ce2:	4845      	ldr	r0, [pc, #276]	@ (8000df8 <handle_update+0x17e>)
 8000ce4:	f7ff fdba 	bl	800085c <printf>

  firmware_t uf;
  init_firmware_t(UPDATE_ADDR, &uf);
 8000ce8:	f107 0308 	add.w	r3, r7, #8
 8000cec:	4619      	mov	r1, r3
 8000cee:	4843      	ldr	r0, [pc, #268]	@ (8000dfc <handle_update+0x182>)
 8000cf0:	f7ff ff46 	bl	8000b80 <init_firmware_t>

  printf("***************validating update***************\n\r", 0x0);
 8000cf4:	2100      	movs	r1, #0
 8000cf6:	4842      	ldr	r0, [pc, #264]	@ (8000e00 <handle_update+0x186>)
 8000cf8:	f7ff fdb0 	bl	800085c <printf>

  // check flag field of the firmware
  if (uf.__flag != 0xffffffff) {
 8000cfc:	68fb      	ldr	r3, [r7, #12]
 8000cfe:	f1b3 3fff 	cmp.w	r3, #4294967295	@ 0xffffffff
 8000d02:	d005      	beq.n	8000d10 <handle_update+0x96>
    printf("ERROR .... flag field of update must be 0xffffffff\n\r", 0x0);
 8000d04:	2100      	movs	r1, #0
 8000d06:	483f      	ldr	r0, [pc, #252]	@ (8000e04 <handle_update+0x18a>)
 8000d08:	f7ff fda8 	bl	800085c <printf>
    return 0;
 8000d0c:	2300      	movs	r3, #0
 8000d0e:	e05f      	b.n	8000dd0 <handle_update+0x156>
  }
  if (!validate_firmware(&uf)) {
 8000d10:	f107 0308 	add.w	r3, r7, #8
 8000d14:	4618      	mov	r0, r3
 8000d16:	f7ff fc85 	bl	8000624 <validate_firmware>
 8000d1a:	4603      	mov	r3, r0
 8000d1c:	f083 0301 	eor.w	r3, r3, #1
 8000d20:	b2db      	uxtb	r3, r3
 8000d22:	2b00      	cmp	r3, #0
 8000d24:	d005      	beq.n	8000d32 <handle_update+0xb8>
    printf("ERROR .... update validation failed\n\r", 0x0);
 8000d26:	2100      	movs	r1, #0
 8000d28:	4837      	ldr	r0, [pc, #220]	@ (8000e08 <handle_update+0x18e>)
 8000d2a:	f7ff fd97 	bl	800085c <printf>
    return 0;
 8000d2e:	2300      	movs	r3, #0
 8000d30:	e04e      	b.n	8000dd0 <handle_update+0x156>
  }

  /************************firmware to COPY section
   * ***********************************/

  if (erase_flash(COPY_ADDR)) {
 8000d32:	4836      	ldr	r0, [pc, #216]	@ (8000e0c <handle_update+0x192>)
 8000d34:	f000 f9cc 	bl	80010d0 <erase_flash>
 8000d38:	4603      	mov	r3, r0
 8000d3a:	2b00      	cmp	r3, #0
 8000d3c:	d005      	beq.n	8000d4a <handle_update+0xd0>
    printf("could not erase COPY section\n\r", 0x0);
 8000d3e:	2100      	movs	r1, #0
 8000d40:	4833      	ldr	r0, [pc, #204]	@ (8000e10 <handle_update+0x196>)
 8000d42:	f7ff fd8b 	bl	800085c <printf>
    return 0;
 8000d46:	2300      	movs	r3, #0
 8000d48:	e042      	b.n	8000dd0 <handle_update+0x156>
  }
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000d4a:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000d4c:	4619      	mov	r1, r3
                  f.__firmware_size, NO_DELAY)) {
 8000d4e:	6d3a      	ldr	r2, [r7, #80]	@ 0x50
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000d50:	2300      	movs	r3, #0
 8000d52:	482e      	ldr	r0, [pc, #184]	@ (8000e0c <handle_update+0x192>)
 8000d54:	f000 fa76 	bl	8001244 <flash_write>
 8000d58:	4603      	mov	r3, r0
 8000d5a:	2b00      	cmp	r3, #0
 8000d5c:	d005      	beq.n	8000d6a <handle_update+0xf0>

    printf("could not write to the COPY section \n\r", 0x0);
 8000d5e:	2100      	movs	r1, #0
 8000d60:	482c      	ldr	r0, [pc, #176]	@ (8000e14 <handle_update+0x19a>)
 8000d62:	f7ff fd7b 	bl	800085c <printf>
    return 0;
 8000d66:	2300      	movs	r3, #0
 8000d68:	e032      	b.n	8000dd0 <handle_update+0x156>
  }
  printf("firmware is copied to copy section\n\r", 0x0);
 8000d6a:	2100      	movs	r1, #0
 8000d6c:	482a      	ldr	r0, [pc, #168]	@ (8000e18 <handle_update+0x19e>)
 8000d6e:	f7ff fd75 	bl	800085c <printf>

  /********************* update to firmware
   * ********************************************/

  if (erase_flash(f.__base_address)) {
 8000d72:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000d74:	4618      	mov	r0, r3
 8000d76:	f000 f9ab 	bl	80010d0 <erase_flash>
 8000d7a:	4603      	mov	r3, r0
 8000d7c:	2b00      	cmp	r3, #0
 8000d7e:	d005      	beq.n	8000d8c <handle_update+0x112>
    printf("could not erase FIRMWARE section\n\r", 0x0);
 8000d80:	2100      	movs	r1, #0
 8000d82:	4826      	ldr	r0, [pc, #152]	@ (8000e1c <handle_update+0x1a2>)
 8000d84:	f7ff fd6a 	bl	800085c <printf>
    return 0;
 8000d88:	2300      	movs	r3, #0
 8000d8a:	e021      	b.n	8000dd0 <handle_update+0x156>
  }
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000d8c:	6b78      	ldr	r0, [r7, #52]	@ 0x34
                  uf.__firmware_size, NO_DELAY)) {
 8000d8e:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000d90:	2300      	movs	r3, #0
 8000d92:	491a      	ldr	r1, [pc, #104]	@ (8000dfc <handle_update+0x182>)
 8000d94:	f000 fa56 	bl	8001244 <flash_write>
 8000d98:	4603      	mov	r3, r0
 8000d9a:	2b00      	cmp	r3, #0
 8000d9c:	d005      	beq.n	8000daa <handle_update+0x130>

    printf("could not write to the firmware section\n\r", 0x0);
 8000d9e:	2100      	movs	r1, #0
 8000da0:	481f      	ldr	r0, [pc, #124]	@ (8000e20 <handle_update+0x1a6>)
 8000da2:	f7ff fd5b 	bl	800085c <printf>
    return 0;
 8000da6:	2300      	movs	r3, #0
 8000da8:	e012      	b.n	8000dd0 <handle_update+0x156>
  }

  const uint32_t end = 0xfffffffe;
 8000daa:	f06f 0301 	mvn.w	r3, #1
 8000dae:	607b      	str	r3, [r7, #4]
  // mark the flag implying that firmware has been updated
  flash_write(f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000db0:	6b78      	ldr	r0, [r7, #52]	@ 0x34
 8000db2:	1d39      	adds	r1, r7, #4
 8000db4:	2300      	movs	r3, #0
 8000db6:	2204      	movs	r2, #4
 8000db8:	f000 fa44 	bl	8001244 <flash_write>

  printf("new flag = %\n\r", f.__base_address);
 8000dbc:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000dbe:	4619      	mov	r1, r3
 8000dc0:	4818      	ldr	r0, [pc, #96]	@ (8000e24 <handle_update+0x1aa>)
 8000dc2:	f7ff fd4b 	bl	800085c <printf>

  printf("updating firmware is done successfully!!!!\n\r", 0x0);
 8000dc6:	2100      	movs	r1, #0
 8000dc8:	4817      	ldr	r0, [pc, #92]	@ (8000e28 <handle_update+0x1ae>)
 8000dca:	f7ff fd47 	bl	800085c <printf>

  return 1;
 8000dce:	2301      	movs	r3, #1
}
 8000dd0:	4618      	mov	r0, r3
 8000dd2:	3760      	adds	r7, #96	@ 0x60
 8000dd4:	46bd      	mov	sp, r7
 8000dd6:	bd80      	pop	{r7, pc}
 8000dd8:	080018f0 	.word	0x080018f0
 8000ddc:	20000074 	.word	0x20000074
 8000de0:	0804000c 	.word	0x0804000c
 8000de4:	08010000 	.word	0x08010000
 8000de8:	20000008 	.word	0x20000008
 8000dec:	08020000 	.word	0x08020000
 8000df0:	20000034 	.word	0x20000034
 8000df4:	0800190c 	.word	0x0800190c
 8000df8:	0800192c 	.word	0x0800192c
 8000dfc:	08040000 	.word	0x08040000
 8000e00:	08001960 	.word	0x08001960
 8000e04:	08001994 	.word	0x08001994
 8000e08:	080019cc 	.word	0x080019cc
 8000e0c:	08060000 	.word	0x08060000
 8000e10:	080019f4 	.word	0x080019f4
 8000e14:	08001a14 	.word	0x08001a14
 8000e18:	08001a3c 	.word	0x08001a3c
 8000e1c:	08001a64 	.word	0x08001a64
 8000e20:	08001a88 	.word	0x08001a88
 8000e24:	08001ab4 	.word	0x08001ab4
 8000e28:	08001ac4 	.word	0x08001ac4

08000e2c <switch_press>:

bool switch_press (bool f1_valid, bool f2_valid){
 8000e2c:	b580      	push	{r7, lr}
 8000e2e:	b084      	sub	sp, #16
 8000e30:	af00      	add	r7, sp, #0
 8000e32:	4603      	mov	r3, r0
 8000e34:	460a      	mov	r2, r1
 8000e36:	71fb      	strb	r3, [r7, #7]
 8000e38:	4613      	mov	r3, r2
 8000e3a:	71bb      	strb	r3, [r7, #6]

  while (!press_count)
 8000e3c:	bf00      	nop
 8000e3e:	4b35      	ldr	r3, [pc, #212]	@ (8000f14 <switch_press+0xe8>)
 8000e40:	681b      	ldr	r3, [r3, #0]
 8000e42:	2b00      	cmp	r3, #0
 8000e44:	d0fb      	beq.n	8000e3e <switch_press+0x12>
    ;
  delay_count = 1000000;
 8000e46:	4b34      	ldr	r3, [pc, #208]	@ (8000f18 <switch_press+0xec>)
 8000e48:	4a34      	ldr	r2, [pc, #208]	@ (8000f1c <switch_press+0xf0>)
 8000e4a:	601a      	str	r2, [r3, #0]
  while (delay_count--)
 8000e4c:	bf00      	nop
 8000e4e:	4b32      	ldr	r3, [pc, #200]	@ (8000f18 <switch_press+0xec>)
 8000e50:	681b      	ldr	r3, [r3, #0]
 8000e52:	1e5a      	subs	r2, r3, #1
 8000e54:	4930      	ldr	r1, [pc, #192]	@ (8000f18 <switch_press+0xec>)
 8000e56:	600a      	str	r2, [r1, #0]
 8000e58:	2b00      	cmp	r3, #0
 8000e5a:	d1f8      	bne.n	8000e4e <switch_press+0x22>
    ;
  if (press_count >= 3) {
 8000e5c:	4b2d      	ldr	r3, [pc, #180]	@ (8000f14 <switch_press+0xe8>)
 8000e5e:	681b      	ldr	r3, [r3, #0]
 8000e60:	2b02      	cmp	r3, #2
 8000e62:	d930      	bls.n	8000ec6 <switch_press+0x9a>
    erase_flash (UPDATE_ADDR);
 8000e64:	482e      	ldr	r0, [pc, #184]	@ (8000f20 <switch_press+0xf4>)
 8000e66:	f000 f933 	bl	80010d0 <erase_flash>
    firmware_update_mode = true;
 8000e6a:	4b2e      	ldr	r3, [pc, #184]	@ (8000f24 <switch_press+0xf8>)
 8000e6c:	2201      	movs	r2, #1
 8000e6e:	701a      	strb	r2, [r3, #0]
    bool status = handle_update();
 8000e70:	f7ff ff03 	bl	8000c7a <handle_update>
 8000e74:	4603      	mov	r3, r0
 8000e76:	73fb      	strb	r3, [r7, #15]

    if (!status && recursion_depth < MAX_RECURSION_DEPTH) {
 8000e78:	7bfb      	ldrb	r3, [r7, #15]
 8000e7a:	f083 0301 	eor.w	r3, r3, #1
 8000e7e:	b2db      	uxtb	r3, r3
 8000e80:	2b00      	cmp	r3, #0
 8000e82:	d041      	beq.n	8000f08 <switch_press+0xdc>
 8000e84:	4b28      	ldr	r3, [pc, #160]	@ (8000f28 <switch_press+0xfc>)
 8000e86:	781b      	ldrb	r3, [r3, #0]
 8000e88:	2b01      	cmp	r3, #1
 8000e8a:	d83d      	bhi.n	8000f08 <switch_press+0xdc>
      printf ("error in update !!! retry\n\r", 0x0);
 8000e8c:	2100      	movs	r1, #0
 8000e8e:	4827      	ldr	r0, [pc, #156]	@ (8000f2c <switch_press+0x100>)
 8000e90:	f7ff fce4 	bl	800085c <printf>
      recursion_depth ++;
 8000e94:	4b24      	ldr	r3, [pc, #144]	@ (8000f28 <switch_press+0xfc>)
 8000e96:	781b      	ldrb	r3, [r3, #0]
 8000e98:	3301      	adds	r3, #1
 8000e9a:	b2da      	uxtb	r2, r3
 8000e9c:	4b22      	ldr	r3, [pc, #136]	@ (8000f28 <switch_press+0xfc>)
 8000e9e:	701a      	strb	r2, [r3, #0]
      press_count = 0;
 8000ea0:	4b1c      	ldr	r3, [pc, #112]	@ (8000f14 <switch_press+0xe8>)
 8000ea2:	2200      	movs	r2, #0
 8000ea4:	601a      	str	r2, [r3, #0]

      flag_size_recieved = false;
 8000ea6:	4b22      	ldr	r3, [pc, #136]	@ (8000f30 <switch_press+0x104>)
 8000ea8:	2200      	movs	r2, #0
 8000eaa:	701a      	strb	r2, [r3, #0]
      flag_wrong_size = false;
 8000eac:	4b21      	ldr	r3, [pc, #132]	@ (8000f34 <switch_press+0x108>)
 8000eae:	2200      	movs	r2, #0
 8000eb0:	701a      	strb	r2, [r3, #0]
      flag_too_big_update = false;
 8000eb2:	4b21      	ldr	r3, [pc, #132]	@ (8000f38 <switch_press+0x10c>)
 8000eb4:	2200      	movs	r2, #0
 8000eb6:	701a      	strb	r2, [r3, #0]

      switch_press (f1_valid, f2_valid);
 8000eb8:	79ba      	ldrb	r2, [r7, #6]
 8000eba:	79fb      	ldrb	r3, [r7, #7]
 8000ebc:	4611      	mov	r1, r2
 8000ebe:	4618      	mov	r0, r3
 8000ec0:	f7ff ffb4 	bl	8000e2c <switch_press>
 8000ec4:	e020      	b.n	8000f08 <switch_press+0xdc>
    }
  } else if (press_count == 2) {
 8000ec6:	4b13      	ldr	r3, [pc, #76]	@ (8000f14 <switch_press+0xe8>)
 8000ec8:	681b      	ldr	r3, [r3, #0]
 8000eca:	2b02      	cmp	r3, #2
 8000ecc:	d10e      	bne.n	8000eec <switch_press+0xc0>
    if (f2_valid) {
 8000ece:	79bb      	ldrb	r3, [r7, #6]
 8000ed0:	2b00      	cmp	r3, #0
 8000ed2:	d005      	beq.n	8000ee0 <switch_press+0xb4>
      boot_f1 = false;
 8000ed4:	4b19      	ldr	r3, [pc, #100]	@ (8000f3c <switch_press+0x110>)
 8000ed6:	2200      	movs	r2, #0
 8000ed8:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000eda:	f7ff f9e3 	bl	80002a4 <jump_to_firmware>
 8000ede:	e013      	b.n	8000f08 <switch_press+0xdc>
    } else {
      boot_f1 = true;
 8000ee0:	4b16      	ldr	r3, [pc, #88]	@ (8000f3c <switch_press+0x110>)
 8000ee2:	2201      	movs	r2, #1
 8000ee4:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000ee6:	f7ff f9dd 	bl	80002a4 <jump_to_firmware>
 8000eea:	e00d      	b.n	8000f08 <switch_press+0xdc>
    }
  } else {
    if (f1_valid) {
 8000eec:	79fb      	ldrb	r3, [r7, #7]
 8000eee:	2b00      	cmp	r3, #0
 8000ef0:	d005      	beq.n	8000efe <switch_press+0xd2>
      boot_f1 = true;
 8000ef2:	4b12      	ldr	r3, [pc, #72]	@ (8000f3c <switch_press+0x110>)
 8000ef4:	2201      	movs	r2, #1
 8000ef6:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000ef8:	f7ff f9d4 	bl	80002a4 <jump_to_firmware>
 8000efc:	e004      	b.n	8000f08 <switch_press+0xdc>
    } else {
      boot_f1 = false;
 8000efe:	4b0f      	ldr	r3, [pc, #60]	@ (8000f3c <switch_press+0x110>)
 8000f00:	2200      	movs	r2, #0
 8000f02:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000f04:	f7ff f9ce 	bl	80002a4 <jump_to_firmware>
    }
  }
  return true;
 8000f08:	2301      	movs	r3, #1
}
 8000f0a:	4618      	mov	r0, r3
 8000f0c:	3710      	adds	r7, #16
 8000f0e:	46bd      	mov	sp, r7
 8000f10:	bd80      	pop	{r7, pc}
 8000f12:	bf00      	nop
 8000f14:	20000060 	.word	0x20000060
 8000f18:	20000064 	.word	0x20000064
 8000f1c:	000f4240 	.word	0x000f4240
 8000f20:	08040000 	.word	0x08040000
 8000f24:	2000507e 	.word	0x2000507e
 8000f28:	2000507f 	.word	0x2000507f
 8000f2c:	08001af4 	.word	0x08001af4
 8000f30:	20005081 	.word	0x20005081
 8000f34:	20005082 	.word	0x20005082
 8000f38:	20005083 	.word	0x20005083
 8000f3c:	20000004 	.word	0x20000004

08000f40 <main>:


int main() {
 8000f40:	b580      	push	{r7, lr}
 8000f42:	b082      	sub	sp, #8
 8000f44:	af00      	add	r7, sp, #0

    Ring_buff_init(&ringbuffer);
 8000f46:	4852      	ldr	r0, [pc, #328]	@ (8001090 <main+0x150>)
 8000f48:	f7ff fa18 	bl	800037c <Ring_buff_init>

    // enable faults (without this any fault = hardfault)
    SCB->SHCSR |= SCB_SHCSR_BUSFAULTENA_Msk;
 8000f4c:	4b51      	ldr	r3, [pc, #324]	@ (8001094 <main+0x154>)
 8000f4e:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f50:	4a50      	ldr	r2, [pc, #320]	@ (8001094 <main+0x154>)
 8000f52:	f443 3300 	orr.w	r3, r3, #131072	@ 0x20000
 8000f56:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_USGFAULTENA_Msk;
 8000f58:	4b4e      	ldr	r3, [pc, #312]	@ (8001094 <main+0x154>)
 8000f5a:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f5c:	4a4d      	ldr	r2, [pc, #308]	@ (8001094 <main+0x154>)
 8000f5e:	f443 2380 	orr.w	r3, r3, #262144	@ 0x40000
 8000f62:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
 8000f64:	4b4b      	ldr	r3, [pc, #300]	@ (8001094 <main+0x154>)
 8000f66:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f68:	4a4a      	ldr	r2, [pc, #296]	@ (8001094 <main+0x154>)
 8000f6a:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 8000f6e:	6253      	str	r3, [r2, #36]	@ 0x24


  __usart1_init();
 8000f70:	f000 fa04 	bl	800137c <__usart1_init>

  printf("\n\n\nbooting....\n\n\n\r", 0x0);
 8000f74:	2100      	movs	r1, #0
 8000f76:	4848      	ldr	r0, [pc, #288]	@ (8001098 <main+0x158>)
 8000f78:	f7ff fc70 	bl	800085c <printf>

  // check if fimrware is corrupted during update

  if (*(uint32_t *)FIRMWARE_1_ADDRESS & 1) {
 8000f7c:	4b47      	ldr	r3, [pc, #284]	@ (800109c <main+0x15c>)
 8000f7e:	681b      	ldr	r3, [r3, #0]
 8000f80:	f003 0301 	and.w	r3, r3, #1
 8000f84:	2b00      	cmp	r3, #0
 8000f86:	d001      	beq.n	8000f8c <main+0x4c>
    rollback();
 8000f88:	f7ff fd94 	bl	8000ab4 <rollback>
  }
  if (*(uint32_t *)FIRMWARE_2_ADDRESS & 1) {
 8000f8c:	4b44      	ldr	r3, [pc, #272]	@ (80010a0 <main+0x160>)
 8000f8e:	681b      	ldr	r3, [r3, #0]
 8000f90:	f003 0301 	and.w	r3, r3, #1
 8000f94:	2b00      	cmp	r3, #0
 8000f96:	d001      	beq.n	8000f9c <main+0x5c>
    rollback();
 8000f98:	f7ff fd8c 	bl	8000ab4 <rollback>
  }

  bool f1_valid = true;
 8000f9c:	2301      	movs	r3, #1
 8000f9e:	71fb      	strb	r3, [r7, #7]
  bool f2_valid = true;
 8000fa0:	2301      	movs	r3, #1
 8000fa2:	71bb      	strb	r3, [r7, #6]
  init_firmware_t(FIRMWARE_1_ADDRESS, &f1);
 8000fa4:	493f      	ldr	r1, [pc, #252]	@ (80010a4 <main+0x164>)
 8000fa6:	483d      	ldr	r0, [pc, #244]	@ (800109c <main+0x15c>)
 8000fa8:	f7ff fdea 	bl	8000b80 <init_firmware_t>
  init_firmware_t(FIRMWARE_2_ADDRESS, &f2);
 8000fac:	493e      	ldr	r1, [pc, #248]	@ (80010a8 <main+0x168>)
 8000fae:	483c      	ldr	r0, [pc, #240]	@ (80010a0 <main+0x160>)
 8000fb0:	f7ff fde6 	bl	8000b80 <init_firmware_t>

  // printf("hii there %\n\r", f1.__vtable_address);

  printf("*************validating firmware1*************\n\r", 0x0);
 8000fb4:	2100      	movs	r1, #0
 8000fb6:	483d      	ldr	r0, [pc, #244]	@ (80010ac <main+0x16c>)
 8000fb8:	f7ff fc50 	bl	800085c <printf>
  f1_valid = validate_firmware(&f1);
 8000fbc:	4839      	ldr	r0, [pc, #228]	@ (80010a4 <main+0x164>)
 8000fbe:	f7ff fb31 	bl	8000624 <validate_firmware>
 8000fc2:	4603      	mov	r3, r0
 8000fc4:	71fb      	strb	r3, [r7, #7]
  printf("*************validating firmware2*************\n\r", 0x0);
 8000fc6:	2100      	movs	r1, #0
 8000fc8:	4839      	ldr	r0, [pc, #228]	@ (80010b0 <main+0x170>)
 8000fca:	f7ff fc47 	bl	800085c <printf>
  f2_valid = validate_firmware(&f2);
 8000fce:	4836      	ldr	r0, [pc, #216]	@ (80010a8 <main+0x168>)
 8000fd0:	f7ff fb28 	bl	8000624 <validate_firmware>
 8000fd4:	4603      	mov	r3, r0
 8000fd6:	71bb      	strb	r3, [r7, #6]

  printf("both the firmwares are checked\n\r", 0x0);
 8000fd8:	2100      	movs	r1, #0
 8000fda:	4836      	ldr	r0, [pc, #216]	@ (80010b4 <main+0x174>)
 8000fdc:	f7ff fc3e 	bl	800085c <printf>
  // init GPIOC (for on board switch)
  // init SYSCGF (for using EXTI)

  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN_Msk;
 8000fe0:	4b35      	ldr	r3, [pc, #212]	@ (80010b8 <main+0x178>)
 8000fe2:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8000fe4:	4a34      	ldr	r2, [pc, #208]	@ (80010b8 <main+0x178>)
 8000fe6:	f443 4380 	orr.w	r3, r3, #16384	@ 0x4000
 8000fea:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN_Msk;
 8000fec:	4b32      	ldr	r3, [pc, #200]	@ (80010b8 <main+0x178>)
 8000fee:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8000ff0:	4a31      	ldr	r2, [pc, #196]	@ (80010b8 <main+0x178>)
 8000ff2:	f043 0304 	orr.w	r3, r3, #4
 8000ff6:	6313      	str	r3, [r2, #48]	@ 0x30

  // set switch to input
  GPIOC->MODER &= ~(3U << (2 * SWITCH_PIN));
 8000ff8:	4b30      	ldr	r3, [pc, #192]	@ (80010bc <main+0x17c>)
 8000ffa:	681b      	ldr	r3, [r3, #0]
 8000ffc:	4a2f      	ldr	r2, [pc, #188]	@ (80010bc <main+0x17c>)
 8000ffe:	f023 6340 	bic.w	r3, r3, #201326592	@ 0xc000000
 8001002:	6013      	str	r3, [r2, #0]

  // falling edge detect
  EXTI->FTSR |= EXTI_FTSR_TR13_Msk;
 8001004:	4b2e      	ldr	r3, [pc, #184]	@ (80010c0 <main+0x180>)
 8001006:	68db      	ldr	r3, [r3, #12]
 8001008:	4a2d      	ldr	r2, [pc, #180]	@ (80010c0 <main+0x180>)
 800100a:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 800100e:	60d3      	str	r3, [r2, #12]

  SYSCFG->EXTICR[3] &= ~(SYSCFG_EXTICR4_EXTI13_Msk);
 8001010:	4b2c      	ldr	r3, [pc, #176]	@ (80010c4 <main+0x184>)
 8001012:	695b      	ldr	r3, [r3, #20]
 8001014:	4a2b      	ldr	r2, [pc, #172]	@ (80010c4 <main+0x184>)
 8001016:	f023 03f0 	bic.w	r3, r3, #240	@ 0xf0
 800101a:	6153      	str	r3, [r2, #20]
  SYSCFG->EXTICR[3] |= SYSCFG_EXTICR4_EXTI13_PC;
 800101c:	4b29      	ldr	r3, [pc, #164]	@ (80010c4 <main+0x184>)
 800101e:	695b      	ldr	r3, [r3, #20]
 8001020:	4a28      	ldr	r2, [pc, #160]	@ (80010c4 <main+0x184>)
 8001022:	f043 0320 	orr.w	r3, r3, #32
 8001026:	6153      	str	r3, [r2, #20]

  // enable mask at the end
  EXTI->IMR |= EXTI_IMR_MR13_Msk;
 8001028:	4b25      	ldr	r3, [pc, #148]	@ (80010c0 <main+0x180>)
 800102a:	681b      	ldr	r3, [r3, #0]
 800102c:	4a24      	ldr	r2, [pc, #144]	@ (80010c0 <main+0x180>)
 800102e:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8001032:	6013      	str	r3, [r2, #0]

  NVIC_EnableIRQ(EXTI15_10_IRQn);
 8001034:	2028      	movs	r0, #40	@ 0x28
 8001036:	f7ff fd87 	bl	8000b48 <__NVIC_EnableIRQ>

  if (!f1_valid && !f2_valid) {
 800103a:	79fb      	ldrb	r3, [r7, #7]
 800103c:	f083 0301 	eor.w	r3, r3, #1
 8001040:	b2db      	uxtb	r3, r3
 8001042:	2b00      	cmp	r3, #0
 8001044:	d011      	beq.n	800106a <main+0x12a>
 8001046:	79bb      	ldrb	r3, [r7, #6]
 8001048:	f083 0301 	eor.w	r3, r3, #1
 800104c:	b2db      	uxtb	r3, r3
 800104e:	2b00      	cmp	r3, #0
 8001050:	d00b      	beq.n	800106a <main+0x12a>
    printf("both the firmwares are not valid\n\n\r", 0x0);
 8001052:	2100      	movs	r1, #0
 8001054:	481c      	ldr	r0, [pc, #112]	@ (80010c8 <main+0x188>)
 8001056:	f7ff fc01 	bl	800085c <printf>
    EXTI->IMR &= EXTI_IMR_MR13_Msk;
 800105a:	4b19      	ldr	r3, [pc, #100]	@ (80010c0 <main+0x180>)
 800105c:	681b      	ldr	r3, [r3, #0]
 800105e:	4a18      	ldr	r2, [pc, #96]	@ (80010c0 <main+0x180>)
 8001060:	f403 5300 	and.w	r3, r3, #8192	@ 0x2000
 8001064:	6013      	str	r3, [r2, #0]
    handle_update();
 8001066:	f7ff fe08 	bl	8000c7a <handle_update>
  }

  // /* illegal memory access */
  // *(uint32_t *) (0xffffffff) = 0;
  
  bool status = switch_press (f1_valid, f2_valid);
 800106a:	79ba      	ldrb	r2, [r7, #6]
 800106c:	79fb      	ldrb	r3, [r7, #7]
 800106e:	4611      	mov	r1, r2
 8001070:	4618      	mov	r0, r3
 8001072:	f7ff fedb 	bl	8000e2c <switch_press>
 8001076:	4603      	mov	r3, r0
 8001078:	717b      	strb	r3, [r7, #5]
  if (!status){
 800107a:	797b      	ldrb	r3, [r7, #5]
 800107c:	f083 0301 	eor.w	r3, r3, #1
 8001080:	b2db      	uxtb	r3, r3
 8001082:	2b00      	cmp	r3, #0
 8001084:	d003      	beq.n	800108e <main+0x14e>
    printf ("too many wrong firmware update attempt !!!\n\r", 0x0);
 8001086:	2100      	movs	r1, #0
 8001088:	4810      	ldr	r0, [pc, #64]	@ (80010cc <main+0x18c>)
 800108a:	f7ff fbe7 	bl	800085c <printf>
  }
  while (1);
 800108e:	e7fe      	b.n	800108e <main+0x14e>
 8001090:	20000078 	.word	0x20000078
 8001094:	e000ed00 	.word	0xe000ed00
 8001098:	08001b10 	.word	0x08001b10
 800109c:	08010000 	.word	0x08010000
 80010a0:	08020000 	.word	0x08020000
 80010a4:	20000008 	.word	0x20000008
 80010a8:	20000034 	.word	0x20000034
 80010ac:	08001b24 	.word	0x08001b24
 80010b0:	08001b58 	.word	0x08001b58
 80010b4:	08001b8c 	.word	0x08001b8c
 80010b8:	40023800 	.word	0x40023800
 80010bc:	40020800 	.word	0x40020800
 80010c0:	40013c00 	.word	0x40013c00
 80010c4:	40013800 	.word	0x40013800
 80010c8:	08001bb0 	.word	0x08001bb0
 80010cc:	08001bd4 	.word	0x08001bd4

080010d0 <erase_flash>:
#define KEY1 0x45670123
#define KEY2 0xCDEF89AB

void printf (const char *string, uint32_t addr);

uint32_t erase_flash(uint32_t address) {
 80010d0:	b580      	push	{r7, lr}
 80010d2:	b084      	sub	sp, #16
 80010d4:	af00      	add	r7, sp, #0
 80010d6:	6078      	str	r0, [r7, #4]
  if (address >= 0x08080000 || address < 0x08000000) {
 80010d8:	687b      	ldr	r3, [r7, #4]
 80010da:	4a4c      	ldr	r2, [pc, #304]	@ (800120c <erase_flash+0x13c>)
 80010dc:	4293      	cmp	r3, r2
 80010de:	d803      	bhi.n	80010e8 <erase_flash+0x18>
 80010e0:	687b      	ldr	r3, [r7, #4]
 80010e2:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 80010e6:	d206      	bcs.n	80010f6 <erase_flash+0x26>
    printf("wrong address \n\r", 0x0);
 80010e8:	2100      	movs	r1, #0
 80010ea:	4849      	ldr	r0, [pc, #292]	@ (8001210 <erase_flash+0x140>)
 80010ec:	f7ff fbb6 	bl	800085c <printf>
    return -1;
 80010f0:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 80010f4:	e085      	b.n	8001202 <erase_flash+0x132>
  }

  uint32_t sector = 0;
 80010f6:	2300      	movs	r3, #0
 80010f8:	60fb      	str	r3, [r7, #12]
  if (address >= 0x08060000)
 80010fa:	687b      	ldr	r3, [r7, #4]
 80010fc:	4a45      	ldr	r2, [pc, #276]	@ (8001214 <erase_flash+0x144>)
 80010fe:	4293      	cmp	r3, r2
 8001100:	d902      	bls.n	8001108 <erase_flash+0x38>
    sector = 7;
 8001102:	2307      	movs	r3, #7
 8001104:	60fb      	str	r3, [r7, #12]
 8001106:	e037      	b.n	8001178 <erase_flash+0xa8>
  else if (address >= 0x08040000)
 8001108:	687b      	ldr	r3, [r7, #4]
 800110a:	4a43      	ldr	r2, [pc, #268]	@ (8001218 <erase_flash+0x148>)
 800110c:	4293      	cmp	r3, r2
 800110e:	d902      	bls.n	8001116 <erase_flash+0x46>
    sector = 6;
 8001110:	2306      	movs	r3, #6
 8001112:	60fb      	str	r3, [r7, #12]
 8001114:	e030      	b.n	8001178 <erase_flash+0xa8>
  else if (address >= 0x08020000)
 8001116:	687b      	ldr	r3, [r7, #4]
 8001118:	4a40      	ldr	r2, [pc, #256]	@ (800121c <erase_flash+0x14c>)
 800111a:	4293      	cmp	r3, r2
 800111c:	d902      	bls.n	8001124 <erase_flash+0x54>
    sector = 5;
 800111e:	2305      	movs	r3, #5
 8001120:	60fb      	str	r3, [r7, #12]
 8001122:	e029      	b.n	8001178 <erase_flash+0xa8>
  else if (address >= 0x08010000)
 8001124:	687b      	ldr	r3, [r7, #4]
 8001126:	4a3e      	ldr	r2, [pc, #248]	@ (8001220 <erase_flash+0x150>)
 8001128:	4293      	cmp	r3, r2
 800112a:	d902      	bls.n	8001132 <erase_flash+0x62>
    sector = 4;
 800112c:	2304      	movs	r3, #4
 800112e:	60fb      	str	r3, [r7, #12]
 8001130:	e022      	b.n	8001178 <erase_flash+0xa8>
  else if (address >= 0x0800c000)
 8001132:	687b      	ldr	r3, [r7, #4]
 8001134:	4a3b      	ldr	r2, [pc, #236]	@ (8001224 <erase_flash+0x154>)
 8001136:	4293      	cmp	r3, r2
 8001138:	d302      	bcc.n	8001140 <erase_flash+0x70>
    sector = 3;
 800113a:	2303      	movs	r3, #3
 800113c:	60fb      	str	r3, [r7, #12]
 800113e:	e01b      	b.n	8001178 <erase_flash+0xa8>
  else if (address >= 0x08008000)
 8001140:	687b      	ldr	r3, [r7, #4]
 8001142:	4a39      	ldr	r2, [pc, #228]	@ (8001228 <erase_flash+0x158>)
 8001144:	4293      	cmp	r3, r2
 8001146:	d302      	bcc.n	800114e <erase_flash+0x7e>
    sector = 2;
 8001148:	2302      	movs	r3, #2
 800114a:	60fb      	str	r3, [r7, #12]
 800114c:	e014      	b.n	8001178 <erase_flash+0xa8>
  else if (address >= 0x08004000)
 800114e:	687b      	ldr	r3, [r7, #4]
 8001150:	4a36      	ldr	r2, [pc, #216]	@ (800122c <erase_flash+0x15c>)
 8001152:	4293      	cmp	r3, r2
 8001154:	d302      	bcc.n	800115c <erase_flash+0x8c>
    sector = 1;
 8001156:	2301      	movs	r3, #1
 8001158:	60fb      	str	r3, [r7, #12]
 800115a:	e00d      	b.n	8001178 <erase_flash+0xa8>
  else if (address >= 0x08000000)
 800115c:	687b      	ldr	r3, [r7, #4]
 800115e:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 8001162:	d302      	bcc.n	800116a <erase_flash+0x9a>
    sector = 0;
 8001164:	2300      	movs	r3, #0
 8001166:	60fb      	str	r3, [r7, #12]
 8001168:	e006      	b.n	8001178 <erase_flash+0xa8>
  else {
    printf("wrong address\n\r", 0x0);
 800116a:	2100      	movs	r1, #0
 800116c:	4830      	ldr	r0, [pc, #192]	@ (8001230 <erase_flash+0x160>)
 800116e:	f7ff fb75 	bl	800085c <printf>
    return -1;
 8001172:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 8001176:	e044      	b.n	8001202 <erase_flash+0x132>
  }
  // unlock
  FLASH->KEYR = KEY1;
 8001178:	4b2e      	ldr	r3, [pc, #184]	@ (8001234 <erase_flash+0x164>)
 800117a:	4a2f      	ldr	r2, [pc, #188]	@ (8001238 <erase_flash+0x168>)
 800117c:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 800117e:	4b2d      	ldr	r3, [pc, #180]	@ (8001234 <erase_flash+0x164>)
 8001180:	4a2e      	ldr	r2, [pc, #184]	@ (800123c <erase_flash+0x16c>)
 8001182:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8001184:	4b2b      	ldr	r3, [pc, #172]	@ (8001234 <erase_flash+0x164>)
 8001186:	68db      	ldr	r3, [r3, #12]
 8001188:	4a2a      	ldr	r2, [pc, #168]	@ (8001234 <erase_flash+0x164>)
 800118a:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 800118e:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 8001190:	bf00      	nop
 8001192:	4b28      	ldr	r3, [pc, #160]	@ (8001234 <erase_flash+0x164>)
 8001194:	68db      	ldr	r3, [r3, #12]
 8001196:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 800119a:	2b00      	cmp	r3, #0
 800119c:	d1f9      	bne.n	8001192 <erase_flash+0xc2>
    ;

  FLASH->CR |= FLASH_CR_SER;
 800119e:	4b25      	ldr	r3, [pc, #148]	@ (8001234 <erase_flash+0x164>)
 80011a0:	691b      	ldr	r3, [r3, #16]
 80011a2:	4a24      	ldr	r2, [pc, #144]	@ (8001234 <erase_flash+0x164>)
 80011a4:	f043 0302 	orr.w	r3, r3, #2
 80011a8:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(FLASH_CR_SNB);
 80011aa:	4b22      	ldr	r3, [pc, #136]	@ (8001234 <erase_flash+0x164>)
 80011ac:	691b      	ldr	r3, [r3, #16]
 80011ae:	4a21      	ldr	r2, [pc, #132]	@ (8001234 <erase_flash+0x164>)
 80011b0:	f023 03f8 	bic.w	r3, r3, #248	@ 0xf8
 80011b4:	6113      	str	r3, [r2, #16]
  FLASH->CR |= (sector << FLASH_CR_SNB_Pos);
 80011b6:	4b1f      	ldr	r3, [pc, #124]	@ (8001234 <erase_flash+0x164>)
 80011b8:	691a      	ldr	r2, [r3, #16]
 80011ba:	68fb      	ldr	r3, [r7, #12]
 80011bc:	00db      	lsls	r3, r3, #3
 80011be:	491d      	ldr	r1, [pc, #116]	@ (8001234 <erase_flash+0x164>)
 80011c0:	4313      	orrs	r3, r2
 80011c2:	610b      	str	r3, [r1, #16]
  FLASH->CR |= FLASH_CR_STRT;
 80011c4:	4b1b      	ldr	r3, [pc, #108]	@ (8001234 <erase_flash+0x164>)
 80011c6:	691b      	ldr	r3, [r3, #16]
 80011c8:	4a1a      	ldr	r2, [pc, #104]	@ (8001234 <erase_flash+0x164>)
 80011ca:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 80011ce:	6113      	str	r3, [r2, #16]

  // wait for the flash to be erased;
  while (FLASH->SR & FLASH_SR_BSY)
 80011d0:	bf00      	nop
 80011d2:	4b18      	ldr	r3, [pc, #96]	@ (8001234 <erase_flash+0x164>)
 80011d4:	68db      	ldr	r3, [r3, #12]
 80011d6:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 80011da:	2b00      	cmp	r3, #0
 80011dc:	d1f9      	bne.n	80011d2 <erase_flash+0x102>
    ;

  // clear the erase bit
  FLASH->CR &= ~(FLASH_CR_SER);
 80011de:	4b15      	ldr	r3, [pc, #84]	@ (8001234 <erase_flash+0x164>)
 80011e0:	691b      	ldr	r3, [r3, #16]
 80011e2:	4a14      	ldr	r2, [pc, #80]	@ (8001234 <erase_flash+0x164>)
 80011e4:	f023 0302 	bic.w	r3, r3, #2
 80011e8:	6113      	str	r3, [r2, #16]
  // lock the control register
  FLASH->CR |= FLASH_CR_LOCK;
 80011ea:	4b12      	ldr	r3, [pc, #72]	@ (8001234 <erase_flash+0x164>)
 80011ec:	691b      	ldr	r3, [r3, #16]
 80011ee:	4a11      	ldr	r2, [pc, #68]	@ (8001234 <erase_flash+0x164>)
 80011f0:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 80011f4:	6113      	str	r3, [r2, #16]

  printf("done erasing flash (address = %)\n\r", (uint32_t)(&address));
 80011f6:	1d3b      	adds	r3, r7, #4
 80011f8:	4619      	mov	r1, r3
 80011fa:	4811      	ldr	r0, [pc, #68]	@ (8001240 <erase_flash+0x170>)
 80011fc:	f7ff fb2e 	bl	800085c <printf>
  return 0;
 8001200:	2300      	movs	r3, #0
}
 8001202:	4618      	mov	r0, r3
 8001204:	3710      	adds	r7, #16
 8001206:	46bd      	mov	sp, r7
 8001208:	bd80      	pop	{r7, pc}
 800120a:	bf00      	nop
 800120c:	0807ffff 	.word	0x0807ffff
 8001210:	08001c04 	.word	0x08001c04
 8001214:	0805ffff 	.word	0x0805ffff
 8001218:	0803ffff 	.word	0x0803ffff
 800121c:	0801ffff 	.word	0x0801ffff
 8001220:	0800ffff 	.word	0x0800ffff
 8001224:	0800c000 	.word	0x0800c000
 8001228:	08008000 	.word	0x08008000
 800122c:	08004000 	.word	0x08004000
 8001230:	08001c18 	.word	0x08001c18
 8001234:	40023c00 	.word	0x40023c00
 8001238:	45670123 	.word	0x45670123
 800123c:	cdef89ab 	.word	0xcdef89ab
 8001240:	08001c28 	.word	0x08001c28

08001244 <flash_write>:

uint32_t flash_write(uint32_t address, const char *buff, uint32_t size,
                     uint32_t simulate) {
 8001244:	b480      	push	{r7}
 8001246:	b087      	sub	sp, #28
 8001248:	af00      	add	r7, sp, #0
 800124a:	60f8      	str	r0, [r7, #12]
 800124c:	60b9      	str	r1, [r7, #8]
 800124e:	607a      	str	r2, [r7, #4]
 8001250:	603b      	str	r3, [r7, #0]


  // unlock
  FLASH->KEYR = KEY1;
 8001252:	4b26      	ldr	r3, [pc, #152]	@ (80012ec <flash_write+0xa8>)
 8001254:	4a26      	ldr	r2, [pc, #152]	@ (80012f0 <flash_write+0xac>)
 8001256:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 8001258:	4b24      	ldr	r3, [pc, #144]	@ (80012ec <flash_write+0xa8>)
 800125a:	4a26      	ldr	r2, [pc, #152]	@ (80012f4 <flash_write+0xb0>)
 800125c:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 800125e:	4b23      	ldr	r3, [pc, #140]	@ (80012ec <flash_write+0xa8>)
 8001260:	68db      	ldr	r3, [r3, #12]
 8001262:	4a22      	ldr	r2, [pc, #136]	@ (80012ec <flash_write+0xa8>)
 8001264:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 8001268:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 800126a:	bf00      	nop
 800126c:	4b1f      	ldr	r3, [pc, #124]	@ (80012ec <flash_write+0xa8>)
 800126e:	68db      	ldr	r3, [r3, #12]
 8001270:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 8001274:	2b00      	cmp	r3, #0
 8001276:	d1f9      	bne.n	800126c <flash_write+0x28>
    ;
  FLASH->CR |= FLASH_CR_PG;
 8001278:	4b1c      	ldr	r3, [pc, #112]	@ (80012ec <flash_write+0xa8>)
 800127a:	691b      	ldr	r3, [r3, #16]
 800127c:	4a1b      	ldr	r2, [pc, #108]	@ (80012ec <flash_write+0xa8>)
 800127e:	f043 0301 	orr.w	r3, r3, #1
 8001282:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(3 << FLASH_CR_PSIZE_Pos);
 8001284:	4b19      	ldr	r3, [pc, #100]	@ (80012ec <flash_write+0xa8>)
 8001286:	691b      	ldr	r3, [r3, #16]
 8001288:	4a18      	ldr	r2, [pc, #96]	@ (80012ec <flash_write+0xa8>)
 800128a:	f423 7340 	bic.w	r3, r3, #768	@ 0x300
 800128e:	6113      	str	r3, [r2, #16]
  // set PSIZE bit to 2 for 32 bit programming
  FLASH->CR |= 2 << FLASH_CR_PSIZE_Pos;
 8001290:	4b16      	ldr	r3, [pc, #88]	@ (80012ec <flash_write+0xa8>)
 8001292:	691b      	ldr	r3, [r3, #16]
 8001294:	4a15      	ldr	r2, [pc, #84]	@ (80012ec <flash_write+0xa8>)
 8001296:	f443 7300 	orr.w	r3, r3, #512	@ 0x200
 800129a:	6113      	str	r3, [r2, #16]

  uint32_t i = 0;
 800129c:	2300      	movs	r3, #0
 800129e:	617b      	str	r3, [r7, #20]
  while (i < size / 4) {
 80012a0:	e00c      	b.n	80012bc <flash_write+0x78>

    *((uint32_t *)address) = ((const uint32_t *)buff)[i];
 80012a2:	697b      	ldr	r3, [r7, #20]
 80012a4:	009b      	lsls	r3, r3, #2
 80012a6:	68ba      	ldr	r2, [r7, #8]
 80012a8:	441a      	add	r2, r3
 80012aa:	68fb      	ldr	r3, [r7, #12]
 80012ac:	6812      	ldr	r2, [r2, #0]
 80012ae:	601a      	str	r2, [r3, #0]
    i++;
 80012b0:	697b      	ldr	r3, [r7, #20]
 80012b2:	3301      	adds	r3, #1
 80012b4:	617b      	str	r3, [r7, #20]
    address += 4;
 80012b6:	68fb      	ldr	r3, [r7, #12]
 80012b8:	3304      	adds	r3, #4
 80012ba:	60fb      	str	r3, [r7, #12]
  while (i < size / 4) {
 80012bc:	687b      	ldr	r3, [r7, #4]
 80012be:	089b      	lsrs	r3, r3, #2
 80012c0:	697a      	ldr	r2, [r7, #20]
 80012c2:	429a      	cmp	r2, r3
 80012c4:	d3ed      	bcc.n	80012a2 <flash_write+0x5e>
  }
  FLASH->CR &= ~(FLASH_CR_PG);
 80012c6:	4b09      	ldr	r3, [pc, #36]	@ (80012ec <flash_write+0xa8>)
 80012c8:	691b      	ldr	r3, [r3, #16]
 80012ca:	4a08      	ldr	r2, [pc, #32]	@ (80012ec <flash_write+0xa8>)
 80012cc:	f023 0301 	bic.w	r3, r3, #1
 80012d0:	6113      	str	r3, [r2, #16]
  FLASH->CR |= FLASH_CR_LOCK;
 80012d2:	4b06      	ldr	r3, [pc, #24]	@ (80012ec <flash_write+0xa8>)
 80012d4:	691b      	ldr	r3, [r3, #16]
 80012d6:	4a05      	ldr	r2, [pc, #20]	@ (80012ec <flash_write+0xa8>)
 80012d8:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 80012dc:	6113      	str	r3, [r2, #16]

  return 0;
 80012de:	2300      	movs	r3, #0
}
 80012e0:	4618      	mov	r0, r3
 80012e2:	371c      	adds	r7, #28
 80012e4:	46bd      	mov	sp, r7
 80012e6:	bc80      	pop	{r7}
 80012e8:	4770      	bx	lr
 80012ea:	bf00      	nop
 80012ec:	40023c00 	.word	0x40023c00
 80012f0:	45670123 	.word	0x45670123
 80012f4:	cdef89ab 	.word	0xcdef89ab

080012f8 <__NVIC_EnableIRQ>:
{
 80012f8:	b480      	push	{r7}
 80012fa:	b083      	sub	sp, #12
 80012fc:	af00      	add	r7, sp, #0
 80012fe:	4603      	mov	r3, r0
 8001300:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 8001302:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8001306:	2b00      	cmp	r3, #0
 8001308:	db0b      	blt.n	8001322 <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 800130a:	79fb      	ldrb	r3, [r7, #7]
 800130c:	f003 021f 	and.w	r2, r3, #31
 8001310:	4906      	ldr	r1, [pc, #24]	@ (800132c <__NVIC_EnableIRQ+0x34>)
 8001312:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8001316:	095b      	lsrs	r3, r3, #5
 8001318:	2001      	movs	r0, #1
 800131a:	fa00 f202 	lsl.w	r2, r0, r2
 800131e:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 8001322:	bf00      	nop
 8001324:	370c      	adds	r7, #12
 8001326:	46bd      	mov	sp, r7
 8001328:	bc80      	pop	{r7}
 800132a:	4770      	bx	lr
 800132c:	e000e100 	.word	0xe000e100

08001330 <__usart1_scan>:
#include "stm32f401xe.h"

#define TX_PIN 9
#define RX_PIN 10

void __usart1_scan (char* buffer, uint16_t size){
 8001330:	b480      	push	{r7}
 8001332:	b085      	sub	sp, #20
 8001334:	af00      	add	r7, sp, #0
 8001336:	6078      	str	r0, [r7, #4]
 8001338:	460b      	mov	r3, r1
 800133a:	807b      	strh	r3, [r7, #2]
  
  uint16_t i = 0;
 800133c:	2300      	movs	r3, #0
 800133e:	81fb      	strh	r3, [r7, #14]
  while (i < size) {
 8001340:	e010      	b.n	8001364 <__usart1_scan+0x34>
    // wait
    while (!(USART1->SR & USART_SR_RXNE))
 8001342:	bf00      	nop
 8001344:	4b0c      	ldr	r3, [pc, #48]	@ (8001378 <__usart1_scan+0x48>)
 8001346:	681b      	ldr	r3, [r3, #0]
 8001348:	f003 0320 	and.w	r3, r3, #32
 800134c:	2b00      	cmp	r3, #0
 800134e:	d0f9      	beq.n	8001344 <__usart1_scan+0x14>
      ;
    buffer[i++] = USART1->DR;
 8001350:	4b09      	ldr	r3, [pc, #36]	@ (8001378 <__usart1_scan+0x48>)
 8001352:	685a      	ldr	r2, [r3, #4]
 8001354:	89fb      	ldrh	r3, [r7, #14]
 8001356:	1c59      	adds	r1, r3, #1
 8001358:	81f9      	strh	r1, [r7, #14]
 800135a:	4619      	mov	r1, r3
 800135c:	687b      	ldr	r3, [r7, #4]
 800135e:	440b      	add	r3, r1
 8001360:	b2d2      	uxtb	r2, r2
 8001362:	701a      	strb	r2, [r3, #0]
  while (i < size) {
 8001364:	89fa      	ldrh	r2, [r7, #14]
 8001366:	887b      	ldrh	r3, [r7, #2]
 8001368:	429a      	cmp	r2, r3
 800136a:	d3ea      	bcc.n	8001342 <__usart1_scan+0x12>
  }
}
 800136c:	bf00      	nop
 800136e:	bf00      	nop
 8001370:	3714      	adds	r7, #20
 8001372:	46bd      	mov	sp, r7
 8001374:	bc80      	pop	{r7}
 8001376:	4770      	bx	lr
 8001378:	40011000 	.word	0x40011000

0800137c <__usart1_init>:

void __usart1_init(void) {
 800137c:	b580      	push	{r7, lr}
 800137e:	af00      	add	r7, sp, #0

  RCC->APB2ENR |= RCC_APB2ENR_USART1EN_Msk;
 8001380:	4b20      	ldr	r3, [pc, #128]	@ (8001404 <__usart1_init+0x88>)
 8001382:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8001384:	4a1f      	ldr	r2, [pc, #124]	@ (8001404 <__usart1_init+0x88>)
 8001386:	f043 0310 	orr.w	r3, r3, #16
 800138a:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
 800138c:	4b1d      	ldr	r3, [pc, #116]	@ (8001404 <__usart1_init+0x88>)
 800138e:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8001390:	4a1c      	ldr	r2, [pc, #112]	@ (8001404 <__usart1_init+0x88>)
 8001392:	f043 0301 	orr.w	r3, r3, #1
 8001396:	6313      	str	r3, [r2, #48]	@ 0x30
  // alternate function mode
  GPIOA->MODER &= ~((3 << (2 * TX_PIN)) | (3 << (2 * RX_PIN)));
 8001398:	4b1b      	ldr	r3, [pc, #108]	@ (8001408 <__usart1_init+0x8c>)
 800139a:	681b      	ldr	r3, [r3, #0]
 800139c:	4a1a      	ldr	r2, [pc, #104]	@ (8001408 <__usart1_init+0x8c>)
 800139e:	f423 1370 	bic.w	r3, r3, #3932160	@ 0x3c0000
 80013a2:	6013      	str	r3, [r2, #0]
  GPIOA->MODER |= 2 << (2 * TX_PIN) | 2 << (2 * RX_PIN);
 80013a4:	4b18      	ldr	r3, [pc, #96]	@ (8001408 <__usart1_init+0x8c>)
 80013a6:	681b      	ldr	r3, [r3, #0]
 80013a8:	4a17      	ldr	r2, [pc, #92]	@ (8001408 <__usart1_init+0x8c>)
 80013aa:	f443 1320 	orr.w	r3, r3, #2621440	@ 0x280000
 80013ae:	6013      	str	r3, [r2, #0]
  // high speed
  GPIOA->OSPEEDR |= (3 << (TX_PIN * 2)) | (3 << (RX_PIN * 2));
 80013b0:	4b15      	ldr	r3, [pc, #84]	@ (8001408 <__usart1_init+0x8c>)
 80013b2:	689b      	ldr	r3, [r3, #8]
 80013b4:	4a14      	ldr	r2, [pc, #80]	@ (8001408 <__usart1_init+0x8c>)
 80013b6:	f443 1370 	orr.w	r3, r3, #3932160	@ 0x3c0000
 80013ba:	6093      	str	r3, [r2, #8]
  // clear the bits in AFR register
  GPIOA->AFR[1] &= ~((0xf << 4) | (0xf << 8));
 80013bc:	4b12      	ldr	r3, [pc, #72]	@ (8001408 <__usart1_init+0x8c>)
 80013be:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80013c0:	4a11      	ldr	r2, [pc, #68]	@ (8001408 <__usart1_init+0x8c>)
 80013c2:	f423 637f 	bic.w	r3, r3, #4080	@ 0xff0
 80013c6:	6253      	str	r3, [r2, #36]	@ 0x24
  // set for af7
  GPIOA->AFR[1] |= (7 << 4) | (7 << 8);
 80013c8:	4b0f      	ldr	r3, [pc, #60]	@ (8001408 <__usart1_init+0x8c>)
 80013ca:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80013cc:	4a0e      	ldr	r2, [pc, #56]	@ (8001408 <__usart1_init+0x8c>)
 80013ce:	f443 63ee 	orr.w	r3, r3, #1904	@ 0x770
 80013d2:	6253      	str	r3, [r2, #36]	@ 0x24

  // set the baud rate (115200 in this case)
  USART1->BRR = 0x08B;
 80013d4:	4b0d      	ldr	r3, [pc, #52]	@ (800140c <__usart1_init+0x90>)
 80013d6:	228b      	movs	r2, #139	@ 0x8b
 80013d8:	609a      	str	r2, [r3, #8]

  // enable usart reciever interrupt;
  USART1->CR1 = USART_CR1_RXNEIE;
 80013da:	4b0c      	ldr	r3, [pc, #48]	@ (800140c <__usart1_init+0x90>)
 80013dc:	2220      	movs	r2, #32
 80013de:	60da      	str	r2, [r3, #12]

  NVIC_EnableIRQ (USART1_IRQn);
 80013e0:	2025      	movs	r0, #37	@ 0x25
 80013e2:	f7ff ff89 	bl	80012f8 <__NVIC_EnableIRQ>

  // enable transmitter and reciever at the end
  USART1->CR1 |= USART_CR1_RE | USART_CR1_TE;
 80013e6:	4b09      	ldr	r3, [pc, #36]	@ (800140c <__usart1_init+0x90>)
 80013e8:	68db      	ldr	r3, [r3, #12]
 80013ea:	4a08      	ldr	r2, [pc, #32]	@ (800140c <__usart1_init+0x90>)
 80013ec:	f043 030c 	orr.w	r3, r3, #12
 80013f0:	60d3      	str	r3, [r2, #12]

  // enable usart
  USART1->CR1 |= USART_CR1_UE;
 80013f2:	4b06      	ldr	r3, [pc, #24]	@ (800140c <__usart1_init+0x90>)
 80013f4:	68db      	ldr	r3, [r3, #12]
 80013f6:	4a05      	ldr	r2, [pc, #20]	@ (800140c <__usart1_init+0x90>)
 80013f8:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 80013fc:	60d3      	str	r3, [r2, #12]

}
 80013fe:	bf00      	nop
 8001400:	bd80      	pop	{r7, pc}
 8001402:	bf00      	nop
 8001404:	40023800 	.word	0x40023800
 8001408:	40020000 	.word	0x40020000
 800140c:	40011000 	.word	0x40011000

08001410 <__usart1_print>:

void __usart1_print(const char *msg, uint32_t size) {
 8001410:	b480      	push	{r7}
 8001412:	b085      	sub	sp, #20
 8001414:	af00      	add	r7, sp, #0
 8001416:	6078      	str	r0, [r7, #4]
 8001418:	6039      	str	r1, [r7, #0]

  int i = 0;
 800141a:	2300      	movs	r3, #0
 800141c:	60fb      	str	r3, [r7, #12]
  while (i < size && msg[i] != '\0') {
 800141e:	e00f      	b.n	8001440 <__usart1_print+0x30>
    while (!(USART1->SR & USART_SR_TXE))
 8001420:	bf00      	nop
 8001422:	4b13      	ldr	r3, [pc, #76]	@ (8001470 <__usart1_print+0x60>)
 8001424:	681b      	ldr	r3, [r3, #0]
 8001426:	f003 0380 	and.w	r3, r3, #128	@ 0x80
 800142a:	2b00      	cmp	r3, #0
 800142c:	d0f9      	beq.n	8001422 <__usart1_print+0x12>
      ;
    USART1->DR = msg[i++];
 800142e:	68fb      	ldr	r3, [r7, #12]
 8001430:	1c5a      	adds	r2, r3, #1
 8001432:	60fa      	str	r2, [r7, #12]
 8001434:	461a      	mov	r2, r3
 8001436:	687b      	ldr	r3, [r7, #4]
 8001438:	4413      	add	r3, r2
 800143a:	781a      	ldrb	r2, [r3, #0]
 800143c:	4b0c      	ldr	r3, [pc, #48]	@ (8001470 <__usart1_print+0x60>)
 800143e:	605a      	str	r2, [r3, #4]
  while (i < size && msg[i] != '\0') {
 8001440:	68fb      	ldr	r3, [r7, #12]
 8001442:	683a      	ldr	r2, [r7, #0]
 8001444:	429a      	cmp	r2, r3
 8001446:	d905      	bls.n	8001454 <__usart1_print+0x44>
 8001448:	68fb      	ldr	r3, [r7, #12]
 800144a:	687a      	ldr	r2, [r7, #4]
 800144c:	4413      	add	r3, r2
 800144e:	781b      	ldrb	r3, [r3, #0]
 8001450:	2b00      	cmp	r3, #0
 8001452:	d1e5      	bne.n	8001420 <__usart1_print+0x10>
  }
  while (!(USART1->SR & USART_SR_TC)) {
 8001454:	bf00      	nop
 8001456:	4b06      	ldr	r3, [pc, #24]	@ (8001470 <__usart1_print+0x60>)
 8001458:	681b      	ldr	r3, [r3, #0]
 800145a:	f003 0340 	and.w	r3, r3, #64	@ 0x40
 800145e:	2b00      	cmp	r3, #0
 8001460:	d0f9      	beq.n	8001456 <__usart1_print+0x46>
  }
}
 8001462:	bf00      	nop
 8001464:	bf00      	nop
 8001466:	3714      	adds	r7, #20
 8001468:	46bd      	mov	sp, r7
 800146a:	bc80      	pop	{r7}
 800146c:	4770      	bx	lr
 800146e:	bf00      	nop
 8001470:	40011000 	.word	0x40011000

08001474 <Reset_Handler>:
 8001474:	480c      	ldr	r0, [pc, #48]	@ (80014a8 <hang+0x4>)
 8001476:	490d      	ldr	r1, [pc, #52]	@ (80014ac <hang+0x8>)
 8001478:	4a0d      	ldr	r2, [pc, #52]	@ (80014b0 <hang+0xc>)
 800147a:	e7ff      	b.n	800147c <copy>

0800147c <copy>:
 800147c:	4288      	cmp	r0, r1
 800147e:	db04      	blt.n	800148a <copy_helper>
 8001480:	480c      	ldr	r0, [pc, #48]	@ (80014b4 <hang+0x10>)
 8001482:	490d      	ldr	r1, [pc, #52]	@ (80014b8 <hang+0x14>)
 8001484:	f04f 0200 	mov.w	r2, #0
 8001488:	e004      	b.n	8001494 <init_zero>

0800148a <copy_helper>:
 800148a:	f852 3b04 	ldr.w	r3, [r2], #4
 800148e:	f840 3b04 	str.w	r3, [r0], #4
 8001492:	e7f3      	b.n	800147c <copy>

08001494 <init_zero>:
 8001494:	4288      	cmp	r0, r1
 8001496:	db00      	blt.n	800149a <init_zero_helper>
 8001498:	e002      	b.n	80014a0 <call_entry>

0800149a <init_zero_helper>:
 800149a:	f840 2b04 	str.w	r2, [r0], #4
 800149e:	e7f9      	b.n	8001494 <init_zero>

080014a0 <call_entry>:
 80014a0:	f7ff bd4e 	b.w	8000f40 <main>

080014a4 <hang>:
 80014a4:	e7fe      	b.n	80014a4 <hang>
 80014a6:	0000      	.short	0x0000
 80014a8:	20000000 	.word	0x20000000
 80014ac:	20000005 	.word	0x20000005
 80014b0:	08001c4b 	.word	0x08001c4b
 80014b4:	20000008 	.word	0x20000008
 80014b8:	20005084 	.word	0x20005084

080014bc <EXTI15_10_IRQ_handler>:
 80014bc:	f7ff b8e6 	b.w	800068c <switch_pressed>

080014c0 <Default_Handler>:
 80014c0:	e7fe      	b.n	80014c0 <Default_Handler>

080014c2 <BusFault_Handler>:
 80014c2:	f3ef 8008 	mrs	r0, MSP
 80014c6:	6980      	ldr	r0, [r0, #24]
 80014c8:	f04f 0100 	mov.w	r1, #0
 80014cc:	b500      	push	{lr}
 80014ce:	f7fe fe35 	bl	800013c <fault_handler_helper>
 80014d2:	f85d eb04 	ldr.w	lr, [sp], #4
 80014d6:	4770      	bx	lr

080014d8 <MemManage_Handler>:
 80014d8:	f3ef 8008 	mrs	r0, MSP
 80014dc:	6980      	ldr	r0, [r0, #24]
 80014de:	f04f 0101 	mov.w	r1, #1
 80014e2:	b500      	push	{lr}
 80014e4:	f7fe fe2a 	bl	800013c <fault_handler_helper>
 80014e8:	f85d eb04 	ldr.w	lr, [sp], #4
 80014ec:	4770      	bx	lr

080014ee <UsageFault_Handler>:
 80014ee:	f3ef 8008 	mrs	r0, MSP
 80014f2:	6980      	ldr	r0, [r0, #24]
 80014f4:	f04f 0102 	mov.w	r1, #2
 80014f8:	b500      	push	{lr}
 80014fa:	f7fe fe1f 	bl	800013c <fault_handler_helper>
 80014fe:	f85d eb04 	ldr.w	lr, [sp], #4
 8001502:	4770      	bx	lr

08001504 <HardFault_Handler>:
 8001504:	f3ef 8008 	mrs	r0, MSP
 8001508:	6980      	ldr	r0, [r0, #24]
 800150a:	4904      	ldr	r1, [pc, #16]	@ (800151c <HardFault_Handler+0x18>)
 800150c:	f381 8808 	msr	MSP, r1
 8001510:	b500      	push	{lr}
 8001512:	f7fe fe75 	bl	8000200 <HardFault_Handler_helper>
 8001516:	f85d eb04 	ldr.w	lr, [sp], #4
 800151a:	e7fe      	b.n	800151a <HardFault_Handler+0x16>
 800151c:	20017000 	.word	0x20017000

08001520 <SVC_Handler>:
 8001520:	e7fe      	b.n	8001520 <SVC_Handler>

08001522 <SysTick_Handler>:
 8001522:	e7fe      	b.n	8001522 <SysTick_Handler>

08001524 <PendSV_Handler>:
 8001524:	e7fe      	b.n	8001524 <PendSV_Handler>

08001526 <NMI_Handler>:
 8001526:	e7fe      	b.n	8001526 <NMI_Handler>

08001528 <DebugMon_Handler>:
 8001528:	e7fe      	b.n	8001528 <DebugMon_Handler>
