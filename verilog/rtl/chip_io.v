module chip_io(
	// Package Pins
	inout  vdd,
    inout  vdd1v8,
    inout  vss,
	input  [15:0] gpio,
	inout  xi,
	output xo,
	inout  adc0_in,
	inout  adc1_in,
	inout  adc_high,
	inout  adc_low,
	inout  comp_inn,
	inout  comp_inp,
	inout  RSTB,
	inout  ser_rx,
	output ser_tx,
	inout  irq,
	output SDO,
	inout  SDI,
	inout  CSB,
	inout  SCK,
	inout  xclk,
	output flash_csb,
	output flash_clk,
	output flash_io0,
	output flash_io1,
	output flash_io2,
	output flash_io3,
	// Chip Core Interface
	input  por,
	output porb_h,
	output ext_clk_core,
	output xi_core,
	input  [15:0] gpio_out_core,
    output [15:0] gpio_in_core,
    input  [15:0] gpio_mode0_core,
    input  [15:0] gpio_mode1_core,
    input  [15:0] gpio_outenb_core,
    input  [15:0] gpio_inenb_core,
	output SCK_core,
	output ser_rx_core,
	inout  ser_tx_core,
	output irq_pin_core,
	input  flash_csb_core,
	input  flash_clk_core,
	input  flash_csb_oeb_core,
	input  flash_clk_oeb_core,
	input  flash_io0_oeb_core,
	input  flash_io1_oeb_core,
	input  flash_io2_oeb_core,
	input  flash_io3_oeb_core,
	input  flash_csb_ieb_core,
	input  flash_clk_ieb_core,
	input  flash_io0_ieb_core,
	input  flash_io1_ieb_core,
	input  flash_io2_ieb_core,
	input  flash_io3_ieb_core,
	input  flash_io0_do_core,
	input  flash_io1_do_core,
	input  flash_io2_do_core,
	input  flash_io3_do_core,
	output flash_io0_di_core,
	output flash_io1_di_core,
	output flash_io2_di_core,
	output flash_io3_di_core,	
	output SDI_core,
	output CSB_core,
	input  pll_clk16,
	input  SDO_core,
	// Mega-project IOs
	input [`MPRJ_IO_PADS-1:0] mprj_io,
	input [`MPRJ_IO_PADS-1:0] mprj_io_out,
	input [`MPRJ_IO_PADS-1:0] mprj_io_oeb_n,
    input [`MPRJ_IO_PADS-1:0] mprj_io_hldh_n,
	input [`MPRJ_IO_PADS-1:0] mprj_io_enh,
    input [`MPRJ_IO_PADS-1:0] mprj_io_inp_dis,
    input [`MPRJ_IO_PADS-1:0] mprj_io_ib_mode_sel,
    input [`MPRJ_IO_PADS-1:0] mprj_io_analog_en,
    input [`MPRJ_IO_PADS-1:0] mprj_io_analog_sel,
    input [`MPRJ_IO_PADS-1:0] mprj_io_analog_pol,
    input [`MPRJ_IO_PADS*3-1:0] mprj_io_dm,
	output [`MPRJ_IO_PADS-1:0] mprj_io_in
);
	wire analog_a, analog_b;
	wire vddio_q, vssio_q;
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

	wire[2:0] flash_io0_mode = 
		{flash_io0_ieb_core, flash_io0_ieb_core, flash_io0_oeb_core};
	wire[2:0] flash_io1_mode = 
		{flash_io1_ieb_core, flash_io1_ieb_core, flash_io1_oeb_core};
	wire[2:0] flash_io2_mode = 
		{flash_io2_ieb_core, flash_io2_ieb_core, flash_io2_oeb_core};
	wire[2:0] flash_io3_mode =
		{flash_io3_ieb_core, flash_io3_ieb_core, flash_io3_oeb_core};

    // GPIO pads
	`INOUT_PAD_V(
		gpio, gpio_in_core, gpio_out_core, 16,
		gpio_inenb_core, gpio_outenb_core, dm_all);
	
	// Flash pads
	`INOUT_PAD(
		flash_io0, flash_io0_di_core, flash_io0_do_core,
		flash_io0_ieb_core, flash_io0_oeb_core, flash_io0_mode);
	`INOUT_PAD(
		flash_io1, flash_io1_di_core, flash_io1_do_core,
		flash_io1_ieb_core, flash_io1_oeb_core, flash_io1_mode);
	`INOUT_PAD(
		flash_io2, flash_io2_di_core, flash_io2_do_core,
		flash_io2_ieb_core, flash_io2_oeb_core, flash_io2_mode);
	`INOUT_PAD(
		flash_io3, flash_io3_di_core, flash_io3_do_core,
		flash_io3_ieb_core, flash_io3_oeb_core, flash_io3_mode);

	`INPUT_PAD(xi, xi_core); 	    
	`INPUT_PAD(irq, irq_pin_core);
	`INPUT_PAD(xclk,ext_clk_core);
	`INPUT_PAD(SDI, SDI_core); 	    
	`INPUT_PAD(CSB, CSB_core); 	    
	`INPUT_PAD(SCK, SCK_core); 	    

	// Analog Pads
	`INPUT_PAD_ANALOG(adc0_in,vss,vss);
	`INPUT_PAD_ANALOG(adc1_in,vss,vss);
	`INPUT_PAD_ANALOG(adc_high,vdd1v8,vdd1v8);
	`INPUT_PAD_ANALOG(adc_low,vss,vss);
    `INPUT_PAD_ANALOG(comp_inn,vss,vss);
	`INPUT_PAD_ANALOG(comp_inp,vdd1v8,vss);

	// Output Pads
	`OUTPUT_PAD(xo,pll_clk16,vdd1v8,vss);
	`OUTPUT_PAD(SDO,SDO_core,vdd1v8,SDO_enb);

	`OUTPUT_PAD(flash_csb, flash_csb_core, flash_csb_ieb_core, flash_csb_oeb_core);  
	`OUTPUT_PAD(flash_clk, flash_clk_core, flash_clk_ieb_core, flash_clk_oeb_core);

	// Instantiate GPIO overvoltage (I2C) compliant cell
    // (Use this for ser_rx and ser_tx;  no reason other than testing
    // the use of the cell.) (Might be worth adding in the I2C IP from
    // ravenna just to test on a proper I2C channel.)
	`I2C_RX(ser_rx, ser_rx_core);
	`I2C_TX(ser_tx, ser_tx_core);

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
    );
`endif

	mprj_io mprj_pads(
		.vdd(vdd),
		.vdd1v8(vdd1v8),
		.vss(vss),
		.vddio_q(vddio_q),
		.vssio_q(vssio_q),
		.analog_a(analog_a),
		.analog_b(analog_b),
		.io(mprj_io),
		.io_out(mprj_io_out),
		.oeb_n(mprj_io_oeb_n),
		.hldh_n(mprj_io_hldh_n),
		.enh(mprj_io_enh),
		.inp_dis(mprj_io_inp_dis),
		.ib_mode_sel(mprj_io_ib_mode_sel),
		.analog_en(mprj_io_analog_en),
		.analog_sel(mprj_io_analog_sel),
		.analog_pol(mprj_io_analog_pol),
		.dm(mprj_io_dm),
		.io_in(mprj_io_in)
	);

endmodule