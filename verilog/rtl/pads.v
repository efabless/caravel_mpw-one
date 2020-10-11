`ifndef TOP_ROUTING 
	`define USER1_ABUTMENT_PINS \
	.amuxbus_a(analog_a),\
	.amuxbus_b(analog_b),\
	.vssa(vssa1),\
	.vdda(vdda1),\
	.vswitch(vddio),\
	.vddio_q(vddio_q),\
	.vcchib(vccd),\
	.vddio(vddio),\
	.vccd(vccd1),\
	.vssio(vssio),\
	.vssd(vssd1),\
	.vssio_q(vssio_q),

	`define USER2_ABUTMENT_PINS \
	.amuxbus_a(analog_a),\
	.amuxbus_b(analog_b),\
	.vssa(vssa2),\
	.vdda(vdda2),\
	.vswitch(vddio),\
	.vddio_q(vddio_q),\
	.vcchib(vccd),\
	.vddio(vddio),\
	.vccd(vccd2),\
	.vssio(vssio),\
	.vssd(vssd2),\
	.vssio_q(vssio_q),

	`define MGMT_ABUTMENT_PINS \
	.amuxbus_a(analog_a),\
	.amuxbus_b(analog_b),\
	.vssa(vssa),\
	.vdda(vdda),\
	.vswitch(vddio),\
	.vddio_q(vddio_q),\
	.vcchib(vccd),\
	.vddio(vddio),\
	.vccd(vccd),\
	.vssio(vssio),\
	.vssd(vssa),\
	.vssio_q(vssio_q),
`else 
	`define USER1_ABUTMENT_PINS 
	`define USER2_ABUTMENT_PINS 
	`define MGMT_ABUTMENT_PINS 
`endif

`define HVCLAMP_PINS(H,L) \
	.drn_hvc(H), \
	.src_bdy_hvc(L)

`define LVCLAMP_PINS(H1,L1,H2,L2,L3) \
	.bdy2_b2b(L3), \
	.drn_lvc1(H1), \
	.drn_lvc2(H2), \
	.src_bdy_lvc1(L1), \
	.src_bdy_lvc2(L2)

`define INPUT_PAD(X,Y) \
	wire loop_``X; \
	s8iom0_gpiov2_pad X``_pad ( \
	`MGMT_ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X), \
	`endif	\
		.out(vssa),	\
		.oe_n(vccd), \
		.hld_h_n(vddio),	\
		.enable_h(porb_h), \
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vssa), \
		.enable_vddio(vccd), \
		.inp_dis(por), \
		.ib_mode_sel(vssa), \
		.vtrip_sel(vssa), \
		.slow(vssa),	\
		.hld_ovr(vssa), \
		.analog_en(vssa), \
		.analog_sel(vssa), \
		.analog_pol(vssa), \
		.dm({vssa, vssa, vccd}), \
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(Y), \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd(loop_``X) ) 

`define OUTPUT_PAD(X,Y,INP_DIS,OUT_EN_N) \
	wire loop_``X; \
	s8iom0_gpiov2_pad X``_pad ( \
	`MGMT_ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X), \
	`endif \
		.out(Y), \
		.oe_n(OUT_EN_N), \
		.hld_h_n(vddio), \
		.enable_h(porb_h),	\
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vssa), \
		.enable_vddio(vccd), \
		.inp_dis(INP_DIS), \
		.ib_mode_sel(vssa), \
		.vtrip_sel(vssa), \
		.slow(vssa),	\
		.hld_ovr(vssa), \
		.analog_en(vssa), \
		.analog_sel(vssa), \
		.analog_pol(vssa), \
		.dm({vccd, vccd, vssa}),	\
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(), \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd(loop_``X)) 

`define INOUT_PAD(X,Y,Y_OUT,INP_DIS,OUT_EN_N,MODE) \
	s8iom0_gpiov2_pad X``_pad ( \
	`MGMT_ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X),\
	`endif	\
		.out(Y_OUT),	\
		.oe_n(OUT_EN_N), \
		.hld_h_n(vddio),	\
		.enable_h(porb_h), \
		.enable_inp_h(loop_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vssa), \
		.enable_vddio(vccd), \
		.inp_dis(INP_DIS), \
		.ib_mode_sel(vssa), \
		.vtrip_sel(vssa), \
		.slow(vssa),	\
		.hld_ovr(vssa), \
		.analog_en(vssa), \
		.analog_sel(vssa), \
		.analog_pol(vssa), \
		.dm(MODE), \
		.pad_a_noesd_h(), \
		.pad_a_esd_0_h(), \
		.pad_a_esd_1_h(), \
		.in(Y),  \
		.in_h(), \
		.tie_hi_esd(), \
		.tie_lo_esd(loop_``X) )

