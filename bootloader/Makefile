RESET = \033[0m
GREEN = \033[0;32m

BUILD = build
SRC = src
CORE = core
DRIVERS = drivers

ARM = arm-none-eabi-
CC = $(ARM)gcc
AS = $(ARM)as
LD = $(ARM)ld
GDB = $(ARM)gdb
OBJCPY = $(ARM)objcopy

#flags
INCLUDES = -Iinclude/cmsis -Iinclude/device -Iinclude/drivers -Iinclude
MPU = -mcpu=cortex-m4 -mthumb
OPTIMISATION = -O0
# frestandin is important as we need to tell the compiler that there is 
# no os or libs gurentee startup provided by system or syscalls
# it remove some assumption that compiler makes
FREESTANDING = -ffreestanding 

FLASH_BASE = 0x08000000

C_SRC_FILES = $(shell find $(SRC) -name "*.c")
AS_SRC_FILES = $(shell find $(SRC) -name "*.s")

C_OBJ_FILES =		$(patsubst $(SRC)/%.c, $(BUILD)/%_c_.o, $(C_SRC_FILES))
AS_OBJ_FILES =		$(patsubst $(SRC)/%.s, $(BUILD)/%_as_.o, $(AS_SRC_FILES))

LINKER_SCRIPT =  linker.ld 


ELF = $(BUILD)/firmware.elf 
BIN = $(BUILD)/firmware.bin


OPENOCD = openocd -f interface/stlink.cfg -f target/stm32f4x.cfg


default : all

all : build $(ELF) $(BIN)

build :
	mkdir -p $(BUILD)/$(CORE) $(BUILD)/$(DRIVERS)

flash : $(BIN)
	$(OPENOCD) -c "program $(BIN) $(FLASH_BASE) verify reset exit"

start_debug_server : $(ELF)
	$(OPENOCD)
start_debug_client : $(ELF)
	$(GDB) $(ELF)

$(BIN) : $(ELF)
	$(OBJCPY) -O binary $(ELF) $(BIN)
	hexdump -C $(BIN) > $(BUILD)/firmware.hex
	arm-none-eabi-objdump -h $(ELF) > $(BUILD)/sections.txt

$(ELF) : $(LINKER_SCRIPT) $(C_OBJ_FILES) $(AS_OBJ_FILES)
	$(CC) -nostartfiles -Wl,--gc-sections  -T $(LINKER_SCRIPT) $(C_OBJ_FILES) $(AS_OBJ_FILES) -o $(ELF)

$(BUILD)/%_c_.o : $(SRC)/%.c 
		
	$(CC) -c -g $(INCLUDES) $(MPU) $(FREESTANDING) -O0 -g3 -fno-inline $< -o $@

$(BUILD)/%_as_.o : $(SRC)/%.s
	
	$(AS) $< -o $@

clean : 
	@rm -rf $(BUILD)


