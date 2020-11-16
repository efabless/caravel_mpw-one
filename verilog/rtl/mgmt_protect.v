`default_nettype none
/*----------------------------------------------------------------------*/
/* Buffers protecting the management region from the user region.	*/
/* This mainly consists of tristate buffers that are enabled by a	*/
/* "logic 1" output connected to the user's VCCD domain.  This ensures	*/
/* that the buffer is disabled and the output high-impedence when the	*/
/* user 1.8V supply is absent.						*/
/*----------------------------------------------------------------------*/
/* Because there is no tristate buffer with a non-inverted enable, a	*/
/* tristate inverter with non-inverted enable is used in series with	*/
/* another (normal) inverter.						*/
/*----------------------------------------------------------------------*/
/* For the sake of placement/routing, one conb (logic 1) cell is used	*/
/* for every buffer.							*/
/*----------------------------------------------------------------------*/

module mgmt_protect (
    inout	  vccd,
    inout	  vssd,
    inout	  vccd1,
    inout	  vssd1,
    inout	  vccd2,
    inout	  vssd2,
    inout	  vdda1,
    inout	  vssa1,
    inout	  vdda2,
    inout	  vssa2,

    input 	  caravel_clk,
    input 	  caravel_clk2,
    input	  caravel_rstn,
    input 	  mprj_cyc_o_core,
    input 	  mprj_stb_o_core,
    input         mprj_we_o_core,
    input [3:0]   mprj_sel_o_core,
    input [31:0]  mprj_adr_o_core,
    input [31:0]  mprj_dat_o_core,
    input [127:0] la_output_core,
    input [127:0] la_oen,

    output 	  user_clock,
    output 	  user_clock2,
    output 	  user_resetn,
    output 	  mprj_cyc_o_user,
    output 	  mprj_stb_o_user,
    output 	  mprj_we_o_user,
    output [3:0]  mprj_sel_o_user,
    output [31:0] mprj_adr_o_user,
    output [31:0] mprj_dat_o_user,
    output [127:0] la_data_in_mprj,
    output	  user1_vcc_powergood,
    output	  user2_vcc_powergood,
    output	  user1_vdd_powergood,
    output	  user2_vdd_powergood
);

	wire [74:0] mprj_logic1;
	wire mprj2_logic1;

	wire mprj_vdd_logic1_h;
	wire mprj2_vdd_logic1_h;
	wire mprj_vdd_logic1;
	wire mprj2_vdd_logic1;

	wire user1_vcc_powergood;
	wire user2_vcc_powergood;
	wire user1_vdd_powergood;
	wire user2_vdd_powergood;

        sky130_fd_sc_hd__conb_1 mprj_logic_high [74:0] (
                .VPWR(vccd1),
                .VGND(vssd1),
                .VPB(vccd1),
                .VNB(vssd1),
                .HI(mprj_logic1),
                .LO()
        );

        sky130_fd_sc_hd__conb_1 mprj2_logic_high (
                .VPWR(vccd2),
                .VGND(vssd2),
                .VPB(vccd2),
                .VNB(vssd2),
                .HI(mprj2_logic1),
                .LO()
        );

	// Logic high in the VDDA (3.3V) domains

        sky130_fd_sc_hvl__conb_1 mprj_logic_high_hvl (
                .VPWR(vdda1),
                .VGND(vssa1),
                .VPB(vdda1),
                .VNB(vssa1),
                .HI(mprj_vdd_logic1_h),
                .LO()
        );

        sky130_fd_sc_hvl__conb_1 mprj2_logic_high_hvl (
                .VPWR(vdda2),
                .VGND(vssa2),
                .VPB(vdda2),
                .VNB(vssa2),
                .HI(mprj2_vdd_logic1_h),
                .LO()
        );

	// Level shift the logic high signals into the 1.8V domain

	sky130_fd_sc_hvl__lsbufhv2lv mprj_logic_high_lv (
		.VPWR(vdda1),
		.VGND(vssd),
		.LVPWR(vccd),
		.VPB(vdda1),
		.VNB(vssd),
		.X(mprj_vdd_logic1),
		.A(mprj_vdd_logic1_h)
	);

	sky130_fd_sc_hvl__lsbufhv2lv mprj2_logic_high_lv (
		.VPWR(vdda2),
		.VGND(vssd),
		.LVPWR(vccd),
		.VPB(vdda2),
		.VNB(vssd),
		.X(mprj2_vdd_logic1),
		.A(mprj2_vdd_logic1_h)
	);

        sky130_fd_sc_hd__einvp_8 mprj_rstn_buf (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .Z(user_resetn),
                .A(~caravel_rstn),
                .TE(mprj_logic1[0])
        );

        sky130_fd_sc_hd__einvp_8 mprj_clk_buf (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .Z(user_clock),
                .A(~caravel_clk),
                .TE(mprj_logic1[1])
        );

        sky130_fd_sc_hd__einvp_8 mprj_clk2_buf (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .Z(user_clock2),
                .A(~caravel_clk2),
                .TE(mprj_logic1[2])
        );

        sky130_fd_sc_hd__einvp_8 mprj_cyc_buf (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .Z(mprj_cyc_o_user),
                .A(~mprj_cyc_o_core),
                .TE(mprj_logic1[3])
        );

        sky130_fd_sc_hd__einvp_8 mprj_stb_buf (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .Z(mprj_stb_o_user),
                .A(~mprj_stb_o_core),
                .TE(mprj_logic1[4])
        );

        sky130_fd_sc_hd__einvp_8 mprj_we_buf (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .Z(mprj_we_o_user),
                .A(~mprj_we_o_core),
                .TE(mprj_logic1[5])
        );

        sky130_fd_sc_hd__einvp_8 mprj_sel_buf [3:0] (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .Z(mprj_sel_o_user),
                .A(~mprj_sel_o_core),
                .TE(mprj_logic1[9:6])
        );

        sky130_fd_sc_hd__einvp_8 mprj_adr_buf [31:0] (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .Z(mprj_adr_o_user),
                .A(~mprj_adr_o_core),
                .TE(mprj_logic1[41:10])
        );

        sky130_fd_sc_hd__einvp_8 mprj_dat_buf [31:0] (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .Z(mprj_dat_o_user),
                .A(~mprj_dat_o_core),
                .TE(mprj_logic1[73:42])
        );

	/* The LA buffers are controlled from the user side, so	*/
	/* it is only necessary to make sure that the function	*/
	/* is inverting the OEB signal and using positive-sense	*/
	/* enable, so that the buffer is disabled on user-side	*/
	/* power-down of vccd1.					*/

        sky130_fd_sc_hd__einvp_8 la_buf [127:0] (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .Z(la_data_in_mprj),
                .A(~la_output_core),
                .TE(~la_oen)
        );

	/* The conb cell output is a resistive connection directly to	*/
	/* the power supply, so when returning the user1_powergood	*/
	/* signal, make sure that it is buffered properly.		*/

        sky130_fd_sc_hd__buf_8 mprj_pwrgood (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .A(mprj_logic1[74]),
                .X(user1_vcc_powergood)
	);

        sky130_fd_sc_hd__buf_8 mprj2_pwrgood (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .A(mprj2_logic1),
                .X(user2_vcc_powergood)
	);

        sky130_fd_sc_hd__buf_8 mprj_vdd_pwrgood (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .A(mprj_vdd_logic1),
                .X(user_vdd_powergood)
	);

        sky130_fd_sc_hd__buf_8 mprj2_vdd_pwrgood (
                .VPWR(vccd),
                .VGND(vssd),
                .VPB(vccd),
                .VNB(vssd),
                .A(mprj2_vdd_logic1),
                .X(user2_vdd_powergood)
	);
endmodule
