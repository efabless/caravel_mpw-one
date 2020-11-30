module mgmt_protect_hv (mprj2_vdd_logic1,
    mprj_vdd_logic1,
    VPWR,
    VGND);
 output mprj2_vdd_logic1;
 output mprj_vdd_logic1;
 input VPWR;
 input VGND;

 sky130_fd_sc_hvl__conb_1 mprj2_logic_high_hvl (.HI(mprj2_vdd_logic1_h),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hvl__lsbufhv2lv_1 mprj2_logic_high_lv (.A(mprj2_vdd_logic1_h),
    .X(mprj2_vdd_logic1),
    .LVPWR(VPWR),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hvl__conb_1 mprj_logic_high_hvl (.HI(mprj_vdd_logic1_h),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hvl__lsbufhv2lv_1 mprj_logic_high_lv (.A(mprj_vdd_logic1_h),
    .X(mprj_vdd_logic1),
    .LVPWR(VPWR),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
endmodule
