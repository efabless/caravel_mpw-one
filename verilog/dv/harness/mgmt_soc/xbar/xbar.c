#include "../defs.h"

// --------------------------------------------------------

/*
	Crosbbar Switch Test
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

    // Write & Read from QSPI CTRL Slave
    qspi_ctrl_slave = 0xA0A1; 
    if(0xA0A1 != qspi_ctrl_slave) reg_gpio_data = 0xAB40;
	reg_gpio_data = 0xAB41;

    // Write & Read from storage area Slave
    storage_area_slave = 0xB0B1; 
    if(0xB0B1 != storage_area_slave) reg_gpio_data = 0xAB50;
	reg_gpio_data = 0xAB51;

    // Write & Read from Mega Project 1st slave
    mega_any_slave1 = 0xC0C1; 
    if(0xC0C1 != mega_any_slave1) reg_gpio_data = 0xAB60;
	reg_gpio_data = 0xAB61;

    // Write & Read from Mega Project 1st slave
    mega_any_slave2 = 0xD0D1; 
    if(0xD0D1 != mega_any_slave2) reg_gpio_data = 0xAB70;
	reg_gpio_data = 0xAB71;

}

