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

`ifdef SYNTH_OPENLANE
        `include "../stubs/scs8hd_conb_1.v"
        `include "../stubs/s8iom0s8.v"
        `include "../stubs/power_pads_lib.v"
`else

    `ifndef LVS
        `include "/ef/tech/SW/EFS8A/libs.ref/verilog/s8iom0s8/s8iom0s8.v"
        `include "/ef/tech/SW/EFS8A/libs.ref/verilog/s8iom0s8/power_pads_lib.v"
        `include "/ef/tech/SW/EFS8A/libs.ref/verilog/scs8hd/scs8hd.v"

        `include "lvlshiftdown.v"
        `include "mgmt_soc.v"
        `include "striVe_spi.v"
        `include "digital_pll.v"
        `include "striVe_clkrst.v"
        `include "../ip/crossbar.v"
        `include "../dv/dummy_slave.v"

    `endif
`endif

`ifdef USE_OPENRAM
        `include "sram_1rw1r_32_256_8_sky130.v"
`endif

//`define     TOP_ROUTING
`ifndef TOP_ROUTING 
    `define ABUTMENT_PINS \
    .amuxbus_a(analog_a),\
    .amuxbus_b(analog_b),\
    .vssa(vss),\
    .vdda(vdd),\
    .vswitch(vdd),\
    .vddio_q(vddio_q),\
    .vcchib(vdd1v8),\
    .vddio(vdd),\
    .vccd(vdd1v8),\
    .vssio(vss),\
    .vssd(vss),\
    .vssio_q(vssio_q),
`else 
    `define ABUTMENT_PINS 
`endif

// Crossbar Slaves
`ifndef SLAVE_ADR
    `define SLAVE_ADR { \
        {8'hB0, {24{1'b0}}},\
        {8'hA0, {24{1'b0}}},\
        {8'h90, {24{1'b0}}},\
        {8'h80, {24{1'b0}}}\
    }\
`endif

`ifndef ADR_MASK
    `define ADR_MASK { \
        {8'hFF, {24{1'b0}}}, \
        {8'hFF, {24{1'b0}}}, \
        {8'hFF, {24{1'b0}}}, \
        {8'hFF, {24{1'b0}}}  \
    }\
