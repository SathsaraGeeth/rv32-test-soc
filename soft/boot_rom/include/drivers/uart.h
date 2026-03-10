// #ifndef UART_H
// #define UART_H

// #include <stdint.h>

// #define UART0_BASE   0x20001000
// #define BAUD_DIV     868

// #define UART0_TXDATA (*(volatile uint32_t *)(UART0_BASE + 0x00))
// #define UART0_RXDATA (*(volatile uint32_t *)(UART0_BASE + 0x04))
// #define UART0_TXCTRL (*(volatile uint32_t *)(UART0_BASE + 0x08))
// #define UART0_RXCTRL (*(volatile uint32_t *)(UART0_BASE + 0x0C))
// #define UART0_IE     (*(volatile uint32_t *)(UART0_BASE + 0x10))
// #define UART0_DIV    (*(volatile uint32_t *)(UART0_BASE + 0x18))

// #define UART0_TX_FULL   (1u << 31)
// #define UART0_RX_EMPTY  (1u << 31)


// #define UART1_BASE   0x20011000
// #define BAUD_DIV     868

// #define UART1_TXDATA (*(volatile uint32_t *)(UART1_BASE + 0x00))
// #define UART1_RXDATA (*(volatile uint32_t *)(UART1_BASE + 0x04))
// #define UART1_TXCTRL (*(volatile uint32_t *)(UART1_BASE + 0x08))
// #define UART1_RXCTRL (*(volatile uint32_t *)(UART1_BASE + 0x0C))
// #define UART1_IE     (*(volatile uint32_t *)(UART1_BASE + 0x10))
// #define UART1_DIV    (*(volatile uint32_t *)(UART1_BASE + 0x18))

// #define UART1_TX_FULL   (1u << 31)
// #define UART1_RX_EMPTY  (1u << 31)


// void    uart_init(void);
// void    uart_tx_char(char c);
// char    uart_rx_char(void);
// void    uart_print_str(const char *s);
// char*   uart_scan_str(void);
// void    uart_print_int8(int n);
// int     uart_scan_int8(void);
// void    uart_print_int32(int n);
// uint32_t uart_scan_int32(void);

// #endif


#ifndef UART_H
#define UART_H

#include <stdint.h>

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

#define BAUD_DIV        868
#define UART_TX_FULL    (1u << 31)
#define UART_RX_EMPTY   (1u << 31)

void     uart_init(uart_t *uart);

void     uart_tx_char(uart_t *uart, char c);
char     uart_rx_char(uart_t *uart);

void     uart_print_str(uart_t *uart, const char *s);
char*    uart_scan_str(uart_t *uart);

void     uart_print_int8(uart_t *uart, int n);
int      uart_scan_int8(uart_t *uart);

void     uart_print_int32(uart_t *uart, int n);
uint32_t uart_scan_int32(uart_t *uart);

#endif
