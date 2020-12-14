module mprj_logic_high (
`ifdef USE_POWER_PINS
    inout	   vccd1,
    inout	   vssd1,
`endif
    output [458:0] HI
);
sky130_fd_sc_hd__conb_1 insts [458:0] (
`ifdef USE_POWER_PINS
                .VPWR(vccd1),
                .VGND(vssd1),
                .VPB(vccd1),
                .VNB(vssd1),
`endif
                .HI(HI),
                .LO()
        );
endmodule
