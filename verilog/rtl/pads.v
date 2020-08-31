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

`define INPUT_PAD(X,Y) \
	wire loop_``X; \
	s8iom0_gpiov2_pad X``_pad ( \
	`ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X), \
	`endif	\
		.out(vss),	\
		.oe_n(vdd1v8), \
		.hld_h_n(vdd),	\
		.enable_h(porb_h), \
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vss), \
		.enable_vddio(vdd1v8), \
		.inp_dis(por), \
		.ib_mode_sel(vss), \
		.vtrip_sel(vss), \
		.slow(vss),	\
		.hld_ovr(vss), \
		.analog_en(vss), \
		.analog_sel(vss), \
		.analog_pol(vss), \
		.dm({vss, vss, vdd1v8}), \
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(Y), \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd(loop_``X) ) 

`define INPUT_PAD_ANALOG(X,SEL,POL) \
	wire loop_``X; \
	s8iom0_gpiov2_pad X``_pad ( \
	`ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X), \
	`endif	\
		.out(vss),	\
		.oe_n(vdd1v8), \
		.hld_h_n(vdd),	\
		.enable_h(porb_h), \
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vss), \
		.enable_vddio(vdd1v8), \
		.inp_dis(vdd1v8), \
		.ib_mode_sel(vss), \
		.vtrip_sel(vss), \
		.slow(vss),	\
		.hld_ovr(vss), \
		.analog_en(vdd1v8), \
		.analog_sel(SEL), \
		.analog_pol(POL), \
		.dm({vss, vss, vss}), \
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(), \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd() ) 

`define INPUT_PAD_V(X,Y,V) \
	wire [V-1:0] loop_``X; \
	s8iom0_gpiov2_pad X``_pad [V-1:0] ( \
	`ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X),\
	`endif	\
		.out(),	\
		.oe_n(vdd1v8), \
		.hld_h_n(vdd),	\
		.enable_h(vdd), \
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(vdd), \
		.enable_vswitch_h(vss), \
		.enable_vddio(vdd1v8), \
		.inp_dis(por), \
		.ib_mode_sel(vss), \
		.vtrip_sel(vss), \
		.slow(vss),	\
		.hld_ovr(vss), \
		.analog_en(vss), \
		.analog_sel(vss), \
		.analog_pol(vss), \
		.dm({vss, vss, vdd1v8}), \
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(Y),  \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd(loop_``X) )
	
`define OUTPUT_PAD(X,Y,INP_DIS,OUT_EN_N) \
	wire loop_``X; \
	s8iom0_gpiov2_pad X``_pad ( \
	`ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X), \
	`endif \
		.out(Y), \
		.oe_n(OUT_EN_N), \
		.hld_h_n(vdd), \
		.enable_h(porb_h),	\
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vss), \
		.enable_vddio(vdd1v8), \
		.inp_dis(INP_DIS), \
		.ib_mode_sel(vss), \
		.vtrip_sel(vss), \
		.slow(vss),	\
		.hld_ovr(vss), \
		.analog_en(vss), \
		.analog_sel(vss), \
		.analog_pol(vss), \
		.dm({vdd1v8, vdd1v8, vss}),	\
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(), \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd(loop_``X)) 

`define INOUT_PAD_V(X,Y,Y_OUT,V,INP_DIS,OUT_EN_N,MODE) \
	wire [V-1:0] loop_``X; \
	s8iom0_gpiov2_pad X``_pad [V-1:0] ( \
	`ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X),\
	`endif	\
		.out(Y_OUT),	\
		.oe_n(OUT_EN_N), \
		.hld_h_n(vdd),	\
		.enable_h(porb_h), \
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vss), \
		.enable_vddio(vdd1v8), \
		.inp_dis(INP_DIS), \
		.ib_mode_sel(vss), \
		.vtrip_sel(vss), \
		.slow(vss),	\
		.hld_ovr(vss), \
		.analog_en(vss), \
		.analog_sel(vss), \
		.analog_pol(vss), \
		.dm(MODE), \
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(Y),  \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd(loop_``X) )

`define INOUT_PAD(X,Y,Y_OUT,INP_DIS,OUT_EN_N,MODE) \
	s8iom0_gpiov2_pad X``_pad ( \
	`ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X),\
	`endif	\
		.out(Y_OUT),	\
		.oe_n(OUT_EN_N), \
		.hld_h_n(vdd),	\
		.enable_h(porb_h), \
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vss), \
		.enable_vddio(vdd1v8), \
		.inp_dis(INP_DIS), \
		.ib_mode_sel(vss), \
		.vtrip_sel(vss), \
		.slow(vss),	\
		.hld_ovr(vss), \
		.analog_en(vss), \
		.analog_sel(vss), \
		.analog_pol(vss), \
		.dm(MODE), \
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(Y),  \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd(loop_``X) )

`define MPRJ_IO_PAD_V(X,Y,Y_OUT,V,OUT_EN_N,HLD_N, ENH, INP_DIS, MODE_SEL, AN_EN, AN_SEL, AN_POL, MODE) \
	wire [V-1:0] loop_``X; \
	s8iom0_gpiov2_pad  X``_pad [V-1:0] ( \
	`ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X),\
	`endif	\
		.out(Y_OUT),	\
		.oe_n(OUT_EN_N), \
		.hld_h_n(HLD_N),	\
		.enable_h(ENH), \
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vss), \
		.enable_vddio(vdd1v8), \
		.inp_dis(INP_DIS), \
		.ib_mode_sel(MODE_SEL), \
		.vtrip_sel(vss), \
		.slow(vss),	\
		.hld_ovr(vss), \
		.analog_en(AN_EN), \
		.analog_sel(AN_SEL), \
		.analog_pol(AN_POL), \
		.dm(MODE), \
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(Y),  \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd(loop_``X) )

`define I2C_RX(X,Y) \
	wire loop_``X; \
	s8iom0s8_top_gpio_ovtv2 X``_pad ( \
	`ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X), \
	`endif \
		.out(vss), \
		.oe_n(vdd1v8), \
		.hld_h_n(vdd), \
		.enable_h(porb_h), \
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vddio(vdd1v8), \
		.enable_vswitch_h(vss), \
		.inp_dis(por), \
		.vtrip_sel(vss), \
		.hys_trim(vdd1v8), \
		.slow(vss), \
		.slew_ctl({vss, vss}), \	// 2 bits
		.hld_ovr(vss), \
		.analog_en(vss), \
		.analog_sel(vss), \
		.analog_pol(vss), \
		.dm({vss, vss, vdd1v8}), \		// 3 bits
		.ib_mode_sel({vss, vss}), \	// 2 bits
		.vinref(vdd1v8), \
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(Y), \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd() )

`define I2C_TX(X,Y) \
	wire loop_``X; \
	s8iom0s8_top_gpio_ovtv2 X``_pad ( \
	`ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X), \
	`endif \
		.out(Y), \
		.oe_n(vss), \
		.hld_h_n(vdd), \
		.enable_h(porb_h), \
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vddio(vdd1v8), \
		.enable_vswitch_h(vss), \
		.inp_dis(vdd1v8), \
		.vtrip_sel(vss), \
		.hys_trim(vdd1v8), \
		.slow(vss), \
		.slew_ctl({vss, vss}), \	// 2 bits
		.hld_ovr(vss), \
		.analog_en(vss), \
		.analog_sel(vss), \
		.analog_pol(vss), \
		.dm({vdd1v8, vdd1v8, vss}),	\	// 3 bits
		.ib_mode_sel({vss, vss}), \	// 2 bits
		.vinref(vdd1v8), \
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(), \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd())
