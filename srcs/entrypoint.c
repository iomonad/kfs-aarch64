/*
 * author: iomonad@riseup.net
 * see: https://github.com/iomonad/kfs-aarch64
 */

#include <io/uart.h>

void __attribute__((cold))
__kernel_entrypoint(void) {
    io_uart_init();
    io_uart_write("hello bare metal\n");
    for (;;) {}
}
