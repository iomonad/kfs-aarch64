// Author: iomonad - iomonad@riseup.net
// File: memory.s
// Compilation: aarch64-linux-gnu-gcc -c -c -MMD
// Notes:

.globl memzero
memzero:
	str xzr, [x0], #8
	subs x1, x1, #8
	b.gt memzero
	ret
