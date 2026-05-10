# STM32F401RE Bare-Metal Bootloader

A custom bare-metal bootloader for the STM32F401RE microcontroller designed for reliable and power-loss-safe firmware updates.

The bootloader directly manages internal Flash memory and prevents execution of incomplete or corrupted firmware images. On reset, it validates firmware images using the STM32 onboard CRC peripheral, performs vector table sanity checks, safely reinitializes the stack pointer and vector table, and transfers control to a valid application.

The entire system is implemented using CMSIS and the STM32 reference manual without relying on vendor bootloader frameworks or HAL-based bootloader solutions.

---

# Features

- Dual firmware support
- Safe application jump mechanism
- Firmware integrity validation
- USART-based firmware update system
- Ring buffer and write buffer based data handling
- USART logging support
- Power-loss-resilient rollback system
- Vector table sanity validation
- Flash memory management without external frameworks

---

# Flash Layout

| Section | Address Range | Size | Flash Sector |
|---|---|---|---|
| Bootloader | `0x08000000 - 0x0800FFFF` | 64 KB | Sector 1-4 |
| Firmware 1 | `0x08010000 - 0x0801FFFF` | 64 KB | Sector 5 |
| Firmware 2 | `0x08020000 - 0x0803FFFF` | 128 KB | Sector 6 |
| Update Section | `0x08040000 - 0x0805FFFF` | 128 KB | Sector 7 |
| Copy Section | `0x08060000 - 0x0807FFFF` | 128 KB | Sector 8 |

---

# Boot Flow

1. Initialize `USART1`
2. Create:
   - Ring buffer (`ringbuffer`)
   - Write buffer (`write_buffer`)
3. Check whether a firmware update was interrupted by power loss
4. Restore firmware if rollback is required
5. Validate available firmware images
6. Enable `EXTI15_10` interrupt
7. Wait for user input

## User Input Actions

| Button Press | Action |
|---|---|
| Press once | Jump to Firmware 1 |
| Press twice | Jump to Firmware 2 |
| Press three times | Enter firmware update mode |

---

# Firmware Update Process

1. Receive firmware size through `USART1`
2. Receive firmware image from host
3. Store update temporarily in RAM
4. Verify the received update
5. Write update to the `UPDATE` Flash section
6. Copy current firmware to the `COPY` section
7. Begin firmware replacement process

## Critical Update Stage

The following stage is considered risky because power loss during this process can corrupt the active firmware:

- Copy update from `UPDATE` section to firmware section
- Clear update-complete flag after successful copy

```c
printf("update successful !!!\\n\\r");
```

If this message is not printed, the firmware update must be uploaded again.

---

# Rollback Strategy

To ensure reliability during unexpected power loss:

- The bootloader checks whether the update-complete flag was cleared
- If the flag remains uncleared, the previous firmware image is restored from the `COPY` section
- After recovery, the flag is cleared

This mechanism prevents execution of partially updated firmware.

---

# Vector Table Sanity Checks

Before jumping to an application, the bootloader validates the vector table using the following checks:

1. Update flag must contain `0xFFFFFFFF`
2. MSP (first vector table entry) must lie within valid RAM range
3. MSP must be word aligned
4. Vector table must be 128-byte aligned
5. All vector table entries must point to valid Flash addresses

These checks help prevent jumps to corrupted or invalid firmware images.

---

# Firmware Validation Mechanism

Firmware validation is performed using:

## CRC Validation

- STM32 onboard CRC peripheral computes CRC over firmware image
- Computed CRC is compared against the CRC stored in the firmware header

## Vector Table Validation

- Bootloader scans vector table entries
- Each entry is validated against allowed Flash memory ranges

---

# Application Jump Mechanism

Before transferring control to the application:

1. Mask all maskable interrupts
2. Disable all interrupt sources
3. Clear all pending interrupts

Then perform the application jump sequence:

## Step 1
Load MSP using the first entry of the vector table

## Step 2
Update `VTOR` register with application vector table address

## Step 3
Unmask interrupts

## Step 4
Branch to the application's `Reset_Handler`

This sequence ensures a clean and reliable context switch from bootloader to application.

---

# Logging System

The bootloader provides runtime logging through `USART1` for:

- Update progress
- Firmware validation
- Recovery operations
- Error reporting
- Debugging support

---

# Possible Improvements

- Secure boot using digital signatures
- Encrypted firmware updates
- Authentication for firmware uploads
- External storage support
- OTA update support
- Version management system

---

# Technologies Used

- STM32F401RE
- ARM Cortex-M4
- CMSIS
- Bare-metal embedded programming
- USART communication
- Flash memory programming
- Interrupt handling
- CRC peripheral

---

# Demonstration

https://www.youtube.com/watch?v=BqOucunvT6A

---

# Project Goals

This project was built to explore:

- Bare-metal firmware development
- Bootloader architecture
- Flash memory management
- Safe firmware update mechanisms
- Fault recovery systems
- Cortex-M startup and application handoff
- Low-level STM32 programming using the reference manual
