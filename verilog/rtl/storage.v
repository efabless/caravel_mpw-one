`default_nettype none
 
module storage (
    // MGMT_AREA R/W Interface 
    input mgmt_clk,
    input [`RAM_BLOCKS-1:0] mgmt_ena, 
    input [`RAM_BLOCKS-1:0] mgmt_wen, // not shared 
    input [(`RAM_BLOCKS*4)-1:0] mgmt_wen_mask, // not shared 
    input [7:0] mgmt_addr,
    input [31:0] mgmt_wdata,
    output [(`RAM_BLOCKS*32)-1:0] mgmt_rdata,

    // MGMT_AREA RO Interface
    input mgmt_ena_ro,
    input [7:0] mgmt_addr_ro,
    output [31:0] mgmt_rdata_ro
);
    sram_1rw1r_32_256_8_sky130 SRAM_0 (
        // MGMT R/W port
        .clk0(mgmt_clk), 
        .csb0(mgmt_ena[0]),   
        .web0(mgmt_wen[0]),  
        .wmask0(mgmt_wen_mask[3:0]),
        .addr0(mgmt_addr),
        .din0(mgmt_wdata),
        .dout0(mgmt_rdata[31:0]),
        // MGMT RO port
        .clk1(mgmt_clk),
        .csb1(mgmt_ena_ro), 
        .addr1(mgmt_addr_ro),
        .dout1(mgmt_rdata_ro)
    ); 

    sram_1rw1r_32_256_8_sky130 SRAM_1 (
        // MGMT R/W port
        .clk0(mgmt_clk), 
        .csb0(mgmt_ena[1]),   
        .web0(mgmt_wen[1]),  
        .wmask0(mgmt_wen_mask[7:4]),
        .addr0(mgmt_addr),
        .din0(mgmt_wdata),
        .dout0(mgmt_rdata[63:32])
    );  

endmodule
`default_nettype wire
