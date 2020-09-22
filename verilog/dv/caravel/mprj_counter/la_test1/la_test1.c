#include "../../defs.h"
#include "../../stub.c"

// --------------------------------------------------------

/*
	MPRJ Logic Analyzer Test:
		- Observes counter value through LA probes [31:0] 
		- Sets counter initial value through LA probes [63:32]
		- Flags when counter value exceeds 500 through the management SoC gpio
		- Outputs message to the UART when the test concludes successfuly
*/

void main()
{

	// All GPIO pins are configured to be output
	// Used to flad the start/end of a test 
	reg_gpio_data = 0;
	reg_gpio_ena =  0x0000;

	// Set UART clock to 64 kbaud
	reg_uart_clkdiv = 625;

	// Configure LA probes [31:0], [127:64] as inputs to the cpu 
	// Configure LA probes [63:32] as outputs from the cpu
	reg_la0_ena = 0xFFFFFFFF;    // [31:0]
	reg_la1_ena = 0x00000000;    // [63:32]
	reg_la2_ena = 0xFFFFFFFF;    // [95:64]
	reg_la3_ena = 0xFFFFFFFF;    // [127:96]

	// Flag start of the test 
	reg_gpio_data = 0xAB40;

	// Set Counter value to zero through LA probes [63:32]
	reg_la1_data = 0x00000000;

	// Configure LA probes from [63:32] as inputs to disable counter write
	reg_la1_ena  = 0xFFFFFFFF;    

	while (1) {
		if (reg_la0_data > 0x1F4) {
			reg_gpio_data = 0xAB41;
			break;
		}
	}
	print("\n");
	print("Monitor: Test 2 Passed\n\n");
	reg_gpio_data = 0xAB51;
}

