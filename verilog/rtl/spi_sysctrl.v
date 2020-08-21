module spi_sysctrl_wb #(
    parameter BASE_ADR = 32'h2E00_0000,
    parameter SPI_CFG = 8'h00,
    parameter SPI_ENA = 8'h04,
    parameter SPI_PLL_CFG = 8'h08,
    parameter SPI_MFGR_ID = 8'h0c,
    parameter SPI_PROD_ID = 8'h10,
    parameter SPI_MASK_REV = 8'h14,
    parameter SPI_PLL_BYPASS = 8'h18
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

    // Read-Only HKSPI Registers
    input [7:0] spi_ro_config, // (verify) wire input to the core not connected to HKSPI, what should it be connected to ? 
    
    input [4:0] spi_ro_pll_div, 
    input [2:0] spi_ro_pll_sel,
    input spi_ro_xtal_ena,
    input spi_ro_reg_ena, 
    
    input [25:0] spi_ro_pll_trim,
    input spi_ro_pll_dco_ena,  

    input [11:0] spi_ro_mfgr_id,
    input [7:0] spi_ro_prod_id, 
    input [3:0] spi_ro_mask_rev, 
    input pll_bypass
);

    wire resetn;
    wire valid;
    wire ready;
    wire [3:0] iomem_we;

    assign resetn = ~wb_rst_i;
    assign valid = wb_stb_i && wb_cyc_i; 

    assign iomem_we = wb_sel_i & {4{wb_we_i}};
    assign wb_ack_o = ready;
    
    spi_sysctrl #(
        .BASE_ADR(BASE_ADR),
        .SPI_CFG(SPI_CFG),
        .SPI_ENA(SPI_ENA),
        .SPI_PLL_CFG(SPI_PLL_CFG),
        .SPI_MFGR_ID(SPI_MFGR_ID),
        .SPI_PROD_ID(SPI_PROD_ID),
        .SPI_MASK_REV(SPI_MASK_REV),
        .SPI_PLL_BYPASS(SPI_PLL_BYPASS)
    ) spi_sysctrl (
        .clk(wb_clk_i),
        .resetn(resetn),

        .iomem_addr(wb_adr_i),
        .iomem_valid(valid),
        .iomem_wstrb(iomem_we),
        .iomem_wdata(wb_dat_i),
        .iomem_rdata(wb_dat_o),
        .iomem_ready(ready),
        
        .spi_ro_config(spi_ro_config), // (verify) wire input to the core not connected to HKSPI, what should it be connected to ? 
        .spi_ro_pll_div(spi_ro_pll_div), 
        .spi_ro_pll_sel(spi_ro_pll_sel),
        .spi_ro_xtal_ena(spi_ro_xtal_ena),
        .spi_ro_reg_ena(spi_ro_reg_ena), 
    
        .spi_ro_pll_trim(spi_ro_pll_trim),
        .spi_ro_pll_dco_ena(spi_ro_pll_dco_ena),  

        .spi_ro_mfgr_id(spi_ro_mfgr_id),
        .spi_ro_prod_id(spi_ro_prod_id), 
        .spi_ro_mask_rev(spi_ro_mask_rev), 
        .pll_bypass(pll_bypass)
    );

endmodule

module spi_sysctrl #(
    parameter BASE_ADR = 32'h2300_0000,
    parameter SPI_CFG = 8'h00,
    parameter SPI_ENA = 8'h04,
    parameter SPI_PLL_CFG = 8'h08,
    parameter SPI_MFGR_ID = 8'h0c,
    parameter SPI_PROD_ID = 8'h10,
    parameter SPI_MASK_REV = 8'h14,
    parameter SPI_PLL_BYPASS = 8'h18
) (
    input clk,
    input resetn,

    input [31:0] iomem_addr,
    input iomem_valid,
    input [3:0] iomem_wstrb,
    input [31:0] iomem_wdata,
    output reg [31:0] iomem_rdata,
    output reg iomem_ready,

    input [7:0] spi_ro_config, // (verify) wire input to the core not connected to HKSPI, what should it be connected to ? 
    
    input [4:0] spi_ro_pll_div, 
    input [2:0] spi_ro_pll_sel,
    input spi_ro_xtal_ena,
    input spi_ro_reg_ena, 
    
    input [25:0] spi_ro_pll_trim,
    input spi_ro_pll_dco_ena,  

    input [11:0] spi_ro_mfgr_id,
    input [7:0] spi_ro_prod_id, 
    input [3:0] spi_ro_mask_rev, 
    input pll_bypass
); 
    // Read-only Registers
   
    wire spi_cfg_sel;
    wire spi_ena_sel;
    wire pll_cfg_sel;
    wire spi_mfgr_sel;
    wire spi_prod_sel;
    wire spi_maskrev_sel;
    wire pll_bypass_sel;


    assign spi_cfg_sel  = (iomem_addr[7:0] == SPI_CFG);
    assign spi_ena_sel  = (iomem_addr[7:0] == SPI_ENA);
    assign pll_cfg_sel  = (iomem_addr[7:0] == SPI_PLL_CFG);
    assign spi_mfgr_sel = (iomem_addr[7:0] == SPI_MFGR_ID);
    assign spi_prod_sel = (iomem_addr[7:0] == SPI_PROD_ID);
    
    assign spi_maskrev_sel = (iomem_addr[7:0] == SPI_MASK_REV);
    assign pll_bypass_sel  = (iomem_addr[7:0] == SPI_PLL_BYPASS);

    always @(posedge clk) begin
        iomem_ready <= 0;
        if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
            iomem_ready <= 1;
            if (spi_cfg_sel) begin
                iomem_rdata <= {24'd0, spi_ro_config};

            end else if (spi_ena_sel) begin
                iomem_rdata <= {
                    22'd0,
                    spi_ro_pll_div,
                    spi_ro_pll_sel,
                    spi_ro_xtal_ena,
                    spi_ro_reg_ena
                };

            end else if (pll_cfg_sel) begin
                iomem_rdata <= {
                    5'd0,
                    spi_ro_pll_trim,
                    spi_ro_pll_dco_ena
                };

            end else if (spi_mfgr_sel) begin
                iomem_rdata <= {20'd0, spi_ro_mfgr_id};

            end else if (spi_prod_sel) begin
                iomem_rdata <= {24'd0, spi_ro_prod_id};

            end else if (spi_maskrev_sel) begin
                iomem_rdata <= {28'd0, spi_ro_mask_rev};

            end else if (pll_bypass_sel) begin
                iomem_rdata <= {31'd0, pll_bypass};
            end
        end
    end

endmodule