#include "drivers/uart.h"
#include <stdint.h>

extern uint32_t __firm_load_addr;
extern uint32_t __firm_entry;

#define BOOT_READY  'R'
#define HANDSHAKE   'H'
#define ACK         'A'
#define ERR         'E'

#define DONE_WORD   0x444F4E45u   /* 'D''O''N''E' */
#define DONE_ACK    'D'           /* Signal after DONE is received */

void main(void) {
    uart_t *uart = UART0;

    uart_init(uart);

    uart_tx_char(uart, BOOT_READY);

    while (1) {
        char b = uart_rx_char(uart);
        if (b == HANDSHAKE) {
            uart_tx_char(uart, ACK);
            break;
        } else {
            uart_tx_char(uart, ERR);
        }
    }

    uint32_t *dst = (uint32_t *)&__firm_load_addr;

    while (1) {
        uint32_t word = 0;

        for (int i = 0; i < 4; i++) {
            uint8_t byte = (uint8_t)uart_rx_char(uart);
            word |= ((uint32_t)byte << (i * 8));
        }

        if (word == DONE_WORD) {
            uart_tx_char(uart, DONE_ACK);
            break;
        }

        *dst++ = word;

        uart_tx_char(uart, ACK);
    }

    uart_print_str(uart, "Firmware is loaded ...\r\n");

    /* Jump -> to  */
    void (*entry)(void) = (void (*)(void)) &__firm_entry;
    entry();

    while (1);  // shouldnt ret
}
// use UART as file system unitil presistance storage is done
