//-------------------------------------
// SPI controller for Caravel (PicoSoC)
//-------------------------------------
// Written by Tim Edwards
// efabless, inc. September 27, 2020
//-------------------------------------

`include "caravel_spi_slave.v"

//-----------------------------------------------------------
// This is a standalone slave SPI for the caravel chip that is
// intended to be independent of the picosoc and independent
// of all IP blocks except the power-on-reset.  This SPI has
// register outputs controlling the functions that critically
// affect operation of the picosoc and so cannot be accessed
// from the picosoc itself.  This includes the PLL enables
// and trim, and the crystal oscillator enable.  It also has
// a general reset for the picosoc, an IRQ input, a bypass for
// the entire crystal oscillator and PLL chain, the
// manufacturer and product IDs and product revision number.
// To be independent of the 1.8V regulator, the slave SPI is
// synthesized with the 3V digital library and runs off of
// the 3V supply.
//
// This module is designed to be decoupled from the chip
// padframe and redirected to the wishbone bus under
// register control from the management SoC, such that the
// contents can be accessed from the management core via the
// SPI master.
//
//-----------------------------------------------------------

//------------------------------------------------------------
// Caravel defined registers:
// Register 0:  SPI status and control (unused & reserved)
// Register 1 and 2:  Manufacturer ID (0x0456) (readonly)
// Register 3:  Product ID (= 2) (readonly)
// Register 4-7: Mask revision (readonly) --- Externally programmed
//	with via programming.  Via programmed with a script to match
//	each customer ID.
//
// Register 8:   PLL enable (1 bit)
// Register 9:   PLL bypass (1 bit)
// Register 10:  IRQ (1 bit)
// Register 11:  reset (1 bit)
// Register 12:  trap (1 bit) (readonly)
// Register 13-16:  PLL trim (26 bits)
// Register 17:	 PLL output select (3 bits)
// Register 18:	 PLL divider (5 bits)
//------------------------------------------------------------

module caravel_spi(
`ifdef LVS
    vdd, vss, 
`endif
    RSTB, SCK, SDI, CSB, SDO, sdo_enb,
    mgmt_sck, mgmt_sdi, mgmt_csb, mgmt_sdo,
    pll_dco_ena, pll_div, pll_sel,
    pll_trim, pll_bypass, irq, reset, trap,
    mask_rev_in, pass_thru_reset,
    pass_thru_mgmt_sck, pass_thru_mgmt_csb,
    pass_thru_mgmt_sdi, pass_thru_mgmt_sdo,
    pass_thru_user_sck, pass_thru_user_csb,
    pass_thru_user_sdi, pass_thru_user_sdo
);

`ifdef LVS
    inout vdd;	    // 3.3V supply
    inout vss;	    // common ground
