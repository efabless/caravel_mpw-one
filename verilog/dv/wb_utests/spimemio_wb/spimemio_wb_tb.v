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

`define FLASH_BASE  32'h 1000_000

`include "spimemio.v"
// `include "spiflash.v"

module spimemio_wb_tb;

    reg wb_clk_i;
	reg wb_rst_i;

    reg wb_flash_stb_i;
	reg wb_cfg_stb_i;
	reg wb_cyc_i;
	reg wb_we_i;
	reg [3:0]  wb_sel_i;
	reg [31:0] wb_adr_i;
	reg [31:0] wb_dat_i;

	wire wb_flash_ack_o;
    wire wb_cfg_ack_o;
	wire [31:0] wb_flash_dat_o;
	wire [31:0] wb_cfg_dat_o;

    wire flash_csb;
    wire flash_clk;

    wire flash_io0_oeb;
    wire flash_io1_oeb;
    wire flash_io2_oeb;
    wire flash_io3_oeb;

    wire flash_io0_di = 1'b 1;
    wire flash_io1_di = 1'b 1;
    wire flash_io2_di = 1'b 1;
    wire flash_io3_di = 1'b 1;

    initial begin
        wb_clk_i = 0; 
        wb_rst_i = 0;
        wb_flash_stb_i = 0;  
        wb_cfg_stb_i = 0; 
        wb_cyc_i = 0;   
        wb_we_i  = 0;
        wb_sel_i = 0;    
        wb_adr_i = 0;  
        wb_dat_i = 0;  
    end

    always #1 wb_clk_i = ~wb_clk_i;

    spimemio_wb uut(
        .wb_clk_i(wb_clk_i),
	    .wb_rst_i(wb_rst_i),
        
        .wb_flash_stb_i(wb_flash_stb_i),
	    .wb_cfg_stb_i(wb_cfg_stb_i),
	    .wb_cyc_i(wb_cyc_i),
    	.wb_we_i(wb_we_i),
	    .wb_sel_i(wb_sel_i),
	    .wb_adr_i(wb_adr_i), 
	    .wb_dat_i(wb_dat_i),
	    .wb_flash_ack_o(wb_flash_ack_o),
        .wb_cfg_ack_o(wb_cfg_ack_o),
	    .wb_flash_dat_o(wb_flash_dat_o),
	    .wb_cfg_dat_o(wb_cfg_dat_o),

        .flash_clk(flash_clk),
        .flash_csb(flash_csb),

        .flash_io0_oeb(flash_io0_oeb),
        .flash_io1_oeb(flash_io1_oeb),
        .flash_io2_oeb(flash_io2_oeb),
        .flash_io3_oeb(flash_io3_oeb),

        .flash_io0_di(flash_io0_di),
        .flash_io1_di(flash_io1_di),
	    .flash_io2_di(flash_io2_di),
	    .flash_io3_di(flash_io3_di)       
    );

    initial begin
        $dumpfile("spimemio_wb_tb.vcd");
        $dumpvars(0, spimemio_wb_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test spimmemio Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;
        
    wire [31:0] cfgreg_data;
    assign cfgreg_data = {
        1'b 1,
        8'b 0,
        3'b 111,
        4'b 1010,
        4'b 0,             // make sure is it tied to zero in the module itself
        {~flash_io3_oeb, ~flash_io2_oeb, ~flash_io1_oeb, ~flash_io0_oeb},
        2'b 0,
        flash_csb,
        flash_clk,
        {flash_io3_di, flash_io2_di, flash_io1_di, flash_io0_di}
    };

    initial begin
        // Reset Operation
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0; 
        #2;

        // Read from flash
        for (i = `FLASH_BASE; i < `FLASH_BASE + 100 ; i = i + 4) begin
            read(i, 1, 0);
            if (wb_flash_dat_o !== 32'hFFFF_FFFF) begin
                $display("%c[1;31m",27);
                $display("Expected %0b, but Got %0b ",  32'hFFFF_FFFF, wb_flash_dat_o);
                $display("Monitor: Wishbone spimemio Failed");
            	$display("%c[0m",27);
                $finish;
            end
            #2;
        end 

        #6;
        // Write to Configuration register
        write(cfgreg_data, 0);
        #2;
        read(0, 0, 1);
        if (wb_cfg_dat_o !== cfgreg_data) begin
            $display("%c[1;31m",27);
            $display("Expected %0b, but Got %0b ",  cfgreg_data, wb_cfg_dat_o);
            $display("Monitor: Wishbone spimemio Failed");
            $display("%c[0m",27);
            $finish;
        end
        
        $display("Success!");
        $finish;
    end
    
    task write;
        input [32:0] data;
        input [31:0] addr;
        begin 
            @(posedge wb_clk_i) begin
                wb_cfg_stb_i = 1'b 1;
                wb_flash_stb_i = 1'b 0;
                wb_cyc_i = 1'b 1;
                wb_sel_i = 4'b 1111; // complete word
                wb_we_i = 1'b 1;     // write enable
                wb_adr_i = addr;
                wb_dat_i = data;
            end

            wait_ack();
        end
    endtask
    
    task read;
        input [32:0] addr;
        input flash_stb;
        input cfg_stb;
        begin 
            wb_flash_stb_i = flash_stb;
            wb_cfg_stb_i = cfg_stb;

            wb_cyc_i = 1'b 1;
            wb_adr_i = addr;
            wb_dat_i = 24;
            wb_sel_i = 4'b 1111; // complete word
            wb_we_i = 1'b 0;     // read
            $display("Initiated Read transaction...");
            wait_ack();
        end
    endtask

    task wait_ack;
        // Wait for an ACK
        if (wb_cfg_stb_i == 1) begin
            @(posedge wb_cfg_ack_o) begin
                #2;  // To end the transaction on the falling edge of ack 
                wb_cyc_i = 1'b 0;
                wb_cfg_stb_i = 1'b 0;
                $display("Monitor: Received an ACK from slave");
            end
        end
        else begin
            @(posedge wb_flash_ack_o) begin
                #2;  // To end the transaction on the falling edge of ack 
                wb_cyc_i = 1'b 0;
                wb_flash_stb_i = 1'b 0;
                $display("Monitor: Received an ACK from slave");
            end
        end
    endtask

    // spiflash #(
	// 	.FILENAME("flash.hex")
	// ) spiflash (
	// 	.csb(flash_csb),
	// 	.clk(flash_clk),
	// 	.io0(flash_io0),
	// 	.io1(flash_io1),
	// 	.io2(flash_io2),
	// 	.io3(flash_io3)
	// );
    
endmodule