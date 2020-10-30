module storage_bridge_wb #(
    parameter USER_BLOCKS = 4, 
    parameter MGMT_BLOCKS = 2
) (
    // MGMT_AREA R/W WB Interface (#of WB Slaves = MGMT_BLOCKS )
    input wb_clk_i,
    input wb_rst_i,

    input [31:0] wb_adr_i,
    input [31:0] wb_dat_i,
    input [3:0]  wb_sel_i,
    input wb_we_i,
    input wb_cyc_i,
    input [1:0] wb_stb_i,
    output reg [1:0] wb_ack_o,
    output reg [31:0] wb_mgmt_dat_o,

    // MGMT_AREA RO WB Interface (USER_BLOCKS)  
    output reg [31:0] wb_user_dat_o,

    // MGMT Area native memory interface
    output [MGMT_BLOCKS-1:0] mgmt_ena, 
    output [(MGMT_BLOCKS*4)-1:0] mgmt_wen_mask,
    output [MGMT_BLOCKS-1:0] mgmt_wen,
    output [7:0] mgmt_addr,
    output [31:0] mgmt_wdata,
    input  [(MGMT_BLOCKS*32)-1:0] mgmt_rdata,

    // MGMT_AREA RO Interface (USER_BLOCKS)
    output [USER_BLOCKS-1:0] mgmt_user_ena,
    output [7:0] mgmt_user_addr,
    input  [(USER_BLOCKS*32)-1:0] mgmt_user_rdata
);

    localparam RAM_BLOCKS = USER_BLOCKS + MGMT_BLOCKS; 
    parameter [(RAM_BLOCKS*32)-1:0] BASE_ADDR = {
        // User partition
        {32'h 0700_0000},
        {32'h 0600_0000},
        {32'h 0500_0000},
        {32'h 0400_0000},
        {32'h 0300_0000},
        // MGMT partition
        {32'h 0200_0000},
        {32'h 0100_0000}
    };
    parameter ADR_MASK = 32'h FF00_0000;

    wire [1:0] valid;
    wire [1:0] wen;
    wire [7:0] wen_mask;

    assign valid = {2{wb_cyc_i}} & wb_stb_i;
    assign wen   = wb_we_i & valid;    
    assign wen_mask = wb_sel_i & {{4{wen[1]}}, {4{wen[0]}}};

    // Ack generation
    reg [1:0] wb_ack_read;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i == 1'b 1) begin
            wb_ack_read <= 2'b0;
            wb_ack_o <= 2'b0;
        end else begin
            wb_ack_o <= wb_we_i? (valid & ~wb_ack_o): wb_ack_read;
            wb_ack_read <= (valid & ~wb_ack_o) & ~wb_ack_read;
        end
    end
    
    // Address decoding
    wire [RAM_BLOCKS-1: 0] ram_sel;
    genvar iS;
    generate
        for (iS = 0; iS < RAM_BLOCKS; iS = iS + 1) begin
            assign ram_sel[iS] = 
                ((wb_adr_i & ADR_MASK) == BASE_ADDR[(iS+1)*32-1:iS*32]);
        end
    endgenerate

    // Management SoC interface
    assign mgmt_ena = valid[0] ? ~ram_sel[1:0] : {MGMT_BLOCKS{1'b1}}; 
    assign mgmt_wen = ~{MGMT_BLOCKS{wen[0]}};
    assign mgmt_wen_mask = {MGMT_BLOCKS{wen_mask[3:0]}};
    assign mgmt_addr = wb_adr_i[7:0];
    assign mgmt_wdata = wb_dat_i[31:0];

    wire [1:0] mgmt_sel = ram_sel[1:0];

    integer i;
    always @(*) begin
        wb_mgmt_dat_o = {32{1'b0}};
        for (i=0; i<(MGMT_BLOCKS*32); i=i+1)
            wb_mgmt_dat_o[i%32] = wb_mgmt_dat_o[i%32] | (mgmt_sel[i/32] & mgmt_rdata[i]);
    end

    // User Interface
    assign mgmt_user_ena = valid[1] ? ~ram_sel[5:2] : {USER_BLOCKS{1'b1}}; 
    assign mgmt_user_addr = wb_adr_i[7:0];
    
    wire [3:0] user_sel = ram_sel [5:2];

    integer j;
    always @(*) begin
        wb_user_dat_o = {32{1'b0}};
        for (j=0; j<(USER_BLOCKS*32); j=j+1)
            wb_user_dat_o[j%32] = wb_user_dat_o[j%32] | (user_sel[j/32] & mgmt_user_rdata[j]);
    end

endmodule