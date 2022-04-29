// Author: iomonad - iomonad@riseup.net
// File: boot.s
// Compilation: aarch64-linux-gnu-gcc -c -c -MMD
// Notes:
//  - https://developer.arm.com/documentation/100403/0200/register-descriptions/aarch64-system-registers/mpidr-el1--multiprocessor-affinity-register--el1
//  - https://github.com/raspberrypi/tools/blob/master/armstubs/armstub.S#L35

#include <mm.h>

.section ".text.boot"

.globl _start
_start:
  // The MPIDR_EL1 provides an additional core identification mechanism
  // for scheduling purposes in a cluster.
  mrs   x0, mpidr_el1
  and   x0, x0, #0xFF  // strip last byte from mpdir
  cbz   x0, entrypoint // on correct cpu branch
  b     hang           // else hang

hang:
  nop
  b hang

.globl entrypoint
entrypoint:
  adr   x0, bss_begin
  adr   x1, bss_end
  sub   x1, x1, x0
  bl    memzero

  mov   sp, #LOW_MEMORY
  bl    __kernel_entrypoint
  b     hang                    // correctness, should never occur
