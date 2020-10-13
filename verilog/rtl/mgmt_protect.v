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
    output [127:0] la_data_in_mprj
);

	wire [73:0] mprj_logic1;

        sky130_fd_sc_hd__conb_1 mprj_logic_high [73:0] (
                .VPWR(vccd1),
                .VGND(vssd1),
                .VPB(vccd1),
                .VNB(vssd1),
                .HI(mprj_logic1),
                .LO()
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

endmodule