`endif

`define NM 2    // Crossbar switch number of masters
`define NS 4    // Crossbar switch number of slaves 
`define DW 32
`define AW 32

module harness (vdd, vdd1v8, vss, gpio, xi, xo, adc0_in, adc1_in, adc_high, adc_low,
    comp_inn, comp_inp, RSTB, ser_rx, ser_tx, irq, SDO, SDI, CSB, SCK,
    xclk, flash_csb, flash_clk, flash_io0, flash_io1, flash_io2, flash_io3);

    inout vdd;
    inout vdd1v8;
    inout vss;
    inout [15:0] gpio;
    input xi;		// CMOS clock input, not a crystal
    output xo;		// divide-by-16 clock output
    input adc0_in;
    input adc1_in;
    input adc_high;
    input adc_low;
    input comp_inn;
    input comp_inp;
    input RSTB;		// NOTE:  Replaces analog_out pin from raven chip
    input ser_rx;
    output ser_tx;
    input irq;
    output SDO;
    input SDI;
    input CSB;
    input SCK;
    input xclk;
    output flash_csb;
    output flash_clk;
    output flash_io0;
    output flash_io1;
    output flash_io2;
    output flash_io3;

    wire [15:0] gpio_out_core;
    wire [15:0] gpio_in_core;
    wire [15:0]	gpio_mode0_core;
    wire [15:0]	gpio_mode1_core;
    wire [15:0]	gpio_outenb_core;
    wire [15:0]	gpio_inenb_core;

    wire analog_a, analog_b;	    /* Placeholders for analog signals */

    wire porb_h;
    wire porb_l;
    wire por_h;
    wire por;
    wire SCK_core;
    wire SDI_core;
    wire CSB_core;
    wire SDO_core;
    wire SDO_enb;
    wire spi_ro_xtal_ena_core;
    wire spi_ro_reg_ena_core;
    wire spi_ro_pll_dco_ena_core;
    wire [2:0] spi_ro_pll_sel_core;
    wire [4:0] spi_ro_pll_div_core;
    wire [25:0] spi_ro_pll_trim_core;
    wire ext_clk_sel_core;
    wire irq_spi_core;
    wire ext_reset_core;
    wire trap_core;
    wire [11:0] spi_ro_mfgr_id_core;
    wire [7:0] spi_ro_prod_id_core;
    wire [3:0] spi_ro_mask_rev_core;

    // Instantiate power cells for VDD3V3 domain (8 total; 4 high clamps and
    // 4 low clamps)
    s8iom0_vdda_hvc_pad vdd3v3hclamp [1:0] (
        `ABUTMENT_PINS
        .drn_hvc(),
        .src_bdy_hvc()
    );

    s8iom0_vddio_hvc_pad vddiohclamp [1:0] (
        `ABUTMENT_PINS
        .drn_hvc(),
        .src_bdy_hvc()
    );


    s8iom0_vdda_lvc_pad vdd3v3lclamp [3:0] (
        `ABUTMENT_PINS
        .bdy2_b2b(),
        .drn_lvc1(),
        .drn_lvc2(),
        .src_bdy_lvc1(),
        .src_bdy_lvc2()
    );

    // Instantiate the core voltage supply (since it is not generated on-chip)
    // (1.8V) (4 total, 2 high and 2 low clamps)

    s8iom0_vccd_hvc_pad vdd1v8hclamp [1:0] (
        `ABUTMENT_PINS
        .drn_hvc(),
        .src_bdy_hvc()
    );

    s8iom0_vccd_lvc_pad vdd1v8lclamp [1:0] (
        `ABUTMENT_PINS
        .bdy2_b2b(),
        .drn_lvc1(),
        .drn_lvc2(),
        .src_bdy_lvc1(),
        .src_bdy_lvc2()
    );

    // Instantiate ground cells (7 total, 4 high clamps and 3 low clamps)

    s8iom0_vssa_hvc_pad vsshclamp [3:0] (
        `ABUTMENT_PINS
        .drn_hvc(),
        .src_bdy_hvc()
    );

    s8iom0_vssa_lvc_pad vssalclamp (
        `ABUTMENT_PINS
        .bdy2_b2b(),
        .drn_lvc1(),
        .drn_lvc2(),
        .src_bdy_lvc1(),
        .src_bdy_lvc2()
    );

    s8iom0_vssd_lvc_pad vssdlclamp (
        `ABUTMENT_PINS
        .bdy2_b2b(),
        .drn_lvc1(),
        .drn_lvc2(),
        .src_bdy_lvc1(),
        .src_bdy_lvc2()
    );

    s8iom0_vssio_lvc_pad vssiolclamp (
        `ABUTMENT_PINS
        .bdy2_b2b(),
        .drn_lvc1(),
        .drn_lvc2(),
        .src_bdy_lvc1(),
        .src_bdy_lvc2()
    );

    wire [47:0] dm_all;

    assign dm_all = {gpio_mode1_core[15], gpio_mode1_core[15], gpio_mode0_core[15],
         gpio_mode1_core[14], gpio_mode1_core[14], gpio_mode0_core[14],
         gpio_mode1_core[13], gpio_mode1_core[13], gpio_mode0_core[13],
         gpio_mode1_core[12], gpio_mode1_core[12], gpio_mode0_core[12],
         gpio_mode1_core[11], gpio_mode1_core[11], gpio_mode0_core[11],
         gpio_mode1_core[10], gpio_mode1_core[10], gpio_mode0_core[10],
         gpio_mode1_core[9], gpio_mode1_core[9], gpio_mode0_core[9],
         gpio_mode1_core[8], gpio_mode1_core[8], gpio_mode0_core[8],
         gpio_mode1_core[7], gpio_mode1_core[7], gpio_mode0_core[7],
         gpio_mode1_core[6], gpio_mode1_core[6], gpio_mode0_core[6],
         gpio_mode1_core[5], gpio_mode1_core[5], gpio_mode0_core[5],
         gpio_mode1_core[4], gpio_mode1_core[4], gpio_mode0_core[4],
         gpio_mode1_core[3], gpio_mode1_core[3], gpio_mode0_core[3],
         gpio_mode1_core[2], gpio_mode1_core[2], gpio_mode0_core[2],
         gpio_mode1_core[1], gpio_mode1_core[1], gpio_mode0_core[1],
         gpio_mode1_core[0], gpio_mode1_core[0], gpio_mode0_core[0]};

    // GPIO pads
    s8iom0_gpiov2_pad gpio_pad [15:0] (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(gpio),
`endif
        .out(gpio_out_core),	// Signal from core to pad
        .oe_n(gpio_outenb_core), // Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold signals during deep sleep (sense inverted)
        .enable_h(porb_h),	// Post-reset enable
        .enable_inp_h(loopb0),	// Input buffer state when disabled
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(gpio_inenb_core),		// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm(dm_all), // (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(gpio_in_core),  // Signal from pad to core
        .in_h(),	    // VDDA domain signal (unused)
        .tie_hi_esd(),
        .tie_lo_esd(loopb0)
    );

    s8iom0_gpiov2_pad xi_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(xi),
`endif
        .out(),			// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb1),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(por),		// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vdd1v8}), // (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(xi_core),	    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd(loopb1)
    );

    s8iom0_gpiov2_pad xo_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(xo),
