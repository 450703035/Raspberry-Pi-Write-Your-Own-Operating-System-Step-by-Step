ARMGNU ?= aarch64-unknown-linux-gnu

board ?= rpi3

ifeq ($(board), rpi3)
COPS += -DCONFIG_BOARD_PI3B
QEMU_FLAGS  += -machine raspi3b
else ifeq ($(board), rpi4)
COPS += -DCONFIG_BOARD_PI4B
QEMU_FLAGS  += -machine raspi4
endif

CPU = Cortex-A72
ARCH = armv8-a
TARGET_CPU = -mcpu=$(CPU)
TARGET_ARCH = -march=$(ARCH) $(TARGET_CPU) 

COPS += -g -mcmodel=large -Wall -nostdlib -Iinclude -mgeneral-regs-only -ffreestanding -nostartfiles
ASMOPS = -g -mcmodel=large -Iinclude 

LDFLAGS = -Map my-os.map -T link.lds

BUILD_DIR = build
SRC_DIR = src

$(BUILD_DIR):
	mkdir $@


all : my-os.img

clean :
	rm -rf $(BUILD_DIR) *.bin *.elf *.map *.img

$(BUILD_DIR)/%_c.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(ARMGNU)-gcc $(TARGET_ARCH) $(COPS) -MMD -c $< -o $@

$(BUILD_DIR)/%_s.o: $(SRC_DIR)/%.s | $(BUILD_DIR)
	$(ARMGNU)-gcc $(TARGET_ARCH) $(ASMOPS) -MMD -c $< -o $@

C_FILES = $(wildcard $(SRC_DIR)/*.c)
ASM_FILES = $(wildcard $(SRC_DIR)/*.s)
OBJ_FILES = $(C_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%_c.o)
OBJ_FILES += $(ASM_FILES:$(SRC_DIR)/%.s=$(BUILD_DIR)/%_s.o)

DEP_FILES = $(OBJ_FILES:%.o=%.d)
-include $(DEP_FILES)

my-os.img: link.lds $(OBJ_FILES)
	$(ARMGNU)-ld $(LDFLAGS) -o my-os.elf  $(OBJ_FILES)
	$(ARMGNU)-objcopy my-os.elf -O binary my-os.img

QEMU_FLAGS  += -nographic

run:
	qemu-system-aarch64 $(QEMU_FLAGS) -kernel my-os.img
debug:
	qemu-system-aarch64 $(QEMU_FLAGS) -kernel my-os.img -S -s
