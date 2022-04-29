#
# (c) iomonad - <iomonad@riseup.net>
#

############################################################
# Environment
############################################################

TOOLCHAIN ?= aarch64-linux-gnu
CC         = ${TOOLCHAIN}-gcc
ASM        = ${TOOLCHAIN}-as -c
LD         = ${TOOLCHAIN}-ld.gold
CCOPTS     = -Wall -nostdlib -nostartfiles -ffreestanding \
	     -Iinclude -mgeneral-regs-only
ASMOPTS    = -I.
BUILDDIR   = build
ASMDIR     = kernel
SRCSDIR    = srcs

############################################################
# Generators
############################################################

$(BUILDDIR)/%.o: $(SRCSDIR)/%.c
	mkdir -p $(@D)
	$(ARMGNU)-gcc $(CCOPTS) -MMD -c $< -o $@

$(BUILDDIR)/%.o: $(ASMDIR)/%.s
	mkdir -p $(@D)
	$(ARMGNU)-gcc $(CCOPTS) -MMD -c $< -o $@

C_FILES = $(wildcard $(SRCSDIR)/*.c)
ASM_FILES = $(wildcard $(ASMDIR)/*.s)
OBJ_FILES = $(C_FILES:$(SRCSDIR)/%.c=$(BUILDDIR)/%.o)
OBJ_FILES += $(ASM_FILES:$(SRCSDIR)/%.S=$(BUILDDIR)/%.o)

DEP_FILES = $(OBJ_FILES:%.o=%.d)
-include $(DEP_FILES)

############################################################
# Targets
############################################################

all: kernel8.img

clean:
	rm -rf $(BUILDDIR) *.img

kernel8.img: linker.ld $(OBJ_FILES)
	echo ok
