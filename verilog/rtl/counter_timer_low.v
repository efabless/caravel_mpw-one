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
/* Simple 32-bit counter-timer for Caravel. */

/* Counter acts as low 32 bits of a 64-bit counter
 * when chained with the other counter.
 */

module counter_timer_low_wb # (
    parameter BASE_ADR = 32'h2400_0000,
    parameter CONFIG = 8'h00,
    parameter VALUE  = 8'h04,
    parameter DATA   = 8'h08
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

    input stop_in,
    input enable_in,
    output strobe,
    output is_offset,
    output stop_out,
    output enable_out,
    output irq
);
    wire [31:0] counter_timer_reg_cfg_do;
    wire [31:0] counter_timer_reg_val_do;
    wire [31:0] counter_timer_reg_dat_do;

    wire resetn = ~wb_rst_i;
    wire valid = wb_stb_i && wb_cyc_i;
    wire counter_timer_reg_cfg_sel = valid && (wb_adr_i == (BASE_ADR | CONFIG));
    wire counter_timer_reg_val_sel = valid && (wb_adr_i == (BASE_ADR | VALUE));
    wire counter_timer_reg_dat_sel = valid && (wb_adr_i == (BASE_ADR | DATA));

    wire reg_cfg_we = (counter_timer_reg_cfg_sel) ?
		(wb_sel_i[0] & {wb_we_i}): 1'b0;
    wire [3:0] reg_val_we = (counter_timer_reg_val_sel) ?
		(wb_sel_i & {4{wb_we_i}}): 4'b0000;
    wire [3:0] reg_dat_we = (counter_timer_reg_dat_sel) ?
		(wb_sel_i & {4{wb_we_i}}): 4'b0000;

    wire [31:0] mem_wdata = wb_dat_i;
    wire reg_dat_re = counter_timer_reg_dat_sel && !wb_sel_i && ~wb_we_i;

    assign wb_dat_o = (counter_timer_reg_cfg_sel) ? counter_timer_reg_cfg_do :
		      (counter_timer_reg_val_sel) ? counter_timer_reg_val_do :
		      counter_timer_reg_dat_do;
    assign wb_ack_o = counter_timer_reg_cfg_sel || counter_timer_reg_val_sel ||
			counter_timer_reg_dat_sel;
    
    counter_timer_low counter_timer_low_inst (
        .resetn(resetn),
        .clkin(wb_clk_i),
        .reg_val_we(reg_val_we),
        .reg_val_di(mem_wdata),
        .reg_val_do(counter_timer_reg_val_do),
        .reg_cfg_we(reg_cfg_we),
        .reg_cfg_di(mem_wdata),
        .reg_cfg_do(counter_timer_reg_cfg_do),
        .reg_dat_we(reg_dat_we),
        .reg_dat_di(mem_wdata),
        .reg_dat_do(counter_timer_reg_dat_do),
	.stop_in(stop_in),
	.strobe(strobe),
	.is_offset(is_offset),
	.enable_in(enable_in),
	.stop_out(stop_out),
	.enable_out(enable_out),
	.irq_out(irq)
   );

endmodule

module counter_timer_low (
    input resetn,
    input clkin,

    input  [3:0]  reg_val_we,
    input  [31:0] reg_val_di,
    output [31:0] reg_val_do,

    input 	  reg_cfg_we,
    input  [31:0] reg_cfg_di,
    output [31:0] reg_cfg_do,

    input  [3:0]  reg_dat_we,
    input  [31:0] reg_dat_di,
    output [31:0] reg_dat_do,

    input	  stop_in,
    input	  enable_in,
    output	  strobe,
    output	  enable_out,
    output	  stop_out,
    output	  is_offset,
    output	  irq_out
);

reg [31:0] value_cur;
reg [31:0] value_reset;
reg	   irq_out;
wire	   stop_in;		// High 32 bits counter has stopped
reg	   strobe;		// Strobe to high 32 bits counter; occurs
				// one cycle before actual timeout and
				// irq signal.
reg	   stop_out;		// Stop condition flag

wire [31:0] value_cur_plus;	// Next value, on up-count
wire [31:0] value_cur_minus;	// Next value, on down-count
wire	    is_offset;
wire	    loc_enable;

reg enable;	// Enable (start) the counter/timer
reg lastenable;	// Previous state of enable (catch rising/falling edge)
reg oneshot;	// Set oneshot (1) mode or continuous (0) mode
reg updown;	// Count up (1) or down (0)
reg irq_ena;	// Enable interrupt on timeout
reg chain;	// Chain to a secondary timer

// Configuration register

