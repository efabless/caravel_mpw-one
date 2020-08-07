/*------------------------------------------------------*/
/* caravel, a standard container for user projects on	*/
/* the Google/SkyWater/efabless shuttle runs for the	*/
/* SkyWater sky130 130nm process.			*/
/*                                                      */
/* Copyright 2020 efabless, Inc.                        */
/* Written by Tim Edwards, August 2020                	*/
/* This file is open source hardware released under the */
/* Apache 2.0 license.  See file LICENSE.               */
/*                                                      */
/*------------------------------------------------------*/

`timescale 1 ns / 1 ps

/* Always define USE_PG_PIN (used by SkyWater cells) */
/* But do not define SC_USE_PG_PIN */
`define USE_PG_PIN

/* Must define functional for now because otherwise the timing delays   */
/* are assumed, but they have been stripped out because some are not    */
/* parsed by iverilog.                                                  */

`define functional

// Define GL to use the gate-level netlists
//`define GL

// PDK IP

// I/O padframe cells

// Local IP
`include "striVe.v"

//`define     TOP_ROUTING

`ifndef TOP_ROUTING 
	`define ABUTMENT_PINS \
	.amuxbus_a(analog_a),\
	.amuxbus_b(analog_b),\
	.vssa(vss),\
	.vdda(vdd3v3),\
	.vswitch(vdd3v3),\
	.vddio_q(vddio_q),\
	.vcchib(vdd1v8),\
	.vddio(vdd3v3),\
	.vccd(vdd1v8),\
	.vssio(vss),\
	.vssd(vss),\
	.vssio_q(vssio_q),
`else 
	`define ABUTMENT_PINS 
`endif

module caravel (vdd3v3, vdd1v8, vss, gpio, cclk, ser_rx, ser_tx, irq,
	RSTB, SDO, SDI, CSB, SCK,
	flash_csb, flash_clk, flash_io0, flash_io1, flash_io2, flash_io3);
    inout vdd3v3;
    inout vdd1v8;
    inout vss;
    inout [15:0] gpio;
    input cclk;		// CMOS clock input
    input ser_rx;
    output ser_tx;
    input irq;
    input RSTB;		// NOTE:  Replaces analog_out pin from raven chip
    output SDO;
    input SDI;
    input CSB;
    input SCK;
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
    wire spi_ro_reg_ena_core;
    wire spi_ro_pll_dco_ena_core;
    wire [2:0] spi_ro_pll_sel_core;
    wire [4:0] spi_ro_pll_div_core;
    wire [25:0] spi_ro_pll_trim_core;
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



    // Instantiate GPIO v2 cell.  These are used for both digital and analog
    // functions, configured appropriately.
    //
    // GPIO pin description:
    //
    // general:  signals with _h suffix are in the vddio (3.3V) domain.  All
    // other signals are in 1.8V domains (vccd or vcchib)

    // out = Signal from core to pad (digital, 1.8V domain)
    // oe_n = Output buffer enable (sense inverted)
    // hld_h_n = Hold signals during deep sleep (sense inverted)
    // enable_h = Power-on-reset (inverted)
    // enable_inp_h = Defines state of input buffer output when disabled.
    //	    Connect via loopback to tie_hi_esd or tie_lo_esd.
    // enable_vdda_h = Power-on-reset (inverted) to analog section
    // enable_vswitch_h = set to 0 if not using vswitch
    // enable_vddio = set to 1 if vddio is up during deep sleep
    // inp_dis = Disable input buffer
    // ib_mode_sel = Input buffer mode select, 0 for 3.3V external signals, 1 for
    //		1.8V external signals
    // vtrip_se = Input buffer trip select, 0 for CMOS level, 1 for TTL level
    // slow = 0 for fast slew, 1 for slow slew
    // hld_ovr = override for pads that need to be enabled during deep sleep
    // analog_en = enable analog functions
    // analog_sel = select analog channel a or b
    // analog_pol = analog select polarity
    // dm = digital mode (3 bits) 000 = analog 001 = input only, 110 = output only
    // vddio = Main 3.3V supply
    // vddio_q = Quiet 3.3V supply
    // vdda = Analog 3.3V supply
    // vccd = Digital 1.8V supply
    // vswitch = High-voltage supply for analog switches
    // vcchib = Digital 1.8V supply live during deep sleep mode
    // vssa = Analog ground
    // vssd = Digital ground
    // vssio_q = Quiet main ground
    // vssio = Main ground
    // pad = Signal on pad
    // pad_a_noesd_h = Direct core connection to pad
    // pad_a_esd_0_h = Core connection to pad through 150 ohms (primary)
    // pad_a_esd_1_h = Core connection to pad through 150 ohms (secondary)
    // amuxbus_a = Analog bus A
    // amuxbus_b = Analog bus B
    // in = Signal from pad to core (digital, 1.8V domain)
    // in_h = Signal from pad to core (3.3V domain)
    // tie_hi_esd = 3.3V output for loopback to enable_inp_h
    // tie_lo_esd = ground output for loopback to enable_inp_h

    // 37 instances:  16 general purpose digital, 2 for the crystal oscillator,
    // 4 for the ADC, 1 for the analog out, 2 for the comparator inputs,
    // one for the IRQ input, one for the xclk input, 6 for the SPI flash
    // signals, and 4 for the housekeeping SPI signals.

    // NOTE:  To pass a vector to array dm in an array of instances gpio_pad,
    // the array needs to be rearranged.  Reconstruct the needed 48-bit vector
    // (3 bit signal * 16 instances).
    //
    // Also note:  Preferable to use a generate block, but that is incompatible
    // with the current version of padframe_generator. . .

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

    // GPIO pads (user space)
    s8iom0_gpiov2_pad gpio_pad [31:0] (
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

    s8iom0_gpiov2_pad cclk_pad (
		`ABUTMENT_PINS 
