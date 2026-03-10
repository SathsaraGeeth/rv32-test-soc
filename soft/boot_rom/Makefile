# ------------------------------
# Toolchain
# ------------------------------
CC      := riscv64-unknown-elf-gcc
OBJDUMP := riscv64-unknown-elf-objdump
OBJCOPY := riscv64-unknown-elf-objcopy

# ------------------------------
# Target
# ------------------------------
TARGET  := boot_rom
CPU     := rv32im
ABI     := ilp32

# ------------------------------
# Directories
# ------------------------------
SRC_DIR   := src
BUILD_DIR := build
INCLUDE   := include

# ------------------------------
# Sources
# ------------------------------
C_SRCS := $(shell find $(SRC_DIR) -name '*.c')
S_SRCS := $(shell find $(SRC_DIR) -name '*.s' -o -name '*.S')

OBJS := $(C_SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
# OBJS += $(S_SRCS:$(SRC_DIR)/%.s=$(BUILD_DIR)/%.o)
OBJS += $(S_SRCS:$(SRC_DIR)/%.S=$(BUILD_DIR)/%.o)

# ------------------------------
# Flags
# ------------------------------
# CFLAGS  := -march=$(CPU) -mabi=$(ABI) -O2 -Wall -ffreestanding -nostdlib -I$(INCLUDE)
CFLAGS  := -march=$(CPU) -mabi=$(ABI) -O2 -Wall -ffreestanding -nostdlib -I$(INCLUDE) -ffunction-sections -fdata-sections
ASFLAGS := -march=$(CPU) -mabi=$(ABI) -ffreestanding
# LDFLAGS := -T linker.ld
LDFLAGS := -T linker.ld -Wl,--gc-sections

# ------------------------------
# Targets
# ------------------------------
all: $(TARGET).elf $(TARGET).hex $(TARGET).bin

# Build ELF
$(TARGET).elf: $(OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $@ -lgcc
	$(OBJDUMP) -d $@ > $(TARGET).asm

# Build HEX file for Verilog simulation
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O verilog -j .text $< $@

# Build binary for RAM loading
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary -j .text $< $@
	xxd -p -c 4 $@ | sed 's/\(..\)\(..\)\(..\)\(..\)/\4\3\2\1/' > $(TARGET).hex

# ------------------------------
# Build object files
# ------------------------------
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) $(ASFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) $(ASFLAGS) -c $< -o $@

# ------------------------------
# Create build directory
# ------------------------------
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# ------------------------------
# Clean
# ------------------------------
clean:
	rm -rf $(BUILD_DIR) $(TARGET).elf $(TARGET).hex $(TARGET).bin $(TARGET)_be.hex $(TARGET).asm

.PHONY: all clean