/*
 *  StriVe - A full example SoC using PicoRV32 in SkyWater s8
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *  Copyright (C) 2018  Tim Edwards <tim@efabless.com>
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
 */

`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"
`include "tbuart.v"

module uart_tb;
	reg clock;

	reg SDI, CSB, SCK, RSTB;

	wire gpio;
	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire flash_io2;
	wire flash_io3;
	wire [15:0] checkbits;
	wire [13:0] noconnect;
	wire uart_tx;
	wire uart_rx;
	wire SDO;

	always #12.5 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	initial begin
		$dumpfile("uart.vcd");
		$dumpvars(0, uart_tb);

		$display("Wait for UART o/p");
		repeat (150) begin
			repeat (10000) @(posedge clock);
			// Diagnostic. . . interrupts output pattern.
		end
		$finish;
	end

	initial begin
		CSB <= 1'b1;
		SCK <= 1'b0;
		SDI <= 1'b0;
		RSTB <= 1'b0;
		#1000;
		RSTB <= 1'b1;	    // Release reset
		#2000;
		CSB <= 1'b0;
	end

	always @(checkbits) begin
		if(checkbits == 16'hA000) begin
			$display("UART Test started");
		end
		else if(checkbits == 16'hAB00) begin
			#20000;		// Allow time for last transmission
			$finish;
		end
	end

	wire VDD3V3;
	wire VDD1V8;
	wire VSS;

	assign VSS = 1'b0;
	assign VDD1V8 = 1'b1;
	assign VDD3V3 = 1'b1;

	caravel uut (
		.vdd3v3	  (VDD3V3),
		.vdd1v8	  (VDD1V8),
		.vss	  (VSS),
		.clock	  (clock),
		.gpio     (gpio),
		.mprj_io  ({checkbits, noconnect[13:5],
				uart_tx, uart_rx, noconnect[4:0]}),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("uart.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

	// Testbench UART
	tbuart tbuart (
		.ser_rx(uart_tx)
	);
		
endmodule
