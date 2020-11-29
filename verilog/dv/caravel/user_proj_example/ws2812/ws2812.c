#include "../../defs.h"

/*
	IO Test:
		- Configures MPRJ pins
		- Observes counter value through the LED digits
*/
#define reg_mprj_oeb0 (*(volatile uint32_t*)0x30000004)
#define reg_mprj_oeb1 (*(volatile uint32_t*)0x30000008)

#define reg_mprj_ws2812 (*(volatile uint32_t*)0x30000100)

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

    system clock
    system reset

    Outputs

    8 data for ws2812
    */

    reg_mprj_io_8 =  GPIO_MODE_USER_STD_OUTPUT;

    /* Apply configuration */
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    // change to project 1
    reg_mprj_slave = 1;
    // all outputs enabled
    reg_mprj_oeb0 = 0;

    // use logic analyser to reset the design
    reg_la0_ena  = 0x00000000; // bits 31:0 outputs
    reg_la0_data = 0x00000001; // reset high is on bit 0
    reg_la0_data = 0x00000000; // low

    // update led 7
    uint8_t led_num = 7;
    uint8_t r = 255;
    uint8_t g = 10;
    uint8_t b = 100;
    reg_mprj_ws2812 = (led_num << 24) + (r << 16) + (g << 8) + b;
}
