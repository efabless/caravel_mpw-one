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

`include "caravel_netlists.v"
`include "spiflash.v"

module pll_tb;
	reg clock;
	reg power1;
	reg power2;
	reg RSTB;

	wire gpio;
	wire [15:0] checkbits;
	wire [7:0] spivalue;
	wire [37:0] mprj_io;
	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire SDO;

	assign checkbits = mprj_io[31:16];
	assign spivalue  = mprj_io[15:8];

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #10 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	initial begin
		$dumpfile("pll.vcd");
		$dumpvars(0, pll_tb);
		repeat (25) begin
			repeat (1000) @(posedge clock);
			$display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		$display ("Monitor: Timeout, Test PLL (RTL) Failed");
		$display("%c[0m",27);
		$finish;
	end

	// Monitor
	initial begin
	    wait(checkbits == 16'hA040);
		
		$display("Monitor: Test PLL (RTL) Started");
		
	    wait(checkbits == 16'hA041);
            // $display("   SPI value = 0x%x (should be 0x04)", spivalue);
            // if(spivalue !== 32'h04) begin
            //     $display("Monitor: Test PLL (RTL) Failed");
            //     $finish;
            // end
	    wait(checkbits == 16'hA042);
            // $display("   SPI value = 0x%x (should be 0x56)", spivalue);
            // if(spivalue !== 32'h56) begin
            //     $display("Monitor: Test PLL (RTL) Failed");
            //     $finish;
            // end

	    wait(checkbits == 16'hA090);

		$display("Monitor: Test PLL (RTL) Passed");
		$finish;
	end

	initial begin
		RSTB <= 1'b0;
		#1000;
		RSTB <= 1'b1;	    // Release reset
		`ifdef GL
			// Force feedback loop to an initial state
			#1 force uut.soc.pll.\ringosc.c[0] = 0;
			#1 force uut.soc.pll.\ringosc.dstage[11].id.out = 1; 
			#1;
			release uut.soc.pll.\ringosc.c[0] ;
			release uut.soc.pll.\ringosc.dstage[11].id.out ;
		`endif
		#2000;
		
	end

	initial begin
		power1 <= 1'b0;
		power2 <= 1'b0;
		#200;
		power1 <= 1'b1;
		#200;
		power2 <= 1'b1;
	end

	always @(checkbits) begin
		#1 $display("GPIO state = %b ", checkbits);
	end

	wire VDD3V3_PKG;
	wire VDD1V8_PKG;
	wire VSS_PKG;

	assign VDD3V3_PKG = power1;
	assign VDD1V8_PKG = power2;
	assign VSS_PKG    = 1'b0;


	assign mprj_io[3] = 1'b1;  // Force CSB high.

	caravel uut (
	       	.vddio_pad  	(VDD3V3_PKG),
	       	.vddio_pad2 	(VDD3V3_PKG),
		.vssio_pad	(VSS_PKG),
		.vssio_pad2	(VSS_PKG),
		.vdda_pad	(VDD3V3_PKG),
		.vssa_pad	(VSS_PKG),
		.vccd_pad	(VDD1V8_PKG),
		.vssd_pad	(VSS_PKG),
		.vdda1_pad  	(VDD3V3_PKG),
		.vdda1_pad2  	(VDD3V3_PKG),
		.vdda2_pad    	(VDD3V3_PKG),
		.vssa1_pad	(VSS_PKG),
		.vssa1_pad2	(VSS_PKG),
		.vssa2_pad	(VSS_PKG),
		.vccd1_pad	(VDD1V8_PKG),
		.vccd2_pad	(VDD1V8_PKG),
		.vssd1_pad	(VSS_PKG),
		.vssd2_pad	(VSS_PKG),
		.clock	  (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("pll.hex")
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
