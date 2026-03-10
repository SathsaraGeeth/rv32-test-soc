// #include "drivers/uart.h"
// #include <stdlib.h>
// #include <string.h>

// void uart_init(void) {
//     UART0_DIV = BAUD_DIV;
//     UART0_TXCTRL = 1;
//     UART0_RXCTRL = 1;
// }

// void uart_tx_char(char c)
// {
//     while (UART0_TXDATA & UART0_TX_FULL);
//     UART0_TXDATA = (uint32_t)c;
// }

// char uart_rx_char(void)
// {
//     uint32_t rx;
//     do {
//         rx = UART0_RXDATA;   // reading dequeues RX
//     } while (rx & UART0_RX_EMPTY);

//     return (char)(rx & 0xFF);
// }

// void uart_print_str(const char *s)
// {
//     while (*s) {
//         if (*s == '\n')
//             uart_tx_char('\r');  // enforce CRLF
//         uart_tx_char(*s++);
//     }
// }

// char* uart_scan_str(void)
// {
//     static char buf[128];
//     int i = 0;

//     while (1) {
//         char c = uart_rx_char();

//         if (c == '\r' || c == '\n') {
//             uart_tx_char('\r');
//             uart_tx_char('\n');
//             break;
//         }

//         if (i < (int)(sizeof(buf) - 1)) {
//             buf[i++] = c;
//             uart_tx_char(c);   // echo
//         }
//     }

//     buf[i] = '\0';
//     return buf;
// }

// void uart_print_int8(int n)
// {
//     if (n < 0) {
//         uart_tx_char('-');
//         n = -n;
//     }

//     if (n >= 10)
//         uart_print_int8(n / 10);

//     uart_tx_char('0' + (n % 10));
// }

// int uart_scan_int8(void)
// {
//     int value = 0;
//     int sign = 1;
//     char c;

//     c = uart_rx_char();
//     if (c == '-') {
//         sign = -1;
//         uart_tx_char(c);
//         c = uart_rx_char();
//     }

//     while (c >= '0' && c <= '9') {
//         uart_tx_char(c);
//         value = value * 10 + (c - '0');
//         c = uart_rx_char();
//     }

//     uart_tx_char('\r');
//     uart_tx_char('\n');

//     return sign * value;
// }

// void uart_print_int32(int n)
// {
//     if (n < 0) {
//         uart_tx_char('-');
//         n = -n;
//     }

//     if (n >= 10)
//         uart_print_int32(n / 10);

//     uart_tx_char('0' + (n % 10));
// }

// uint32_t uart_scan_int32(void)
// {
//     uint32_t value = 0;
//     char c = uart_rx_char();

//     while (c >= '0' && c <= '9') {
//         uart_tx_char(c);
//         value = value * 10 + (c - '0');
//         c = uart_rx_char();
//     }

//     uart_tx_char('\r');
//     uart_tx_char('\n');

//     return value;
// }


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
