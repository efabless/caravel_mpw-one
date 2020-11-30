module sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped (
	X    ,
	A    ,
`ifdef USE_POWER_PINS
	VPWR ,
	VGND ,
	LVPWR,
	VPB  ,
	VNB
`endif
);

output X    ;
input  A    ;
`ifdef USE_POWER_PINS
input  VPWR ;
input  VGND ;
input  LVPWR;
input  VPB  ;
input  VNB  ;
`endif

sky130_fd_sc_hvl__lsbufhv2lv_1 lvlshiftdown (
`ifdef USE_POWER_PINS
	.VPWR(VPWR),
	.VPB(VPB),
	.LVPWR(LVPWR),
	.VNB(VNB),
	.VGND(VGND),
`endif
	.A(A),
	.X(X)
);

endmodule
