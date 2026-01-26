RESET = \033[0m
GREEN = \033[0;32m

BUILD = build
SRC = src

ARM = arm-none-eabi-
CC = $(ARM)gcc
AS = $(ARM)as
LD = $(ARM)ld
GDB = $(ARM)gdb
OBJCPY = $(ARM)objcopy 

#flags
INCLUDE_CMSIS_HEADERS = -Iinclude/cmsis -Iinclude/device
MPU = -mcpu=cortex-m4 -mthumb
OPTIMISATION = -O0
# frestandin is important as we need to tell the compiler that there is 
# no os or libs gurentee startup provided by system or syscalls
# it remove some assumption that compiler makes
FREESTANDING = -ffreestanding 

FLASH_BASE = 0x08000000
SECTOR_SIZE = 0X4000
SECTOR_NUMBER = 1

FLASH_ADDRESS = $(shell printf "0x%X\n" $$(( $(FLASH_BASE) + $(SECTOR_SIZE) * $(SECTOR_NUMBER) )))


C_SRC_FILES = $(wildcard $(SRC)/*.c)
AS_SRC_FILES = $(wildcard $(SRC)/*.s)

C_OBJ_FILES =		$(patsubst $(SRC)/%.c, $(BUILD)/%_c_.o, $(C_SRC_FILES))
AS_OBJ_FILES =		$(patsubst $(SRC)/%.s, $(BUILD)/%_as_.o, $(AS_SRC_FILES))

LINKER_SCRIPT =  linker.ld 


ELF = $(BUILD)/firmware.elf 
BIN = $(BUILD)/firmware.bin


OPENOCD = openocd -f interface/stlink.cfg -f target/stm32f4x.cfg


default : all

all : $(ELF) $(BIN)

flash : $(BIN)
	# $(OPENOCD) -c "program $(BIN) $(FLASH_BASE) verify reset exit"
	st-flash write $(BIN) $(FLASH_ADDRESS)

start_debug_server : $(ELF)
	$(OPENOCD)
start_debug_client : $(ELF)
	$(GDB) $(ELF)

$(BIN) : $(ELF)
	# without --gap-fill=0xff -> no bytes will be emitted for padding (bad for crc)
	$(OBJCPY) -O binary --gap-fill=0xff $(ELF) $(BIN)

$(ELF) : $(LINKER_SCRIPT) $(C_OBJ_FILES) $(AS_OBJ_FILES)
	$(LD) -T $(LINKER_SCRIPT) $(C_OBJ_FILES) $(AS_OBJ_FILES) -o $(ELF)

$(BUILD)/%_c_.o : $(SRC)/%.c 
		
	$(CC) -c -g $(INCLUDE_CMSIS_HEADERS) $(MPU) $(OPTIMISATION) $(FREESTANDING) $< -o $@

$(BUILD)/%_as_.o : $(SRC)/%.s
	
	$(AS) $< -o $@

clean : 
	@rm $(BUILD)/*.o $(BUILD)/*.bin $(BUILD)/*.elf
	


