#include "../../defs.h"

// --------------------------------------------------------

/*
	Performance Test
	It uses GPIO to flag the success or failure of the test
*/
unsigned int ints[50];
unsigned short shorts[50];
unsigned char bytes[50];

int main()
{
	int i;
    int sum = 0;

	/* All GPIO pins are configured to be output */
	reg_gpio_data = 0;
	reg_gpio_ena =  0x0000;

	// start test
	reg_gpio_data = 0xA000;
	
    for(i=0; i<100; i++)
        sum+=(sum + i);
    
    reg_gpio_data = 0xAB00;
    
    return sum;
	
}

