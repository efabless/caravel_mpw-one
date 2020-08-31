/*----------------------------------------------------------*/
/* striVe, a raven/ravenna-like architecture in SkyWater s8 */
/*                                                          */
/* 1st edition, test of SkyWater s8 process                 */
/* This version is missing all analog functionality,        */
/* including crystal oscillator, voltage regulator, and PLL */
/* For simplicity, the pad arrangement of Raven has been    */
/* retained, even though many pads have no internal         */
/* connection.                                              */
/*                                                          */
/* Copyright 2020 efabless, Inc.                            */
/* Written by Tim Edwards, December 2019                    */
/* This file is open source hardware released under the     */
/* Apache 2.0 license.  See file LICENSE.                   */
/*                                                          */
/*----------------------------------------------------------*/

`timescale 1 ns / 1 ps

`define USE_OPENRAM
`define USE_PG_PIN
`define functional

`define MPRJ_IO_PADS 32

`include "pads.v"

`include "/ef/tech/SW/EFS8A/libs.ref/verilog/s8iom0s8/s8iom0s8.v"
`include "/ef/tech/SW/EFS8A/libs.ref/verilog/s8iom0s8/power_pads_lib.v"
`include "/ef/tech/SW/EFS8A/libs.ref/verilog/scs8hd/scs8hd.v"

`include "lvlshiftdown.v"
`include "mgmt_soc.v"
`include "striVe_spi.v"
`include "digital_pll.v"
`include "striVe_clkrst.v"
`include "mprj_counter.v"
`include "mgmt_core.v"
`include "mprj_io.v"
`include "chip_io.v"

`ifdef USE_OPENRAM
    `include "sram_1rw1r_32_8192_8_sky130.v"
