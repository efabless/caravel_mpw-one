module mprj_io #(
    parameter AREA1PADS = 18	// Highest numbered pad in area 1
) (
    inout vddio,
    inout vssio,
    inout vdda,
    inout vssa,
    inout vccd,
    inout vssd,

    inout vdda1,
    inout vdda2,
    inout vssa1,
    inout vssa2,
    inout vccd1,
    inout vccd2,
    inout vssd1,
    inout vssd2,

    input vddio_q,
    input vssio_q,
    input analog_a,
    input analog_b,
    input porb_h,
    input por,
    inout [`MPRJ_IO_PADS-1:0] io,
    input [`MPRJ_IO_PADS-1:0] io_out,
    input [`MPRJ_IO_PADS-1:0] oeb,
    input [`MPRJ_IO_PADS-1:0] hldh_n,
    input [`MPRJ_IO_PADS-1:0] enh,
    input [`MPRJ_IO_PADS-1:0] inp_dis,
    input [`MPRJ_IO_PADS-1:0] ib_mode_sel,
    input [`MPRJ_IO_PADS-1:0] vtrip_sel,
    input [`MPRJ_IO_PADS-1:0] slow_sel,
    input [`MPRJ_IO_PADS-1:0] holdover,
    input [`MPRJ_IO_PADS-1:0] analog_en,
    input [`MPRJ_IO_PADS-1:0] analog_sel,
    input [`MPRJ_IO_PADS-1:0] analog_pol,
    input [`MPRJ_IO_PADS*3-1:0] dm,
    output [`MPRJ_IO_PADS-1:0] io_in
);

    wire [`MPRJ_IO_PADS-1:0] loop1_io;

    s8iom0_gpiov2_pad  area1_io_pad [AREA1PADS - 1:0] (
	`USER1_ABUTMENT_PINS
	`ifndef	TOP_ROUTING
	    .pad(io[AREA1PADS - 1:0]),
	`endif
	    .out(io_out[AREA1PADS - 1:0]),
	    .oe_n(oeb[AREA1PADS - 1:0]),
	    .hld_h_n(hldh_n[AREA1PADS - 1:0]),
	    .enable_h(enh[AREA1PADS - 1:0]),
	    .enable_inp_h(loop1_io[AREA1PADS - 1:0]),
	    .enable_vdda_h(porb_h),
	    .enable_vswitch_h(vssa),
	    .enable_vddio(vccd),
	    .inp_dis(inp_dis[AREA1PADS - 1:0]),
	    .ib_mode_sel(ib_mode_sel[AREA1PADS - 1:0]),
	    .vtrip_sel(vtrip_sel[AREA1PADS - 1:0]),
	    .slow(slow_sel[AREA1PADS - 1:0]),
	    .hld_ovr(holdover[AREA1PADS - 1:0]),
	    .analog_en(analog_en[AREA1PADS - 1:0]),
	    .analog_sel(analog_sel[AREA1PADS - 1:0]),
	    .analog_pol(analog_pol[AREA1PADS - 1:0]),
	    .dm(dm[AREA1PADS*3 - 1:0]),
	    .pad_a_noesd_h(),
	    .pad_a_esd_0_h(),
	    .pad_a_esd_1_h(),
	    .in(io_in[AREA1PADS - 1:0]),
	    .in_h(),
	    .tie_hi_esd(),
	    .tie_lo_esd(loop1_io[AREA1PADS - 1:0])
    );

    s8iom0_gpiov2_pad area2_io_pad [`MPRJ_IO_PADS - AREA1PADS - 1:0] (
	`USER2_ABUTMENT_PINS
	`ifndef	TOP_ROUTING
	    .pad(io[`MPRJ_IO_PADS - AREA1PADS - 1:0]),
	`endif
	    .out(io_out[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .oe_n(oeb[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .hld_h_n(hldh_n[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .enable_h(enh[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .enable_inp_h(loop1_io[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .enable_vdda_h(porb_h),
	    .enable_vswitch_h(vssa),
	    .enable_vddio(vccd),
	    .inp_dis(inp_dis[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .ib_mode_sel(ib_mode_sel[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .vtrip_sel(vtrip_sel[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .slow(slow_sel[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .hld_ovr(holdover[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .analog_en(analog_en[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .analog_sel(analog_sel[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .analog_pol(analog_pol[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .dm(dm[`MPRJ_IO_PADS*3 - 1:AREA1PADS*3]),
	    .pad_a_noesd_h(),
	    .pad_a_esd_0_h(),
	    .pad_a_esd_1_h(),
	    .in(io_in[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .in_h(),
	    .tie_hi_esd(),
	    .tie_lo_esd(loop1_io[`MPRJ_IO_PADS - 1:AREA1PADS])
    );

endmodule
