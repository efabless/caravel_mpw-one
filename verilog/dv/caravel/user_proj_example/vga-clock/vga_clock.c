#include "../../defs.h"

/*
	IO Test:
		- Configures MPRJ pins
		- Observes counter value through the LED digits
*/

void main()
{
	/* 
	IO Control Registers
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 3-bits | 1-bit | 1-bit | 1-bit  | 1-bit  | 1-bit | 1-bit   | 1-bit   | 1-bit | 1-bit | 1-bit   |

	Output: 0000_0110_0000_1110  (0x1808) = GPIO_MODE_USER_STD_OUTPUT
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 110    | 0     | 0     | 0      | 0      | 0     | 0       | 1       | 0     | 0     | 0       |

	Output: 0000_0110_0000_1111  (0x1809) = GPIO_MODE_MGNT_STD_OUTPUT
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 110    | 0     | 0     | 0      | 0      | 0     | 0       | 1       | 0     | 0     | 1       |
	
	 
	Input: 0000_0001_0000_1111 (0x0402) = GPIO_MODE_USER_STD_INPUT_NOPULL
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 001    | 0     | 0     | 0      | 0      | 0     | 0       | 0       | 0     | 1     | 0       |

	*/

    /* 
    Inputs

    0   clock
    1   reset
    2   adj hours
    3   adj min
    4   adj sec


    Outputs

    5   hsync
    6   vsync
    7-12 rrggbb
    */

	reg_mprj_io_0 =  GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_1 =  GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_2 =  GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_3 =  GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_4 =  GPIO_MODE_USER_STD_INPUT_NOPULL;

    reg_mprj_io_5 =  GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_6 =  GPIO_MODE_USER_STD_OUTPUT;

    reg_mprj_io_7 =  GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_8 =  GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_9 =  GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_10 =  GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_11 =  GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_12 =  GPIO_MODE_USER_STD_OUTPUT;

    /* Apply configuration */
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    // change to project 2
    reg_mprj_slave = 2;

    // use logic analyser to reset the design
    reg_la0_ena  = 0x00000000; // bits 31:0 outputs
    reg_la0_data = 0x00000001; // reset high is on bit 0
    reg_la0_data = 0x00000000; // low
}
