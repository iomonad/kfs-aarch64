#
# (c) iomonad - <iomonad@riseup.net>
#

############################################################
# Environment
############################################################

TOOLCHAIN ?= aarch64-linux-gnu
CC         = ${TOOLCHAIN}-gcc
ASM        = ${TOOLCHAIN}-gcc
LD         = ${TOOLCHAIN}-ld.gold
BUILDDIR   = build
ASMDIR     = asm
SRCSDIR    = srcs
INCDIR     = includes
CCOPTS     = -Wall -nostdlib -nostartfiles -ffreestanding  -mgeneral-regs-only -I$(INCDIR)
ASMOPTS    = -I$(INCDIR)

############################################################
# Generators
############################################################

$(BUILDDIR)/%.o: $(SRCSDIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CCOPTS) -MMD -c $< -o $@

$(BUILDDIR)/%.o: $(ASMDIR)/%.S
	@mkdir -p $(@D)
	$(ASM) $(ASMOPTS) -c -MMD $< -o $@

C_FILES   =  $(wildcard $(SRCSDIR)/*.c)
ASM_FILES =  $(wildcard $(ASMDIR)/*.S)

OBJ_FILES =  $(C_FILES:$(SRCSDIR)/%.c=$(BUILDDIR)/%.o)
OBJ_FILES += $(ASM_FILES:$(ASMDIR)/%.S=$(BUILDDIR)/%.o)

-include $(OBJ_FILES:%.o=%.d)

############################################################
# Targets
############################################################

all: kernel8.img

clean:
	rm -rf $(BUILDDIR) *.img
re: clean all

kernel8.img: linker.ld $(OBJ_FILES)
	$(LD) -T linker.ld -o $(BUILDDIR)/kernel8.elf $(OBJ_FILES)
	$(TOOLCHAIN)-objcopy $(BUILDDIR)/kernel8.elf -O binary kernel8.img
