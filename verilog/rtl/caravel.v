// `default_nettype none
// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
/*--------------------------------------------------------------*/
/* caravel, a project harness for the Google/SkyWater sky130	*/
/* fabrication process and open source PDK			*/
/*                                                          	*/
/* Copyright 2020 efabless, Inc.                            	*/
/* Written by Tim Edwards, December 2019                    	*/
/* and Mohamed Shalan, August 2020			    	*/
/* This file is open source hardware released under the     	*/
/* Apache 2.0 license.  See file LICENSE.                   	*/
/*                                                          	*/
/*--------------------------------------------------------------*/

`timescale 1 ns / 1 ps

`define UNIT_DELAY #1

`ifdef SIM

`define USE_POWER_PINS

`include "defines.v"
`include "pads.v"

/* NOTE: Need to pass the PDK root directory to iverilog with option -I */

`include "libs.ref/sky130_fd_io/verilog/sky130_fd_io.v"
`include "libs.ref/sky130_fd_io/verilog/sky130_ef_io.v"
`include "libs.ref/sky130_fd_io/verilog/sky130_ef_io__gpiov2_pad_wrapped.v"

`include "libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
`include "libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"
`include "libs.ref/sky130_fd_sc_hvl/verilog/primitives.v"
`include "libs.ref/sky130_fd_sc_hvl/verilog/sky130_fd_sc_hvl.v"

`ifdef GL
	`include "gl/mgmt_core.v"
	`include "gl/digital_pll.v"
	`include "gl/DFFRAM.v"
	`include "gl/storage.v"
	`include "gl/user_id_programming.v"
	`include "gl/chip_io.v"
`else
	`include "mgmt_soc.v"
	`include "housekeeping_spi.v"
	`include "caravel_clocking.v"
	`include "mgmt_core.v"
	`include "digital_pll.v"
	`include "DFFRAM.v"
	`include "DFFRAMBB.v"
	`include "storage.v"
	`include "user_id_programming.v"
	`include "clock_div.v"
	`include "storage_bridge_wb.v"
	`include "mprj_io.v"
	`include "chip_io.v"
`endif

`include "mprj_logic_high.v"
`include "mprj2_logic_high.v"
`include "sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.v"
`include "mgmt_protect.v"
`include "mgmt_protect_hv.v"
`include "user_project_wrapper.v"
`include "gpio_control_block.v"
`include "simple_por.v"
`include "sram_1rw1r_32_256_8_sky130.v"

