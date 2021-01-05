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

`include "simple_spi_master.v"

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

    reg [31:0] spi_cfg_data;
    reg [31:0] spi_data;

    initial begin
        wb_clk_i = 0; 
        wb_rst_i = 0;
        wb_stb_i = 0; 
        wb_cyc_i = 0;  
        wb_sel_i = 0;  
        wb_we_i  = 0;  
        wb_dat_i = 0; 
        wb_adr_i = 0; 
    end

    always #1 wb_clk_i = ~wb_clk_i;

    // SPI Control Register Addresses
    wire [31:0] spi_cfg  = uut.BASE_ADR | uut.CONFIG; 
    wire [31:0] spi_data_adr = uut.BASE_ADR | uut.DATA;

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
        #2;
        wb_rst_i = 0;
        #10;

        // Write to SPI_CFG
        spi_cfg_data = {16'd0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0,
            1'b0, 1'b0, 1'b0, 8'd2};
        write(spi_cfg, spi_cfg_data);

        #2;
        // Read from SPI_CFG
        read(spi_cfg);
        if (wb_dat_o !== spi_cfg_data) begin
            $display("Error reading spi_cfg reg");
            $finish;
        end

        // Read default value of SPI_DATA
        spi_data = 32'h00FF;
        read(spi_data_adr);
        if (wb_dat_o !== spi_data) begin
            $display("Error reading data register reg");
            $finish;
        end
        $display("Success!");
        $display ("Monitor: Test SPI-SYSCTRL WB Passed");
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
            #2;
            wb_adr_i = 0;
            $display("Monitor: Read Cycle Ended.");
        end
    endtask

    task write;
        input [32:0] addr;
        input [32:0] data;
        begin 
            @(posedge wb_clk_i) begin
                wb_stb_i = 1;
                wb_cyc_i = 1;
                wb_sel_i = 4'hF; 
                wb_we_i = 1;     
                wb_adr_i = addr;
                wb_dat_i = data;
                $display("Write Cycle Started.");
            end
            // Wait for an ACK
            wait(wb_ack_o == 1);
            #2;
            wb_adr_i = 0;
            wait(wb_ack_o == 0);
            $display("Write Cycle Ended.");
        end
    endtask

    simple_spi_master_wb uut(
        .wb_clk_i(wb_clk_i),
	    .wb_rst_i(wb_rst_i),

        .wb_stb_i(wb_stb_i),
	    .wb_cyc_i(wb_cyc_i),
	    .wb_sel_i(wb_sel_i),
	    .wb_we_i(wb_we_i),
	    .wb_dat_i(wb_dat_i),
	    .wb_adr_i(wb_adr_i), 
        .wb_ack_o(wb_ack_o),
	    .wb_dat_o(wb_dat_o)
    );
endmodule