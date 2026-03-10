#include "drivers/uart.h"
#include "drivers/gpio.h"

void main(void) {
    uart_t *uart = UART0;
    while (1) {
        uart_tx_char(uart, '0');
    }
}
