// Author: iomonad - iomonad@riseup.net
// File: boot.s
// Compilation: aarch64-linux-gnu-gcc -c -c -MMD
// Notes:
//  - https://developer.arm.com/documentation/100403/0200/register-descriptions\
//    /aarch64-system-registers/mpidr-el1--multiprocessor-affinity-register--el1
//  - https://github.com/raspberrypi/tools/blob/master/armstubs/armstub.S#L35
// Registers:
//  Xn->64 / Wn->32

#include <mm.h>

.section ".text.boot"

.globl _start
_start:
  // The MPIDR_EL1 provides an additional core identification mechanism
  // for scheduling purposes in a cluster.
  mrs   x1, mpidr_el1
  and   x1, x1, #3
  cbz   x1, 2f          // branch on zero
1:
  wfe                   // wait for events
  b     1b              // recur
2:
  ldr   x1, =_start     // stack ptr
  mov   sp, x1
  ldr   x1, =__bss_start
  ldr   w2, =__bss_size
3:
  cbz   w2, 4f
  // store with immediate offset in WZR/XZR zero registers
  str   xzr, [x1], #8
  sub   w2, w2, #1
  cbnz  w2, 3b          // when offset not reach loop
4:
  bl    __kernel_entrypoint
  b     1b              // halt if entrypoint return
