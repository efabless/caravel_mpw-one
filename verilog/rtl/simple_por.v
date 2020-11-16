`default_nettype none
`timescale 1 ns / 1 ps

module simple_por(
    input vdd3v3,
    input vss,
    output porb_h
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
    // down.

    always @(posedge vdd3v3) begin
	#500 inode <= 1'b1;
    end
    always @(negedge vdd3v3) begin
	#500 inode <= 1'b0;
    end

    // Instantiate two shmitt trigger buffers in series

    sky130_fd_sc_hvl__schmittbuf hystbuf1 (
	.VPWR(vdd3v3),
	.VGND(vss),
	.VPB(vdd3v3),
	.VNB(vss),
	.A(inode),
	.X(mid)
    );

    sky130_fd_sc_hvl__schmittbuf hystbuf2 (
	.VPWR(vdd3v3),
	.VGND(vss),
	.VPB(vdd3v3),
	.VNB(vss),
	.A(mid),
	.X(porb_h)
    );

endmodule
