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

module gpio_tb;
	wire VDD3V3;
	assign VDD3V3 = 1'b1;

	reg clock;

	always #10 clock <= (clock === 1'b0);

	initial begin
		clock <= 0;
	end

	initial begin
		$dumpfile("gpio.vcd");
		$dumpvars(0, gpio_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (25) begin
			repeat (1000) @(posedge clock);
			$display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		$display ("Monitor: Timeout, Test GPIO (RTL) Failed");
		 $display("%c[0m",27);
		$finish;
	end

	wire [15:0] checkbits;

	reg [7:0] checkbits_lo;
	wire [7:0] checkbits_hi;

	assign checkbits[7:0] = checkbits_lo;
	assign checkbits_hi = checkbits[15:8];

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	reg RSTB;
	reg CSB, SCK, SDI;
	wire SDO;

	// Transactor
	initial begin
		checkbits_lo = {8{1'bz}};
		wait(checkbits_hi == 8'hA0);
		checkbits_lo = 8'hF0;
		wait(checkbits_hi == 8'h0B);
		checkbits_lo = 8'h0F;
		wait(checkbits_hi == 8'hAB);
		checkbits_lo = 8'h0;
		repeat (1000) @(posedge clock);
		checkbits_lo = 8'h1;
		repeat (1000) @(posedge clock);
		checkbits_lo = 8'h3;
	end

	// Monitor
	initial begin
		wait(checkbits_hi == 8'hA0);
		wait(checkbits[7:0] == 8'hF0);
		wait(checkbits_hi== 8'h0B);
		wait(checkbits[7:0] == 8'h0F);
		wait(checkbits_hi== 8'hAB);
		wait(checkbits[7:0] == 8'h00);
		wait(checkbits_hi== 8'h01);
		wait(checkbits[7:0] == 8'h01);
		wait(checkbits_hi== 8'h02);
		wait(checkbits[7:0] == 8'h03);
		wait(checkbits_hi== 8'h04);
		$display("Monitor: Test GPIO (RTL) Passed");
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
	end

	always @(checkbits) begin
		#1 $display("GPIO state = %b (%d - %d)", checkbits,
				checkbits_hi, checkbits_lo);
	end

	wire VDD1V8;
	wire VSS;

	assign VSS = 1'b0;
	assign VDD1V8 = 1'b1;

	// These are the mappings of mprj_io GPIO pads that are set to
	// specific functions on startup:
	//
	// JTAG      = mgmt_gpio_io[0]              (inout)
	// SDO       = mgmt_gpio_io[1]              (output)
	// SDI       = mgmt_gpio_io[2]              (input)
	// CSB       = mgmt_gpio_io[3]              (input)
	// SCK       = mgmt_gpio_io[4]              (input)
	// ser_rx    = mgmt_gpio_io[5]              (input)
	// ser_tx    = mgmt_gpio_io[6]              (output)
	// irq       = mgmt_gpio_io[7]              (input)
	//
	// Therefore to connect SDO, SDI, CSB, and SCK,
	// apply {27'bz, SCK, CSB, SDI, SDO, 1'bz} to mprj_io (32 bits)

	wire [11:0] noconnect;
	wire [2:0] spi_sigs;

	assign spi_sigs = 3'b010;

	caravel uut (
		.vdd3v3	  (VDD3V3),
		.vdd1v8	  (VDD1V8),
		.vss	  (VSS),
		.clock	  (clock),
		.gpio     (gpio),
		.mprj_io  ({checkbits, noconnect[11:1],
				// SCK, CSB, SDI, SDO, noconnect[0]}),
				spi_sigs, SDO, noconnect[0]}),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("gpio.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
