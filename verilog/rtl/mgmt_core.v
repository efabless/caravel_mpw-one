module mgmt_core(
`ifdef LVS
	inout vdd1v8,	   
	inout vss,
`endif
	// GPIO (dedicated pad)
	output gpio_out_pad,		// Connect to out on gpio pad
	input  gpio_in_pad,		// Connect to in on gpio pad
	output gpio_mode0_pad,		// Connect to dm[0] on gpio pad
	output gpio_mode1_pad,		// Connect to dm[2] on gpio pad
	output gpio_outenb_pad,		// Connect to oe_n on gpio pad
	output gpio_inenb_pad,		// Connect to inp_dis on gpio pad
	// Flash memory control (SPI master)
	output flash_csb,
	output flash_clk,
	output flash_csb_oeb,
	output flash_clk_oeb,
	output flash_io0_oeb,
	output flash_io1_oeb,
	output flash_csb_ieb,
	output flash_clk_ieb,
	output flash_io0_ieb,
	output flash_io1_ieb,
	output flash_io0_do,
	output flash_io1_do,
	input flash_io0_di,
	input flash_io1_di,
	// Master reset
	input porb,
	// Clocking
	input clock,
	input ext_clk,
	output pll_clk16,
	// LA signals
    	input  [127:0] la_input,           	// From Mega-Project to cpu
    	output [127:0] la_output,          	// From CPU to Mega-Project
    	output [127:0] la_oen,              // LA output enable  
	// Mega-Project Control Signals
	inout [`MPRJ_IO_PADS-1:0] mgmt_io_data,
	output mprj_io_loader_resetn,
	output mprj_io_loader_clock,
	output mprj_io_loader_data,
	// WB MI A (Mega project)
    	input mprj_ack_i,
	input [31:0] mprj_dat_i,
    	output mprj_cyc_o,
	output mprj_stb_o,
	output mprj_we_o,
	output [3:0] mprj_sel_o,
	output [31:0] mprj_adr_o,
	output [31:0] mprj_dat_o,
    	// WB MI B Switch 
    	input xbar_ack_i,
    	input [31:0] xbar_dat_i,
    	output xbar_cyc_o,
    	output xbar_stb_o,
    	output xbar_we_o,
    	output [3:0] xbar_sel_o,
    	output [31:0] xbar_adr_o,
    	output [31:0] xbar_dat_o,

    	output core_clk,
    	output core_rstn,

	// Metal programmed user ID / mask revision vector
	input [31:0] mask_rev
);
    	wire ext_clk_sel;
    	wire ext_clk;
    	wire pll_clk;
    	wire ext_reset;

	wire spi_sck;
	wire spi_csb;
	wire spi_sdi;
	wire spi_sdo;

	caravel_clkrst clkrst(
	`ifdef LVS
		.vdd1v8(vdd1v8),
		.vss(vss),
	`endif		
		.ext_clk_sel(ext_clk_sel),
		.ext_clk(ext_clk),
		.pll_clk(pll_clk),
		.resetb(porb), 
		.ext_reset(ext_reset),
		.core_clk(core_clk),
		.resetb_sync(core_rstn)
	);

	// The following functions are connected to specific user project
	// area pins, when under control of the management area (during
	// startup, and when not otherwise programmed for the user project).

	// JTAG      = mgmt_io_data[0]       (inout)
	// SDO       = mgmt_io_data[1]       (output)	(shared with SPI master)
	// SDI       = mgmt_io_data[2]       (input)	(shared with SPI master)
	// CSB       = mgmt_io_data[3]       (input)	(shared with SPI master)
	// SCK       = mgmt_io_data[4]       (input)	(shared with SPI master)
	// ser_rx    = mgmt_io_data[5]       (input)
	// ser_tx    = mgmt_io_data[6]       (output)
	// irq       = mgmt_io_data[7]       (input)
	// flash_csb = mgmt_io_data[8]	     (output)	(user area flash)
	// flash_sck = mgmt_io_data[9]	     (output)	(user area flash)
	// flash_io0 = mgmt_io_data[10]	     (output)	(user area flash)
	// flash_io1 = mgmt_io_data[11]	     (input)	(user area flash)

	mgmt_soc soc (
    	    `ifdef LVS
        	.vdd1v8(vdd1v8),
        	.vss(vss),
    	    `endif
        	.pll_clk(pll_clk),
		.ext_clk(ext_clk),
		.ext_clk_sel(ext_clk_sel),
		.clk(core_clk),
		.resetn(core_rstn),
		.trap(trap),
		// GPIO
		.gpio_out_pad(gpio_out_pad),
		.gpio_in_pad(gpio_in_pad),
		.gpio_mode0_pad(gpio_mode0_pad),
		.gpio_mode1_pad(gpio_mode1_pad),
		.gpio_outenb_pad(gpio_outenb_pad),
		.gpio_inenb_pad(gpio_inenb_pad),
		// UART
		.ser_tx(mgmt_io_data[6]),
		.ser_rx(mgmt_io_data[5]),
		.irq_pin(mgmt_io_data[7]),
		.irq_spi(irq_spi),
		// SPI master
		.spi_csb(spi_csb),
		.spi_sck(spi_sck),
		.spi_sdi(spi_sdi),
		.spi_sdo(spi_sdo),
		// Flash
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_csb_oeb(flash_csb_oeb),
		.flash_clk_oeb(flash_clk_oeb),
		.flash_io0_oeb(flash_io0_oeb),
		.flash_io1_oeb(flash_io1_oeb),
		.flash_io2_oeb(flash_io2_oeb),
		.flash_io3_oeb(flash_io3_oeb),
		.flash_csb_ieb(flash_csb_ieb),
		.flash_clk_ieb(flash_clk_ieb),
		.flash_io0_ieb(flash_io0_ieb),
		.flash_io1_ieb(flash_io1_ieb),
		.flash_io2_ieb(flash_io2_ieb),
		.flash_io3_ieb(flash_io3_ieb),
		.flash_io0_do(flash_io0_do),
		.flash_io1_do(flash_io1_do),
		.flash_io2_do(flash_io2_do),
		.flash_io3_do(flash_io3_do),
		.flash_io0_di(flash_io0_di),
		.flash_io1_di(flash_io1_di),
		.flash_io2_di(flash_io2_di),
		.flash_io3_di(flash_io3_di),
		// SPI pass-through to/from SPI flash controller
		.pass_thru_mgmt(pass_thru_reset),
		.pass_thru_mgmt_csb(pass_thru_mgmt_csb),
		.pass_thru_mgmt_sck(pass_thru_mgmt_sck),
		.pass_thru_mgmt_sdi(pass_thru_mgmt_sdi),
		.pass_thru_mgmt_sdo(pass_thru_mgmt_sdo),
		// Logic Analyzer
		.la_input(la_input),
		.la_output(la_output),
		.la_oen(la_oen),
		// Mega-Project I/O Configuration
		.mprj_io_loader_resetn(mprj_io_loader_resetn),
		.mprj_io_loader_clock(mprj_io_loader_clock),
		.mprj_io_loader_data(mprj_io_loader_data),
		// I/O data
		.mgmt_io_data(mgmt_io_data),
		// Mega Project Slave ports (WB MI A)
		.mprj_cyc_o(mprj_cyc_o),
		.mprj_stb_o(mprj_stb_o),
		.mprj_we_o(mprj_we_o),
		.mprj_sel_o(mprj_sel_o),
		.mprj_adr_o(mprj_adr_o),
		.mprj_dat_o(mprj_dat_o),
		.mprj_ack_i(mprj_ack_i),
		.mprj_dat_i(mprj_dat_i),
		// Crossbar Switch
        	.xbar_cyc_o(xbar_cyc_o),
        	.xbar_stb_o(xbar_stb_o),
        	.xbar_we_o (xbar_we_o),
        	.xbar_sel_o(xbar_sel_o),
        	.xbar_adr_o(xbar_adr_o),
        	.xbar_dat_o(xbar_dat_o),
        	.xbar_ack_i(xbar_ack_i),
        	.xbar_dat_i(xbar_dat_i)
    	);
    
    	digital_pll pll (
	    `ifdef LVS
		.vdd(vdd1v8),
		.vss(vss),
	    `endif
		.resetb(porb),
		.extclk_sel(ext_clk_sel),
		.osc(clock),
		.clockc(pll_clk),
		.clockp({pll_clk_core0, pll_clk_core90}),
		.clockd({pll_clk2, pll_clk4, pll_clk8, pll_clk16}),
		.div(spi_pll_div),
		.sel(spi_pll_sel),
		.dco(spi_pll_dco_ena),
		.ext_trim(spi_pll_trim)
    	);


	// Housekeeping SPI vectors
	wire [4:0]  spi_pll_div;
	wire [2:0]  spi_pll_sel;
	wire [25:0] spi_pll_trim;

	// Housekeeping SPI (SPI slave module)
	caravel_spi housekeeping (
	    `ifdef LVS
		.vdd(vdd1v8),
		.vss(vss),
	    `endif
	    .RSTB(porb),
	    .SCK(mgmt_io_data[4]),
	    .SDI(mgmt_io_data[2]),
	    .CSB(mgmt_io_data[3]),
	    .SDO(mgmt_io_data[1]),
	     // Note that the Soc SPI master shares pins with the housekeeping
	     // SPI but with SDI and SDO reversed, such that the CPU can
	     // access the housekeeping SPI registers directly if the
	     // SPI master is enabled.
	    .mgmt_sck(mgmt_io_data[4]),
	    .mgmt_sdi(mgmt_io_data[1]),
	    .mgmt_csb(mgmt_io_data[3]),
	    .mgmt_sdo(mgmt_io_data[2]),
	     // NOTE:  SDO enable is not accessible in the current configuration.
	     // May want to have a different type of GPIO control for the several
	     // pins like SPI SDO that could benefit from it.
	    .sdo_enb(),
	    .pll_dco_ena(spi_pll_dco_ena),
	    .pll_sel(spi_pll_sel),
	    .pll_div(spi_pll_div),
            .pll_trim(spi_pll_trim),
	    .pll_bypass(ext_clk_sel),
	    .irq(irq_spi),
	    .reset(ext_reset),
	    .trap(trap),
	    .mask_rev_in(mask_rev),
    	    .pass_thru_reset(pass_thru_reset),
    	    .pass_thru_mgmt_sck(pass_thru_mgmt_sck),
    	    .pass_thru_mgmt_csb(pass_thru_mgmt_csb),
    	    .pass_thru_mgmt_sdi(pass_thru_mgmt_sdi),
    	    .pass_thru_mgmt_sdo(pass_thru_mgmt_sdo),
    	    .pass_thru_user_sck(mgmt_io_data[9]),
    	    .pass_thru_user_csb(mgmt_io_data[8]),
    	    .pass_thru_user_sdi(mgmt_io_data[10]),
    	    .pass_thru_user_sdo(mgmt_io_data[11])
	);

endmodule
