module simple_por (porb_h,
    vdd3v3,
    vss,
    VPWR,
    VGND);
 output porb_h;
 input vdd3v3;
 input vss;
 input VPWR;
 input VGND;

 sky130_fd_sc_hvl__conb_1 _1_ (.LO(_0_));
 sky130_fd_sc_hvl__schmittbuf_1 hystbuf1 (.A(_0_),
    .X(mid));
 sky130_fd_sc_hvl__schmittbuf_1 hystbuf2 (.A(mid),
    .X(porb_h));
 sky130_fd_sc_hvl__decap_4 FILLER_0_0 ();
 sky130_fd_sc_hvl__fill_2 FILLER_0_4 ();
 sky130_fd_sc_hvl__fill_1 FILLER_0_6 ();
 sky130_fd_sc_hvl__decap_8 FILLER_0_12 ();
 sky130_fd_sc_hvl__decap_4 FILLER_0_20 ();
 sky130_fd_sc_hvl__fill_2 FILLER_0_24 ();
 sky130_fd_sc_hvl__fill_1 FILLER_0_26 ();
 sky130_fd_sc_hvl__decap_4 FILLER_1_0 ();
 sky130_fd_sc_hvl__decap_8 FILLER_1_15 ();
 sky130_fd_sc_hvl__decap_4 FILLER_1_23 ();
 sky130_fd_sc_hvl__decap_4 FILLER_2_0 ();
 sky130_fd_sc_hvl__decap_8 FILLER_2_15 ();
 sky130_fd_sc_hvl__decap_4 FILLER_2_23 ();
endmodule
