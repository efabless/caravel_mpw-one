#include "../../defs.h"

// --------------------------------------------------------

/*
	Memory Test
	It uses GPIO to flag the success or failure of the test
*/
unsigned int ints[10];
unsigned short shorts[10];
unsigned char bytes[10];

void main()
{
	int i;

	/* All GPIO pins are configured to be output */
	reg_gpio_data = 0;
	reg_gpio_ena =  0x0000;

	// start test
	reg_gpio_data = 0xA040;

	// Test Word R/W
	for(i=0; i<10; i++)
		ints[i] = i*5000 + 10000;
	
	for(i=0; i<10; i++)
		if((i*5000+10000) != ints[i]) reg_gpio_data = 0xAB40;
	reg_gpio_data = 0xAB41;
	
	// Test Half Word R/W
	reg_gpio_data = 0xA020;
	for(i=0; i<10; i++)
		shorts[i] = i*500 + 100;
	
	for(i=0; i<10; i++)
		if((i*500+100) != shorts[i]) reg_gpio_data = 0xAB20;
	reg_gpio_data = 0xAB21;

	// Test byte R/W
	reg_gpio_data = 0xA010;
	for(i=0; i<10; i++)
		bytes[i] = i*5 + 10;
	
	for(i=0; i<10; i++)
		if((i*5+10) != bytes[i]) reg_gpio_data = 0xAB10;
	reg_gpio_data = 0xAB11;

}

