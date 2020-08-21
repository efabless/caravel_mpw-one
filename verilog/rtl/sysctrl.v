module sysctrl_wb #(
    parameter BASE_ADR      = 32'h2F00_0000,
    parameter OSC_ENA       = 8'h00,
    parameter OSC_OUT       = 8'h04,
    parameter XTAL_OUT      = 8'h08,
    parameter PLL_OUT       = 8'h0c,
    parameter TRAP_OUT      = 8'h10,
    parameter IRQ7_SRC      = 8'h14,
    parameter IRQ8_SRC      = 8'h18,
    parameter OVERTEMP_ENA  = 8'h1c,
    parameter OVERTEMP_DATA = 8'h20,
    parameter OVERTEMP_OUT  = 8'h24
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
    
    input overtemp,

    output rcosc_ena,
    output [1:0] rcosc_output_dest,
    output [1:0] xtal_output_dest,
    output [1:0] pll_output_dest,
    output [1:0] trap_output_dest,
    output [1:0] irq_7_inputsrc,
    output [1:0] irq_8_inputsrc,
    output overtemp_ena,
    output [1:0] overtemp_dest

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
        .OSC_ENA(OSC_ENA),
        .OSC_OUT(OSC_OUT),
        .XTAL_OUT(XTAL_OUT),
        .PLL_OUT(PLL_OUT),
        .TRAP_OUT(TRAP_OUT),
        .IRQ7_SRC(IRQ7_SRC),
        .IRQ8_SRC(IRQ8_SRC),
        .OVERTEMP_ENA(OVERTEMP_ENA),
        .OVERTEMP_DATA(OVERTEMP_DATA),
        .OVERTEMP_OUT(OVERTEMP_OUT)
    ) sysctrl (
        .clk(wb_clk_i),
        .resetn(resetn),
        
        .overtemp(overtemp), 

        .iomem_addr(wb_adr_i),
        .iomem_valid(valid),
        .iomem_wstrb(iomem_we),
        .iomem_wdata(wb_dat_i),
        .iomem_rdata(wb_dat_o),
        .iomem_ready(ready),
        
        .rcosc_ena(rcosc_ena), // (verify) wire input to the core not connected to HKSPI, what should it be connected to ? 
        .rcosc_output_dest(rcosc_output_dest), 
        .xtal_output_dest(xtal_output_dest),
        .pll_output_dest(pll_output_dest),
        .trap_output_dest(trap_output_dest), 
    
        .irq_7_inputsrc(irq_7_inputsrc),
        .irq_8_inputsrc(irq_8_inputsrc),  

        .overtemp_ena(overtemp_ena),
        .overtemp_dest(overtemp_dest) 
    );

endmodule