/*------------------------------*/
/* Include user project here	*/
/*------------------------------*/
`include "user_proj_example.v"

// `ifdef USE_OPENRAM
//     `include "sram_1rw1r_32_256_8_sky130.v"
// `endif
`endif

module caravel (
    inout vddio,	// Common 3.3V padframe/ESD power
    inout vssio,	// Common padframe/ESD ground
    inout vdda,		// Management 3.3V power
    inout vssa,		// Common analog ground
    inout vccd,		// Management/Common 1.8V power
    inout vssd,		// Common digital ground
    inout vdda1,	// User area 1 3.3V power
    inout vdda2,	// User area 2 3.3V power
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V power
    inout vccd2,	// User area 2 1.8V power
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground

    inout gpio,			// Used for external LDO control
    inout [`MPRJ_IO_PADS-1:0] mprj_io,
    output [`MPRJ_PWR_PADS-1:0] pwr_ctrl_out,
    input clock,	    	// CMOS core clock input, not a crystal
    input resetb,

    // Note that only two pins are available on the flash so dual and
    // quad flash modes are not available.

    output flash_csb,
    output flash_clk,
    output flash_io0,
    output flash_io1
);

    //------------------------------------------------------------
    // This value is uniquely defined for each user project.
    //------------------------------------------------------------
    parameter USER_PROJECT_ID = 32'h0;

    // These pins are overlaid on mprj_io space.  They have the function
    // below when the management processor is in reset, or in the default
    // configuration.  They are assigned to uses in the user space by the
    // configuration program running off of the SPI flash.  Note that even
    // when the user has taken control of these pins, they can be restored
    // to the original use by setting the resetb pin low.  The SPI pins and
    // UART pins can be connected directly to an FTDI chip as long as the
    // FTDI chip sets these lines to high impedence (input function) at
    // all times except when holding the chip in reset.

    // JTAG      = mprj_io[0]		(inout)
    // SDO 	 = mprj_io[1]		(output)
    // SDI 	 = mprj_io[2]		(input)
    // CSB 	 = mprj_io[3]		(input)
    // SCK	 = mprj_io[4]		(input)
    // ser_rx    = mprj_io[5]		(input)
    // ser_tx    = mprj_io[6]		(output)
    // irq 	 = mprj_io[7]		(input)

    // These pins are reserved for any project that wants to incorporate
    // its own processor and flash controller.  While a user project can
    // technically use any available I/O pins for the purpose, these
    // four pins connect to a pass-through mode from the SPI slave (pins
    // 1-4 above) so that any SPI flash connected to these specific pins
    // can be accessed through the SPI slave even when the processor is in
    // reset.

    // user_flash_csb = mprj_io[8]
    // user_flash_sck = mprj_io[9]
    // user_flash_io0 = mprj_io[10]
    // user_flash_io1 = mprj_io[11]

    // One-bit GPIO dedicated to management SoC (outside of user control)
    wire gpio_out_core;
    wire gpio_in_core;
    wire gpio_mode0_core;
    wire gpio_mode1_core;
    wire gpio_outenb_core;
    wire gpio_inenb_core;

    // User Project Control (pad-facing)
    wire mprj_io_loader_resetn;
    wire mprj_io_loader_clock;
    wire mprj_io_loader_data;

    wire [`MPRJ_IO_PADS-1:0] mprj_io_hldh_n;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_enh;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_inp_dis;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_oeb;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_ib_mode_sel;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_vtrip_sel;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_slow_sel;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_holdover;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_analog_en;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_analog_sel;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_analog_pol;
    wire [`MPRJ_IO_PADS*3-1:0] mprj_io_dm;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_in;
    wire [`MPRJ_IO_PADS-1:0] mprj_io_out;

    // User Project Control (user-facing)
    wire [`MPRJ_IO_PADS-1:0] user_io_oeb;
    wire [`MPRJ_IO_PADS-1:0] user_io_in;
    wire [`MPRJ_IO_PADS-1:0] user_io_out;
    wire [`MPRJ_IO_PADS-8:0] user_analog_io;

    /* Padframe control signals */
    wire [`MPRJ_IO_PADS-1:0] gpio_serial_link;
    wire mgmt_serial_clock;
    wire mgmt_serial_resetn;

    // User Project Control management I/O
    // There are two types of GPIO connections:
    // (1) Full Bidirectional: Management connects to in, out, and oeb
    //     Uses:  JTAG and SDO
    // (2) Selectable bidirectional:  Management connects to in and out,
    //	   which are tied together.  oeb is grounded (oeb from the
    //	   configuration is used)

    // SDI 	 = mprj_io[2]		(input)
    // CSB 	 = mprj_io[3]		(input)
    // SCK	 = mprj_io[4]		(input)
    // ser_rx    = mprj_io[5]		(input)
    // ser_tx    = mprj_io[6]		(output)
    // irq 	 = mprj_io[7]		(input)

    wire [`MPRJ_IO_PADS-1:0] mgmt_io_in;
    wire jtag_out, sdo_out;
    wire jtag_outenb, sdo_outenb;

    wire [`MPRJ_IO_PADS-3:0] mgmt_io_nc1;	/* no-connects */
    wire [`MPRJ_IO_PADS-3:0] mgmt_io_nc3;	/* no-connects */
    wire [1:0] mgmt_io_nc2;			/* no-connects */

    wire clock_core;

    // Power-on-reset signal.  The reset pad generates the sense-inverted
    // reset at 3.3V.  The 1.8V signal and the inverted 1.8V signal are
    // derived.

    wire porb_h;
    wire porb_l;
    wire por_l;

    wire rstb_h;
    wire rstb_l;

    wire flash_clk_core,     flash_csb_core;
    wire flash_clk_oeb_core, flash_csb_oeb_core;
    wire flash_clk_ieb_core, flash_csb_ieb_core;
    wire flash_io0_oeb_core, flash_io1_oeb_core;
    wire flash_io2_oeb_core, flash_io3_oeb_core;
    wire flash_io0_ieb_core, flash_io1_ieb_core;
    wire flash_io2_ieb_core, flash_io3_ieb_core;
    wire flash_io0_do_core,  flash_io1_do_core;
    wire flash_io2_do_core,  flash_io3_do_core;
    wire flash_io0_di_core,  flash_io1_di_core;
    wire flash_io2_di_core,  flash_io3_di_core;

    // To be considered:  Master hold signal on all user pads (?)
    // For now, set holdh_n to 1 (NOTE:  This is in the 3.3V domain)
    // and setting enh to porb_h.
    assign mprj_io_hldh_n = {`MPRJ_IO_PADS{vddio}};
    assign mprj_io_enh = {`MPRJ_IO_PADS{porb_h}};

    chip_io padframe(
	// Package Pins
	.vddio(vddio),
	.vssio(vssio),
	.vdda(vdda),
	.vssa(vssa),
	.vccd(vccd),
	.vssd(vssd),
	.vdda1(vdda1),
	.vdda2(vdda2),
	.vssa1(vssa1),
	.vssa2(vssa2),
	.vccd1(vccd1),
	.vccd2(vccd2),
	.vssd1(vssd1),
	.vssd2(vssd2),

	.gpio(gpio),
	.mprj_io(mprj_io),
	.clock(clock),
	.resetb(resetb),
	.flash_csb(flash_csb),
	.flash_clk(flash_clk),
	.flash_io0(flash_io0),
	.flash_io1(flash_io1),
	// SoC Core Interface
	.porb_h(porb_h),
	.por(por_l),
	.resetb_core_h(rstb_h),
	.clock_core(clock_core),
	.gpio_out_core(gpio_out_core),
	.gpio_in_core(gpio_in_core),
	.gpio_mode0_core(gpio_mode0_core),
	.gpio_mode1_core(gpio_mode1_core),
	.gpio_outenb_core(gpio_outenb_core),
	.gpio_inenb_core(gpio_inenb_core),
	.flash_csb_core(flash_csb_core),
	.flash_clk_core(flash_clk_core),
	.flash_csb_oeb_core(flash_csb_oeb_core),
	.flash_clk_oeb_core(flash_clk_oeb_core),
	.flash_io0_oeb_core(flash_io0_oeb_core),
	.flash_io1_oeb_core(flash_io1_oeb_core),
	.flash_csb_ieb_core(flash_csb_ieb_core),
	.flash_clk_ieb_core(flash_clk_ieb_core),
	.flash_io0_ieb_core(flash_io0_ieb_core),
	.flash_io1_ieb_core(flash_io1_ieb_core),
	.flash_io0_do_core(flash_io0_do_core),
	.flash_io1_do_core(flash_io1_do_core),
	.flash_io0_di_core(flash_io0_di_core),
	.flash_io1_di_core(flash_io1_di_core),
	.mprj_io_in(mprj_io_in),
	.mprj_io_out(mprj_io_out),
	.mprj_io_oeb(mprj_io_oeb),
	.mprj_io_hldh_n(mprj_io_hldh_n),
	.mprj_io_enh(mprj_io_enh),
	.mprj_io_inp_dis(mprj_io_inp_dis),
	.mprj_io_ib_mode_sel(mprj_io_ib_mode_sel),
	.mprj_io_vtrip_sel(mprj_io_vtrip_sel),
	.mprj_io_slow_sel(mprj_io_slow_sel),
	.mprj_io_holdover(mprj_io_holdover),
	.mprj_io_analog_en(mprj_io_analog_en),
	.mprj_io_analog_sel(mprj_io_analog_sel),
	.mprj_io_analog_pol(mprj_io_analog_pol),
	.mprj_io_dm(mprj_io_dm),
	.mprj_analog_io(user_analog_io)
    );

    // SoC core
    wire caravel_clk;
    wire caravel_clk2;
    wire caravel_rstn;

    wire [7:0] spi_ro_config_core;

    // LA signals
    wire [127:0] la_data_in_user;  // From CPU to MPRJ
    wire [127:0] la_data_in_mprj;  // From MPRJ to CPU
    wire [127:0] la_data_out_mprj; // From CPU to MPRJ
    wire [127:0] la_data_out_user; // From MPRJ to CPU
    wire [127:0] la_oen_user;      // From CPU to MPRJ
    wire [127:0] la_oen_mprj;	   // From CPU to MPRJ

    // WB MI A (User Project)
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

    // Mask revision
    wire [31:0] mask_rev;

	wire 	    mprj_clock;
	wire 	    mprj_clock2;
	wire 	    mprj_resetn;
	wire 	    mprj_reset;
	wire 	    mprj_cyc_o_user;
	wire 	    mprj_stb_o_user;
	wire 	    mprj_we_o_user;
	wire [3:0]  mprj_sel_o_user;
	wire [31:0] mprj_adr_o_user;
	wire [31:0] mprj_dat_o_user;
	wire	    mprj_vcc_pwrgood;
	wire	    mprj2_vcc_pwrgood;
	wire	    mprj_vdd_pwrgood;
	wire	    mprj2_vdd_pwrgood;

	// Storage area
	// Management R/W interface
	wire [`RAM_BLOCKS-1:0] mgmt_ena;
    wire [`RAM_BLOCKS-1:0] mgmt_wen;
    wire [(`RAM_BLOCKS*4)-1:0] mgmt_wen_mask;
    wire [7:0] mgmt_addr;
    wire [31:0] mgmt_wdata;
    wire [(`RAM_BLOCKS*32)-1:0] mgmt_rdata;
	// Management RO interface
	wire mgmt_ena_ro;
    wire [7:0] mgmt_addr_ro;
    wire [31:0] mgmt_rdata_ro;

    mgmt_core soc (
	`ifdef USE_POWER_PINS
		.VPWR(vccd),
		.VGND(vssa),
	`endif
		// GPIO (1 pin)
		.gpio_out_pad(gpio_out_core),
		.gpio_in_pad(gpio_in_core),
		.gpio_mode0_pad(gpio_mode0_core),
		.gpio_mode1_pad(gpio_mode1_core),
		.gpio_outenb_pad(gpio_outenb_core),
		.gpio_inenb_pad(gpio_inenb_core),
		// Primary SPI flash controller
		.flash_csb(flash_csb_core),
		.flash_clk(flash_clk_core),
		.flash_csb_oeb(flash_csb_oeb_core),
		.flash_clk_oeb(flash_clk_oeb_core),
		.flash_io0_oeb(flash_io0_oeb_core),
		.flash_io1_oeb(flash_io1_oeb_core),
		.flash_csb_ieb(flash_csb_ieb_core),
		.flash_clk_ieb(flash_clk_ieb_core),
		.flash_io0_ieb(flash_io0_ieb_core),
		.flash_io1_ieb(flash_io1_ieb_core),
		.flash_io0_do(flash_io0_do_core),
		.flash_io1_do(flash_io1_do_core),
		.flash_io0_di(flash_io0_di_core),
		.flash_io1_di(flash_io1_di_core),
		// Master Reset
		.resetb(rstb_l),
		.porb(porb_l),
		// Clocks and reset
		.clock(clock_core),
        	.core_clk(caravel_clk),
        	.user_clk(caravel_clk2),
        	.core_rstn(caravel_rstn),
		// Logic Analyzer
		.la_input(la_data_in_mprj),
		.la_output(la_data_out_mprj),
		.la_oen(la_oen_mprj),
		// User Project IO Control
		.mprj_vcc_pwrgood(mprj_vcc_pwrgood),
		.mprj2_vcc_pwrgood(mprj2_vcc_pwrgood),
		.mprj_vdd_pwrgood(mprj_vdd_pwrgood),
		.mprj2_vdd_pwrgood(mprj2_vdd_pwrgood),
		.mprj_io_loader_resetn(mprj_io_loader_resetn),
		.mprj_io_loader_clock(mprj_io_loader_clock),
		.mprj_io_loader_data(mprj_io_loader_data),
		.mgmt_in_data(mgmt_io_in),
		.mgmt_out_data({mgmt_io_in[(`MPRJ_IO_PADS-1):2], mgmt_io_nc2}),
		.pwr_ctrl_out(pwr_ctrl_out),
		.sdo_out(sdo_out),
		.sdo_outenb(sdo_outenb),
		.jtag_out(jtag_out),
		.jtag_outenb(jtag_outenb),
		// User Project Slave ports (WB MI A)
		.mprj_cyc_o(mprj_cyc_o_core),
		.mprj_stb_o(mprj_stb_o_core),
		.mprj_we_o(mprj_we_o_core),
		.mprj_sel_o(mprj_sel_o_core),
		.mprj_adr_o(mprj_adr_o_core),
		.mprj_dat_o(mprj_dat_o_core),
		.mprj_ack_i(mprj_ack_i_core),
		.mprj_dat_i(mprj_dat_i_core),
		// mask data
		.mask_rev(mask_rev),
		// MGMT area R/W interface
    	.mgmt_ena(mgmt_ena),
    	.mgmt_wen_mask(mgmt_wen_mask),
    	.mgmt_wen(mgmt_wen),
    	.mgmt_addr(mgmt_addr),
    	.mgmt_wdata(mgmt_wdata),
    	.mgmt_rdata(mgmt_rdata),
    	// MGMT area RO interface
    	.mgmt_ena_ro(mgmt_ena_ro),
    	.mgmt_addr_ro(mgmt_addr_ro),
    	.mgmt_rdata_ro(mgmt_rdata_ro)
    	);

	/* Clock and reset to user space are passed through a tristate	*/
	/* buffer like the above, but since they are intended to be	*/
	/* always active, connect the enable to the logic-1 output from	*/
	/* the vccd1 domain.						*/

	mgmt_protect mgmt_buffers (
	`ifdef USE_POWER_PINS
		.vccd(vccd),
		.vssd(vssd),
		.vccd1(vccd1),
		.vssd1(vssd1),
		.vdda1(vdda1),
		.vssa1(vssa1),
		.vdda2(vdda2),
		.vssa2(vssa2),
        `endif

		.caravel_clk(caravel_clk),
		.caravel_clk2(caravel_clk2),
		.caravel_rstn(caravel_rstn),
		.mprj_cyc_o_core(mprj_cyc_o_core),
		.mprj_stb_o_core(mprj_stb_o_core),
		.mprj_we_o_core(mprj_we_o_core),
		.mprj_sel_o_core(mprj_sel_o_core),
		.mprj_adr_o_core(mprj_adr_o_core),
		.mprj_dat_o_core(mprj_dat_o_core),
		.la_data_out_core(la_data_out_user),
		.la_data_out_mprj(la_data_out_mprj),
		.la_data_in_core(la_data_in_user),
		.la_data_in_mprj(la_data_in_mprj),
		.la_oen_mprj(la_oen_mprj),
		.la_oen_core(la_oen_user),

		.user_clock(mprj_clock),
		.user_clock2(mprj_clock2),
		.user_resetn(mprj_resetn),
		.user_reset(mprj_reset),
		.mprj_cyc_o_user(mprj_cyc_o_user),
		.mprj_stb_o_user(mprj_stb_o_user),
		.mprj_we_o_user(mprj_we_o_user),
		.mprj_sel_o_user(mprj_sel_o_user),
		.mprj_adr_o_user(mprj_adr_o_user),
		.mprj_dat_o_user(mprj_dat_o_user),
		.user1_vcc_powergood(mprj_vcc_pwrgood),
		.user2_vcc_powergood(mprj2_vcc_pwrgood),
		.user1_vdd_powergood(mprj_vdd_pwrgood),
		.user2_vdd_powergood(mprj2_vdd_pwrgood)
	);


	/*----------------------------------------------*/
	/* Wrapper module around the user project 	*/
	/*----------------------------------------------*/

	user_project_wrapper mprj ( 
	`ifdef USE_POWER_PINS
		.vdda1(vdda1),	// User area 1 3.3V power
		.vdda2(vdda2),	// User area 2 3.3V power
		.vssa1(vssa1),	// User area 1 analog ground
		.vssa2(vssa2),	// User area 2 analog ground
		.vccd1(vccd1),	// User area 1 1.8V power
		.vccd2(vccd2),	// User area 2 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
		.vssd2(vssd2),	// User area 2 digital ground
        `endif

    		.wb_clk_i(mprj_clock),
    		.wb_rst_i(mprj_reset),
		// MGMT SoC Wishbone Slave
		.wbs_cyc_i(mprj_cyc_o_user),
		.wbs_stb_i(mprj_stb_o_user),
		.wbs_we_i(mprj_we_o_user),
		.wbs_sel_i(mprj_sel_o_user),
	    	.wbs_adr_i(mprj_adr_o_user),
		.wbs_dat_i(mprj_dat_o_user),
	    	.wbs_ack_o(mprj_ack_i_core),
		.wbs_dat_o(mprj_dat_i_core),
		// Logic Analyzer
		.la_data_in(la_data_in_user),
		.la_data_out(la_data_out_user),
		.la_oen(la_oen_user),
		// IO Pads
		.io_in (user_io_in),
    		.io_out(user_io_out),
    		.io_oeb(user_io_oeb),
		.analog_io(user_analog_io),
		// Independent clock
		.user_clock2(mprj_clock2)
	);

	/*--------------------------------------*/
	/* End user project instantiation	*/
	/*--------------------------------------*/

    wire [`MPRJ_IO_PADS-1:0] gpio_serial_link_shifted;

    assign gpio_serial_link_shifted = {gpio_serial_link[`MPRJ_IO_PADS-2:0], mprj_io_loader_data};

    // Each control block sits next to an I/O pad in the user area.
    // It gets input through a serial chain from the previous control
    // block and passes it to the next control block.  Due to the nature
    // of the shift register, bits are presented in reverse, as the first
    // bit in ends up as the last bit of the last I/O pad control block.

    // There are two types of block;  the first two are configured to be
    // full bidirectional under control of the management Soc (JTAG and
    // SDO).  The rest are configured to be default (input).

    gpio_control_block #(
	.DM_INIT(`DM_INIT),	// Mode = output, strong up/down
	.OENB_INIT(`OENB_INIT)	// Enable output signaling from wire
    ) gpio_control_bidir [1:0] (
    	`ifdef USE_POWER_PINS
			.vccd(vccd),
			.vssd(vssd),
			.vccd1(vccd1),
			.vssd1(vssd1),
        `endif

    	// Management Soc-facing signals

    	.resetn(mprj_io_loader_resetn),
    	.serial_clock(mprj_io_loader_clock),

    	.mgmt_gpio_in(mgmt_io_in[1:0]),
	.mgmt_gpio_out({sdo_out, jtag_out}),
	.mgmt_gpio_oeb({sdo_outenb, jtag_outenb}),

        .one(),
        .zero(),

    	// Serial data chain for pad configuration
    	.serial_data_in(gpio_serial_link_shifted[1:0]),
    	.serial_data_out(gpio_serial_link[1:0]),

    	// User-facing signals
    	.user_gpio_out(user_io_out[1:0]),
    	.user_gpio_oeb(user_io_oeb[1:0]),
    	.user_gpio_in(user_io_in[1:0]),

    	// Pad-facing signals (Pad GPIOv2)
    	.pad_gpio_inenb(mprj_io_inp_dis[1:0]),
    	.pad_gpio_ib_mode_sel(mprj_io_ib_mode_sel[1:0]),
    	.pad_gpio_vtrip_sel(mprj_io_vtrip_sel[1:0]),
    	.pad_gpio_slow_sel(mprj_io_slow_sel[1:0]),
    	.pad_gpio_holdover(mprj_io_holdover[1:0]),
    	.pad_gpio_ana_en(mprj_io_analog_en[1:0]),
    	.pad_gpio_ana_sel(mprj_io_analog_sel[1:0]),
    	.pad_gpio_ana_pol(mprj_io_analog_pol[1:0]),
    	.pad_gpio_dm(mprj_io_dm[5:0]),
    	.pad_gpio_outenb(mprj_io_oeb[1:0]),
    	.pad_gpio_out(mprj_io_out[1:0]),
    	.pad_gpio_in(mprj_io_in[1:0])
    );

    wire [`MPRJ_IO_PADS-1:2] one_loop;
    gpio_control_block gpio_control_in [`MPRJ_IO_PADS-1:2] (
    	`ifdef USE_POWER_PINS
            .vccd(vccd),
			.vssd(vssd),
			.vccd1(vccd1),
			.vssd1(vssd1),
        `endif

    	// Management Soc-facing signals

    	.resetn(mprj_io_loader_resetn),
    	.serial_clock(mprj_io_loader_clock),

	.mgmt_gpio_in(mgmt_io_in[(`MPRJ_IO_PADS-1):2]),
	.mgmt_gpio_out(mgmt_io_in[(`MPRJ_IO_PADS-1):2]),
	.mgmt_gpio_oeb(one_loop),

        .one(one_loop),
        .zero(),

    	// Serial data chain for pad configuration
    	.serial_data_in(gpio_serial_link_shifted[(`MPRJ_IO_PADS-1):2]),
    	.serial_data_out(gpio_serial_link[(`MPRJ_IO_PADS-1):2]),

    	// User-facing signals
    	.user_gpio_out(user_io_out[(`MPRJ_IO_PADS-1):2]),
    	.user_gpio_oeb(user_io_oeb[(`MPRJ_IO_PADS-1):2]),
    	.user_gpio_in(user_io_in[(`MPRJ_IO_PADS-1):2]),

    	// Pad-facing signals (Pad GPIOv2)
    	.pad_gpio_inenb(mprj_io_inp_dis[(`MPRJ_IO_PADS-1):2]),
    	.pad_gpio_ib_mode_sel(mprj_io_ib_mode_sel[(`MPRJ_IO_PADS-1):2]),
    	.pad_gpio_vtrip_sel(mprj_io_vtrip_sel[(`MPRJ_IO_PADS-1):2]),
    	.pad_gpio_slow_sel(mprj_io_slow_sel[(`MPRJ_IO_PADS-1):2]),
    	.pad_gpio_holdover(mprj_io_holdover[(`MPRJ_IO_PADS-1):2]),
    	.pad_gpio_ana_en(mprj_io_analog_en[(`MPRJ_IO_PADS-1):2]),
    	.pad_gpio_ana_sel(mprj_io_analog_sel[(`MPRJ_IO_PADS-1):2]),
    	.pad_gpio_ana_pol(mprj_io_analog_pol[(`MPRJ_IO_PADS-1):2]),
    	.pad_gpio_dm(mprj_io_dm[(`MPRJ_IO_PADS*3-1):6]),
    	.pad_gpio_outenb(mprj_io_oeb[(`MPRJ_IO_PADS-1):2]),
    	.pad_gpio_out(mprj_io_out[(`MPRJ_IO_PADS-1):2]),
    	.pad_gpio_in(mprj_io_in[(`MPRJ_IO_PADS-1):2])
    );

    user_id_programming #(
	.USER_PROJECT_ID(USER_PROJECT_ID)
    ) user_id_value (
`ifdef USE_POWER_PINS
	.VPWR(vccd),
	.VGND(vssd),
`endif
	.mask_rev(mask_rev)
    );

    // Power-on-reset circuit
    simple_por por (
`ifdef USE_POWER_PINS
		.vdd3v3(vddio),
		.vdd1v8(vccd),
		.vss(vssio),
`endif
		.porb_h(porb_h),
		.porb_l(porb_l),
		.por_l(por_l)
    );

    // XRES (chip input pin reset) reset level converter
    sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped rstb_level (
`ifdef USE_POWER_PINS
		.VPWR(vddio),
		.VPB(vddio),
		.LVPWR(vccd),
		.VNB(vssio),
		.VGND(vssio),
`endif
		.A(rstb_h),
		.X(rstb_l)
    );

	// Storage area
	storage storage(
		.mgmt_clk(caravel_clk),
        .mgmt_ena(mgmt_ena),
        .mgmt_wen(mgmt_wen),
        .mgmt_wen_mask(mgmt_wen_mask),
        .mgmt_addr(mgmt_addr),
        .mgmt_wdata(mgmt_wdata),
        .mgmt_rdata(mgmt_rdata),
        // Management RO interface
        .mgmt_ena_ro(mgmt_ena_ro),
        .mgmt_addr_ro(mgmt_addr_ro),
        .mgmt_rdata_ro(mgmt_rdata_ro)
	);

endmodule
// `default_nettype wire
