#include "../../defs.h"

// --------------------------------------------------------

/*
	GPIO Test
		Tests PU and PD on the lower 2 pins while being driven from outside
		Tests Writing to the upper 2 pins
		Tests reading from the lower 2 pins
*/
void main()
{
	int i;

	/* Lower 2 pins are input and upper 2 pins are o/p */
	reg_gpio_data = 0;
	reg_gpio_ena =  0x0003;

	// change the pull up and pull down (checked by the TB)
	reg_gpio_data = 0x0100;
	reg_gpio_pu = 0x0001;
	reg_gpio_pd = 0x0002;

	reg_gpio_data = 0x0300;
	reg_gpio_pu = 0x0002;
	reg_gpio_pd = 0x0001;

	reg_gpio_pu = 0x0001;
	reg_gpio_pd = 0x0002;

	// read the lower 2 pins, add 1 then o/p the result
	// checked by the TB
	reg_gpio_data = 0x0100;
	while (1){
		int x = reg_gpio_data & 0x03;
		reg_gpio_data = (x+1) << 8;
	}
}

