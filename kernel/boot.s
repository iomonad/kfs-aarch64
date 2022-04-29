// filename: boot.s
// comment: aarch64 mode
// nasm arguments: aarch64-elf-as -c boot.S -o boot.o

.section ".text.boot"

.globl _start

// Memory entry point for the kernel
// Registers:
//   x0 -> 32 bit pointer to DTB in memory (primary core only) / 0 (secondary cores)
//   x1 -> 0
//   x2 -> 0
//   x3 -> 0
//   x4 -> 32 bit kernel entry point, _start location

.org 0x80000
_start:
  // stack setup
  ldr   x5, =_start
  mov   sp, x5
  // bss cleanup
  ldr   x5, =__bss_start
  ldr   w6, =__bss_size

// https://github.com/raspberrypi/tools/blob/master/armstubs/armstub.S#L35
3:
  cbz   w6, 4f
  str   xzr, [x5], #8
  sub   w6, w6, #1
  cbnz  w6, 3b

// jump to C kernel code and should
// not return. For failsafe,
// halt this core too
4:
  bl kernel_main
  b 1b

// halt
halt:
  wfe
  b     halt
