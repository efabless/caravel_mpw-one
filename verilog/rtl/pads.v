`ifndef TOP_ROUTING 
	`define USER1_ABUTMENT_PINS \
	.AMUXBUS_A(analog_a),\
	.AMUXBUS_B(analog_b),\
	.VSSA(vssa1),\
	.VDDA(vdda1),\
	.VSWITCH(vddio),\
	.VDDIO_Q(vddio_q),\
	.VCCHIB(vccd),\
	.VDDIO(vddio),\
	.VCCD(vccd1),\
	.VSSIO(vssio),\
	.VSSD(vssd1),\
	.VSSIO_Q(vssio_q),

	`define USER2_ABUTMENT_PINS \
	.AMUXBUS_A(analog_a),\
	.AMUXBUS_B(analog_b),\
	.VSSA(vssa2),\
	.VDDA(vdda2),\
	.VSWITCH(vddio),\
	.VDDIO_Q(vddio_q),\
	.VCCHIB(vccd),\
	.VDDIO(vddio),\
	.VCCD(vccd2),\
	.VSSIO(vssio),\
	.VSSD(vssd2),\
	.VSSIO_Q(vssio_q),

	`define MGMT_ABUTMENT_PINS \
	.AMUXBUS_A(analog_a),\
	.AMUXBUS_B(analog_b),\
	.VSSA(vssa),\
	.VDDA(vdda),\
	.VSWITCH(vddio),\
	.VDDIO_Q(vddio_q),\
	.VCCHIB(vccd),\
	.VDDIO(vddio),\
	.VCCD(vccd),\
	.VSSIO(vssio),\
	.VSSD(vssa),\
	.VSSIO_Q(vssio_q),
`else 
	`define USER1_ABUTMENT_PINS 
	`define USER2_ABUTMENT_PINS 
	`define MGMT_ABUTMENT_PINS 
`endif

`define HVCLAMP_PINS(H,L) \
	.DRN_HVC(H), \
	.SRC_BDY_HVC(L)

`define LVCLAMP_PINS(H1,L1,H2,L2,L3) \
	.BDY2_B2B(L3), \
	.DRN_LVC1(H1), \
	.DRN_LVC2(H2), \
	.SRC_BDY_LVC1(L1), \
	.SRC_BDY_LVC2(L2)

`define INPUT_PAD(X,Y) \
	wire loop_``X; \
	sky130_ef_io__gpiov2_pad X``_pad ( \
	`MGMT_ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.PAD(X), \
	`endif	\
		.OUT(vssa),	\
		.OE_N(vccd), \
		.HLD_H_N(vddio),	\
		.ENABLE_H(porb_h), \
		.ENABLE_INP_H(loop_``X), \
		.ENABLE_VDDA_H(porb_h), \
		.ENABLE_VSWITCH_H(vssa), \
		.ENABLE_VDDIO(vccd), \
		.INP_DIS(por), \
		.IB_MODE_SEL(vssa), \
		.VTRIP_SEL(vssa), \
		.SLOW(vssa),	\
		.HLD_OVR(vssa), \
		.ANALOG_EN(vssa), \
		.ANALOG_SEL(vssa), \
		.ANALOG_POL(vssa), \
		.DM({vssa, vssa, vccd}), \
		.PAD_A_NOESD_H(), \
		.PAD_A_ESD_0_H(), \
		.PAD_A_ESD_1_H(), \
		.IN(Y), \
		.IN_H(), \
		.TIE_HI_ESD(), \
		.TIE_LO_ESD(loop_``X) ) 

`define OUTPUT_PAD(X,Y,INPUT_DIS,OUT_EN_N) \
	wire loop_``X; \
	sky130_ef_io__gpiov2_pad X``_pad ( \
	`MGMT_ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.PAD(X), \
	`endif \
		.OUT(Y), \
		.OE_N(OUT_EN_N), \
		.HLD_H_N(vddio), \
		.ENABLE_H(porb_h),	\
		.ENABLE_INP_H(loop_``X), \
		.ENABLE_VDDA_H(porb_h), \
		.ENABLE_VSWITCH_H(vssa), \
		.ENABLE_VDDIO(vccd), \
		.INP_DIS(INPUT_DIS), \
		.IB_MODE_SEL(vssa), \
		.VTRIP_SEL(vssa), \
		.SLOW(vssa),	\
		.HLD_OVR(vssa), \
		.ANALOG_EN(vssa), \
		.ANALOG_SEL(vssa), \
		.ANALOG_POL(vssa), \
		.DM({vccd, vccd, vssa}),	\
		.PAD_A_NOESD_H(), \
		.PAD_A_ESD_0_H(), \
		.PAD_A_ESD_1_H(), \
		.IN(), \
		.IN_H(), \
		.TIE_HI_ESD(), \
		.TIE_LO_ESD(loop_``X)) 

`define INOUT_PAD(X,Y,Y_OUT,INPUT_DIS,OUT_EN_N,MODE) \
	sky130_ef_io__gpiov2_pad X``_pad ( \
	`MGMT_ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.PAD(X),\
	`endif	\
		.OUT(Y_OUT),	\
		.OE_N(OUT_EN_N), \
		.HLD_H_N(vddio),	\
		.ENABLE_H(porb_h), \
		.ENABLE_INP_H(loop_``X), \
		.ENABLE_VDDA_H(porb_h), \
		.ENABLE_VSWITCH_H(vssa), \
		.ENABLE_VDDIO(vccd), \
		.INP_DIS(INPUT_DIS), \
		.IB_MODE_SEL(vssa), \
		.VTRIP_SEL(vssa), \
		.SLOW(vssa),	\
		.HLD_OVR(vssa), \
		.ANALOG_EN(vssa), \
		.ANALOG_SEL(vssa), \
		.ANALOG_POL(vssa), \
		.DM(MODE), \
		.PAD_A_NOESD_H(), \
		.PAD_A_ESD_0_H(), \
		.PAD_A_ESD_1_H(), \
		.IN(Y),  \
		.IN_H(), \
		.TIE_HI_ESD(), \
		.TIE_LO_ESD(loop_``X) )

