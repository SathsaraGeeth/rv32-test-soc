#include "drivers/gpio.h"

void gpio_write(uint32_t mask, uint32_t value) {
    uint32_t current = GPIO0;
    current &= ~mask;
    current |= (value & mask);
    GPIO0 = current;
}

uint32_t gpio_read(uint32_t mask) {
    return GPIO0 & mask;
}

void gpio_set(uint32_t mask) {
    GPIO0 |= mask;
}

void gpio_clear(uint32_t mask) {
    GPIO0 &= ~mask;
}
