#include "../defs.h"

// --------------------------------------------------------

void putchar(char c)
{
	if (c == '\n')
		putchar('\r');
	reg_uart_data = c;
}

void print(const char *p)
{
	while (*p)
		putchar(*(p++));
}

// --------------------------------------------------------

void main()
{
	// Set clock to 64 kbaud
	reg_uart_clkdiv = 625;

	// NOTE: XCLK is running in simulation at 40MHz
	// Divided by clkdiv is 64 kHz
	// So at this crystal rate, use clkdiv = 4167 for 9600 baud.

	/* All GPIO pins are configured to be output */
	reg_gpio_data = 0;
	reg_gpio_ena =  0x0000;

	// start test
	reg_gpio_data = 0xA000;

	// This should appear at the output, received by the testbench UART.
    print("\n");
	print("Monitor: Test UART (RTL) passed\n\n");
	reg_gpio_data = 0xAB00;
}