`endif
    
    input RSTB;	    // from padframe

    input SCK;	    // from padframe
    input SDI;	    // from padframe
    input CSB;	    // from padframe
    output SDO;	    // to padframe
    output sdo_enb; // to padframe

    input mgmt_sck;    // from management SoC
    input mgmt_sdi;    // from management SoC
    input mgmt_csb;    // from management SoC
    output mgmt_sdo;   // to management SoC

    output pll_dco_ena;
    output [4:0] pll_div;
    output [2:0] pll_sel;
    output [25:0] pll_trim;
    output pll_bypass;
    output irq;
    output reset;
    input  trap;
    input [31:0] mask_rev_in;	// metal programmed;  3.3V domain

    // Pass-through programming mode for management area SPI flash
    output pass_thru_reset;
    output pass_thru_mgmt_sck;
    output pass_thru_mgmt_csb;
    output pass_thru_mgmt_sdi;
    input  pass_thru_mgmt_sdo;

    // Pass-through programming mode for user area SPI flash
    output pass_thru_user_sck;
    output pass_thru_user_csb;
    output pass_thru_user_sdi;
    input  pass_thru_user_sdo;

    reg [25:0] pll_trim;
    reg [4:0] pll_div;
    reg [2:0] pll_sel;
    reg pll_dco_ena;
    reg pll_bypass;
    reg reset_reg;
    reg irq;

    wire [7:0] odata;
    wire [7:0] idata;
    wire [7:0] iaddr;

    wire trap;
    wire rdstb;
    wire wrstb;
    wire pass_thru_mgmt;		// Mode detected by spi_slave
    wire pass_thru_mgmt_delay;
    wire pass_thru_user;		// Mode detected by spi_slave
    wire pass_thru_user_delay;

    // Connect to management SoC SPI master when mgmt_csb is low

    wire loc_sck;
    wire loc_csb;
    wire loc_sdi;
    wire loc_sdo;
    wire loc_sdoenb;

    assign loc_csb = (mgmt_csb == 1'b0) ? 1'b0 : CSB;
    assign loc_sck = (mgmt_csb == 1'b0) ? mgmt_sck : SCK;
    assign loc_sdi = (mgmt_csb == 1'b0) ? mgmt_sdi : SDI;

    assign mgmt_sdo = (mgmt_csb == 1'b0) ? loc_sdo : 1'b0;
    assign sdo_enb = (mgmt_csb == 1'b0) ? 1'b1 : loc_sdoenb;

    // Pass-through mode handling

    assign pass_thru_mgmt_csb = ~pass_thru_mgmt_delay;
    assign pass_thru_mgmt_sck = pass_thru_mgmt ? SCK : 1'b0;
    assign pass_thru_mgmt_sdi = pass_thru_mgmt ? SDI : 1'b0;

    assign pass_thru_user_csb = ~pass_thru_user_delay;
    assign pass_thru_user_sck = pass_thru_user ? SCK : 1'b0;
    assign pass_thru_user_sdi = pass_thru_user ? SDI : 1'b0;

    assign SDO = pass_thru_mgmt ? pass_thru_mgmt_sdo :
		 pass_thru_user ? pass_thru_user_sdo : loc_sdo;
    assign reset = pass_thru_reset ? 1'b1 : reset_reg;

    // Instantiate the SPI slave module

    caravel_spi_slave U1 (
	.reset(~RSTB),
    	.SCK(loc_sck),
    	.SDI(loc_sdi),
    	.CSB(loc_csb),
    	.SDO(loc_sdo),
    	.sdoenb(loc_sdoenb),
    	.idata(odata),
    	.odata(idata),
    	.oaddr(iaddr),
    	.rdstb(rdstb),
    	.wrstb(wrstb),
    	.pass_thru_mgmt(pass_thru_mgmt),
    	.pass_thru_mgmt_delay(pass_thru_mgmt_delay),
    	.pass_thru_user(pass_thru_user),
    	.pass_thru_user_delay(pass_thru_user_delay),
    	.pass_thru_reset(pass_thru_reset)
    );

    wire [11:0] mfgr_id;
    wire [7:0]  prod_id;
    wire [31:0] mask_rev;

    assign mfgr_id = 12'h456;		// Hard-coded
    assign prod_id = 8'h10;		// Hard-coded
    assign mask_rev = mask_rev_in;	// Copy in to out.

    // Send register contents to odata on SPI read command
    // All values are 1-4 bits and no shadow registers are required.

    assign odata = 
    (iaddr == 8'h00) ? 8'h00 :	// SPI status (fixed)
    (iaddr == 8'h01) ? {4'h0, mfgr_id[11:8]} :	// Manufacturer ID (fixed)
    (iaddr == 8'h02) ? mfgr_id[7:0] :	// Manufacturer ID (fixed)
    (iaddr == 8'h03) ? prod_id :	// Product ID (fixed)
    (iaddr == 8'h04) ? mask_rev[31:24] :	// Mask rev (metal programmed)
    (iaddr == 8'h05) ? mask_rev[23:16] :	// Mask rev (metal programmed)
    (iaddr == 8'h06) ? mask_rev[15:8] :		// Mask rev (metal programmed)
    (iaddr == 8'h07) ? mask_rev[7:0] :		// Mask rev (metal programmed)

    (iaddr == 8'h08) ? {7'b0000000, pll_dco_ena} :
    (iaddr == 8'h09) ? {7'b0000000, pll_bypass} :
    (iaddr == 8'h0a) ? {7'b0000000, irq} :
    (iaddr == 8'h0b) ? {7'b0000000, reset} :
    (iaddr == 8'h0c) ? {7'b0000000, trap} :
    (iaddr == 8'h0d) ? pll_trim[7:0] :
    (iaddr == 8'h0e) ? pll_trim[15:8] :
    (iaddr == 8'h0f) ? pll_trim[23:16] :
    (iaddr == 8'h10) ? {6'b000000, pll_trim[25:24]} :
    (iaddr == 8'h11) ? {5'b00000, pll_sel} :
    (iaddr == 8'h12) ? {3'b000, pll_div} :
               8'h00;	// Default

    // Register mapping and I/O to slave module

    always @(posedge SCK or negedge RSTB) begin
    if (RSTB == 1'b0) begin
        // Set trim for PLL at (almost) slowest rate (~90MHz).  However,
        // pll_trim[12] must be set to zero for proper startup.
        pll_trim <= 26'b11111111111110111111111111;
        pll_sel <= 3'b000;
        pll_div <= 5'b00100;	// Default divide-by-8
        pll_dco_ena <= 1'b1;	// Default free-running PLL
        pll_bypass <= 1'b1;		// NOTE: Default bypass mode (don't use PLL)
        irq <= 1'b0;
        reset_reg <= 1'b0;
    end else if (wrstb == 1'b1) begin
        case (iaddr)
        8'h08: begin
             pll_dco_ena <= idata[0];
               end
        8'h09: begin
             pll_bypass <= idata[0];
               end
        8'h0a: begin
             irq <= idata[0];
               end
        8'h0b: begin
             reset_reg <= idata[0];
               end
        // Register 0xc is read-only
        8'h0d: begin
              pll_trim[7:0] <= idata;
               end
        8'h0e: begin
              pll_trim[15:8] <= idata;
               end
        8'h0f: begin
              pll_trim[23:16] <= idata;
               end
        8'h10: begin
              pll_trim[25:24] <= idata[1:0];
               end
        8'h11: begin
             pll_sel <= idata[2:0];
               end
        8'h12: begin
             pll_div <= idata[4:0];
               end
        endcase	// (iaddr)
    end
    end
endmodule	// caravel_spi