`endif

module harness_chip (
    inout vdd,
    inout vdd1v8,
    inout vss,
    inout [15:0] gpio,
	inout [`MPRJ_IO_PADS-1:0] mprj_io,
    input xi,		    // CMOS clock input, not a crystal
    output xo,		    // divide-by-16 clock output
    input adc0_in,
    input adc1_in,
    input adc_high,
    input adc_low,
    input comp_inn,
    input comp_inp,
    input RSTB,		    // NOTE:  Replaces analog_out pin from raven chip
    input ser_rx,
    output ser_tx,
    input irq,
    output SDO,
    input SDI,
    input CSB,
    input SCK,
    input xclk,
    output flash_csb,
    output flash_clk,
    output flash_io0,
    output flash_io1,
    output flash_io2,
    output flash_io3  
);

    wire [15:0] gpio_out_core;
    wire [15:0] gpio_in_core;
    wire [15:0]	gpio_mode0_core;
    wire [15:0]	gpio_mode1_core;
    wire [15:0]	gpio_outenb_core;
    wire [15:0]	gpio_inenb_core;

	// Mega-Project Control
	wire [`MPRJ_IO_PADS-1:0] mprj_io_oeb_n;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_hldh_n;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_enh;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_inp_dis;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_ib_mode_sel;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_analog_en;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_analog_sel;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_analog_pol;
    wire [`MPRJ_IO_PADS*3-1:0] mprj_io_dm;
	wire [`MPRJ_IO_PADS-1:0] mprj_io_in;
	wire [`MPRJ_IO_PADS-1:0] mprj_io_out;

    wire porb_h;
    wire porb_l;
    wire por;
    wire SCK_core;
    wire SDI_core;
    wire CSB_core;
    wire SDO_core;
    wire SDO_enb;

	chip_io padframe(
		// Package Pins
		.vdd(vdd),
		.vdd1v8(vdd1v8),
		.vss(vss),
		.gpio(gpio),
		.mprj_io(mprj_io),
		.xi(xi),
		.xo(xo),
		.adc0_in(adc0_in),
		.adc1_in(adc1_in),
		.adc_high(adc_high),
		.adc_low(adc_low),
		.comp_inn(comp_inn),
		.comp_inp(comp_inp),
		.RSTB(RSTB),
		.ser_rx(ser_rx),
		.ser_tx(ser_tx),
		.irq(irq),
		.SDO(SDO),
		.SDI(SDI),
		.CSB(CSB),
		.SCK(SCK),
		.xclk(xclk),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.flash_io2(flash_io2),
		.flash_io3(flash_io3),
		// SoC Core Interface
		.por(por),
		.porb_h(porb_h),
		.ext_clk_core(ext_clk_core),
		.xi_core(xi_core),
		.gpio_out_core(gpio_out_core),
		.gpio_in_core(gpio_in_core),
		.gpio_mode0_core(gpio_mode0_core),
		.gpio_mode1_core(gpio_mode1_core),
		.gpio_outenb_core(gpio_outenb_core),
		.gpio_inenb_core(gpio_inenb_core),
		.SCK_core(SCK_core),
		.ser_rx_core(ser_rx_core),
		.ser_tx_core(ser_tx_core),
		.irq_pin_core(irq_pin_core),
		.flash_csb_core(flash_csb_core),
		.flash_clk_core(flash_clk_core),
		.flash_csb_oeb_core(flash_csb_oeb_core),
		.flash_clk_oeb_core(flash_clk_oeb_core),
		.flash_io0_oeb_core(flash_io0_oeb_core),
		.flash_io1_oeb_core(flash_io1_oeb_core),
		.flash_io2_oeb_core(flash_io2_oeb_core),
		.flash_io3_oeb_core(flash_io3_oeb_core),
		.flash_csb_ieb_core(flash_csb_ieb_core),
		.flash_clk_ieb_core(flash_clk_ieb_core),
		.flash_io0_ieb_core(flash_io0_ieb_core),
		.flash_io1_ieb_core(flash_io1_ieb_core),
		.flash_io2_ieb_core(flash_io2_ieb_core),
		.flash_io3_ieb_core(flash_io3_ieb_core),
		.flash_io0_do_core(flash_io0_do_core),
		.flash_io1_do_core(flash_io1_do_core),
		.flash_io2_do_core(flash_io2_do_core),
		.flash_io3_do_core(flash_io3_do_core),
		.flash_io0_di_core(flash_io0_di_core),
		.flash_io1_di_core(flash_io1_di_core),
		.flash_io2_di_core(flash_io2_di_core),
		.flash_io3_di_core(flash_io3_di_core),
		.SDI_core(SDI_core),
		.CSB_core(CSB_core),
		.pll_clk16(pll_clk16),
		.SDO_core(SDO_core),
		.mprj_io_in(mprj_io_in),
		.mprj_io_out(mprj_io_out),
		.mprj_io_oeb_n(mprj_io_oeb_n),
        .mprj_io_hldh_n(mprj_io_hldh_n),
		.mprj_io_enh(mprj_io_enh),
        .mprj_io_inp_dis(mprj_io_inp_dis),
        .mprj_io_ib_mode_sel(mprj_io_ib_mode_sel),
        .mprj_io_analog_en(mprj_io_analog_en),
        .mprj_io_analog_sel(mprj_io_analog_sel),
        .mprj_io_analog_pol(mprj_io_analog_pol),
        .mprj_io_dm(mprj_io_dm)
	);

    // SoC core
    wire striVe_clk;
    wire striVe_rstn;

    wire [9:0] adc0_data_core;
    wire [1:0] adc0_inputsrc_core;
    wire [9:0] adc1_data_core;
    wire [1:0] adc1_inputsrc_core;
    wire [9:0] dac_value_core;
    wire [1:0] comp_ninputsrc_core;
    wire [1:0] comp_pinputsrc_core;
    wire [7:0] spi_ro_config_core;

	// LA signals
    wire [127:0] la_output_core;     // From CPU to MPRJ
	wire [127:0] la_data_in_mprj;	// From CPU to MPRJ
	wire [127:0] la_data_out_mprj;		 // From CPU to MPRJ
	wire [127:0] la_output_mprj;	 // From MPRJ to CPU
    wire [127:0] la_oen;              // LA output enable from CPU perspective (active-low) 
	
	// WB MI A (Mega Project)
	wire mprj_cyc_o_core;
	wire mprj_stb_o_core;
	wire mprj_we_o_core;
	wire [3:0] mprj_sel_o_core;
	wire [31:0] mprj_adr_o_core;
	wire [31:0] mprj_dat_o_core;
	wire mprj_ack_i_core;
	wire [31:0] mprj_dat_i_core;

	// WB MI B (xbar)
    wire xbar_cyc_o_core;
    wire xbar_stb_o_core;
    wire xbar_we_o_core;
    wire [3:0] xbar_sel_o_core;
    wire [31:0] xbar_adr_o_core;
    wire [31:0] xbar_dat_o_core;
    wire xbar_ack_i_core;
    wire [31:0] xbar_dat_i_core;

    mgmt_core soc (
	`ifdef LVS
		.vdd1v8(vdd1v8),
		.vss(vss),
	`endif
		.ext_clk(ext_clk_core),
		.gpio_out_pad(gpio_out_core),
		.gpio_in_pad(gpio_in_core),
		.gpio_mode0_pad(gpio_mode0_core),
		.gpio_mode1_pad(gpio_mode1_core),
		.gpio_outenb_pad(gpio_outenb_core),
		.gpio_inenb_pad(gpio_inenb_core),
		.adc0_ena(adc0_ena_core),
		.adc0_convert(adc0_convert_core),
		.adc0_data(adc0_data_core),
		.adc0_done(adc0_done_core),
		.adc0_clk(adc0_clk_core),
		.adc0_inputsrc(adc0_inputsrc_core),
		.adc1_ena(adc1_ena_core),
		.adc1_convert(adc1_convert_core),
		.adc1_clk(adc1_clk_core),
		.adc1_inputsrc(adc1_inputsrc_core),
		.adc1_data(adc1_data_core),
		.adc1_done(adc1_done_core),
		.dac_ena(dac_ena_core),
		.dac_value(dac_value_core),
		.analog_out_sel(analog_out_sel_core),
		.opamp_ena(opamp_ena_core),
		.opamp_bias_ena(opamp_bias_ena_core),
		.bg_ena(bg_ena_core),
		.comp_ena(comp_ena_core),
		.comp_ninputsrc(comp_ninputsrc_core),
		.comp_pinputsrc(comp_pinputsrc_core),
		.rcosc_ena(rcosc_ena_core),
		.overtemp_ena(overtemp_ena_core),
		.overtemp(overtemp_core),
		.rcosc_in(rcosc_in_core),
		.xtal_in(xtal_in_core),
		.comp_in(comp_in_core),
		.spi_sck(SCK_core),
		.spi_ro_config(spi_ro_config_core),
		.ser_tx(ser_tx_core),
		.ser_rx(ser_rx_core),
		.irq_pin(irq_pin_core),
		.flash_csb(flash_csb_core),
		.flash_clk(flash_clk_core),
		.flash_csb_oeb(flash_csb_oeb_core),
		.flash_clk_oeb(flash_clk_oeb_core),
		.flash_io0_oeb(flash_io0_oeb_core),
		.flash_io1_oeb(flash_io1_oeb_core),
		.flash_io2_oeb(flash_io2_oeb_core),
		.flash_io3_oeb(flash_io3_oeb_core),
		.flash_csb_ieb(flash_csb_ieb_core),
		.flash_clk_ieb(flash_clk_ieb_core),
		.flash_io0_ieb(flash_io0_ieb_core),
		.flash_io1_ieb(flash_io1_ieb_core),
		.flash_io2_ieb(flash_io2_ieb_core),
		.flash_io3_ieb(flash_io3_ieb_core),
		.flash_io0_do(flash_io0_do_core),
		.flash_io1_do(flash_io1_do_core),
		.flash_io2_do(flash_io2_do_core),
		.flash_io3_do(flash_io3_do_core),
		.flash_io0_di(flash_io0_di_core),
		.flash_io1_di(flash_io1_di_core),
		.flash_io2_di(flash_io2_di_core),
		.flash_io3_di(flash_io3_di_core),
		.por(por),
		.porb_l(porb_l),
		.xi(xi_core),
		.pll_clk16(pll_clk16),
		.SDI_core(SDI_core),
		.CSB_core(CSB_core),
		.SDO_core(SDO_core),
		.SDO_enb(SDO_enb),
        .striVe_clk(striVe_clk),
        .striVe_rstn(striVe_rstn),
		// Logic Analyzer 
		.la_input(la_data_out_mprj),
		.la_output(la_output_core),
		.la_oen(la_oen),
		// Mega Project IO Control
		.mprj_io_oeb_n(mprj_io_oeb_n),
		.mprj_io_enh(mprj_io_enh),
        .mprj_io_hldh_n(mprj_io_hldh_n),
        .mprj_io_inp_dis(mprj_io_inp_dis),
        .mprj_io_ib_mode_sel(mprj_io_ib_mode_sel),
        .mprj_io_analog_en(mprj_io_analog_en),
        .mprj_io_analog_sel(mprj_io_analog_sel),
        .mprj_io_analog_pol(mprj_io_analog_pol),
        .mprj_io_dm(mprj_io_dm),
		// Mega Project Slave ports (WB MI A)
		.mprj_cyc_o(mprj_cyc_o_core),
		.mprj_stb_o(mprj_stb_o_core),
		.mprj_we_o(mprj_we_o_core),
		.mprj_sel_o(mprj_sel_o_core),
		.mprj_adr_o(mprj_adr_o_core),
		.mprj_dat_o(mprj_dat_o_core),
		.mprj_ack_i(mprj_ack_i_core),
		.mprj_dat_i(mprj_dat_i_core),
		// Xbar Switch (WB MI B)
        .xbar_cyc_o(xbar_cyc_o_core),
        .xbar_stb_o(xbar_stb_o_core),
        .xbar_we_o (xbar_we_o_core),
        .xbar_sel_o(xbar_sel_o_core),
        .xbar_adr_o(xbar_adr_o_core),
        .xbar_dat_o(xbar_dat_o_core),
        .xbar_ack_i(xbar_ack_i_core),
        .xbar_dat_i(xbar_dat_i_core)
    );

	scs8hd_ebufn_8 la_buf[127:0](
		.Z(la_data_in_mprj),
		.A(la_output_core),
		.TEB(la_oen)
	);
	
	mega_project mprj ( 
    	.wb_clk_i(striVe_clk),
    	.wb_rst_i(!striVe_rstn),
		// MGMT SoC Wishbone Slave 
		.wbs_cyc_i(mprj_cyc_o_core),
		.wbs_stb_i(mprj_stb_o_core),
		.wbs_we_i(mprj_we_o_core),
		.wbs_sel_i(mprj_sel_o_core),
	    .wbs_adr_i(mprj_adr_o_core),
		.wbs_dat_i(mprj_dat_o_core),
	    .wbs_ack_o(mprj_ack_i_core),
		.wbs_dat_o(mprj_dat_i_core),
		// Logic Analyzer
		.la_data_in(la_data_in_mprj),
		.la_data_out(la_data_out_mprj),
		.la_oen (la_oen),
		// IO Pads
    	.io_out(mprj_io_out),
		.io_in (mprj_io_in)
	);

    lvlshiftdown porb_level_shift (
	`ifdef LVS
		.vpwr(vdd1v8),
		.vpb(vdd1v8),
		.vnb(vss),
		.vgnd(vss),
	`endif
		.A(porb_h),
		.X(porb_l)
    );

endmodule
