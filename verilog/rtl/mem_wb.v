module mem_wb (
    input wb_clk_i,
    input wb_rst_i,

    input [31:0] wb_adr_i,
    input [31:0] wb_dat_i,
    input [3:0] wb_sel_i,
    input wb_we_i,
    input wb_cyc_i,
    input wb_stb_i,

    output wb_ack_o,
    output [31:0] wb_dat_o
    
);
    wire valid;
    wire ram_wen;
    wire [3:0] wen; // write enable

    assign valid = wb_cyc_i & wb_stb_i;
    assign ram_wen = wb_we_i && valid;

    assign wen = wb_sel_i & {4{ram_wen}} ;

`ifndef USE_OPENRAM
    assign wb_ack_o = valid;
`else

    /*
        Ack Generation
            - write transaction: asserted upon receiving adr_i & dat_i 
            - read transaction : asserted one clock cycle after receiving the adr_i & dat_i
    */ 

    reg wb_ack_read;
    reg wb_ack_o;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i == 1'b 1) begin
            wb_ack_read <= 1'b0;
            wb_ack_o <= 1'b0;
        end else begin
            // wb_ack_read <= {2{valid}} & {1'b1, wb_ack_read[1]};
            wb_ack_o    <= wb_we_i? (valid & !wb_ack_o): wb_ack_read;
            wb_ack_read <= (valid & !wb_ack_o) & !wb_ack_read;
        end
    end

`endif

    soc_mem
`ifndef USE_OPENRAM
    #(.WORDS(`MEM_WORDS))
`endif
     mem (
        .clk(wb_clk_i),
        .ena(valid),
        .wen(wen),
        .addr(wb_adr_i[23:2]),
        .wdata(wb_dat_i),
        .rdata(wb_dat_o)
    );

endmodule

module soc_mem 
`ifndef USE_OPENRAM
#(
    parameter integer WORDS = 8192
)
`endif
 ( 
    input clk,
    input ena,
    input [3:0] wen,
    input [21:0] addr,
    input [31:0] wdata,
    output[31:0] rdata
);

`ifndef USE_OPENRAM
    reg [31:0] rdata;
    reg [31:0] mem [0:WORDS-1];

    always @(posedge clk) begin
        if (ena == 1'b1) begin
            rdata <= mem[addr];
            if (wen[0]) mem[addr][ 7: 0] <= wdata[ 7: 0];
            if (wen[1]) mem[addr][15: 8] <= wdata[15: 8];
            if (wen[2]) mem[addr][23:16] <= wdata[23:16];
            if (wen[3]) mem[addr][31:24] <= wdata[31:24];
        end
    end
`else
    
    /* Using Port 0 Only - Size: 1KB, 256x32 bits */
    //sram_1rw1r_32_256_8_scn4m_subm 
    sram_1rw1r_32_256_8_sky130 SRAM(
            .clk0(clk), 
            .csb0(~ena), 
            .web0(~|wen),
            .wmask0(wen),
            .addr0(addr[7:0]),
            .din0(wdata),
            .dout0(rdata)
      );

`endif

endmodule
