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

`default_nettype none
module mgmt_core (
`ifdef USE_POWER_PINS
	inout VPWR,	   
	inout VGND,
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
	output flash_io0_ieb, output flash_io1_ieb,
	output flash_io0_do,
	output flash_io1_do,
	input flash_io0_di,
	input flash_io1_di,
	// Master reset
	input resetb,
	input porb,
	// Clocking
	input clock,
	// LA signals
    	input  [127:0] la_input,           	// From User Project to cpu
    	output [127:0] la_output,          	// From CPU to User Project
    	output [127:0] la_oen,              // LA output enable  
	// Housekeeping SPI
	output sdo_out,
	output sdo_outenb,
	// JTAG
	output jtag_out,
	output jtag_outenb,
	// User Project Control Signals
	input [`MPRJ_IO_PADS-1:0] mgmt_in_data,
	output [`MPRJ_IO_PADS-1:0] mgmt_out_data,
	output [`MPRJ_PWR_PADS-1:0] pwr_ctrl_out,
	input mprj_vcc_pwrgood,
	input mprj2_vcc_pwrgood,
	input mprj_vdd_pwrgood,
	input mprj2_vdd_pwrgood,
	output mprj_io_loader_resetn,
	output mprj_io_loader_clock,
	output mprj_io_loader_data,
	// WB MI A (User project)
    	input mprj_ack_i,
	input [31:0] mprj_dat_i,
    	output mprj_cyc_o,
	output mprj_stb_o,
	output mprj_we_o,
	output [3:0] mprj_sel_o,
	output [31:0] mprj_adr_o,
	output [31:0] mprj_dat_o,
	
    	output core_clk,
    	output user_clk,
    	output core_rstn,

	// Metal programmed user ID / mask revision vector
	input [31:0] mask_rev,
	
    // MGMT area R/W interface for mgmt RAM
    output [`RAM_BLOCKS-1:0] mgmt_ena, 
    output [(`RAM_BLOCKS*4)-1:0] mgmt_wen_mask,
    output [`RAM_BLOCKS-1:0] mgmt_wen,
    output [7:0] mgmt_addr,
    output [31:0] mgmt_wdata,
    input  [(`RAM_BLOCKS*32)-1:0] mgmt_rdata,

    // MGMT area RO interface for user RAM 
    output mgmt_ena_ro,
    output [7:0] mgmt_addr_ro,
    input  [31:0] mgmt_rdata_ro
);
    	wire ext_clk_sel;
    	wire pll_clk, pll_clk90;
    	wire ext_reset;
	wire hk_connect;
	wire trap;
	wire irq_spi;

	// JTAG (to be implemented)
	wire jtag_out;
	wire jtag_out_pre = 1'b0;
	wire jtag_outenb = 1'b1;
	wire jtag_oenb_state;

	// SDO
	wire sdo_out;
	wire sdo_out_pre;
	wire sdo_oenb_state;

	// Housekeeping SPI vectors
	wire [4:0]  spi_pll_div;
	wire [2:0]  spi_pll_sel;
	wire [2:0]  spi_pll90_sel;
	wire [25:0] spi_pll_trim;

	// Override default function for SDO and JTAG outputs if purposely
	// set for override by the management SoC.
	assign sdo_out = (sdo_oenb_state == 1'b0) ? mgmt_out_data[1] : sdo_out_pre;
	assign jtag_out = (jtag_oenb_state == 1'b0) ? mgmt_out_data[0] : jtag_out_pre;

	caravel_clocking clocking(
	`ifdef USE_POWER_PINS
		.vdd1v8(VPWR),
		.vss(VGND),
	`endif		
		.ext_clk_sel(ext_clk_sel),
		.ext_clk(clock),
		.pll_clk(pll_clk),
		.pll_clk90(pll_clk90),
		.resetb(resetb), 
		.sel(spi_pll_sel),
		.sel2(spi_pll90_sel),
		.ext_reset(ext_reset),	// From housekeeping SPI
		.core_clk(core_clk),
		.user_clk(user_clk),
		.resetb_sync(core_rstn)
	);

	// These wires are defined in the SoC but are not being used because
	// the SoC flash is reduced to a 2-pin I/O
	wire flash_io2_oeb, flash_io3_oeb;
	wire flash_io2_ieb, flash_io3_ieb;
	wire flash_io2_di, flash_io3_di;
	wire flash_io2_do, flash_io3_do;

	wire pass_thru_mgmt_sdo, pass_thru_mgmt_csb;
	wire pass_thru_mgmt_sck, pass_thru_mgmt_sdi;
	wire pass_thru_reset;
	wire spi_pll_ena, spi_pll_dco_ena;

	// The following functions are connected to specific user project
	// area pins, when under control of the management area (during
	// startup, and when not otherwise programmed for the user project).

	// JTAG      = jtag_out   	     (inout)
	// SDO       = sdo_out      	     (output)	(shared with SPI master)
	// SDI       = mgmt_in_data[2]       (input)	(shared with SPI master)
	// CSB       = mgmt_in_data[3]       (input)	(shared with SPI master)
	// SCK       = mgmt_in_data[4]       (input)	(shared with SPI master)
	// ser_rx    = mgmt_in_data[5]       (input)
	// ser_tx    = mgmt_out_data[6]      (output)
	// irq       = mgmt_in_data[7]       (input)
	// flash_csb = mgmt_out_data[8]      (output)	(user area flash)
	// flash_sck = mgmt_out_data[9]      (output)	(user area flash)
	// flash_io0 = mgmt_in/out_data[10]  (input)	(user area flash)
	// flash_io1 = mgmt_in/out_data[11]  (output)	(user area flash)
   	// irq2_pin  = mgmt_in_data[12]      (input)
    	// trap_mon  = mgmt_in_data[13]      (output)
    	// clk1_mon  = mgmt_in_data[14]      (output)
    	// clk2_mon  = mgmt_in_data[15]      (output)


	// OEB lines for [0] and [1] are the only ones connected directly to
	// the pad.  All others have OEB controlled by the configuration bit
	// in the control block.

	mgmt_soc soc (
    	    `ifdef USE_POWER_PINS
        	.vdd1v8(VPWR),
        	.vss(VGND),
    	    `endif
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
		.irq_spi(irq_spi),
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
		// SDO and JTAG state for output override
		.sdo_oenb_state(sdo_oenb_state),
		.jtag_oenb_state(jtag_oenb_state),
		// SPI master->slave direct connection
		.hk_connect(hk_connect),
		// Secondary clock (for monitoring)
		.user_clk(user_clk),
		// Logic Analyzer
		.la_input(la_input),
		.la_output(la_output),
		.la_oen(la_oen),
		// User Project I/O Configuration
		.mprj_vcc_pwrgood(mprj_vcc_pwrgood),
		.mprj2_vcc_pwrgood(mprj2_vcc_pwrgood),
		.mprj_vdd_pwrgood(mprj_vdd_pwrgood),
		.mprj2_vdd_pwrgood(mprj2_vdd_pwrgood),
		.mprj_io_loader_resetn(mprj_io_loader_resetn),
		.mprj_io_loader_clock(mprj_io_loader_clock),
		.mprj_io_loader_data(mprj_io_loader_data),
		// I/O data
		.mgmt_in_data(mgmt_in_data),
		.mgmt_out_data(mgmt_out_data),
		.pwr_ctrl_out(pwr_ctrl_out),
		// User Project Slave ports (WB MI A)
		.mprj_cyc_o(mprj_cyc_o),
		.mprj_stb_o(mprj_stb_o),
		.mprj_we_o(mprj_we_o),
		.mprj_sel_o(mprj_sel_o),
		.mprj_adr_o(mprj_adr_o),
		.mprj_dat_o(mprj_dat_o),
		.mprj_ack_i(mprj_ack_i),
		.mprj_dat_i(mprj_dat_i),
    	// MGMT area R/W interface for mgmt RAM
    	.mgmt_ena(mgmt_ena), 
    	.mgmt_wen_mask(mgmt_wen_mask),
    	.mgmt_wen(mgmt_wen),
    	.mgmt_addr(mgmt_addr),
    	.mgmt_wdata(mgmt_wdata),
    	.mgmt_rdata(mgmt_rdata),
    	// MGMT area RO interface for user RAM 
    	.mgmt_ena_ro(mgmt_ena_ro),
    	.mgmt_addr_ro(mgmt_addr_ro),
    	.mgmt_rdata_ro(mgmt_rdata_ro)
    	);
    
    	digital_pll pll (
	    `ifdef USE_POWER_PINS
		.VPWR(VPWR),
		.VGND(VGND),
	    `endif
		.resetb(resetb),
		.enable(spi_pll_ena),
		.osc(clock),
		.clockp({pll_clk, pll_clk90}),
		.div(spi_pll_div),
		.dco(spi_pll_dco_ena),
		.ext_trim(spi_pll_trim)
    	);

	// Housekeeping SPI (SPI slave module)
	housekeeping_spi housekeeping (
	    `ifdef USE_POWER_PINS
		.vdd(VPWR),
		.vss(VGND),
	    `endif
	    .RSTB(porb),
	    .SCK((hk_connect) ? mgmt_out_data[4] : mgmt_in_data[4]),
	    .SDI((hk_connect) ? mgmt_out_data[2] : mgmt_in_data[2]),
	    .CSB((hk_connect) ? mgmt_out_data[3] : mgmt_in_data[3]),
	    .SDO(sdo_out_pre),
	    .sdo_enb(sdo_outenb),
	    .pll_dco_ena(spi_pll_dco_ena),
	    .pll_sel(spi_pll_sel),
	    .pll90_sel(spi_pll90_sel),
	    .pll_div(spi_pll_div),
	    .pll_ena(spi_pll_ena),
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
    	    .pass_thru_user_sck(mgmt_out_data[9]),
    	    .pass_thru_user_csb(mgmt_out_data[8]),
    	    .pass_thru_user_sdi(mgmt_out_data[10]),
    	    .pass_thru_user_sdo(mgmt_in_data[11])
	);

endmodule
`default_nettype wire