module sysctrl #(
    parameter BASE_ADR = 32'h2300_0000,
    parameter OSC_ENA       = 8'h00,
    parameter OSC_OUT       = 8'h04,
    parameter XTAL_OUT      = 8'h08,
    parameter PLL_OUT       = 8'h0c,
    parameter TRAP_OUT      = 8'h10,
    parameter IRQ7_SRC      = 8'h14,
    parameter IRQ8_SRC      = 8'h18,
    parameter OVERTEMP_ENA  = 8'h1c,
    parameter OVERTEMP_DATA = 8'h20,
    parameter OVERTEMP_OUT  = 8'h24
) (
    input clk,
    input resetn,
    
    input overtemp,

    input [31:0] iomem_addr,
    input iomem_valid,
    input [3:0] iomem_wstrb,
    input [31:0] iomem_wdata,
    output reg [31:0] iomem_rdata,
    output reg iomem_ready,

    output rcosc_ena,
    output [1:0] rcosc_output_dest,
    output [1:0] xtal_output_dest,
    output [1:0] pll_output_dest,
    output [1:0] trap_output_dest,
    output [1:0] irq_7_inputsrc,
    output [1:0] irq_8_inputsrc,
    output overtemp_ena,
    output [1:0] overtemp_dest
); 
    reg rcosc_ena;
    reg [1:0] rcosc_output_dest;
    reg [1:0] xtal_output_dest;
    reg [1:0] pll_output_dest;
    reg [1:0] trap_output_dest;
    reg [1:0] irq_7_inputsrc;
    reg [1:0] irq_8_inputsrc;
    reg overtemp_ena;
    reg [1:0] overtemp_dest;

    assign osc_ena_sel  = (iomem_addr[7:0] == OSC_ENA);
    assign osc_out_sel  = (iomem_addr[7:0] == OSC_OUT);
    assign pll_out_sel  = (iomem_addr[7:0] == PLL_OUT);
    assign trap_out_sel = (iomem_addr[7:0] == TRAP_OUT);
    assign xtal_out_sel = (iomem_addr[7:0] == XTAL_OUT);

    assign irq7_sel  = (iomem_addr[7:0] == IRQ7_SRC);
    assign irq8_sel  = (iomem_addr[7:0] == IRQ8_SRC);

    assign overtemp_sel       = (iomem_addr[7:0] == OVERTEMP_DATA);
    assign overtemp_ena_sel   = (iomem_addr[7:0] == OVERTEMP_ENA);
    assign overtemp_dest_sel  = (iomem_addr[7:0] == OVERTEMP_OUT);

    always @(posedge clk) begin
        if (!resetn) begin
            rcosc_ena <= 0;
            rcosc_output_dest <= 0;
            pll_output_dest <= 0;
            xtal_output_dest <= 0;
            trap_output_dest <= 0;
            irq_7_inputsrc <= 0;
            irq_8_inputsrc <= 0;
            overtemp_dest <= 0;
            overtemp_ena <= 0;
        end else begin
            iomem_ready <= 0;
            if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
                iomem_ready <= 1'b 1;
                
                if (osc_ena_sel) begin
                    iomem_rdata <= {31'd0, rcosc_ena};					
                    if (iomem_wstrb[0])
                        rcosc_ena <= iomem_wdata[0];

                end else if (osc_out_sel) begin
                    iomem_rdata <= {30'd0, rcosc_output_dest};
                    if (iomem_wstrb[0])
                        rcosc_output_dest <= iomem_wdata[1:0];

                end else if (xtal_out_sel) begin
                    iomem_rdata <= {30'd0, xtal_output_dest};
                    if (iomem_wstrb[0])
                        xtal_output_dest <= iomem_wdata[1:0];

                end else if (pll_out_sel) begin
                    iomem_rdata <= {30'd0, pll_output_dest};
                    if (iomem_wstrb[0])
                        pll_output_dest <= iomem_wdata[1:0];

                end else if (trap_out_sel) begin
                    iomem_rdata <= {30'd0, trap_output_dest};
                    if (iomem_wstrb[0]) 
                        trap_output_dest <= iomem_wdata[1:0];

                end else if (irq7_sel) begin
                    iomem_rdata <= {30'd0, irq_7_inputsrc};
                    if (iomem_wstrb[0])
                        irq_7_inputsrc <= iomem_wdata[1:0];

                end else if (irq8_sel) begin
                    iomem_rdata <= {30'd0, irq_8_inputsrc};
                    if (iomem_wstrb[0])
                        irq_8_inputsrc <= iomem_wdata[1:0];

                end else if (overtemp_ena_sel) begin
                    iomem_rdata <= {31'd0, overtemp_ena};
                    if (iomem_wstrb[0])
                        overtemp_ena <= iomem_wdata[0];

                end else if (overtemp_sel) begin
                    iomem_rdata <= {31'd0, overtemp};

                end else if (overtemp_dest_sel) begin
                    iomem_rdata <= {30'd0, overtemp_dest};
                    if (iomem_wstrb[0])
                        overtemp_dest <= iomem_wdata[1:0];

                end
            end
        end
    end

endmodule