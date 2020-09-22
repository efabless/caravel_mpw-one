#include "../../defs.h"

// --------------------------------------------------------

/*
	Mega-Project IO Control Test
*/

void main()
{
    /* All GPIO pins are configured to be output */
	reg_gpio_data = 0;
	reg_gpio_ena =  0x0000;

	// start test
	reg_gpio_data = 0xA040;

    // Write to IO Control
    reg_mprj_io_0 = 0x004F;
    if(0x004F != reg_mprj_io_0) reg_gpio_data = 0xAB40;
	reg_gpio_data = 0xAB41;

    // Write to IO Control 
    reg_mprj_io_1 = 0x005F;
    if(0x005F != reg_mprj_io_1) reg_gpio_data = 0xAB50;
	reg_gpio_data = 0xAB51;

    // Write to IO Control
    reg_mprj_io_2 = 0x006F;
    if(0x006F != reg_mprj_io_2) reg_gpio_data = 0xAB60;
	reg_gpio_data = 0xAB61;

    // Write to IO Control
    reg_mprj_io_3 = 0xF0F5;
    if(0xF0F5 != reg_mprj_io_3) reg_gpio_data = 0xAB70;
	reg_gpio_data = 0xAB71;
}

