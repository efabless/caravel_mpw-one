// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none


`timescale 1 ns / 1 ps

`include "spi_sysctrl.v"
`include "striVe_spi.v"

module spi_sysctrl_wb_tb;

    reg wb_clk_i;
	reg wb_rst_i;

    reg wb_stb_i;
    reg wb_cyc_i;
	reg wb_we_i;
	reg [3:0] wb_sel_i;
	reg [31:0] wb_dat_i;
	reg [31:0] wb_adr_i;

	wire wb_ack_o;
	wire [31:0] wb_dat_o;

    wire [7:0] spi_ro_config; // (verify) wire input to the core not connected to HKSPI, what should it be connected to ? 
    wire [4:0] spi_ro_pll_div; 
    wire [2:0] spi_ro_pll_sel;
    wire spi_ro_xtal_ena;
    wire spi_ro_reg_ena; 
    wire [25:0] spi_ro_pll_trim;
    wire spi_ro_pll_dco_ena;
    wire [11:0] spi_ro_mfgr_id;
    wire [7:0] spi_ro_prod_id;
    wire [3:0] spi_ro_mask_rev;
    wire spi_ro_pll_bypass;
   
    // HKSPI
    reg RSTB;	    
    reg SCK;	   
    reg SDI;	    
    reg CSB;	    
    reg trap;
    reg [3:0] mask_rev_in;	

    wire SDO;	  
    wire sdo_enb;
    wire xtal_ena;
    wire reg_ena;
    wire pll_dco_ena;
    wire [25:0] pll_trim;
    wire [2:0] pll_sel;
    wire [4:0] pll_div;
    wire pll_bypass;
    wire irq;
    wire reset;
    wire RST;
    wire [11:0] mfgr_id;
    wire [7:0] prod_id;
    wire [3:0] mask_rev;

    initial begin
        wb_clk_i = 0; 
        wb_rst_i = 0;
        wb_stb_i = 0; 
        wb_cyc_i = 0;  
        wb_sel_i = 0;  
        wb_we_i  = 0;  
        wb_dat_i = 0; 
        wb_adr_i = 0; 
        CSB = 1;
        SCK = 0;
        SDI = 0;
        RSTB = 0; 
    end

    always #1 wb_clk_i = ~wb_clk_i;

    // System Control Default Register Addresses (Read-only reg)
    wire [31:0] spi_cfg         = uut.BASE_ADR | uut.SPI_CFG; // unused & reserved ? 
    wire [31:0] spi_ena         = uut.BASE_ADR | uut.SPI_ENA;
    wire [31:0] spi_pll_cfg     = uut.BASE_ADR | uut.SPI_PLL_CFG;
    wire [31:0] spi_mfgr_id     = uut.BASE_ADR | uut.SPI_MFGR_ID;
    wire [31:0] spi_prod_id     = uut.BASE_ADR | uut.SPI_PROD_ID;
    wire [31:0] spi_mask_rev    = uut.BASE_ADR | uut.SPI_MASK_REV;
    wire [31:0] spi_pll_bypass  = uut.BASE_ADR | uut.SPI_PLL_BYPASS;

    initial begin
        $dumpfile("spi_sysctrl_wb_tb.vcd");
        $dumpvars(0, spi_sysctrl_wb_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test SPI System Control Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;

    initial begin   
        // Reset Operation
        wb_rst_i = 1;
        RSTB = 0;       // active low reset
        #2;
        wb_rst_i = 0;
        RSTB = 1; 
        #2;

        // Read mask_rev register
        mask_rev_in = 4'hF;
        read(spi_mask_rev);
        if (wb_dat_o !== {28'd0, mask_rev_in}) begin
            $display("Error reading mask_rev reg");
            $finish;
        end

        // Read manufacture id register
        read(spi_mfgr_id);
        if (wb_dat_o !== {20'd0, 12'h456}) begin
            $display("Error reading manufacture id reg");
            $finish;
        end

        // Read product id register
        read(spi_prod_id);
        if (wb_dat_o !== {24'd0, 8'h05}) begin
            $display("Error reading product id reg");
            $finish;
        end

        // Read PLL-Bypass register
        read(spi_pll_bypass);
        if (wb_dat_o !== {31'd0, 1'b1}) begin
            $display("Error reading pll bypass id reg");
            $finish;
        end

        // Read PLL-Configuration register
        read(spi_pll_cfg);
        if (wb_dat_o !== {5'd0, spi_ro_pll_trim, spi_ro_pll_dco_ena}) begin
            $display("Error reading pll bypass id reg");
            $finish;
        end

        // Read SPI Enables register
        read(spi_ena);
        if (wb_dat_o !== {22'd0, spi_ro_pll_div, spi_ro_pll_sel, spi_ro_xtal_ena, spi_ro_reg_ena}) begin
            $display("Error reading pll bypass id reg");
            $finish;
        end                
        $display("Success!");
        $finish;
    end

    task read;
        input [32:0] addr;
        begin 
            @(posedge wb_clk_i) begin
                wb_stb_i = 1;
                wb_cyc_i = 1;
                wb_we_i = 0;
                wb_adr_i = addr;
                $display("Monitor: Read Cycle Started.");
            end
            // Wait for an ACK
            wait(wb_ack_o == 1);
            wait(wb_ack_o == 0);
            wb_cyc_i = 0;
            wb_stb_i = 0;
            $display("Monitor: Read Cycle Ended.");
        end
    endtask

    spi_sysctrl_wb uut(
        .wb_clk_i(wb_clk_i),
	    .wb_rst_i(wb_rst_i),

        .wb_stb_i(wb_stb_i),
	    .wb_cyc_i(wb_cyc_i),
	    .wb_sel_i(wb_sel_i),
	    .wb_we_i(wb_we_i),
	    .wb_dat_i(wb_dat_i),
	    .wb_adr_i(wb_adr_i), 
        .wb_ack_o(wb_ack_o),
	    .wb_dat_o(wb_dat_o),
        
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
        .pll_bypass(spi_ro_pll_bypass)
    );

    striVe_spi hkspi (
		.RSTB(RSTB),
		.SCK(SCK),
		.SDI(SDI),
		.CSB(CSB),

		.SDO(SDO),
		.sdo_enb(SDO_enb),
		.xtal_ena(spi_ro_xtal_ena),
		.reg_ena(spi_ro_reg_ena),
		.pll_dco_ena(spi_ro_pll_dco_ena),
		.pll_sel(spi_ro_pll_sel),
		.pll_div(spi_ro_pll_div),
		.pll_trim(spi_ro_pll_trim),
		.pll_bypass(spi_ro_pll_bypass),
		.irq(irq_spi),
		.RST(por),
		.reset(ext_reset),
		.trap(trap),
		.mfgr_id(spi_ro_mfgr_id),
		.prod_id(spi_ro_prod_id),
		.mask_rev_in(mask_rev_in),
		.mask_rev(spi_ro_mask_rev)
    );

endmodule