assign reg_cfg_do = {27'd0, irq_ena, chain, updown, oneshot, enable};

always @(posedge clkin or negedge resetn) begin
    if (resetn == 1'b0) begin
	enable <= 1'b0;
	oneshot <= 1'b0;
	updown <= 1'b0;
	chain <= 1'b0;
	irq_ena <= 1'b0;
    end else begin
	if (reg_cfg_we) begin
	    enable <= reg_cfg_di[0];
	    oneshot <= reg_cfg_di[1];
	    updown <= reg_cfg_di[2];
	    chain <= reg_cfg_di[3];
	    irq_ena <= reg_cfg_di[4];
	end
    end
end

// Counter/timer reset value register

assign reg_val_do = value_reset;

always @(posedge clkin or negedge resetn) begin
    if (resetn == 1'b0) begin
	value_reset <= 32'd0;
    end else begin
	if (reg_val_we[3]) value_reset[31:24] <= reg_val_di[31:24];
	if (reg_val_we[2]) value_reset[23:16] <= reg_val_di[23:16];
	if (reg_val_we[1]) value_reset[15:8] <= reg_val_di[15:8];
	if (reg_val_we[0]) value_reset[7:0] <= reg_val_di[7:0];
    end
end

assign reg_dat_do = value_cur;

// Counter/timer current value register and timer implementation

assign value_cur_plus = value_cur + 1;
assign value_cur_minus = value_cur - 1;

assign loc_enable = (chain == 1'b1) ? (enable && enable_in) : enable;
assign enable_out = enable;

// If counting up and the stop condition on the low 32 bits is zero,
// then signal to the high word counter that the stop condition of the
// high word must be adjusted by one, since it will roll over at the same
// time and must be signaled early.

assign is_offset = ((updown == 1'b1) && (value_reset == 0));

// When acting as low 32-bit word of a 64-bit chained counter:
// It sets the output strobe on the stop condition, one cycle early.
// It stops on the stop condition if "stop_in" is high.

always @(posedge clkin or negedge resetn) begin
    if (resetn == 1'b0) begin
	value_cur <= 32'd0;	
	strobe <= 1'b0;
	stop_out <= 1'b0;
	irq_out <= 1'b0;
	lastenable <= 1'b0;
    end else begin
	lastenable <= loc_enable;

	if (reg_dat_we != 4'b0000) begin
	    if (reg_dat_we[3] == 1'b1) value_cur[31:24] <= reg_dat_di[31:24];
	    if (reg_dat_we[2] == 1'b1) value_cur[23:16] <= reg_dat_di[23:16];
	    if (reg_dat_we[1] == 1'b1) value_cur[15:8] <= reg_dat_di[15:8];
	    if (reg_dat_we[0] == 1'b1) value_cur[7:0] <= reg_dat_di[7:0];

	end else if (loc_enable == 1'b1) begin
	    /* IRQ signals one cycle after stop_out, if IRQ is enabled	*/
	    /* IRQ lasts for one clock cycle only.			*/
	    irq_out <= (irq_ena) ? (stop_out & ~irq_out) : 1'b0;

	    if (updown == 1'b1) begin
		if (lastenable == 1'b0) begin
		    value_cur <= 32'd0;
		    strobe <= 1'b0;
		    stop_out <= 1'b0;
		end else if (chain == 1'b1) begin
		    // Rollover strobe (2 clock cycles advanced)
		    if (value_cur == -1) begin
			strobe <= 1'b1;
		    end else begin
			strobe <= 1'b0;
		    end

		    // Chained counter behavior
		    if ((stop_in == 1'b1) && (value_cur == value_reset)) begin
		    	if (oneshot != 1'b1) begin
			    value_cur <= 32'd0;
		    	    stop_out <= 1'b0;
		    	end else begin
		    	    stop_out <= 1'b1;
			end
		    end else begin
		        if ((stop_in == 1'b1) && (value_cur_plus == value_reset)) begin
		    	    stop_out <= 1'b1;
			end else begin
		    	    stop_out <= 1'b0;
			end
		    	value_cur <= value_cur_plus;	// count up
		    end
		end else begin

		    // Single 32-bit counter behavior
		    if (value_cur == value_reset) begin
		    	if (oneshot != 1'b1) begin
			    value_cur <= 32'd0;
		    	    stop_out <= 1'b0;
		    	end else begin
		    	    stop_out <= 1'b1;
			end
		    end else begin
		        if (value_cur_plus == value_reset) begin
		    	    stop_out <= 1'b1;
			end else begin
		    	    stop_out <= 1'b0;
			end
		    	value_cur <= value_cur_plus;	// count up
		    end
		end
	    end else begin
		if (lastenable == 1'b0) begin
		    value_cur <= value_reset;
		    stop_out <= 1'b0;
		    strobe <= 1'b0;
		end else if (chain == 1'b1) begin
		    // Rollover strobe (2 clock cycles advanced)
		    if (value_cur == 2) begin
			strobe <= 1'b1;
		    end else begin
			strobe <= 1'b0;
		    end

		    // Chained counter behavior
		    if ((stop_in == 1'b1) && (value_cur == 32'd0)) begin
		    	if (oneshot != 1'b1) begin
			    value_cur <= value_reset;
			    stop_out <= 1'b0;
			end else begin
			    stop_out <= 1'b1;
			end
		    end else begin
		    	if ((stop_in == 1'b1) && (value_cur_minus == 32'd0)) begin
			    stop_out <= 1'b1;
			end else begin
		    	    stop_out <= 1'b0;
			end
		    	value_cur <= value_cur_minus;	// count down
		    end
		end else begin

		    // Single 32-bit counter behavior
		    if (value_cur == 32'd0) begin
		    	if (oneshot != 1'b1) begin
			    value_cur <= value_reset;
			    stop_out <= 1'b0;
			end else begin
			    stop_out <= 1'b1;
			end
		    end else begin
		    	if (value_cur_minus == 32'd0) begin
			    stop_out <= 1'b1;
			end else begin
		    	    stop_out <= 1'b0;
			end
		    	value_cur <= value_cur_minus;	// count down
		    end
		end
	    end
	end else begin
	    strobe <= 1'b0;
	end
    end
end

endmodule
`default_nettype wire
