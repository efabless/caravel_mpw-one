#include "../../defs.h"
#include "../../stub.c"

// --------------------------------------------------------

void main()
{
	// Set clock to 64 kbaud
	reg_uart_clkdiv = 625;

	// NOTE: XCLK is running in simulation at 40MHz
	// Divided by clkdiv is 64 kHz
	// So at this crystal rate, use clkdiv = 4167 for 9600 baud.

	/* Both GPIO pins are configured to be output */
	reg_gpio_data = 0;
	reg_gpio_ena =  0x0000;

	// start test
	reg_gpio_data = 0x0001;

	// This should appear at the output, received by the testbench UART.
    print("\n");
	print("Monitor: Test UART (RTL) passed\n\n");
	reg_gpio_data = 0x0002;
}

