module chip_io(
	// Package Pins
	inout  vdd3v3,
    	inout  vdd1v8,
    	inout  vss,
	inout  gpio,
	input  clock,
	input  resetb,
	output flash_csb,
	output flash_clk,
	inout  flash_io0,
	inout  flash_io1,
	// Chip Core Interface
	input  porb_h,
	output resetb_core_h,
	output clock_core,
	input  gpio_out_core,
    	output gpio_in_core,
    	input  gpio_mode0_core,
    	input  gpio_mode1_core,
    	input  gpio_outenb_core,
    	input  gpio_inenb_core,
	input  flash_csb_core,
	input  flash_clk_core,
	input  flash_csb_oeb_core,
	input  flash_clk_oeb_core,
	input  flash_io0_oeb_core,
	input  flash_io1_oeb_core,
	input  flash_csb_ieb_core,
	input  flash_clk_ieb_core,
	input  flash_io0_ieb_core,
	input  flash_io1_ieb_core,
	input  flash_io0_do_core,
	input  flash_io1_do_core,
	output flash_io0_di_core,
	output flash_io1_di_core,
	// porbh, returned to the I/O level shifted down and inverted
	input  por,
	// Mega-project IOs
	inout [`MPRJ_IO_PADS-1:0] mprj_io,
	input [`MPRJ_IO_PADS-1:0] mprj_io_out,
	input [`MPRJ_IO_PADS-1:0] mprj_io_oeb,
    	input [`MPRJ_IO_PADS-1:0] mprj_io_hldh_n,
	input [`MPRJ_IO_PADS-1:0] mprj_io_enh,
    	input [`MPRJ_IO_PADS-1:0] mprj_io_inp_dis,
    	input [`MPRJ_IO_PADS-1:0] mprj_io_ib_mode_sel,
    	input [`MPRJ_IO_PADS-1:0] mprj_io_vtrip_sel,
    	input [`MPRJ_IO_PADS-1:0] mprj_io_slow_sel,
    	input [`MPRJ_IO_PADS-1:0] mprj_io_holdover,
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

	wire [2:0] dm_all =
    		{gpio_mode1_core, gpio_mode1_core, gpio_mode0_core};
	wire[2:0] flash_io0_mode = 
		{flash_io0_ieb_core, flash_io0_ieb_core, flash_io0_oeb_core};
	wire[2:0] flash_io1_mode = 
		{flash_io1_ieb_core, flash_io1_ieb_core, flash_io1_oeb_core};

    	// GPIO pad
	`INOUT_PAD(
		gpio, gpio_in_core, gpio_out_core,
		gpio_inenb_core, gpio_outenb_core, dm_all);
	
	// Flash pads
	`INOUT_PAD(
		flash_io0, flash_io0_di_core, flash_io0_do_core,
		flash_io0_ieb_core, flash_io0_oeb_core, flash_io0_mode);
	`INOUT_PAD(
		flash_io1, flash_io1_di_core, flash_io1_do_core,
		flash_io1_ieb_core, flash_io1_oeb_core, flash_io1_mode);

	`INPUT_PAD(clock, clock_core); 	    

	// Output Pads
	`OUTPUT_PAD(flash_csb, flash_csb_core, flash_csb_ieb_core, flash_csb_oeb_core);  
	`OUTPUT_PAD(flash_clk, flash_clk_core, flash_clk_ieb_core, flash_clk_oeb_core);


	// NOTE:  The analog_out pad from the raven chip has been replaced by
    	// the digital reset input resetb on caravel due to the lack of an on-board
    	// power-on-reset circuit.  The XRES pad is used for providing a glitch-
    	// free reset.
	s8iom0s8_top_xres4v2 resetb_pad (
		`ABUTMENT_PINS 
		`ifndef	TOP_ROUTING
		    .pad(resetb),
		`endif
		.tie_weak_hi_h(xresloop),   // Loop-back connection to pad through pad_a_esd_h
		.tie_hi_esd(),
		.tie_lo_esd(),
		.pad_a_esd_h(xresloop),
		.xres_h_n(resetb_core_h),
		.disable_pullup_h(vss),	    // 0 = enable pull-up on reset pad
		.enable_h(vdd3v3),	    // Power-on-reset to the power-on-reset input??
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
		.vddio(vdd3v3),
		.vddio_q(vddio_q),
		.vssio_q(vssio_q),
		.amuxbus_a(analog_a),
		.amuxbus_b(analog_b),
		.vssd(vss),
		.vssa(vss),
		.vswitch(vdd3v3),
		.vdda(vdd3v3),
		.vccd(vdd1v8),
		.vcchib(vdd1v8)
    	    );
	`endif

	mprj_io mprj_pads(
		.vdd3v3(vdd3v3),
		.vdd1v8(vdd1v8),
		.vss(vss),
		.vddio_q(vddio_q),
		.vssio_q(vssio_q),
		.analog_a(analog_a),
		.analog_b(analog_b),
		.porb_h(porb_h),
		.por(por),
		.io(mprj_io),
		.io_out(mprj_io_out),
		.oeb(mprj_io_oeb),
		.hldh_n(mprj_io_hldh_n),
		.enh(mprj_io_enh),
		.inp_dis(mprj_io_inp_dis),
		.ib_mode_sel(mprj_io_ib_mode_sel),
		.vtrip_sel(mprj_io_vtrip_sel),
		.holdover(mprj_io_holdover),
		.slow_sel(mprj_io_slow_sel),
		.analog_en(mprj_io_analog_en),
		.analog_sel(mprj_io_analog_sel),
		.analog_pol(mprj_io_analog_pol),
		.dm(mprj_io_dm),
		.io_in(mprj_io_in)
	);

endmodule
