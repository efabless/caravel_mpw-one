#include "../../defs.h"

#define PROJECT 5
#define NB_OUTPUTS 28

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
    system clock
    system reset_n

    Outputs
    8  - 14 segment_hxxx
    15 - 21 segment_xhxx
    22 - 28 segment_xxhx
    29 - 35 segment_xxxh
    */
    volatile uint32_t *io = &reg_mprj_io_0;
    for (int i = 8 ; i < 8+NB_OUTPUTS ; i++) {
        io[i] = GPIO_MODE_USER_STD_OUTPUT;
    }
    // for (int i = 0; i < NUMNODES; i++) {
    // 	for (int j = 0; j <= 1; j += 6)
    // 		io[i + j] = GPIO_MODE_USER_STD_INPUT_NOPULL;
    // 	for (int j = 1; j <= 29; j += 6)
    // 		io[i + j] = GPIO_MODE_USER_STD_OUTPUT;
    // }

    /* Apply configuration */
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    // change to project
    reg_mprj_slave = PROJECT;

    // use logic analyser bit 0 as reset
    reg_la0_ena  = 0x00000000; // bits 31:0 outputs
    reg_la0_data = 0x00000001; // reset high is on bit 0
    reg_la0_data = 0x00000000; // low

}
