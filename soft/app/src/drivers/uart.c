#include "drivers/uart.h"


void uart_init(uart_t *uart)
{
    uart->DIV    = BAUD_DIV;
    uart->TXCTRL = 1;
    uart->RXCTRL = 1;
}

void uart_tx_char(uart_t *uart, char c)
{
    while (uart->TXDATA & UART_TX_FULL);
    uart->TXDATA = (uint32_t)c;
}

char uart_rx_char(uart_t *uart)
{
    uint32_t rx;
    do {
        rx = uart->RXDATA;   // read dequeues RX
    } while (rx & UART_RX_EMPTY);

    return (char)(rx & 0xFF);
}


void uart_print_str(uart_t *uart, const char *s)
{
    while (*s) {
        if (*s == '\n')
            uart_tx_char(uart, '\r');
        uart_tx_char(uart, *s++);
    }
}

char* uart_scan_str(uart_t *uart)
{
    static char buf[128];
    int i = 0;

    while (1) {
        char c = uart_rx_char(uart);

        if (c == '\r' || c == '\n') {
            uart_tx_char(uart, '\r');
            uart_tx_char(uart, '\n');
            break;
        }

        if (i < (int)(sizeof(buf) - 1)) {
            buf[i++] = c;
            uart_tx_char(uart, c);   // echo
        }
    }

    buf[i] = '\0';
    return buf;
}


void uart_print_int8(uart_t *uart, int n)
{
    if (n < 0) {
        uart_tx_char(uart, '-');
        n = -n;
    }

    if (n >= 10)
        uart_print_int8(uart, n / 10);

    uart_tx_char(uart, '0' + (n % 10));
}

int uart_scan_int8(uart_t *uart)
{
    int value = 0, sign = 1;
    char c = uart_rx_char(uart);

    if (c == '-') {
        sign = -1;
        uart_tx_char(uart, c);
        c = uart_rx_char(uart);
    }

    while (c >= '0' && c <= '9') {
        uart_tx_char(uart, c);
        value = value * 10 + (c - '0');
        c = uart_rx_char(uart);
    }

    uart_tx_char(uart, '\r');
    uart_tx_char(uart, '\n');

    return sign * value;
}

void uart_print_int32(uart_t *uart, int n)
{
    if (n < 0) {
        uart_tx_char(uart, '-');
        n = -n;
    }

    if (n >= 10)
        uart_print_int32(uart, n / 10);

    uart_tx_char(uart, '0' + (n % 10));
}

uint32_t uart_scan_int32(uart_t *uart)
{
    uint32_t value = 0;
    char c = uart_rx_char(uart);

    while (c >= '0' && c <= '9') {
        uart_tx_char(uart, c);
        value = value * 10 + (c - '0');
        c = uart_rx_char(uart);
    }

    uart_tx_char(uart, '\r');
    uart_tx_char(uart, '\n');

    return value;
}

void uart_load_firmware(uart_t *uart, uint32_t *dst, void (*entry)(void)) {
    /* 1. Signal boot ROM is ready repeatedly until handshake */
    uart_tx_char(uart, BOOT_READY);
    while (1) {
        char b;
        b = uart_rx_char(uart);
        if (b == HANDSHAKE) {
            uart_tx_char(uart, ACK);
            break;
        } else {
            uart_tx_char(uart, BOOT_READY);
        }
    }

    /* 2. Receive firmware */
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
    entry();
    while (1);
}