`endif
        .out(pll_clk16),	// Signal from core to pad
        .oe_n(vss),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb2),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(vdd1v8),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vdd1v8, vdd1v8, vss}),	// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(),	    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd(loopb2)
    );

    s8iom0_gpiov2_pad adc0_in_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(adc0_in),
`endif
        .out(vss),		// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb3),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(vdd1v8),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vdd1v8),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vss}),			// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    s8iom0_gpiov2_pad adc1_in_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(adc1_in),
`endif
        .pad_a_noesd_h(),   // Direct pad connection
        .out(vss),		// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb4),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(vdd1v8),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vdd1v8),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vss}),			// (3 bits) Mode control
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    s8iom0_gpiov2_pad adc_high_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(adc_high),
`endif
        .out(vss),		// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb5),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(vdd1v8),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vdd1v8),	//
        .analog_sel(vdd1v8),	//
        .analog_pol(vdd1v8),	//
        .dm({vss, vss, vss}),			// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    s8iom0_gpiov2_pad adc_low_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(adc_low),
`endif
        .out(vss),		// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb6),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(vdd1v8),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vdd1v8),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vss}),			// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    s8iom0_gpiov2_pad comp_inn_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(comp_inn),
`endif
        .out(vss),		// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb7),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(vdd1v8),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vdd1v8),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vss}),			// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    s8iom0_gpiov2_pad comp_inp_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(comp_inp),
`endif
        .out(vss),		// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb8),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(vdd1v8),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vdd1v8),	//
        .analog_sel(vdd1v8),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vss}),			// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    // NOTE:  The analog_out pad from the raven chip has been replaced by
    // the digital reset input RSTB on striVe due to the lack of an on-board
    // power-on-reset circuit.  The XRES pad is used for providing a glitch-
    // free reset.

    s8iom0s8_top_xres4v2 RSTB_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(RSTB),
`endif
        .tie_weak_hi_h(xresloop),   // Loop-back connection to pad through pad_a_esd_h
        .tie_hi_esd(),
        .tie_lo_esd(),
        .pad_a_esd_h(xresloop),
        .xres_h_n(porb_h),
        .disable_pullup_h(vss),	    // 0 = enable pull-up on reset pad
        .enable_h(vdd),		    // Power-on-reset to the power-on-reset input??
        .en_vddio_sig_h(vss),	    // No idea.
        .inp_sel_h(vss),	    // 1 = use filt_in_h else filter the pad input
        .filt_in_h(vss),	    // Alternate input for glitch filter
        .pullup_h(vss),		    // Pullup connection for alternate filter input
        .enable_vddio(vdd1v8)
    );

    s8iom0_gpiov2_pad irq_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(irq),
`endif
        .out(vss),		// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb10),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(por),		// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vdd1v8}),	// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(irq_pin_core),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd(loopb10)
    );

    s8iom0_gpiov2_pad SDO_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(SDO),
`endif
        .out(SDO_core),		// Signal from core to pad
        .oe_n(SDO_enb),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb11),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(vdd1v8),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vdd1v8, vdd1v8, vss}),	// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd(loopb11)
    );

    s8iom0_gpiov2_pad SDI_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(SDI),
