 
/* User area has R/W access for USER_BLOCKS and RO access for MGMT_BLOCKS 
   Management area has R/W access for MGMT_BLOCKS and RO access for USER_BLOCKS */

module storage #(
    parameter USER_BLOCKS = 4,  // R/W access
    parameter MGMT_BLOCKS = 2   // R/W access
) (
    // MGMT_AREA R/W Interface (MGMT_BLOCKS)
    input mgmt_clk,
    input [MGMT_BLOCKS-1:0] mgmt_ena, 
    input [MGMT_BLOCKS-1:0] mgmt_wen, // not shared 
    input [(MGMT_BLOCKS*4)-1:0] mgmt_wen_mask, // not shared 
    input [7:0] mgmt_addr,
    input [31:0] mgmt_wdata,
    output [(MGMT_BLOCKS*32)-1:0] mgmt_rdata,

    // MGMT_AREA RO Interface (USER_BLOCKS)
    input [USER_BLOCKS-1:0] mgmt_user_ena,
    input [7:0] mgmt_user_addr,
    output [(USER_BLOCKS*32)-1:0] mgmt_user_rdata,
    
    // USER_AREA R/W Interface (USER_BLOCKS)
    input user_clk,
    input [USER_BLOCKS-1:0] user_ena, 
    input [USER_BLOCKS-1:0] user_wen,
    input [(USER_BLOCKS*4)-1:0] user_wen_mask,
    input [7:0] user_addr,
    input [31:0] user_wdata,
    output [(USER_BLOCKS*32)-1:0] user_rdata,

    // USER_AREA RO Interface (MGMT_BLOCS)
    input [MGMT_BLOCKS-1:0] user_mgmt_ena,
    input [7:0] user_mgmt_addr,
    output  [(MGMT_BLOCKS*32)-1:0] user_mgmt_rdata
);

    sram_1rw1r_32_256_8_sky130 SRAM_0 [MGMT_BLOCKS-1:0] (
        // MGMT R/W port
        .clk0(mgmt_clk), 
        .csb0(mgmt_ena),   
        .web0(mgmt_wen),  
        .wmask0(mgmt_wen_mask),
        .addr0(mgmt_addr[7:0]),
        .din0(mgmt_wdata),
        .dout0(mgmt_rdata),
        // User RO port
        .clk1(user_clk),
        .csb1(user_mgmt_ena), 
        .addr1(user_mgmt_addr),
        .dout1(user_mgmt_rdata)
    );    

    sram_1rw1r_32_256_8_sky130 SRAM_1 [USER_BLOCKS-1:0](
        // User R/W port
        .clk0(user_clk), 
        .csb0(user_ena), 
        .web0(user_wen),
        .wmask0(user_wen_mask),
        .addr0(user_addr),
        .din0(user_wdata),
        .dout0(user_rdata),
        // MGMT RO port
        .clk1(mgmt_clk),
        .csb1(mgmt_user_ena),
        .addr1(mgmt_user_addr),
        .dout1(mgmt_user_rdata)
    );
    
endmodule