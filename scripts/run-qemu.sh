#!/bin/bash

KERNEL_FILE=kernel8.img
DTB_FILE=devicestree/bcm2711-rpi-4-b.dtb
CPU=cortex-a72

if [ ! -f $KERNEL_FILE ]; then
   make
fi

sudo qemu-system-aarch64 \
     -M virt,highmem=off \
     -cpu $CPU \
     -kernel $KERNEL_FILE \
     -dtb $DTB_FILE
