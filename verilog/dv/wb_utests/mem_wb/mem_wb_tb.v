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

`define USE_OPENRAM

`include "sram_1rw1r_32_8192_8_sky130.v"
`include "mem_wb.v"

module mem_wb_tb;

    reg wb_clk_i;
    reg wb_rst_i;

    reg [31:0] wb_adr_i;
    reg [31:0] wb_dat_i;
    reg [3:0]  wb_sel_i;
    reg wb_we_i;
    reg wb_cyc_i;
    reg wb_stb_i;

    wire wb_ack_o;
    wire [31:0] wb_dat_o;

    initial begin
        wb_clk_i = 0; 
        wb_rst_i = 0;

        wb_stb_i = 0;  // master select-signal for the slave
        wb_we_i  = 0;  // R = 0 , W = 1
        wb_cyc_i = 0;  // master is transferring
        wb_adr_i = 0;  // input addr 32-bits
        wb_dat_i = 0;  // input data 32-bits
        wb_sel_i = 0;  // where data is available on data_i 4-bits
    end

    always #1 wb_clk_i = ~wb_clk_i;

    initial begin
        $dumpfile("mem_wb_tb.vcd");
        $dumpvars(0, mem_wb_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test Wishbone Memory Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;

    reg [31:0] ref_data [255: 0];
    reg [31: 0] read_data;

    initial begin
        // Reset Operation
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0; 
        #2;

        // Randomly Write to memory array
        for ( i = 0; i < 1; i = i + 1) begin 
            ref_data[i] = $urandom_range(0, 2**30);
            write(i, ref_data[i]);
            #2;
        end

        #6;
        for ( i = 0; i < 1; i = i + 1) begin 
            read(i);
            if (wb_dat_o !== ref_data[i]) begin
                $display("%c[1;31m",27);
                $display("Expected %0b, but Got %0b ", ref_data[i], wb_dat_o);
                $display("Monitor: Wishbone Memory Failed");
                $display("%c[0m",27);
                $finish;
            end
            #2;
        end
        #6;
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
    
    mem_wb uut(
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(wb_adr_i), 
        .wb_dat_i(wb_dat_i),
        .wb_sel_i(wb_sel_i),
        .wb_we_i(wb_we_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_stb_i(wb_stb_i),

        .wb_ack_o(wb_ack_o), 
        .wb_dat_o(wb_dat_o)
    );

endmodule