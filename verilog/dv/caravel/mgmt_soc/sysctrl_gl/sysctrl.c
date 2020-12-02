#include "../../defs.h"

// --------------------------------------------------------

/*
 *	System Control Test
 *	- Enables SPI master
 *	- Uses SPI master to internally access the housekeeping SPI
 *      - Reads default value of SPI-Controlled registers
 *      - Flags failure/success using mprj_io
 */
void main()
{
    int i;
    uint32_t value;

    reg_mprj_datal = 0;

    // Configure upper 16 bits of user GPIO for generating testbench
    // checkpoints.

    reg_mprj_io_31 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_30 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_29 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_28 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_27 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_26 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_25 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_24 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_23 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_22 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_21 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_20 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_19 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_18 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_17 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_16 = GPIO_MODE_MGMT_STD_OUTPUT;

    // Configure next 8 bits for writing the SPI value read on GPIO
    reg_mprj_io_15 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_14 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_13 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_12 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_11 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_10 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_9  = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_8  = GPIO_MODE_MGMT_STD_OUTPUT;

    /* Apply configuration */
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    // Start test
    reg_mprj_datal = 0xA0400000;

    // Enable SPI master
    // SPI master configuration bits:
    // bits 7-0:	Clock prescaler value (default 2)
    // bit  8:		MSB/LSB first (0 = MSB first, 1 = LSB first)
    // bit  9:		CSB sense (0 = inverted, 1 = noninverted)
    // bit 10:		SCK sense (0 = noninverted, 1 = inverted)
    // bit 11:		mode (0 = read/write opposite edges, 1 = same edges)
    // bit 12:		stream (1 = CSB ends transmission)
    // bit 13:		enable (1 = enabled)
    // bit 14:		IRQ enable (1 = enabled)
    // bit 15:		Connect to housekeeping SPI (1 = connected)

    reg_spimaster_config = 0xa002;	// Enable, prescaler = 2,
					// connect to housekeeping SPI

    // Apply stream read (0x40 + 0x03) and read back one byte 

    reg_spimaster_config = 0xb002;	// Apply stream mode
    reg_spimaster_data = 0x40;		// Write 0x40 (read mode)
    reg_spimaster_data = 0x01;		// Write 0x01 (start address)

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA0410000 | (value << 8);	// Mfgr ID (high)

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA0420000 | (value << 8);	// Mfgr ID (low)

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA0430000 | (value << 8);	// Prod ID

    reg_spimaster_config = 0xa102;	// Release CSB (ends stream mode)
    reg_spimaster_config = 0xb002;	// Apply stream mode
    reg_spimaster_data = 0x40;		// Write 0x40 (read mode)
    reg_spimaster_data = 0x08;		// Write 0x08 (start address)

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA0440000 | (value << 8);	// PLL enable

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA0450000 | (value << 8);	// PLL bypass

    reg_spimaster_config = 0xa102;	// Release CSB (ends stream mode)
    reg_spimaster_config = 0xb002;	// Apply stream mode
    reg_spimaster_data = 0x40;		// Write 0x40 (read mode)
    reg_spimaster_data = 0x0d;		// Write 0x0d (start address)

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA0460000 | (value << 8);	// PLL trim (2 high bits)

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA0470000 | (value << 8);	// PLL trim (2nd byte)

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA0480000 | (value << 8);	// PLL trim (3rd byte)

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA0490000 | (value << 8);	// PLL trim (low byte)

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA04a0000 | (value << 8);	// PLL select (3 lowest bits)

    reg_spimaster_data = 0x00;		// Write 0x00 for read
    value = reg_spimaster_data;		// Read back byte
    // Write checkpoint
    reg_mprj_datal = 0xA04b0000 | (value << 8);	// PLL divider (5 lowest bits)

    reg_spimaster_config = 0xa102;	// Release CSB (ends stream mode)
    reg_spimaster_config = 0x2102;	// Release housekeeping SPI

    // End test
    reg_mprj_datal = 0xA0900000;
}

