`default_nettype none
/*
 *  SPDX-FileCopyrightText: 2015 Clifford Wolf
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *  SPDX-License-Identifier: ISC
 */

module simpleuart_wb # (
    parameter BASE_ADR = 32'h 2000_0000,
    parameter CLK_DIV = 8'h00,
    parameter DATA = 8'h04,
    parameter CONFIG = 8'h08
) (
    input wb_clk_i,
    input wb_rst_i,

    input [31:0] wb_adr_i,      // (verify): input address was originaly 22 bits , why ? (max number of words ?)
    input [31:0] wb_dat_i,
    input [3:0]  wb_sel_i,
    input wb_we_i,
    input wb_cyc_i,
    input wb_stb_i,

    output wb_ack_o,
    output [31:0] wb_dat_o,

    output uart_enabled,
    output ser_tx,
    input  ser_rx

);
    wire [31:0] simpleuart_reg_div_do;
    wire [31:0] simpleuart_reg_dat_do;
    wire [31:0] simpleuart_reg_cfg_do;
    wire reg_dat_wait;

    wire resetn = ~wb_rst_i;
    wire valid = wb_stb_i && wb_cyc_i; 
    wire simpleuart_reg_div_sel = valid && (wb_adr_i == (BASE_ADR | CLK_DIV));
    wire simpleuart_reg_dat_sel = valid && (wb_adr_i == (BASE_ADR | DATA));
    wire simpleuart_reg_cfg_sel = valid && (wb_adr_i == (BASE_ADR | CONFIG));

    wire [3:0] reg_div_we = simpleuart_reg_div_sel ? (wb_sel_i & {4{wb_we_i}}): 4'b 0000; 
    wire reg_dat_we = simpleuart_reg_dat_sel ? (wb_sel_i[0] & wb_we_i): 1'b 0;      // simpleuart_reg_dat_sel ? mem_wstrb[0] : 1'b 0
    wire reg_cfg_we = simpleuart_reg_cfg_sel ? (wb_sel_i[0] & wb_we_i): 1'b 0; 

    wire [31:0] mem_wdata = wb_dat_i;
    wire reg_dat_re = simpleuart_reg_dat_sel && !wb_sel_i && ~wb_we_i; // read_enable

    assign wb_dat_o = simpleuart_reg_div_sel ? simpleuart_reg_div_do:
		      simpleuart_reg_cfg_sel ? simpleuart_reg_cfg_do:
					       simpleuart_reg_dat_do;
    assign wb_ack_o = (simpleuart_reg_div_sel || simpleuart_reg_dat_sel
			|| simpleuart_reg_cfg_sel) && (!reg_dat_wait);
    
    simpleuart simpleuart (
        .clk    (wb_clk_i),
        .resetn (resetn),

        .ser_tx      (ser_tx),
        .ser_rx      (ser_rx),
	.enabled     (uart_enabled),

        .reg_div_we  (reg_div_we), 
        .reg_div_di  (mem_wdata),
        .reg_div_do  (simpleuart_reg_div_do),

        .reg_cfg_we  (reg_cfg_we), 
        .reg_cfg_di  (mem_wdata),
        .reg_cfg_do  (simpleuart_reg_cfg_do),

        .reg_dat_we  (reg_dat_we),
        .reg_dat_re  (reg_dat_re),
        .reg_dat_di  (mem_wdata),
        .reg_dat_do  (simpleuart_reg_dat_do),
        .reg_dat_wait(reg_dat_wait)
    );

endmodule

module simpleuart (
    input clk,
    input resetn,

    output enabled,
    output ser_tx,
    input  ser_rx,

    input   [3:0] reg_div_we,         
    input  [31:0] reg_div_di,         
    output [31:0] reg_div_do,         

    input   	  reg_cfg_we,         
    input  [31:0] reg_cfg_di,         
    output [31:0] reg_cfg_do,         

    input         reg_dat_we,         
    input         reg_dat_re,         
    input  [31:0] reg_dat_di,
    output [31:0] reg_dat_do,
    output        reg_dat_wait
);
    reg [31:0] cfg_divider;
    reg        enabled;

    reg [3:0] recv_state;
    reg [31:0] recv_divcnt;
    reg [7:0] recv_pattern;
    reg [7:0] recv_buf_data;
    reg recv_buf_valid;

    reg [9:0] send_pattern;
    reg [3:0] send_bitcnt;
    reg [31:0] send_divcnt;
    reg send_dummy;

    assign reg_div_do = cfg_divider;
    assign reg_cfg_do = {31'd0, enabled};

    assign reg_dat_wait = reg_dat_we && (send_bitcnt || send_dummy);
    assign reg_dat_do = recv_buf_valid ? recv_buf_data : ~0;

    always @(posedge clk) begin
        if (!resetn) begin
            cfg_divider <= 1;
	    enabled <= 1'b0;
        end else begin
            if (reg_div_we[0]) cfg_divider[ 7: 0] <= reg_div_di[ 7: 0];
            if (reg_div_we[1]) cfg_divider[15: 8] <= reg_div_di[15: 8];
            if (reg_div_we[2]) cfg_divider[23:16] <= reg_div_di[23:16];
            if (reg_div_we[3]) cfg_divider[31:24] <= reg_div_di[31:24];
            if (reg_cfg_we) enabled <= reg_div_di[0];
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            recv_state <= 0;
            recv_divcnt <= 0;
            recv_pattern <= 0;
            recv_buf_data <= 0;
            recv_buf_valid <= 0;
        end else begin
            recv_divcnt <= recv_divcnt + 1;
            if (reg_dat_re)
                recv_buf_valid <= 0;
            case (recv_state)
                0: begin
                    if (!ser_rx && enabled)
                        recv_state <= 1;
                    recv_divcnt <= 0;
                end
                1: begin
                    if (2*recv_divcnt > cfg_divider) begin
                        recv_state <= 2;
                        recv_divcnt <= 0;
                    end
                end
                10: begin
                    if (recv_divcnt > cfg_divider) begin
                        recv_buf_data <= recv_pattern;
                        recv_buf_valid <= 1;
                        recv_state <= 0;
                    end
                end
                default: begin
                    if (recv_divcnt > cfg_divider) begin
                        recv_pattern <= {ser_rx, recv_pattern[7:1]};
                        recv_state <= recv_state + 1;
                        recv_divcnt <= 0;
                    end
                end
            endcase
        end
    end

    assign ser_tx = send_pattern[0];

    always @(posedge clk) begin
        if (reg_div_we && enabled)
            send_dummy <= 1;
        send_divcnt <= send_divcnt + 1;
        if (!resetn) begin
            send_pattern <= ~0;
            send_bitcnt <= 0;
            send_divcnt <= 0;
            send_dummy <= 1;
        end else begin
            if (send_dummy && !send_bitcnt) begin
                send_pattern <= ~0;
                send_bitcnt <= 15;
                send_divcnt <= 0;
                send_dummy <= 0;
            end else
            if (reg_dat_we && !send_bitcnt) begin
                send_pattern <= {1'b1, reg_dat_di[7:0], 1'b0};
                send_bitcnt <= 10;
                send_divcnt <= 0;
            end else
            if (send_divcnt > cfg_divider && send_bitcnt) begin
                send_pattern <= {1'b1, send_pattern[9:1]};
                send_bitcnt <= send_bitcnt - 1;
                send_divcnt <= 0;
            end
        end
    end
endmodule
`default_nettype wire
