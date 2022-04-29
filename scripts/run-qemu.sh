#!/bin/bash

KERNEL_FILE=kernel8.img
DTB_FILE=devicestree/bcm2711-rpi-4-b.dtb

if [ -f $KERNEL_FILE ]
then make
fi

sudo qemu-system-aarch64 \
    -m  4096 \
    -M raspi3 \
    -kernel $KERNEL_FILE \
    -dtb $DTB_FILE \
    -nographic \
    -device usb-net,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22