`endif
        .out(vss),			// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb12),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(por),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vdd1v8}),	// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(SDI_core),		    // Signal from pad to core
        .in_h(SDI_core_h),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    s8iom0_gpiov2_pad CSB_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(CSB),
`endif
        .out(vss),		// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb13),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(por),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vdd1v8}),	// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(CSB_core),		    // Signal from pad to core
        .in_h(CSB_core_h),
        .tie_hi_esd(),
        .tie_lo_esd(loopb13)
    );

    s8iom0_gpiov2_pad SCK_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(SCK),
`endif
        .out(vss),		// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb14),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(por),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vdd1v8}),	// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(SCK_core),		    // Signal from pad to core
        .in_h(SCK_core_h),    // Signal in vdda domain (3.3V)
        .tie_hi_esd(),
        .tie_lo_esd(loopb14)
    );

    s8iom0_gpiov2_pad xclk_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(xclk),
`endif
        .out(vss),		// Signal from core to pad
        .oe_n(vdd1v8),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb15),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(por),		// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vss, vss, vdd1v8}), // (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(ext_clk_core),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd(loopb15)
    );

    // assign flash_csb = (input) ? 
    s8iom0_gpiov2_pad flash_csb_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(flash_csb),
`endif
        .out(flash_csb_core),			// Signal from core to pad
        .oe_n(flash_csb_oeb_core),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb16),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(flash_csb_ieb_core),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vdd1v8, vdd1v8, vss}),	// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    s8iom0_gpiov2_pad flash_clk_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(flash_clk),
`endif
        .out(flash_clk_core),			// Signal from core to pad
        .oe_n(flash_clk_oeb_core),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb17),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(flash_clk_ieb_core),	// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({vdd1v8, vdd1v8, vss}),	// (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    s8iom0_gpiov2_pad flash_io0_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(flash_io0),
`endif
        .out(flash_io0_do_core),			// Signal from core to pad
        .oe_n(flash_io0_oeb_core),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb18),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(flash_io0_ieb_core),		// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({flash_io0_ieb_core, flash_io0_ieb_core, flash_io0_oeb_core}), // (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(flash_io0_di_core),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd(loopb18)
    );

    s8iom0_gpiov2_pad flash_io1_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(flash_io1),
`endif
        .out(flash_io1_do_core),			// Signal from core to pad
        .oe_n(flash_io1_oeb_core),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb19),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(flash_io1_ieb_core),		// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({flash_io1_ieb_core, flash_io1_ieb_core, flash_io1_oeb_core}), // (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(flash_io1_di_core),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd(loopb19)
    );

    s8iom0_gpiov2_pad flash_io2_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(flash_io2),
`endif
        .out(flash_io2_do_core),			// Signal from core to pad
        .oe_n(flash_io2_oeb_core),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb20),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(flash_io2_ieb_core),		// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({flash_io2_ieb_core, flash_io2_ieb_core, flash_io2_oeb_core}), // (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(flash_io2_di_core),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd(loopb20)
    );

    s8iom0_gpiov2_pad flash_io3_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(flash_io3),
`endif
        .out(flash_io3_do_core),			// Signal from core to pad
        .oe_n(flash_io3_oeb_core),		// Output enable (sense inverted)
        .hld_h_n(vdd),		// Hold
        .enable_h(porb_h),	// Enable
        .enable_inp_h(loopb21),	// Enable input buffer
        .enable_vdda_h(porb_h),	// 
        .enable_vswitch_h(vss),	// 
        .enable_vddio(vdd1v8),	//
        .inp_dis(flash_io3_ieb_core),		// Disable input buffer
        .ib_mode_sel(vss),	//
        .vtrip_sel(vss),	//
        .slow(vss),		//
        .hld_ovr(vss),		//
        .analog_en(vss),	//
        .analog_sel(vss),	//
        .analog_pol(vss),	//
        .dm({flash_io3_ieb_core, flash_io3_ieb_core, flash_io3_oeb_core}), // (3 bits) Mode control
        .pad_a_noesd_h(),   // Direct pad connection
        .pad_a_esd_0_h(),   // Pad connection through 150 ohms
        .pad_a_esd_1_h(),   // Pad connection through 150 ohms
        .in(flash_io3_di_core),		    // Signal from pad to core
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd(loopb21)
    );

    // Instantiate GPIO overvoltage (I2C) compliant cell
    // (Use this for ser_rx and ser_tx;  no reason other than testing
    // the use of the cell.) (Might be worth adding in the I2C IP from
    // ravenna just to test on a proper I2C channel.)

    s8iom0s8_top_gpio_ovtv2 ser_rx_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(ser_rx),
