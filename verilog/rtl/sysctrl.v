module sysctrl_wb #(
    parameter BASE_ADR      = 32'h2F00_0000,
    parameter PLL_OUT       = 8'h0c,
    parameter TRAP_OUT      = 8'h10,
    parameter IRQ7_SRC      = 8'h14
) (
    input wb_clk_i,
    input wb_rst_i,

    input [31:0] wb_dat_i,
    input [31:0] wb_adr_i,
    input [3:0] wb_sel_i,
    input wb_cyc_i,
    input wb_stb_i,
    input wb_we_i,

    output [31:0] wb_dat_o,
    output wb_ack_o,
    
    output pll_output_dest,
    output trap_output_dest,
    output irq_7_inputsrc

);

    wire resetn;
    wire valid;
    wire ready;
    wire [3:0] iomem_we;

    assign resetn = ~wb_rst_i;
    assign valid = wb_stb_i && wb_cyc_i; 

    assign iomem_we = wb_sel_i & {4{wb_we_i}};
    assign wb_ack_o = ready;
    
    sysctrl #(
        .BASE_ADR(BASE_ADR),
        .PLL_OUT(PLL_OUT),
        .TRAP_OUT(TRAP_OUT),
        .IRQ7_SRC(IRQ7_SRC)
    ) sysctrl (
        .clk(wb_clk_i),
        .resetn(resetn),
        
        .iomem_addr(wb_adr_i),
        .iomem_valid(valid),
        .iomem_wstrb(iomem_we),
        .iomem_wdata(wb_dat_i),
        .iomem_rdata(wb_dat_o),
        .iomem_ready(ready),
        
        .pll_output_dest(pll_output_dest),
        .trap_output_dest(trap_output_dest), 
    
        .irq_7_inputsrc(irq_7_inputsrc)
    );

endmodule

module sysctrl #(
    parameter BASE_ADR = 32'h2300_0000,
    parameter PLL_OUT       = 8'h0c,
    parameter TRAP_OUT      = 8'h10,
    parameter IRQ7_SRC      = 8'h14
) (
    input clk,
    input resetn,
    
    input [31:0] iomem_addr,
    input iomem_valid,
    input [3:0] iomem_wstrb,
    input [31:0] iomem_wdata,
    output reg [31:0] iomem_rdata,
    output reg iomem_ready,

    output pll_output_dest,
    output trap_output_dest,
    output irq_7_inputsrc
); 

    reg pll_output_dest;
    reg trap_output_dest;
    reg irq_7_inputsrc;

    assign pll_out_sel  = (iomem_addr[7:0] == PLL_OUT);
    assign trap_out_sel = (iomem_addr[7:0] == TRAP_OUT);

    assign irq7_sel  = (iomem_addr[7:0] == IRQ7_SRC);

    always @(posedge clk) begin
        if (!resetn) begin
            pll_output_dest <= 0;
            trap_output_dest <= 0;
            irq_7_inputsrc <= 0;
        end else begin
            iomem_ready <= 0;
            if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
                iomem_ready <= 1'b 1;
                
                if (pll_out_sel) begin
                    iomem_rdata <= {31'd0, pll_output_dest};
                    if (iomem_wstrb[0])
                        pll_output_dest <= iomem_wdata[0];

                end else if (trap_out_sel) begin
                    iomem_rdata <= {31'd0, trap_output_dest};
                    if (iomem_wstrb[0]) 
                        trap_output_dest <= iomem_wdata[0];

                end else if (irq7_sel) begin
                    iomem_rdata <= {31'd0, irq_7_inputsrc};
                    if (iomem_wstrb[0])
                        irq_7_inputsrc <= iomem_wdata[0];

                end
            end
        end
    end

endmodule
