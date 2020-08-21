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

`include "harness.v"
`include "spiflash.v"

module gpio_tb;
	reg XCLK;

	wire VDD3V3;
	assign VDD3V3 = 1'b1;

	reg XI;

	reg real adc_h, adc_l;
	reg real adc_0, adc_1;
	reg real comp_n, comp_p;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #10 XCLK <= (XCLK === 1'b0);
	always #220 XI <= (XI === 1'b0);

	initial begin
		XI = 0;
		XCLK = 0;
	end

	initial begin
		// Analog input pin values
		adc_h = 0.0;
		adc_l = 0.0;
		adc_0 = 0.0;
		adc_1 = 0.0;
		comp_n = 0.0;
		comp_p = 0.0;
		#2000;
		adc_h = 3.25;
		adc_l = 0.05;
		adc_0 = 1.0;
		adc_1 = 1.5;
		comp_n = 2.0;
		comp_p = 2.5;
	end

	initial begin
		$dumpfile("gpio.vcd");
		$dumpvars(0, gpio_tb);

		// Repeat cycles of 1000 XCLK edges as needed to complete testbench
		repeat (25) begin
			repeat (1000) @(posedge XCLK);
			$display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		$display ("Monitor: Timeout, Test GPIO (RTL) Failed");
		 $display("%c[0m",27);
		$finish;
	end

	wire [15:0] gpio;

	reg [7:0] gpio_lo;
	wire [7:0] gpio_hi;

	assign gpio[7:0] = gpio_lo;
	assign gpio_hi = gpio[15:8];

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire flash_io2;
	wire flash_io3;

	reg SDI, CSB, SCK, RSTB;
	wire SDO;

	// Transactor
	initial begin
		gpio_lo = {8{1'bz}};
		wait(gpio_hi==8'hA0);
		gpio_lo = 8'hF0;
		wait(gpio_hi==8'h0B);
		gpio_lo = 8'h0F;
		wait(gpio_hi==8'hAB);
		gpio_lo = 8'h0;
		repeat (1000) @(posedge XCLK);
		gpio_lo = 8'h1;
		repeat (1000) @(posedge XCLK);
		gpio_lo = 8'h3;
	end

	// Monitor
	initial begin
		wait(gpio_hi==8'hA0);
		wait(gpio[7:0]==8'hF0);
		wait(gpio_hi==8'h0B);
		wait(gpio[7:0]==8'h0F);
		wait(gpio_hi==8'hAB);
		wait(gpio[7:0]==8'h00);
		wait(gpio_hi==8'h01);
		wait(gpio[7:0]==8'h01);
		wait(gpio_hi==8'h02);
		wait(gpio[7:0]==8'h03);
		wait(gpio_hi==8'h04);
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
		CSB <= 1'b0;	    // Apply CSB to start transmission
	end

	always @(gpio) begin
		#1 $display("GPIO state = %b (%d - %d)", gpio, gpio_hi, gpio_lo);
	end

	wire VDD1V8;
	wire VSS;

	assign VSS = 1'b0;
	assign VDD1V8 = 1'b1;

	harness uut (
		.vdd	  (VDD3V3),
		.vdd1v8	  (VDD1V8),
		.vss	  (VSS),
		.xi	  	  (XI),
		.xclk	  (XCLK),
		.SDI	  (SDI),
		.SDO	  (SDO),
		.CSB	  (CSB),
		.SCK	  (SCK),
		.ser_rx	  (1'b0),
		.ser_tx	  (),
		.irq	  (1'b0),
		.gpio     (gpio),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.flash_io2(flash_io2),
		.flash_io3(flash_io3),
		.adc_high (adc_h),
		.adc_low  (adc_l),
		.adc0_in  (adc_0),
		.adc1_in  (adc_1),
		.RSTB	  (RSTB),
		.comp_inp (comp_p),
		.comp_inn (comp_n)
	);

	spiflash #(
		.FILENAME("gpio.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(flash_io2),
		.io3(flash_io3)
	);

endmodule
