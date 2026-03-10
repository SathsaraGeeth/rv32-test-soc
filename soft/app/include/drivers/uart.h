
#ifndef UART_H
#define UART_H

#include <stdint.h>

#define BAUD_DIV        868
#define UART_TX_FULL    (1u << 31)
#define UART_RX_EMPTY   (1u << 31)

#define BOOT_READY      'R'
#define HANDSHAKE       'H'
#define ACK             'A'
#define ERR             'E'
#define DONE_WORD       0x444F4E45u   /* 'D''O''N''E' */
#define DONE_ACK        'D'           /* Signal after DONE is received */

typedef struct {
    volatile uint32_t TXDATA;
    volatile uint32_t RXDATA;
    volatile uint32_t TXCTRL;
    volatile uint32_t RXCTRL;
    volatile uint32_t IE;
    volatile uint32_t IP;
    volatile uint32_t DIV;
} uart_t;

#define UART0   ((uart_t *)0x20001000)
#define UART1   ((uart_t *)0x20011000)


void     uart_init(uart_t *uart);

void     uart_tx_char(uart_t *uart, char c);
char     uart_rx_char(uart_t *uart);

void     uart_print_str(uart_t *uart, const char *s);
char*    uart_scan_str(uart_t *uart);

void     uart_print_int8(uart_t *uart, int n);
int      uart_scan_int8(uart_t *uart);

void     uart_print_int32(uart_t *uart, int n);
uint32_t uart_scan_int32(uart_t *uart);

void     uart_load_firmware(uart_t *uart, uint32_t *dst, void (*entry)(void));

#endif

