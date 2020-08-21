#include "../defs.h"

// --------------------------------------------------------

/*
	GPIO Test
		Tests PU and PD on the lower 8 pins while being driven from outside
		Tests Writing to the upper 8 pins
		Tests reading from the lower 8 pins
*/
void main()
{
	int i;

	/* Lower 8 pins are input and upper 8 pins are o/p */
	reg_gpio_data = 0;
	reg_gpio_ena =  0x00ff;

	// change the pull up and pull down (checked by the TB)
	reg_gpio_data = 0xA000;
	reg_gpio_pu = 0x000f;
	reg_gpio_pd = 0x00f0;

	reg_gpio_data = 0x0B00;
	reg_gpio_pu = 0x00f0;
	reg_gpio_pd = 0x000f;

	reg_gpio_pu = 0x000f;
	reg_gpio_pd = 0x00f0;

	// read the lower 8 pins, add 1 then o/p the result
	// checked by the TB
	reg_gpio_data = 0xAB00;
	while (1){
		int x = reg_gpio_data & 0xff;
		reg_gpio_data = (x+1) << 8;
	}
}

