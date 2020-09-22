#include "../../defs.h"

/*
	IO Test:
		- Configures MPRJ lower 8-IO pins as outputs
		- Observes counter value through the MPRJ lower 8 IO pins (in the testbench)
*/

void main()
{
	/* 
	IO Control Registers
	
	| DM     | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | ENH   | HLDH_N | OEB_N |
	| 3-bits | 1-bit  | 1-bit  | 1-bit | 1-bit   | 1-bit   | 1-bit | 1-bit  | 1-bit |

	Output: 0000_0110_0000_1110  (0x060E)
	| DM  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | ENH | HLDH_N | OEB_N |
	| 110 | 0      | 0      | 0     | 0       | 1       | 1   | 1      | 0     |
	
	 
	Input: 0000_0001_0000_1111 (0x010F)
	| DM  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | ENH | HLDH_N | OEB_N |
	| 001 | 0      | 0      | 0     | 0       | 1       |  1  | 1      | 1     |

	*/

	// Configure lower 8-IOs as output
	// Observe counter value in the testbench
	reg_mprj_io_0 =  0x060E;
	reg_mprj_io_1 =  0x060E;
	reg_mprj_io_2 =  0x060E;
	reg_mprj_io_3 =  0x060E;
	reg_mprj_io_4 =  0x060E;
	reg_mprj_io_5 =  0x060E;
	reg_mprj_io_6 =  0x060E;
	reg_mprj_io_7 =  0x060E;

}

