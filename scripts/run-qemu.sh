#!/bin/bash

KERNEL_FILE=kernel8.img
DTB_FILE=devicestree/bcm2711-rpi-4-b.dtb
MACHINE=ast2600-evb

if [ ! -f $KERNEL_FILE ]; then
   make
fi

sudo qemu-system-aarch64 \
    -M raspi3            \
    -machine $MACHINE    \
    -kernel $KERNEL_FILE \
    -dtb $DTB_FILE       \
    -serial stdio        \
    -nographic
