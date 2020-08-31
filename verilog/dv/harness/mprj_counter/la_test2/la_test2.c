#include "../../defs.h"
#include "../../stub.c"

/*
	MPRJ LA Test:
		- Sets counter clk through LA[64]
		- Sets counter rst through LA[65] 
		- Observes count value for five clk cycle through LA[31:0]
*/

int clk = 0;
int i;

void main()
{
	// All GPIO pins are configured to be output
	// Used to flad the start/end of a test 
	reg_gpio_data = 0;
	reg_gpio_ena =  0x0000;

	// Configure All LA probes as inputs to the cpu 
	reg_la0_ena = 0xFFFFFFFF;    // [31:0]
	reg_la1_ena = 0xFFFFFFFF;    // [63:32]
	reg_la2_ena = 0xFFFFFFFF;    // [95:64]
	reg_la3_ena = 0xFFFFFFFF;    // [127:96]

	// Flag start of the test
	reg_gpio_data = 0xAB60;

	// Configure LA[64] LA[65] as outputs from the cpu
	reg_la2_ena  = 0xFFFFFFFC; 

	// Set clk & reset to one
	reg_la2_data = 0x00000003;

	// Toggle clk & de-assert reset
	for (i=0; i<11; i=i+1) {
		clk = !clk;
		reg_la2_data = 0x00000000 | clk;
	}

	if (reg_la0_data == 0x05) {
		reg_gpio_data = 0xAB61;
	}

}

