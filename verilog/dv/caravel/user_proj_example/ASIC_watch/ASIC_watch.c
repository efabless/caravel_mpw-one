#include "../../defs.h"

#define PROJECT 5
#define NB_OUTPUTS 28

#define reg_mprj_oeb0 (*(volatile uint32_t*)0x30000004)
#define reg_mprj_oeb1 (*(volatile uint32_t*)0x30000008)
#define reg_mprj_ws2812 (*(volatile uint32_t*)0x30000500)
/*
	IO Test:
		- Configures MPRJ pins
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
    36 - Safe mode
    37 - 2^15Hz crystal clock

    Outputs
    8  - 14 segment_hxxx
    15 - 21 segment_xhxx
    22 - 28 segment_xxmx
    29 - 35 segment_xxxm
    */
    volatile uint32_t *io = &reg_mprj_io_0;
    for (int i = 8 ; i < 8+NB_OUTPUTS ; i++) {
        io[i] = GPIO_MODE_USER_STD_OUTPUT;
    }

    io[36] = GPIO_MODE_USER_STD_INPUT_NOPULL;
    io[37] = GPIO_MODE_USER_STD_INPUT_NOPULL;
    
    /* Apply configuration */
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    // change to project
    reg_mprj_slave = PROJECT;

    reg_mprj_oeb1 = (1 << 4) + (1 << 5); //GPIO 36 and 37 as inputs

    // use logic analyser bit 0 as reset
    reg_la0_ena  = 0x00000000; // bits 31:0 outputs
    reg_la0_data = 0x00000001; // reset high is on bit 0
    reg_la0_data = 0x00000000; // low

}
