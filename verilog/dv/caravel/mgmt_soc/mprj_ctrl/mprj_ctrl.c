#include "../../defs.h"

// --------------------------------------------------------

/*
 *	User Project IO Control Test
 */

void main()
{
    /* All GPIO pins are configured to be output	*/
    /* The lower 28 bits are connected to the user	*/
    /* project to output the counter result, and the	*/
    /* upper 4 bits are connected to the management	*/
    /* SoC to apply values that can be flagged by the	*/
    /* testbench for specific benchmark tests.		*/

    /* GPIOs 31 to 16 are connected to the management SoC */
    reg_mprj_io_31 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_30 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_29 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_28 = GPIO_MODE_MGMT_STD_OUTPUT;

    /* GPIOs 27 to 0 are connected to the user area */
    reg_mprj_io_27 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_26 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_25 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_24 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_23 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_22 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_21 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_20 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_19 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_18 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_17 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_16 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_13 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_12 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_11 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_10 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_9  = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_8  = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_7  = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_6  = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_5  = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_4  = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_3  = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_2  = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_1  = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_0  = GPIO_MODE_USER_STD_OUTPUT;

    // Apply configuration
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    reg_mprj_datal = 0;

    // start test
    reg_mprj_datal = 0x50000000;

    // Write to IO Control
    reg_mprj_io_0 = 0x004F;
    if (reg_mprj_io_0 != 0x004F)
	reg_mprj_datal = 0x60000000;
     else
	reg_mprj_datal = 0x70000000;

    // Write to IO Control 
    reg_mprj_io_1 = 0x005F;
    if (reg_mprj_io_1 != 0x005F)
	reg_mprj_datal = 0x80000000;
    else
	reg_mprj_datal = 0x90000000;

    // Write to IO Control
    reg_mprj_io_2 = 0x006F;
    if (reg_mprj_io_2 != 0x006F)
	reg_mprj_datal = 0xA0000000;
    else
	reg_mprj_datal = 0xb0000000;

    // Write to IO Control (NOTE:  Only 13 bits are valid)
    reg_mprj_io_3 = 0xF0F5;
    if (reg_mprj_io_3 != 0x10F5)
	reg_mprj_datal = 0xc0000000;
    else
	reg_mprj_datal = 0xd0000000;
}

