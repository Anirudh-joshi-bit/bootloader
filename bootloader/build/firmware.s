
build/firmware.elf:     file format elf32-littlearm


Disassembly of section .text:

080000e4 <__NVIC_EnableIRQ>:
  \details Enables a device specific interrupt in the NVIC interrupt controller.
  \param [in]      IRQn  Device specific interrupt number.
  \note    IRQn must not be negative.
 */
__STATIC_INLINE void __NVIC_EnableIRQ(IRQn_Type IRQn)
{
 80000e4:	b480      	push	{r7}
 80000e6:	b083      	sub	sp, #12
 80000e8:	af00      	add	r7, sp, #0
 80000ea:	4603      	mov	r3, r0
 80000ec:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 80000ee:	f997 3007 	ldrsb.w	r3, [r7, #7]
 80000f2:	2b00      	cmp	r3, #0
 80000f4:	db0b      	blt.n	800010e <__NVIC_EnableIRQ+0x2a>
  {
    __COMPILER_BARRIER();
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 80000f6:	79fb      	ldrb	r3, [r7, #7]
 80000f8:	f003 021f 	and.w	r2, r3, #31
 80000fc:	4906      	ldr	r1, [pc, #24]	@ (8000118 <__NVIC_EnableIRQ+0x34>)
 80000fe:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000102:	095b      	lsrs	r3, r3, #5
 8000104:	2001      	movs	r0, #1
 8000106:	fa00 f202 	lsl.w	r2, r0, r2
 800010a:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
    __COMPILER_BARRIER();
  }
}
 800010e:	bf00      	nop
 8000110:	370c      	adds	r7, #12
 8000112:	46bd      	mov	sp, r7
 8000114:	bc80      	pop	{r7}
 8000116:	4770      	bx	lr
 8000118:	e000e100 	.word	0xe000e100

0800011c <__usart1_scan>:
#include "stm32f401xe.h"

#define TX_PIN 9
#define RX_PIN 10

void __usart1_scan (char* buffer, uint16_t size){
 800011c:	b480      	push	{r7}
 800011e:	b085      	sub	sp, #20
 8000120:	af00      	add	r7, sp, #0
 8000122:	6078      	str	r0, [r7, #4]
 8000124:	460b      	mov	r3, r1
 8000126:	807b      	strh	r3, [r7, #2]
  
  uint16_t i = 0;
 8000128:	2300      	movs	r3, #0
 800012a:	81fb      	strh	r3, [r7, #14]
  while (i < size) {
 800012c:	e010      	b.n	8000150 <__usart1_scan+0x34>
    // wait
    while (!(USART1->SR & USART_SR_RXNE))
 800012e:	bf00      	nop
 8000130:	4b0c      	ldr	r3, [pc, #48]	@ (8000164 <__usart1_scan+0x48>)
 8000132:	681b      	ldr	r3, [r3, #0]
 8000134:	f003 0320 	and.w	r3, r3, #32
 8000138:	2b00      	cmp	r3, #0
 800013a:	d0f9      	beq.n	8000130 <__usart1_scan+0x14>
      ;
    buffer[i++] = USART1->DR;
 800013c:	4b09      	ldr	r3, [pc, #36]	@ (8000164 <__usart1_scan+0x48>)
 800013e:	685a      	ldr	r2, [r3, #4]
 8000140:	89fb      	ldrh	r3, [r7, #14]
 8000142:	1c59      	adds	r1, r3, #1
 8000144:	81f9      	strh	r1, [r7, #14]
 8000146:	4619      	mov	r1, r3
 8000148:	687b      	ldr	r3, [r7, #4]
 800014a:	440b      	add	r3, r1
 800014c:	b2d2      	uxtb	r2, r2
 800014e:	701a      	strb	r2, [r3, #0]
  while (i < size) {
 8000150:	89fa      	ldrh	r2, [r7, #14]
 8000152:	887b      	ldrh	r3, [r7, #2]
 8000154:	429a      	cmp	r2, r3
 8000156:	d3ea      	bcc.n	800012e <__usart1_scan+0x12>
  }
}
 8000158:	bf00      	nop
 800015a:	bf00      	nop
 800015c:	3714      	adds	r7, #20
 800015e:	46bd      	mov	sp, r7
 8000160:	bc80      	pop	{r7}
 8000162:	4770      	bx	lr
 8000164:	40011000 	.word	0x40011000

08000168 <__usart1_init>:

void __usart1_init(void) {
 8000168:	b580      	push	{r7, lr}
 800016a:	af00      	add	r7, sp, #0

  RCC->APB2ENR |= RCC_APB2ENR_USART1EN_Msk;
 800016c:	4b20      	ldr	r3, [pc, #128]	@ (80001f0 <__usart1_init+0x88>)
 800016e:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8000170:	4a1f      	ldr	r2, [pc, #124]	@ (80001f0 <__usart1_init+0x88>)
 8000172:	f043 0310 	orr.w	r3, r3, #16
 8000176:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
 8000178:	4b1d      	ldr	r3, [pc, #116]	@ (80001f0 <__usart1_init+0x88>)
 800017a:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 800017c:	4a1c      	ldr	r2, [pc, #112]	@ (80001f0 <__usart1_init+0x88>)
 800017e:	f043 0301 	orr.w	r3, r3, #1
 8000182:	6313      	str	r3, [r2, #48]	@ 0x30
  // alternate function mode
  GPIOA->MODER &= ~((3 << (2 * TX_PIN)) | (3 << (2 * RX_PIN)));
 8000184:	4b1b      	ldr	r3, [pc, #108]	@ (80001f4 <__usart1_init+0x8c>)
 8000186:	681b      	ldr	r3, [r3, #0]
 8000188:	4a1a      	ldr	r2, [pc, #104]	@ (80001f4 <__usart1_init+0x8c>)
 800018a:	f423 1370 	bic.w	r3, r3, #3932160	@ 0x3c0000
 800018e:	6013      	str	r3, [r2, #0]
  GPIOA->MODER |= 2 << (2 * TX_PIN) | 2 << (2 * RX_PIN);
 8000190:	4b18      	ldr	r3, [pc, #96]	@ (80001f4 <__usart1_init+0x8c>)
 8000192:	681b      	ldr	r3, [r3, #0]
 8000194:	4a17      	ldr	r2, [pc, #92]	@ (80001f4 <__usart1_init+0x8c>)
 8000196:	f443 1320 	orr.w	r3, r3, #2621440	@ 0x280000
 800019a:	6013      	str	r3, [r2, #0]
  // high speed
  GPIOA->OSPEEDR |= (3 << (TX_PIN * 2)) | (3 << (RX_PIN * 2));
 800019c:	4b15      	ldr	r3, [pc, #84]	@ (80001f4 <__usart1_init+0x8c>)
 800019e:	689b      	ldr	r3, [r3, #8]
 80001a0:	4a14      	ldr	r2, [pc, #80]	@ (80001f4 <__usart1_init+0x8c>)
 80001a2:	f443 1370 	orr.w	r3, r3, #3932160	@ 0x3c0000
 80001a6:	6093      	str	r3, [r2, #8]
  // clear the bits in AFR register
  GPIOA->AFR[1] &= ~((0xf << 4) | (0xf << 8));
 80001a8:	4b12      	ldr	r3, [pc, #72]	@ (80001f4 <__usart1_init+0x8c>)
 80001aa:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80001ac:	4a11      	ldr	r2, [pc, #68]	@ (80001f4 <__usart1_init+0x8c>)
 80001ae:	f423 637f 	bic.w	r3, r3, #4080	@ 0xff0
 80001b2:	6253      	str	r3, [r2, #36]	@ 0x24
  // set for af7
  GPIOA->AFR[1] |= (7 << 4) | (7 << 8);
 80001b4:	4b0f      	ldr	r3, [pc, #60]	@ (80001f4 <__usart1_init+0x8c>)
 80001b6:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80001b8:	4a0e      	ldr	r2, [pc, #56]	@ (80001f4 <__usart1_init+0x8c>)
 80001ba:	f443 63ee 	orr.w	r3, r3, #1904	@ 0x770
 80001be:	6253      	str	r3, [r2, #36]	@ 0x24

  // set the baud rate (115200 in this case)
  USART1->BRR = 0x08B;
 80001c0:	4b0d      	ldr	r3, [pc, #52]	@ (80001f8 <__usart1_init+0x90>)
 80001c2:	228b      	movs	r2, #139	@ 0x8b
 80001c4:	609a      	str	r2, [r3, #8]

  // enable usart reciever interrupt;
  USART1->CR1 = USART_CR1_RXNEIE;
 80001c6:	4b0c      	ldr	r3, [pc, #48]	@ (80001f8 <__usart1_init+0x90>)
 80001c8:	2220      	movs	r2, #32
 80001ca:	60da      	str	r2, [r3, #12]

  NVIC_EnableIRQ (USART1_IRQn);
 80001cc:	2025      	movs	r0, #37	@ 0x25
 80001ce:	f7ff ff89 	bl	80000e4 <__NVIC_EnableIRQ>

  // enable transmitter and reciever at the end
  USART1->CR1 |= USART_CR1_RE | USART_CR1_TE;
 80001d2:	4b09      	ldr	r3, [pc, #36]	@ (80001f8 <__usart1_init+0x90>)
 80001d4:	68db      	ldr	r3, [r3, #12]
 80001d6:	4a08      	ldr	r2, [pc, #32]	@ (80001f8 <__usart1_init+0x90>)
 80001d8:	f043 030c 	orr.w	r3, r3, #12
 80001dc:	60d3      	str	r3, [r2, #12]

  // enable usart
  USART1->CR1 |= USART_CR1_UE;
 80001de:	4b06      	ldr	r3, [pc, #24]	@ (80001f8 <__usart1_init+0x90>)
 80001e0:	68db      	ldr	r3, [r3, #12]
 80001e2:	4a05      	ldr	r2, [pc, #20]	@ (80001f8 <__usart1_init+0x90>)
 80001e4:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 80001e8:	60d3      	str	r3, [r2, #12]

}
 80001ea:	bf00      	nop
 80001ec:	bd80      	pop	{r7, pc}
 80001ee:	bf00      	nop
 80001f0:	40023800 	.word	0x40023800
 80001f4:	40020000 	.word	0x40020000
 80001f8:	40011000 	.word	0x40011000

080001fc <__usart1_print>:

void __usart1_print(const char *msg, uint32_t size) {
 80001fc:	b480      	push	{r7}
 80001fe:	b085      	sub	sp, #20
 8000200:	af00      	add	r7, sp, #0
 8000202:	6078      	str	r0, [r7, #4]
 8000204:	6039      	str	r1, [r7, #0]

  int i = 0;
 8000206:	2300      	movs	r3, #0
 8000208:	60fb      	str	r3, [r7, #12]
  while (i < size && msg[i] != '\0') {
 800020a:	e00f      	b.n	800022c <__usart1_print+0x30>
    while (!(USART1->SR & USART_SR_TXE))
 800020c:	bf00      	nop
 800020e:	4b13      	ldr	r3, [pc, #76]	@ (800025c <__usart1_print+0x60>)
 8000210:	681b      	ldr	r3, [r3, #0]
 8000212:	f003 0380 	and.w	r3, r3, #128	@ 0x80
 8000216:	2b00      	cmp	r3, #0
 8000218:	d0f9      	beq.n	800020e <__usart1_print+0x12>
      ;
    USART1->DR = msg[i++];
 800021a:	68fb      	ldr	r3, [r7, #12]
 800021c:	1c5a      	adds	r2, r3, #1
 800021e:	60fa      	str	r2, [r7, #12]
 8000220:	461a      	mov	r2, r3
 8000222:	687b      	ldr	r3, [r7, #4]
 8000224:	4413      	add	r3, r2
 8000226:	781a      	ldrb	r2, [r3, #0]
 8000228:	4b0c      	ldr	r3, [pc, #48]	@ (800025c <__usart1_print+0x60>)
 800022a:	605a      	str	r2, [r3, #4]
  while (i < size && msg[i] != '\0') {
 800022c:	68fb      	ldr	r3, [r7, #12]
 800022e:	683a      	ldr	r2, [r7, #0]
 8000230:	429a      	cmp	r2, r3
 8000232:	d905      	bls.n	8000240 <__usart1_print+0x44>
 8000234:	68fb      	ldr	r3, [r7, #12]
 8000236:	687a      	ldr	r2, [r7, #4]
 8000238:	4413      	add	r3, r2
 800023a:	781b      	ldrb	r3, [r3, #0]
 800023c:	2b00      	cmp	r3, #0
 800023e:	d1e5      	bne.n	800020c <__usart1_print+0x10>
  }
  while (!(USART1->SR & USART_SR_TC)) {
 8000240:	bf00      	nop
 8000242:	4b06      	ldr	r3, [pc, #24]	@ (800025c <__usart1_print+0x60>)
 8000244:	681b      	ldr	r3, [r3, #0]
 8000246:	f003 0340 	and.w	r3, r3, #64	@ 0x40
 800024a:	2b00      	cmp	r3, #0
 800024c:	d0f9      	beq.n	8000242 <__usart1_print+0x46>
  }
}
 800024e:	bf00      	nop
 8000250:	bf00      	nop
 8000252:	3714      	adds	r7, #20
 8000254:	46bd      	mov	sp, r7
 8000256:	bc80      	pop	{r7}
 8000258:	4770      	bx	lr
 800025a:	bf00      	nop
 800025c:	40011000 	.word	0x40011000

08000260 <erase_flash>:
#define KEY1 0x45670123
#define KEY2 0xCDEF89AB

void printf (const char *string, uint32_t addr);

uint32_t erase_flash(uint32_t address) {
 8000260:	b580      	push	{r7, lr}
 8000262:	b084      	sub	sp, #16
 8000264:	af00      	add	r7, sp, #0
 8000266:	6078      	str	r0, [r7, #4]
  if (address >= 0x08080000 || address < 0x08000000) {
 8000268:	687b      	ldr	r3, [r7, #4]
 800026a:	4a4c      	ldr	r2, [pc, #304]	@ (800039c <erase_flash+0x13c>)
 800026c:	4293      	cmp	r3, r2
 800026e:	d803      	bhi.n	8000278 <erase_flash+0x18>
 8000270:	687b      	ldr	r3, [r7, #4]
 8000272:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 8000276:	d206      	bcs.n	8000286 <erase_flash+0x26>
    printf("wrong address \n\r", 0x0);
 8000278:	2100      	movs	r1, #0
 800027a:	4849      	ldr	r0, [pc, #292]	@ (80003a0 <erase_flash+0x140>)
 800027c:	f000 fab6 	bl	80007ec <printf>
    return -1;
 8000280:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 8000284:	e085      	b.n	8000392 <erase_flash+0x132>
  }

  uint32_t sector = 0;
 8000286:	2300      	movs	r3, #0
 8000288:	60fb      	str	r3, [r7, #12]
  if (address >= 0x08060000)
 800028a:	687b      	ldr	r3, [r7, #4]
 800028c:	4a45      	ldr	r2, [pc, #276]	@ (80003a4 <erase_flash+0x144>)
 800028e:	4293      	cmp	r3, r2
 8000290:	d902      	bls.n	8000298 <erase_flash+0x38>
    sector = 7;
 8000292:	2307      	movs	r3, #7
 8000294:	60fb      	str	r3, [r7, #12]
 8000296:	e037      	b.n	8000308 <erase_flash+0xa8>
  else if (address >= 0x08040000)
 8000298:	687b      	ldr	r3, [r7, #4]
 800029a:	4a43      	ldr	r2, [pc, #268]	@ (80003a8 <erase_flash+0x148>)
 800029c:	4293      	cmp	r3, r2
 800029e:	d902      	bls.n	80002a6 <erase_flash+0x46>
    sector = 6;
 80002a0:	2306      	movs	r3, #6
 80002a2:	60fb      	str	r3, [r7, #12]
 80002a4:	e030      	b.n	8000308 <erase_flash+0xa8>
  else if (address >= 0x08020000)
 80002a6:	687b      	ldr	r3, [r7, #4]
 80002a8:	4a40      	ldr	r2, [pc, #256]	@ (80003ac <erase_flash+0x14c>)
 80002aa:	4293      	cmp	r3, r2
 80002ac:	d902      	bls.n	80002b4 <erase_flash+0x54>
    sector = 5;
 80002ae:	2305      	movs	r3, #5
 80002b0:	60fb      	str	r3, [r7, #12]
 80002b2:	e029      	b.n	8000308 <erase_flash+0xa8>
  else if (address >= 0x08010000)
 80002b4:	687b      	ldr	r3, [r7, #4]
 80002b6:	4a3e      	ldr	r2, [pc, #248]	@ (80003b0 <erase_flash+0x150>)
 80002b8:	4293      	cmp	r3, r2
 80002ba:	d902      	bls.n	80002c2 <erase_flash+0x62>
    sector = 4;
 80002bc:	2304      	movs	r3, #4
 80002be:	60fb      	str	r3, [r7, #12]
 80002c0:	e022      	b.n	8000308 <erase_flash+0xa8>
  else if (address >= 0x0800c000)
 80002c2:	687b      	ldr	r3, [r7, #4]
 80002c4:	4a3b      	ldr	r2, [pc, #236]	@ (80003b4 <erase_flash+0x154>)
 80002c6:	4293      	cmp	r3, r2
 80002c8:	d302      	bcc.n	80002d0 <erase_flash+0x70>
    sector = 3;
 80002ca:	2303      	movs	r3, #3
 80002cc:	60fb      	str	r3, [r7, #12]
 80002ce:	e01b      	b.n	8000308 <erase_flash+0xa8>
  else if (address >= 0x08008000)
 80002d0:	687b      	ldr	r3, [r7, #4]
 80002d2:	4a39      	ldr	r2, [pc, #228]	@ (80003b8 <erase_flash+0x158>)
 80002d4:	4293      	cmp	r3, r2
 80002d6:	d302      	bcc.n	80002de <erase_flash+0x7e>
    sector = 2;
 80002d8:	2302      	movs	r3, #2
 80002da:	60fb      	str	r3, [r7, #12]
 80002dc:	e014      	b.n	8000308 <erase_flash+0xa8>
  else if (address >= 0x08004000)
 80002de:	687b      	ldr	r3, [r7, #4]
 80002e0:	4a36      	ldr	r2, [pc, #216]	@ (80003bc <erase_flash+0x15c>)
 80002e2:	4293      	cmp	r3, r2
 80002e4:	d302      	bcc.n	80002ec <erase_flash+0x8c>
    sector = 1;
 80002e6:	2301      	movs	r3, #1
 80002e8:	60fb      	str	r3, [r7, #12]
 80002ea:	e00d      	b.n	8000308 <erase_flash+0xa8>
  else if (address >= 0x08000000)
 80002ec:	687b      	ldr	r3, [r7, #4]
 80002ee:	f1b3 6f00 	cmp.w	r3, #134217728	@ 0x8000000
 80002f2:	d302      	bcc.n	80002fa <erase_flash+0x9a>
    sector = 0;
 80002f4:	2300      	movs	r3, #0
 80002f6:	60fb      	str	r3, [r7, #12]
 80002f8:	e006      	b.n	8000308 <erase_flash+0xa8>
  else {
    printf("wrong address\n\r", 0x0);
 80002fa:	2100      	movs	r1, #0
 80002fc:	4830      	ldr	r0, [pc, #192]	@ (80003c0 <erase_flash+0x160>)
 80002fe:	f000 fa75 	bl	80007ec <printf>
    return -1;
 8000302:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 8000306:	e044      	b.n	8000392 <erase_flash+0x132>
  }
  // unlock
  FLASH->KEYR = KEY1;
 8000308:	4b2e      	ldr	r3, [pc, #184]	@ (80003c4 <erase_flash+0x164>)
 800030a:	4a2f      	ldr	r2, [pc, #188]	@ (80003c8 <erase_flash+0x168>)
 800030c:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 800030e:	4b2d      	ldr	r3, [pc, #180]	@ (80003c4 <erase_flash+0x164>)
 8000310:	4a2e      	ldr	r2, [pc, #184]	@ (80003cc <erase_flash+0x16c>)
 8000312:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 8000314:	4b2b      	ldr	r3, [pc, #172]	@ (80003c4 <erase_flash+0x164>)
 8000316:	68db      	ldr	r3, [r3, #12]
 8000318:	4a2a      	ldr	r2, [pc, #168]	@ (80003c4 <erase_flash+0x164>)
 800031a:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 800031e:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 8000320:	bf00      	nop
 8000322:	4b28      	ldr	r3, [pc, #160]	@ (80003c4 <erase_flash+0x164>)
 8000324:	68db      	ldr	r3, [r3, #12]
 8000326:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 800032a:	2b00      	cmp	r3, #0
 800032c:	d1f9      	bne.n	8000322 <erase_flash+0xc2>
    ;

  FLASH->CR |= FLASH_CR_SER;
 800032e:	4b25      	ldr	r3, [pc, #148]	@ (80003c4 <erase_flash+0x164>)
 8000330:	691b      	ldr	r3, [r3, #16]
 8000332:	4a24      	ldr	r2, [pc, #144]	@ (80003c4 <erase_flash+0x164>)
 8000334:	f043 0302 	orr.w	r3, r3, #2
 8000338:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(FLASH_CR_SNB);
 800033a:	4b22      	ldr	r3, [pc, #136]	@ (80003c4 <erase_flash+0x164>)
 800033c:	691b      	ldr	r3, [r3, #16]
 800033e:	4a21      	ldr	r2, [pc, #132]	@ (80003c4 <erase_flash+0x164>)
 8000340:	f023 03f8 	bic.w	r3, r3, #248	@ 0xf8
 8000344:	6113      	str	r3, [r2, #16]
  FLASH->CR |= (sector << FLASH_CR_SNB_Pos);
 8000346:	4b1f      	ldr	r3, [pc, #124]	@ (80003c4 <erase_flash+0x164>)
 8000348:	691a      	ldr	r2, [r3, #16]
 800034a:	68fb      	ldr	r3, [r7, #12]
 800034c:	00db      	lsls	r3, r3, #3
 800034e:	491d      	ldr	r1, [pc, #116]	@ (80003c4 <erase_flash+0x164>)
 8000350:	4313      	orrs	r3, r2
 8000352:	610b      	str	r3, [r1, #16]
  FLASH->CR |= FLASH_CR_STRT;
 8000354:	4b1b      	ldr	r3, [pc, #108]	@ (80003c4 <erase_flash+0x164>)
 8000356:	691b      	ldr	r3, [r3, #16]
 8000358:	4a1a      	ldr	r2, [pc, #104]	@ (80003c4 <erase_flash+0x164>)
 800035a:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 800035e:	6113      	str	r3, [r2, #16]

  // wait for the flash to be erased;
  while (FLASH->SR & FLASH_SR_BSY)
 8000360:	bf00      	nop
 8000362:	4b18      	ldr	r3, [pc, #96]	@ (80003c4 <erase_flash+0x164>)
 8000364:	68db      	ldr	r3, [r3, #12]
 8000366:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 800036a:	2b00      	cmp	r3, #0
 800036c:	d1f9      	bne.n	8000362 <erase_flash+0x102>
    ;

  // clear the erase bit
  FLASH->CR &= ~(FLASH_CR_SER);
 800036e:	4b15      	ldr	r3, [pc, #84]	@ (80003c4 <erase_flash+0x164>)
 8000370:	691b      	ldr	r3, [r3, #16]
 8000372:	4a14      	ldr	r2, [pc, #80]	@ (80003c4 <erase_flash+0x164>)
 8000374:	f023 0302 	bic.w	r3, r3, #2
 8000378:	6113      	str	r3, [r2, #16]
  // lock the control register
  FLASH->CR |= FLASH_CR_LOCK;
 800037a:	4b12      	ldr	r3, [pc, #72]	@ (80003c4 <erase_flash+0x164>)
 800037c:	691b      	ldr	r3, [r3, #16]
 800037e:	4a11      	ldr	r2, [pc, #68]	@ (80003c4 <erase_flash+0x164>)
 8000380:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 8000384:	6113      	str	r3, [r2, #16]

  printf("done erasing flash (address = %)\n\r", (uint32_t)(&address));
 8000386:	1d3b      	adds	r3, r7, #4
 8000388:	4619      	mov	r1, r3
 800038a:	4811      	ldr	r0, [pc, #68]	@ (80003d0 <erase_flash+0x170>)
 800038c:	f000 fa2e 	bl	80007ec <printf>
  return 0;
 8000390:	2300      	movs	r3, #0
}
 8000392:	4618      	mov	r0, r3
 8000394:	3710      	adds	r7, #16
 8000396:	46bd      	mov	sp, r7
 8000398:	bd80      	pop	{r7, pc}
 800039a:	bf00      	nop
 800039c:	0807ffff 	.word	0x0807ffff
 80003a0:	0800147c 	.word	0x0800147c
 80003a4:	0805ffff 	.word	0x0805ffff
 80003a8:	0803ffff 	.word	0x0803ffff
 80003ac:	0801ffff 	.word	0x0801ffff
 80003b0:	0800ffff 	.word	0x0800ffff
 80003b4:	0800c000 	.word	0x0800c000
 80003b8:	08008000 	.word	0x08008000
 80003bc:	08004000 	.word	0x08004000
 80003c0:	08001490 	.word	0x08001490
 80003c4:	40023c00 	.word	0x40023c00
 80003c8:	45670123 	.word	0x45670123
 80003cc:	cdef89ab 	.word	0xcdef89ab
 80003d0:	080014a0 	.word	0x080014a0

080003d4 <flash_write>:

uint32_t flash_write(uint32_t address, const char *buff, uint32_t size,
                     uint32_t simulate) {
 80003d4:	b480      	push	{r7}
 80003d6:	b087      	sub	sp, #28
 80003d8:	af00      	add	r7, sp, #0
 80003da:	60f8      	str	r0, [r7, #12]
 80003dc:	60b9      	str	r1, [r7, #8]
 80003de:	607a      	str	r2, [r7, #4]
 80003e0:	603b      	str	r3, [r7, #0]


  // unlock
  FLASH->KEYR = KEY1;
 80003e2:	4b26      	ldr	r3, [pc, #152]	@ (800047c <flash_write+0xa8>)
 80003e4:	4a26      	ldr	r2, [pc, #152]	@ (8000480 <flash_write+0xac>)
 80003e6:	605a      	str	r2, [r3, #4]
  FLASH->KEYR = KEY2;
 80003e8:	4b24      	ldr	r3, [pc, #144]	@ (800047c <flash_write+0xa8>)
 80003ea:	4a26      	ldr	r2, [pc, #152]	@ (8000484 <flash_write+0xb0>)
 80003ec:	605a      	str	r2, [r3, #4]

  FLASH->SR |= FLASH_SR_EOP |    // End of operation
 80003ee:	4b23      	ldr	r3, [pc, #140]	@ (800047c <flash_write+0xa8>)
 80003f0:	68db      	ldr	r3, [r3, #12]
 80003f2:	4a22      	ldr	r2, [pc, #136]	@ (800047c <flash_write+0xa8>)
 80003f4:	f043 03f3 	orr.w	r3, r3, #243	@ 0xf3
 80003f8:	60d3      	str	r3, [r2, #12]
               FLASH_SR_PGAERR | // Programming alignment error
               FLASH_SR_PGPERR | // Programming parallelism error
               FLASH_SR_PGSERR;  // Programming sequence error

  // wait for operation to be done
  while (FLASH->SR & FLASH_SR_BSY)
 80003fa:	bf00      	nop
 80003fc:	4b1f      	ldr	r3, [pc, #124]	@ (800047c <flash_write+0xa8>)
 80003fe:	68db      	ldr	r3, [r3, #12]
 8000400:	f403 3380 	and.w	r3, r3, #65536	@ 0x10000
 8000404:	2b00      	cmp	r3, #0
 8000406:	d1f9      	bne.n	80003fc <flash_write+0x28>
    ;
  FLASH->CR |= FLASH_CR_PG;
 8000408:	4b1c      	ldr	r3, [pc, #112]	@ (800047c <flash_write+0xa8>)
 800040a:	691b      	ldr	r3, [r3, #16]
 800040c:	4a1b      	ldr	r2, [pc, #108]	@ (800047c <flash_write+0xa8>)
 800040e:	f043 0301 	orr.w	r3, r3, #1
 8000412:	6113      	str	r3, [r2, #16]
  FLASH->CR &= ~(3 << FLASH_CR_PSIZE_Pos);
 8000414:	4b19      	ldr	r3, [pc, #100]	@ (800047c <flash_write+0xa8>)
 8000416:	691b      	ldr	r3, [r3, #16]
 8000418:	4a18      	ldr	r2, [pc, #96]	@ (800047c <flash_write+0xa8>)
 800041a:	f423 7340 	bic.w	r3, r3, #768	@ 0x300
 800041e:	6113      	str	r3, [r2, #16]
  // set PSIZE bit to 2 for 32 bit programming
  FLASH->CR |= 2 << FLASH_CR_PSIZE_Pos;
 8000420:	4b16      	ldr	r3, [pc, #88]	@ (800047c <flash_write+0xa8>)
 8000422:	691b      	ldr	r3, [r3, #16]
 8000424:	4a15      	ldr	r2, [pc, #84]	@ (800047c <flash_write+0xa8>)
 8000426:	f443 7300 	orr.w	r3, r3, #512	@ 0x200
 800042a:	6113      	str	r3, [r2, #16]

  uint32_t i = 0;
 800042c:	2300      	movs	r3, #0
 800042e:	617b      	str	r3, [r7, #20]
  while (i < size / 4) {
 8000430:	e00c      	b.n	800044c <flash_write+0x78>

    *((uint32_t *)address) = ((const uint32_t *)buff)[i];
 8000432:	697b      	ldr	r3, [r7, #20]
 8000434:	009b      	lsls	r3, r3, #2
 8000436:	68ba      	ldr	r2, [r7, #8]
 8000438:	441a      	add	r2, r3
 800043a:	68fb      	ldr	r3, [r7, #12]
 800043c:	6812      	ldr	r2, [r2, #0]
 800043e:	601a      	str	r2, [r3, #0]
    i++;
 8000440:	697b      	ldr	r3, [r7, #20]
 8000442:	3301      	adds	r3, #1
 8000444:	617b      	str	r3, [r7, #20]
    address += 4;
 8000446:	68fb      	ldr	r3, [r7, #12]
 8000448:	3304      	adds	r3, #4
 800044a:	60fb      	str	r3, [r7, #12]
  while (i < size / 4) {
 800044c:	687b      	ldr	r3, [r7, #4]
 800044e:	089b      	lsrs	r3, r3, #2
 8000450:	697a      	ldr	r2, [r7, #20]
 8000452:	429a      	cmp	r2, r3
 8000454:	d3ed      	bcc.n	8000432 <flash_write+0x5e>
  }
  FLASH->CR &= ~(FLASH_CR_PG);
 8000456:	4b09      	ldr	r3, [pc, #36]	@ (800047c <flash_write+0xa8>)
 8000458:	691b      	ldr	r3, [r3, #16]
 800045a:	4a08      	ldr	r2, [pc, #32]	@ (800047c <flash_write+0xa8>)
 800045c:	f023 0301 	bic.w	r3, r3, #1
 8000460:	6113      	str	r3, [r2, #16]
  FLASH->CR |= FLASH_CR_LOCK;
 8000462:	4b06      	ldr	r3, [pc, #24]	@ (800047c <flash_write+0xa8>)
 8000464:	691b      	ldr	r3, [r3, #16]
 8000466:	4a05      	ldr	r2, [pc, #20]	@ (800047c <flash_write+0xa8>)
 8000468:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
 800046c:	6113      	str	r3, [r2, #16]

  return 0;
 800046e:	2300      	movs	r3, #0
}
 8000470:	4618      	mov	r0, r3
 8000472:	371c      	adds	r7, #28
 8000474:	46bd      	mov	sp, r7
 8000476:	bc80      	pop	{r7}
 8000478:	4770      	bx	lr
 800047a:	bf00      	nop
 800047c:	40023c00 	.word	0x40023c00
 8000480:	45670123 	.word	0x45670123
 8000484:	cdef89ab 	.word	0xcdef89ab

08000488 <crc_calc>:
#include "core.h"

// refine !!!!

uint32_t crc_calc (firmware_t *fw){
 8000488:	b480      	push	{r7}
 800048a:	b085      	sub	sp, #20
 800048c:	af00      	add	r7, sp, #0
 800048e:	6078      	str	r0, [r7, #4]

    RCC-> AHB1ENR |= RCC_AHB1ENR_CRCEN;
 8000490:	4b11      	ldr	r3, [pc, #68]	@ (80004d8 <crc_calc+0x50>)
 8000492:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8000494:	4a10      	ldr	r2, [pc, #64]	@ (80004d8 <crc_calc+0x50>)
 8000496:	f443 5380 	orr.w	r3, r3, #4096	@ 0x1000
 800049a:	6313      	str	r3, [r2, #48]	@ 0x30
    CRC-> CR |= CRC_CR_RESET;
 800049c:	4b0f      	ldr	r3, [pc, #60]	@ (80004dc <crc_calc+0x54>)
 800049e:	689b      	ldr	r3, [r3, #8]
 80004a0:	4a0e      	ldr	r2, [pc, #56]	@ (80004dc <crc_calc+0x54>)
 80004a2:	f043 0301 	orr.w	r3, r3, #1
 80004a6:	6093      	str	r3, [r2, #8]
    // last address is the next free address
    for (uint32_t i=fw->__crc_start_addr; i<fw->__crc_end_addr; i+=4){
 80004a8:	687b      	ldr	r3, [r7, #4]
 80004aa:	691b      	ldr	r3, [r3, #16]
 80004ac:	60fb      	str	r3, [r7, #12]
 80004ae:	e006      	b.n	80004be <crc_calc+0x36>
        CRC-> DR = *((uint32_t*) i);
 80004b0:	68fb      	ldr	r3, [r7, #12]
 80004b2:	4a0a      	ldr	r2, [pc, #40]	@ (80004dc <crc_calc+0x54>)
 80004b4:	681b      	ldr	r3, [r3, #0]
 80004b6:	6013      	str	r3, [r2, #0]
    for (uint32_t i=fw->__crc_start_addr; i<fw->__crc_end_addr; i+=4){
 80004b8:	68fb      	ldr	r3, [r7, #12]
 80004ba:	3304      	adds	r3, #4
 80004bc:	60fb      	str	r3, [r7, #12]
 80004be:	687b      	ldr	r3, [r7, #4]
 80004c0:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 80004c2:	68fa      	ldr	r2, [r7, #12]
 80004c4:	429a      	cmp	r2, r3
 80004c6:	d3f3      	bcc.n	80004b0 <crc_calc+0x28>
    }
    
    return CRC-> DR;
 80004c8:	4b04      	ldr	r3, [pc, #16]	@ (80004dc <crc_calc+0x54>)
 80004ca:	681b      	ldr	r3, [r3, #0]
}
 80004cc:	4618      	mov	r0, r3
 80004ce:	3714      	adds	r7, #20
 80004d0:	46bd      	mov	sp, r7
 80004d2:	bc80      	pop	{r7}
 80004d4:	4770      	bx	lr
 80004d6:	bf00      	nop
 80004d8:	40023800 	.word	0x40023800
 80004dc:	40023000 	.word	0x40023000

080004e0 <fault_handler_helper>:
#include "core.h"
#include <stdint.h>


void fault_handler_helper(uint32_t pc, uint8_t fault_identifier,
                          uint32_t fault_place) {
 80004e0:	b580      	push	{r7, lr}
 80004e2:	b086      	sub	sp, #24
 80004e4:	af00      	add	r7, sp, #0
 80004e6:	60f8      	str	r0, [r7, #12]
 80004e8:	460b      	mov	r3, r1
 80004ea:	607a      	str	r2, [r7, #4]
 80004ec:	72fb      	strb	r3, [r7, #11]

  /* bus fault diagnosis */
  if (fault_identifier == BUSFAULT_IDENTIFIER) {
 80004ee:	7afb      	ldrb	r3, [r7, #11]
 80004f0:	2b00      	cmp	r3, #0
 80004f2:	d10e      	bne.n	8000512 <fault_handler_helper+0x32>
    printf("busdault !!\n\r", 0x0);
 80004f4:	2100      	movs	r1, #0
 80004f6:	4820      	ldr	r0, [pc, #128]	@ (8000578 <fault_handler_helper+0x98>)
 80004f8:	f000 f978 	bl	80007ec <printf>
    if (SCB->CFSR & SCB_CFSR_BFARVALID_Msk)
 80004fc:	4b1f      	ldr	r3, [pc, #124]	@ (800057c <fault_handler_helper+0x9c>)
 80004fe:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 8000500:	f403 4300 	and.w	r3, r3, #32768	@ 0x8000
 8000504:	2b00      	cmp	r3, #0
 8000506:	d01f      	beq.n	8000548 <fault_handler_helper+0x68>
      printf("busfault address -> %\n\r", (uint32_t)(&SCB->BFAR));
 8000508:	491d      	ldr	r1, [pc, #116]	@ (8000580 <fault_handler_helper+0xa0>)
 800050a:	481e      	ldr	r0, [pc, #120]	@ (8000584 <fault_handler_helper+0xa4>)
 800050c:	f000 f96e 	bl	80007ec <printf>
 8000510:	e01a      	b.n	8000548 <fault_handler_helper+0x68>
  }

  /* MemManagement diagnosis */
  else if (fault_identifier == MEMMANAGE_IDENTIFIER) {
 8000512:	7afb      	ldrb	r3, [r7, #11]
 8000514:	2b01      	cmp	r3, #1
 8000516:	d110      	bne.n	800053a <fault_handler_helper+0x5a>
    printf("MemManagement exception !!\n\r", 0x0);
 8000518:	2100      	movs	r1, #0
 800051a:	481b      	ldr	r0, [pc, #108]	@ (8000588 <fault_handler_helper+0xa8>)
 800051c:	f000 f966 	bl	80007ec <printf>
    if (SCB->CFSR & SCB_CFSR_MMARVALID_Msk)
 8000520:	4b16      	ldr	r3, [pc, #88]	@ (800057c <fault_handler_helper+0x9c>)
 8000522:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
 8000524:	f003 0380 	and.w	r3, r3, #128	@ 0x80
 8000528:	2b00      	cmp	r3, #0
 800052a:	d00d      	beq.n	8000548 <fault_handler_helper+0x68>
      printf("address caused MemManage Fault -> %\n\r", SCB->MMFAR);
 800052c:	4b13      	ldr	r3, [pc, #76]	@ (800057c <fault_handler_helper+0x9c>)
 800052e:	6b5b      	ldr	r3, [r3, #52]	@ 0x34
 8000530:	4619      	mov	r1, r3
 8000532:	4816      	ldr	r0, [pc, #88]	@ (800058c <fault_handler_helper+0xac>)
 8000534:	f000 f95a 	bl	80007ec <printf>
 8000538:	e006      	b.n	8000548 <fault_handler_helper+0x68>
  }

  /* UsageFault diagnosis */
  else if (fault_identifier == USAGEFAULT_IDENTIFIER) {
 800053a:	7afb      	ldrb	r3, [r7, #11]
 800053c:	2b02      	cmp	r3, #2
 800053e:	d117      	bne.n	8000570 <fault_handler_helper+0x90>
    printf("UsageFault !!\n\r", 0x0);
 8000540:	2100      	movs	r1, #0
 8000542:	4813      	ldr	r0, [pc, #76]	@ (8000590 <fault_handler_helper+0xb0>)
 8000544:	f000 f952 	bl	80007ec <printf>
    /* there is no address access that can cause USAGE FAULT */
  } else {
    return;
  }

  uint32_t instruction = *(uint32_t *)(pc);
 8000548:	68fb      	ldr	r3, [r7, #12]
 800054a:	681b      	ldr	r3, [r3, #0]
 800054c:	617b      	str	r3, [r7, #20]

  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
 800054e:	4911      	ldr	r1, [pc, #68]	@ (8000594 <fault_handler_helper+0xb4>)
 8000550:	4811      	ldr	r0, [pc, #68]	@ (8000598 <fault_handler_helper+0xb8>)
 8000552:	f000 f94b 	bl	80007ec <printf>
         (uint32_t)(&SCB->CFSR));
  printf("PC -> %\n\r", (uint32_t)&pc);
 8000556:	f107 030c 	add.w	r3, r7, #12
 800055a:	4619      	mov	r1, r3
 800055c:	480f      	ldr	r0, [pc, #60]	@ (800059c <fault_handler_helper+0xbc>)
 800055e:	f000 f945 	bl	80007ec <printf>
  printf("instruction that caused the fault-> %\n\r", (uint32_t)(&instruction));
 8000562:	f107 0314 	add.w	r3, r7, #20
 8000566:	4619      	mov	r1, r3
 8000568:	480d      	ldr	r0, [pc, #52]	@ (80005a0 <fault_handler_helper+0xc0>)
 800056a:	f000 f93f 	bl	80007ec <printf>


  /* cannot recover */
  while (1);
 800056e:	e7fe      	b.n	800056e <fault_handler_helper+0x8e>
    return;
 8000570:	bf00      	nop


}
 8000572:	3718      	adds	r7, #24
 8000574:	46bd      	mov	sp, r7
 8000576:	bd80      	pop	{r7, pc}
 8000578:	080014c4 	.word	0x080014c4
 800057c:	e000ed00 	.word	0xe000ed00
 8000580:	e000ed38 	.word	0xe000ed38
 8000584:	080014d4 	.word	0x080014d4
 8000588:	080014ec 	.word	0x080014ec
 800058c:	0800150c 	.word	0x0800150c
 8000590:	08001534 	.word	0x08001534
 8000594:	e000ed28 	.word	0xe000ed28
 8000598:	08001544 	.word	0x08001544
 800059c:	08001574 	.word	0x08001574
 80005a0:	08001580 	.word	0x08001580

080005a4 <HardFault_Handler_helper>:

void HardFault_Handler_helper(uint32_t pc) {
 80005a4:	b580      	push	{r7, lr}
 80005a6:	b084      	sub	sp, #16
 80005a8:	af00      	add	r7, sp, #0
 80005aa:	6078      	str	r0, [r7, #4]

  uint32_t instruction = *(uint32_t *)(pc);
 80005ac:	687b      	ldr	r3, [r7, #4]
 80005ae:	681b      	ldr	r3, [r3, #0]
 80005b0:	60fb      	str	r3, [r7, #12]

  printf("HARD_FAULT !!!\n\r", 0x0);
 80005b2:	2100      	movs	r1, #0
 80005b4:	480b      	ldr	r0, [pc, #44]	@ (80005e4 <HardFault_Handler_helper+0x40>)
 80005b6:	f000 f919 	bl	80007ec <printf>
  printf("configrable fault status reg (SCB->CFSR) => %\n\r",
 80005ba:	490b      	ldr	r1, [pc, #44]	@ (80005e8 <HardFault_Handler_helper+0x44>)
 80005bc:	480b      	ldr	r0, [pc, #44]	@ (80005ec <HardFault_Handler_helper+0x48>)
 80005be:	f000 f915 	bl	80007ec <printf>
         (uint32_t)(&SCB->CFSR));
  printf("Hard Fault Status Register -> %\n\r", (uint32_t)(&SCB->HFSR));
 80005c2:	490b      	ldr	r1, [pc, #44]	@ (80005f0 <HardFault_Handler_helper+0x4c>)
 80005c4:	480b      	ldr	r0, [pc, #44]	@ (80005f4 <HardFault_Handler_helper+0x50>)
 80005c6:	f000 f911 	bl	80007ec <printf>
  printf("PC -> %\n\r", (uint32_t)(&pc));
 80005ca:	1d3b      	adds	r3, r7, #4
 80005cc:	4619      	mov	r1, r3
 80005ce:	480a      	ldr	r0, [pc, #40]	@ (80005f8 <HardFault_Handler_helper+0x54>)
 80005d0:	f000 f90c 	bl	80007ec <printf>
  printf("instruction that triggered HardFault -> %\n\r",
 80005d4:	f107 030c 	add.w	r3, r7, #12
 80005d8:	4619      	mov	r1, r3
 80005da:	4808      	ldr	r0, [pc, #32]	@ (80005fc <HardFault_Handler_helper+0x58>)
 80005dc:	f000 f906 	bl	80007ec <printf>
         (uint32_t)&instruction);

  /* cannot recover */
  while (1);
 80005e0:	e7fe      	b.n	80005e0 <HardFault_Handler_helper+0x3c>
 80005e2:	bf00      	nop
 80005e4:	080015a8 	.word	0x080015a8
 80005e8:	e000ed28 	.word	0xe000ed28
 80005ec:	08001544 	.word	0x08001544
 80005f0:	e000ed2c 	.word	0xe000ed2c
 80005f4:	080015bc 	.word	0x080015bc
 80005f8:	08001574 	.word	0x08001574
 80005fc:	080015e0 	.word	0x080015e0

08000600 <__NVIC_DisableIRQ>:
  \details Disables a device specific interrupt in the NVIC interrupt controller.
  \param [in]      IRQn  Device specific interrupt number.
  \note    IRQn must not be negative.
 */
__STATIC_INLINE void __NVIC_DisableIRQ(IRQn_Type IRQn)
{
 8000600:	b480      	push	{r7}
 8000602:	b083      	sub	sp, #12
 8000604:	af00      	add	r7, sp, #0
 8000606:	4603      	mov	r3, r0
 8000608:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 800060a:	f997 3007 	ldrsb.w	r3, [r7, #7]
 800060e:	2b00      	cmp	r3, #0
 8000610:	db12      	blt.n	8000638 <__NVIC_DisableIRQ+0x38>
  {
    NVIC->ICER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 8000612:	79fb      	ldrb	r3, [r7, #7]
 8000614:	f003 021f 	and.w	r2, r3, #31
 8000618:	490a      	ldr	r1, [pc, #40]	@ (8000644 <__NVIC_DisableIRQ+0x44>)
 800061a:	f997 3007 	ldrsb.w	r3, [r7, #7]
 800061e:	095b      	lsrs	r3, r3, #5
 8000620:	2001      	movs	r0, #1
 8000622:	fa00 f202 	lsl.w	r2, r0, r2
 8000626:	3320      	adds	r3, #32
 8000628:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
  \details Acts as a special kind of Data Memory Barrier.
           It completes when all explicit memory accesses before this instruction complete.
 */
__STATIC_FORCEINLINE void __DSB(void)
{
  __ASM volatile ("dsb 0xF":::"memory");
 800062c:	f3bf 8f4f 	dsb	sy
}
 8000630:	bf00      	nop
  __ASM volatile ("isb 0xF":::"memory");
 8000632:	f3bf 8f6f 	isb	sy
}
 8000636:	bf00      	nop
    __DSB();
    __ISB();
  }
}
 8000638:	bf00      	nop
 800063a:	370c      	adds	r7, #12
 800063c:	46bd      	mov	sp, r7
 800063e:	bc80      	pop	{r7}
 8000640:	4770      	bx	lr
 8000642:	bf00      	nop
 8000644:	e000e100 	.word	0xe000e100

08000648 <jump_to_firmware>:

extern volatile bool boot_f1;
extern volatile firmware_t f1;
extern volatile firmware_t f2;

void jump_to_firmware() {
 8000648:	b580      	push	{r7, lr}
 800064a:	b084      	sub	sp, #16
 800064c:	af00      	add	r7, sp, #0
  \details Disables IRQ interrupts by setting special-purpose register PRIMASK.
           Can only be executed in Privileged modes.
 */
__STATIC_FORCEINLINE void __disable_irq(void)
{
  __ASM volatile ("cpsid i" : : : "memory");
 800064e:	b672      	cpsid	i
}
 8000650:	bf00      	nop

  __disable_irq();
  if (boot_f1) {
 8000652:	4b2c      	ldr	r3, [pc, #176]	@ (8000704 <jump_to_firmware+0xbc>)
 8000654:	781b      	ldrb	r3, [r3, #0]
 8000656:	b2db      	uxtb	r3, r3
 8000658:	2b00      	cmp	r3, #0
 800065a:	d027      	beq.n	80006ac <jump_to_firmware+0x64>
    printf("jumping to firmware1 \n\r", 0x0);
 800065c:	2100      	movs	r1, #0
 800065e:	482a      	ldr	r0, [pc, #168]	@ (8000708 <jump_to_firmware+0xc0>)
 8000660:	f000 f8c4 	bl	80007ec <printf>

    NVIC_DisableIRQ(EXTI15_10_IRQn);
 8000664:	2028      	movs	r0, #40	@ 0x28
 8000666:	f7ff ffcb 	bl	8000600 <__NVIC_DisableIRQ>
    // below this point no other interrupt can be pended !
    for (uint8_t i = 0; i < 8; i++) {
 800066a:	2300      	movs	r3, #0
 800066c:	73fb      	strb	r3, [r7, #15]
 800066e:	e009      	b.n	8000684 <jump_to_firmware+0x3c>
      NVIC->ICPR[i] = 0xffffffff;
 8000670:	4a26      	ldr	r2, [pc, #152]	@ (800070c <jump_to_firmware+0xc4>)
 8000672:	7bfb      	ldrb	r3, [r7, #15]
 8000674:	3360      	adds	r3, #96	@ 0x60
 8000676:	f04f 31ff 	mov.w	r1, #4294967295	@ 0xffffffff
 800067a:	f842 1023 	str.w	r1, [r2, r3, lsl #2]
    for (uint8_t i = 0; i < 8; i++) {
 800067e:	7bfb      	ldrb	r3, [r7, #15]
 8000680:	3301      	adds	r3, #1
 8000682:	73fb      	strb	r3, [r7, #15]
 8000684:	7bfb      	ldrb	r3, [r7, #15]
 8000686:	2b07      	cmp	r3, #7
 8000688:	d9f2      	bls.n	8000670 <jump_to_firmware+0x28>
    }

    __set_MSP(f1.__msp_value);
 800068a:	4b21      	ldr	r3, [pc, #132]	@ (8000710 <jump_to_firmware+0xc8>)
 800068c:	6a1b      	ldr	r3, [r3, #32]
 800068e:	60bb      	str	r3, [r7, #8]
  \details Assigns the given value to the Main Stack Pointer (MSP).
  \param [in]    topOfMainStack  Main Stack Pointer value to set
 */
__STATIC_FORCEINLINE void __set_MSP(uint32_t topOfMainStack)
{
  __ASM volatile ("MSR msp, %0" : : "r" (topOfMainStack) : );
 8000690:	68bb      	ldr	r3, [r7, #8]
 8000692:	f383 8808 	msr	MSP, r3
}
 8000696:	bf00      	nop
    SCB->VTOR = f1.__vtable_address;
 8000698:	4a1e      	ldr	r2, [pc, #120]	@ (8000714 <jump_to_firmware+0xcc>)
 800069a:	4b1d      	ldr	r3, [pc, #116]	@ (8000710 <jump_to_firmware+0xc8>)
 800069c:	695b      	ldr	r3, [r3, #20]
 800069e:	6093      	str	r3, [r2, #8]
  __ASM volatile ("cpsie i" : : : "memory");
 80006a0:	b662      	cpsie	i
}
 80006a2:	bf00      	nop
    // before calling the reset handler, enable irqs
    __enable_irq();
    ((void (*)(void))f1.__reset_handler)();
 80006a4:	4b1a      	ldr	r3, [pc, #104]	@ (8000710 <jump_to_firmware+0xc8>)
 80006a6:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80006a8:	4798      	blx	r3
    SCB->VTOR = f2.__vtable_address;
    // before jumping the reset handler, enable irqs
    __enable_irq();
    ((void (*)(void))f2.__reset_handler)();
  }
}
 80006aa:	e026      	b.n	80006fa <jump_to_firmware+0xb2>
    printf("jumping to firmware2 \n\r", 0x0);
 80006ac:	2100      	movs	r1, #0
 80006ae:	481a      	ldr	r0, [pc, #104]	@ (8000718 <jump_to_firmware+0xd0>)
 80006b0:	f000 f89c 	bl	80007ec <printf>
    NVIC_DisableIRQ(EXTI15_10_IRQn);
 80006b4:	2028      	movs	r0, #40	@ 0x28
 80006b6:	f7ff ffa3 	bl	8000600 <__NVIC_DisableIRQ>
    for (uint8_t i = 0; i < 8; i++) {
 80006ba:	2300      	movs	r3, #0
 80006bc:	73bb      	strb	r3, [r7, #14]
 80006be:	e009      	b.n	80006d4 <jump_to_firmware+0x8c>
      NVIC->ICPR[i] = 0xffffffff;
 80006c0:	4a12      	ldr	r2, [pc, #72]	@ (800070c <jump_to_firmware+0xc4>)
 80006c2:	7bbb      	ldrb	r3, [r7, #14]
 80006c4:	3360      	adds	r3, #96	@ 0x60
 80006c6:	f04f 31ff 	mov.w	r1, #4294967295	@ 0xffffffff
 80006ca:	f842 1023 	str.w	r1, [r2, r3, lsl #2]
    for (uint8_t i = 0; i < 8; i++) {
 80006ce:	7bbb      	ldrb	r3, [r7, #14]
 80006d0:	3301      	adds	r3, #1
 80006d2:	73bb      	strb	r3, [r7, #14]
 80006d4:	7bbb      	ldrb	r3, [r7, #14]
 80006d6:	2b07      	cmp	r3, #7
 80006d8:	d9f2      	bls.n	80006c0 <jump_to_firmware+0x78>
    __set_MSP(f2.__msp_value);
 80006da:	4b10      	ldr	r3, [pc, #64]	@ (800071c <jump_to_firmware+0xd4>)
 80006dc:	6a1b      	ldr	r3, [r3, #32]
 80006de:	607b      	str	r3, [r7, #4]
  __ASM volatile ("MSR msp, %0" : : "r" (topOfMainStack) : );
 80006e0:	687b      	ldr	r3, [r7, #4]
 80006e2:	f383 8808 	msr	MSP, r3
}
 80006e6:	bf00      	nop
    SCB->VTOR = f2.__vtable_address;
 80006e8:	4a0a      	ldr	r2, [pc, #40]	@ (8000714 <jump_to_firmware+0xcc>)
 80006ea:	4b0c      	ldr	r3, [pc, #48]	@ (800071c <jump_to_firmware+0xd4>)
 80006ec:	695b      	ldr	r3, [r3, #20]
 80006ee:	6093      	str	r3, [r2, #8]
  __ASM volatile ("cpsie i" : : : "memory");
 80006f0:	b662      	cpsie	i
}
 80006f2:	bf00      	nop
    ((void (*)(void))f2.__reset_handler)();
 80006f4:	4b09      	ldr	r3, [pc, #36]	@ (800071c <jump_to_firmware+0xd4>)
 80006f6:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 80006f8:	4798      	blx	r3
}
 80006fa:	bf00      	nop
 80006fc:	3710      	adds	r7, #16
 80006fe:	46bd      	mov	sp, r7
 8000700:	bd80      	pop	{r7, pc}
 8000702:	bf00      	nop
 8000704:	20000004 	.word	0x20000004
 8000708:	0800160c 	.word	0x0800160c
 800070c:	e000e100 	.word	0xe000e100
 8000710:	20000010 	.word	0x20000010
 8000714:	e000ed00 	.word	0xe000ed00
 8000718:	08001624 	.word	0x08001624
 800071c:	2000003c 	.word	0x2000003c

08000720 <strlen>:
uint32_t update_section_end_address = UPDATE_ADDR;
extern volatile Ring_buff_t ringbuffer;
extern uint8_t write_buffer[WRITE_BUFF_SIZE];
volatile uint32_t fw_ar_ind = 0;

uint32_t strlen(const char *msg) {
 8000720:	b480      	push	{r7}
 8000722:	b085      	sub	sp, #20
 8000724:	af00      	add	r7, sp, #0
 8000726:	6078      	str	r0, [r7, #4]

  int i = 0;
 8000728:	2300      	movs	r3, #0
 800072a:	60fb      	str	r3, [r7, #12]
  while (msg[i++] != '\0')
 800072c:	bf00      	nop
 800072e:	68fb      	ldr	r3, [r7, #12]
 8000730:	1c5a      	adds	r2, r3, #1
 8000732:	60fa      	str	r2, [r7, #12]
 8000734:	461a      	mov	r2, r3
 8000736:	687b      	ldr	r3, [r7, #4]
 8000738:	4413      	add	r3, r2
 800073a:	781b      	ldrb	r3, [r3, #0]
 800073c:	2b00      	cmp	r3, #0
 800073e:	d1f6      	bne.n	800072e <strlen+0xe>
    ;
  return i - 1;
 8000740:	68fb      	ldr	r3, [r7, #12]
 8000742:	3b01      	subs	r3, #1
}
 8000744:	4618      	mov	r0, r3
 8000746:	3714      	adds	r7, #20
 8000748:	46bd      	mov	sp, r7
 800074a:	bc80      	pop	{r7}
 800074c:	4770      	bx	lr

0800074e <delay>:

void delay(uint32_t count) {
 800074e:	b480      	push	{r7}
 8000750:	b083      	sub	sp, #12
 8000752:	af00      	add	r7, sp, #0
 8000754:	6078      	str	r0, [r7, #4]

  while (count--)
 8000756:	bf00      	nop
 8000758:	687b      	ldr	r3, [r7, #4]
 800075a:	1e5a      	subs	r2, r3, #1
 800075c:	607a      	str	r2, [r7, #4]
 800075e:	2b00      	cmp	r3, #0
 8000760:	d1fa      	bne.n	8000758 <delay+0xa>
    ;
}
 8000762:	bf00      	nop
 8000764:	bf00      	nop
 8000766:	370c      	adds	r7, #12
 8000768:	46bd      	mov	sp, r7
 800076a:	bc80      	pop	{r7}
 800076c:	4770      	bx	lr

0800076e <hex_str>:
char *hex_str(uint32_t value, char *out) {
 800076e:	b4b0      	push	{r4, r5, r7}
 8000770:	b08b      	sub	sp, #44	@ 0x2c
 8000772:	af00      	add	r7, sp, #0
 8000774:	6078      	str	r0, [r7, #4]
 8000776:	6039      	str	r1, [r7, #0]

  char hex_char[] = "0123456789abcdef";
 8000778:	4b1b      	ldr	r3, [pc, #108]	@ (80007e8 <hex_str+0x7a>)
 800077a:	f107 0408 	add.w	r4, r7, #8
 800077e:	461d      	mov	r5, r3
 8000780:	cd0f      	ldmia	r5!, {r0, r1, r2, r3}
 8000782:	c40f      	stmia	r4!, {r0, r1, r2, r3}
 8000784:	682b      	ldr	r3, [r5, #0]
 8000786:	7023      	strb	r3, [r4, #0]
  out[0] = '0';
 8000788:	683b      	ldr	r3, [r7, #0]
 800078a:	2230      	movs	r2, #48	@ 0x30
 800078c:	701a      	strb	r2, [r3, #0]
  out[1] = 'x';
 800078e:	683b      	ldr	r3, [r7, #0]
 8000790:	3301      	adds	r3, #1
 8000792:	2278      	movs	r2, #120	@ 0x78
 8000794:	701a      	strb	r2, [r3, #0]

  for (int i = 0; i < 8; i++) {
 8000796:	2300      	movs	r3, #0
 8000798:	627b      	str	r3, [r7, #36]	@ 0x24
 800079a:	e01c      	b.n	80007d6 <hex_str+0x68>
    uint32_t ind = (value & (15 << (i * 4))) >> (i * 4);
 800079c:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 800079e:	009b      	lsls	r3, r3, #2
 80007a0:	220f      	movs	r2, #15
 80007a2:	fa02 f303 	lsl.w	r3, r2, r3
 80007a6:	461a      	mov	r2, r3
 80007a8:	687b      	ldr	r3, [r7, #4]
 80007aa:	401a      	ands	r2, r3
 80007ac:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80007ae:	009b      	lsls	r3, r3, #2
 80007b0:	fa22 f303 	lsr.w	r3, r2, r3
 80007b4:	623b      	str	r3, [r7, #32]
    int j = 9 - i;
 80007b6:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80007b8:	f1c3 0309 	rsb	r3, r3, #9
 80007bc:	61fb      	str	r3, [r7, #28]
    out[j] = hex_char[ind];
 80007be:	69fb      	ldr	r3, [r7, #28]
 80007c0:	683a      	ldr	r2, [r7, #0]
 80007c2:	4413      	add	r3, r2
 80007c4:	f107 0108 	add.w	r1, r7, #8
 80007c8:	6a3a      	ldr	r2, [r7, #32]
 80007ca:	440a      	add	r2, r1
 80007cc:	7812      	ldrb	r2, [r2, #0]
 80007ce:	701a      	strb	r2, [r3, #0]
  for (int i = 0; i < 8; i++) {
 80007d0:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80007d2:	3301      	adds	r3, #1
 80007d4:	627b      	str	r3, [r7, #36]	@ 0x24
 80007d6:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 80007d8:	2b07      	cmp	r3, #7
 80007da:	dddf      	ble.n	800079c <hex_str+0x2e>
  }
}
 80007dc:	bf00      	nop
 80007de:	4618      	mov	r0, r3
 80007e0:	372c      	adds	r7, #44	@ 0x2c
 80007e2:	46bd      	mov	sp, r7
 80007e4:	bcb0      	pop	{r4, r5, r7}
 80007e6:	4770      	bx	lr
 80007e8:	0800163c 	.word	0x0800163c

080007ec <printf>:

void printf(const char *msg, uint32_t address) {
 80007ec:	b580      	push	{r7, lr}
 80007ee:	b0a4      	sub	sp, #144	@ 0x90
 80007f0:	af00      	add	r7, sp, #0
 80007f2:	6078      	str	r0, [r7, #4]
 80007f4:	6039      	str	r1, [r7, #0]

  uint32_t value = *((uint32_t *)address);
 80007f6:	683b      	ldr	r3, [r7, #0]
 80007f8:	681b      	ldr	r3, [r3, #0]
 80007fa:	67fb      	str	r3, [r7, #124]	@ 0x7c

  if (strlen(msg) + 9 > MAX_STR_SIZE) {
 80007fc:	6878      	ldr	r0, [r7, #4]
 80007fe:	f7ff ff8f 	bl	8000720 <strlen>
 8000802:	4603      	mov	r3, r0
 8000804:	3309      	adds	r3, #9
 8000806:	2b64      	cmp	r3, #100	@ 0x64
 8000808:	d904      	bls.n	8000814 <printf+0x28>
    __usart1_print("too large error message !!\n\r", MAX_STR_SIZE);
 800080a:	2164      	movs	r1, #100	@ 0x64
 800080c:	483e      	ldr	r0, [pc, #248]	@ (8000908 <printf+0x11c>)
 800080e:	f7ff fcf5 	bl	80001fc <__usart1_print>
 8000812:	e076      	b.n	8000902 <printf+0x116>
    return;
  }
  char hex[10];
  char __msg[MAX_STR_SIZE];

  uint32_t i = 0;
 8000814:	2300      	movs	r3, #0
 8000816:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
  int p = 0, q = 0;
 800081a:	2300      	movs	r3, #0
 800081c:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
 8000820:	2300      	movs	r3, #0
 8000822:	f8c7 3084 	str.w	r3, [r7, #132]	@ 0x84
  bool single_sub = false;
 8000826:	2300      	movs	r3, #0
 8000828:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83

  uint32_t msg_size = strlen(msg);
 800082c:	6878      	ldr	r0, [r7, #4]
 800082e:	f7ff ff77 	bl	8000720 <strlen>
 8000832:	67b8      	str	r0, [r7, #120]	@ 0x78
  for (; i < msg_size; i++) {
 8000834:	e04d      	b.n	80008d2 <printf+0xe6>

    if (msg[i] == '%' && !single_sub) {
 8000836:	687a      	ldr	r2, [r7, #4]
 8000838:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 800083c:	4413      	add	r3, r2
 800083e:	781b      	ldrb	r3, [r3, #0]
 8000840:	2b25      	cmp	r3, #37	@ 0x25
 8000842:	d12f      	bne.n	80008a4 <printf+0xb8>
 8000844:	f897 3083 	ldrb.w	r3, [r7, #131]	@ 0x83
 8000848:	f083 0301 	eor.w	r3, r3, #1
 800084c:	b2db      	uxtb	r3, r3
 800084e:	2b00      	cmp	r3, #0
 8000850:	d028      	beq.n	80008a4 <printf+0xb8>
      hex_str(value, hex);
 8000852:	f107 036c 	add.w	r3, r7, #108	@ 0x6c
 8000856:	4619      	mov	r1, r3
 8000858:	6ff8      	ldr	r0, [r7, #124]	@ 0x7c
 800085a:	f7ff ff88 	bl	800076e <hex_str>

      while (q - p < 10) {
 800085e:	e011      	b.n	8000884 <printf+0x98>
        __msg[q++] = hex[q - p];
 8000860:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 8000864:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000868:	1ad2      	subs	r2, r2, r3
 800086a:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 800086e:	1c59      	adds	r1, r3, #1
 8000870:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 8000874:	3290      	adds	r2, #144	@ 0x90
 8000876:	443a      	add	r2, r7
 8000878:	f812 2c24 	ldrb.w	r2, [r2, #-36]
 800087c:	3390      	adds	r3, #144	@ 0x90
 800087e:	443b      	add	r3, r7
 8000880:	f803 2c88 	strb.w	r2, [r3, #-136]
      while (q - p < 10) {
 8000884:	f8d7 2084 	ldr.w	r2, [r7, #132]	@ 0x84
 8000888:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 800088c:	1ad3      	subs	r3, r2, r3
 800088e:	2b09      	cmp	r3, #9
 8000890:	dde6      	ble.n	8000860 <printf+0x74>
      }
      p++;
 8000892:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 8000896:	3301      	adds	r3, #1
 8000898:	f8c7 3088 	str.w	r3, [r7, #136]	@ 0x88
      single_sub = true;
 800089c:	2301      	movs	r3, #1
 800089e:	f887 3083 	strb.w	r3, [r7, #131]	@ 0x83
 80008a2:	e011      	b.n	80008c8 <printf+0xdc>
    } else
      __msg[q++] = msg[p++];
 80008a4:	f8d7 3088 	ldr.w	r3, [r7, #136]	@ 0x88
 80008a8:	1c5a      	adds	r2, r3, #1
 80008aa:	f8c7 2088 	str.w	r2, [r7, #136]	@ 0x88
 80008ae:	461a      	mov	r2, r3
 80008b0:	687b      	ldr	r3, [r7, #4]
 80008b2:	441a      	add	r2, r3
 80008b4:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 80008b8:	1c59      	adds	r1, r3, #1
 80008ba:	f8c7 1084 	str.w	r1, [r7, #132]	@ 0x84
 80008be:	7812      	ldrb	r2, [r2, #0]
 80008c0:	3390      	adds	r3, #144	@ 0x90
 80008c2:	443b      	add	r3, r7
 80008c4:	f803 2c88 	strb.w	r2, [r3, #-136]
  for (; i < msg_size; i++) {
 80008c8:	f8d7 308c 	ldr.w	r3, [r7, #140]	@ 0x8c
 80008cc:	3301      	adds	r3, #1
 80008ce:	f8c7 308c 	str.w	r3, [r7, #140]	@ 0x8c
 80008d2:	f8d7 208c 	ldr.w	r2, [r7, #140]	@ 0x8c
 80008d6:	6fbb      	ldr	r3, [r7, #120]	@ 0x78
 80008d8:	429a      	cmp	r2, r3
 80008da:	d3ac      	bcc.n	8000836 <printf+0x4a>
  }
  __msg[q] = '\0';
 80008dc:	f107 0208 	add.w	r2, r7, #8
 80008e0:	f8d7 3084 	ldr.w	r3, [r7, #132]	@ 0x84
 80008e4:	4413      	add	r3, r2
 80008e6:	2200      	movs	r2, #0
 80008e8:	701a      	strb	r2, [r3, #0]
  __usart1_print(__msg, strlen(__msg));
 80008ea:	f107 0308 	add.w	r3, r7, #8
 80008ee:	4618      	mov	r0, r3
 80008f0:	f7ff ff16 	bl	8000720 <strlen>
 80008f4:	4602      	mov	r2, r0
 80008f6:	f107 0308 	add.w	r3, r7, #8
 80008fa:	4611      	mov	r1, r2
 80008fc:	4618      	mov	r0, r3
 80008fe:	f7ff fc7d 	bl	80001fc <__usart1_print>
}
 8000902:	3790      	adds	r7, #144	@ 0x90
 8000904:	46bd      	mov	sp, r7
 8000906:	bd80      	pop	{r7, pc}
 8000908:	08001650 	.word	0x08001650

0800090c <recieve_update>:
//   }
//   printf("data recieved !!! yehhhh \n\n\r", 0x0);
//   return 0;
// }

uint32_t recieve_update(void) {
 800090c:	b580      	push	{r7, lr}
 800090e:	b082      	sub	sp, #8
 8000910:	af00      	add	r7, sp, #0

  // recieve update size

  printf("enter the size of the update....\n\r", 0x0);
 8000912:	2100      	movs	r1, #0
 8000914:	483e      	ldr	r0, [pc, #248]	@ (8000a10 <recieve_update+0x104>)
 8000916:	f7ff ff69 	bl	80007ec <printf>

  recieve_size = true;
 800091a:	4b3e      	ldr	r3, [pc, #248]	@ (8000a14 <recieve_update+0x108>)
 800091c:	2201      	movs	r2, #1
 800091e:	701a      	strb	r2, [r3, #0]
  while (1) {
    if (flag_wrong_size) {
 8000920:	4b3d      	ldr	r3, [pc, #244]	@ (8000a18 <recieve_update+0x10c>)
 8000922:	781b      	ldrb	r3, [r3, #0]
 8000924:	b2db      	uxtb	r3, r3
 8000926:	2b00      	cmp	r3, #0
 8000928:	d006      	beq.n	8000938 <recieve_update+0x2c>
      printf("wrong size entered !!!\n\r", 0x0);
 800092a:	2100      	movs	r1, #0
 800092c:	483b      	ldr	r0, [pc, #236]	@ (8000a1c <recieve_update+0x110>)
 800092e:	f7ff ff5d 	bl	80007ec <printf>
      return -1;
 8000932:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 8000936:	e066      	b.n	8000a06 <recieve_update+0xfa>
    }
    if (flag_too_big_update) {
 8000938:	4b39      	ldr	r3, [pc, #228]	@ (8000a20 <recieve_update+0x114>)
 800093a:	781b      	ldrb	r3, [r3, #0]
 800093c:	b2db      	uxtb	r3, r3
 800093e:	2b00      	cmp	r3, #0
 8000940:	d006      	beq.n	8000950 <recieve_update+0x44>
      printf("update size cannot exceed 128KB \n\r", 0x0);
 8000942:	2100      	movs	r1, #0
 8000944:	4837      	ldr	r0, [pc, #220]	@ (8000a24 <recieve_update+0x118>)
 8000946:	f7ff ff51 	bl	80007ec <printf>
      return -1;
 800094a:	f04f 33ff 	mov.w	r3, #4294967295	@ 0xffffffff
 800094e:	e05a      	b.n	8000a06 <recieve_update+0xfa>
    }
    if (flag_size_recieved) {
 8000950:	4b35      	ldr	r3, [pc, #212]	@ (8000a28 <recieve_update+0x11c>)
 8000952:	781b      	ldrb	r3, [r3, #0]
 8000954:	b2db      	uxtb	r3, r3
 8000956:	2b00      	cmp	r3, #0
 8000958:	d0e2      	beq.n	8000920 <recieve_update+0x14>
      printf("update size recieved \n\r", 0x0);
 800095a:	2100      	movs	r1, #0
 800095c:	4833      	ldr	r0, [pc, #204]	@ (8000a2c <recieve_update+0x120>)
 800095e:	f7ff ff45 	bl	80007ec <printf>
      break;
 8000962:	bf00      	nop
    }
  }
  recieve_size = false;
 8000964:	4b2b      	ldr	r3, [pc, #172]	@ (8000a14 <recieve_update+0x108>)
 8000966:	2200      	movs	r2, #0
 8000968:	701a      	strb	r2, [r3, #0]

  // recieve firmware update !!
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 800096a:	e041      	b.n	80009f0 <recieve_update+0xe4>
    while (Ring_buff_empty(&ringbuffer))
 800096c:	bf00      	nop
 800096e:	4830      	ldr	r0, [pc, #192]	@ (8000a30 <recieve_update+0x124>)
 8000970:	f000 f8c7 	bl	8000b02 <Ring_buff_empty>
 8000974:	4603      	mov	r3, r0
 8000976:	2b00      	cmp	r3, #0
 8000978:	d1f9      	bne.n	800096e <recieve_update+0x62>
      ;
    //
    // problem
    uint16_t read_size = Ring_buff_read(&ringbuffer, write_buffer + wb_size,
 800097a:	4b2e      	ldr	r3, [pc, #184]	@ (8000a34 <recieve_update+0x128>)
 800097c:	881b      	ldrh	r3, [r3, #0]
 800097e:	461a      	mov	r2, r3
 8000980:	4b2d      	ldr	r3, [pc, #180]	@ (8000a38 <recieve_update+0x12c>)
 8000982:	18d1      	adds	r1, r2, r3
 8000984:	4b2b      	ldr	r3, [pc, #172]	@ (8000a34 <recieve_update+0x128>)
 8000986:	881b      	ldrh	r3, [r3, #0]
 8000988:	f5c3 5320 	rsb	r3, r3, #10240	@ 0x2800
 800098c:	b29b      	uxth	r3, r3
 800098e:	461a      	mov	r2, r3
 8000990:	4827      	ldr	r0, [pc, #156]	@ (8000a30 <recieve_update+0x124>)
 8000992:	f000 f928 	bl	8000be6 <Ring_buff_read>
 8000996:	4603      	mov	r3, r0
 8000998:	80fb      	strh	r3, [r7, #6]
                                        WRITE_BUFF_SIZE - wb_size);
    wb_size += read_size;
 800099a:	4b26      	ldr	r3, [pc, #152]	@ (8000a34 <recieve_update+0x128>)
 800099c:	881a      	ldrh	r2, [r3, #0]
 800099e:	88fb      	ldrh	r3, [r7, #6]
 80009a0:	4413      	add	r3, r2
 80009a2:	b29a      	uxth	r2, r3
 80009a4:	4b23      	ldr	r3, [pc, #140]	@ (8000a34 <recieve_update+0x128>)
 80009a6:	801a      	strh	r2, [r3, #0]

    uint16_t update_in_flash_size = update_section_end_address - UPDATE_ADDR;
 80009a8:	4b24      	ldr	r3, [pc, #144]	@ (8000a3c <recieve_update+0x130>)
 80009aa:	681b      	ldr	r3, [r3, #0]
 80009ac:	80bb      	strh	r3, [r7, #4]
    //
    if (wb_size == WRITE_BUFF_SIZE ||
 80009ae:	4b21      	ldr	r3, [pc, #132]	@ (8000a34 <recieve_update+0x128>)
 80009b0:	881b      	ldrh	r3, [r3, #0]
 80009b2:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 80009b6:	d007      	beq.n	80009c8 <recieve_update+0xbc>
        update_size - update_in_flash_size == wb_size) {
 80009b8:	4b21      	ldr	r3, [pc, #132]	@ (8000a40 <recieve_update+0x134>)
 80009ba:	681a      	ldr	r2, [r3, #0]
 80009bc:	88bb      	ldrh	r3, [r7, #4]
 80009be:	1ad3      	subs	r3, r2, r3
 80009c0:	4a1c      	ldr	r2, [pc, #112]	@ (8000a34 <recieve_update+0x128>)
 80009c2:	8812      	ldrh	r2, [r2, #0]
    if (wb_size == WRITE_BUFF_SIZE ||
 80009c4:	4293      	cmp	r3, r2
 80009c6:	d113      	bne.n	80009f0 <recieve_update+0xe4>
      // flash write, update end address, wb flush

      flash_write(update_section_end_address, write_buffer, wb_size, 0);
 80009c8:	4b1c      	ldr	r3, [pc, #112]	@ (8000a3c <recieve_update+0x130>)
 80009ca:	6818      	ldr	r0, [r3, #0]
 80009cc:	4b19      	ldr	r3, [pc, #100]	@ (8000a34 <recieve_update+0x128>)
 80009ce:	881b      	ldrh	r3, [r3, #0]
 80009d0:	461a      	mov	r2, r3
 80009d2:	2300      	movs	r3, #0
 80009d4:	4918      	ldr	r1, [pc, #96]	@ (8000a38 <recieve_update+0x12c>)
 80009d6:	f7ff fcfd 	bl	80003d4 <flash_write>

      update_section_end_address += wb_size;
 80009da:	4b16      	ldr	r3, [pc, #88]	@ (8000a34 <recieve_update+0x128>)
 80009dc:	881b      	ldrh	r3, [r3, #0]
 80009de:	461a      	mov	r2, r3
 80009e0:	4b16      	ldr	r3, [pc, #88]	@ (8000a3c <recieve_update+0x130>)
 80009e2:	681b      	ldr	r3, [r3, #0]
 80009e4:	4413      	add	r3, r2
 80009e6:	4a15      	ldr	r2, [pc, #84]	@ (8000a3c <recieve_update+0x130>)
 80009e8:	6013      	str	r3, [r2, #0]
      wb_size = 0;
 80009ea:	4b12      	ldr	r3, [pc, #72]	@ (8000a34 <recieve_update+0x128>)
 80009ec:	2200      	movs	r2, #0
 80009ee:	801a      	strh	r2, [r3, #0]
  while (update_section_end_address - UPDATE_ADDR < update_size) {
 80009f0:	4b12      	ldr	r3, [pc, #72]	@ (8000a3c <recieve_update+0x130>)
 80009f2:	681b      	ldr	r3, [r3, #0]
 80009f4:	f103 4377 	add.w	r3, r3, #4143972352	@ 0xf7000000
 80009f8:	f503 037c 	add.w	r3, r3, #16515072	@ 0xfc0000
 80009fc:	4a10      	ldr	r2, [pc, #64]	@ (8000a40 <recieve_update+0x134>)
 80009fe:	6812      	ldr	r2, [r2, #0]
 8000a00:	4293      	cmp	r3, r2
 8000a02:	d3b3      	bcc.n	800096c <recieve_update+0x60>
    }
  }

  // while (fw_ar_ind < update_size);

  return 0;
 8000a04:	2300      	movs	r3, #0
}
 8000a06:	4618      	mov	r0, r3
 8000a08:	3708      	adds	r7, #8
 8000a0a:	46bd      	mov	sp, r7
 8000a0c:	bd80      	pop	{r7, pc}
 8000a0e:	bf00      	nop
 8000a10:	08001670 	.word	0x08001670
 8000a14:	20000008 	.word	0x20000008
 8000a18:	2000000a 	.word	0x2000000a
 8000a1c:	08001694 	.word	0x08001694
 8000a20:	2000000b 	.word	0x2000000b
 8000a24:	080016b0 	.word	0x080016b0
 8000a28:	20000009 	.word	0x20000009
 8000a2c:	080016d4 	.word	0x080016d4
 8000a30:	20000080 	.word	0x20000080
 8000a34:	20005084 	.word	0x20005084
 8000a38:	20002884 	.word	0x20002884
 8000a3c:	20000000 	.word	0x20000000
 8000a40:	2000007c 	.word	0x2000007c

08000a44 <rollback>:

void rollback(void) {
 8000a44:	b580      	push	{r7, lr}
 8000a46:	b08e      	sub	sp, #56	@ 0x38
 8000a48:	af00      	add	r7, sp, #0

  firmware_t old_f;
  // old firmware is present in the COPY_ADDR section
  init_firmware_t(COPY_ADDR, &old_f);
 8000a4a:	f107 0308 	add.w	r3, r7, #8
 8000a4e:	4619      	mov	r1, r3
 8000a50:	4819      	ldr	r0, [pc, #100]	@ (8000ab8 <rollback+0x74>)
 8000a52:	f000 f923 	bl	8000c9c <init_firmware_t>

  printf("startign rollback\n\n\r", 0x0);
 8000a56:	2100      	movs	r1, #0
 8000a58:	4818      	ldr	r0, [pc, #96]	@ (8000abc <rollback+0x78>)
 8000a5a:	f7ff fec7 	bl	80007ec <printf>
  erase_flash(old_f.__base_address);
 8000a5e:	68bb      	ldr	r3, [r7, #8]
 8000a60:	4618      	mov	r0, r3
 8000a62:	f7ff fbfd 	bl	8000260 <erase_flash>
  printf("corupted firmware is erased\n\r", 0x0);
 8000a66:	2100      	movs	r1, #0
 8000a68:	4815      	ldr	r0, [pc, #84]	@ (8000ac0 <rollback+0x7c>)
 8000a6a:	f7ff febf 	bl	80007ec <printf>

  uint32_t copy_size =
      (*(uint32_t *)(COPY_ADDR + 0x14)) - (*(uint32_t *)(COPY_ADDR + 0x0c));
 8000a6e:	4b15      	ldr	r3, [pc, #84]	@ (8000ac4 <rollback+0x80>)
 8000a70:	681a      	ldr	r2, [r3, #0]
 8000a72:	4b15      	ldr	r3, [pc, #84]	@ (8000ac8 <rollback+0x84>)
 8000a74:	681b      	ldr	r3, [r3, #0]
  uint32_t copy_size =
 8000a76:	1ad3      	subs	r3, r2, r3
 8000a78:	637b      	str	r3, [r7, #52]	@ 0x34
  flash_write(old_f.__base_address + 0x04, (const char *)(COPY_ADDR + 0x04),
 8000a7a:	68bb      	ldr	r3, [r7, #8]
 8000a7c:	1d18      	adds	r0, r3, #4
 8000a7e:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000a80:	1f1a      	subs	r2, r3, #4
 8000a82:	2300      	movs	r3, #0
 8000a84:	4911      	ldr	r1, [pc, #68]	@ (8000acc <rollback+0x88>)
 8000a86:	f7ff fca5 	bl	80003d4 <flash_write>
              copy_size - 0x04, NO_DELAY);

  // word write => size would be 4 (not 2)
  const uint32_t end = 0xfffffffe;
 8000a8a:	f06f 0301 	mvn.w	r3, #1
 8000a8e:	607b      	str	r3, [r7, #4]
  // &end is of type -> uint32_t * ==> need type conversion
  flash_write(old_f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000a90:	68b8      	ldr	r0, [r7, #8]
 8000a92:	1d39      	adds	r1, r7, #4
 8000a94:	2300      	movs	r3, #0
 8000a96:	2204      	movs	r2, #4
 8000a98:	f7ff fc9c 	bl	80003d4 <flash_write>
  printf("new flag = %\n\r", old_f.__base_address);
 8000a9c:	68bb      	ldr	r3, [r7, #8]
 8000a9e:	4619      	mov	r1, r3
 8000aa0:	480b      	ldr	r0, [pc, #44]	@ (8000ad0 <rollback+0x8c>)
 8000aa2:	f7ff fea3 	bl	80007ec <printf>

  printf("done recovering old firmware \n\r", 0x0);
 8000aa6:	2100      	movs	r1, #0
 8000aa8:	480a      	ldr	r0, [pc, #40]	@ (8000ad4 <rollback+0x90>)
 8000aaa:	f7ff fe9f 	bl	80007ec <printf>
}
 8000aae:	bf00      	nop
 8000ab0:	3738      	adds	r7, #56	@ 0x38
 8000ab2:	46bd      	mov	sp, r7
 8000ab4:	bd80      	pop	{r7, pc}
 8000ab6:	bf00      	nop
 8000ab8:	08060000 	.word	0x08060000
 8000abc:	080016ec 	.word	0x080016ec
 8000ac0:	08001704 	.word	0x08001704
 8000ac4:	08060014 	.word	0x08060014
 8000ac8:	0806000c 	.word	0x0806000c
 8000acc:	08060004 	.word	0x08060004
 8000ad0:	08001724 	.word	0x08001724
 8000ad4:	08001734 	.word	0x08001734

08000ad8 <Ring_buff_init>:
#include "ring_buff.h"
#include <stdint.h>
#include <stdbool.h>

void Ring_buff_init(volatile Ring_buff_t *rb) {
 8000ad8:	b480      	push	{r7}
 8000ada:	b083      	sub	sp, #12
 8000adc:	af00      	add	r7, sp, #0
 8000ade:	6078      	str	r0, [r7, #4]
  rb->rear = 0;
 8000ae0:	687b      	ldr	r3, [r7, #4]
 8000ae2:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000ae6:	2200      	movs	r2, #0
 8000ae8:	f8a3 2800 	strh.w	r2, [r3, #2048]	@ 0x800
  rb->front = 0;
 8000aec:	687b      	ldr	r3, [r7, #4]
 8000aee:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000af2:	2200      	movs	r2, #0
 8000af4:	f8a3 2802 	strh.w	r2, [r3, #2050]	@ 0x802
}
 8000af8:	bf00      	nop
 8000afa:	370c      	adds	r7, #12
 8000afc:	46bd      	mov	sp, r7
 8000afe:	bc80      	pop	{r7}
 8000b00:	4770      	bx	lr

08000b02 <Ring_buff_empty>:
bool Ring_buff_empty (volatile Ring_buff_t* rb){
 8000b02:	b480      	push	{r7}
 8000b04:	b083      	sub	sp, #12
 8000b06:	af00      	add	r7, sp, #0
 8000b08:	6078      	str	r0, [r7, #4]
  return rb->front == rb->rear;
 8000b0a:	687b      	ldr	r3, [r7, #4]
 8000b0c:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000b10:	f8b3 3802 	ldrh.w	r3, [r3, #2050]	@ 0x802
 8000b14:	b29a      	uxth	r2, r3
 8000b16:	687b      	ldr	r3, [r7, #4]
 8000b18:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000b1c:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 8000b20:	b29b      	uxth	r3, r3
 8000b22:	429a      	cmp	r2, r3
 8000b24:	bf0c      	ite	eq
 8000b26:	2301      	moveq	r3, #1
 8000b28:	2300      	movne	r3, #0
 8000b2a:	b2db      	uxtb	r3, r3
}
 8000b2c:	4618      	mov	r0, r3
 8000b2e:	370c      	adds	r7, #12
 8000b30:	46bd      	mov	sp, r7
 8000b32:	bc80      	pop	{r7}
 8000b34:	4770      	bx	lr

08000b36 <Ring_buff_size>:
uint16_t Ring_buff_size (volatile Ring_buff_t* rb){
 8000b36:	b480      	push	{r7}
 8000b38:	b085      	sub	sp, #20
 8000b3a:	af00      	add	r7, sp, #0
 8000b3c:	6078      	str	r0, [r7, #4]
  uint16_t local_front = rb-> front;
 8000b3e:	687b      	ldr	r3, [r7, #4]
 8000b40:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000b44:	f8b3 3802 	ldrh.w	r3, [r3, #2050]	@ 0x802
 8000b48:	81fb      	strh	r3, [r7, #14]
  uint16_t local_rear = rb-> rear;
 8000b4a:	687b      	ldr	r3, [r7, #4]
 8000b4c:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000b50:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 8000b54:	81bb      	strh	r3, [r7, #12]

  if (local_front <= local_rear){
 8000b56:	89fa      	ldrh	r2, [r7, #14]
 8000b58:	89bb      	ldrh	r3, [r7, #12]
 8000b5a:	429a      	cmp	r2, r3
 8000b5c:	d804      	bhi.n	8000b68 <Ring_buff_size+0x32>
    return local_rear - local_front;
 8000b5e:	89ba      	ldrh	r2, [r7, #12]
 8000b60:	89fb      	ldrh	r3, [r7, #14]
 8000b62:	1ad3      	subs	r3, r2, r3
 8000b64:	b29b      	uxth	r3, r3
 8000b66:	e006      	b.n	8000b76 <Ring_buff_size+0x40>
  }
  return RING_BUFF_SIZE - local_front + local_rear;
 8000b68:	89ba      	ldrh	r2, [r7, #12]
 8000b6a:	89fb      	ldrh	r3, [r7, #14]
 8000b6c:	1ad3      	subs	r3, r2, r3
 8000b6e:	b29b      	uxth	r3, r3
 8000b70:	f503 5320 	add.w	r3, r3, #10240	@ 0x2800
 8000b74:	b29b      	uxth	r3, r3
} 
 8000b76:	4618      	mov	r0, r3
 8000b78:	3714      	adds	r7, #20
 8000b7a:	46bd      	mov	sp, r7
 8000b7c:	bc80      	pop	{r7}
 8000b7e:	4770      	bx	lr

08000b80 <Ring_buff_write>:

// the below functions should only be called by isr
// Use only REAR for write . donot read / write FRONT
// if ring buffer of overwhelmed ... then increase the size of Ringbuffer

void Ring_buff_write(volatile Ring_buff_t *rb, uint8_t *buff, uint16_t size) {
 8000b80:	b480      	push	{r7}
 8000b82:	b087      	sub	sp, #28
 8000b84:	af00      	add	r7, sp, #0
 8000b86:	60f8      	str	r0, [r7, #12]
 8000b88:	60b9      	str	r1, [r7, #8]
 8000b8a:	4613      	mov	r3, r2
 8000b8c:	80fb      	strh	r3, [r7, #6]
  // data can be overwritten ... if this happens -> increase the size of the ring buffer
  
  uint16_t local_rear = rb->rear;
 8000b8e:	68fb      	ldr	r3, [r7, #12]
 8000b90:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000b94:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 8000b98:	82fb      	strh	r3, [r7, #22]

  for (uint16_t ind = 0; ind < size; ind ++){
 8000b9a:	2300      	movs	r3, #0
 8000b9c:	82bb      	strh	r3, [r7, #20]
 8000b9e:	e012      	b.n	8000bc6 <Ring_buff_write+0x46>
    rb-> buffer[local_rear] = buff [ind];
 8000ba0:	8abb      	ldrh	r3, [r7, #20]
 8000ba2:	68ba      	ldr	r2, [r7, #8]
 8000ba4:	441a      	add	r2, r3
 8000ba6:	8afb      	ldrh	r3, [r7, #22]
 8000ba8:	7811      	ldrb	r1, [r2, #0]
 8000baa:	68fa      	ldr	r2, [r7, #12]
 8000bac:	54d1      	strb	r1, [r2, r3]
    local_rear ++;
 8000bae:	8afb      	ldrh	r3, [r7, #22]
 8000bb0:	3301      	adds	r3, #1
 8000bb2:	82fb      	strh	r3, [r7, #22]
    if (local_rear == RING_BUFF_SIZE)
 8000bb4:	8afb      	ldrh	r3, [r7, #22]
 8000bb6:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 8000bba:	d101      	bne.n	8000bc0 <Ring_buff_write+0x40>
      local_rear = 0;
 8000bbc:	2300      	movs	r3, #0
 8000bbe:	82fb      	strh	r3, [r7, #22]
  for (uint16_t ind = 0; ind < size; ind ++){
 8000bc0:	8abb      	ldrh	r3, [r7, #20]
 8000bc2:	3301      	adds	r3, #1
 8000bc4:	82bb      	strh	r3, [r7, #20]
 8000bc6:	8aba      	ldrh	r2, [r7, #20]
 8000bc8:	88fb      	ldrh	r3, [r7, #6]
 8000bca:	429a      	cmp	r2, r3
 8000bcc:	d3e8      	bcc.n	8000ba0 <Ring_buff_write+0x20>
  }

  rb-> rear = local_rear; 
 8000bce:	68fb      	ldr	r3, [r7, #12]
 8000bd0:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000bd4:	461a      	mov	r2, r3
 8000bd6:	8afb      	ldrh	r3, [r7, #22]
 8000bd8:	f8a2 3800 	strh.w	r3, [r2, #2048]	@ 0x800
}
 8000bdc:	bf00      	nop
 8000bde:	371c      	adds	r7, #28
 8000be0:	46bd      	mov	sp, r7
 8000be2:	bc80      	pop	{r7}
 8000be4:	4770      	bx	lr

08000be6 <Ring_buff_read>:

// read the whole Ring_buffer
uint16_t Ring_buff_read(volatile Ring_buff_t *rb, uint8_t *buff,
                        uint16_t buff_size) {
 8000be6:	b480      	push	{r7}
 8000be8:	b087      	sub	sp, #28
 8000bea:	af00      	add	r7, sp, #0
 8000bec:	60f8      	str	r0, [r7, #12]
 8000bee:	60b9      	str	r1, [r7, #8]
 8000bf0:	4613      	mov	r3, r2
 8000bf2:	80fb      	strh	r3, [r7, #6]

  uint16_t local_front = rb->front;
 8000bf4:	68fb      	ldr	r3, [r7, #12]
 8000bf6:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000bfa:	f8b3 3802 	ldrh.w	r3, [r3, #2050]	@ 0x802
 8000bfe:	82fb      	strh	r3, [r7, #22]
  uint16_t local_rear = rb->rear;
 8000c00:	68fb      	ldr	r3, [r7, #12]
 8000c02:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000c06:	f8b3 3800 	ldrh.w	r3, [r3, #2048]	@ 0x800
 8000c0a:	827b      	strh	r3, [r7, #18]

  uint16_t ind = 0;
 8000c0c:	2300      	movs	r3, #0
 8000c0e:	82bb      	strh	r3, [r7, #20]

  while (ind < buff_size && local_front != local_rear){
 8000c10:	e013      	b.n	8000c3a <Ring_buff_read+0x54>
    buff[ind] = rb-> buffer[local_front];
 8000c12:	8afa      	ldrh	r2, [r7, #22]
 8000c14:	8abb      	ldrh	r3, [r7, #20]
 8000c16:	68b9      	ldr	r1, [r7, #8]
 8000c18:	440b      	add	r3, r1
 8000c1a:	68f9      	ldr	r1, [r7, #12]
 8000c1c:	5c8a      	ldrb	r2, [r1, r2]
 8000c1e:	b2d2      	uxtb	r2, r2
 8000c20:	701a      	strb	r2, [r3, #0]
    local_front ++;
 8000c22:	8afb      	ldrh	r3, [r7, #22]
 8000c24:	3301      	adds	r3, #1
 8000c26:	82fb      	strh	r3, [r7, #22]
    if (local_front == RING_BUFF_SIZE)
 8000c28:	8afb      	ldrh	r3, [r7, #22]
 8000c2a:	f5b3 5f20 	cmp.w	r3, #10240	@ 0x2800
 8000c2e:	d101      	bne.n	8000c34 <Ring_buff_read+0x4e>
      local_front = 0;
 8000c30:	2300      	movs	r3, #0
 8000c32:	82fb      	strh	r3, [r7, #22]
    ind ++;
 8000c34:	8abb      	ldrh	r3, [r7, #20]
 8000c36:	3301      	adds	r3, #1
 8000c38:	82bb      	strh	r3, [r7, #20]
  while (ind < buff_size && local_front != local_rear){
 8000c3a:	8aba      	ldrh	r2, [r7, #20]
 8000c3c:	88fb      	ldrh	r3, [r7, #6]
 8000c3e:	429a      	cmp	r2, r3
 8000c40:	d203      	bcs.n	8000c4a <Ring_buff_read+0x64>
 8000c42:	8afa      	ldrh	r2, [r7, #22]
 8000c44:	8a7b      	ldrh	r3, [r7, #18]
 8000c46:	429a      	cmp	r2, r3
 8000c48:	d1e3      	bne.n	8000c12 <Ring_buff_read+0x2c>
  }

  rb->front = local_front;
 8000c4a:	68fb      	ldr	r3, [r7, #12]
 8000c4c:	f503 5300 	add.w	r3, r3, #8192	@ 0x2000
 8000c50:	461a      	mov	r2, r3
 8000c52:	8afb      	ldrh	r3, [r7, #22]
 8000c54:	f8a2 3802 	strh.w	r3, [r2, #2050]	@ 0x802

  return ind;
 8000c58:	8abb      	ldrh	r3, [r7, #20]
}
 8000c5a:	4618      	mov	r0, r3
 8000c5c:	371c      	adds	r7, #28
 8000c5e:	46bd      	mov	sp, r7
 8000c60:	bc80      	pop	{r7}
 8000c62:	4770      	bx	lr

08000c64 <__NVIC_EnableIRQ>:
{
 8000c64:	b480      	push	{r7}
 8000c66:	b083      	sub	sp, #12
 8000c68:	af00      	add	r7, sp, #0
 8000c6a:	4603      	mov	r3, r0
 8000c6c:	71fb      	strb	r3, [r7, #7]
  if ((int32_t)(IRQn) >= 0)
 8000c6e:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000c72:	2b00      	cmp	r3, #0
 8000c74:	db0b      	blt.n	8000c8e <__NVIC_EnableIRQ+0x2a>
    NVIC->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
 8000c76:	79fb      	ldrb	r3, [r7, #7]
 8000c78:	f003 021f 	and.w	r2, r3, #31
 8000c7c:	4906      	ldr	r1, [pc, #24]	@ (8000c98 <__NVIC_EnableIRQ+0x34>)
 8000c7e:	f997 3007 	ldrsb.w	r3, [r7, #7]
 8000c82:	095b      	lsrs	r3, r3, #5
 8000c84:	2001      	movs	r0, #1
 8000c86:	fa00 f202 	lsl.w	r2, r0, r2
 8000c8a:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
}
 8000c8e:	bf00      	nop
 8000c90:	370c      	adds	r7, #12
 8000c92:	46bd      	mov	sp, r7
 8000c94:	bc80      	pop	{r7}
 8000c96:	4770      	bx	lr
 8000c98:	e000e100 	.word	0xe000e100

08000c9c <init_firmware_t>:
uint16_t wb_size;

bool firmware_update_mode = false;


void init_firmware_t(uint32_t address, firmware_t *f) {
 8000c9c:	b480      	push	{r7}
 8000c9e:	b083      	sub	sp, #12
 8000ca0:	af00      	add	r7, sp, #0
 8000ca2:	6078      	str	r0, [r7, #4]
 8000ca4:	6039      	str	r1, [r7, #0]
  f->__flag = *(volatile uint32_t *)(address + 0x00);
 8000ca6:	687b      	ldr	r3, [r7, #4]
 8000ca8:	681a      	ldr	r2, [r3, #0]
 8000caa:	683b      	ldr	r3, [r7, #0]
 8000cac:	605a      	str	r2, [r3, #4]
  f->__crc = *((volatile uint32_t *)(address + 0x04));
 8000cae:	687b      	ldr	r3, [r7, #4]
 8000cb0:	3304      	adds	r3, #4
 8000cb2:	681a      	ldr	r2, [r3, #0]
 8000cb4:	683b      	ldr	r3, [r7, #0]
 8000cb6:	609a      	str	r2, [r3, #8]
  f->__vtable_end = *((volatile uint32_t *)(address + 0x08));
 8000cb8:	687b      	ldr	r3, [r7, #4]
 8000cba:	3308      	adds	r3, #8
 8000cbc:	681a      	ldr	r2, [r3, #0]
 8000cbe:	683b      	ldr	r3, [r7, #0]
 8000cc0:	60da      	str	r2, [r3, #12]
  f->__base_address = *((volatile uint32_t *)(address + 0x0c));
 8000cc2:	687b      	ldr	r3, [r7, #4]
 8000cc4:	330c      	adds	r3, #12
 8000cc6:	681a      	ldr	r2, [r3, #0]
 8000cc8:	683b      	ldr	r3, [r7, #0]
 8000cca:	601a      	str	r2, [r3, #0]
  f->__vtable_address = *((volatile uint32_t *)(address + 0x10));
 8000ccc:	687b      	ldr	r3, [r7, #4]
 8000cce:	3310      	adds	r3, #16
 8000cd0:	681a      	ldr	r2, [r3, #0]
 8000cd2:	683b      	ldr	r3, [r7, #0]
 8000cd4:	615a      	str	r2, [r3, #20]
  f->__firmware_end = *((volatile uint32_t *)(address + 0x14));
 8000cd6:	687b      	ldr	r3, [r7, #4]
 8000cd8:	3314      	adds	r3, #20
 8000cda:	681a      	ldr	r2, [r3, #0]
 8000cdc:	683b      	ldr	r3, [r7, #0]
 8000cde:	619a      	str	r2, [r3, #24]
  f->__firmware_size = f->__firmware_end - f->__base_address;
 8000ce0:	683b      	ldr	r3, [r7, #0]
 8000ce2:	699a      	ldr	r2, [r3, #24]
 8000ce4:	683b      	ldr	r3, [r7, #0]
 8000ce6:	681b      	ldr	r3, [r3, #0]
 8000ce8:	1ad2      	subs	r2, r2, r3
 8000cea:	683b      	ldr	r3, [r7, #0]
 8000cec:	61da      	str	r2, [r3, #28]
  f->__crc_start_addr = address + 0x08;
 8000cee:	687b      	ldr	r3, [r7, #4]
 8000cf0:	f103 0208 	add.w	r2, r3, #8
 8000cf4:	683b      	ldr	r3, [r7, #0]
 8000cf6:	611a      	str	r2, [r3, #16]
  f->__crc_end_addr = f->__crc_start_addr - 0x08 + f->__firmware_size;
 8000cf8:	683b      	ldr	r3, [r7, #0]
 8000cfa:	691a      	ldr	r2, [r3, #16]
 8000cfc:	683b      	ldr	r3, [r7, #0]
 8000cfe:	69db      	ldr	r3, [r3, #28]
 8000d00:	4413      	add	r3, r2
 8000d02:	f1a3 0208 	sub.w	r2, r3, #8
 8000d06:	683b      	ldr	r3, [r7, #0]
 8000d08:	629a      	str	r2, [r3, #40]	@ 0x28
  f->__msp_value = *((volatile uint32_t *)(f->__vtable_address));
 8000d0a:	683b      	ldr	r3, [r7, #0]
 8000d0c:	695b      	ldr	r3, [r3, #20]
 8000d0e:	681a      	ldr	r2, [r3, #0]
 8000d10:	683b      	ldr	r3, [r7, #0]
 8000d12:	621a      	str	r2, [r3, #32]
  f->__reset_handler = *((volatile uint32_t *)(f->__vtable_address + 0x4));
 8000d14:	683b      	ldr	r3, [r7, #0]
 8000d16:	695b      	ldr	r3, [r3, #20]
 8000d18:	3304      	adds	r3, #4
 8000d1a:	681a      	ldr	r2, [r3, #0]
 8000d1c:	683b      	ldr	r3, [r7, #0]
 8000d1e:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000d20:	bf00      	nop
 8000d22:	370c      	adds	r7, #12
 8000d24:	46bd      	mov	sp, r7
 8000d26:	bc80      	pop	{r7}
 8000d28:	4770      	bx	lr

08000d2a <copy_firmware_t>:

void copy_firmware_t(firmware_t *f_dest, firmware_t *f_src) {
 8000d2a:	b480      	push	{r7}
 8000d2c:	b083      	sub	sp, #12
 8000d2e:	af00      	add	r7, sp, #0
 8000d30:	6078      	str	r0, [r7, #4]
 8000d32:	6039      	str	r1, [r7, #0]

  f_dest->__base_address = f_src->__base_address;
 8000d34:	683b      	ldr	r3, [r7, #0]
 8000d36:	681a      	ldr	r2, [r3, #0]
 8000d38:	687b      	ldr	r3, [r7, #4]
 8000d3a:	601a      	str	r2, [r3, #0]
  f_dest->__flag = f_src->__flag;
 8000d3c:	683b      	ldr	r3, [r7, #0]
 8000d3e:	685a      	ldr	r2, [r3, #4]
 8000d40:	687b      	ldr	r3, [r7, #4]
 8000d42:	605a      	str	r2, [r3, #4]
  f_dest->__crc = f_src->__crc;
 8000d44:	683b      	ldr	r3, [r7, #0]
 8000d46:	689a      	ldr	r2, [r3, #8]
 8000d48:	687b      	ldr	r3, [r7, #4]
 8000d4a:	609a      	str	r2, [r3, #8]
  f_dest->__vtable_end = f_src->__vtable_end;
 8000d4c:	683b      	ldr	r3, [r7, #0]
 8000d4e:	68da      	ldr	r2, [r3, #12]
 8000d50:	687b      	ldr	r3, [r7, #4]
 8000d52:	60da      	str	r2, [r3, #12]
  f_dest->__crc_start_addr = f_src->__crc_start_addr;
 8000d54:	683b      	ldr	r3, [r7, #0]
 8000d56:	691a      	ldr	r2, [r3, #16]
 8000d58:	687b      	ldr	r3, [r7, #4]
 8000d5a:	611a      	str	r2, [r3, #16]
  f_dest->__crc_end_addr = f_src->__crc_end_addr;
 8000d5c:	683b      	ldr	r3, [r7, #0]
 8000d5e:	6a9a      	ldr	r2, [r3, #40]	@ 0x28
 8000d60:	687b      	ldr	r3, [r7, #4]
 8000d62:	629a      	str	r2, [r3, #40]	@ 0x28
  f_dest->__vtable_address = f_src->__vtable_address;
 8000d64:	683b      	ldr	r3, [r7, #0]
 8000d66:	695a      	ldr	r2, [r3, #20]
 8000d68:	687b      	ldr	r3, [r7, #4]
 8000d6a:	615a      	str	r2, [r3, #20]
  f_dest->__firmware_end = f_src->__firmware_end;
 8000d6c:	683b      	ldr	r3, [r7, #0]
 8000d6e:	699a      	ldr	r2, [r3, #24]
 8000d70:	687b      	ldr	r3, [r7, #4]
 8000d72:	619a      	str	r2, [r3, #24]
  f_dest->__firmware_size = f_src->__firmware_size;
 8000d74:	683b      	ldr	r3, [r7, #0]
 8000d76:	69da      	ldr	r2, [r3, #28]
 8000d78:	687b      	ldr	r3, [r7, #4]
 8000d7a:	61da      	str	r2, [r3, #28]
  f_dest->__msp_value = f_src->__msp_value;
 8000d7c:	683b      	ldr	r3, [r7, #0]
 8000d7e:	6a1a      	ldr	r2, [r3, #32]
 8000d80:	687b      	ldr	r3, [r7, #4]
 8000d82:	621a      	str	r2, [r3, #32]
  f_dest->__reset_handler = f_src->__reset_handler;
 8000d84:	683b      	ldr	r3, [r7, #0]
 8000d86:	6a5a      	ldr	r2, [r3, #36]	@ 0x24
 8000d88:	687b      	ldr	r3, [r7, #4]
 8000d8a:	625a      	str	r2, [r3, #36]	@ 0x24
}
 8000d8c:	bf00      	nop
 8000d8e:	370c      	adds	r7, #12
 8000d90:	46bd      	mov	sp, r7
 8000d92:	bc80      	pop	{r7}
 8000d94:	4770      	bx	lr

08000d96 <handle_update>:

void handle_update(void) {
 8000d96:	b580      	push	{r7, lr}
 8000d98:	b098      	sub	sp, #96	@ 0x60
 8000d9a:	af00      	add	r7, sp, #0

  /************************* recieve update and store it in
   * RAM***********************/

  if (recieve_update()) {
 8000d9c:	f7ff fdb6 	bl	800090c <recieve_update>
 8000da0:	4603      	mov	r3, r0
 8000da2:	2b00      	cmp	r3, #0
 8000da4:	d004      	beq.n	8000db0 <handle_update+0x1a>
    printf("ERROR in recieving update\n\r", 0x0);
 8000da6:	2100      	movs	r1, #0
 8000da8:	484d      	ldr	r0, [pc, #308]	@ (8000ee0 <handle_update+0x14a>)
 8000daa:	f7ff fd1f 	bl	80007ec <printf>
    return;
 8000dae:	e094      	b.n	8000eda <handle_update+0x144>
  }
  firmware_t f;
  update_size = update_size / 4 * 4 + 4; // align update size by 4bytes
 8000db0:	4b4c      	ldr	r3, [pc, #304]	@ (8000ee4 <handle_update+0x14e>)
 8000db2:	681b      	ldr	r3, [r3, #0]
 8000db4:	f023 0303 	bic.w	r3, r3, #3
 8000db8:	3304      	adds	r3, #4
 8000dba:	4a4a      	ldr	r2, [pc, #296]	@ (8000ee4 <handle_update+0x14e>)
 8000dbc:	6013      	str	r3, [r2, #0]

  if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_1_ADDRESS)
 8000dbe:	4b4a      	ldr	r3, [pc, #296]	@ (8000ee8 <handle_update+0x152>)
 8000dc0:	681b      	ldr	r3, [r3, #0]
 8000dc2:	4a4a      	ldr	r2, [pc, #296]	@ (8000eec <handle_update+0x156>)
 8000dc4:	4293      	cmp	r3, r2
 8000dc6:	d106      	bne.n	8000dd6 <handle_update+0x40>
    copy_firmware_t(&f, &f1);
 8000dc8:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000dcc:	4948      	ldr	r1, [pc, #288]	@ (8000ef0 <handle_update+0x15a>)
 8000dce:	4618      	mov	r0, r3
 8000dd0:	f7ff ffab 	bl	8000d2a <copy_firmware_t>
 8000dd4:	e010      	b.n	8000df8 <handle_update+0x62>

  else if (*(uint32_t *)(UPDATE_ADDR + 0x0c) == FIRMWARE_2_ADDRESS)
 8000dd6:	4b44      	ldr	r3, [pc, #272]	@ (8000ee8 <handle_update+0x152>)
 8000dd8:	681b      	ldr	r3, [r3, #0]
 8000dda:	4a46      	ldr	r2, [pc, #280]	@ (8000ef4 <handle_update+0x15e>)
 8000ddc:	4293      	cmp	r3, r2
 8000dde:	d106      	bne.n	8000dee <handle_update+0x58>
    copy_firmware_t(&f, &f2);
 8000de0:	f107 0334 	add.w	r3, r7, #52	@ 0x34
 8000de4:	4944      	ldr	r1, [pc, #272]	@ (8000ef8 <handle_update+0x162>)
 8000de6:	4618      	mov	r0, r3
 8000de8:	f7ff ff9f 	bl	8000d2a <copy_firmware_t>
 8000dec:	e004      	b.n	8000df8 <handle_update+0x62>

  else {
    printf("wrong firmware base address !!!", 0x0);
 8000dee:	2100      	movs	r1, #0
 8000df0:	4842      	ldr	r0, [pc, #264]	@ (8000efc <handle_update+0x166>)
 8000df2:	f7ff fcfb 	bl	80007ec <printf>
    return;
 8000df6:	e070      	b.n	8000eda <handle_update+0x144>
  // if (flash_write(UPDATE_ADDR, fw_update, update_size, NO_DELAY)) {
  //   printf("ERROR in flash_write\n\r", 0x0);
  //   return;
  // }

  printf("update has been saved in the update section !!!\n\r", 0x0);
 8000df8:	2100      	movs	r1, #0
 8000dfa:	4841      	ldr	r0, [pc, #260]	@ (8000f00 <handle_update+0x16a>)
 8000dfc:	f7ff fcf6 	bl	80007ec <printf>

  firmware_t uf;
  init_firmware_t(UPDATE_ADDR, &uf);
 8000e00:	f107 0308 	add.w	r3, r7, #8
 8000e04:	4619      	mov	r1, r3
 8000e06:	483f      	ldr	r0, [pc, #252]	@ (8000f04 <handle_update+0x16e>)
 8000e08:	f7ff ff48 	bl	8000c9c <init_firmware_t>

  printf("***************validating update***************\n\r", 0x0);
 8000e0c:	2100      	movs	r1, #0
 8000e0e:	483e      	ldr	r0, [pc, #248]	@ (8000f08 <handle_update+0x172>)
 8000e10:	f7ff fcec 	bl	80007ec <printf>

  // check flag field of the firmware
  if (uf.__flag != 0xffffffff) {
 8000e14:	68fb      	ldr	r3, [r7, #12]
 8000e16:	f1b3 3fff 	cmp.w	r3, #4294967295	@ 0xffffffff
 8000e1a:	d004      	beq.n	8000e26 <handle_update+0x90>
    printf("ERROR .... flag field of update must be 0xffffffff\n\r", 0x0);
 8000e1c:	2100      	movs	r1, #0
 8000e1e:	483b      	ldr	r0, [pc, #236]	@ (8000f0c <handle_update+0x176>)
 8000e20:	f7ff fce4 	bl	80007ec <printf>
    return;
 8000e24:	e059      	b.n	8000eda <handle_update+0x144>
  }
  if (!validate_firmware(&uf)) {
 8000e26:	f107 0308 	add.w	r3, r7, #8
 8000e2a:	4618      	mov	r0, r3
 8000e2c:	f000 fa96 	bl	800135c <validate_firmware>
 8000e30:	4603      	mov	r3, r0
 8000e32:	f083 0301 	eor.w	r3, r3, #1
 8000e36:	b2db      	uxtb	r3, r3
 8000e38:	2b00      	cmp	r3, #0
 8000e3a:	d004      	beq.n	8000e46 <handle_update+0xb0>
    printf("ERROR .... update validation failed\n\r", 0x0);
 8000e3c:	2100      	movs	r1, #0
 8000e3e:	4834      	ldr	r0, [pc, #208]	@ (8000f10 <handle_update+0x17a>)
 8000e40:	f7ff fcd4 	bl	80007ec <printf>
    return;
 8000e44:	e049      	b.n	8000eda <handle_update+0x144>
  }

  /************************firmware to COPY section
   * ***********************************/

  if (erase_flash(COPY_ADDR)) {
 8000e46:	4833      	ldr	r0, [pc, #204]	@ (8000f14 <handle_update+0x17e>)
 8000e48:	f7ff fa0a 	bl	8000260 <erase_flash>
 8000e4c:	4603      	mov	r3, r0
 8000e4e:	2b00      	cmp	r3, #0
 8000e50:	d004      	beq.n	8000e5c <handle_update+0xc6>
    printf("could not erase COPY section\n\r", 0x0);
 8000e52:	2100      	movs	r1, #0
 8000e54:	4830      	ldr	r0, [pc, #192]	@ (8000f18 <handle_update+0x182>)
 8000e56:	f7ff fcc9 	bl	80007ec <printf>
    return;
 8000e5a:	e03e      	b.n	8000eda <handle_update+0x144>
  }
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000e5c:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000e5e:	4619      	mov	r1, r3
                  f.__firmware_size, NO_DELAY)) {
 8000e60:	6d3a      	ldr	r2, [r7, #80]	@ 0x50
  if (flash_write(COPY_ADDR, (const char *)(f.__base_address),
 8000e62:	2300      	movs	r3, #0
 8000e64:	482b      	ldr	r0, [pc, #172]	@ (8000f14 <handle_update+0x17e>)
 8000e66:	f7ff fab5 	bl	80003d4 <flash_write>
 8000e6a:	4603      	mov	r3, r0
 8000e6c:	2b00      	cmp	r3, #0
 8000e6e:	d004      	beq.n	8000e7a <handle_update+0xe4>

    printf("could not write to the COPY section \n\r", 0x0);
 8000e70:	2100      	movs	r1, #0
 8000e72:	482a      	ldr	r0, [pc, #168]	@ (8000f1c <handle_update+0x186>)
 8000e74:	f7ff fcba 	bl	80007ec <printf>
    return;
 8000e78:	e02f      	b.n	8000eda <handle_update+0x144>
  } // check this !!
  printf("firmware is copied to copy section\n\r", 0x0);
 8000e7a:	2100      	movs	r1, #0
 8000e7c:	4828      	ldr	r0, [pc, #160]	@ (8000f20 <handle_update+0x18a>)
 8000e7e:	f7ff fcb5 	bl	80007ec <printf>

  /********************* update to firmware
   * ********************************************/

  if (erase_flash(f.__base_address)) {
 8000e82:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000e84:	4618      	mov	r0, r3
 8000e86:	f7ff f9eb 	bl	8000260 <erase_flash>
 8000e8a:	4603      	mov	r3, r0
 8000e8c:	2b00      	cmp	r3, #0
 8000e8e:	d004      	beq.n	8000e9a <handle_update+0x104>
    printf("could not erase FIRMWARE section\n\r", 0x0);
 8000e90:	2100      	movs	r1, #0
 8000e92:	4824      	ldr	r0, [pc, #144]	@ (8000f24 <handle_update+0x18e>)
 8000e94:	f7ff fcaa 	bl	80007ec <printf>
    return;
 8000e98:	e01f      	b.n	8000eda <handle_update+0x144>
  }
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000e9a:	6b78      	ldr	r0, [r7, #52]	@ 0x34
                  uf.__firmware_size, NO_DELAY)) {
 8000e9c:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
  if (flash_write(f.__base_address, (const char *)(UPDATE_ADDR),
 8000e9e:	2300      	movs	r3, #0
 8000ea0:	4918      	ldr	r1, [pc, #96]	@ (8000f04 <handle_update+0x16e>)
 8000ea2:	f7ff fa97 	bl	80003d4 <flash_write>
 8000ea6:	4603      	mov	r3, r0
 8000ea8:	2b00      	cmp	r3, #0
 8000eaa:	d004      	beq.n	8000eb6 <handle_update+0x120>

    printf("could not write to the firmware section\n\r", 0x0);
 8000eac:	2100      	movs	r1, #0
 8000eae:	481e      	ldr	r0, [pc, #120]	@ (8000f28 <handle_update+0x192>)
 8000eb0:	f7ff fc9c 	bl	80007ec <printf>
    return;
 8000eb4:	e011      	b.n	8000eda <handle_update+0x144>
  }

  const uint32_t end = 0xfffffffe;
 8000eb6:	f06f 0301 	mvn.w	r3, #1
 8000eba:	607b      	str	r3, [r7, #4]
  // mark the flag implying that firmware has been updated
  flash_write(f.__base_address, (const char *)(&end), 4, NO_DELAY);
 8000ebc:	6b78      	ldr	r0, [r7, #52]	@ 0x34
 8000ebe:	1d39      	adds	r1, r7, #4
 8000ec0:	2300      	movs	r3, #0
 8000ec2:	2204      	movs	r2, #4
 8000ec4:	f7ff fa86 	bl	80003d4 <flash_write>

  printf("new flag = %\n\r", f.__base_address);
 8000ec8:	6b7b      	ldr	r3, [r7, #52]	@ 0x34
 8000eca:	4619      	mov	r1, r3
 8000ecc:	4817      	ldr	r0, [pc, #92]	@ (8000f2c <handle_update+0x196>)
 8000ece:	f7ff fc8d 	bl	80007ec <printf>

  printf("updating firmware is done successfully!!!!\n\r", 0x0);
 8000ed2:	2100      	movs	r1, #0
 8000ed4:	4816      	ldr	r0, [pc, #88]	@ (8000f30 <handle_update+0x19a>)
 8000ed6:	f7ff fc89 	bl	80007ec <printf>
}
 8000eda:	3760      	adds	r7, #96	@ 0x60
 8000edc:	46bd      	mov	sp, r7
 8000ede:	bd80      	pop	{r7, pc}
 8000ee0:	08001754 	.word	0x08001754
 8000ee4:	2000007c 	.word	0x2000007c
 8000ee8:	0804000c 	.word	0x0804000c
 8000eec:	08010000 	.word	0x08010000
 8000ef0:	20000010 	.word	0x20000010
 8000ef4:	08020000 	.word	0x08020000
 8000ef8:	2000003c 	.word	0x2000003c
 8000efc:	08001770 	.word	0x08001770
 8000f00:	08001790 	.word	0x08001790
 8000f04:	08040000 	.word	0x08040000
 8000f08:	080017c4 	.word	0x080017c4
 8000f0c:	080017f8 	.word	0x080017f8
 8000f10:	08001830 	.word	0x08001830
 8000f14:	08060000 	.word	0x08060000
 8000f18:	08001858 	.word	0x08001858
 8000f1c:	08001878 	.word	0x08001878
 8000f20:	080018a0 	.word	0x080018a0
 8000f24:	080018c8 	.word	0x080018c8
 8000f28:	080018ec 	.word	0x080018ec
 8000f2c:	08001918 	.word	0x08001918
 8000f30:	08001928 	.word	0x08001928

08000f34 <main>:

int main() {
 8000f34:	b580      	push	{r7, lr}
 8000f36:	b082      	sub	sp, #8
 8000f38:	af00      	add	r7, sp, #0

    Ring_buff_init(&ringbuffer);
 8000f3a:	4868      	ldr	r0, [pc, #416]	@ (80010dc <main+0x1a8>)
 8000f3c:	f7ff fdcc 	bl	8000ad8 <Ring_buff_init>

    // enable faults (without this any fault = hardfault)
    SCB->SHCSR |= SCB_SHCSR_BUSFAULTENA_Msk;
 8000f40:	4b67      	ldr	r3, [pc, #412]	@ (80010e0 <main+0x1ac>)
 8000f42:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f44:	4a66      	ldr	r2, [pc, #408]	@ (80010e0 <main+0x1ac>)
 8000f46:	f443 3300 	orr.w	r3, r3, #131072	@ 0x20000
 8000f4a:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_USGFAULTENA_Msk;
 8000f4c:	4b64      	ldr	r3, [pc, #400]	@ (80010e0 <main+0x1ac>)
 8000f4e:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f50:	4a63      	ldr	r2, [pc, #396]	@ (80010e0 <main+0x1ac>)
 8000f52:	f443 2380 	orr.w	r3, r3, #262144	@ 0x40000
 8000f56:	6253      	str	r3, [r2, #36]	@ 0x24
    SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
 8000f58:	4b61      	ldr	r3, [pc, #388]	@ (80010e0 <main+0x1ac>)
 8000f5a:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
 8000f5c:	4a60      	ldr	r2, [pc, #384]	@ (80010e0 <main+0x1ac>)
 8000f5e:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
 8000f62:	6253      	str	r3, [r2, #36]	@ 0x24


  __usart1_init();
 8000f64:	f7ff f900 	bl	8000168 <__usart1_init>

  printf("\n\n\nbooting....\n\n\n\r", 0x0);
 8000f68:	2100      	movs	r1, #0
 8000f6a:	485e      	ldr	r0, [pc, #376]	@ (80010e4 <main+0x1b0>)
 8000f6c:	f7ff fc3e 	bl	80007ec <printf>

  // check if fimrware is corrupted during update

  if (*(uint32_t *)FIRMWARE_1_ADDRESS & 1) {
 8000f70:	4b5d      	ldr	r3, [pc, #372]	@ (80010e8 <main+0x1b4>)
 8000f72:	681b      	ldr	r3, [r3, #0]
 8000f74:	f003 0301 	and.w	r3, r3, #1
 8000f78:	2b00      	cmp	r3, #0
 8000f7a:	d001      	beq.n	8000f80 <main+0x4c>
    rollback();
 8000f7c:	f7ff fd62 	bl	8000a44 <rollback>
  }
  if (*(uint32_t *)FIRMWARE_2_ADDRESS & 1) {
 8000f80:	4b5a      	ldr	r3, [pc, #360]	@ (80010ec <main+0x1b8>)
 8000f82:	681b      	ldr	r3, [r3, #0]
 8000f84:	f003 0301 	and.w	r3, r3, #1
 8000f88:	2b00      	cmp	r3, #0
 8000f8a:	d001      	beq.n	8000f90 <main+0x5c>
    rollback();
 8000f8c:	f7ff fd5a 	bl	8000a44 <rollback>
  }

  bool f1_valid = true;
 8000f90:	2301      	movs	r3, #1
 8000f92:	71fb      	strb	r3, [r7, #7]
  bool f2_valid = true;
 8000f94:	2301      	movs	r3, #1
 8000f96:	71bb      	strb	r3, [r7, #6]
  init_firmware_t(FIRMWARE_1_ADDRESS, &f1);
 8000f98:	4955      	ldr	r1, [pc, #340]	@ (80010f0 <main+0x1bc>)
 8000f9a:	4853      	ldr	r0, [pc, #332]	@ (80010e8 <main+0x1b4>)
 8000f9c:	f7ff fe7e 	bl	8000c9c <init_firmware_t>
  init_firmware_t(FIRMWARE_2_ADDRESS, &f2);
 8000fa0:	4954      	ldr	r1, [pc, #336]	@ (80010f4 <main+0x1c0>)
 8000fa2:	4852      	ldr	r0, [pc, #328]	@ (80010ec <main+0x1b8>)
 8000fa4:	f7ff fe7a 	bl	8000c9c <init_firmware_t>

  // printf("hii there %\n\r", f1.__vtable_address);

  printf("*************validating firmware1*************\n\r", 0x0);
 8000fa8:	2100      	movs	r1, #0
 8000faa:	4853      	ldr	r0, [pc, #332]	@ (80010f8 <main+0x1c4>)
 8000fac:	f7ff fc1e 	bl	80007ec <printf>
  f1_valid = validate_firmware(&f1);
 8000fb0:	484f      	ldr	r0, [pc, #316]	@ (80010f0 <main+0x1bc>)
 8000fb2:	f000 f9d3 	bl	800135c <validate_firmware>
 8000fb6:	4603      	mov	r3, r0
 8000fb8:	71fb      	strb	r3, [r7, #7]
  printf("*************validating firmware2*************\n\r", 0x0);
 8000fba:	2100      	movs	r1, #0
 8000fbc:	484f      	ldr	r0, [pc, #316]	@ (80010fc <main+0x1c8>)
 8000fbe:	f7ff fc15 	bl	80007ec <printf>
  f2_valid = validate_firmware(&f2);
 8000fc2:	484c      	ldr	r0, [pc, #304]	@ (80010f4 <main+0x1c0>)
 8000fc4:	f000 f9ca 	bl	800135c <validate_firmware>
 8000fc8:	4603      	mov	r3, r0
 8000fca:	71bb      	strb	r3, [r7, #6]

  printf("both the firmwares are checked\n\r", 0x0);
 8000fcc:	2100      	movs	r1, #0
 8000fce:	484c      	ldr	r0, [pc, #304]	@ (8001100 <main+0x1cc>)
 8000fd0:	f7ff fc0c 	bl	80007ec <printf>
  // init GPIOC (for on board switch)
  // init SYSCGF (for using EXTI)

  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN_Msk;
 8000fd4:	4b4b      	ldr	r3, [pc, #300]	@ (8001104 <main+0x1d0>)
 8000fd6:	6c5b      	ldr	r3, [r3, #68]	@ 0x44
 8000fd8:	4a4a      	ldr	r2, [pc, #296]	@ (8001104 <main+0x1d0>)
 8000fda:	f443 4380 	orr.w	r3, r3, #16384	@ 0x4000
 8000fde:	6453      	str	r3, [r2, #68]	@ 0x44
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN_Msk;
 8000fe0:	4b48      	ldr	r3, [pc, #288]	@ (8001104 <main+0x1d0>)
 8000fe2:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
 8000fe4:	4a47      	ldr	r2, [pc, #284]	@ (8001104 <main+0x1d0>)
 8000fe6:	f043 0304 	orr.w	r3, r3, #4
 8000fea:	6313      	str	r3, [r2, #48]	@ 0x30

  // set switch to input
  GPIOC->MODER &= ~(3U << (2 * SWITCH_PIN));
 8000fec:	4b46      	ldr	r3, [pc, #280]	@ (8001108 <main+0x1d4>)
 8000fee:	681b      	ldr	r3, [r3, #0]
 8000ff0:	4a45      	ldr	r2, [pc, #276]	@ (8001108 <main+0x1d4>)
 8000ff2:	f023 6340 	bic.w	r3, r3, #201326592	@ 0xc000000
 8000ff6:	6013      	str	r3, [r2, #0]

  // falling edge detect
  EXTI->FTSR |= EXTI_FTSR_TR13_Msk;
 8000ff8:	4b44      	ldr	r3, [pc, #272]	@ (800110c <main+0x1d8>)
 8000ffa:	68db      	ldr	r3, [r3, #12]
 8000ffc:	4a43      	ldr	r2, [pc, #268]	@ (800110c <main+0x1d8>)
 8000ffe:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8001002:	60d3      	str	r3, [r2, #12]

  SYSCFG->EXTICR[3] &= ~(SYSCFG_EXTICR4_EXTI13_Msk);
 8001004:	4b42      	ldr	r3, [pc, #264]	@ (8001110 <main+0x1dc>)
 8001006:	695b      	ldr	r3, [r3, #20]
 8001008:	4a41      	ldr	r2, [pc, #260]	@ (8001110 <main+0x1dc>)
 800100a:	f023 03f0 	bic.w	r3, r3, #240	@ 0xf0
 800100e:	6153      	str	r3, [r2, #20]
  SYSCFG->EXTICR[3] |= SYSCFG_EXTICR4_EXTI13_PC;
 8001010:	4b3f      	ldr	r3, [pc, #252]	@ (8001110 <main+0x1dc>)
 8001012:	695b      	ldr	r3, [r3, #20]
 8001014:	4a3e      	ldr	r2, [pc, #248]	@ (8001110 <main+0x1dc>)
 8001016:	f043 0320 	orr.w	r3, r3, #32
 800101a:	6153      	str	r3, [r2, #20]

  // enable mask at the end
  EXTI->IMR |= EXTI_IMR_MR13_Msk;
 800101c:	4b3b      	ldr	r3, [pc, #236]	@ (800110c <main+0x1d8>)
 800101e:	681b      	ldr	r3, [r3, #0]
 8001020:	4a3a      	ldr	r2, [pc, #232]	@ (800110c <main+0x1d8>)
 8001022:	f443 5300 	orr.w	r3, r3, #8192	@ 0x2000
 8001026:	6013      	str	r3, [r2, #0]

  NVIC_EnableIRQ(EXTI15_10_IRQn);
 8001028:	2028      	movs	r0, #40	@ 0x28
 800102a:	f7ff fe1b 	bl	8000c64 <__NVIC_EnableIRQ>

  if (!f1_valid && !f2_valid) {
 800102e:	79fb      	ldrb	r3, [r7, #7]
 8001030:	f083 0301 	eor.w	r3, r3, #1
 8001034:	b2db      	uxtb	r3, r3
 8001036:	2b00      	cmp	r3, #0
 8001038:	d011      	beq.n	800105e <main+0x12a>
 800103a:	79bb      	ldrb	r3, [r7, #6]
 800103c:	f083 0301 	eor.w	r3, r3, #1
 8001040:	b2db      	uxtb	r3, r3
 8001042:	2b00      	cmp	r3, #0
 8001044:	d00b      	beq.n	800105e <main+0x12a>
    printf("both the firmwares are not valid\n\n\r", 0x0);
 8001046:	2100      	movs	r1, #0
 8001048:	4832      	ldr	r0, [pc, #200]	@ (8001114 <main+0x1e0>)
 800104a:	f7ff fbcf 	bl	80007ec <printf>
    EXTI->IMR &= EXTI_IMR_MR13_Msk;
 800104e:	4b2f      	ldr	r3, [pc, #188]	@ (800110c <main+0x1d8>)
 8001050:	681b      	ldr	r3, [r3, #0]
 8001052:	4a2e      	ldr	r2, [pc, #184]	@ (800110c <main+0x1d8>)
 8001054:	f403 5300 	and.w	r3, r3, #8192	@ 0x2000
 8001058:	6013      	str	r3, [r2, #0]
    handle_update();
 800105a:	f7ff fe9c 	bl	8000d96 <handle_update>
  // /* illegal memory access */
  // *(uint32_t *) (0xffffffff) = 0;



  while (!press_count)
 800105e:	bf00      	nop
 8001060:	4b2d      	ldr	r3, [pc, #180]	@ (8001118 <main+0x1e4>)
 8001062:	681b      	ldr	r3, [r3, #0]
 8001064:	2b00      	cmp	r3, #0
 8001066:	d0fb      	beq.n	8001060 <main+0x12c>
    ;
  delay_count = 1000000;
 8001068:	4b2c      	ldr	r3, [pc, #176]	@ (800111c <main+0x1e8>)
 800106a:	4a2d      	ldr	r2, [pc, #180]	@ (8001120 <main+0x1ec>)
 800106c:	601a      	str	r2, [r3, #0]
  while (delay_count--)
 800106e:	bf00      	nop
 8001070:	4b2a      	ldr	r3, [pc, #168]	@ (800111c <main+0x1e8>)
 8001072:	681b      	ldr	r3, [r3, #0]
 8001074:	1e5a      	subs	r2, r3, #1
 8001076:	4929      	ldr	r1, [pc, #164]	@ (800111c <main+0x1e8>)
 8001078:	600a      	str	r2, [r1, #0]
 800107a:	2b00      	cmp	r3, #0
 800107c:	d1f8      	bne.n	8001070 <main+0x13c>
    ;
  if (press_count >= 3) {
 800107e:	4b26      	ldr	r3, [pc, #152]	@ (8001118 <main+0x1e4>)
 8001080:	681b      	ldr	r3, [r3, #0]
 8001082:	2b02      	cmp	r3, #2
 8001084:	d908      	bls.n	8001098 <main+0x164>
    erase_flash (UPDATE_ADDR);
 8001086:	4827      	ldr	r0, [pc, #156]	@ (8001124 <main+0x1f0>)
 8001088:	f7ff f8ea 	bl	8000260 <erase_flash>
    firmware_update_mode = true;
 800108c:	4b26      	ldr	r3, [pc, #152]	@ (8001128 <main+0x1f4>)
 800108e:	2201      	movs	r2, #1
 8001090:	701a      	strb	r2, [r3, #0]
    handle_update();
 8001092:	f7ff fe80 	bl	8000d96 <handle_update>
 8001096:	e020      	b.n	80010da <main+0x1a6>
  } else if (press_count == 2) {
 8001098:	4b1f      	ldr	r3, [pc, #124]	@ (8001118 <main+0x1e4>)
 800109a:	681b      	ldr	r3, [r3, #0]
 800109c:	2b02      	cmp	r3, #2
 800109e:	d10e      	bne.n	80010be <main+0x18a>
    if (f2_valid) {
 80010a0:	79bb      	ldrb	r3, [r7, #6]
 80010a2:	2b00      	cmp	r3, #0
 80010a4:	d005      	beq.n	80010b2 <main+0x17e>
      boot_f1 = false;
 80010a6:	4b21      	ldr	r3, [pc, #132]	@ (800112c <main+0x1f8>)
 80010a8:	2200      	movs	r2, #0
 80010aa:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 80010ac:	f7ff facc 	bl	8000648 <jump_to_firmware>
 80010b0:	e013      	b.n	80010da <main+0x1a6>
    } else {
      boot_f1 = true;
 80010b2:	4b1e      	ldr	r3, [pc, #120]	@ (800112c <main+0x1f8>)
 80010b4:	2201      	movs	r2, #1
 80010b6:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 80010b8:	f7ff fac6 	bl	8000648 <jump_to_firmware>
 80010bc:	e00d      	b.n	80010da <main+0x1a6>
    }
  } else {
    if (f1_valid) {
 80010be:	79fb      	ldrb	r3, [r7, #7]
 80010c0:	2b00      	cmp	r3, #0
 80010c2:	d005      	beq.n	80010d0 <main+0x19c>
      boot_f1 = true;
 80010c4:	4b19      	ldr	r3, [pc, #100]	@ (800112c <main+0x1f8>)
 80010c6:	2201      	movs	r2, #1
 80010c8:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 80010ca:	f7ff fabd 	bl	8000648 <jump_to_firmware>
 80010ce:	e004      	b.n	80010da <main+0x1a6>
    } else {
      boot_f1 = false;
 80010d0:	4b16      	ldr	r3, [pc, #88]	@ (800112c <main+0x1f8>)
 80010d2:	2200      	movs	r2, #0
 80010d4:	701a      	strb	r2, [r3, #0]
      jump_to_firmware();
 80010d6:	f7ff fab7 	bl	8000648 <jump_to_firmware>
    }
  }
  while (1);
 80010da:	e7fe      	b.n	80010da <main+0x1a6>
 80010dc:	20000080 	.word	0x20000080
 80010e0:	e000ed00 	.word	0xe000ed00
 80010e4:	08001958 	.word	0x08001958
 80010e8:	08010000 	.word	0x08010000
 80010ec:	08020000 	.word	0x08020000
 80010f0:	20000010 	.word	0x20000010
 80010f4:	2000003c 	.word	0x2000003c
 80010f8:	0800196c 	.word	0x0800196c
 80010fc:	080019a0 	.word	0x080019a0
 8001100:	080019d4 	.word	0x080019d4
 8001104:	40023800 	.word	0x40023800
 8001108:	40020800 	.word	0x40020800
 800110c:	40013c00 	.word	0x40013c00
 8001110:	40013800 	.word	0x40013800
 8001114:	080019f8 	.word	0x080019f8
 8001118:	20000068 	.word	0x20000068
 800111c:	2000006c 	.word	0x2000006c
 8001120:	000f4240 	.word	0x000f4240
 8001124:	08040000 	.word	0x08040000
 8001128:	20005086 	.word	0x20005086
 800112c:	20000004 	.word	0x20000004

08001130 <switch_pressed>:
extern volatile Ring_buff_t ringbuffer;




void switch_pressed(void){  
 8001130:	b480      	push	{r7}
 8001132:	af00      	add	r7, sp, #0
    // clear the pending status (not done by hardware)
    EXTI-> PR = EXTI_PR_PR13_Msk;
 8001134:	4b0e      	ldr	r3, [pc, #56]	@ (8001170 <switch_pressed+0x40>)
 8001136:	f44f 5200 	mov.w	r2, #8192	@ 0x2000
 800113a:	615a      	str	r2, [r3, #20]

    press_count++;
 800113c:	4b0d      	ldr	r3, [pc, #52]	@ (8001174 <switch_pressed+0x44>)
 800113e:	681b      	ldr	r3, [r3, #0]
 8001140:	3301      	adds	r3, #1
 8001142:	4a0c      	ldr	r2, [pc, #48]	@ (8001174 <switch_pressed+0x44>)
 8001144:	6013      	str	r3, [r2, #0]
    if (press_count == 3){
 8001146:	4b0b      	ldr	r3, [pc, #44]	@ (8001174 <switch_pressed+0x44>)
 8001148:	681b      	ldr	r3, [r3, #0]
 800114a:	2b03      	cmp	r3, #3
 800114c:	d10b      	bne.n	8001166 <switch_pressed+0x36>
        delay_count = 100;
 800114e:	4b0a      	ldr	r3, [pc, #40]	@ (8001178 <switch_pressed+0x48>)
 8001150:	2264      	movs	r2, #100	@ 0x64
 8001152:	601a      	str	r2, [r3, #0]
        recieve_size = true;
 8001154:	4b09      	ldr	r3, [pc, #36]	@ (800117c <switch_pressed+0x4c>)
 8001156:	2201      	movs	r2, #1
 8001158:	701a      	strb	r2, [r3, #0]
        EXTI-> IMR &= ~EXTI_IMR_MR13_Msk;
 800115a:	4b05      	ldr	r3, [pc, #20]	@ (8001170 <switch_pressed+0x40>)
 800115c:	681b      	ldr	r3, [r3, #0]
 800115e:	4a04      	ldr	r2, [pc, #16]	@ (8001170 <switch_pressed+0x40>)
 8001160:	f423 5300 	bic.w	r3, r3, #8192	@ 0x2000
 8001164:	6013      	str	r3, [r2, #0]
    }
}
 8001166:	bf00      	nop
 8001168:	46bd      	mov	sp, r7
 800116a:	bc80      	pop	{r7}
 800116c:	4770      	bx	lr
 800116e:	bf00      	nop
 8001170:	40013c00 	.word	0x40013c00
 8001174:	20000068 	.word	0x20000068
 8001178:	2000006c 	.word	0x2000006c
 800117c:	20000008 	.word	0x20000008

08001180 <USART1_IRQHandler>:
void USART1_IRQHandler (void){
 8001180:	b580      	push	{r7, lr}
 8001182:	b082      	sub	sp, #8
 8001184:	af00      	add	r7, sp, #0
  if (!firmware_update_mode) return;
 8001186:	4b26      	ldr	r3, [pc, #152]	@ (8001220 <USART1_IRQHandler+0xa0>)
 8001188:	781b      	ldrb	r3, [r3, #0]
 800118a:	f083 0301 	eor.w	r3, r3, #1
 800118e:	b2db      	uxtb	r3, r3
 8001190:	2b00      	cmp	r3, #0
 8001192:	d141      	bne.n	8001218 <USART1_IRQHandler+0x98>
  if (USART1 -> SR & USART_SR_RXNE_Msk){
 8001194:	4b23      	ldr	r3, [pc, #140]	@ (8001224 <USART1_IRQHandler+0xa4>)
 8001196:	681b      	ldr	r3, [r3, #0]
 8001198:	f003 0320 	and.w	r3, r3, #32
 800119c:	2b00      	cmp	r3, #0
 800119e:	d03c      	beq.n	800121a <USART1_IRQHandler+0x9a>
    if (recieve_size){
 80011a0:	4b21      	ldr	r3, [pc, #132]	@ (8001228 <USART1_IRQHandler+0xa8>)
 80011a2:	781b      	ldrb	r3, [r3, #0]
 80011a4:	b2db      	uxtb	r3, r3
 80011a6:	2b00      	cmp	r3, #0
 80011a8:	d02b      	beq.n	8001202 <USART1_IRQHandler+0x82>
      char digit = '\0';
 80011aa:	2300      	movs	r3, #0
 80011ac:	71fb      	strb	r3, [r7, #7]
      digit = USART1-> DR;
 80011ae:	4b1d      	ldr	r3, [pc, #116]	@ (8001224 <USART1_IRQHandler+0xa4>)
 80011b0:	685b      	ldr	r3, [r3, #4]
 80011b2:	71fb      	strb	r3, [r7, #7]
      if (digit == '\n'){
 80011b4:	79fb      	ldrb	r3, [r7, #7]
 80011b6:	2b0a      	cmp	r3, #10
 80011b8:	d103      	bne.n	80011c2 <USART1_IRQHandler+0x42>
        flag_size_recieved = true;
 80011ba:	4b1c      	ldr	r3, [pc, #112]	@ (800122c <USART1_IRQHandler+0xac>)
 80011bc:	2201      	movs	r2, #1
 80011be:	701a      	strb	r2, [r3, #0]
        return;
 80011c0:	e02b      	b.n	800121a <USART1_IRQHandler+0x9a>
      }
      if (digit < '0' || digit > '9'){
 80011c2:	79fb      	ldrb	r3, [r7, #7]
 80011c4:	2b2f      	cmp	r3, #47	@ 0x2f
 80011c6:	d902      	bls.n	80011ce <USART1_IRQHandler+0x4e>
 80011c8:	79fb      	ldrb	r3, [r7, #7]
 80011ca:	2b39      	cmp	r3, #57	@ 0x39
 80011cc:	d903      	bls.n	80011d6 <USART1_IRQHandler+0x56>
        flag_wrong_size = true;
 80011ce:	4b18      	ldr	r3, [pc, #96]	@ (8001230 <USART1_IRQHandler+0xb0>)
 80011d0:	2201      	movs	r2, #1
 80011d2:	701a      	strb	r2, [r3, #0]
        return;
 80011d4:	e021      	b.n	800121a <USART1_IRQHandler+0x9a>
      }
      if (update_size > 128*1024){
 80011d6:	4b17      	ldr	r3, [pc, #92]	@ (8001234 <USART1_IRQHandler+0xb4>)
 80011d8:	681b      	ldr	r3, [r3, #0]
 80011da:	f5b3 3f00 	cmp.w	r3, #131072	@ 0x20000
 80011de:	d903      	bls.n	80011e8 <USART1_IRQHandler+0x68>
        flag_too_big_update = true;
 80011e0:	4b15      	ldr	r3, [pc, #84]	@ (8001238 <USART1_IRQHandler+0xb8>)
 80011e2:	2201      	movs	r2, #1
 80011e4:	701a      	strb	r2, [r3, #0]
        return;
 80011e6:	e018      	b.n	800121a <USART1_IRQHandler+0x9a>
      }
      update_size = update_size * 10 + (digit-'0');
 80011e8:	4b12      	ldr	r3, [pc, #72]	@ (8001234 <USART1_IRQHandler+0xb4>)
 80011ea:	681a      	ldr	r2, [r3, #0]
 80011ec:	4613      	mov	r3, r2
 80011ee:	009b      	lsls	r3, r3, #2
 80011f0:	4413      	add	r3, r2
 80011f2:	005b      	lsls	r3, r3, #1
 80011f4:	461a      	mov	r2, r3
 80011f6:	79fb      	ldrb	r3, [r7, #7]
 80011f8:	4413      	add	r3, r2
 80011fa:	3b30      	subs	r3, #48	@ 0x30
 80011fc:	4a0d      	ldr	r2, [pc, #52]	@ (8001234 <USART1_IRQHandler+0xb4>)
 80011fe:	6013      	str	r3, [r2, #0]
 8001200:	e00b      	b.n	800121a <USART1_IRQHandler+0x9a>
    }
    else {
      // if (fw_ar_ind >= update_size)
      //   return;
      // fw_update [fw_ar_ind++] = USART1 -> DR;
      uint8_t data = USART1 -> DR;
 8001202:	4b08      	ldr	r3, [pc, #32]	@ (8001224 <USART1_IRQHandler+0xa4>)
 8001204:	685b      	ldr	r3, [r3, #4]
 8001206:	b2db      	uxtb	r3, r3
 8001208:	71bb      	strb	r3, [r7, #6]
      Ring_buff_write(&ringbuffer, &data, 1);
 800120a:	1dbb      	adds	r3, r7, #6
 800120c:	2201      	movs	r2, #1
 800120e:	4619      	mov	r1, r3
 8001210:	480a      	ldr	r0, [pc, #40]	@ (800123c <USART1_IRQHandler+0xbc>)
 8001212:	f7ff fcb5 	bl	8000b80 <Ring_buff_write>
 8001216:	e000      	b.n	800121a <USART1_IRQHandler+0x9a>
  if (!firmware_update_mode) return;
 8001218:	bf00      	nop
    }
  }
}
 800121a:	3708      	adds	r7, #8
 800121c:	46bd      	mov	sp, r7
 800121e:	bd80      	pop	{r7, pc}
 8001220:	20005086 	.word	0x20005086
 8001224:	40011000 	.word	0x40011000
 8001228:	20000008 	.word	0x20000008
 800122c:	20000009 	.word	0x20000009
 8001230:	2000000a 	.word	0x2000000a
 8001234:	2000007c 	.word	0x2000007c
 8001238:	2000000b 	.word	0x2000000b
 800123c:	20000080 	.word	0x20000080

08001240 <validate_vtable>:
#include "core.h"
#include <stdint.h>

bool validate_vtable(firmware_t *f) {
 8001240:	b580      	push	{r7, lr}
 8001242:	b08a      	sub	sp, #40	@ 0x28
 8001244:	af00      	add	r7, sp, #0
 8001246:	6078      	str	r0, [r7, #4]

  // vtable end is the next free address
  // check from address ------->    [vtable_start, vtable_end)
  
  // vtable must be 128byte aligned => last 7 bits must be 0 (for stm32f401re)
  if (f->__vtable_address & ((1 << 7) - 1)) {
 8001248:	687b      	ldr	r3, [r7, #4]
 800124a:	695b      	ldr	r3, [r3, #20]
 800124c:	f003 037f 	and.w	r3, r3, #127	@ 0x7f
 8001250:	2b00      	cmp	r3, #0
 8001252:	d005      	beq.n	8001260 <validate_vtable+0x20>
    printf("the vector table is not 128byte aligned !!!\n\r", 0x0);
 8001254:	2100      	movs	r1, #0
 8001256:	4839      	ldr	r0, [pc, #228]	@ (800133c <validate_vtable+0xfc>)
 8001258:	f7ff fac8 	bl	80007ec <printf>
    return false;
 800125c:	2300      	movs	r3, #0
 800125e:	e068      	b.n	8001332 <validate_vtable+0xf2>

  // all the "end" addresses are next free address => there should not be any
  // data in the "end" address !! all the addresses must lie in the range
  // [start, end)

  uint32_t RAM_start = 0x20000000;
 8001260:	f04f 5300 	mov.w	r3, #536870912	@ 0x20000000
 8001264:	623b      	str	r3, [r7, #32]
  uint32_t RAM_size = 96 * 1024; // 96kB
 8001266:	f44f 33c0 	mov.w	r3, #98304	@ 0x18000
 800126a:	61fb      	str	r3, [r7, #28]
  uint32_t RAM_end = RAM_start + RAM_size;
 800126c:	6a3a      	ldr	r2, [r7, #32]
 800126e:	69fb      	ldr	r3, [r7, #28]
 8001270:	4413      	add	r3, r2
 8001272:	61bb      	str	r3, [r7, #24]
  uint32_t FLASH_start = f->__vtable_address;
 8001274:	687b      	ldr	r3, [r7, #4]
 8001276:	695b      	ldr	r3, [r3, #20]
 8001278:	617b      	str	r3, [r7, #20]
  uint32_t FLASH_size;
  if (f->__base_address == FIRMWARE_1_ADDRESS)
 800127a:	687b      	ldr	r3, [r7, #4]
 800127c:	681b      	ldr	r3, [r3, #0]
 800127e:	4a30      	ldr	r2, [pc, #192]	@ (8001340 <validate_vtable+0x100>)
 8001280:	4293      	cmp	r3, r2
 8001282:	d103      	bne.n	800128c <validate_vtable+0x4c>
    FLASH_size = f->__firmware_size;
 8001284:	687b      	ldr	r3, [r7, #4]
 8001286:	69db      	ldr	r3, [r3, #28]
 8001288:	613b      	str	r3, [r7, #16]
 800128a:	e00e      	b.n	80012aa <validate_vtable+0x6a>
  else if (f->__base_address == FIRMWARE_2_ADDRESS)
 800128c:	687b      	ldr	r3, [r7, #4]
 800128e:	681b      	ldr	r3, [r3, #0]
 8001290:	4a2c      	ldr	r2, [pc, #176]	@ (8001344 <validate_vtable+0x104>)
 8001292:	4293      	cmp	r3, r2
 8001294:	d103      	bne.n	800129e <validate_vtable+0x5e>
    FLASH_size = f->__firmware_size;
 8001296:	687b      	ldr	r3, [r7, #4]
 8001298:	69db      	ldr	r3, [r3, #28]
 800129a:	613b      	str	r3, [r7, #16]
 800129c:	e005      	b.n	80012aa <validate_vtable+0x6a>
  else {
    printf("update _base address is not valid\n\r", 0x0);
 800129e:	2100      	movs	r1, #0
 80012a0:	4829      	ldr	r0, [pc, #164]	@ (8001348 <validate_vtable+0x108>)
 80012a2:	f7ff faa3 	bl	80007ec <printf>
    return false;
 80012a6:	2300      	movs	r3, #0
 80012a8:	e043      	b.n	8001332 <validate_vtable+0xf2>
  }
  uint32_t FLASH_end = f->__firmware_end;
 80012aa:	687b      	ldr	r3, [r7, #4]
 80012ac:	699b      	ldr	r3, [r3, #24]
 80012ae:	60fb      	str	r3, [r7, #12]

  /*************************msp check*********************/
  
  // MSP value can be RAM end as MSP grows downword;
  if (f->__msp_value > RAM_end || f->__msp_value < RAM_start) {
 80012b0:	687b      	ldr	r3, [r7, #4]
 80012b2:	6a1b      	ldr	r3, [r3, #32]
 80012b4:	69ba      	ldr	r2, [r7, #24]
 80012b6:	429a      	cmp	r2, r3
 80012b8:	d304      	bcc.n	80012c4 <validate_vtable+0x84>
 80012ba:	687b      	ldr	r3, [r7, #4]
 80012bc:	6a1b      	ldr	r3, [r3, #32]
 80012be:	6a3a      	ldr	r2, [r7, #32]
 80012c0:	429a      	cmp	r2, r3
 80012c2:	d90b      	bls.n	80012dc <validate_vtable+0x9c>

      printf ("MSP value is -> %\n\r", (uint32_t)(&(f->__msp_value)));
 80012c4:	687b      	ldr	r3, [r7, #4]
 80012c6:	3320      	adds	r3, #32
 80012c8:	4619      	mov	r1, r3
 80012ca:	4820      	ldr	r0, [pc, #128]	@ (800134c <validate_vtable+0x10c>)
 80012cc:	f7ff fa8e 	bl	80007ec <printf>
    printf("MSP value is invalid\n\r", 0x0);
 80012d0:	2100      	movs	r1, #0
 80012d2:	481f      	ldr	r0, [pc, #124]	@ (8001350 <validate_vtable+0x110>)
 80012d4:	f7ff fa8a 	bl	80007ec <printf>
    return false;
 80012d8:	2300      	movs	r3, #0
 80012da:	e02a      	b.n	8001332 <validate_vtable+0xf2>
  }
  // msp value must be word aligned !!!
  if (f->__msp_value & 3) {
 80012dc:	687b      	ldr	r3, [r7, #4]
 80012de:	6a1b      	ldr	r3, [r3, #32]
 80012e0:	f003 0303 	and.w	r3, r3, #3
 80012e4:	2b00      	cmp	r3, #0
 80012e6:	d005      	beq.n	80012f4 <validate_vtable+0xb4>
    printf("MSP value is not word aligned\n\r", 0x0);
 80012e8:	2100      	movs	r1, #0
 80012ea:	481a      	ldr	r0, [pc, #104]	@ (8001354 <validate_vtable+0x114>)
 80012ec:	f7ff fa7e 	bl	80007ec <printf>
    return false;
 80012f0:	2300      	movs	r3, #0
 80012f2:	e01e      	b.n	8001332 <validate_vtable+0xf2>
  }

  /************************ vtable check************************/

  for (uint32_t vtable_entry = f->__vtable_address + 0x4;
 80012f4:	687b      	ldr	r3, [r7, #4]
 80012f6:	695b      	ldr	r3, [r3, #20]
 80012f8:	3304      	adds	r3, #4
 80012fa:	627b      	str	r3, [r7, #36]	@ 0x24
 80012fc:	e013      	b.n	8001326 <validate_vtable+0xe6>
       vtable_entry < f->__vtable_end; vtable_entry += 4) {

    uint32_t FLASH_address =
        *((uint32_t *)vtable_entry); // peek inside vtable_entry
 80012fe:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
    uint32_t FLASH_address =
 8001300:	681b      	ldr	r3, [r3, #0]
 8001302:	60bb      	str	r3, [r7, #8]
    if (FLASH_address >= FLASH_end || FLASH_address < FLASH_start) {
 8001304:	68ba      	ldr	r2, [r7, #8]
 8001306:	68fb      	ldr	r3, [r7, #12]
 8001308:	429a      	cmp	r2, r3
 800130a:	d203      	bcs.n	8001314 <validate_vtable+0xd4>
 800130c:	68ba      	ldr	r2, [r7, #8]
 800130e:	697b      	ldr	r3, [r7, #20]
 8001310:	429a      	cmp	r2, r3
 8001312:	d205      	bcs.n	8001320 <validate_vtable+0xe0>

      printf("% ---- in vtable entry does not exist in the allowed flash "
 8001314:	6a79      	ldr	r1, [r7, #36]	@ 0x24
 8001316:	4810      	ldr	r0, [pc, #64]	@ (8001358 <validate_vtable+0x118>)
 8001318:	f7ff fa68 	bl	80007ec <printf>
             "range\n\r", vtable_entry);
      return false;
 800131c:	2300      	movs	r3, #0
 800131e:	e008      	b.n	8001332 <validate_vtable+0xf2>
       vtable_entry < f->__vtable_end; vtable_entry += 4) {
 8001320:	6a7b      	ldr	r3, [r7, #36]	@ 0x24
 8001322:	3304      	adds	r3, #4
 8001324:	627b      	str	r3, [r7, #36]	@ 0x24
 8001326:	687b      	ldr	r3, [r7, #4]
 8001328:	68db      	ldr	r3, [r3, #12]
 800132a:	6a7a      	ldr	r2, [r7, #36]	@ 0x24
 800132c:	429a      	cmp	r2, r3
 800132e:	d3e6      	bcc.n	80012fe <validate_vtable+0xbe>
    }
  }

  return true;
 8001330:	2301      	movs	r3, #1
}
 8001332:	4618      	mov	r0, r3
 8001334:	3728      	adds	r7, #40	@ 0x28
 8001336:	46bd      	mov	sp, r7
 8001338:	bd80      	pop	{r7, pc}
 800133a:	bf00      	nop
 800133c:	08001a1c 	.word	0x08001a1c
 8001340:	08010000 	.word	0x08010000
 8001344:	08020000 	.word	0x08020000
 8001348:	08001a4c 	.word	0x08001a4c
 800134c:	08001a70 	.word	0x08001a70
 8001350:	08001a84 	.word	0x08001a84
 8001354:	08001a9c 	.word	0x08001a9c
 8001358:	08001abc 	.word	0x08001abc

0800135c <validate_firmware>:

bool validate_firmware(firmware_t *f) {
 800135c:	b580      	push	{r7, lr}
 800135e:	b084      	sub	sp, #16
 8001360:	af00      	add	r7, sp, #0
 8001362:	6078      	str	r0, [r7, #4]

  if (!validate_vtable(f)) {
 8001364:	6878      	ldr	r0, [r7, #4]
 8001366:	f7ff ff6b 	bl	8001240 <validate_vtable>
 800136a:	4603      	mov	r3, r0
 800136c:	f083 0301 	eor.w	r3, r3, #1
 8001370:	b2db      	uxtb	r3, r3
 8001372:	2b00      	cmp	r3, #0
 8001374:	d005      	beq.n	8001382 <validate_firmware+0x26>
    printf("vector table of the update is not valid\n\r", 0x0);
 8001376:	2100      	movs	r1, #0
 8001378:	480f      	ldr	r0, [pc, #60]	@ (80013b8 <validate_firmware+0x5c>)
 800137a:	f7ff fa37 	bl	80007ec <printf>
    return false;
 800137e:	2300      	movs	r3, #0
 8001380:	e016      	b.n	80013b0 <validate_firmware+0x54>
  }

  uint32_t crc_result = crc_calc(f);
 8001382:	6878      	ldr	r0, [r7, #4]
 8001384:	f7ff f880 	bl	8000488 <crc_calc>
 8001388:	4603      	mov	r3, r0
 800138a:	60fb      	str	r3, [r7, #12]
  printf("crc value is -> %\n\r", (uint32_t)(&crc_result));
 800138c:	f107 030c 	add.w	r3, r7, #12
 8001390:	4619      	mov	r1, r3
 8001392:	480a      	ldr	r0, [pc, #40]	@ (80013bc <validate_firmware+0x60>)
 8001394:	f7ff fa2a 	bl	80007ec <printf>
  if (crc_result != f->__crc) {
 8001398:	687b      	ldr	r3, [r7, #4]
 800139a:	689a      	ldr	r2, [r3, #8]
 800139c:	68fb      	ldr	r3, [r7, #12]
 800139e:	429a      	cmp	r2, r3
 80013a0:	d005      	beq.n	80013ae <validate_firmware+0x52>
    printf("CRC failed\n\r", 0x0);
 80013a2:	2100      	movs	r1, #0
 80013a4:	4806      	ldr	r0, [pc, #24]	@ (80013c0 <validate_firmware+0x64>)
 80013a6:	f7ff fa21 	bl	80007ec <printf>
    return false;
 80013aa:	2300      	movs	r3, #0
 80013ac:	e000      	b.n	80013b0 <validate_firmware+0x54>
  }
  return true;
 80013ae:	2301      	movs	r3, #1
}
 80013b0:	4618      	mov	r0, r3
 80013b2:	3710      	adds	r7, #16
 80013b4:	46bd      	mov	sp, r7
 80013b6:	bd80      	pop	{r7, pc}
 80013b8:	08001b00 	.word	0x08001b00
 80013bc:	08001b2c 	.word	0x08001b2c
 80013c0:	08001b40 	.word	0x08001b40

080013c4 <Reset_Handler>:
 80013c4:	480c      	ldr	r0, [pc, #48]	@ (80013f8 <hang+0x4>)
 80013c6:	490d      	ldr	r1, [pc, #52]	@ (80013fc <hang+0x8>)
 80013c8:	4a0d      	ldr	r2, [pc, #52]	@ (8001400 <hang+0xc>)
 80013ca:	e7ff      	b.n	80013cc <copy>

080013cc <copy>:
 80013cc:	4288      	cmp	r0, r1
 80013ce:	db04      	blt.n	80013da <copy_helper>
 80013d0:	480c      	ldr	r0, [pc, #48]	@ (8001404 <hang+0x10>)
 80013d2:	490d      	ldr	r1, [pc, #52]	@ (8001408 <hang+0x14>)
 80013d4:	f04f 0200 	mov.w	r2, #0
 80013d8:	e004      	b.n	80013e4 <init_zero>

080013da <copy_helper>:
 80013da:	f852 3b04 	ldr.w	r3, [r2], #4
 80013de:	f840 3b04 	str.w	r3, [r0], #4
 80013e2:	e7f3      	b.n	80013cc <copy>

080013e4 <init_zero>:
 80013e4:	4288      	cmp	r0, r1
 80013e6:	db00      	blt.n	80013ea <init_zero_helper>
 80013e8:	e002      	b.n	80013f0 <call_entry>

080013ea <init_zero_helper>:
 80013ea:	f840 2b04 	str.w	r2, [r0], #4
 80013ee:	e7f9      	b.n	80013e4 <init_zero>

080013f0 <call_entry>:
 80013f0:	f7ff bda0 	b.w	8000f34 <main>

080013f4 <hang>:
 80013f4:	e7fe      	b.n	80013f4 <hang>
 80013f6:	0000      	.short	0x0000
 80013f8:	20000000 	.word	0x20000000
 80013fc:	20000005 	.word	0x20000005
 8001400:	08001b4d 	.word	0x08001b4d
 8001404:	20000008 	.word	0x20000008
 8001408:	20005087 	.word	0x20005087

0800140c <EXTI15_10_IRQ_handler>:
 800140c:	f7ff be90 	b.w	8001130 <switch_pressed>

08001410 <Default_Handler>:
 8001410:	e7fe      	b.n	8001410 <Default_Handler>

08001412 <BusFault_Handler>:
 8001412:	f3ef 8008 	mrs	r0, MSP
 8001416:	6980      	ldr	r0, [r0, #24]
 8001418:	f04f 0100 	mov.w	r1, #0
 800141c:	b500      	push	{lr}
 800141e:	f7ff f85f 	bl	80004e0 <fault_handler_helper>
 8001422:	f85d eb04 	ldr.w	lr, [sp], #4
 8001426:	4770      	bx	lr

08001428 <MemManage_Handler>:
 8001428:	f3ef 8008 	mrs	r0, MSP
 800142c:	6980      	ldr	r0, [r0, #24]
 800142e:	f04f 0101 	mov.w	r1, #1
 8001432:	b500      	push	{lr}
 8001434:	f7ff f854 	bl	80004e0 <fault_handler_helper>
 8001438:	f85d eb04 	ldr.w	lr, [sp], #4
 800143c:	4770      	bx	lr

0800143e <UsageFault_Handler>:
 800143e:	f3ef 8008 	mrs	r0, MSP
 8001442:	6980      	ldr	r0, [r0, #24]
 8001444:	f04f 0102 	mov.w	r1, #2
 8001448:	b500      	push	{lr}
 800144a:	f7ff f849 	bl	80004e0 <fault_handler_helper>
 800144e:	f85d eb04 	ldr.w	lr, [sp], #4
 8001452:	4770      	bx	lr

08001454 <HardFault_Handler>:
 8001454:	f3ef 8008 	mrs	r0, MSP
 8001458:	6980      	ldr	r0, [r0, #24]
 800145a:	4904      	ldr	r1, [pc, #16]	@ (800146c <HardFault_Handler+0x18>)
 800145c:	f381 8808 	msr	MSP, r1
 8001460:	b500      	push	{lr}
 8001462:	f7ff f89f 	bl	80005a4 <HardFault_Handler_helper>
 8001466:	f85d eb04 	ldr.w	lr, [sp], #4
 800146a:	e7fe      	b.n	800146a <HardFault_Handler+0x16>
 800146c:	20017000 	.word	0x20017000

08001470 <SVC_Handler>:
 8001470:	e7fe      	b.n	8001470 <SVC_Handler>

08001472 <SysTick_Handler>:
 8001472:	e7fe      	b.n	8001472 <SysTick_Handler>

08001474 <PendSV_Handler>:
 8001474:	e7fe      	b.n	8001474 <PendSV_Handler>

08001476 <NMI_Handler>:
 8001476:	e7fe      	b.n	8001476 <NMI_Handler>

08001478 <DebugMon_Handler>:
 8001478:	e7fe      	b.n	8001478 <DebugMon_Handler>
