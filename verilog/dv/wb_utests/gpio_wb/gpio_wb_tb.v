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

`include "gpio_wb.v"

module gpio_wb_tb;

    reg wb_clk_i;
    reg wb_rst_i;

    reg wb_stb_i;
    reg wb_cyc_i;
    reg wb_we_i;
    reg [3:0] wb_sel_i;

    reg [31:0] wb_dat_i;
    reg [31:0] wb_adr_i;
    reg [15:0] gpio_in_pad;

    wire wb_ack_o;
    wire [31:0] wb_dat_o;

    initial begin
        wb_clk_i = 0; 
        wb_rst_i = 0;
        wb_stb_i = 0; 
        wb_cyc_i = 0;  
        wb_sel_i = 0;  
        wb_we_i  = 0;  
        wb_dat_i = 0; 
        wb_adr_i = 0;  
        gpio_in_pad = 0;
    end

    always #1 wb_clk_i = ~wb_clk_i;

    initial begin
        $dumpfile("gpio_wb_tb.vcd");
        $dumpvars(0, gpio_wb_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test GPIO Wishbone Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;
    
    // GPIO Internal Register Addresses
    wire [31:0] gpio_adr     = uut.BASE_ADR | uut.GPIO_DATA;
    wire [31:0] gpio_oeb_adr = uut.BASE_ADR | uut.GPIO_ENA;
    wire [31:0] gpio_pu_adr  = uut.BASE_ADR | uut.GPIO_PU;
    wire [31:0] gpio_pd_adr  = uut.BASE_ADR | uut.GPIO_PD;

    reg [15:0] gpio_data;
    reg [15:0] gpio_pu; 
    reg [15:0] gpio_pd; 
    reg [15:0] gpio_oeb;  

    initial begin
        // Reset Operation
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0; 
        #2;

        // Write to gpio_data reg
        gpio_in_pad = 16'h FFFF;
        gpio_data = 16'h A000;
        write(gpio_adr, gpio_data);
       
        #2;
        // Read from gpio_data reg
        read(gpio_adr);
        if (wb_dat_o !== {gpio_data, gpio_in_pad}) begin
            $display("Monitor: Error reading from gpio reg");
            $finish;
        end
        
        #2;
        // Write to pull-up reg
        gpio_pu = 16'h 000f;
        write(gpio_pu_adr, gpio_pu);
        
        #2;
        // Read from pull-up reg
        read(gpio_pu_adr);
        if (wb_dat_o !== {16'd0, gpio_pu}) begin
            $display("Monitor: Error reading from gpio pull-up reg");
            $finish;
        end

        #2;
        // Write to pull-down reg
        gpio_pd = 16'h 00f0;
        write(gpio_pd_adr, gpio_pd);
        
        #2;
        // Read from pull-down reg
        read(gpio_pd_adr);
        if (wb_dat_o !== {16'd0, gpio_pd}) begin
            $display("Monitor: Error reading from gpio pull-down reg");
            $finish;
        end

        #2;
        // Write to gpio enable reg
        gpio_oeb = 16'h 00ff;
        write(gpio_oeb_adr, gpio_oeb);
        
        #2;
        // Read from gpio enable reg
        read(gpio_oeb_adr);
        if (wb_dat_o !== {16'd0, gpio_oeb}) begin
            $display("Monitor: Error reading from gpio output enable reg");
            $finish;
        end
        
        #6;
        $display("Monitor: GPIO WB Success!");
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
            // Wait for an ACK
            wait(wb_ack_o == 1);
            wait(wb_ack_o == 0);
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
            wait(wb_ack_o == 0);
            wb_cyc_i = 0;
            wb_stb_i = 0;
            $display("Read Cycle Ended.");
        end
    endtask
    
    gpio_wb uut(
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
        .gpio_in_pad(gpio_in_pad)
    );
    
endmodule
