`default_nettype wire
/*
 *  SPDX-FileCopyrightText: 2017  Clifford Wolf, 2018  Tim Edwards
 *
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
 *  SPDX-License-Identifier: ISC
 */

`timescale 1 ns / 1 ps

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

`timescale 1 ns / 1 ps

`define UNIT_DELAY #1

`include "caravel_netlists.v"
`include "spiflash.v"

module gpio_mgmt_tb;

	reg clock;
	wire clock_input;
	reg power1;
	reg power2;

	assign clock_input = clock;
	always #50 clock <= (clock === 1'b0);

	initial begin
		clock <= 0;
	end

	initial begin
		$dumpfile("gpio_mgmt.vcd");
		$dumpvars(3, gpio_mgmt_tb);
	
		$sdf_annotate("mgmt_core.sdf", uut.soc);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (25) begin
			repeat (1000) @(posedge clock);
			$display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("Monitor: Timeout, Test Mgmt GPIO (GL) Failed");
		`else
			$display ("Monitor: Timeout, Test Mgmt GPIO (RTL) Failed");
		`endif
		$display("%c[0m",27);
		$finish;
	end

	wire [37:0] mprj_io;	// Most of these are no-connects
	wire [15:0] checkbits;
	reg  [7:0] checkbits_lo;
	wire [7:0] checkbits_hi;

	assign mprj_io[23:16] = checkbits_lo;
	assign checkbits = mprj_io[31:16];
	assign checkbits_hi = checkbits[15:8];
	assign mprj_io[3] = 1'b1;       // Force CSB high.

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire gpio;

	reg RSTB;

	// Monitor
	initial begin
		wait(gpio == 1'b1);
		wait(gpio == 1'b0);
		$display("Blink.");
		wait(gpio == 1'b1);
		wait(gpio == 1'b0);
		$display("Blink.");
		wait(gpio == 1'b1);
		wait(gpio == 1'b0);
		$display("Blink.");
		wait(gpio == 1'b1);
		wait(gpio == 1'b0);
		$display("Blink.");
		wait(gpio == 1'b1);
		wait(gpio == 1'b0);
		$display("Blink.");
		wait(gpio == 1'b1);
		wait(gpio == 1'b0);
		$display("Blink.");
		wait(gpio == 1'b1);
		wait(gpio == 1'b0);
		$display("Blink.");
		wait(gpio == 1'b1);
		wait(gpio == 1'b0);
		$display("Blink.");
		wait(gpio == 1'b1);
		wait(gpio == 1'b0);
		$display("Blink.");
		wait(gpio == 1'b1);
		wait(gpio == 1'b0);
		`ifdef GL
			$display("Monitor: Test Mgmt GPIO (GL) Passed");
		`else
			$display("Monitor: Test Mgmt GPIO (RTL) Passed");
		`endif
		#2000;
		$finish;
	end

	initial begin
		RSTB <= 1'b0;
		
		#5000;
		RSTB <= 1'b1;	    // Release reset
		#10000;
	end

	initial begin			// Power-up
		power1 <= 1'b0;
		power2 <= 1'b0;
		#1000;
		power1 <= 1'b1;
		#1000;
		power2 <= 1'b1;
	end
		

	always @(checkbits) begin
		#1 $display("Mgmt GPIO state = %b (%d - %d)", checkbits,
				checkbits_hi, checkbits_lo);
	end

	wire VDD3V3;
	wire VDD1V8;
	wire VSS;

	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

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

	caravel uut (
		.vddio_pad	  (VDD3V3),
		.vddio_pad2	  (VDD3V3),
		.vssio_pad	  (VSS),
    	.vssio_pad2	  (VSS),
		.vdda_pad	  (VDD3V3),
		.vssa_pad	  (VSS),
		.vccd_pad	  (VDD1V8),
		.vssd_pad	  (VSS),
		.vdda1_pad    (VDD3V3),
		.vdda2_pad    (VDD3V3),
		.vssa1_pad	  (VSS),
		.vssa1_pad2	  (VSS),
		.vssa2_pad	  (VSS),
		.vccd1_pad	  (VDD1V8),
		.vccd2_pad	  (VDD1V8),
		.vssd1_pad	  (VSS),
		.vssd2_pad	  (VSS),
		.clock	  (clock_input),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("gpio_mgmt.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
`default_nettype wire
