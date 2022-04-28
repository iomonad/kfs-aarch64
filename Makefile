#
# (c) iomonad - <iomonad@riseup.net>
#

CC  = aarch64-linux-gnu-gcc
ASM = aarch64-elf-as -c
LD  = aarch64-linux-gnu-ld.gold

all:
	  ${CC} boot.s -o boot.o
