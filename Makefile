# project name
PROJECT = cm0-bare-prj

# source files
SOURCES = src/startup.c src/main.c
# object files
OBJECTS = $(SOURCES:.c=.o)
# dependencies files (-MMD flag of gcc)
DEPS = $(OBJECTS:.o=.d)

INCLUDE_PATHS = -I.
LIBRARY_PATHS = 
LIBRARIES = -lgcc
LINKER_SCRIPT = ./script.ld

# toolchain paths
GCC_BIN = ~/arm-toolchain/gcc-arm-none-eabi-4_9-2015q2/bin
CC      = $(GCC_BIN)/arm-none-eabi-gcc
LD      = $(GCC_BIN)/arm-none-eabi-gcc
OBJCOPY = $(GCC_BIN)/arm-none-eabi-objcopy
SIZE		= $(GCC_BIN)/arm-none-eabi-size

# flashing utility
LPC21ISP = lpc21isp
SERIAL_PORT = /dev/ttyUSB1
BAUDRATE = 115200
OSC_CLK_KHZ	= 12000

# compiler options
CPU = -mcpu=cortex-m0 -mthumb
CC_OPTIMIZE = -O2
CC_COMMON = -nostartfiles -ffreestanding
CC_FLAGS = $(CPU) -c -MMD $(CC_OPTIMIZE) $(CC_COMMON) -fno-common -fmessage-length=0 -Wall -fno-exceptions -ffunction-sections -fdata-sections -g
CC_SYMBOLS = 

# linker options
# link only used sections
LD_GC = -Wl,--gc-sections
# generate map file with cross-reference table
LD_MAP = -Wl,-Map=$(PROJECT).map,--cref
# linker flags
LD_FLAGS = $(CPU) $(CC_COMMON) $(LD_GC) $(LD_MAP)

# main target
all: $(PROJECT).hex size

# rule for compiling sources
.c.o:
	$(CC)  $(CC_FLAGS) $(CC_SYMBOLS) -std=gnu99   $(INCLUDE_PATHS) -o $@ $<

# rule for linking ELF file
$(PROJECT).elf: $(OBJECTS)
	$(LD) $(LD_FLAGS) -T$(LINKER_SCRIPT) $(LIBRARY_PATHS) -o $@ $^ $(LIBRARIES)

# rule for converting ELF to HEX format
$(PROJECT).hex: $(PROJECT).elf 
	$(OBJCOPY) -O ihex $< $@

# rule for priting section size information
size: $(PROJECT).elf
	@$(SIZE) $<	

# rule for cleaning source tree
clean:
	rm -f $(PROJECT).bin $(PROJECT).elf $(OBJECTS) $(DEPS) $(PROJECT).map $(PROJECT).hex

# rule for flashing firmware using lpc21isp tool
run: $(PROJECT).hex
	$(LPC21ISP) -hex -wipe -verify $(PROJECT).hex $(SERIAL_PORT) $(BAUDRATE) $(OSC_CLK_KHZ)

# include generated dependencies
-include $(DEPS)
