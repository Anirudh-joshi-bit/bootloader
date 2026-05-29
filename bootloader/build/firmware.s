
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
 8000154:	f000 fe3e 	bl	8000dd4 <printf>
    if (SCB->CFSR & SCB_CFSR_BFARVALID_Msk)
 8000158:	4b1f      	ldr	r3, [pc, #124]	@ (80001d8 <fault_handler_helper+0x9c>)
 800015a:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 800015c:	f403 4300 	and.w	r3, r3, #32768	@ 0x8000
 8000160:	2b00      	cmp	r3, #0
 8000162:	d01f      	beq.n	80001a4 <fault_handler_helper+0x68>
      printf("busfault address -> %\n\r", (uint32_t)(&SCB->BFAR));
 8000164:	491d      	ldr	r1, [pc, #116]	@ (80001dc <fault_handler_helper+0xa0>)
 8000166:	481e      	ldr	r0, [pc, #120]	@ (80001e0 <fault_handler_helper+0xa4>)
 8000168:	f000 fe34 	bl	8000dd4 <printf>
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
 8000178:	f000 fe2c 	bl	8000dd4 <printf>
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
 8000190:	f000 fe20 	bl	8000dd4 <printf>
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
 80001a0:	f000 fe18 	bl	8000dd4 <printf>
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
 80001ae:	f000 fe11 	bl	8000dd4 <printf>
         (uint32_t)(&SCB->CFSR));
  printf("PC -> %\n\r", (uint32_t)&pc);
 80001b2:	f107 030c 	add.w	r3, r7, #12
 80001b6:	4619      	mov	r1, r3
 80001b8:	480f      	ldr	r0, [pc, #60]	@ (80001f8 <fault_handler_helper+0xbc>)
 80001ba:	f000 fe0b 	bl	8000dd4 <printf>
  printf("instruction that caused the fault-> %\n\r", (uint32_t)(&instruction));
 80001be:	f107 0314 	add.w	r3, r7, #20
 80001c2:	4619      	mov	r1, r3
 80001c4:	480d      	ldr	r0, [pc, #52]	@ (80001fc <fault_handler_helper+0xc0>)
 80001c6:	f000 fe05 	bl	8000dd4 <printf>


  /* cannot recover */
  while (1);
 80001ca:	e7fe      	b.n	80001ca <fault_handler_helper+0x8e>
    return;
 80001cc:	bf00      	nop


}
 80001ce:	3718      	adds	r7, #24
 80001d0:	46bd      	mov	sp, r7
 80001d2:	bd80      	pop	{r7, pc}
 80001d4:	08001590 	.word	0x08001590
 80001d8:	e000ed00 	.word	0xe000ed00
 80001dc:	e000ed38 	.word	0xe000ed38
 80001e0:	080015a0 	.word	0x080015a0
 80001e4:	080015b8 	.word	0x080015b8
 80001e8:	080015d8 	.word	0x080015d8
 80001ec:	08001600 	.word	0x08001600
 80001f0:	e000ed28 	.word	0xe000ed28
 80001f4:	08001610 	.word	0x08001610
 80001f8:	08001640 	.word	0x08001640
 80001fc:	0800164c 	.word	0x0800164c

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
 8000212:	f000 fddf 	bl	8000dd4 <printf>
  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
 8000216:	490b      	ldr	r1, [pc, #44]	@ (8000244 <HardFault_Handler_helper+0x44>)
 8000218:	480b      	ldr	r0, [pc, #44]	@ (8000248 <HardFault_Handler_helper+0x48>)
 800021a:	f000 fddb 	bl	8000dd4 <printf>
         (uint32_t)(&SCB->CFSR));
  printf("Hard Fault Status Register -> %\n\r", (uint32_t)(&SCB->HFSR));
 800021e:	490b      	ldr	r1, [pc, #44]	@ (800024c <HardFault_Handler_helper+0x4c>)
 8000220:	480b      	ldr	r0, [pc, #44]	@ (8000250 <HardFault_Handler_helper+0x50>)
 8000222:	f000 fdd7 	bl	8000dd4 <printf>
  printf("PC -> %\n\r", (uint32_t)(&pc));
 8000226:	1d3b      	adds	r3, r7, #4
 8000228:	4619      	mov	r1, r3
 800022a:	480a      	ldr	r0, [pc, #40]	@ (8000254 <HardFault_Handler_helper+0x54>)
 800022c:	f000 fdd2 	bl	8000dd4 <printf>
  printf("instruction that triggered HardFault -> %\n\r",
 8000230:	f107 030c 	add.w	r3, r7, #12
 8000234:	4619      	mov	r1, r3
 8000236:	4808      	ldr	r0, [pc, #32]	@ (8000258 <HardFault_Handler_helper+0x58>)
 8000238:	f000 fdcc 	bl	8000dd4 <printf>
         (uint32_t)&instruction);

  /* cannot recover */
  while (1);
 800023c:	e7fe      	b.n	800023c <HardFault_Handler_helper+0x3c>
 800023e:	bf00      	nop
 8000240:	08001674 	.word	0x08001674
 8000244:	e000ed28 	.word	0xe000ed28
 8000248:	08001610 	.word	0x08001610
 800024c:	e000ed2c 	.word	0xe000ed2c
 8000250:	08001688 	.word	0x08001688
 8000254:	08001640 	.word	0x08001640
 8000258:	080016ac 	.word	0x080016ac

0800025c <switch_pressed>:
extern volatile Ring_buff_t ringbuffer;




void switch_pressed(void){  
 800025c:	b480      	push	{r7}
 800025e:	af00      	add	r7, sp, #0
    // clear the pending status (not done by hardware)
    EXTI-> PR = EXTI_PR_PR13_Msk;
 8000260:	4b0b      	ldr	r3, [pc, #44]	@ (8000290 <switch_pressed+0x34>)
 8000262:	f44f 5200 	mov.w	r2, #8192	@ 0x2000
 8000266:	615a      	str	r2, [r3, #20]

    press_count++;
 8000268:	4b0a      	ldr	r3, [pc, #40]	@ (8000294 <switch_pressed+0x38>)
 800026a:	681b      	ldr	r3, [r3, #0]
 800026c:	3301      	adds	r3, #1
 800026e:	4a09      	ldr	r2, [pc, #36]	@ (8000294 <switch_pressed+0x38>)
 8000270:	6013      	str	r3, [r2, #0]
    if (press_count == 3){
 8000272:	4b08      	ldr	r3, [pc, #32]	@ (8000294 <switch_pressed+0x38>)
 8000274:	681b      	ldr	r3, [r3, #0]
 8000276:	2b03      	cmp	r3, #3
 8000278:	d105      	bne.n	8000286 <switch_pressed+0x2a>
        delay_count = 100;
 800027a:	4b07      	ldr	r3, [pc, #28]	@ (8000298 <switch_pressed+0x3c>)
 800027c:	2264      	movs	r2, #100	@ 0x64
 800027e:	601a      	str	r2, [r3, #0]
        recieve_size = true;
 8000280:	4b06      	ldr	r3, [pc, #24]	@ (800029c <switch_pressed+0x40>)
 8000282:	2201      	movs	r2, #1
 8000284:	701a      	strb	r2, [r3, #0]
        //EXTI-> IMR &= ~EXTI_IMR_MR13_Msk;
    }
}
 8000286:	bf00      	nop
 8000288:	46bd      	mov	sp, r7
 800028a:	bc80      	pop	{r7}
 800028c:	4770      	bx	lr
 800028e:	bf00      	nop
 8000290:	40013c00 	.word	0x40013c00
 8000294:	20000060 	.word	0x20000060
 8000298:	20000064 	.word	0x20000064
 800029c:	20005078 	.word	0x20005078

080002a0 <USART1_IRQHandler>:
void USART1_IRQHandler (void){
 80002a0:	b580      	push	{r7, lr}
 80002a2:	b082      	sub	sp, #8
 80002a4:	af00      	add	r7, sp, #0
  if (!firmware_update_mode) return;
 80002a6:	4b26      	ldr	r3, [pc, #152]	@ (8000340 <USART1_IRQHandler+0xa0>)
 80002a8:	781b      	ldrb	r3, [r3, #0]
 80002aa:	f083 0301 	eor.w	r3, r3, #1
 80002ae:	b2db      	uxtb	r3, r3
 80002b0:	2b00      	cmp	r3, #0
 80002b2:	d141      	bne.n	8000338 <USART1_IRQHandler+0x98>
  if (USART1 -> SR & USART_SR_RXNE_Msk){
 80002b4:	4b23      	ldr	r3, [pc, #140]	@ (8000344 <USART1_IRQHandler+0xa4>)
 80002b6:	681b      	ldr	r3, [r3, #0]
 80002b8:	f003 0320 	and.w	r3, r3, #32
 80002bc:	2b00      	cmp	r3, #0
 80002be:	d03c      	beq.n	800033a <USART1_IRQHandler+0x9a>
    if (recieve_size){
 80002c0:	4b21      	ldr	r3, [pc, #132]	@ (8000348 <USART1_IRQHandler+0xa8>)
 80002c2:	781b      	ldrb	r3, [r3, #0]
 80002c4:	b2db      	uxtb	r3, r3
 80002c6:	2b00      	cmp	r3, #0
 80002c8:	d02b      	beq.n	8000322 <USART1_IRQHandler+0x82>
      char digit = '\0';
 80002ca:	2300      	movs	r3, #0
 80002cc:	71fb      	strb	r3, [r7, #7]
      digit = USART1-> DR;
 80002ce:	4b1d      	ldr	r3, [pc, #116]	@ (8000344 <USART1_IRQHandler+0xa4>)
 80002d0:	685b      	ldr	r3, [r3, #4]
 80002d2:	71fb      	strb	r3, [r7, #7]
      if (digit == '\n'){
 80002d4:	79fb      	ldrb	r3, [r7, #7]
 80002d6:	2b0a      	cmp	r3, #10
 80002d8:	d103      	bne.n	80002e2 <USART1_IRQHandler+0x42>
        flag_size_recieved = true;
 80002da:	4b1c      	ldr	r3, [pc, #112]	@ (800034c <USART1_IRQHandler+0xac>)
 80002dc:	2201      	movs	r2, #1
 80002de:	701a      	strb	r2, [r3, #0]
        return;
 80002e0:	e02b      	b.n	800033a <USART1_IRQHandler+0x9a>
      }
      if (digit < '0' || digit > '9'){
 80002e2:	79fb      	ldrb	r3, [r7, #7]
 80002e4:	2b2f      	cmp	r3, #47	@ 0x2f
 80002e6:	d902      	bls.n	80002ee <USART1_IRQHandler+0x4e>
 80002e8:	79fb      	ldrb	r3, [r7, #7]
 80002ea:	2b39      	cmp	r3, #57	@ 0x39
 80002ec:	d903      	bls.n	80002f6 <USART1_IRQHandler+0x56>
        flag_wrong_size = true;
 80002ee:	4b18      	ldr	r3, [pc, #96]	@ (8000350 <USART1_IRQHandler+0xb0>)
 80002f0:	2201      	movs	r2, #1
 80002f2:	701a      	strb	r2, [r3, #0]
        return;
 80002f4:	e021      	b.n	800033a <USART1_IRQHandler+0x9a>
      }
      if (update_size > 128*1024){
 80002f6:	4b17      	ldr	r3, [pc, #92]	@ (8000354 <USART1_IRQHandler+0xb4>)
 80002f8:	681b      	ldr	r3, [r3, #0]
 80002fa:	f5b3 3f00 	cmp.w	r3, #131072	@ 0x20000
 80002fe:	d903      	bls.n	8000308 <USART1_IRQHandler+0x68>
        flag_too_big_update = true;
 8000300:	4b15      	ldr	r3, [pc, #84]	@ (8000358 <USART1_IRQHandler+0xb8>)
 8000302:	2201      	movs	r2, #1
 8000304:	701a      	strb	r2, [r3, #0]
        return;
 8000306:	e018      	b.n	800033a <USART1_IRQHandler+0x9a>
      }
      update_size = update_size * 10 + (digit-'0');
 8000308:	4b12      	ldr	r3, [pc, #72]	@ (8000354 <USART1_IRQHandler+0xb4>)
 800030a:	681a      	ldr	r2, [r3, #0]
 800030c:	4613      	mov	r3, r2
 800030e:	009b      	lsls	r3, r3, #2
 8000310:	4413      	add	r3, r2
 8000312:	005b      	lsls	r3, r3, #1
 8000314:	461a      	mov	r2, r3
 8000316:	79fb      	ldrb	r3, [r7, #7]
 8000318:	4413      	add	r3, r2
 800031a:	3b30      	subs	r3, #48	@ 0x30
 800031c:	4a0d      	ldr	r2, [pc, #52]	@ (8000354 <USART1_IRQHandler+0xb4>)
 800031e:	6013      	str	r3, [r2, #0]
 8000320:	e00b      	b.n	800033a <USART1_IRQHandler+0x9a>
    }
    else {
      // if (fw_ar_ind >= update_size)
      //   return;
      // fw_update [fw_ar_ind++] = USART1 -> DR;
      uint8_t data = USART1 -> DR;
 8000322:	4b08      	ldr	r3, [pc, #32]	@ (8000344 <USART1_IRQHandler+0xa4>)
 8000324:	685b      	ldr	r3, [r3, #4]
 8000326:	b2db      	uxtb	r3, r3
 8000328:	71bb      	strb	r3, [r7, #6]
      Ring_buff_write(&ringbuffer, &data, 1);
 800032a:	1dbb      	adds	r3, r7, #6
 800032c:	2201      	movs	r2, #1
 800032e:	4619      	mov	r1, r3
 8000330:	480a      	ldr	r0, [pc, #40]	@ (800035c <USART1_IRQHandler+0xbc>)
 8000332:	f000 f869 	bl	8000408 <Ring_buff_write>
 8000336:	e000      	b.n	800033a <USART1_IRQHandler+0x9a>
  if (!firmware_update_mode) return;
 8000338:	bf00      	nop
    }
  }
}
 800033a:	3708      	adds	r7, #8
 800033c:	46bd      	mov	sp, r7
 800033e:	bd80      	pop	{r7, pc}
 8000340:	20005076 	.word	0x20005076
 8000344:	40011000 	.word	0x40011000
 8000348:	20005078 	.word	0x20005078
 800034c:	20005079 	.word	0x20005079
 8000350:	2000507a 	.word	0x2000507a
 8000354:	2000006c 	.word	0x2000006c
 8000358:	2000507b 	.word	0x2000507b
 800035c:	20000070 	.word	0x20000070

08000360 <Ring_buff_init>:
#include "ring_buff.h"
#include <stdint.h>
#include <stdbool.h>

void Ring_buff_init(volatile Ring_buff_t *rb) {
 8000360:	b480      	push	{r7}
 8000362:	b083      	sub	sp, #12
 8000364:	af00      	add	r7, sp, #0
 8000366:	6078      	str	r0, [r7, #4]
  rb->rear = 0;
 8000368:	687b      	ldr	r3, [r7, #4]
 800036a:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 800036e:	2200      	movs	r2, #0
 8000370:	f8a3 2800 	strh.w	r2, [r3, #2048]	@ 0x800
  rb->front = 0;
 8000374:	687b      	ldr	r3, [r7, #4]
 8000376:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 800037a:	2200      	movs	r2, #0
 800037c:	f8a3 2802 	strh.w	r2, [r3, #2050]	@ 0x802
}
 8000380:	bf00      	nop
 8000382:	370c      	adds	r7, #12
 8000384:	46bd      	mov	sp, r7
 8000386:	bc80      	pop	{r7}
 8000388:	4770      	bx	lr

0800038a <Ring_buff_empty>:
bool Ring_buff_empty (volatile Ring_buff_t* rb){
 800038a:	b480      	push	{r7}
 800038c:	b083      	sub	sp, #12
 800038e:	af00      	add	r7, sp, #0
 8000390:	6078      	str	r0, [r7, #4]
  return rb->front == rb->rear;
 8000392:	687b      	ldr	r3, [r7, #4]
 8000394:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000398:	f8b3 3802 	ldrh.w	r3, [r3, #2050]	@ 0x802
 800039c:	b29a      	uxth	r2, r3
 800039e:	687b      	ldr	r3, [r7, #4]
 80003a0:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 80003a4:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 80003a8:	b29b      	uxth	r3, r3
 80003aa:	429a      	cmp	r2, r3
 80003ac:	bf0c      	ite	eq
 80003ae:	2301      	moveq	r3, #1
 80003b0:	2300      	movne	r3, #0
 80003b2:	b2db      	uxtb	r3, r3
}
 80003b4:	4618      	mov	r0, r3
 80003b6:	370c      	adds	r7, #12
 80003b8:	46bd      	mov	sp, r7
 80003ba:	bc80      	pop	{r7}
 80003bc:	4770      	bx	lr

080003be <Ring_buff_size>:
uint16_t Ring_buff_size (volatile Ring_buff_t* rb){
 80003be:	b480      	push	{r7}
 80003c0:	b085      	sub	sp, #20
 80003c2:	af00      	add	r7, sp, #0
 80003c4:	6078      	str	r0, [r7, #4]
  uint16_t local_front = rb-> front;
 80003c6:	687b      	ldr	r3, [r7, #4]
 80003c8:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 80003cc:	f8b3 3802 	ldrh.w	r3, [r3, #2050]	@ 0x802
 80003d0:	81fb      	strh	r3, [r7, #14]
  uint16_t local_rear = rb-> rear;
 80003d2:	687b      	ldr	r3, [r7, #4]
 80003d4:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 80003d8:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 80003dc:	81bb      	strh	r3, [r7, #12]

  if (local_front <= local_rear){
 80003de:	89fa      	ldrh	r2, [r7, #14]
 80003e0:	89bb      	ldrh	r3, [r7, #12]
 80003e2:	429a      	cmp	r2, r3
 80003e4:	d804      	bhi.n	80003f0 <Ring_buff_size+0x32>
    return local_rear - local_front;
 80003e6:	89ba      	ldrh	r2, [r7, #12]
 80003e8:	89fb      	ldrh	r3, [r7, #14]
 80003ea:	1ad3      	subs	r3, r2, r3
 80003ec:	b29b      	uxth	r3, r3
 80003ee:	e006      	b.n	80003fe <Ring_buff_size+0x40>
  }
  return RING_BUFF_SIZE - local_front + local_rear;
 80003f0:	89ba      	ldrh	r2, [r7, #12]
 80003f2:	89fb      	ldrh	r3, [r7, #14]
 80003f4:	1ad3      	subs	r3, r2, r3
 80003f6:	b29b      	uxth	r3, r3
 80003f8:	f503 5320 	add.w	r3, r3, #10240	@ 0x2800
 80003fc:	b29b      	uxth	r3, r3
} 
 80003fe:	4618      	mov	r0, r3
 8000400:	3714      	adds	r7, #20
 8000402:	46bd      	mov	sp, r7
 8000404:	bc80      	pop	{r7}
 8000406:	4770      	bx	lr

08000408 <Ring_buff_write>:

// the below functions should only be called by isr
// Use only REAR for write . donot read / write FRONT
// if ring buffer of overwhelmed ... then increase the size of Ringbuffer

void Ring_buff_write(volatile Ring_buff_t *rb, uint8_t *buff, uint16_t size) {
 8000408:	b480      	push	{r7}
 800040a:	b087      	sub	sp, #28
 800040c:	af00      	add	r7, sp, #0
 800040e:	60f8      	str	r0, [r7, #12]
 8000410:	60b9      	str	r1, [r7, #8]
 8000412:	4613      	mov	r3, r2
 8000414:	80fb      	strh	r3, [r7, #6]
  // data can be overwritten ... if this happens -> increase the size of the ring buffer
  
  uint16_t local_rear = rb->rear;
 8000416:	68fb      	ldr	r3, [r7, #12]
 8000418:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 800041c:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 8000420:	82fb      	strh	r3, [r7, #22]

  for (uint16_t ind = 0; ind < size; ind ++){
 8000422:	2300      	movs	r3, #0
 8000424:	82bb      	strh	r3, [r7, #20]
 8000426:	e012      	b.n	800044e <Ring_buff_write+0x46>
    rb-> buffer[local_rear] = buff [ind];
 8000428:	8abb      	ldrh	r3, [r7, #20]
 800042a:	68ba      	ldr	r2, [r7, #8]
 800042c:	441a      	add	r2, r3
 800042e:	8afb      	ldrh	r3, [r7, #22]
 8000430:	7811      	ldrb	r1, [r2, #0]
 8000432:	68fa      	ldr	r2, [r7, #12]
 8000434:	54d1      	strb	r1, [r2, r3]
    local_rear ++;
 8000436:	8afb      	ldrh	r3, [r7, #22]
 8000438:	3301      	adds	r3, #1
 800043a:	82fb      	strh	r3, [r7, #22]
    if (local_rear == RING_BUFF_SIZE)
 800043c:	8afb      	ldrh	r3, [r7, #22]
 800043e:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 8000442:	d101      	bne.n	8000448 <Ring_buff_write+0x40>
      local_rear = 0;
 8000444:	2300      	movs	r3, #0
 8000446:	82fb      	strh	r3, [r7, #22]
  for (uint16_t ind = 0; ind < size; ind ++){
 8000448:	8abb      	ldrh	r3, [r7, #20]
 800044a:	3301      	adds	r3, #1
 800044c:	82bb      	strh	r3, [r7, #20]
 800044e:	8aba      	ldrh	r2, [r7, #20]
 8000450:	88fb      	ldrh	r3, [r7, #6]
 8000452:	429a      	cmp	r2, r3
 8000454:	d3e8      	bcc.n	8000428 <Ring_buff_write+0x20>
  }

  rb-> rear = local_rear; 
 8000456:	68fb      	ldr	r3, [r7, #12]
 8000458:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 800045c:	461a      	mov	r2, r3
 800045e:	8afb      	ldrh	r3, [r7, #22]
 8000460:	f8a2 3800 	strh.w	r3, [r2, #2048]	@ 0x800
}
 8000464:	bf00      	nop
 8000466:	371c      	adds	r7, #28
 8000468:	46bd      	mov	sp, r7
 800046a:	bc80      	pop	{r7}
 800046c:	4770      	bx	lr

0800046e <Ring_buff_read>:

// read the whole Ring_buffer
uint16_t Ring_buff_read(volatile Ring_buff_t *rb, uint8_t *buff,
                        uint16_t buff_size) {
 800046e:	b480      	push	{r7}
 8000470:	b087      	sub	sp, #28
 8000472:	af00      	add	r7, sp, #0
 8000474:	60f8      	str	r0, [r7, #12]
 8000476:	60b9      	str	r1, [r7, #8]
 8000478:	4613      	mov	r3, r2
 800047a:	80fb      	strh	r3, [r7, #6]

  uint16_t local_front = rb->front;
 800047c:	68fb      	ldr	r3, [r7, #12]
 800047e:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000482:	f8b3 3802 	ldrh.w	r3, [r3, #2050]	@ 0x802
 8000486:	82fb      	strh	r3, [r7, #22]
  uint16_t local_rear = rb->rear;
 8000488:	68fb      	ldr	r3, [r7, #12]
 800048a:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 800048e:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 8000492:	827b      	strh	r3, [r7, #18]

  uint16_t ind = 0;
 8000494:	2300      	movs	r3, #0
 8000496:	82bb      	strh	r3, [r7, #20]

  while (ind < buff_size && local_front != local_rear){
 8000498:	e013      	b.n	80004c2 <Ring_buff_read+0x54>
    buff[ind] = rb-> buffer[local_front];
 800049a:	8afa      	ldrh	r2, [r7, #22]
 800049c:	8abb      	ldrh	r3, [r7, #20]
 800049e:	68b9      	ldr	r1, [r7, #8]
 80004a0:	440b      	add	r3, r1
 80004a2:	68f9      	ldr	r1, [r7, #12]
 80004a4:	5c8a      	ldrb	r2, [r1, r2]
 80004a6:	b2d2      	uxtb	r2, r2
 80004a8:	701a      	strb	r2, [r3, #0]
    local_front ++;
 80004aa:	8afb      	ldrh	r3, [r7, #22]
 80004ac:	3301      	adds	r3, #1
 80004ae:	82fb      	strh	r3, [r7, #22]
    if (local_front == RING_BUFF_SIZE)
 80004b0:	8afb      	ldrh	r3, [r7, #22]
 80004b2:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 80004b6:	d101      	bne.n	80004bc <Ring_buff_read+0x4e>
      local_front = 0;
 80004b8:	2300      	movs	r3, #0
 80004ba:	82fb      	strh	r3, [r7, #22]
    ind ++;
 80004bc:	8abb      	ldrh	r3, [r7, #20]
 80004be:	3301      	adds	r3, #1
 80004c0:	82bb      	strh	r3, [r7, #20]
  while (ind < buff_size && local_front != local_rear){
 80004c2:	8aba      	ldrh	r2, [r7, #20]
 80004c4:	88fb      	ldrh	r3, [r7, #6]
 80004c6:	429a      	cmp	r2, r3
 80004c8:	d203      	bcs.n	80004d2 <Ring_buff_read+0x64>
 80004ca:	8afa      	ldrh	r2, [r7, #22]
 80004cc:	8a7b      	ldrh	r3, [r7, #18]
 80004ce:	429a      	cmp	r2, r3
 80004d0:	d1e3      	bne.n	800049a <Ring_buff_read+0x2c>
  }

  rb->front = local_front;
 80004d2:	68fb      	ldr	r3, [r7, #12]
 80004d4:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 80004d8:	461a      	mov	r2, r3
 80004da:	8afb      	ldrh	r3, [r7, #22]
 80004dc:	f8a2 3802 	strh.w	r3, [r2, #2050]	@ 0x802

  return ind;
 80004e0:	8abb      	ldrh	r3, [r7, #20]
}
 80004e2:	4618      	mov	r0, r3
 80004e4:	371c      	adds	r7, #28
 80004e6:	46bd      	mov	sp, r7
 80004e8:	bc80      	pop	{r7}
 80004ea:	4770      	bx	lr

080004ec <validate_vtable>:
#include "core.h"
#include <stdint.h>

bool validate_vtable(firmware_t *f, uint32_t address) {
 80004ec:	b580      	push	{r7, lr}
 80004ee:	b08a      	sub	sp, #40	@ 0x28
 80004f0:	af00      	add	r7, sp, #0
 80004f2:	6078      	str	r0, [r7, #4]
 80004f4:	6039      	str	r1, [r7, #0]

  // vtable end is the next free address
  // check from address ------->    [vtable_start, vtable_end)

  // vtable must be 128byte aligned => last 7 bits must be 0 (for stm32f401re)
  if (f->__vtable_address & ((1 << 7) - 1)) {
 80004f6:	687b      	ldr	r3, [r7, #4]
 80004f8:	695b      	ldr	r3, [r3, #20]
 80004fa:	f003 037f 	and.w	r3, r3, #127	@ 0x7f
 80004fe:	2b00      	cmp	r3, #0
 8000500:	d005      	beq.n	800050e <validate_vtable+0x22>
    printf("the vector table is not 128byte aligned !!!\n\r", 0x0);
 8000502:	2100      	movs	r1, #0
 8000504:	4833      	ldr	r0, [pc, #204]	@ (80005d4 <validate_vtable+0xe8>)
 8000506:	f000 fc65 	bl	8000dd4 <printf>
    return false;
 800050a:	2300      	movs	r3, #0
 800050c:	e05e      	b.n	80005cc <validate_vtable+0xe0>

  // all the "end" addresses are next free address => there should not be any
  // data in the "end" address !! all the addresses must lie in the range
  // [start, end)

  uint32_t RAM_start = 0x20000000;
 800050e:	f04f 5300 	mov.w	r3, #536870912	@ 0x20000000
 8000512:	623b      	str	r3, [r7, #32]
  uint32_t RAM_size = 96 * 1024; // 96kB
 8000514:	f44f 33c0 	mov.w	r3, #98304	@ 0x18000
 8000518:	61fb      	str	r3, [r7, #28]
  uint32_t RAM_end = RAM_start + RAM_size;
 800051a:	6a3a      	ldr	r2, [r7, #32]
 800051c:	69fb      	ldr	r3, [r7, #28]
 800051e:	4413      	add	r3, r2
 8000520:	61bb      	str	r3, [r7, #24]
  uint32_t FLASH_start = f->__vtable_address;
 8000522:	687b      	ldr	r3, [r7, #4]
 8000524:	695b      	ldr	r3, [r3, #20]
 8000526:	617b      	str	r3, [r7, #20]
  uint32_t FLASH_end = f->__firmware_end;
 8000528:	687b      	ldr	r3, [r7, #4]
 800052a:	699b      	ldr	r3, [r3, #24]
 800052c:	613b      	str	r3, [r7, #16]

  /*************************msp check*********************/

  // MSP value can be RAM end as MSP grows downword;
  if (f->__msp_value > RAM_end || f->__msp_value < RAM_start) {
 800052e:	687b      	ldr	r3, [r7, #4]
 8000530:	6a1b      	ldr	r3, [r3, #32]
 8000532:	69ba      	ldr	r2, [r7, #24]
 8000534:	429a      	cmp	r2, r3
 8000536:	d304      	bcc.n	8000542 <validate_vtable+0x56>
 8000538:	687b      	ldr	r3, [r7, #4]
 800053a:	6a1b      	ldr	r3, [r3, #32]
 800053c:	6a3a      	ldr	r2, [r7, #32]
 800053e:	429a      	cmp	r2, r3
 8000540:	d90b      	bls.n	800055a <validate_vtable+0x6e>

    printf("MSP value is -> %\n\r", (uint32_t)(&(f->__msp_value)));
 8000542:	687b      	ldr	r3, [r7, #4]
 8000544:	3320      	adds	r3, #32
 8000546:	4619      	mov	r1, r3
 8000548:	4823      	ldr	r0, [pc, #140]	@ (80005d8 <validate_vtable+0xec>)
 800054a:	f000 fc43 	bl	8000dd4 <printf>
    printf("MSP value is invalid\n\r", 0x0);
 800054e:	2100      	movs	r1, #0
 8000550:	4822      	ldr	r0, [pc, #136]	@ (80005dc <validate_vtable+0xf0>)
 8000552:	f000 fc3f 	bl	8000dd4 <printf>
    return false;
 8000556:	2300      	movs	r3, #0
 8000558:	e038      	b.n	80005cc <validate_vtable+0xe0>
  }
  // msp value must be word aligned !!!
  if (f->__msp_value & 3) {
 800055a:	687b      	ldr	r3, [r7, #4]
 800055c:	6a1b      	ldr	r3, [r3, #32]
 800055e:	f003 0303 	and.w	r3, r3, #3
 8000562:	2b00      	cmp	r3, #0
 8000564:	d005      	beq.n	8000572 <validate_vtable+0x86>
    printf("MSP value is not word aligned\n\r", 0x0);
 8000566:	2100      	movs	r1, #0
 8000568:	481d      	ldr	r0, [pc, #116]	@ (80005e0 <validate_vtable+0xf4>)
 800056a:	f000 fc33 	bl	8000dd4 <printf>
    return false;
 800056e:	2300      	movs	r3, #0
 8000570:	e02c      	b.n	80005cc <validate_vtable+0xe0>
  }

  /************************ vtable check************************/
  uint32_t vtable_entry =
      address + f->__vtable_address - f->__base_address + 0x4;
 8000572:	687b      	ldr	r3, [r7, #4]
 8000574:	695a      	ldr	r2, [r3, #20]
 8000576:	683b      	ldr	r3, [r7, #0]
 8000578:	441a      	add	r2, r3
 800057a:	687b      	ldr	r3, [r7, #4]
 800057c:	681b      	ldr	r3, [r3, #0]
 800057e:	1ad3      	subs	r3, r2, r3
  uint32_t vtable_entry =
 8000580:	3304      	adds	r3, #4
 8000582:	627b      	str	r3, [r7, #36]	@ 0x24
  uint32_t vtable_end = address + f->__vtable_end - f->__base_address;
 8000584:	687b      	ldr	r3, [r7, #4]
 8000586:	68da      	ldr	r2, [r3, #12]
 8000588:	683b      	ldr	r3, [r7, #0]
 800058a:	441a      	add	r2, r3
 800058c:	687b      	ldr	r3, [r7, #4]
 800058e:	681b      	ldr	r3, [r3, #0]
 8000590:	1ad3      	subs	r3, r2, r3
 8000592:	60fb      	str	r3, [r7, #12]

  for (; vtable_entry < vtable_end; vtable_entry += 4) {
 8000594:	e015      	b.n	80005c2 <validate_vtable+0xd6>

    uint32_t FLASH_address =
        (*((uint32_t *)vtable_entry)) & (~1U); // peek inside vtable_entry
 8000596:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000598:	681b      	ldr	r3, [r3, #0]
    uint32_t FLASH_address =
 800059a:	f023 0301 	bic.w	r3, r3, #1
 800059e:	60bb      	str	r3, [r7, #8]
    if (FLASH_address >= FLASH_end || FLASH_address < FLASH_start) {
 80005a0:	68ba      	ldr	r2, [r7, #8]
 80005a2:	693b      	ldr	r3, [r7, #16]
 80005a4:	429a      	cmp	r2, r3
 80005a6:	d203      	bcs.n	80005b0 <validate_vtable+0xc4>
 80005a8:	68ba      	ldr	r2, [r7, #8]
 80005aa:	697b      	ldr	r3, [r7, #20]
 80005ac:	429a      	cmp	r2, r3
 80005ae:	d205      	bcs.n	80005bc <validate_vtable+0xd0>

      printf("% ---- in vtable entry does not exist in the allowed flash "
 80005b0:	6a79      	ldr	r1, [r7, #36]	@ 0x24
 80005b2:	480c      	ldr	r0, [pc, #48]	@ (80005e4 <validate_vtable+0xf8>)
 80005b4:	f000 fc0e 	bl	8000dd4 <printf>
             "range\n\r",
             vtable_entry);
      return false;
 80005b8:	2300      	movs	r3, #0
 80005ba:	e007      	b.n	80005cc <validate_vtable+0xe0>
  for (; vtable_entry < vtable_end; vtable_entry += 4) {
 80005bc:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80005be:	3304      	adds	r3, #4
 80005c0:	627b      	str	r3, [r7, #36]	@ 0x24
 80005c2:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
 80005c4:	68fb      	ldr	r3, [r7, #12]
 80005c6:	429a      	cmp	r2, r3
 80005c8:	d3e5      	bcc.n	8000596 <validate_vtable+0xaa>
    }
  }

  return true;
 80005ca:	2301      	movs	r3, #1
}
 80005cc:	4618      	mov	r0, r3
 80005ce:	3728      	adds	r7, #40	@ 0x28
 80005d0:	46bd      	mov	sp, r7
 80005d2:	bd80      	pop	{r7, pc}
 80005d4:	080016d8 	.word	0x080016d8
 80005d8:	08001708 	.word	0x08001708
 80005dc:	0800171c 	.word	0x0800171c
 80005e0:	08001734 	.word	0x08001734
 80005e4:	08001754 	.word	0x08001754

080005e8 <validate_firmware>:

bool validate_firmware(firmware_t *f, uint32_t address) {
 80005e8:	b580      	push	{r7, lr}
 80005ea:	b084      	sub	sp, #16
 80005ec:	af00      	add	r7, sp, #0
 80005ee:	6078      	str	r0, [r7, #4]
 80005f0:	6039      	str	r1, [r7, #0]

  if (!validate_vtable(f, address)) {
 80005f2:	6839      	ldr	r1, [r7, #0]
 80005f4:	6878      	ldr	r0, [r7, #4]
 80005f6:	f7ff ff79 	bl	80004ec <validate_vtable>
 80005fa:	4603      	mov	r3, r0
 80005fc:	f083 0301 	eor.w	r3, r3, #1
 8000600:	b2db      	uxtb	r3, r3
 8000602:	2b00      	cmp	r3, #0
 8000604:	d005      	beq.n	8000612 <validate_firmware+0x2a>

    printf("vector table of the update is not valid\n\r", 0x0);
 8000606:	2100      	movs	r1, #0
 8000608:	480f      	ldr	r0, [pc, #60]	@ (8000648 <validate_firmware+0x60>)
 800060a:	f000 fbe3 	bl	8000dd4 <printf>
    return false;
 800060e:	2300      	movs	r3, #0
 8000610:	e016      	b.n	8000640 <validate_firmware+0x58>
  }

  uint32_t crc_result = crc_calc(f);
 8000612:	6878      	ldr	r0, [r7, #4]
 8000614:	f7ff fd66 	bl	80000e4 <crc_calc>
 8000618:	4603      	mov	r3, r0
 800061a:	60fb      	str	r3, [r7, #12]
  printf("crc value is -> %\n\r", (uint32_t)(&crc_result));
 800061c:	f107 030c 	add.w	r3, r7, #12
 8000620:	4619      	mov	r1, r3
 8000622:	480a      	ldr	r0, [pc, #40]	@ (800064c <validate_firmware+0x64>)
 8000624:	f000 fbd6 	bl	8000dd4 <printf>
  if (crc_result != f->__crc) {
 8000628:	687b      	ldr	r3, [r7, #4]
 800062a:	689a      	ldr	r2, [r3, #8]
 800062c:	68fb      	ldr	r3, [r7, #12]
 800062e:	429a      	cmp	r2, r3
 8000630:	d005      	beq.n	800063e <validate_firmware+0x56>
    printf("CRC failed\n\r", 0x0);
 8000632:	2100      	movs	r1, #0
 8000634:	4806      	ldr	r0, [pc, #24]	@ (8000650 <validate_firmware+0x68>)
 8000636:	f000 fbcd 	bl	8000dd4 <printf>
    return false;
 800063a:	2300      	movs	r3, #0
 800063c:	e000      	b.n	8000640 <validate_firmware+0x58>
  }
  return true;
 800063e:	2301      	movs	r3, #1
}
 8000640:	4618      	mov	r0, r3
 8000642:	3710      	adds	r7, #16
 8000644:	46bd      	mov	sp, r7
 8000646:	bd80      	pop	{r7, pc}
 8000648:	08001798 	.word	0x08001798
 800064c:	080017c4 	.word	0x080017c4
 8000650:	080017d8 	.word	0x080017d8

08000654 <__NVIC_DisableIRQ>:
  \details Disables a device specific interrupt in the NVIC interrupt controller.
  \param [in]      IRQn  Device specific interrupt number.
  \note    IRQn must not be negative.
 */
__STATIC_INLINE void __NVIC_DisableIRQ(IRQn_Type IRQn)
{
 8000654:	b480      	push	{r7}
 8000656:	b083      	sub	sp, #12
 8000658:	af00      	add	r7, sp, #0
 800065a:	4603      	mov	r3, r0
 800065c:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 800065e:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000662:	2b00      	cmp	r3, #0
 8000664:	db12      	blt.n	800068c <__NVIC_DisableIRQ+0x38>
  {
    NVIC->ICER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 8000666:	79fb      	ldrb	r3, [r7, #7]
 8000668:	f003 021f 	and.w	r2, r3, #31
 800066c:	490a      	ldr	r1, [pc, #40]	@ (8000698 <__NVIC_DisableIRQ+0x44>)
 800066e:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000672:	095b      	lsrs	r3, r3, #5
 8000674:	2001      	movs	r0, #1
 8000676:	fa00 f202 	lsl.w	r2, r0, r2
 800067a:	3320      	adds	r3, #32
 800067c:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
  \details Acts as a special kind of Data Memory Barrier.
           It completes when all explicit memory accesses before this instruction complete.
 */
__STATIC_FORCEINLINE void __DSB(void)
{
  __ASM volatile ("dsb 0xF":::"memory");
 8000680:	f3bf 8f4f 	dsb	sy
}
 8000684:	bf00      	nop
  __ASM volatile ("isb 0xF":::"memory");
 8000686:	f3bf 8f6f 	isb	sy
}
 800068a:	bf00      	nop
    __DSB();
    __ISB();
  }
}
 800068c:	bf00      	nop
 800068e:	370c      	adds	r7, #12
 8000690:	46bd      	mov	sp, r7
 8000692:	bc80      	pop	{r7}
 8000694:	4770      	bx	lr
 8000696:	bf00      	nop
 8000698:	e000e100 	.word	0xe000e100

0800069c <jump_to_firmware>:

extern volatile bool boot_f1;
extern volatile firmware_t f1;
extern volatile firmware_t f2;

void jump_to_firmware() {
 800069c:	b580      	push	{r7, lr}
 800069e:	b084      	sub	sp, #16
 80006a0:	af00      	add	r7, sp, #0
  \details Disables IRQ interrupts by setting special-purpose register PRIMASK.
           Can only be executed in Privileged modes.
 */
__STATIC_FORCEINLINE void __disable_irq(void)
{
  __ASM volatile ("cpsid i" : : : "memory");
 80006a2:	b672      	cpsid	i
}
 80006a4:	bf00      	nop

  __disable_irq();
  

  if (boot_f1) {
 80006a6:	4b2c      	ldr	r3, [pc, #176]	@ (8000758 <jump_to_firmware+0xbc>)
 80006a8:	781b      	ldrb	r3, [r3, #0]
 80006aa:	b2db      	uxtb	r3, r3
 80006ac:	2b00      	cmp	r3, #0
 80006ae:	d027      	beq.n	8000700 <jump_to_firmware+0x64>
    printf("jumping to firmware1 \n\r", 0x0);
 80006b0:	2100      	movs	r1, #0
 80006b2:	482a      	ldr	r0, [pc, #168]	@ (800075c <jump_to_firmware+0xc0>)
 80006b4:	f000 fb8e 	bl	8000dd4 <printf>

    // reset peripherals and flash registers
    // __usart1_reset_reg();
    // flash_reg_reset();
    //
    NVIC_DisableIRQ(EXTI15_10_IRQn);
 80006b8:	2028      	movs	r0, #40	@ 0x28
 80006ba:	f7ff ffcb 	bl	8000654 <__NVIC_DisableIRQ>
    // below this point no other interrupt can be pended !
    for (uint8_t i = 0; i < 8; i++) {
 80006be:	2300      	movs	r3, #0
 80006c0:	73fb      	strb	r3, [r7, #15]
 80006c2:	e009      	b.n	80006d8 <jump_to_firmware+0x3c>
      NVIC->ICPR[i] = 0xffffffff;
 80006c4:	4a26      	ldr	r2, [pc, #152]	@ (8000760 <jump_to_firmware+0xc4>)
 80006c6:	7bfb      	ldrb	r3, [r7, #15]
 80006c8:	3360      	adds	r3, #96	@ 0x60
 80006ca:	f04f 31ff 	mov.w	r1, #4294967295	@ 0xffffffff
 80006ce:	f842 1023 	str.w	r1, [r2, r3, lsl #2]
    for (uint8_t i = 0; i < 8; i++) {
 80006d2:	7bfb      	ldrb	r3, [r7, #15]
 80006d4:	3301      	adds	r3, #1
 80006d6:	73fb      	strb	r3, [r7, #15]
 80006d8:	7bfb      	ldrb	r3, [r7, #15]
 80006da:	2b07      	cmp	r3, #7
 80006dc:	d9f2      	bls.n	80006c4 <jump_to_firmware+0x28>
    }

    __set_MSP(f1.__msp_value);
 80006de:	4b21      	ldr	r3, [pc, #132]	@ (8000764 <jump_to_firmware+0xc8>)
 80006e0:	6a1b      	ldr	r3, [r3, #32]
 80006e2:	60bb      	str	r3, [r7, #8]
  \details Assigns the given value to the Main Stack Pointer (MSP).
  \param [in]    topOfMainStack  Main Stack Pointer value to set
 */
__STATIC_FORCEINLINE void __set_MSP(uint32_t topOfMainStack)
{
  __ASM volatile ("MSR msp, %0" : : "r" (topOfMainStack) : );
 80006e4:	68bb      	ldr	r3, [r7, #8]
 80006e6:	f383 8808 	msr	MSP, r3
}
 80006ea:	bf00      	nop
    SCB->VTOR = f1.__vtable_address;
 80006ec:	4a1e      	ldr	r2, [pc, #120]	@ (8000768 <jump_to_firmware+0xcc>)
 80006ee:	4b1d      	ldr	r3, [pc, #116]	@ (8000764 <jump_to_firmware+0xc8>)
 80006f0:	695b      	ldr	r3, [r3, #20]
 80006f2:	6093      	str	r3, [r2, #8]
  __ASM volatile ("cpsie i" : : : "memory");
 80006f4:	b662      	cpsie	i
}
 80006f6:	bf00      	nop
    // before calling the reset handler, enable irqs
    __enable_irq();
    ((void (*)(void))f1.__reset_handler)();
 80006f8:	4b1a      	ldr	r3, [pc, #104]	@ (8000764 <jump_to_firmware+0xc8>)
 80006fa:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80006fc:	4798      	blx	r3
    SCB->VTOR = f2.__vtable_address;
    // before jumping the reset handler, enable irqs
    __enable_irq();
    ((void (*)(void))f2.__reset_handler)();
  }
}
 80006fe:	e026      	b.n	800074e <jump_to_firmware+0xb2>
    printf("jumping to firmware2 \n\r", 0x0);
 8000700:	2100      	movs	r1, #0
 8000702:	481a      	ldr	r0, [pc, #104]	@ (800076c <jump_to_firmware+0xd0>)
 8000704:	f000 fb66 	bl	8000dd4 <printf>
    NVIC_DisableIRQ(EXTI15_10_IRQn);
 8000708:	2028      	movs	r0, #40	@ 0x28
 800070a:	f7ff ffa3 	bl	8000654 <__NVIC_DisableIRQ>
    for (uint8_t i = 0; i < 8; i++) {
 800070e:	2300      	movs	r3, #0
 8000710:	73bb      	strb	r3, [r7, #14]
 8000712:	e009      	b.n	8000728 <jump_to_firmware+0x8c>
      NVIC->ICPR[i] = 0xffffffff;
 8000714:	4a12      	ldr	r2, [pc, #72]	@ (8000760 <jump_to_firmware+0xc4>)
 8000716:	7bbb      	ldrb	r3, [r7, #14]
 8000718:	3360      	adds	r3, #96	@ 0x60
 800071a:	f04f 31ff 	mov.w	r1, #4294967295	@ 0xffffffff
 800071e:	f842 1023 	str.w	r1, [r2, r3, lsl #2]
    for (uint8_t i = 0; i < 8; i++) {
 8000722:	7bbb      	ldrb	r3, [r7, #14]
 8000724:	3301      	adds	r3, #1
 8000726:	73bb      	strb	r3, [r7, #14]
 8000728:	7bbb      	ldrb	r3, [r7, #14]
 800072a:	2b07      	cmp	r3, #7
 800072c:	d9f2      	bls.n	8000714 <jump_to_firmware+0x78>
    __set_MSP(f2.__msp_value);
 800072e:	4b10      	ldr	r3, [pc, #64]	@ (8000770 <jump_to_firmware+0xd4>)
 8000730:	6a1b      	ldr	r3, [r3, #32]
 8000732:	607b      	str	r3, [r7, #4]
  __ASM volatile ("MSR msp, %0" : : "r" (topOfMainStack) : );
 8000734:	687b      	ldr	r3, [r7, #4]
 8000736:	f383 8808 	msr	MSP, r3
}
 800073a:	bf00      	nop
    SCB->VTOR = f2.__vtable_address;
 800073c:	4a0a      	ldr	r2, [pc, #40]	@ (8000768 <jump_to_firmware+0xcc>)
 800073e:	4b0c      	ldr	r3, [pc, #48]	@ (8000770 <jump_to_firmware+0xd4>)
 8000740:	695b      	ldr	r3, [r3, #20]
 8000742:	6093      	str	r3, [r2, #8]
  __ASM volatile ("cpsie i" : : : "memory");
 8000744:	b662      	cpsie	i
}
 8000746:	bf00      	nop
    ((void (*)(void))f2.__reset_handler)();
 8000748:	4b09      	ldr	r3, [pc, #36]	@ (8000770 <jump_to_firmware+0xd4>)
 800074a:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 800074c:	4798      	blx	r3
}
 800074e:	bf00      	nop
 8000750:	3710      	adds	r7, #16
 8000752:	46bd      	mov	sp, r7
 8000754:	bd80      	pop	{r7, pc}
 8000756:	bf00      	nop
 8000758:	20000000 	.word	0x20000000
 800075c:	080017e8 	.word	0x080017e8
 8000760:	e000e100 	.word	0xe000e100
 8000764:	20000008 	.word	0x20000008
 8000768:	e000ed00 	.word	0xe000ed00
 800076c:	08001800 	.word	0x08001800
 8000770:	20000034 	.word	0x20000034

08000774 <__NVIC_EnableIRQ>:
{
 8000774:	b480      	push	{r7}
 8000776:	b083      	sub	sp, #12
 8000778:	af00      	add	r7, sp, #0
 800077a:	4603      	mov	r3, r0
 800077c:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 800077e:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000782:	2b00      	cmp	r3, #0
 8000784:	db0b      	blt.n	800079e <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 8000786:	79fb      	ldrb	r3, [r7, #7]
 8000788:	f003 021f 	and.w	r2, r3, #31
 800078c:	4906      	ldr	r1, [pc, #24]	@ (80007a8 <__NVIC_EnableIRQ+0x34>)
 800078e:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000792:	095b      	lsrs	r3, r3, #5
 8000794:	2001      	movs	r0, #1
 8000796:	fa00 f202 	lsl.w	r2, r0, r2
 800079a:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 800079e:	bf00      	nop
 80007a0:	370c      	adds	r7, #12
 80007a2:	46bd      	mov	sp, r7
 80007a4:	bc80      	pop	{r7}
 80007a6:	4770      	bx	lr
 80007a8:	e000e100 	.word	0xe000e100

080007ac <init_firmware_t>:
volatile bool flag_size_recieved = false;
volatile bool flag_wrong_size = false;
volatile bool flag_too_big_update = false;


void init_firmware_t(uint32_t address, firmware_t *f) {
 80007ac:	b480      	push	{r7}
 80007ae:	b083      	sub	sp, #12
 80007b0:	af00      	add	r7, sp, #0
 80007b2:	6078      	str	r0, [r7, #4]
 80007b4:	6039      	str	r1, [r7, #0]
  f->__flag = *(volatile uint32_t *)(address + 0x00);
 80007b6:	687b      	ldr	r3, [r7, #4]
 80007b8:	681a      	ldr	r2, [r3, #0]
 80007ba:	683b      	ldr	r3, [r7, #0]
 80007bc:	605a      	str	r2, [r3, #4]
  f->__crc = *((volatile uint32_t *)(address + 0x04));
 80007be:	687b      	ldr	r3, [r7, #4]
 80007c0:	3304      	adds	r3, #4
 80007c2:	681a      	ldr	r2, [r3, #0]
 80007c4:	683b      	ldr	r3, [r7, #0]
 80007c6:	609a      	str	r2, [r3, #8]
  f->__vtable_end = *((volatile uint32_t *)(address + 0x08));
 80007c8:	687b      	ldr	r3, [r7, #4]
 80007ca:	3308      	adds	r3, #8
 80007cc:	681a      	ldr	r2, [r3, #0]
 80007ce:	683b      	ldr	r3, [r7, #0]
 80007d0:	60da      	str	r2, [r3, #12]
  f->__base_address = *((volatile uint32_t *)(address + 0x0c));
 80007d2:	687b      	ldr	r3, [r7, #4]
 80007d4:	330c      	adds	r3, #12
 80007d6:	681a      	ldr	r2, [r3, #0]
 80007d8:	683b      	ldr	r3, [r7, #0]
 80007da:	601a      	str	r2, [r3, #0]
  f->__vtable_address = *((volatile uint32_t *)(address + 0x10));
 80007dc:	687b      	ldr	r3, [r7, #4]
 80007de:	3310      	adds	r3, #16
 80007e0:	681a      	ldr	r2, [r3, #0]
 80007e2:	683b      	ldr	r3, [r7, #0]
 80007e4:	615a      	str	r2, [r3, #20]
  f->__firmware_end = *((volatile uint32_t *)(address + 0x14));
 80007e6:	687b      	ldr	r3, [r7, #4]
 80007e8:	3314      	adds	r3, #20
 80007ea:	681a      	ldr	r2, [r3, #0]
 80007ec:	683b      	ldr	r3, [r7, #0]
 80007ee:	619a      	str	r2, [r3, #24]
  f->__firmware_size = f->__firmware_end - f->__base_address;
 80007f0:	683b      	ldr	r3, [r7, #0]
 80007f2:	699a      	ldr	r2, [r3, #24]
 80007f4:	683b      	ldr	r3, [r7, #0]
 80007f6:	681b      	ldr	r3, [r3, #0]
 80007f8:	1ad2      	subs	r2, r2, r3
 80007fa:	683b      	ldr	r3, [r7, #0]
 80007fc:	61da      	str	r2, [r3, #28]
  f->__crc_start_addr = address + 0x08;
 80007fe:	687b      	ldr	r3, [r7, #4]
 8000800:	f103 0208 	add.w	r2, r3, #8
 8000804:	683b      	ldr	r3, [r7, #0]
 8000806:	611a      	str	r2, [r3, #16]
  f->__crc_end_addr = f->__crc_start_addr - 0x08 + f->__firmware_size;
 8000808:	683b      	ldr	r3, [r7, #0]
 800080a:	691a      	ldr	r2, [r3, #16]
 800080c:	683b      	ldr	r3, [r7, #0]
 800080e:	69db      	ldr	r3, [r3, #28]
 8000810:	4413      	add	r3, r2
 8000812:	f1a3 0208 	sub.w	r2, r3, #8
 8000816:	683b      	ldr	r3, [r7, #0]
 8000818:	629a      	str	r2, [r3, #40]	@ 0x28
  f->__msp_value = *((volatile uint32_t *)(f->__vtable_address));
 800081a:	683b      	ldr	r3, [r7, #0]
 800081c:	695b      	ldr	r3, [r3, #20]
 800081e:	681a      	ldr	r2, [r3, #0]
 8000820:	683b      	ldr	r3, [r7, #0]
 8000822:	621a      	str	r2, [r3, #32]
  f->__reset_handler = *((volatile uint32_t *)(f->__vtable_address + 0x4));
 8000824:	683b      	ldr	r3, [r7, #0]
 8000826:	695b      	ldr	r3, [r3, #20]
 8000828:	3304      	adds	r3, #4
 800082a:	681a      	ldr	r2, [r3, #0]
 800082c:	683b      	ldr	r3, [r7, #0]
 800082e:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000830:	bf00      	nop
 8000832:	370c      	adds	r7, #12
 8000834:	46bd      	mov	sp, r7
 8000836:	bc80      	pop	{r7}
 8000838:	4770      	bx	lr

0800083a <copy_firmware_t>:

void copy_firmware_t(firmware_t *f_dest, firmware_t *f_src) {
 800083a:	b480      	push	{r7}
 800083c:	b083      	sub	sp, #12
 800083e:	af00      	add	r7, sp, #0
 8000840:	6078      	str	r0, [r7, #4]
 8000842:	6039      	str	r1, [r7, #0]

  f_dest->__base_address = f_src->__base_address;
 8000844:	683b      	ldr	r3, [r7, #0]
 8000846:	681a      	ldr	r2, [r3, #0]
 8000848:	687b      	ldr	r3, [r7, #4]
 800084a:	601a      	str	r2, [r3, #0]
  f_dest->__flag = f_src->__flag;
 800084c:	683b      	ldr	r3, [r7, #0]
 800084e:	685a      	ldr	r2, [r3, #4]
 8000850:	687b      	ldr	r3, [r7, #4]
 8000852:	605a      	str	r2, [r3, #4]
  f_dest->__crc = f_src->__crc;
 8000854:	683b      	ldr	r3, [r7, #0]
 8000856:	689a      	ldr	r2, [r3, #8]
 8000858:	687b      	ldr	r3, [r7, #4]
 800085a:	609a      	str	r2, [r3, #8]
  f_dest->__vtable_end = f_src->__vtable_end;
 800085c:	683b      	ldr	r3, [r7, #0]
 800085e:	68da      	ldr	r2, [r3, #12]
 8000860:	687b      	ldr	r3, [r7, #4]
 8000862:	60da      	str	r2, [r3, #12]
  f_dest->__crc_start_addr = f_src->__crc_start_addr;
 8000864:	683b      	ldr	r3, [r7, #0]
 8000866:	691a      	ldr	r2, [r3, #16]
 8000868:	687b      	ldr	r3, [r7, #4]
 800086a:	611a      	str	r2, [r3, #16]
  f_dest->__crc_end_addr = f_src->__crc_end_addr;
 800086c:	683b      	ldr	r3, [r7, #0]
 800086e:	6a9a      	ldr	r2, [r3, #40]	@ 0x28
 8000870:	687b      	ldr	r3, [r7, #4]
 8000872:	629a      	str	r2, [r3, #40]	@ 0x28
  f_dest->__vtable_address = f_src->__vtable_address;
 8000874:	683b      	ldr	r3, [r7, #0]
 8000876:	695a      	ldr	r2, [r3, #20]
 8000878:	687b      	ldr	r3, [r7, #4]
 800087a:	615a      	str	r2, [r3, #20]
  f_dest->__firmware_end = f_src->__firmware_end;
 800087c:	683b      	ldr	r3, [r7, #0]
 800087e:	699a      	ldr	r2, [r3, #24]
 8000880:	687b      	ldr	r3, [r7, #4]
 8000882:	619a      	str	r2, [r3, #24]
  f_dest->__firmware_size = f_src->__firmware_size;
 8000884:	683b      	ldr	r3, [r7, #0]
 8000886:	69da      	ldr	r2, [r3, #28]
 8000888:	687b      	ldr	r3, [r7, #4]
 800088a:	61da      	str	r2, [r3, #28]
  f_dest->__msp_value = f_src->__msp_value;
 800088c:	683b      	ldr	r3, [r7, #0]
 800088e:	6a1a      	ldr	r2, [r3, #32]
 8000890:	687b      	ldr	r3, [r7, #4]
 8000892:	621a      	str	r2, [r3, #32]
  f_dest->__reset_handler = f_src->__reset_handler;
 8000894:	683b      	ldr	r3, [r7, #0]
 8000896:	6a5a      	ldr	r2, [r3, #36]	@ 0x24
 8000898:	687b      	ldr	r3, [r7, #4]
 800089a:	625a      	str	r2, [r3, #36]	@ 0x24
}
 800089c:	bf00      	nop
 800089e:	370c      	adds	r7, #12
 80008a0:	46bd      	mov	sp, r7
 80008a2:	bc80      	pop	{r7}
 80008a4:	4770      	bx	lr

080008a6 <handle_update>:

bool handle_update(void) {
 80008a6:	b580      	push	{r7, lr}
 80008a8:	b098      	sub	sp, #96	@ 0x60
 80008aa:	af00      	add	r7, sp, #0

  /************************* recieve update and store it in
   * UPDATE_ADDR in flash***********************/

  if (recieve_update()) {
 80008ac:	f000 fb22 	bl	8000ef4 <recieve_update>
 80008b0:	4603      	mov	r3, r0
 80008b2:	2b00      	cmp	r3, #0
 80008b4:	d005      	beq.n	80008c2 <handle_update+0x1c>
    printf("ERROR in recieving update\n\r", 0x0);
 80008b6:	2100      	movs	r1, #0
 80008b8:	4853      	ldr	r0, [pc, #332]	@ (8000a08 <handle_update+0x162>)
 80008ba:	f000 fa8b 	bl	8000dd4 <printf>
    return 0;
 80008be:	2300      	movs	r3, #0
 80008c0:	e09d      	b.n	80009fe <handle_update+0x158>
  }
  firmware_t f;
  update_size = update_size / 4 * 4 + 4; // align update size by 4bytes
 80008c2:	4b52      	ldr	r3, [pc, #328]	@ (8000a0c <handle_update+0x166>)
 80008c4:	681b      	ldr	r3, [r3, #0]
 80008c6:	f023 0303 	bic.w	r3, r3, #3
 80008ca:	3304      	adds	r3, #4
 80008cc:	4a4f      	ldr	r2, [pc, #316]	@ (8000a0c <handle_update+0x166>)
 80008ce:	6013      	str	r3, [r2, #0]

  if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_1_ADDRESS)
 80008d0:	4b4f      	ldr	r3, [pc, #316]	@ (8000a10 <handle_update+0x16a>)
 80008d2:	681b      	ldr	r3, [r3, #0]
 80008d4:	4a4f      	ldr	r2, [pc, #316]	@ (8000a14 <handle_update+0x16e>)
 80008d6:	4293      	cmp	r3, r2
 80008d8:	d106      	bne.n	80008e8 <handle_update+0x42>
    copy_firmware_t(&f, &f1);
 80008da:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 80008de:	494e      	ldr	r1, [pc, #312]	@ (8000a18 <handle_update+0x172>)
 80008e0:	4618      	mov	r0, r3
 80008e2:	f7ff ffaa 	bl	800083a <copy_firmware_t>
 80008e6:	e011      	b.n	800090c <handle_update+0x66>


  else if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_2_ADDRESS)
 80008e8:	4b49      	ldr	r3, [pc, #292]	@ (8000a10 <handle_update+0x16a>)
 80008ea:	681b      	ldr	r3, [r3, #0]
 80008ec:	4a4b      	ldr	r2, [pc, #300]	@ (8000a1c <handle_update+0x176>)
 80008ee:	4293      	cmp	r3, r2
 80008f0:	d106      	bne.n	8000900 <handle_update+0x5a>
    copy_firmware_t(&f, &f2);
 80008f2:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 80008f6:	494a      	ldr	r1, [pc, #296]	@ (8000a20 <handle_update+0x17a>)
 80008f8:	4618      	mov	r0, r3
 80008fa:	f7ff ff9e 	bl	800083a <copy_firmware_t>
 80008fe:	e005      	b.n	800090c <handle_update+0x66>

  else {
    printf("wrong firmware base address !!!", 0x0);
 8000900:	2100      	movs	r1, #0
 8000902:	4848      	ldr	r0, [pc, #288]	@ (8000a24 <handle_update+0x17e>)
 8000904:	f000 fa66 	bl	8000dd4 <printf>
    return 0;
 8000908:	2300      	movs	r3, #0
 800090a:	e078      	b.n	80009fe <handle_update+0x158>
  }

  /******************** store the update in UPDATE section
   * ***************************/

  printf("update has been saved in the update section !!!\n\r", 0x0);
 800090c:	2100      	movs	r1, #0
 800090e:	4846      	ldr	r0, [pc, #280]	@ (8000a28 <handle_update+0x182>)
 8000910:	f000 fa60 	bl	8000dd4 <printf>

  firmware_t uf;
  init_firmware_t(UPDATE_ADDR, &uf);
 8000914:	f107 0308 	add.w	r3, r7, #8
 8000918:	4619      	mov	r1, r3
 800091a:	4844      	ldr	r0, [pc, #272]	@ (8000a2c <handle_update+0x186>)
 800091c:	f7ff ff46 	bl	80007ac <init_firmware_t>

  printf("***************validating update***************\n\r", 0x0);
 8000920:	2100      	movs	r1, #0
 8000922:	4843      	ldr	r0, [pc, #268]	@ (8000a30 <handle_update+0x18a>)
 8000924:	f000 fa56 	bl	8000dd4 <printf>

  // check flag field of the firmware
  if (uf.__flag != 0xffffffff) {
 8000928:	68fb      	ldr	r3, [r7, #12]
 800092a:	f1b3 3fff 	cmp.w	r3, #4294967295	@ 0xffffffff
 800092e:	d005      	beq.n	800093c <handle_update+0x96>
    printf("ERROR .... flag field of update must be 0xffffffff\n\r", 0x0);
 8000930:	2100      	movs	r1, #0
 8000932:	4840      	ldr	r0, [pc, #256]	@ (8000a34 <handle_update+0x18e>)
 8000934:	f000 fa4e 	bl	8000dd4 <printf>
    return 0;
 8000938:	2300      	movs	r3, #0
 800093a:	e060      	b.n	80009fe <handle_update+0x158>
  }
  if (!validate_firmware(&uf, UPDATE_ADDR)) {
 800093c:	f107 0308 	add.w	r3, r7, #8
 8000940:	493a      	ldr	r1, [pc, #232]	@ (8000a2c <handle_update+0x186>)
 8000942:	4618      	mov	r0, r3
 8000944:	f7ff fe50 	bl	80005e8 <validate_firmware>
 8000948:	4603      	mov	r3, r0
 800094a:	f083 0301 	eor.w	r3, r3, #1
 800094e:	b2db      	uxtb	r3, r3
 8000950:	2b00      	cmp	r3, #0
 8000952:	d005      	beq.n	8000960 <handle_update+0xba>
    printf("ERROR .... update validation failed\n\r", 0x0);
 8000954:	2100      	movs	r1, #0
 8000956:	4838      	ldr	r0, [pc, #224]	@ (8000a38 <handle_update+0x192>)
 8000958:	f000 fa3c 	bl	8000dd4 <printf>
    return 0;
 800095c:	2300      	movs	r3, #0
 800095e:	e04e      	b.n	80009fe <handle_update+0x158>
  }

  /************************firmware to COPY section
   * ***********************************/

  if (erase_flash(COPY_ADDR)) {
 8000960:	4836      	ldr	r0, [pc, #216]	@ (8000a3c <handle_update+0x196>)
 8000962:	f000 fc87 	bl	8001274 <erase_flash>
 8000966:	4603      	mov	r3, r0
 8000968:	2b00      	cmp	r3, #0
 800096a:	d005      	beq.n	8000978 <handle_update+0xd2>
    printf("could not erase COPY section\n\r", 0x0);
 800096c:	2100      	movs	r1, #0
 800096e:	4834      	ldr	r0, [pc, #208]	@ (8000a40 <handle_update+0x19a>)
 8000970:	f000 fa30 	bl	8000dd4 <printf>
    return 0;
 8000974:	2300      	movs	r3, #0
 8000976:	e042      	b.n	80009fe <handle_update+0x158>
  }
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000978:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 800097a:	4619      	mov	r1, r3
                  f.__firmware_size, NO_DELAY)) {
 800097c:	6d3a      	ldr	r2, [r7, #80]	@ 0x50
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 800097e:	2300      	movs	r3, #0
 8000980:	482e      	ldr	r0, [pc, #184]	@ (8000a3c <handle_update+0x196>)
 8000982:	f000 fd31 	bl	80013e8 <flash_write>
 8000986:	4603      	mov	r3, r0
 8000988:	2b00      	cmp	r3, #0
 800098a:	d005      	beq.n	8000998 <handle_update+0xf2>

    printf("could not write to the COPY section \n\r", 0x0);
 800098c:	2100      	movs	r1, #0
 800098e:	482d      	ldr	r0, [pc, #180]	@ (8000a44 <handle_update+0x19e>)
 8000990:	f000 fa20 	bl	8000dd4 <printf>
    return 0;
 8000994:	2300      	movs	r3, #0
 8000996:	e032      	b.n	80009fe <handle_update+0x158>
  }
  printf("firmware is copied to copy section\n\r", 0x0);
 8000998:	2100      	movs	r1, #0
 800099a:	482b      	ldr	r0, [pc, #172]	@ (8000a48 <handle_update+0x1a2>)
 800099c:	f000 fa1a 	bl	8000dd4 <printf>

  /********************* update to firmware
   * ********************************************/

  if (erase_flash(f.__base_address)) {
 80009a0:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 80009a2:	4618      	mov	r0, r3
 80009a4:	f000 fc66 	bl	8001274 <erase_flash>
 80009a8:	4603      	mov	r3, r0
 80009aa:	2b00      	cmp	r3, #0
 80009ac:	d005      	beq.n	80009ba <handle_update+0x114>
    printf("could not erase FIRMWARE section\n\r", 0x0);
 80009ae:	2100      	movs	r1, #0
 80009b0:	4826      	ldr	r0, [pc, #152]	@ (8000a4c <handle_update+0x1a6>)
 80009b2:	f000 fa0f 	bl	8000dd4 <printf>
    return 0;
 80009b6:	2300      	movs	r3, #0
 80009b8:	e021      	b.n	80009fe <handle_update+0x158>
  }
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 80009ba:	6b78      	ldr	r0, [r7, #52]	@ 0x34
                  uf.__firmware_size, NO_DELAY)) {
 80009bc:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 80009be:	2300      	movs	r3, #0
 80009c0:	491a      	ldr	r1, [pc, #104]	@ (8000a2c <handle_update+0x186>)
 80009c2:	f000 fd11 	bl	80013e8 <flash_write>
 80009c6:	4603      	mov	r3, r0
 80009c8:	2b00      	cmp	r3, #0
 80009ca:	d005      	beq.n	80009d8 <handle_update+0x132>

    printf("could not write to the firmware section\n\r", 0x0);
 80009cc:	2100      	movs	r1, #0
 80009ce:	4820      	ldr	r0, [pc, #128]	@ (8000a50 <handle_update+0x1aa>)
 80009d0:	f000 fa00 	bl	8000dd4 <printf>
    return 0;
 80009d4:	2300      	movs	r3, #0
 80009d6:	e012      	b.n	80009fe <handle_update+0x158>
  }

  const uint32_t end = 0xfffffffe;
 80009d8:	f06f 0301 	mvn.w	r3, #1
 80009dc:	607b      	str	r3, [r7, #4]
  // mark the flag implying that firmware has been updated
  flash_write(f.__base_address, (const char *)(&end), 4, NO_DELAY);
 80009de:	6b78      	ldr	r0, [r7, #52]	@ 0x34
 80009e0:	1d39      	adds	r1, r7, #4
 80009e2:	2300      	movs	r3, #0
 80009e4:	2204      	movs	r2, #4
 80009e6:	f000 fcff 	bl	80013e8 <flash_write>

  printf("new flag = %\n\r", f.__base_address);
 80009ea:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 80009ec:	4619      	mov	r1, r3
 80009ee:	4819      	ldr	r0, [pc, #100]	@ (8000a54 <handle_update+0x1ae>)
 80009f0:	f000 f9f0 	bl	8000dd4 <printf>

  printf("updating firmware is done successfully!!!!\n\r", 0x0);
 80009f4:	2100      	movs	r1, #0
 80009f6:	4818      	ldr	r0, [pc, #96]	@ (8000a58 <handle_update+0x1b2>)
 80009f8:	f000 f9ec 	bl	8000dd4 <printf>

  return 1;
 80009fc:	2301      	movs	r3, #1
}
 80009fe:	4618      	mov	r0, r3
 8000a00:	3760      	adds	r7, #96	@ 0x60
 8000a02:	46bd      	mov	sp, r7
 8000a04:	bd80      	pop	{r7, pc}
 8000a06:	bf00      	nop
 8000a08:	08001818 	.word	0x08001818
 8000a0c:	2000006c 	.word	0x2000006c
 8000a10:	0804000c 	.word	0x0804000c
 8000a14:	08004000 	.word	0x08004000
 8000a18:	20000008 	.word	0x20000008
 8000a1c:	08020000 	.word	0x08020000
 8000a20:	20000034 	.word	0x20000034
 8000a24:	08001834 	.word	0x08001834
 8000a28:	08001854 	.word	0x08001854
 8000a2c:	08040000 	.word	0x08040000
 8000a30:	08001888 	.word	0x08001888
 8000a34:	080018bc 	.word	0x080018bc
 8000a38:	080018f4 	.word	0x080018f4
 8000a3c:	08060000 	.word	0x08060000
 8000a40:	0800191c 	.word	0x0800191c
 8000a44:	0800193c 	.word	0x0800193c
 8000a48:	08001964 	.word	0x08001964
 8000a4c:	0800198c 	.word	0x0800198c
 8000a50:	080019b0 	.word	0x080019b0
 8000a54:	080019dc 	.word	0x080019dc
 8000a58:	080019ec 	.word	0x080019ec

08000a5c <switch_press>:

bool switch_press (bool f1_valid, bool f2_valid){
 8000a5c:	b580      	push	{r7, lr}
 8000a5e:	b084      	sub	sp, #16
 8000a60:	af00      	add	r7, sp, #0
 8000a62:	4603      	mov	r3, r0
 8000a64:	460a      	mov	r2, r1
 8000a66:	71fb      	strb	r3, [r7, #7]
 8000a68:	4613      	mov	r3, r2
 8000a6a:	71bb      	strb	r3, [r7, #6]

  while (!press_count)
 8000a6c:	bf00      	nop
 8000a6e:	4b36      	ldr	r3, [pc, #216]	@ (8000b48 <switch_press+0xec>)
 8000a70:	681b      	ldr	r3, [r3, #0]
 8000a72:	2b00      	cmp	r3, #0
 8000a74:	d0fb      	beq.n	8000a6e <switch_press+0x12>
    ;
  delay_count = 1000000;
 8000a76:	4b35      	ldr	r3, [pc, #212]	@ (8000b4c <switch_press+0xf0>)
 8000a78:	4a35      	ldr	r2, [pc, #212]	@ (8000b50 <switch_press+0xf4>)
 8000a7a:	601a      	str	r2, [r3, #0]
  while (delay_count--)
 8000a7c:	bf00      	nop
 8000a7e:	4b33      	ldr	r3, [pc, #204]	@ (8000b4c <switch_press+0xf0>)
 8000a80:	681b      	ldr	r3, [r3, #0]
 8000a82:	1e5a      	subs	r2, r3, #1
 8000a84:	4931      	ldr	r1, [pc, #196]	@ (8000b4c <switch_press+0xf0>)
 8000a86:	600a      	str	r2, [r1, #0]
 8000a88:	2b00      	cmp	r3, #0
 8000a8a:	d1f8      	bne.n	8000a7e <switch_press+0x22>
    ;
  if (press_count >= 3) {
 8000a8c:	4b2e      	ldr	r3, [pc, #184]	@ (8000b48 <switch_press+0xec>)
 8000a8e:	681b      	ldr	r3, [r3, #0]
 8000a90:	2b02      	cmp	r3, #2
 8000a92:	d933      	bls.n	8000afc <switch_press+0xa0>
    erase_flash (UPDATE_ADDR);
 8000a94:	482f      	ldr	r0, [pc, #188]	@ (8000b54 <switch_press+0xf8>)
 8000a96:	f000 fbed 	bl	8001274 <erase_flash>
    firmware_update_mode = true;
 8000a9a:	4b2f      	ldr	r3, [pc, #188]	@ (8000b58 <switch_press+0xfc>)
 8000a9c:	2201      	movs	r2, #1
 8000a9e:	701a      	strb	r2, [r3, #0]
    bool status = handle_update();
 8000aa0:	f7ff ff01 	bl	80008a6 <handle_update>
 8000aa4:	4603      	mov	r3, r0
 8000aa6:	73fb      	strb	r3, [r7, #15]

    if (!status && recursion_depth < MAX_RECURSION_DEPTH) {
 8000aa8:	7bfb      	ldrb	r3, [r7, #15]
 8000aaa:	f083 0301 	eor.w	r3, r3, #1
 8000aae:	b2db      	uxtb	r3, r3
 8000ab0:	2b00      	cmp	r3, #0
 8000ab2:	d044      	beq.n	8000b3e <switch_press+0xe2>
 8000ab4:	4b29      	ldr	r3, [pc, #164]	@ (8000b5c <switch_press+0x100>)
 8000ab6:	781b      	ldrb	r3, [r3, #0]
 8000ab8:	2b01      	cmp	r3, #1
 8000aba:	d840      	bhi.n	8000b3e <switch_press+0xe2>
      printf ("error in update !!! retry\n\r", 0x0);
 8000abc:	2100      	movs	r1, #0
 8000abe:	4828      	ldr	r0, [pc, #160]	@ (8000b60 <switch_press+0x104>)
 8000ac0:	f000 f988 	bl	8000dd4 <printf>
      recursion_depth ++;
 8000ac4:	4b25      	ldr	r3, [pc, #148]	@ (8000b5c <switch_press+0x100>)
 8000ac6:	781b      	ldrb	r3, [r3, #0]
 8000ac8:	3301      	adds	r3, #1
 8000aca:	b2da      	uxtb	r2, r3
 8000acc:	4b23      	ldr	r3, [pc, #140]	@ (8000b5c <switch_press+0x100>)
 8000ace:	701a      	strb	r2, [r3, #0]
      press_count = 0;
 8000ad0:	4b1d      	ldr	r3, [pc, #116]	@ (8000b48 <switch_press+0xec>)
 8000ad2:	2200      	movs	r2, #0
 8000ad4:	601a      	str	r2, [r3, #0]
      
      firmware_update_mode = false;
 8000ad6:	4b20      	ldr	r3, [pc, #128]	@ (8000b58 <switch_press+0xfc>)
 8000ad8:	2200      	movs	r2, #0
 8000ada:	701a      	strb	r2, [r3, #0]
      flag_size_recieved = false;
 8000adc:	4b21      	ldr	r3, [pc, #132]	@ (8000b64 <switch_press+0x108>)
 8000ade:	2200      	movs	r2, #0
 8000ae0:	701a      	strb	r2, [r3, #0]
      flag_wrong_size = false;
 8000ae2:	4b21      	ldr	r3, [pc, #132]	@ (8000b68 <switch_press+0x10c>)
 8000ae4:	2200      	movs	r2, #0
 8000ae6:	701a      	strb	r2, [r3, #0]
      flag_too_big_update = false;
 8000ae8:	4b20      	ldr	r3, [pc, #128]	@ (8000b6c <switch_press+0x110>)
 8000aea:	2200      	movs	r2, #0
 8000aec:	701a      	strb	r2, [r3, #0]

      switch_press (f1_valid, f2_valid);
 8000aee:	79ba      	ldrb	r2, [r7, #6]
 8000af0:	79fb      	ldrb	r3, [r7, #7]
 8000af2:	4611      	mov	r1, r2
 8000af4:	4618      	mov	r0, r3
 8000af6:	f7ff ffb1 	bl	8000a5c <switch_press>
 8000afa:	e020      	b.n	8000b3e <switch_press+0xe2>
    }
  } else if (press_count == 2) {
 8000afc:	4b12      	ldr	r3, [pc, #72]	@ (8000b48 <switch_press+0xec>)
 8000afe:	681b      	ldr	r3, [r3, #0]
 8000b00:	2b02      	cmp	r3, #2
 8000b02:	d10e      	bne.n	8000b22 <switch_press+0xc6>
    if (f2_valid) {
 8000b04:	79bb      	ldrb	r3, [r7, #6]
 8000b06:	2b00      	cmp	r3, #0
 8000b08:	d005      	beq.n	8000b16 <switch_press+0xba>
      boot_f1 = false;
 8000b0a:	4b19      	ldr	r3, [pc, #100]	@ (8000b70 <switch_press+0x114>)
 8000b0c:	2200      	movs	r2, #0
 8000b0e:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000b10:	f7ff fdc4 	bl	800069c <jump_to_firmware>
 8000b14:	e013      	b.n	8000b3e <switch_press+0xe2>
    } else {
      boot_f1 = true;
 8000b16:	4b16      	ldr	r3, [pc, #88]	@ (8000b70 <switch_press+0x114>)
 8000b18:	2201      	movs	r2, #1
 8000b1a:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000b1c:	f7ff fdbe 	bl	800069c <jump_to_firmware>
 8000b20:	e00d      	b.n	8000b3e <switch_press+0xe2>
    }
  } else {
    if (f1_valid) {
 8000b22:	79fb      	ldrb	r3, [r7, #7]
 8000b24:	2b00      	cmp	r3, #0
 8000b26:	d005      	beq.n	8000b34 <switch_press+0xd8>
      boot_f1 = true;
 8000b28:	4b11      	ldr	r3, [pc, #68]	@ (8000b70 <switch_press+0x114>)
 8000b2a:	2201      	movs	r2, #1
 8000b2c:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000b2e:	f7ff fdb5 	bl	800069c <jump_to_firmware>
 8000b32:	e004      	b.n	8000b3e <switch_press+0xe2>
    } else {
      boot_f1 = false;
 8000b34:	4b0e      	ldr	r3, [pc, #56]	@ (8000b70 <switch_press+0x114>)
 8000b36:	2200      	movs	r2, #0
 8000b38:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 8000b3a:	f7ff fdaf 	bl	800069c <jump_to_firmware>
    }
  }
  return true;
 8000b3e:	2301      	movs	r3, #1
}
 8000b40:	4618      	mov	r0, r3
 8000b42:	3710      	adds	r7, #16
 8000b44:	46bd      	mov	sp, r7
 8000b46:	bd80      	pop	{r7, pc}
 8000b48:	20000060 	.word	0x20000060
 8000b4c:	20000064 	.word	0x20000064
 8000b50:	000f4240 	.word	0x000f4240
 8000b54:	08040000 	.word	0x08040000
 8000b58:	20005076 	.word	0x20005076
 8000b5c:	20005077 	.word	0x20005077
 8000b60:	08001a1c 	.word	0x08001a1c
 8000b64:	20005079 	.word	0x20005079
 8000b68:	2000507a 	.word	0x2000507a
 8000b6c:	2000507b 	.word	0x2000507b
 8000b70:	20000000 	.word	0x20000000

08000b74 <main>:


int main() {
 8000b74:	b580      	push	{r7, lr}
 8000b76:	b082      	sub	sp, #8
 8000b78:	af00      	add	r7, sp, #0

    Ring_buff_init(&ringbuffer);
 8000b7a:	4853      	ldr	r0, [pc, #332]	@ (8000cc8 <main+0x154>)
 8000b7c:	f7ff fbf0 	bl	8000360 <Ring_buff_init>

    // enable faults (without this any fault = hardfault)
    SCB->SHCSR |= SCB_SHCSR_BUSFAULTENA_Msk;
 8000b80:	4b52      	ldr	r3, [pc, #328]	@ (8000ccc <main+0x158>)
 8000b82:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000b84:	4a51      	ldr	r2, [pc, #324]	@ (8000ccc <main+0x158>)
 8000b86:	f443 3300 	orr.w	r3, r3, #131072	@ 0x20000
 8000b8a:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_USGFAULTENA_Msk;
 8000b8c:	4b4f      	ldr	r3, [pc, #316]	@ (8000ccc <main+0x158>)
 8000b8e:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000b90:	4a4e      	ldr	r2, [pc, #312]	@ (8000ccc <main+0x158>)
 8000b92:	f443 2380 	orr.w	r3, r3, #262144	@ 0x40000
 8000b96:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
 8000b98:	4b4c      	ldr	r3, [pc, #304]	@ (8000ccc <main+0x158>)
 8000b9a:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000b9c:	4a4b      	ldr	r2, [pc, #300]	@ (8000ccc <main+0x158>)
 8000b9e:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 8000ba2:	6253      	str	r3, [r2, #36]	@ 0x24


  __usart1_init();
 8000ba4:	f000 fad6 	bl	8001154 <__usart1_init>

  printf("\n\n\nbooting....\n\n\n\r", 0x0);
 8000ba8:	2100      	movs	r1, #0
 8000baa:	4849      	ldr	r0, [pc, #292]	@ (8000cd0 <main+0x15c>)
 8000bac:	f000 f912 	bl	8000dd4 <printf>

  // check if fimrware is corrupted during update

  if (*(uint32_t *)FIRMWARE_1_ADDRESS & 1) {
 8000bb0:	4b48      	ldr	r3, [pc, #288]	@ (8000cd4 <main+0x160>)
 8000bb2:	681b      	ldr	r3, [r3, #0]
 8000bb4:	f003 0301 	and.w	r3, r3, #1
 8000bb8:	2b00      	cmp	r3, #0
 8000bba:	d001      	beq.n	8000bc0 <main+0x4c>
    rollback();
 8000bbc:	f000 fa3e 	bl	800103c <rollback>
  }
  if (*(uint32_t *)FIRMWARE_2_ADDRESS & 1) {
 8000bc0:	4b45      	ldr	r3, [pc, #276]	@ (8000cd8 <main+0x164>)
 8000bc2:	681b      	ldr	r3, [r3, #0]
 8000bc4:	f003 0301 	and.w	r3, r3, #1
 8000bc8:	2b00      	cmp	r3, #0
 8000bca:	d001      	beq.n	8000bd0 <main+0x5c>
    rollback();
 8000bcc:	f000 fa36 	bl	800103c <rollback>
  }

  bool f1_valid = true;
 8000bd0:	2301      	movs	r3, #1
 8000bd2:	71fb      	strb	r3, [r7, #7]
  bool f2_valid = true;
 8000bd4:	2301      	movs	r3, #1
 8000bd6:	71bb      	strb	r3, [r7, #6]
  init_firmware_t(FIRMWARE_1_ADDRESS, &f1);
 8000bd8:	4940      	ldr	r1, [pc, #256]	@ (8000cdc <main+0x168>)
 8000bda:	483e      	ldr	r0, [pc, #248]	@ (8000cd4 <main+0x160>)
 8000bdc:	f7ff fde6 	bl	80007ac <init_firmware_t>
  init_firmware_t(FIRMWARE_2_ADDRESS, &f2);
 8000be0:	493f      	ldr	r1, [pc, #252]	@ (8000ce0 <main+0x16c>)
 8000be2:	483d      	ldr	r0, [pc, #244]	@ (8000cd8 <main+0x164>)
 8000be4:	f7ff fde2 	bl	80007ac <init_firmware_t>

  // printf("hii there %\n\r", f1.__vtable_address);

  printf("*************validating firmware1*************\n\r", 0x0);
 8000be8:	2100      	movs	r1, #0
 8000bea:	483e      	ldr	r0, [pc, #248]	@ (8000ce4 <main+0x170>)
 8000bec:	f000 f8f2 	bl	8000dd4 <printf>
  f1_valid = validate_firmware(&f1, FIRMWARE_1_ADDRESS);
 8000bf0:	4938      	ldr	r1, [pc, #224]	@ (8000cd4 <main+0x160>)
 8000bf2:	483a      	ldr	r0, [pc, #232]	@ (8000cdc <main+0x168>)
 8000bf4:	f7ff fcf8 	bl	80005e8 <validate_firmware>
 8000bf8:	4603      	mov	r3, r0
 8000bfa:	71fb      	strb	r3, [r7, #7]
  printf("*************validating firmware2*************\n\r", 0x0);
 8000bfc:	2100      	movs	r1, #0
 8000bfe:	483a      	ldr	r0, [pc, #232]	@ (8000ce8 <main+0x174>)
 8000c00:	f000 f8e8 	bl	8000dd4 <printf>
  f2_valid = validate_firmware(&f2, FIRMWARE_2_ADDRESS);
 8000c04:	4934      	ldr	r1, [pc, #208]	@ (8000cd8 <main+0x164>)
 8000c06:	4836      	ldr	r0, [pc, #216]	@ (8000ce0 <main+0x16c>)
 8000c08:	f7ff fcee 	bl	80005e8 <validate_firmware>
 8000c0c:	4603      	mov	r3, r0
 8000c0e:	71bb      	strb	r3, [r7, #6]

  printf("both the firmwares are checked\n\r", 0x0);
 8000c10:	2100      	movs	r1, #0
 8000c12:	4836      	ldr	r0, [pc, #216]	@ (8000cec <main+0x178>)
 8000c14:	f000 f8de 	bl	8000dd4 <printf>
  // init GPIOC (for on board switch)
  // init SYSCGF (for using EXTI)

  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN_Msk;
 8000c18:	4b35      	ldr	r3, [pc, #212]	@ (8000cf0 <main+0x17c>)
 8000c1a:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8000c1c:	4a34      	ldr	r2, [pc, #208]	@ (8000cf0 <main+0x17c>)
 8000c1e:	f443 4380 	orr.w	r3, r3, #16384	@ 0x4000
 8000c22:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN_Msk;
 8000c24:	4b32      	ldr	r3, [pc, #200]	@ (8000cf0 <main+0x17c>)
 8000c26:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8000c28:	4a31      	ldr	r2, [pc, #196]	@ (8000cf0 <main+0x17c>)
 8000c2a:	f043 0304 	orr.w	r3, r3, #4
 8000c2e:	6313      	str	r3, [r2, #48]	@ 0x30

  // set switch to input
  GPIOC->MODER &= ~(3U << (2 * SWITCH_PIN));
 8000c30:	4b30      	ldr	r3, [pc, #192]	@ (8000cf4 <main+0x180>)
 8000c32:	681b      	ldr	r3, [r3, #0]
 8000c34:	4a2f      	ldr	r2, [pc, #188]	@ (8000cf4 <main+0x180>)
 8000c36:	f023 6340 	bic.w	r3, r3, #201326592	@ 0xc000000
 8000c3a:	6013      	str	r3, [r2, #0]

  // falling edge detect
  EXTI->FTSR |= EXTI_FTSR_TR13_Msk;
 8000c3c:	4b2e      	ldr	r3, [pc, #184]	@ (8000cf8 <main+0x184>)
 8000c3e:	68db      	ldr	r3, [r3, #12]
 8000c40:	4a2d      	ldr	r2, [pc, #180]	@ (8000cf8 <main+0x184>)
 8000c42:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8000c46:	60d3      	str	r3, [r2, #12]

  SYSCFG->EXTICR[3] &= ~(SYSCFG_EXTICR4_EXTI13_Msk);
 8000c48:	4b2c      	ldr	r3, [pc, #176]	@ (8000cfc <main+0x188>)
 8000c4a:	695b      	ldr	r3, [r3, #20]
 8000c4c:	4a2b      	ldr	r2, [pc, #172]	@ (8000cfc <main+0x188>)
 8000c4e:	f023 03f0 	bic.w	r3, r3, #240	@ 0xf0
 8000c52:	6153      	str	r3, [r2, #20]
  SYSCFG->EXTICR[3] |= SYSCFG_EXTICR4_EXTI13_PC;
 8000c54:	4b29      	ldr	r3, [pc, #164]	@ (8000cfc <main+0x188>)
 8000c56:	695b      	ldr	r3, [r3, #20]
 8000c58:	4a28      	ldr	r2, [pc, #160]	@ (8000cfc <main+0x188>)
 8000c5a:	f043 0320 	orr.w	r3, r3, #32
 8000c5e:	6153      	str	r3, [r2, #20]

  // enable mask at the end
  EXTI->IMR |= EXTI_IMR_MR13_Msk;
 8000c60:	4b25      	ldr	r3, [pc, #148]	@ (8000cf8 <main+0x184>)
 8000c62:	681b      	ldr	r3, [r3, #0]
 8000c64:	4a24      	ldr	r2, [pc, #144]	@ (8000cf8 <main+0x184>)
 8000c66:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8000c6a:	6013      	str	r3, [r2, #0]

  NVIC_EnableIRQ(EXTI15_10_IRQn);
 8000c6c:	2028      	movs	r0, #40	@ 0x28
 8000c6e:	f7ff fd81 	bl	8000774 <__NVIC_EnableIRQ>

  if (!f1_valid && !f2_valid) {
 8000c72:	79fb      	ldrb	r3, [r7, #7]
 8000c74:	f083 0301 	eor.w	r3, r3, #1
 8000c78:	b2db      	uxtb	r3, r3
 8000c7a:	2b00      	cmp	r3, #0
 8000c7c:	d011      	beq.n	8000ca2 <main+0x12e>
 8000c7e:	79bb      	ldrb	r3, [r7, #6]
 8000c80:	f083 0301 	eor.w	r3, r3, #1
 8000c84:	b2db      	uxtb	r3, r3
 8000c86:	2b00      	cmp	r3, #0
 8000c88:	d00b      	beq.n	8000ca2 <main+0x12e>
    printf("both the firmwares are not valid\n\n\r", 0x0);
 8000c8a:	2100      	movs	r1, #0
 8000c8c:	481c      	ldr	r0, [pc, #112]	@ (8000d00 <main+0x18c>)
 8000c8e:	f000 f8a1 	bl	8000dd4 <printf>
    EXTI->IMR &= EXTI_IMR_MR13_Msk;
 8000c92:	4b19      	ldr	r3, [pc, #100]	@ (8000cf8 <main+0x184>)
 8000c94:	681b      	ldr	r3, [r3, #0]
 8000c96:	4a18      	ldr	r2, [pc, #96]	@ (8000cf8 <main+0x184>)
 8000c98:	f403 5300 	and.w	r3, r3, #8192	@ 0x2000
 8000c9c:	6013      	str	r3, [r2, #0]
    handle_update();
 8000c9e:	f7ff fe02 	bl	80008a6 <handle_update>
  }

  // /* illegal memory access */
  // *(uint32_t *) (0xffffffff) = 0;
  
  bool status = switch_press (f1_valid, f2_valid);
 8000ca2:	79ba      	ldrb	r2, [r7, #6]
 8000ca4:	79fb      	ldrb	r3, [r7, #7]
 8000ca6:	4611      	mov	r1, r2
 8000ca8:	4618      	mov	r0, r3
 8000caa:	f7ff fed7 	bl	8000a5c <switch_press>
 8000cae:	4603      	mov	r3, r0
 8000cb0:	717b      	strb	r3, [r7, #5]
  if (!status){
 8000cb2:	797b      	ldrb	r3, [r7, #5]
 8000cb4:	f083 0301 	eor.w	r3, r3, #1
 8000cb8:	b2db      	uxtb	r3, r3
 8000cba:	2b00      	cmp	r3, #0
 8000cbc:	d003      	beq.n	8000cc6 <main+0x152>
    printf ("too many wrong firmware update attempt !!!\n\r", 0x0);
 8000cbe:	2100      	movs	r1, #0
 8000cc0:	4810      	ldr	r0, [pc, #64]	@ (8000d04 <main+0x190>)
 8000cc2:	f000 f887 	bl	8000dd4 <printf>
  }
  while (1);
 8000cc6:	e7fe      	b.n	8000cc6 <main+0x152>
 8000cc8:	20000070 	.word	0x20000070
 8000ccc:	e000ed00 	.word	0xe000ed00
 8000cd0:	08001a38 	.word	0x08001a38
 8000cd4:	08004000 	.word	0x08004000
 8000cd8:	08020000 	.word	0x08020000
 8000cdc:	20000008 	.word	0x20000008
 8000ce0:	20000034 	.word	0x20000034
 8000ce4:	08001a4c 	.word	0x08001a4c
 8000ce8:	08001a80 	.word	0x08001a80
 8000cec:	08001ab4 	.word	0x08001ab4
 8000cf0:	40023800 	.word	0x40023800
 8000cf4:	40020800 	.word	0x40020800
 8000cf8:	40013c00 	.word	0x40013c00
 8000cfc:	40013800 	.word	0x40013800
 8000d00:	08001ad8 	.word	0x08001ad8
 8000d04:	08001afc 	.word	0x08001afc

08000d08 <strlen>:
static uint32_t update_section_end_address = UPDATE_ADDR;
extern volatile Ring_buff_t ringbuffer;
extern uint8_t write_buffer[WRITE_BUFF_SIZE];
volatile uint32_t fw_ar_ind = 0;

uint32_t strlen(const char *msg) {
 8000d08:	b480      	push	{r7}
 8000d0a:	b085      	sub	sp, #20
 8000d0c:	af00      	add	r7, sp, #0
 8000d0e:	6078      	str	r0, [r7, #4]

  int i = 0;
 8000d10:	2300      	movs	r3, #0
 8000d12:	60fb      	str	r3, [r7, #12]
  while (msg[i++] != '\0')
 8000d14:	bf00      	nop
 8000d16:	68fb      	ldr	r3, [r7, #12]
 8000d18:	1c5a      	adds	r2, r3, #1
 8000d1a:	60fa      	str	r2, [r7, #12]
 8000d1c:	461a      	mov	r2, r3
 8000d1e:	687b      	ldr	r3, [r7, #4]
 8000d20:	4413      	add	r3, r2
 8000d22:	781b      	ldrb	r3, [r3, #0]
 8000d24:	2b00      	cmp	r3, #0
 8000d26:	d1f6      	bne.n	8000d16 <strlen+0xe>
    ;
  return i - 1;
 8000d28:	68fb      	ldr	r3, [r7, #12]
 8000d2a:	3b01      	subs	r3, #1
}
 8000d2c:	4618      	mov	r0, r3
 8000d2e:	3714      	adds	r7, #20
 8000d30:	46bd      	mov	sp, r7
 8000d32:	bc80      	pop	{r7}
 8000d34:	4770      	bx	lr

08000d36 <delay>:

void delay(uint32_t count) {
 8000d36:	b480      	push	{r7}
 8000d38:	b083      	sub	sp, #12
 8000d3a:	af00      	add	r7, sp, #0
 8000d3c:	6078      	str	r0, [r7, #4]

  while (count--)
 8000d3e:	bf00      	nop
 8000d40:	687b      	ldr	r3, [r7, #4]
 8000d42:	1e5a      	subs	r2, r3, #1
 8000d44:	607a      	str	r2, [r7, #4]
 8000d46:	2b00      	cmp	r3, #0
 8000d48:	d1fa      	bne.n	8000d40 <delay+0xa>
    ;
}
 8000d4a:	bf00      	nop
 8000d4c:	bf00      	nop
 8000d4e:	370c      	adds	r7, #12
 8000d50:	46bd      	mov	sp, r7
 8000d52:	bc80      	pop	{r7}
 8000d54:	4770      	bx	lr

08000d56 <hex_str>:
char *hex_str(uint32_t value, char *out) {
 8000d56:	b4b0      	push	{r4, r5, r7}
 8000d58:	b08b      	sub	sp, #44	@ 0x2c
 8000d5a:	af00      	add	r7, sp, #0
 8000d5c:	6078      	str	r0, [r7, #4]
 8000d5e:	6039      	str	r1, [r7, #0]

  char hex_char[] = "0123456789abcdef";
 8000d60:	4b1b      	ldr	r3, [pc, #108]	@ (8000dd0 <hex_str+0x7a>)
 8000d62:	f107 0408 	add.w	r4, r7, #8
 8000d66:	461d      	mov	r5, r3
 8000d68:	cd0f      	ldmia	r5!, {r0, r1, r2, r3}
 8000d6a:	c40f      	stmia	r4!, {r0, r1, r2, r3}
 8000d6c:	682b      	ldr	r3, [r5, #0]
 8000d6e:	7023      	strb	r3, [r4, #0]
  out[0] = '0';
 8000d70:	683b      	ldr	r3, [r7, #0]
 8000d72:	2230      	movs	r2, #48	@ 0x30
 8000d74:	701a      	strb	r2, [r3, #0]
  out[1] = 'x';
 8000d76:	683b      	ldr	r3, [r7, #0]
 8000d78:	3301      	adds	r3, #1
 8000d7a:	2278      	movs	r2, #120	@ 0x78
 8000d7c:	701a      	strb	r2, [r3, #0]

  for (int i = 0; i < 8; i++) {
 8000d7e:	2300      	movs	r3, #0
 8000d80:	627b      	str	r3, [r7, #36]	@ 0x24
 8000d82:	e01c      	b.n	8000dbe <hex_str+0x68>
    uint32_t ind = (value & (15 << (i * 4))) >> (i * 4);
 8000d84:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000d86:	009b      	lsls	r3, r3, #2
 8000d88:	220f      	movs	r2, #15
 8000d8a:	fa02 f303 	lsl.w	r3, r2, r3
 8000d8e:	461a      	mov	r2, r3
 8000d90:	687b      	ldr	r3, [r7, #4]
 8000d92:	401a      	ands	r2, r3
 8000d94:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000d96:	009b      	lsls	r3, r3, #2
 8000d98:	fa22 f303 	lsr.w	r3, r2, r3
 8000d9c:	623b      	str	r3, [r7, #32]
    int j = 9 - i;
 8000d9e:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000da0:	f1c3 0309 	rsb	r3, r3, #9
 8000da4:	61fb      	str	r3, [r7, #28]
    out[j] = hex_char[ind];
 8000da6:	69fb      	ldr	r3, [r7, #28]
 8000da8:	683a      	ldr	r2, [r7, #0]
 8000daa:	4413      	add	r3, r2
 8000dac:	f107 0108 	add.w	r1, r7, #8
 8000db0:	6a3a      	ldr	r2, [r7, #32]
 8000db2:	440a      	add	r2, r1
 8000db4:	7812      	ldrb	r2, [r2, #0]
 8000db6:	701a      	strb	r2, [r3, #0]
  for (int i = 0; i < 8; i++) {
 8000db8:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000dba:	3301      	adds	r3, #1
 8000dbc:	627b      	str	r3, [r7, #36]	@ 0x24
 8000dbe:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8000dc0:	2b07      	cmp	r3, #7
 8000dc2:	dddf      	ble.n	8000d84 <hex_str+0x2e>
  }
}
 8000dc4:	bf00      	nop
 8000dc6:	4618      	mov	r0, r3
 8000dc8:	372c      	adds	r7, #44	@ 0x2c
 8000dca:	46bd      	mov	sp, r7
 8000dcc:	bcb0      	pop	{r4, r5, r7}
 8000dce:	4770      	bx	lr
 8000dd0:	08001b2c 	.word	0x08001b2c

08000dd4 <printf>:

void printf(const char *msg, uint32_t address) {
 8000dd4:	b580      	push	{r7, lr}
 8000dd6:	b0a4      	sub	sp, #144	@ 0x90
 8000dd8:	af00      	add	r7, sp, #0
 8000dda:	6078      	str	r0, [r7, #4]
 8000ddc:	6039      	str	r1, [r7, #0]

  uint32_t value = *((uint32_t *)address);
 8000dde:	683b      	ldr	r3, [r7, #0]
 8000de0:	681b      	ldr	r3, [r3, #0]
 8000de2:	67fb      	str	r3, [r7, #124]	@ 0x7c

  if (strlen(msg) + 9 > MAX_STR_SIZE) {
 8000de4:	6878      	ldr	r0, [r7, #4]
 8000de6:	f7ff ff8f 	bl	8000d08 <strlen>
 8000dea:	4603      	mov	r3, r0
 8000dec:	3309      	adds	r3, #9
 8000dee:	2b64      	cmp	r3, #100	@ 0x64
 8000df0:	d904      	bls.n	8000dfc <printf+0x28>
    __usart1_print("too large error message !!\n\r", MAX_STR_SIZE);
 8000df2:	2164      	movs	r1, #100	@ 0x64
 8000df4:	483e      	ldr	r0, [pc, #248]	@ (8000ef0 <printf+0x11c>)
 8000df6:	f000 f9f7 	bl	80011e8 <__usart1_print>
 8000dfa:	e076      	b.n	8000eea <printf+0x116>
    return;
  }
  char hex[10];
  char __msg[MAX_STR_SIZE];

  uint32_t i = 0;
 8000dfc:	2300      	movs	r3, #0
 8000dfe:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
  int p = 0, q = 0;
 8000e02:	2300      	movs	r3, #0
 8000e04:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
 8000e08:	2300      	movs	r3, #0
 8000e0a:	f8c7 3084 	str.w	r3, [r7, #132]	@ 0x84
  bool single_sub = false;
 8000e0e:	2300      	movs	r3, #0
 8000e10:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83

  uint32_t msg_size = strlen(msg);
 8000e14:	6878      	ldr	r0, [r7, #4]
 8000e16:	f7ff ff77 	bl	8000d08 <strlen>
 8000e1a:	67b8      	str	r0, [r7, #120]	@ 0x78
  for (; i < msg_size; i++) {
 8000e1c:	e04d      	b.n	8000eba <printf+0xe6>

    if (msg[i] == '%' && !single_sub) {
 8000e1e:	687a      	ldr	r2, [r7, #4]
 8000e20:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 8000e24:	4413      	add	r3, r2
 8000e26:	781b      	ldrb	r3, [r3, #0]
 8000e28:	2b25      	cmp	r3, #37	@ 0x25
 8000e2a:	d12f      	bne.n	8000e8c <printf+0xb8>
 8000e2c:	f897 3083 	ldrb.w	r3, [r7, #131]	@ 0x83
 8000e30:	f083 0301 	eor.w	r3, r3, #1
 8000e34:	b2db      	uxtb	r3, r3
 8000e36:	2b00      	cmp	r3, #0
 8000e38:	d028      	beq.n	8000e8c <printf+0xb8>
      hex_str(value, hex);
 8000e3a:	f107 036c 	add.w	r3, r7, #108	@ 0x6c
 8000e3e:	4619      	mov	r1, r3
 8000e40:	6ff8      	ldr	r0, [r7, #124]	@ 0x7c
 8000e42:	f7ff ff88 	bl	8000d56 <hex_str>

      while (q - p < 10) {
 8000e46:	e011      	b.n	8000e6c <printf+0x98>
        __msg[q++] = hex[q - p];
 8000e48:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 8000e4c:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000e50:	1ad2      	subs	r2, r2, r3
 8000e52:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000e56:	1c59      	adds	r1, r3, #1
 8000e58:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 8000e5c:	3290      	adds	r2, #144	@ 0x90
 8000e5e:	443a      	add	r2, r7
 8000e60:	f812 2c24 	ldrb.w	r2, [r2, #-36]
 8000e64:	3390      	adds	r3, #144	@ 0x90
 8000e66:	443b      	add	r3, r7
 8000e68:	f803 2c88 	strb.w	r2, [r3, #-136]
      while (q - p < 10) {
 8000e6c:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 8000e70:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000e74:	1ad3      	subs	r3, r2, r3
 8000e76:	2b09      	cmp	r3, #9
 8000e78:	dde6      	ble.n	8000e48 <printf+0x74>
      }
      p++;
 8000e7a:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000e7e:	3301      	adds	r3, #1
 8000e80:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
      single_sub = true;
 8000e84:	2301      	movs	r3, #1
 8000e86:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83
 8000e8a:	e011      	b.n	8000eb0 <printf+0xdc>
    } else
      __msg[q++] = msg[p++];
 8000e8c:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000e90:	1c5a      	adds	r2, r3, #1
 8000e92:	f8c7 2088 	str.w	r2, [r7, #136]	@ 0x88
 8000e96:	461a      	mov	r2, r3
 8000e98:	687b      	ldr	r3, [r7, #4]
 8000e9a:	441a      	add	r2, r3
 8000e9c:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000ea0:	1c59      	adds	r1, r3, #1
 8000ea2:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 8000ea6:	7812      	ldrb	r2, [r2, #0]
 8000ea8:	3390      	adds	r3, #144	@ 0x90
 8000eaa:	443b      	add	r3, r7
 8000eac:	f803 2c88 	strb.w	r2, [r3, #-136]
  for (; i < msg_size; i++) {
 8000eb0:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 8000eb4:	3301      	adds	r3, #1
 8000eb6:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
 8000eba:	f8d7 208c 	ldr.w	r2, [r7, #140]	@ 0x8c
 8000ebe:	6fbb      	ldr	r3, [r7, #120]	@ 0x78
 8000ec0:	429a      	cmp	r2, r3
 8000ec2:	d3ac      	bcc.n	8000e1e <printf+0x4a>
  }
  __msg[q] = '\0';
 8000ec4:	f107 0208 	add.w	r2, r7, #8
 8000ec8:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 8000ecc:	4413      	add	r3, r2
 8000ece:	2200      	movs	r2, #0
 8000ed0:	701a      	strb	r2, [r3, #0]
  __usart1_print(__msg, strlen(__msg));
 8000ed2:	f107 0308 	add.w	r3, r7, #8
 8000ed6:	4618      	mov	r0, r3
 8000ed8:	f7ff ff16 	bl	8000d08 <strlen>
 8000edc:	4602      	mov	r2, r0
 8000ede:	f107 0308 	add.w	r3, r7, #8
 8000ee2:	4611      	mov	r1, r2
 8000ee4:	4618      	mov	r0, r3
 8000ee6:	f000 f97f 	bl	80011e8 <__usart1_print>
}
 8000eea:	3790      	adds	r7, #144	@ 0x90
 8000eec:	46bd      	mov	sp, r7
 8000eee:	bd80      	pop	{r7, pc}
 8000ef0:	08001b40 	.word	0x08001b40

08000ef4 <recieve_update>:

uint32_t recieve_update(void) {
 8000ef4:	b580      	push	{r7, lr}
 8000ef6:	b082      	sub	sp, #8
 8000ef8:	af00      	add	r7, sp, #0

  // recieve update size

  printf("enter the size of the update....\n\r", 0x0);
 8000efa:	2100      	movs	r1, #0
 8000efc:	4841      	ldr	r0, [pc, #260]	@ (8001004 <recieve_update+0x110>)
 8000efe:	f7ff ff69 	bl	8000dd4 <printf>
  update_size = 0;
 8000f02:	4b41      	ldr	r3, [pc, #260]	@ (8001008 <recieve_update+0x114>)
 8000f04:	2200      	movs	r2, #0
 8000f06:	601a      	str	r2, [r3, #0]
  recieve_size = true;
 8000f08:	4b40      	ldr	r3, [pc, #256]	@ (800100c <recieve_update+0x118>)
 8000f0a:	2201      	movs	r2, #1
 8000f0c:	701a      	strb	r2, [r3, #0]
  while (1) {
    if (flag_wrong_size) {
 8000f0e:	4b40      	ldr	r3, [pc, #256]	@ (8001010 <recieve_update+0x11c>)
 8000f10:	781b      	ldrb	r3, [r3, #0]
 8000f12:	b2db      	uxtb	r3, r3
 8000f14:	2b00      	cmp	r3, #0
 8000f16:	d006      	beq.n	8000f26 <recieve_update+0x32>
      printf("wrong size entered !!!\n\r", 0x0);
 8000f18:	2100      	movs	r1, #0
 8000f1a:	483e      	ldr	r0, [pc, #248]	@ (8001014 <recieve_update+0x120>)
 8000f1c:	f7ff ff5a 	bl	8000dd4 <printf>
      return -1;
 8000f20:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 8000f24:	e069      	b.n	8000ffa <recieve_update+0x106>
    }
    if (flag_too_big_update) {
 8000f26:	4b3c      	ldr	r3, [pc, #240]	@ (8001018 <recieve_update+0x124>)
 8000f28:	781b      	ldrb	r3, [r3, #0]
 8000f2a:	b2db      	uxtb	r3, r3
 8000f2c:	2b00      	cmp	r3, #0
 8000f2e:	d006      	beq.n	8000f3e <recieve_update+0x4a>
      printf("update size cannot exceed 128KB \n\r", 0x0);
 8000f30:	2100      	movs	r1, #0
 8000f32:	483a      	ldr	r0, [pc, #232]	@ (800101c <recieve_update+0x128>)
 8000f34:	f7ff ff4e 	bl	8000dd4 <printf>
      return -1;
 8000f38:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 8000f3c:	e05d      	b.n	8000ffa <recieve_update+0x106>
    }
    if (flag_size_recieved) {
 8000f3e:	4b38      	ldr	r3, [pc, #224]	@ (8001020 <recieve_update+0x12c>)
 8000f40:	781b      	ldrb	r3, [r3, #0]
 8000f42:	b2db      	uxtb	r3, r3
 8000f44:	2b00      	cmp	r3, #0
 8000f46:	d0e2      	beq.n	8000f0e <recieve_update+0x1a>
      printf("update size recieved \n\r", 0x0);
 8000f48:	2100      	movs	r1, #0
 8000f4a:	4836      	ldr	r0, [pc, #216]	@ (8001024 <recieve_update+0x130>)
 8000f4c:	f7ff ff42 	bl	8000dd4 <printf>
      break;
 8000f50:	bf00      	nop
    }
  }
  recieve_size = false;
 8000f52:	4b2e      	ldr	r3, [pc, #184]	@ (800100c <recieve_update+0x118>)
 8000f54:	2200      	movs	r2, #0
 8000f56:	701a      	strb	r2, [r3, #0]

  update_section_end_address = UPDATE_ADDR;
 8000f58:	4b33      	ldr	r3, [pc, #204]	@ (8001028 <recieve_update+0x134>)
 8000f5a:	4a34      	ldr	r2, [pc, #208]	@ (800102c <recieve_update+0x138>)
 8000f5c:	601a      	str	r2, [r3, #0]

  // recieve firmware update !!
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 8000f5e:	e041      	b.n	8000fe4 <recieve_update+0xf0>
    while (Ring_buff_empty(&ringbuffer))
 8000f60:	bf00      	nop
 8000f62:	4833      	ldr	r0, [pc, #204]	@ (8001030 <recieve_update+0x13c>)
 8000f64:	f7ff fa11 	bl	800038a <Ring_buff_empty>
 8000f68:	4603      	mov	r3, r0
 8000f6a:	2b00      	cmp	r3, #0
 8000f6c:	d1f9      	bne.n	8000f62 <recieve_update+0x6e>
      ;
    //
    // problem
    uint16_t read_size = Ring_buff_read(&ringbuffer, write_buffer + wb_size,
 8000f6e:	4b31      	ldr	r3, [pc, #196]	@ (8001034 <recieve_update+0x140>)
 8000f70:	881b      	ldrh	r3, [r3, #0]
 8000f72:	461a      	mov	r2, r3
 8000f74:	4b30      	ldr	r3, [pc, #192]	@ (8001038 <recieve_update+0x144>)
 8000f76:	18d1      	adds	r1, r2, r3
 8000f78:	4b2e      	ldr	r3, [pc, #184]	@ (8001034 <recieve_update+0x140>)
 8000f7a:	881b      	ldrh	r3, [r3, #0]
 8000f7c:	f5c3 5320 	rsb	r3, r3, #10240	@ 0x2800
 8000f80:	b29b      	uxth	r3, r3
 8000f82:	461a      	mov	r2, r3
 8000f84:	482a      	ldr	r0, [pc, #168]	@ (8001030 <recieve_update+0x13c>)
 8000f86:	f7ff fa72 	bl	800046e <Ring_buff_read>
 8000f8a:	4603      	mov	r3, r0
 8000f8c:	80fb      	strh	r3, [r7, #6]
                                        WRITE_BUFF_SIZE - wb_size);
    wb_size += read_size;
 8000f8e:	4b29      	ldr	r3, [pc, #164]	@ (8001034 <recieve_update+0x140>)
 8000f90:	881a      	ldrh	r2, [r3, #0]
 8000f92:	88fb      	ldrh	r3, [r7, #6]
 8000f94:	4413      	add	r3, r2
 8000f96:	b29a      	uxth	r2, r3
 8000f98:	4b26      	ldr	r3, [pc, #152]	@ (8001034 <recieve_update+0x140>)
 8000f9a:	801a      	strh	r2, [r3, #0]

    uint16_t update_in_flash_size = update_section_end_address - UPDATE_ADDR;
 8000f9c:	4b22      	ldr	r3, [pc, #136]	@ (8001028 <recieve_update+0x134>)
 8000f9e:	681b      	ldr	r3, [r3, #0]
 8000fa0:	80bb      	strh	r3, [r7, #4]
    //
    if (wb_size == WRITE_BUFF_SIZE ||
 8000fa2:	4b24      	ldr	r3, [pc, #144]	@ (8001034 <recieve_update+0x140>)
 8000fa4:	881b      	ldrh	r3, [r3, #0]
 8000fa6:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 8000faa:	d007      	beq.n	8000fbc <recieve_update+0xc8>
        update_size - update_in_flash_size == wb_size) {
 8000fac:	4b16      	ldr	r3, [pc, #88]	@ (8001008 <recieve_update+0x114>)
 8000fae:	681a      	ldr	r2, [r3, #0]
 8000fb0:	88bb      	ldrh	r3, [r7, #4]
 8000fb2:	1ad3      	subs	r3, r2, r3
 8000fb4:	4a1f      	ldr	r2, [pc, #124]	@ (8001034 <recieve_update+0x140>)
 8000fb6:	8812      	ldrh	r2, [r2, #0]
    if (wb_size == WRITE_BUFF_SIZE ||
 8000fb8:	4293      	cmp	r3, r2
 8000fba:	d113      	bne.n	8000fe4 <recieve_update+0xf0>
      // flash write, update end address, wb flush

      flash_write(update_section_end_address, write_buffer, wb_size, 0);
 8000fbc:	4b1a      	ldr	r3, [pc, #104]	@ (8001028 <recieve_update+0x134>)
 8000fbe:	6818      	ldr	r0, [r3, #0]
 8000fc0:	4b1c      	ldr	r3, [pc, #112]	@ (8001034 <recieve_update+0x140>)
 8000fc2:	881b      	ldrh	r3, [r3, #0]
 8000fc4:	461a      	mov	r2, r3
 8000fc6:	2300      	movs	r3, #0
 8000fc8:	491b      	ldr	r1, [pc, #108]	@ (8001038 <recieve_update+0x144>)
 8000fca:	f000 fa0d 	bl	80013e8 <flash_write>

      update_section_end_address += wb_size;
 8000fce:	4b19      	ldr	r3, [pc, #100]	@ (8001034 <recieve_update+0x140>)
 8000fd0:	881b      	ldrh	r3, [r3, #0]
 8000fd2:	461a      	mov	r2, r3
 8000fd4:	4b14      	ldr	r3, [pc, #80]	@ (8001028 <recieve_update+0x134>)
 8000fd6:	681b      	ldr	r3, [r3, #0]
 8000fd8:	4413      	add	r3, r2
 8000fda:	4a13      	ldr	r2, [pc, #76]	@ (8001028 <recieve_update+0x134>)
 8000fdc:	6013      	str	r3, [r2, #0]
      wb_size = 0;
 8000fde:	4b15      	ldr	r3, [pc, #84]	@ (8001034 <recieve_update+0x140>)
 8000fe0:	2200      	movs	r2, #0
 8000fe2:	801a      	strh	r2, [r3, #0]
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 8000fe4:	4b10      	ldr	r3, [pc, #64]	@ (8001028 <recieve_update+0x134>)
 8000fe6:	681b      	ldr	r3, [r3, #0]
 8000fe8:	f103 4377 	add.w	r3, r3, #4143972352	@ 0xf7000000
 8000fec:	f503 037c 	add.w	r3, r3, #16515072	@ 0xfc0000
 8000ff0:	4a05      	ldr	r2, [pc, #20]	@ (8001008 <recieve_update+0x114>)
 8000ff2:	6812      	ldr	r2, [r2, #0]
 8000ff4:	4293      	cmp	r3, r2
 8000ff6:	d3b3      	bcc.n	8000f60 <recieve_update+0x6c>
    }
  }

  // while (fw_ar_ind < update_size);

  return 0;
 8000ff8:	2300      	movs	r3, #0
}
 8000ffa:	4618      	mov	r0, r3
 8000ffc:	3708      	adds	r7, #8
 8000ffe:	46bd      	mov	sp, r7
 8001000:	bd80      	pop	{r7, pc}
 8001002:	bf00      	nop
 8001004:	08001b60 	.word	0x08001b60
 8001008:	2000006c 	.word	0x2000006c
 800100c:	20005078 	.word	0x20005078
 8001010:	2000507a 	.word	0x2000507a
 8001014:	08001b84 	.word	0x08001b84
 8001018:	2000507b 	.word	0x2000507b
 800101c:	08001ba0 	.word	0x08001ba0
 8001020:	20005079 	.word	0x20005079
 8001024:	08001bc4 	.word	0x08001bc4
 8001028:	20000004 	.word	0x20000004
 800102c:	08040000 	.word	0x08040000
 8001030:	20000070 	.word	0x20000070
 8001034:	20005074 	.word	0x20005074
 8001038:	20002874 	.word	0x20002874

0800103c <rollback>:

void rollback(void) {
 800103c:	b580      	push	{r7, lr}
 800103e:	b08e      	sub	sp, #56	@ 0x38
 8001040:	af00      	add	r7, sp, #0

  firmware_t old_f;
  // old firmware is present in the COPY_ADDR section
  init_firmware_t(COPY_ADDR, &old_f);
 8001042:	f107 0308 	add.w	r3, r7, #8
 8001046:	4619      	mov	r1, r3
 8001048:	4819      	ldr	r0, [pc, #100]	@ (80010b0 <rollback+0x74>)
 800104a:	f7ff fbaf 	bl	80007ac <init_firmware_t>

  printf("startign rollback\n\n\r", 0x0);
 800104e:	2100      	movs	r1, #0
 8001050:	4818      	ldr	r0, [pc, #96]	@ (80010b4 <rollback+0x78>)
 8001052:	f7ff febf 	bl	8000dd4 <printf>
  erase_flash(old_f.__base_address);
 8001056:	68bb      	ldr	r3, [r7, #8]
 8001058:	4618      	mov	r0, r3
 800105a:	f000 f90b 	bl	8001274 <erase_flash>
  printf("corupted firmware is erased\n\r", 0x0);
 800105e:	2100      	movs	r1, #0
 8001060:	4815      	ldr	r0, [pc, #84]	@ (80010b8 <rollback+0x7c>)
 8001062:	f7ff feb7 	bl	8000dd4 <printf>

  uint32_t copy_size =
      (*(uint32_t *)(COPY_ADDR + 0x14)) - (*(uint32_t *)(COPY_ADDR + 0x0c));
 8001066:	4b15      	ldr	r3, [pc, #84]	@ (80010bc <rollback+0x80>)
 8001068:	681a      	ldr	r2, [r3, #0]
 800106a:	4b15      	ldr	r3, [pc, #84]	@ (80010c0 <rollback+0x84>)
 800106c:	681b      	ldr	r3, [r3, #0]
  uint32_t copy_size =
 800106e:	1ad3      	subs	r3, r2, r3
 8001070:	637b      	str	r3, [r7, #52]	@ 0x34
  flash_write(old_f.__base_address + 0x04, (const char *)(COPY_ADDR + 0x04),
 8001072:	68bb      	ldr	r3, [r7, #8]
 8001074:	1d18      	adds	r0, r3, #4
 8001076:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8001078:	1f1a      	subs	r2, r3, #4
 800107a:	2300      	movs	r3, #0
 800107c:	4911      	ldr	r1, [pc, #68]	@ (80010c4 <rollback+0x88>)
 800107e:	f000 f9b3 	bl	80013e8 <flash_write>
              copy_size - 0x04, NO_DELAY);

  // word write => size would be 4 (not 2)
  const uint32_t end = 0xfffffffe;
 8001082:	f06f 0301 	mvn.w	r3, #1
 8001086:	607b      	str	r3, [r7, #4]
  // &end is of type -> uint32_t * ==> need type conversion
  flash_write(old_f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8001088:	68b8      	ldr	r0, [r7, #8]
 800108a:	1d39      	adds	r1, r7, #4
 800108c:	2300      	movs	r3, #0
 800108e:	2204      	movs	r2, #4
 8001090:	f000 f9aa 	bl	80013e8 <flash_write>
  printf("new flag = %\n\r", old_f.__base_address);
 8001094:	68bb      	ldr	r3, [r7, #8]
 8001096:	4619      	mov	r1, r3
 8001098:	480b      	ldr	r0, [pc, #44]	@ (80010c8 <rollback+0x8c>)
 800109a:	f7ff fe9b 	bl	8000dd4 <printf>

  printf("done recovering old firmware \n\r", 0x0);
 800109e:	2100      	movs	r1, #0
 80010a0:	480a      	ldr	r0, [pc, #40]	@ (80010cc <rollback+0x90>)
 80010a2:	f7ff fe97 	bl	8000dd4 <printf>
}
 80010a6:	bf00      	nop
 80010a8:	3738      	adds	r7, #56	@ 0x38
 80010aa:	46bd      	mov	sp, r7
 80010ac:	bd80      	pop	{r7, pc}
 80010ae:	bf00      	nop
 80010b0:	08060000 	.word	0x08060000
 80010b4:	08001bdc 	.word	0x08001bdc
 80010b8:	08001bf4 	.word	0x08001bf4
 80010bc:	08060014 	.word	0x08060014
 80010c0:	0806000c 	.word	0x0806000c
 80010c4:	08060004 	.word	0x08060004
 80010c8:	08001c14 	.word	0x08001c14
 80010cc:	08001c24 	.word	0x08001c24

080010d0 <__NVIC_EnableIRQ>:
{
 80010d0:	b480      	push	{r7}
 80010d2:	b083      	sub	sp, #12
 80010d4:	af00      	add	r7, sp, #0
 80010d6:	4603      	mov	r3, r0
 80010d8:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 80010da:	f997 3007 	ldrsb.w	r3, [r7, #7]
 80010de:	2b00      	cmp	r3, #0
 80010e0:	db0b      	blt.n	80010fa <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 80010e2:	79fb      	ldrb	r3, [r7, #7]
 80010e4:	f003 021f 	and.w	r2, r3, #31
 80010e8:	4906      	ldr	r1, [pc, #24]	@ (8001104 <__NVIC_EnableIRQ+0x34>)
 80010ea:	f997 3007 	ldrsb.w	r3, [r7, #7]
 80010ee:	095b      	lsrs	r3, r3, #5
 80010f0:	2001      	movs	r0, #1
 80010f2:	fa00 f202 	lsl.w	r2, r0, r2
 80010f6:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 80010fa:	bf00      	nop
 80010fc:	370c      	adds	r7, #12
 80010fe:	46bd      	mov	sp, r7
 8001100:	bc80      	pop	{r7}
 8001102:	4770      	bx	lr
 8001104:	e000e100 	.word	0xe000e100

08001108 <__usart1_scan>:
#include "usart.h"

#define TX_PIN 9
#define RX_PIN 10

void __usart1_scan (char* buffer, uint16_t size){
 8001108:	b480      	push	{r7}
 800110a:	b085      	sub	sp, #20
 800110c:	af00      	add	r7, sp, #0
 800110e:	6078      	str	r0, [r7, #4]
 8001110:	460b      	mov	r3, r1
 8001112:	807b      	strh	r3, [r7, #2]
  
  uint16_t i = 0;
 8001114:	2300      	movs	r3, #0
 8001116:	81fb      	strh	r3, [r7, #14]
  while (i < size) {
 8001118:	e010      	b.n	800113c <__usart1_scan+0x34>
    // wait
    while (!(USART1->SR & USART_SR_RXNE))
 800111a:	bf00      	nop
 800111c:	4b0c      	ldr	r3, [pc, #48]	@ (8001150 <__usart1_scan+0x48>)
 800111e:	681b      	ldr	r3, [r3, #0]
 8001120:	f003 0320 	and.w	r3, r3, #32
 8001124:	2b00      	cmp	r3, #0
 8001126:	d0f9      	beq.n	800111c <__usart1_scan+0x14>
      ;
    buffer[i++] = USART1->DR;
 8001128:	4b09      	ldr	r3, [pc, #36]	@ (8001150 <__usart1_scan+0x48>)
 800112a:	685a      	ldr	r2, [r3, #4]
 800112c:	89fb      	ldrh	r3, [r7, #14]
 800112e:	1c59      	adds	r1, r3, #1
 8001130:	81f9      	strh	r1, [r7, #14]
 8001132:	4619      	mov	r1, r3
 8001134:	687b      	ldr	r3, [r7, #4]
 8001136:	440b      	add	r3, r1
 8001138:	b2d2      	uxtb	r2, r2
 800113a:	701a      	strb	r2, [r3, #0]
  while (i < size) {
 800113c:	89fa      	ldrh	r2, [r7, #14]
 800113e:	887b      	ldrh	r3, [r7, #2]
 8001140:	429a      	cmp	r2, r3
 8001142:	d3ea      	bcc.n	800111a <__usart1_scan+0x12>
  }
}
 8001144:	bf00      	nop
 8001146:	bf00      	nop
 8001148:	3714      	adds	r7, #20
 800114a:	46bd      	mov	sp, r7
 800114c:	bc80      	pop	{r7}
 800114e:	4770      	bx	lr
 8001150:	40011000 	.word	0x40011000

08001154 <__usart1_init>:

void __usart1_init(void) {
 8001154:	b580      	push	{r7, lr}
 8001156:	af00      	add	r7, sp, #0

  RCC->APB2ENR |= RCC_APB2ENR_USART1EN_Msk;
 8001158:	4b20      	ldr	r3, [pc, #128]	@ (80011dc <__usart1_init+0x88>)
 800115a:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 800115c:	4a1f      	ldr	r2, [pc, #124]	@ (80011dc <__usart1_init+0x88>)
 800115e:	f043 0310 	orr.w	r3, r3, #16
 8001162:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
 8001164:	4b1d      	ldr	r3, [pc, #116]	@ (80011dc <__usart1_init+0x88>)
 8001166:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8001168:	4a1c      	ldr	r2, [pc, #112]	@ (80011dc <__usart1_init+0x88>)
 800116a:	f043 0301 	orr.w	r3, r3, #1
 800116e:	6313      	str	r3, [r2, #48]	@ 0x30
  // alternate function mode
  GPIOA->MODER &= ~((3 << (2 * TX_PIN)) | (3 << (2 * RX_PIN)));
 8001170:	4b1b      	ldr	r3, [pc, #108]	@ (80011e0 <__usart1_init+0x8c>)
 8001172:	681b      	ldr	r3, [r3, #0]
 8001174:	4a1a      	ldr	r2, [pc, #104]	@ (80011e0 <__usart1_init+0x8c>)
 8001176:	f423 1370 	bic.w	r3, r3, #3932160	@ 0x3c0000
 800117a:	6013      	str	r3, [r2, #0]
  GPIOA->MODER |= 2 << (2 * TX_PIN) | 2 << (2 * RX_PIN);
 800117c:	4b18      	ldr	r3, [pc, #96]	@ (80011e0 <__usart1_init+0x8c>)
 800117e:	681b      	ldr	r3, [r3, #0]
 8001180:	4a17      	ldr	r2, [pc, #92]	@ (80011e0 <__usart1_init+0x8c>)
 8001182:	f443 1320 	orr.w	r3, r3, #2621440	@ 0x280000
 8001186:	6013      	str	r3, [r2, #0]
  // high speed
  GPIOA->OSPEEDR |= (3 << (TX_PIN * 2)) | (3 << (RX_PIN * 2));
 8001188:	4b15      	ldr	r3, [pc, #84]	@ (80011e0 <__usart1_init+0x8c>)
 800118a:	689b      	ldr	r3, [r3, #8]
 800118c:	4a14      	ldr	r2, [pc, #80]	@ (80011e0 <__usart1_init+0x8c>)
 800118e:	f443 1370 	orr.w	r3, r3, #3932160	@ 0x3c0000
 8001192:	6093      	str	r3, [r2, #8]
  // clear the bits in AFR register
  GPIOA->AFR[1] &= ~((0xf << 4) | (0xf << 8));
 8001194:	4b12      	ldr	r3, [pc, #72]	@ (80011e0 <__usart1_init+0x8c>)
 8001196:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8001198:	4a11      	ldr	r2, [pc, #68]	@ (80011e0 <__usart1_init+0x8c>)
 800119a:	f423 637f 	bic.w	r3, r3, #4080	@ 0xff0
 800119e:	6253      	str	r3, [r2, #36]	@ 0x24
  // set for af7
  GPIOA->AFR[1] |= (7 << 4) | (7 << 8);
 80011a0:	4b0f      	ldr	r3, [pc, #60]	@ (80011e0 <__usart1_init+0x8c>)
 80011a2:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80011a4:	4a0e      	ldr	r2, [pc, #56]	@ (80011e0 <__usart1_init+0x8c>)
 80011a6:	f443 63ee 	orr.w	r3, r3, #1904	@ 0x770
 80011aa:	6253      	str	r3, [r2, #36]	@ 0x24

  // set the baud rate (115200 in this case)
  USART1->BRR = 0x08B;
 80011ac:	4b0d      	ldr	r3, [pc, #52]	@ (80011e4 <__usart1_init+0x90>)
 80011ae:	228b      	movs	r2, #139	@ 0x8b
 80011b0:	609a      	str	r2, [r3, #8]

  // enable usart reciever interrupt;
  USART1->CR1 = USART_CR1_RXNEIE;
 80011b2:	4b0c      	ldr	r3, [pc, #48]	@ (80011e4 <__usart1_init+0x90>)
 80011b4:	2220      	movs	r2, #32
 80011b6:	60da      	str	r2, [r3, #12]

  NVIC_EnableIRQ (USART1_IRQn);
 80011b8:	2025      	movs	r0, #37	@ 0x25
 80011ba:	f7ff ff89 	bl	80010d0 <__NVIC_EnableIRQ>

  // enable transmitter and reciever at the end
  USART1->CR1 |= USART_CR1_RE | USART_CR1_TE;
 80011be:	4b09      	ldr	r3, [pc, #36]	@ (80011e4 <__usart1_init+0x90>)
 80011c0:	68db      	ldr	r3, [r3, #12]
 80011c2:	4a08      	ldr	r2, [pc, #32]	@ (80011e4 <__usart1_init+0x90>)
 80011c4:	f043 030c 	orr.w	r3, r3, #12
 80011c8:	60d3      	str	r3, [r2, #12]

  // enable usart
  USART1->CR1 |= USART_CR1_UE;
 80011ca:	4b06      	ldr	r3, [pc, #24]	@ (80011e4 <__usart1_init+0x90>)
 80011cc:	68db      	ldr	r3, [r3, #12]
 80011ce:	4a05      	ldr	r2, [pc, #20]	@ (80011e4 <__usart1_init+0x90>)
 80011d0:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 80011d4:	60d3      	str	r3, [r2, #12]

}
 80011d6:	bf00      	nop
 80011d8:	bd80      	pop	{r7, pc}
 80011da:	bf00      	nop
 80011dc:	40023800 	.word	0x40023800
 80011e0:	40020000 	.word	0x40020000
 80011e4:	40011000 	.word	0x40011000

080011e8 <__usart1_print>:

void __usart1_print(const char *msg, uint32_t size) {
 80011e8:	b480      	push	{r7}
 80011ea:	b085      	sub	sp, #20
 80011ec:	af00      	add	r7, sp, #0
 80011ee:	6078      	str	r0, [r7, #4]
 80011f0:	6039      	str	r1, [r7, #0]

  int i = 0;
 80011f2:	2300      	movs	r3, #0
 80011f4:	60fb      	str	r3, [r7, #12]
  while (i < size && msg[i] != '\0') {
 80011f6:	e00f      	b.n	8001218 <__usart1_print+0x30>
    while (!(USART1->SR & USART_SR_TXE))
 80011f8:	bf00      	nop
 80011fa:	4b13      	ldr	r3, [pc, #76]	@ (8001248 <__usart1_print+0x60>)
 80011fc:	681b      	ldr	r3, [r3, #0]
 80011fe:	f003 0380 	and.w	r3, r3, #128	@ 0x80
 8001202:	2b00      	cmp	r3, #0
 8001204:	d0f9      	beq.n	80011fa <__usart1_print+0x12>
      ;
    USART1->DR = msg[i++];
 8001206:	68fb      	ldr	r3, [r7, #12]
 8001208:	1c5a      	adds	r2, r3, #1
 800120a:	60fa      	str	r2, [r7, #12]
 800120c:	461a      	mov	r2, r3
 800120e:	687b      	ldr	r3, [r7, #4]
 8001210:	4413      	add	r3, r2
 8001212:	781a      	ldrb	r2, [r3, #0]
 8001214:	4b0c      	ldr	r3, [pc, #48]	@ (8001248 <__usart1_print+0x60>)
 8001216:	605a      	str	r2, [r3, #4]
  while (i < size && msg[i] != '\0') {
 8001218:	68fb      	ldr	r3, [r7, #12]
 800121a:	683a      	ldr	r2, [r7, #0]
 800121c:	429a      	cmp	r2, r3
 800121e:	d905      	bls.n	800122c <__usart1_print+0x44>
 8001220:	68fb      	ldr	r3, [r7, #12]
 8001222:	687a      	ldr	r2, [r7, #4]
 8001224:	4413      	add	r3, r2
 8001226:	781b      	ldrb	r3, [r3, #0]
 8001228:	2b00      	cmp	r3, #0
 800122a:	d1e5      	bne.n	80011f8 <__usart1_print+0x10>
  }
  while (!(USART1->SR & USART_SR_TC)) {
 800122c:	bf00      	nop
 800122e:	4b06      	ldr	r3, [pc, #24]	@ (8001248 <__usart1_print+0x60>)
 8001230:	681b      	ldr	r3, [r3, #0]
 8001232:	f003 0340 	and.w	r3, r3, #64	@ 0x40
 8001236:	2b00      	cmp	r3, #0
 8001238:	d0f9      	beq.n	800122e <__usart1_print+0x46>
  }
}
 800123a:	bf00      	nop
 800123c:	bf00      	nop
 800123e:	3714      	adds	r7, #20
 8001240:	46bd      	mov	sp, r7
 8001242:	bc80      	pop	{r7}
 8001244:	4770      	bx	lr
 8001246:	bf00      	nop
 8001248:	40011000 	.word	0x40011000

0800124c <__usart1_reset_reg>:


// reset the registers of usart1;
void __usart1_reset_reg (void){
 800124c:	b480      	push	{r7}
 800124e:	af00      	add	r7, sp, #0
  RCC->APB1RSTR |= RCC_APB1RSTR_USART2RST;
 8001250:	4b07      	ldr	r3, [pc, #28]	@ (8001270 <__usart1_reset_reg+0x24>)
 8001252:	6a1b      	ldr	r3, [r3, #32]
 8001254:	4a06      	ldr	r2, [pc, #24]	@ (8001270 <__usart1_reset_reg+0x24>)
 8001256:	f443 3300 	orr.w	r3, r3, #131072	@ 0x20000
 800125a:	6213      	str	r3, [r2, #32]
  RCC->APB1RSTR &= ~RCC_APB1RSTR_USART2RST;
 800125c:	4b04      	ldr	r3, [pc, #16]	@ (8001270 <__usart1_reset_reg+0x24>)
 800125e:	6a1b      	ldr	r3, [r3, #32]
 8001260:	4a03      	ldr	r2, [pc, #12]	@ (8001270 <__usart1_reset_reg+0x24>)
 8001262:	f423 3300 	bic.w	r3, r3, #131072	@ 0x20000
 8001266:	6213      	str	r3, [r2, #32]
}
 8001268:	bf00      	nop
 800126a:	46bd      	mov	sp, r7
 800126c:	bc80      	pop	{r7}
 800126e:	4770      	bx	lr
 8001270:	40023800 	.word	0x40023800

08001274 <erase_flash>:
#define KEY1 0x45670123
#define KEY2 0xCDEF89AB

void printf (const char *string, uint32_t addr);

uint32_t erase_flash(uint32_t address) {
 8001274:	b580      	push	{r7, lr}
 8001276:	b084      	sub	sp, #16
 8001278:	af00      	add	r7, sp, #0
 800127a:	6078      	str	r0, [r7, #4]
  if (address >= 0x08080000 || address < 0x08000000) {
 800127c:	687b      	ldr	r3, [r7, #4]
 800127e:	4a4c      	ldr	r2, [pc, #304]	@ (80013b0 <erase_flash+0x13c>)
 8001280:	4293      	cmp	r3, r2
 8001282:	d803      	bhi.n	800128c <erase_flash+0x18>
 8001284:	687b      	ldr	r3, [r7, #4]
 8001286:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 800128a:	d206      	bcs.n	800129a <erase_flash+0x26>
    printf("wrong address \n\r", 0x0);
 800128c:	2100      	movs	r1, #0
 800128e:	4849      	ldr	r0, [pc, #292]	@ (80013b4 <erase_flash+0x140>)
 8001290:	f7ff fda0 	bl	8000dd4 <printf>
    return -1;
 8001294:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 8001298:	e085      	b.n	80013a6 <erase_flash+0x132>
  }

  uint32_t sector = 0;
 800129a:	2300      	movs	r3, #0
 800129c:	60fb      	str	r3, [r7, #12]
  if (address >= 0x08060000)
 800129e:	687b      	ldr	r3, [r7, #4]
 80012a0:	4a45      	ldr	r2, [pc, #276]	@ (80013b8 <erase_flash+0x144>)
 80012a2:	4293      	cmp	r3, r2
 80012a4:	d902      	bls.n	80012ac <erase_flash+0x38>
    sector = 7;
 80012a6:	2307      	movs	r3, #7
 80012a8:	60fb      	str	r3, [r7, #12]
 80012aa:	e037      	b.n	800131c <erase_flash+0xa8>
  else if (address >= 0x08040000)
 80012ac:	687b      	ldr	r3, [r7, #4]
 80012ae:	4a43      	ldr	r2, [pc, #268]	@ (80013bc <erase_flash+0x148>)
 80012b0:	4293      	cmp	r3, r2
 80012b2:	d902      	bls.n	80012ba <erase_flash+0x46>
    sector = 6;
 80012b4:	2306      	movs	r3, #6
 80012b6:	60fb      	str	r3, [r7, #12]
 80012b8:	e030      	b.n	800131c <erase_flash+0xa8>
  else if (address >= 0x08020000)
 80012ba:	687b      	ldr	r3, [r7, #4]
 80012bc:	4a40      	ldr	r2, [pc, #256]	@ (80013c0 <erase_flash+0x14c>)
 80012be:	4293      	cmp	r3, r2
 80012c0:	d902      	bls.n	80012c8 <erase_flash+0x54>
    sector = 5;
 80012c2:	2305      	movs	r3, #5
 80012c4:	60fb      	str	r3, [r7, #12]
 80012c6:	e029      	b.n	800131c <erase_flash+0xa8>
  else if (address >= 0x08010000)
 80012c8:	687b      	ldr	r3, [r7, #4]
 80012ca:	4a3e      	ldr	r2, [pc, #248]	@ (80013c4 <erase_flash+0x150>)
 80012cc:	4293      	cmp	r3, r2
 80012ce:	d902      	bls.n	80012d6 <erase_flash+0x62>
    sector = 4;
 80012d0:	2304      	movs	r3, #4
 80012d2:	60fb      	str	r3, [r7, #12]
 80012d4:	e022      	b.n	800131c <erase_flash+0xa8>
  else if (address >= 0x0800c000)
 80012d6:	687b      	ldr	r3, [r7, #4]
 80012d8:	4a3b      	ldr	r2, [pc, #236]	@ (80013c8 <erase_flash+0x154>)
 80012da:	4293      	cmp	r3, r2
 80012dc:	d302      	bcc.n	80012e4 <erase_flash+0x70>
    sector = 3;
 80012de:	2303      	movs	r3, #3
 80012e0:	60fb      	str	r3, [r7, #12]
 80012e2:	e01b      	b.n	800131c <erase_flash+0xa8>
  else if (address >= 0x08008000)
 80012e4:	687b      	ldr	r3, [r7, #4]
 80012e6:	4a39      	ldr	r2, [pc, #228]	@ (80013cc <erase_flash+0x158>)
 80012e8:	4293      	cmp	r3, r2
 80012ea:	d302      	bcc.n	80012f2 <erase_flash+0x7e>
    sector = 2;
 80012ec:	2302      	movs	r3, #2
 80012ee:	60fb      	str	r3, [r7, #12]
 80012f0:	e014      	b.n	800131c <erase_flash+0xa8>
  else if (address >= 0x08004000)
 80012f2:	687b      	ldr	r3, [r7, #4]
 80012f4:	4a36      	ldr	r2, [pc, #216]	@ (80013d0 <erase_flash+0x15c>)
 80012f6:	4293      	cmp	r3, r2
 80012f8:	d302      	bcc.n	8001300 <erase_flash+0x8c>
    sector = 1;
 80012fa:	2301      	movs	r3, #1
 80012fc:	60fb      	str	r3, [r7, #12]
 80012fe:	e00d      	b.n	800131c <erase_flash+0xa8>
  else if (address >= 0x08000000)
 8001300:	687b      	ldr	r3, [r7, #4]
 8001302:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 8001306:	d302      	bcc.n	800130e <erase_flash+0x9a>
    sector = 0;
 8001308:	2300      	movs	r3, #0
 800130a:	60fb      	str	r3, [r7, #12]
 800130c:	e006      	b.n	800131c <erase_flash+0xa8>
  else {
    printf("wrong address\n\r", 0x0);
 800130e:	2100      	movs	r1, #0
 8001310:	4830      	ldr	r0, [pc, #192]	@ (80013d4 <erase_flash+0x160>)
 8001312:	f7ff fd5f 	bl	8000dd4 <printf>
    return -1;
 8001316:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 800131a:	e044      	b.n	80013a6 <erase_flash+0x132>
  }
  // unlock
  FLASH->KEYR = KEY1;
 800131c:	4b2e      	ldr	r3, [pc, #184]	@ (80013d8 <erase_flash+0x164>)
 800131e:	4a2f      	ldr	r2, [pc, #188]	@ (80013dc <erase_flash+0x168>)
 8001320:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 8001322:	4b2d      	ldr	r3, [pc, #180]	@ (80013d8 <erase_flash+0x164>)
 8001324:	4a2e      	ldr	r2, [pc, #184]	@ (80013e0 <erase_flash+0x16c>)
 8001326:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8001328:	4b2b      	ldr	r3, [pc, #172]	@ (80013d8 <erase_flash+0x164>)
 800132a:	68db      	ldr	r3, [r3, #12]
 800132c:	4a2a      	ldr	r2, [pc, #168]	@ (80013d8 <erase_flash+0x164>)
 800132e:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 8001332:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 8001334:	bf00      	nop
 8001336:	4b28      	ldr	r3, [pc, #160]	@ (80013d8 <erase_flash+0x164>)
 8001338:	68db      	ldr	r3, [r3, #12]
 800133a:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 800133e:	2b00      	cmp	r3, #0
 8001340:	d1f9      	bne.n	8001336 <erase_flash+0xc2>
    ;

  FLASH->CR |= FLASH_CR_SER;
 8001342:	4b25      	ldr	r3, [pc, #148]	@ (80013d8 <erase_flash+0x164>)
 8001344:	691b      	ldr	r3, [r3, #16]
 8001346:	4a24      	ldr	r2, [pc, #144]	@ (80013d8 <erase_flash+0x164>)
 8001348:	f043 0302 	orr.w	r3, r3, #2
 800134c:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(FLASH_CR_SNB);
 800134e:	4b22      	ldr	r3, [pc, #136]	@ (80013d8 <erase_flash+0x164>)
 8001350:	691b      	ldr	r3, [r3, #16]
 8001352:	4a21      	ldr	r2, [pc, #132]	@ (80013d8 <erase_flash+0x164>)
 8001354:	f023 03f8 	bic.w	r3, r3, #248	@ 0xf8
 8001358:	6113      	str	r3, [r2, #16]
  FLASH->CR |= (sector << FLASH_CR_SNB_Pos);
 800135a:	4b1f      	ldr	r3, [pc, #124]	@ (80013d8 <erase_flash+0x164>)
 800135c:	691a      	ldr	r2, [r3, #16]
 800135e:	68fb      	ldr	r3, [r7, #12]
 8001360:	00db      	lsls	r3, r3, #3
 8001362:	491d      	ldr	r1, [pc, #116]	@ (80013d8 <erase_flash+0x164>)
 8001364:	4313      	orrs	r3, r2
 8001366:	610b      	str	r3, [r1, #16]
  FLASH->CR |= FLASH_CR_STRT;
 8001368:	4b1b      	ldr	r3, [pc, #108]	@ (80013d8 <erase_flash+0x164>)
 800136a:	691b      	ldr	r3, [r3, #16]
 800136c:	4a1a      	ldr	r2, [pc, #104]	@ (80013d8 <erase_flash+0x164>)
 800136e:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 8001372:	6113      	str	r3, [r2, #16]

  // wait for the flash to be erased;
  while (FLASH->SR & FLASH_SR_BSY)
 8001374:	bf00      	nop
 8001376:	4b18      	ldr	r3, [pc, #96]	@ (80013d8 <erase_flash+0x164>)
 8001378:	68db      	ldr	r3, [r3, #12]
 800137a:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 800137e:	2b00      	cmp	r3, #0
 8001380:	d1f9      	bne.n	8001376 <erase_flash+0x102>
    ;

  // clear the erase bit
  FLASH->CR &= ~(FLASH_CR_SER);
 8001382:	4b15      	ldr	r3, [pc, #84]	@ (80013d8 <erase_flash+0x164>)
 8001384:	691b      	ldr	r3, [r3, #16]
 8001386:	4a14      	ldr	r2, [pc, #80]	@ (80013d8 <erase_flash+0x164>)
 8001388:	f023 0302 	bic.w	r3, r3, #2
 800138c:	6113      	str	r3, [r2, #16]
  // lock the control register
  FLASH->CR |= FLASH_CR_LOCK;
 800138e:	4b12      	ldr	r3, [pc, #72]	@ (80013d8 <erase_flash+0x164>)
 8001390:	691b      	ldr	r3, [r3, #16]
 8001392:	4a11      	ldr	r2, [pc, #68]	@ (80013d8 <erase_flash+0x164>)
 8001394:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 8001398:	6113      	str	r3, [r2, #16]

  printf("done erasing flash (address = %)\n\r", (uint32_t)(&address));
 800139a:	1d3b      	adds	r3, r7, #4
 800139c:	4619      	mov	r1, r3
 800139e:	4811      	ldr	r0, [pc, #68]	@ (80013e4 <erase_flash+0x170>)
 80013a0:	f7ff fd18 	bl	8000dd4 <printf>
  return 0;
 80013a4:	2300      	movs	r3, #0
}
 80013a6:	4618      	mov	r0, r3
 80013a8:	3710      	adds	r7, #16
 80013aa:	46bd      	mov	sp, r7
 80013ac:	bd80      	pop	{r7, pc}
 80013ae:	bf00      	nop
 80013b0:	0807ffff 	.word	0x0807ffff
 80013b4:	08001c44 	.word	0x08001c44
 80013b8:	0805ffff 	.word	0x0805ffff
 80013bc:	0803ffff 	.word	0x0803ffff
 80013c0:	0801ffff 	.word	0x0801ffff
 80013c4:	0800ffff 	.word	0x0800ffff
 80013c8:	0800c000 	.word	0x0800c000
 80013cc:	08008000 	.word	0x08008000
 80013d0:	08004000 	.word	0x08004000
 80013d4:	08001c58 	.word	0x08001c58
 80013d8:	40023c00 	.word	0x40023c00
 80013dc:	45670123 	.word	0x45670123
 80013e0:	cdef89ab 	.word	0xcdef89ab
 80013e4:	08001c68 	.word	0x08001c68

080013e8 <flash_write>:

uint32_t flash_write(uint32_t address, const char *buff, uint32_t size,
                     uint32_t simulate) {
 80013e8:	b480      	push	{r7}
 80013ea:	b087      	sub	sp, #28
 80013ec:	af00      	add	r7, sp, #0
 80013ee:	60f8      	str	r0, [r7, #12]
 80013f0:	60b9      	str	r1, [r7, #8]
 80013f2:	607a      	str	r2, [r7, #4]
 80013f4:	603b      	str	r3, [r7, #0]


  // unlock
  FLASH->KEYR = KEY1;
 80013f6:	4b26      	ldr	r3, [pc, #152]	@ (8001490 <flash_write+0xa8>)
 80013f8:	4a26      	ldr	r2, [pc, #152]	@ (8001494 <flash_write+0xac>)
 80013fa:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 80013fc:	4b24      	ldr	r3, [pc, #144]	@ (8001490 <flash_write+0xa8>)
 80013fe:	4a26      	ldr	r2, [pc, #152]	@ (8001498 <flash_write+0xb0>)
 8001400:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8001402:	4b23      	ldr	r3, [pc, #140]	@ (8001490 <flash_write+0xa8>)
 8001404:	68db      	ldr	r3, [r3, #12]
 8001406:	4a22      	ldr	r2, [pc, #136]	@ (8001490 <flash_write+0xa8>)
 8001408:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 800140c:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 800140e:	bf00      	nop
 8001410:	4b1f      	ldr	r3, [pc, #124]	@ (8001490 <flash_write+0xa8>)
 8001412:	68db      	ldr	r3, [r3, #12]
 8001414:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 8001418:	2b00      	cmp	r3, #0
 800141a:	d1f9      	bne.n	8001410 <flash_write+0x28>
    ;
  FLASH->CR |= FLASH_CR_PG;
 800141c:	4b1c      	ldr	r3, [pc, #112]	@ (8001490 <flash_write+0xa8>)
 800141e:	691b      	ldr	r3, [r3, #16]
 8001420:	4a1b      	ldr	r2, [pc, #108]	@ (8001490 <flash_write+0xa8>)
 8001422:	f043 0301 	orr.w	r3, r3, #1
 8001426:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(3 << FLASH_CR_PSIZE_Pos);
 8001428:	4b19      	ldr	r3, [pc, #100]	@ (8001490 <flash_write+0xa8>)
 800142a:	691b      	ldr	r3, [r3, #16]
 800142c:	4a18      	ldr	r2, [pc, #96]	@ (8001490 <flash_write+0xa8>)
 800142e:	f423 7340 	bic.w	r3, r3, #768	@ 0x300
 8001432:	6113      	str	r3, [r2, #16]
  // set PSIZE bit to 2 for 32 bit programming
  FLASH->CR |= 2 << FLASH_CR_PSIZE_Pos;
 8001434:	4b16      	ldr	r3, [pc, #88]	@ (8001490 <flash_write+0xa8>)
 8001436:	691b      	ldr	r3, [r3, #16]
 8001438:	4a15      	ldr	r2, [pc, #84]	@ (8001490 <flash_write+0xa8>)
 800143a:	f443 7300 	orr.w	r3, r3, #512	@ 0x200
 800143e:	6113      	str	r3, [r2, #16]

  uint32_t i = 0;
 8001440:	2300      	movs	r3, #0
 8001442:	617b      	str	r3, [r7, #20]
  while (i < size / 4) {
 8001444:	e00c      	b.n	8001460 <flash_write+0x78>

    *((uint32_t *)address) = ((const uint32_t *)buff)[i];
 8001446:	697b      	ldr	r3, [r7, #20]
 8001448:	009b      	lsls	r3, r3, #2
 800144a:	68ba      	ldr	r2, [r7, #8]
 800144c:	441a      	add	r2, r3
 800144e:	68fb      	ldr	r3, [r7, #12]
 8001450:	6812      	ldr	r2, [r2, #0]
 8001452:	601a      	str	r2, [r3, #0]
    i++;
 8001454:	697b      	ldr	r3, [r7, #20]
 8001456:	3301      	adds	r3, #1
 8001458:	617b      	str	r3, [r7, #20]
    address += 4;
 800145a:	68fb      	ldr	r3, [r7, #12]
 800145c:	3304      	adds	r3, #4
 800145e:	60fb      	str	r3, [r7, #12]
  while (i < size / 4) {
 8001460:	687b      	ldr	r3, [r7, #4]
 8001462:	089b      	lsrs	r3, r3, #2
 8001464:	697a      	ldr	r2, [r7, #20]
 8001466:	429a      	cmp	r2, r3
 8001468:	d3ed      	bcc.n	8001446 <flash_write+0x5e>
  }
  FLASH->CR &= ~(FLASH_CR_PG);
 800146a:	4b09      	ldr	r3, [pc, #36]	@ (8001490 <flash_write+0xa8>)
 800146c:	691b      	ldr	r3, [r3, #16]
 800146e:	4a08      	ldr	r2, [pc, #32]	@ (8001490 <flash_write+0xa8>)
 8001470:	f023 0301 	bic.w	r3, r3, #1
 8001474:	6113      	str	r3, [r2, #16]

  // lock this flash
  FLASH->CR |= FLASH_CR_LOCK;
 8001476:	4b06      	ldr	r3, [pc, #24]	@ (8001490 <flash_write+0xa8>)
 8001478:	691b      	ldr	r3, [r3, #16]
 800147a:	4a05      	ldr	r2, [pc, #20]	@ (8001490 <flash_write+0xa8>)
 800147c:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 8001480:	6113      	str	r3, [r2, #16]

  return 0;
 8001482:	2300      	movs	r3, #0
}
 8001484:	4618      	mov	r0, r3
 8001486:	371c      	adds	r7, #28
 8001488:	46bd      	mov	sp, r7
 800148a:	bc80      	pop	{r7}
 800148c:	4770      	bx	lr
 800148e:	bf00      	nop
 8001490:	40023c00 	.word	0x40023c00
 8001494:	45670123 	.word	0x45670123
 8001498:	cdef89ab 	.word	0xcdef89ab

0800149c <flash_reg_reset>:


// reset the registers of flash 

void flash_reg_reset (void){
 800149c:	b480      	push	{r7}
 800149e:	af00      	add	r7, sp, #0
  FLASH-> ACR = FLASH_ACR_RESET_VAL;
 80014a0:	4b0b      	ldr	r3, [pc, #44]	@ (80014d0 <flash_reg_reset+0x34>)
 80014a2:	2200      	movs	r2, #0
 80014a4:	601a      	str	r2, [r3, #0]
  FLASH-> KEYR = FLASH_KEYR_RESET_VAL;
 80014a6:	4b0a      	ldr	r3, [pc, #40]	@ (80014d0 <flash_reg_reset+0x34>)
 80014a8:	2200      	movs	r2, #0
 80014aa:	605a      	str	r2, [r3, #4]
  FLASH-> OPTKEYR = FLASH_OPTKEYR_RESET_VAL;
 80014ac:	4b08      	ldr	r3, [pc, #32]	@ (80014d0 <flash_reg_reset+0x34>)
 80014ae:	2200      	movs	r2, #0
 80014b0:	609a      	str	r2, [r3, #8]
  FLASH-> SR = FLASH_SR_RESET_VAL;
 80014b2:	4b07      	ldr	r3, [pc, #28]	@ (80014d0 <flash_reg_reset+0x34>)
 80014b4:	2200      	movs	r2, #0
 80014b6:	60da      	str	r2, [r3, #12]
  FLASH-> CR = FLASH_CR_RESET_VAL;
 80014b8:	4b05      	ldr	r3, [pc, #20]	@ (80014d0 <flash_reg_reset+0x34>)
 80014ba:	f04f 4200 	mov.w	r2, #2147483648	@ 0x80000000
 80014be:	611a      	str	r2, [r3, #16]
  FLASH-> OPTCR = FLASH_OPTCR_RESET_VAL;
 80014c0:	4b03      	ldr	r3, [pc, #12]	@ (80014d0 <flash_reg_reset+0x34>)
 80014c2:	4a04      	ldr	r2, [pc, #16]	@ (80014d4 <flash_reg_reset+0x38>)
 80014c4:	615a      	str	r2, [r3, #20]
}
 80014c6:	bf00      	nop
 80014c8:	46bd      	mov	sp, r7
 80014ca:	bc80      	pop	{r7}
 80014cc:	4770      	bx	lr
 80014ce:	bf00      	nop
 80014d0:	40023c00 	.word	0x40023c00
 80014d4:	00ffaaed 	.word	0x00ffaaed

080014d8 <Reset_Handler>:
 80014d8:	480c      	ldr	r0, [pc, #48]	@ (800150c <hang+0x4>)
 80014da:	490d      	ldr	r1, [pc, #52]	@ (8001510 <hang+0x8>)
 80014dc:	4a0d      	ldr	r2, [pc, #52]	@ (8001514 <hang+0xc>)
 80014de:	e7ff      	b.n	80014e0 <copy>

080014e0 <copy>:
 80014e0:	4288      	cmp	r0, r1
 80014e2:	db04      	blt.n	80014ee <copy_helper>
 80014e4:	480c      	ldr	r0, [pc, #48]	@ (8001518 <hang+0x10>)
 80014e6:	490d      	ldr	r1, [pc, #52]	@ (800151c <hang+0x14>)
 80014e8:	f04f 0200 	mov.w	r2, #0
 80014ec:	e004      	b.n	80014f8 <init_zero>

080014ee <copy_helper>:
 80014ee:	f852 3b04 	ldr.w	r3, [r2], #4
 80014f2:	f840 3b04 	str.w	r3, [r0], #4
 80014f6:	e7f3      	b.n	80014e0 <copy>

080014f8 <init_zero>:
 80014f8:	4288      	cmp	r0, r1
 80014fa:	db00      	blt.n	80014fe <init_zero_helper>
 80014fc:	e002      	b.n	8001504 <call_entry>

080014fe <init_zero_helper>:
 80014fe:	f840 2b04 	str.w	r2, [r0], #4
 8001502:	e7f9      	b.n	80014f8 <init_zero>

08001504 <call_entry>:
 8001504:	f7ff bb36 	b.w	8000b74 <main>

08001508 <hang>:
 8001508:	e7fe      	b.n	8001508 <hang>
 800150a:	0000      	.short	0x0000
 800150c:	20000000 	.word	0x20000000
 8001510:	20000008 	.word	0x20000008
 8001514:	08001c8b 	.word	0x08001c8b
 8001518:	20000008 	.word	0x20000008
 800151c:	2000507c 	.word	0x2000507c

08001520 <EXTI15_10_IRQ_handler>:
 8001520:	f7fe be9c 	b.w	800025c <switch_pressed>

08001524 <Default_Handler>:
 8001524:	e7fe      	b.n	8001524 <Default_Handler>

08001526 <BusFault_Handler>:
 8001526:	f3ef 8008 	mrs	r0, MSP
 800152a:	6980      	ldr	r0, [r0, #24]
 800152c:	f04f 0100 	mov.w	r1, #0
 8001530:	b500      	push	{lr}
 8001532:	f7fe fe03 	bl	800013c <fault_handler_helper>
 8001536:	f85d eb04 	ldr.w	lr, [sp], #4
 800153a:	4770      	bx	lr

0800153c <MemManage_Handler>:
 800153c:	f3ef 8008 	mrs	r0, MSP
 8001540:	6980      	ldr	r0, [r0, #24]
 8001542:	f04f 0101 	mov.w	r1, #1
 8001546:	b500      	push	{lr}
 8001548:	f7fe fdf8 	bl	800013c <fault_handler_helper>
 800154c:	f85d eb04 	ldr.w	lr, [sp], #4
 8001550:	4770      	bx	lr

08001552 <UsageFault_Handler>:
 8001552:	f3ef 8008 	mrs	r0, MSP
 8001556:	6980      	ldr	r0, [r0, #24]
 8001558:	f04f 0102 	mov.w	r1, #2
 800155c:	b500      	push	{lr}
 800155e:	f7fe fded 	bl	800013c <fault_handler_helper>
 8001562:	f85d eb04 	ldr.w	lr, [sp], #4
 8001566:	4770      	bx	lr

08001568 <HardFault_Handler>:
 8001568:	f3ef 8008 	mrs	r0, MSP
 800156c:	6980      	ldr	r0, [r0, #24]
 800156e:	4904      	ldr	r1, [pc, #16]	@ (8001580 <HardFault_Handler+0x18>)
 8001570:	f381 8808 	msr	MSP, r1
 8001574:	b500      	push	{lr}
 8001576:	f7fe fe43 	bl	8000200 <HardFault_Handler_helper>
 800157a:	f85d eb04 	ldr.w	lr, [sp], #4
 800157e:	e7fe      	b.n	800157e <HardFault_Handler+0x16>
 8001580:	20017000 	.word	0x20017000

08001584 <SVC_Handler>:
 8001584:	e7fe      	b.n	8001584 <SVC_Handler>

08001586 <SysTick_Handler>:
 8001586:	e7fe      	b.n	8001586 <SysTick_Handler>

08001588 <PendSV_Handler>:
 8001588:	e7fe      	b.n	8001588 <PendSV_Handler>

0800158a <NMI_Handler>:
 800158a:	e7fe      	b.n	800158a <NMI_Handler>

0800158c <DebugMon_Handler>:
 800158c:	e7fe      	b.n	800158c <DebugMon_Handler>
