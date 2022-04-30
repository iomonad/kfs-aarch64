#ifndef GPIO_H
#define GPIO_H

enum {
    PERIPHERAL_BASE = 0xFE000000,
    GPFSEL0         = PERIPHERAL_BASE + 0x200000,
    GPSET0          = PERIPHERAL_BASE + 0x20001C,
    GPCLR0          = PERIPHERAL_BASE + 0x200028,
    GPPUPPDN0       = PERIPHERAL_BASE + 0x2000E4
};

enum {
    GPIO_MAX_PIN       = 53,
    GPIO_FUNCTION_ALT5 = 2,
};

enum {
    Pull_None = 0,
};

void	     mmio_write(long reg, unsigned int val);
unsigned int mmio_read(long reg);
unsigned int gpio_call(unsigned int pin_number, unsigned int value,
		       unsigned int base, unsigned int field_size,
		       unsigned int field_max);
unsigned int gpio_set(unsigned int pin_number, unsigned int value);
unsigned int gpio_clear(unsigned int pin_number, unsigned int value);
unsigned int gpio_pull(unsigned int pin_number, unsigned int value);
unsigned int gpio_function(unsigned int pin_number,
			   unsigned int value);
void         gpio_useasalt5(unsigned int pin_number);

#endif
