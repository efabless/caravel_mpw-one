`default_nettype none
// SPDX-FileCopyrightText: 2019 Efabless Corporation
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
//----------------------------------------------------------------------------
// Module: simple_spi_master
//
//----------------------------------------------------------------------------
// Copyright (C) 2019 efabless, inc.
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any
// later version.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE.  See the GNU Lesser General Public License for more
// details.
//
//--------------------------------------------------------------------
// 
// resetn: active low async reset
// clk:    master clock (before prescaler)
// stream:
//     0 = apply/release CSB separately for each byte
//     1 = apply CSB until stream bit is cleared
// mlb:
//     0 = msb 1st
//     1 = lsb 1st
// invsck:
//     0 = normal SCK
//     1 = inverted SCK
// invcsb:
//     0 = normal CSB (active low)
//     1 = inverted CSB (active high)
// mode:
//     0 = read and change data on opposite SCK edges
//     1 = read and change data on the same SCK edge
// enable:
//     0 = disable the SPI master
//     1 = enable the SPI master
// irqena:
//     0 = disable interrupt
//     1 = enable interrupt
// hkconn:
//     0 = housekeeping SPI disconnected
//     1 = housekeeping SPI connected (when SPI master enabled)
// prescaler: count (in master clock cycles) of 1/2 SCK cycle.
//
// reg_dat_we:
//     1 = data write enable
// reg_dat_re:
//     1 = data read enable
// reg_cfg_*: Signaling for read/write of configuration register
// reg_dat_*: Signaling for read/write of data register
//
// err_out:  Indicates attempt to read/write before data ready
//	(failure to wait for reg_dat_wait to clear)
//
// Between "mode" and "invsck", all four standard SPI modes are supported
//
//--------------------------------------------------------------------

module simple_spi_master_wb #(
    parameter BASE_ADR = 32'h2100_0000,
    parameter CONFIG = 8'h00,
    parameter DATA = 8'h04
) (
    input wb_clk_i,
    input wb_rst_i,
    input [31:0] wb_adr_i,
    input [31:0] wb_dat_i,
    input [3:0] wb_sel_i,
    input wb_we_i,
    input wb_cyc_i,
    input wb_stb_i,
    output wb_ack_o,
    output [31:0] wb_dat_o,

    output	 hk_connect,	// Connect to housekeeping SPI
    output	 spi_enabled,	// Use to mux pins with GPIO control
    input 	 sdi,	 // SPI input
    output 	 csb,	 // SPI chip select
    output 	 sck,	 // SPI clock
    output 	 sdo,	 // SPI output
    output 	 sdoenb, // SPI output enable
    output	 irq	 // interrupt output
);

    wire [31:0] simple_spi_master_reg_cfg_do;
    wire [31:0] simple_spi_master_reg_dat_do;

    wire resetn = ~wb_rst_i;
    wire valid = wb_stb_i && wb_cyc_i;
    wire simple_spi_master_reg_cfg_sel = valid && (wb_adr_i == (BASE_ADR | CONFIG));
    wire simple_spi_master_reg_dat_sel = valid && (wb_adr_i == (BASE_ADR | DATA));

    wire [1:0] reg_cfg_we = (simple_spi_master_reg_cfg_sel) ?
		(wb_sel_i[1:0] & {2{wb_we_i}}): 2'b00;
    wire reg_dat_we = (simple_spi_master_reg_dat_sel) ? (wb_sel_i[0] & wb_we_i): 1'b0;
    wire reg_dat_wait;

    wire [31:0] mem_wdata = wb_dat_i;
    wire reg_dat_re = simple_spi_master_reg_dat_sel && !wb_sel_i && ~wb_we_i;

    assign wb_dat_o = (simple_spi_master_reg_cfg_sel) ? simple_spi_master_reg_cfg_do :
		simple_spi_master_reg_dat_do;
    assign wb_ack_o = (simple_spi_master_reg_cfg_sel || simple_spi_master_reg_dat_sel)
		&& (!reg_dat_wait);

    simple_spi_master spi_master (
    	.resetn(resetn),
    	.clk(wb_clk_i),
    	.reg_cfg_we(reg_cfg_we),
    	.reg_cfg_di(mem_wdata),
    	.reg_cfg_do(simple_spi_master_reg_cfg_do),
    	.reg_dat_we(reg_dat_we),
    	.reg_dat_re(reg_dat_re),
    	.reg_dat_di(mem_wdata),
    	.reg_dat_do(simple_spi_master_reg_dat_do),
    	.reg_dat_wait(reg_dat_wait),

	.hk_connect(hk_connect),	// Attach to housekeeping SPI slave
	.spi_enabled(spi_enabled),	// Mux pins with GPIO
    	.sdi(sdi),	 // SPI input
    	.csb(csb),	 // SPI chip select
    	.sck(sck),	 // SPI clock
    	.sdo(sdo),	 // SPI output
	.irq_out(irq)	 // interrupt
    );
endmodule

module simple_spi_master (
    input        resetn,
    input        clk,	 // master clock (assume 100MHz)

    input  [1:0]  reg_cfg_we,
    input  [31:0] reg_cfg_di,
    output [31:0] reg_cfg_do,

    input  	  reg_dat_we,
    input  	  reg_dat_re,
    input  [31:0] reg_dat_di,
    output [31:0] reg_dat_do,
    output	  reg_dat_wait,
    output	  irq_out,
    output	  err_out,

    output	 hk_connect,	// Connect to housekeeping SPI
    output	 spi_enabled,	// Used to mux pins with GPIO
    input 	 sdi,	 // SPI input
    output 	 csb,	 // SPI chip select
    output 	 sck,	 // SPI clock
    output 	 sdo	 // SPI output
);

    parameter IDLE   = 2'b00;	    
    parameter SENDL  = 2'b01; 
    parameter SENDH  = 2'b10; 
    parameter FINISH = 2'b11; 

    reg	  done;
    reg 	  isdo, hsck, icsb;
    reg [1:0] state;
    reg 	  isck;
    reg	  err_out;
 
    reg [7:0]  treg, rreg, d_latched;
    reg [2:0]  nbit;

    reg [7:0]  prescaler;
    reg [7:0]  count;
    reg	   invsck;
    reg	   invcsb;
    reg	   mlb;
    reg	   irqena;
    reg	   stream;
    reg	   mode;
    reg	   enable;
    reg	   hkconn;
 
    wire	  csb;
    wire	  irq_out;
    wire	  sck;
    wire	  sdo;
    wire	  sdoenb;
    wire	  hk_connect;
    wire	  spi_enabled;

    // Define behavior for inverted SCK and inverted CSB
    assign    	  csb = (invcsb) ? ~icsb : icsb;
    assign	  sck = (invsck) ? ~isck : isck;

    // No bidirectional 3-pin mode defined, so SDO is enabled whenever CSB is low.
    assign	  sdoenb = icsb;
    assign	  sdo = isdo;

    assign	  irq_out = irqena & done;
    assign	  hk_connect = (enable == 1'b1) ? hkconn : 1'b0;
    assign	  spi_enabled = enable;

    // Read configuration and data registers
    assign reg_cfg_do = {16'd0, hkconn, irqena, enable, stream, mode,
			 invsck, invcsb, mlb, prescaler};
    assign reg_dat_wait = ~done;
    assign reg_dat_do = done ? rreg : ~0;

    // Write configuration register
    always @(posedge clk or negedge resetn) begin
        if (resetn == 1'b0) begin
	    prescaler <= 8'd2;
	    invcsb <= 1'b0;
	    invsck <= 1'b0;
	    mlb <= 1'b0;
	    enable <= 1'b0;
	    irqena <= 1'b0;
	    stream <= 1'b0;
	    mode <= 1'b0;
	    hkconn <= 1'b0;
        end else begin
            if (reg_cfg_we[0]) prescaler <= reg_cfg_di[7:0];
            if (reg_cfg_we[1]) begin
	        mlb <= reg_cfg_di[8];
	        invcsb <= reg_cfg_di[9];
	        invsck <= reg_cfg_di[10];
	        mode <= reg_cfg_di[11];
	        stream <= reg_cfg_di[12];
	        enable <= reg_cfg_di[13];
	        irqena <= reg_cfg_di[14];
	        hkconn <= reg_cfg_di[15];
	    end //reg_cfg_we[1]
        end //resetn
    end //always
 
    // Watch for read and write enables on clk, not hsck, so as not to
    // miss them.

    reg w_latched, r_latched;

    always @(posedge clk or negedge resetn) begin
        if (resetn == 1'b0) begin
	    err_out <= 1'b0;
            w_latched <= 1'b0;
            r_latched <= 1'b0;
	    d_latched <= 8'd0;
        end else begin
            // Clear latches on SEND, otherwise latch when seen
            if (state == SENDL || state == SENDH) begin
	        if (reg_dat_we == 1'b0) begin
		    w_latched <= 1'b0;
	        end
	    end else begin
	        if (reg_dat_we == 1'b1) begin
		    if (done == 1'b0 && w_latched == 1'b1) begin
		        err_out <= 1'b1;
		    end else begin
		        w_latched <= 1'b1;
		        d_latched <= reg_dat_di[7:0];
		        err_out <= 1'b0;
		    end
	        end
	    end

	    if (reg_dat_re == 1'b1) begin
	        if (r_latched == 1'b1) begin
		    r_latched <= 1'b0;
	        end else begin
		    err_out <= 1'b1;	// byte not available
	        end
	    end else if (state == FINISH) begin
	        r_latched <= 1'b1;
	    end if (state == SENDL || state == SENDH) begin
	        if (r_latched == 1'b1) begin
		    err_out <= 1'b1;	// last byte was never read
	        end else begin
		    r_latched <= 1'b0;
	        end
	    end
        end
    end

    // State transition.

    always @(posedge hsck or negedge resetn) begin
        if (resetn == 1'b0) begin
	    state <= IDLE;
	    nbit <= 3'd0;
	    icsb <= 1'b1;
	    done <= 1'b1;
        end else begin
	    if (state == IDLE) begin
	        if (w_latched == 1'b1) begin
		    state <= SENDL;
		    nbit <= 3'd0;
		    icsb <= 1'b0;
		    done <= 1'b0;
	        end else begin
	            icsb <= ~stream;
	        end
	    end else if (state == SENDL) begin
	        state <= SENDH;
	    end else if (state == SENDH) begin
	        nbit <= nbit + 1;
                if (nbit == 3'd7) begin
		    state <= FINISH;
	        end else begin
	            state <= SENDL;
	        end
	    end else if (state == FINISH) begin
	        icsb <= ~stream;
	        done <= 1'b1;
	        state <= IDLE;
	    end
        end
    end
 
    // Set up internal clock.  The enable bit gates the internal clock
    // to shut down the master SPI when disabled.

    always @(posedge clk or negedge resetn) begin
        if (resetn == 1'b0) begin
	    count <= 8'd0;
	    hsck <= 1'b0;
        end else begin
	    if (enable == 1'b0) begin
 	        count <= 8'd0;
	    end else begin
	        count <= count + 1; 
                if (count == prescaler) begin
		    hsck <= ~hsck;
		    count <= 8'd0;
	        end // count
	    end // enable
        end // resetn
    end // always
 
    // sck is half the rate of hsck

    always @(posedge hsck or negedge resetn) begin
        if (resetn == 1'b0) begin
	    isck <= 1'b0;
        end else begin
	    if (state == IDLE || state == FINISH)
	        isck <= 1'b0;
	    else
	        isck <= ~isck;
        end // resetn
    end // always

    // Main procedure:  read, write, shift data

    always @(posedge hsck or negedge resetn) begin
        if (resetn == 1'b0) begin
	    rreg <= 8'hff;
	    treg <= 8'hff;
	    isdo <= 1'b0;
        end else begin 
	    if (isck == 1'b0 && (state == SENDL || state == SENDH)) begin
	        if (mlb == 1'b1) begin
		    // LSB first, sdi@msb -> right shift
		    rreg <= {sdi, rreg[7:1]};
	        end else begin
		    // MSB first, sdi@lsb -> left shift
		    rreg <= {rreg[6:0], sdi};
	        end
	    end // read on ~isck

            if (w_latched == 1'b1) begin
	        if (mlb == 1'b1) begin
		    treg <= {1'b1, d_latched[7:1]};
		    isdo <= d_latched[0];
	        end else begin
		    treg <= {d_latched[6:0], 1'b1};
		    isdo <= d_latched[7];
	        end // mlb
	    end else if ((mode ^ isck) == 1'b1) begin
	        if (mlb == 1'b1) begin
		    // LSB first, shift right
		    treg <= {1'b1, treg[7:1]};
		    isdo <= treg[0];
	        end else begin
		    // MSB first shift LEFT
		    treg <= {treg[6:0], 1'b1};
		    isdo <= treg[7];
	        end // mlb
	    end // write on mode ^ isck
        end // resetn
    end // always
 
endmodule
`default_nettype wire