`ifndef	TOP_ROUTING
		.pad(cclk),
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
		.in(cclk_core),	    // Signal from pad to core
		.in_h(),
		.tie_hi_esd(),
		.tie_lo_esd(loopb1)
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
		.out(vss),		// Signal from core to pad
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

    // Corner cells
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

    striVe_soc core (
`ifdef LVS
	.vdd1v8(vdd1v8),
	.vss(vss),
`endif
    
	.pll_clk(pll_clk_core),
    	.clk(striVe_clk),
    	.resetn(striVe_rstn),
	.gpio_out_pad(gpio_out_core),
	.gpio_in_pad(gpio_in_core),
	.gpio_mode0_pad(gpio_mode0_core),
	.gpio_mode1_pad(gpio_mode1_core),
	.gpio_outenb_pad(gpio_outenb_core),
	.gpio_inenb_pad(gpio_inenb_core),
	.spi_sck(SCK_core),
	.spi_ro_config(spi_ro_config_core),
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
	.flash_io3_di(flash_io3_di_core)
    );

    // For the mask revision input, use an array of digital constant logic cells
    wire [3:0] mask_rev_h;
    wire [3:0] no_connect;

    sky130_fd_sc_hvl__conb_1 mask_rev_value [3:0] (
`ifdef LVS
        .vpwr(vdd3v3),
        .vpb(vdd3v3),
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
	.RSTB(porb_h),
	.SCK(SCK_core_h),
	.SDI(SDI_core_h),
	.CSB(CSB_core_h),
	.SDO(SDO_core_h),
	.sdo_enb(SDO_enb_h),
	.reg_ena(spi_ro_reg_ena_core_h),
	.pll_dco_ena(spi_ro_pll_dco_ena_core_h),
	.pll_sel(spi_ro_pll_sel_core_h),
	.pll_div(spi_ro_pll_div_core_h),
        .pll_trim(spi_ro_pll_trim_core_h),
	.irq(irq_spi_core_h),
	.RST(por_h),
	.reset(ext_reset_core_h),
	.trap(trap_core_h),
        .mfgr_id(spi_ro_mfgr_id_core_h),
	.prod_id(spi_ro_prod_id_core_h),
	.mask_rev_in(mask_rev_h),
	.mask_rev(spi_ro_mask_rev_core_h)
    );

    // Level shifters from the HVL library

    // On-board digital PLL

    digital_pll pll (
`ifdef LVS
	.vdd(vdd1v8),
	.vss(vss),
`endif
	.reset(por),
	.osc(cclk_core),
	.clockc(pll_clk_core),
	.clockp({pll_clk_core0, pll_clk_core90}),
	.clockd({pll_clk2, pll_clk4, pll_clk8, pll_clk16}),
	.div(spi_ro_pll_div_core),
	.sel(spi_ro_pll_sel_core),
	.dco(spi_ro_pll_dco_ena_core),
	.ext_trim(spi_ro_pll_trim_core)
    );
	
endmodule
