module mgmt_core(
`ifdef LVS
	inout vdd3v3,
	inout vdd1v8,	   
	inout vss,
`endif
	input ext_clk,
	output[ 15:0] gpio_out_pad,		// Connect to out on gpio pad
	input  [15:0] gpio_in_pad,		// Connect to in on gpio pad
	output [15:0] gpio_mode0_pad,		// Connect to dm[0] on gpio pad
	output [15:0] gpio_mode1_pad,		// Connect to dm[2] on gpio pad
	output [15:0] gpio_outenb_pad,		// Connect to oe_n on gpio pad
	output [15:0] gpio_inenb_pad,		// Connect to inp_dis on gpio pad
	input [7:0]   spi_ro_config,
	output ser_tx,
	input  ser_rx,
	// IRQ
	input  irq_pin,		        // dedicated IRQ pin
	// Flash memory control (SPI master)
	output flash_csb,
	output flash_clk,
	output flash_csb_oeb,
	output flash_clk_oeb,
	output flash_io0_oeb,
	output flash_io1_oeb,
	output flash_io2_oeb,
	output flash_io3_oeb,
	output flash_csb_ieb,
	output flash_clk_ieb,
	output flash_io0_ieb,
	output flash_io1_ieb,
	output flash_io2_ieb,
	output flash_io3_ieb,
	output flash_io0_do,
	output flash_io1_do,
	output flash_io2_do,
	output flash_io3_do,
	input flash_io0_di,
	input flash_io1_di,
	input flash_io2_di,
	input flash_io3_di,
	output por,
	input porb_l,
	input clock,
	output pll_clk16,
	input SDI_core,
	input CSB_core,
	output SDO_core,
	output SDO_enb,
	// LA signals
    	input  [127:0] la_input,           	// From Mega-Project to cpu
    	output [127:0] la_output,          	// From CPU to Mega-Project
    	output [127:0] la_oen,              // LA output enable  
	// Mega-Project Control Signals
	output [`MPRJ_IO_PADS-1:0] mprj_io_oeb_n,
    	output [`MPRJ_IO_PADS-1:0] mprj_io_hldh_n,
	output [`MPRJ_IO_PADS-1:0] mprj_io_enh,
    	output [`MPRJ_IO_PADS-1:0] mprj_io_inp_dis,
    	output [`MPRJ_IO_PADS-1:0] mprj_io_ib_mode_sel,
    	output [`MPRJ_IO_PADS-1:0] mprj_io_analog_en,
    	output [`MPRJ_IO_PADS-1:0] mprj_io_analog_sel,
    	output [`MPRJ_IO_PADS-1:0] mprj_io_analog_pol,
    	output [`MPRJ_IO_PADS*3-1:0] mprj_io_dm,
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

    	output striVe_clk,
    	output striVe_rstn
);
    	wire ext_clk_sel;
    	wire ext_clk;
    	wire pll_clk;
    	wire ext_reset;

	striVe_clkrst clkrst(
	`ifdef LVS
		.vdd1v8(vdd1v8),
		.vss(vss),
	`endif		
		.ext_clk_sel(ext_clk_sel),
		.ext_clk(ext_clk),
		.pll_clk(pll_clk),
		.reset(por), 
		.ext_reset(ext_reset),
		.clk(striVe_clk),
		.resetn(striVe_rstn)
	);

    	// SoC core
    	wire [9:0] adc0_data_core;
    	wire [1:0] adc0_inputsrc_core;
    	wire [9:0] adc1_data_core;
    	wire [1:0] adc1_inputsrc_core;
    	wire [9:0] dac_value_core;
    	wire [1:0] comp_ninputsrc_core;
    	wire [1:0] comp_pinputsrc_core;
    	wire [7:0] spi_ro_config_core;

    	// HKSPI 
	wire [11:0] spi_ro_mfgr_id;
    	wire [7:0] spi_ro_prod_id;
    	wire [3:0] spi_ro_mask_rev;
	wire [2:0] spi_ro_pll_sel;
    	wire [4:0] spi_ro_pll_div;
    	wire [25:0] spi_ro_pll_trim;

	mgmt_soc soc (
    	    `ifdef LVS
        	.vdd1v8(vdd1v8),
        	.vss(vss),
    	    `endif
        	.pll_clk(pll_clk),
		.ext_clk(ext_clk),
		.ext_clk_sel(ext_clk_sel),
		.clk(striVe_clk),
		.resetn(striVe_rstn),
		.gpio_out_pad(gpio_out_pad),
		.gpio_in_pad(gpio_in_pad),
		.gpio_mode0_pad(gpio_mode0_pad),
		.gpio_mode1_pad(gpio_mode1_pad),
		.gpio_outenb_pad(gpio_outenb_pad),
		.gpio_inenb_pad(gpio_inenb_pad),
		.spi_ro_config(spi_ro_config),
		.spi_ro_pll_dco_ena(spi_ro_pll_dco_ena),
		.spi_ro_pll_div(spi_ro_pll_div),
		.spi_ro_pll_sel(spi_ro_pll_sel),
		.spi_ro_pll_trim(spi_ro_pll_trim),
		.spi_ro_mfgr_id(spi_ro_mfgr_id),
		.spi_ro_prod_id(spi_ro_prod_id),
		.spi_ro_mask_rev(spi_ro_mask_rev),
		.ser_tx(ser_tx),
		.ser_rx(ser_rx),
		.irq_pin(irq_pin),
		.irq_spi(irq_spi),
		.trap(trap),
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
		// Logic Analyzer
		.la_input(la_input),
		.la_output(la_output),
		.la_oen(la_oen),
		// Mega-Project Control
		.mprj_io_oeb_n(mprj_io_oeb_n),
        	.mprj_io_hldh_n(mprj_io_hldh_n),
		.mprj_io_enh(mprj_io_enh),
        	.mprj_io_inp_dis(mprj_io_inp_dis),
        	.mprj_io_ib_mode_sel(mprj_io_ib_mode_sel),
        	.mprj_io_analog_en(mprj_io_analog_en),
        	.mprj_io_analog_sel(mprj_io_analog_sel),
        	.mprj_io_analog_pol(mprj_io_analog_pol),
        	.mprj_io_dm(mprj_io_dm),
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
		.reset(por),
		.extclk_sel(ext_clk_sel),
		.osc(xi),
		.clockc(pll_clk),
		.clockp({pll_clk_core0, pll_clk_core90}),
		.clockd({pll_clk2, pll_clk4, pll_clk8, pll_clk16}),
		.div(spi_ro_pll_div),
		.sel(spi_ro_pll_sel),
		.dco(spi_ro_pll_dco_ena),
		.ext_trim(spi_ro_pll_trim)
    	);

	// For the mask revision input, use an array of digital constant logic cells
	wire [3:0] mask_rev;
    	wire [3:0] no_connect;

    	scs8hd_conb_1 mask_rev_value [3:0] (
	    `ifdef LVS
        	.vpwr(vdd1v8),
        	.vpb(vdd1v8),
        	.vnb(vss),
        	.vgnd(vss),
	    `endif
        	.HI({no_connect[3:1], mask_rev[0]}),
        	.LO({mask_rev[3:1], no_connect[0]})
    	);

	// Housekeeping SPI at 3.3V.
    	striVe_spi housekeeping (
	    `ifdef LVS
		.vdd(vdd3v3),
		.vss(vss),
	    `endif
		.RSTB(porb_l),
		.SCK(spi_sck),
		.SDI(SDI_core),
		.CSB(CSB_core),
		.SDO(SDO_core),
		.sdo_enb(SDO_enb),
		.pll_dco_ena(spi_ro_pll_dco_ena),
		.pll_sel(spi_ro_pll_sel),
		.pll_div(spi_ro_pll_div),
        	.pll_trim(spi_ro_pll_trim),
		.pll_bypass(ext_clk_sel),
		.irq(irq_spi),
		.RST(por),
		.reset(ext_reset),
		.trap(trap),
        	.mfgr_id(spi_ro_mfgr_id),
		.prod_id(spi_ro_prod_id),
		.mask_rev_in(mask_rev),
		.mask_rev(spi_ro_mask_rev)
    	);

endmodule
