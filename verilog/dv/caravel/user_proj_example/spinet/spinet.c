#include "../../defs.h"

/*
	IO Test:
		- Configures MPRJ pins
		- Nothing else to do: spinet is autonomous
*/

#define PROJECT 3
#define NUMNODES 6

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
          Inputs       | Outputs
	Node  MOSI SCK  SS   MISO TXRDY RXRDY
	0     0    6    12   18   24    30
	1     1    7    13   19   25    31
	2     2    8    14   20   26    32
	3     3    9    15   21   27    33
	4     4   10    16   22   28    34
	5     5   11    17   23   29    35

    */

	volatile uint32_t *io = &reg_mprj_io_0;
	for (int i = 0; i < NUMNODES; i++) {
		for (int j = 0; j <= 12; j += 6)
			io[i + j] = GPIO_MODE_USER_STD_INPUT_NOPULL;
		for (int j = 18; j <= 30; j += 6)
			io[i + j] = GPIO_MODE_USER_STD_OUTPUT;
	}
			
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
