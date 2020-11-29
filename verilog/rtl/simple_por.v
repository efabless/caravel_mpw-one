`default_nettype none
`timescale 1 ns / 1 ps

module simple_por(
`ifdef USE_POWER_PINS
    inout vdd3v3,
    inout vdd1v8,
    inout vss,
`endif
    output porb_h,
    output porb_l,
    output por_l
);

    wire mid, porb_h;
    reg inode;

    // This is a behavioral model!  Actual circuit is a resitor dumping
    // current (slowly) from vdd3v3 onto a capacitor, and this fed into
    // two schmitt triggers for strong hysteresis/glitch tolerance.

    initial begin
	inode <= 1'b0; 
    end 

    // Emulate current source on capacitor as a 500ns delay either up or
    // down.  Note that this is sped way up for verilog simulation;  the
    // actual circuit is set to a 15ms delay.

    always @(posedge vdd3v3) begin
	#500 inode <= 1'b1;
    end
    always @(negedge vdd3v3) begin
	#500 inode <= 1'b0;
    end

    // Instantiate two shmitt trigger buffers in series

    sky130_fd_sc_hvl__schmittbuf_1 hystbuf1 (
`ifdef USE_POWER_PINS
	.VPWR(vdd3v3),
	.VGND(vss),
	.VPB(vdd3v3),
	.VNB(vss),
`endif
	.A(inode),
	.X(mid)
    );

    sky130_fd_sc_hvl__schmittbuf_1 hystbuf2 (
`ifdef USE_POWER_PINS
	.VPWR(vdd3v3),
	.VGND(vss),
	.VPB(vdd3v3),
	.VNB(vss),
`endif
	.A(mid),
	.X(porb_h)
    );

    sky130_fd_sc_hvl__lsbufhv2lv_1 porb_level (
`ifdef USE_POWER_PINS
	.VPWR(vdd3v3),
	.VPB(vdd3v3),
	.LVPWR(vdd1v8),
	.VNB(vss),
	.VGND(vss),
`endif
	.A(porb_h),
	.X(porb_l)
    );

    // since this is behavioral anyway, but this should be
    // replaced by a proper inverter
    assign por_l = ~porb_l;
endmodule
`default_nettype wire
