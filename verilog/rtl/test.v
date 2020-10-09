`define MPRJ1_IO_PAD_V(X,Y,Y_OUT,V,OUT_EN_N,HLD_N, ENH, INP_DIS, MODE_SEL, VTRIP_SEL, SLOW_SEL, HOLD_SEL, AN_EN, AN_SEL, AN_POL, MODE) \
	wire [V-1:0] loop1_``X; \
	s8iom0_gpiov2_pad  X``_pad [V-1:0] ( \
	`USER1_ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X),\
	`endif	\
		.out(Y_OUT),	\
		.oe_n(OUT_EN_N), \
		.hld_h_n(HLD_N),	\
		.enable_h(ENH), \
		.enable_inp_h(loop1_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vssa), \
		.enable_vddio(vccd), \
		.inp_dis(INP_DIS), \
		.ib_mode_sel(MODE_SEL), \
		.vtrip_sel(VTRIP_SEL), \
		.slow(SLOW_SEL),	\
		.hld_ovr(HOLD_SEL), \
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
		.tie_lo_esd(loop1_``X) )

`define MPRJ2_IO_PAD_V(X,Y,Y_OUT,V,OUT_EN_N,HLD_N, ENH, INP_DIS, MODE_SEL, VTRIP_SEL, SLOW_SEL, HOLD_SEL, AN_EN, AN_SEL, AN_POL, MODE) \
	wire [V-1:0] loop2_``X; \
	s8iom0_gpiov2_pad  X``_pad [V-1:0] ( \
	`USER2_ABUTMENT_PINS \
	`ifndef	TOP_ROUTING \
		.pad(X),\
	`endif	\
		.out(Y_OUT),	\
		.oe_n(OUT_EN_N), \
		.hld_h_n(HLD_N),	\
		.enable_h(ENH), \
		.enable_inp_h(loop2_``X), \
		.enable_vdda_h(porb_h), \
		.enable_vswitch_h(vssa), \
		.enable_vddio(vccd), \
		.inp_dis(INP_DIS), \
		.ib_mode_sel(MODE_SEL), \
		.vtrip_sel(VTRIP_SEL), \
		.slow(SLOW_SEL),	\
		.hld_ovr(HOLD_SEL), \
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
		.tie_lo_esd(loop2_``X) )