`endif
        .out(vss),
        .oe_n(vdd1v8),
        .hld_h_n(vdd),
        .enable_h(porb_h),
        .enable_inp_h(loopb22),
        .enable_vdda_h(porb_h),
        .enable_vddio(vdd1v8),
        .enable_vswitch_h(vss),
        .inp_dis(por),
        .vtrip_sel(vss),
        .hys_trim(vdd1v8),
        .slow(vss),
        .slew_ctl({vss, vss}),	// 2 bits
        .hld_ovr(vss),
        .analog_en(vss),
        .analog_sel(vss),
        .analog_pol(vss),
        .dm({vss, vss, vdd1v8}),		// 3 bits
        .ib_mode_sel({vss, vss}),	// 2 bits
        .vinref(vdd1v8),
        .pad_a_noesd_h(),
        .pad_a_esd_0_h(),
        .pad_a_esd_1_h(),
        .in(ser_rx_core),
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    s8iom0s8_top_gpio_ovtv2 ser_tx_pad (
        `ABUTMENT_PINS 
`ifndef	TOP_ROUTING
        .pad(ser_tx),
`endif
        .out(ser_tx_core),
        .oe_n(vss),
        .hld_h_n(vdd),
        .enable_h(porb_h),
        .enable_inp_h(loopb23),
        .enable_vdda_h(porb_h),
        .enable_vddio(vdd1v8),
        .enable_vswitch_h(vss),
        .inp_dis(vdd1v8),
        .vtrip_sel(vss),
        .hys_trim(vdd1v8),
        .slow(vss),
        .slew_ctl({vss, vss}),	// 2 bits
        .hld_ovr(vss),
        .analog_en(vss),
        .analog_sel(vss),
        .analog_pol(vss),
        .dm({vdd1v8, vdd1v8, vss}),		// 3 bits
        .ib_mode_sel({vss, vss}),	// 2 bits
        .vinref(vdd1v8),
        .pad_a_noesd_h(),
        .pad_a_esd_0_h(),
        .pad_a_esd_1_h(),
        .in(),
        .in_h(),
        .tie_hi_esd(),
        .tie_lo_esd()
    );

    // Corner cells (These are overlay cells;  it is not clear what is normally
    // supposed to go under them.)
 `ifndef TOP_ROUTING   
    s8iom0_corner_pad corner [3:0] (
        .vssio(vss),
        .vddio(vdd),
        .vddio_q(vddio_q),
        .vssio_q(vssio_q),
        .amuxbus_a(analog_a),
        .amuxbus_b(analog_b),
        .vssd(vss),
        .vssa(vss),
        .vswitch(vdd),
        .vdda(vdd),
        .vccd(vdd1v8),
        .vcchib(vdd1v8)
        //`ABUTMENT_PINS 
    );
