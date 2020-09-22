#include "../../defs.h"

// --------------------------------------------------------

/*
	System Control Test
        - Reads default value of SPI-Controlled registers
        - Flags failure/success using gpio
*/
void main()
{
	int i;

    reg_gpio_data = 0;
	reg_gpio_ena =  0x0000;

	// start test
	reg_gpio_data = 0xA040;

    // Read Product ID value
    if(0x05 != reg_spi_prod_id) reg_gpio_data = 0xAB40;
	reg_gpio_data = 0xAB41;

    // Read Manufacturer ID value
    if(0x456 != reg_spi_mfgr_id) reg_gpio_data = 0xAB50;
	reg_gpio_data = 0xAB51;

    // Read Mask revision 
    if(0x1 != reg_spi_mask_rev) reg_gpio_data = 0xAB60;
	reg_gpio_data = 0xAB61;

    // Read PLL-Bypass
    if(0x1 != reg_spi_pll_bypass) reg_gpio_data = 0xAB70;
	reg_gpio_data = 0xAB71;

    if(0x7FFDFFF != reg_spi_pll_config) reg_gpio_data = 0xAB80;
	reg_gpio_data = 0xAB81;

    // Read spi enables
    if(0x83 != reg_spi_enables) reg_gpio_data = 0xAB90;
	reg_gpio_data = 0xAB91;
}

