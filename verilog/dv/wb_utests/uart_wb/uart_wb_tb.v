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

`include "simpleuart.v"

module uart_wb_tb;
    
    reg wb_clk_i;
	reg wb_rst_i;

    reg wb_stb_i;
	reg wb_cyc_i;
	reg wb_we_i;
	reg [3:0] wb_sel_i;
	reg [31:0] wb_adr_i;
	reg [31:0] wb_dat_i;

	wire wb_ack_o;
	wire [31:0] wb_dat_o;

    wire tbuart_rx;
	wire ser_rx;
  
    initial begin
        wb_clk_i = 0; 
        wb_rst_i = 0;
        wb_stb_i = 0; 
        wb_we_i  = 0;  
        wb_cyc_i = 0;  
        wb_adr_i = 0; 
        wb_dat_i = 0; 
        wb_sel_i = 0;  
    end

    always #1 wb_clk_i = ~wb_clk_i;

    initial begin
        $dumpfile("uart_wb_tb.vcd");
        $dumpvars(0, uart_wb_tb);
        repeat (500) begin
            repeat (10000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display("Monitor: Timeout, Test UART Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;

    wire [31:0] div_reg_addr = uut.BASE_ADR | uut.CLK_DIV;
    wire [31:0] div_reg_data = 32'h FFFF_FFFF;
    
    wire [31:0] dat_reg_addr = uut.BASE_ADR | uut.DATA;
    wire [31:0] dat_reg_data = 32'h FFFF_FFFF;

    initial begin
        // Reset Operation
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0; 
        #2;

        // Write to div register
        write(div_reg_addr, div_reg_data);
        #2;
        read(div_reg_addr);
        if (wb_dat_o !== div_reg_data) begin
            $display("%c[1;31m",27);
            $display("Expected %0b, but Got %0b ", div_reg_data, wb_dat_o);
            $display("Monitor: Wishbone UART Failed");
            $display("%c[0m",27);
            $finish;
        end
        #6;

        // Write Operation: writes to data register
        write(dat_reg_addr, dat_reg_data);
        #2;
        read(dat_reg_addr);
        if (wb_dat_o !== dat_reg_data) begin
            $display("%c[1;31m",27);
            $display("Expected %0b, but Got %0b ", dat_reg_data, wb_dat_o);
            $display("Monitor: Wishbone UART Failed");
            $display("%c[0m",27);
            $finish;
        end
        $display("Success!");
        $finish;
    end
    
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
            #2;
            wb_we_i = 0;     
            // Wait for an ACK
            wait(wb_ack_o == 1);
            #2;
            wb_cyc_i = 0;
            wb_stb_i = 0;
            $display("Write Cycle Ended.");
        end
    endtask
    
    task read;
        input [32:0] addr;
        begin 
            @(posedge wb_clk_i) begin
                wb_stb_i = 1;
                wb_cyc_i = 1;
                wb_we_i = 0;
                wb_adr_i = addr;
                $display("Read Cycle Started.");
            end
            // Wait for an ACK
            wait(wb_ack_o == 1);
            #2;
            // wait(wb_ack_o == 0);
            wb_cyc_i = 0;
            wb_stb_i = 0;
            $display("Read Cycle Ended.");
        end
    endtask
    
    simpleuart_wb uut (
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
    	.wb_stb_i(wb_stb_i),
    	.wb_cyc_i(wb_cyc_i),
    	.wb_sel_i(wb_sel_i),
    	.wb_we_i(wb_we_i),
        .wb_adr_i(wb_adr_i),      
	    .wb_dat_i(wb_dat_i),
	    .wb_ack_o(wb_ack_o),
	    .wb_dat_o(wb_dat_o),
        .ser_tx(tbuart_rx),
		.ser_rx(ser_rx)
	);

endmodule