`endif

    // SoC core
    wire [9:0]  adc0_data_core;
    wire [1:0]  adc0_inputsrc_core;
    wire [9:0]  adc1_data_core;
    wire [1:0]  adc1_inputsrc_core;
    wire [9:0]  dac_value_core;
    wire [1:0]  comp_ninputsrc_core;
    wire [1:0]  comp_pinputsrc_core;
    wire [7:0]  spi_ro_config_core;

    wire xbar_cyc_o_core;
    wire xbar_stb_o_core;
    wire xbar_we_o_core;
    wire [3:0] xbar_sel_o_core;
    wire [31:0] xbar_adr_o_core;
    wire [31:0] xbar_dat_o_core;
    wire xbar_ack_i_core;
    wire [31:0] xbar_dat_i_core;

    wire striVe_clk, striVe_rstn;
    
    striVe_clkrst clkrst(
    `ifdef LVS
        .vdd1v8(vdd1v8),
        .vss(vss),
    `endif		
        .ext_clk_sel(ext_clk_sel_core),
        .ext_clk(ext_clk_core),
        .pll_clk(pll_clk_core),
        .reset(por), 
        .ext_reset(ext_reset_core),
        .clk(striVe_clk),
        .resetn(striVe_rstn)
    );

    mgmt_soc core (
    `ifdef LVS
        .vdd1v8(vdd1v8),
        .vss(vss),
    `endif
        .pll_clk(pll_clk_core),
        .ext_clk(ext_clk_core),
        .ext_clk_sel(ext_clk_sel_core),
        .clk(striVe_clk),
        .resetn(striVe_rstn),
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
        .xtal_in(xtal_in_core),
        .comp_in(comp_in_core),
        .spi_sck(SCK_core),
        .spi_ro_config(spi_ro_config_core),
        .spi_ro_xtal_ena(spi_ro_xtal_ena_core),
        .spi_ro_reg_ena(spi_ro_reg_ena_core),
        .spi_ro_pll_dco_ena(spi_ro_pll_dco_ena_core),
        .spi_ro_pll_div(spi_ro_pll_div_core),
        .spi_ro_pll_sel(spi_ro_pll_sel_core),
        .spi_ro_pll_trim(spi_ro_pll_trim_core),
        .spi_ro_mfgr_id(spi_ro_mfgr_id_core),
        .spi_ro_prod_id(spi_ro_prod_id_core),
        .spi_ro_mask_rev(spi_ro_mask_rev_core),
        .ser_tx(ser_tx_core),
        .ser_rx(ser_rx_core),
        .irq_pin(irq_pin_core),
        .irq_spi(irq_spi_core),
        .trap(trap_core),
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
        .xbar_cyc_o(xbar_cyc_o_core),
        .xbar_stb_o(xbar_stb_o_core),
        .xbar_we_o (xbar_we_o_core),
        .xbar_sel_o(xbar_sel_o_core),
        .xbar_adr_o(xbar_adr_o_core),
        .xbar_dat_o(xbar_dat_o_core),
        .xbar_ack_i(xbar_ack_i_core),
        .xbar_dat_i(xbar_dat_i_core)
    );
    
    // Mega-Project
    wire mega_cyc_o;
    wire mega_stb_o;
    wire mega_we_o;
    wire [3:0] mega_sel_o;
    wire [31:0] mega_adr_o;
    wire [31:0] mega_dat_o;
    wire mega_ack_i;
    wire [31:0] mega_dat_i;

    // Masters interface
    wire [`NM-1:0] wbm_cyc_i;       
    wire [`NM-1:0] wbm_stb_i;       
    wire [`NM-1:0] wbm_we_i;     
    wire [(`NM*(`DW/8))-1:0] wbm_sel_i;     
    wire [(`NM*`AW)-1:0] wbm_adr_i;        
    wire [(`NM*`DW)-1:0] wbm_dat_i; 

    wire [`NM-1:0] wbm_ack_o; 
    wire [(`NM*`DW)-1:0] wbm_dat_o;       

    // Slaves interfaces
    wire [`NS-1:0] wbs_ack_o;       
    wire [(`NS*`DW)-1:0] wbs_dat_i;
    wire [`NS-1:0] wbs_cyc_o;        
    wire [`NS-1:0] wbs_stb_o;       
    wire [`NS-1:0] wbs_we_o;        
    wire [(`NS*(`DW/8))-1:0] wbs_sel_o;       
    wire [(`NS*`AW)-1:0] wbs_adr_o;       
    wire [(`NS*`DW)-1:0] wbs_dat_o;  

    assign wbm_cyc_i = {mega_cyc_o, xbar_cyc_o_core};
    assign wbm_stb_i = {mega_stb_o, xbar_stb_o_core};
    assign wbm_we_i  = {mega_we_o , xbar_we_o_core};
    assign wbm_sel_i = {mega_sel_o, xbar_sel_o_core};
    assign wbm_adr_i = {mega_adr_o, xbar_adr_o_core};
    assign wbm_dat_i = {mega_dat_o, xbar_dat_o_core};

    assign xbar_ack_i_core = wbm_ack_o[0];
    assign mega_ack_i = wbm_ack_o[1];
    assign xbar_dat_i_core = wbm_dat_o[`DW-1:0];
    assign mega_dat_i = wbm_dat_o[`DW*2-1:`DW];
    
     // Instantiate four dummy slaves for testing (TO-BE-REMOVED)
    dummy_slave dummy_slaves [`NS-1:0](
        .wb_clk_i({`NS{striVe_clk}}),
        .wb_rst_i({`NS{~striVe_rstn}}),
        .wb_stb_i(wbs_stb_o),
        .wb_cyc_i(wbs_cyc_o),
        .wb_we_i(wbs_we_o),
        .wb_sel_i(wbs_sel_o),
        .wb_adr_i(wbs_adr_o),
        .wb_dat_i(wbs_dat_i),
        .wb_dat_o(wbs_dat_o),
        .wb_ack_o(wbs_ack_o)
    );
    // Crossbar Switch
    wb_xbar #(
        .NM(`NM),
        .NS(`NS),
        .AW(`AW),
        .DW(`DW),
        .SLAVE_ADR(`SLAVE_ADR),
        .ADR_MASK(`ADR_MASK) 
    )
    wb_xbar(
        .wb_clk_i(striVe_clk),           
        .wb_rst_i(~striVe_rstn), 

        // Masters interface
        .wbm_cyc_i(wbm_cyc_i),       
        .wbm_stb_i(wbm_stb_i),       
        .wbm_we_i (wbm_we_i),     
        .wbm_sel_i(wbm_sel_i),     
        .wbm_adr_i(wbm_adr_i),        
        .wbm_dat_i(wbm_dat_i),       
        .wbm_ack_o(wbm_ack_o), 
        .wbm_dat_o(wbm_dat_o),       

        // Slaves interfaces
        .wbs_ack_i(wbs_ack_o),       
        .wbs_dat_i(wbs_dat_o),
        .wbs_cyc_o(wbs_cyc_o),        
        .wbs_stb_o(wbs_stb_o),       
        .wbs_we_o (wbs_we_o),        
        .wbs_sel_o(wbs_sel_o),       
        .wbs_adr_o(wbs_adr_o),       
        .wbs_dat_o(wbs_dat_i)     
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

    // Housekeeping SPI at 1.8V.

    striVe_spi housekeeping (
    `ifdef LVS
        .vdd(vdd1v8),
        .vss(vss),
    `endif
        .RSTB(porb_l),
        .SCK(SCK_core),
        .SDI(SDI_core),
        .CSB(CSB_core),
        .SDO(SDO_core),
        .sdo_enb(SDO_enb),
        
        .xtal_ena(spi_ro_xtal_ena_core),
        .reg_ena(spi_ro_reg_ena_core),
        .pll_dco_ena(spi_ro_pll_dco_ena_core),
        .pll_sel(spi_ro_pll_sel_core),
        .pll_div(spi_ro_pll_div_core),
        .pll_trim(spi_ro_pll_trim_core),
        .pll_bypass(ext_clk_sel_core),
        .irq(irq_spi_core),
        .RST(por),
        .reset(ext_reset_core),
        .trap(trap_core),
        .mfgr_id(spi_ro_mfgr_id_core),
        .prod_id(spi_ro_prod_id_core),
        .mask_rev_in(mask_rev),
        .mask_rev(spi_ro_mask_rev_core)
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

    // On-board experimental digital PLL
    // Use xi_core, assumed to be a CMOS digital clock signal.  xo_core
    // is used as an output and set from pll_clk16.

    digital_pll pll (
    `ifdef LVS
        .vdd(vdd1v8),
        .vss(vss),
    `endif
        .reset(por),
        .extclk_sel(ext_clk_sel_core),
        .osc(xi_core),
        .clockc(pll_clk_core),
        .clockp({pll_clk_core0, pll_clk_core90}),
        .clockd({pll_clk2, pll_clk4, pll_clk8, pll_clk16}),
        .div(spi_ro_pll_div_core),
        .sel(spi_ro_pll_sel_core),
        .dco(spi_ro_pll_dco_ena_core),
        .ext_trim(spi_ro_pll_trim_core)
    );
    
endmodule
