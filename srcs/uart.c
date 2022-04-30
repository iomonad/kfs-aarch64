/*
 * author: iomonad@riseup.net
 * see: https://github.com/iomonad/kfs-aarch64
 */

#include <gpio.h>
#include <io/uart.h>

static unsigned int
uart_iswritebyteready() {
    return mmio_read(AUX_MU_LSR_REG) & 0x20;
}

static void
uart_writebyteblockingactual(unsigned char ch) {
    while (!uart_iswritebyteready())
	;
    mmio_write(AUX_MU_IO_REG, (unsigned int)ch);
}

void __attribute__ ((cold))
io_uart_init() {
    mmio_write(AUX_ENABLES, 1); //enable UART1
    mmio_write(AUX_MU_IER_REG, 0);
    mmio_write(AUX_MU_CNTL_REG, 0);
    mmio_write(AUX_MU_LCR_REG, 3); //8 bits
    mmio_write(AUX_MU_MCR_REG, 0);
    mmio_write(AUX_MU_IER_REG, 0);
    mmio_write(AUX_MU_IIR_REG, 0xC6); //disable interrupts
    mmio_write(AUX_MU_BAUD_REG, AUX_MU_BAUD(115200));
    gpio_useasalt5(14);
    gpio_useasalt5(15);
    mmio_write(AUX_MU_CNTL_REG, 3); //enable RX/TX
}

void
io_uart_write(const char *buffer) {
    while (*buffer) {
	if (*buffer == '\n') uart_writebyteblockingactual('\r');
       uart_writebyteblockingactual(*buffer++);
    }
}
