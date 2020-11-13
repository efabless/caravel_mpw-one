module simple_por (porb_h,
    vdd3v3,
    vss);
 output porb_h;
 input vdd3v3;
 input vss;

 sky130_fd_sc_hvl__conb_1 _1_ (.LO(_0_));
 sky130_fd_sc_hvl__schmittbuf_1 hystbuf1 (.A(_0_),
    .X(mid));
 sky130_fd_sc_hvl__schmittbuf_1 hystbuf2 (.A(mid),
    .X(porb_h));
endmodule
