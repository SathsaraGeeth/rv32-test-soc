#ifndef GPIO_H
#define GPIO_H

#include <stdint.h>

#define GPIO0_BASE  0x20000000

#define GPIO0       (*(volatile uint32_t *)(GPIO0_BASE + 0x00))

#define SW0_MASK    (1 << 0)
#define SW1_MASK    (1 << 1)
#define BTN0_MASK   (1 << 2)
#define BTN1_MASK   (1 << 3)
#define BTN2_MASK   (1 << 4)
#define LED0_MASK   (1 << 5)
#define LED1_MASK   (1 << 6)
#define LED2_MASK   (1 << 7)
#define RGB0_MASK   (1 << 8)
#define RGB1_MASK   (1 << 9)
#define RGB2_MASK   (1 << 10)
#define RGB3_MASK   (1 << 11)
#define RGB4_MASK   (1 << 12)
#define RGB5_MASK   (1 << 13)

// RO = 32'b0000_0000_0000_0000_0000_0000_0001_1111
// WO = 32'b0000_0000_0000_0000_0011_1111_1110_0000
// RW = 32'b0000_0000_0000_0000_0000_0000_0000_0000
// GPIO_BANK0 - {18'b0, led_rgb[5], led_rgb[4], led_rgb[3], led_rgb[2], led_rgb[1], led_rgb[0], led[2], led[1], led[0], btn_db[2], btn_db[1], btn_db[0], sw[1], sw[0]}

void     gpio_write(uint32_t mask, uint32_t value);
uint32_t gpio_read(uint32_t mask);
void     gpio_set(uint32_t mask);
void     gpio_clear(uint32_t mask); 

#endif // GPIO_H
