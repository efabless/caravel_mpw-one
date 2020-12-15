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

`include "la_wb.v"

module la_wb_tb;

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
    
    initial begin
        $dumpfile("la_wb_tb.vcd");
        $dumpvars(0, la_wb_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test Wishbone LA Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;
    
    // LA Wishbone Internal Register Addresses
    wire [31:0] la_data_adr_0   = uut.BASE_ADR | uut.LA_DATA_0;
    wire [31:0] la_data_adr_1   = uut.BASE_ADR | uut.LA_DATA_1;
    wire [31:0] la_data_adr_2   = uut.BASE_ADR | uut.LA_DATA_2;
    wire [31:0] la_data_adr_3   = uut.BASE_ADR | uut.LA_DATA_3;
    
    wire [31:0] la_ena_adr_0 = uut.BASE_ADR | uut.LA_ENA_0;
    wire [31:0] la_ena_adr_1 = uut.BASE_ADR | uut.LA_ENA_1;
    wire [31:0] la_ena_adr_2 = uut.BASE_ADR | uut.LA_ENA_2;
    wire [31:0] la_ena_adr_3 = uut.BASE_ADR | uut.LA_ENA_3;

    reg [31:0] la_data_0;
    reg [31:0] la_data_1; 
    reg [31:0] la_data_2;
    reg [31:0] la_data_3; 

    reg [31:0] la_ena_0;
    reg [31:0] la_ena_1; 
    reg [31:0] la_ena_2;
    reg [31:0] la_ena_3; 

    initial begin
        // Reset Operation
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0; 
        #2;

        // Write to la data registers
        la_data_0 = $urandom_range(0, 2**32);
        la_data_1 = $urandom_range(0, 2**32);
        la_data_2 = $urandom_range(0, 2**32);
        la_data_3 = $urandom_range(0, 2**32);

        write(la_data_adr_0, la_data_0);
        write(la_data_adr_1, la_data_1);
        write(la_data_adr_2, la_data_2);
        write(la_data_adr_3, la_data_3);

        #2;
        // Read from la data registers
        read(la_data_adr_0);
        if (wb_dat_o !== la_data_0) begin
            $display("Monitor: Error reading from la data_0 reg");
            $finish;
        end
        
        read(la_data_adr_1);
        if (wb_dat_o !== la_data_1) begin
            $display("Monitor: Error reading from la data_0 reg");
            $finish;
        end
        
        read(la_data_adr_2);
        if (wb_dat_o !== la_data_1) begin
            $display("Monitor: Error reading from la data_0 reg");
            $finish;
        end

        read(la_data_adr_3);
        if (wb_dat_o !== la_data_3) begin
            $display("Monitor: Error reading from la data_0 reg");
            $finish;
        end

        // Write to la emable registers
        la_ena_0 = $urandom_range(0, 2**32);
        la_ena_1 = $urandom_range(0, 2**32);
        la_ena_2 = $urandom_range(0, 2**32);
        la_ena_3 = $urandom_range(0, 2**32);

        write(la_ena_adr_0, la_ena_0);
        write(la_ena_adr_1, la_ena_1);
        write(la_ena_adr_2, la_ena_2);
        write(la_ena_adr_3, la_ena_3);

        #2;
        // Read from la data registers
        read(la_ena_adr_0);
        if (wb_dat_o !== la_ena_0) begin
            $display("Monitor: Error reading from la data_0 reg");
            $finish;
        end
        
        read(la_ena_adr_1);
        if (wb_dat_o !== la_ena_1) begin
            $display("Monitor: Error reading from la data_0 reg");
            $finish;
        end
        
        read(la_ena_adr_2);
        if (wb_dat_o !== la_ena_1) begin
            $display("Monitor: Error reading from la data_0 reg");
            $finish;
        end

        read(la_ena_adr_3);
        if (wb_dat_o !== la_ena_3) begin
            $display("Monitor: Error reading from la data_0 reg");
            $finish;
        end
        #6;
        $display("Monitor: Test LA Wishbone Success!");
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

    la_wb uut(
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