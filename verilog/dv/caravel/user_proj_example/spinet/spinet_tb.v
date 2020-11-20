`default_nettype none

`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"

module spinet_tb;
	reg clock;
	reg ext_clock;
    	reg RSTB;
	reg power1, power2;
	reg power3, power4;

    	wire gpio;
    	wire [37:0] mprj_io;

	localparam N = 6;

	// SPI signals for each node
	reg  [N-1:0] mosi, sck, ss;
	wire [N-1:0]miso, txrdy, rxrdy;
	assign mprj_io[5:0]   = mosi;
	assign mprj_io[11:6]  = sck;
	assign mprj_io[17:12] = ss;
	assign miso  = mprj_io[23:18];
	assign txrdy = mprj_io[29:24];
	assign rxrdy = mprj_io[35:30];

	initial begin
		sck = 0;
		ss = ~0;
		mosi = 0;
	end

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #12.5 clock <= (clock === 1'b0);
	always #6.25 ext_clock <= (ext_clock === 1'b0);

	initial begin
		clock = 0;
	        ext_clock = 0;
	end

	initial begin
		$dumpfile("spinet.vcd");
		$dumpvars(0, spinet_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (30) begin
			repeat (1000) @(posedge clock);
		end
		$display("%c[1;31m",27);
		$display ("Monitor: Timeout, Test Failed");
		$display("%c[0m",27);
		$finish;
	end

	reg [15:0] snd, rcv;
	initial begin
		// Wait for initial reset (not clear what signal to wait for?)
		#1000;
		// Node 2 sends one packet to node 4
		snd <= {2'b10,3'h4,3'h2,8'h42};
		#100 ss[2] <= 0;
		#50;
		repeat (16) begin
			mosi[2] <= snd[15];
			#50 sck[2] <= 1;
			rcv <= {rcv[15:0],miso[2]};
			#50 sck[2] <= 0;
			snd <= snd << 1;
		end
		#100 ss[2] <= 1;
		// Wait for node 4 to see RXRDY
		wait (rxrdy[4] != 0)
		// Node 4 reads the packet
		snd <= 0;
		ss[4] <= 0;
		#50
		repeat (16) begin
			mosi[4] <= snd[15];
			#50 sck[4] <= 1;
			rcv <= {rcv[15:0],miso[4]};
			#50 sck[4] <= 0;
			snd <= snd << 1;
		end
		#100 ss[4] <= 1;
		$display("received: %x", rcv);
		$display("Monitor: Test Passed");
	        $finish;
	end

	initial begin
		RSTB <= 1'b0;
		#2000;
		RSTB <= 1'b1;	    // Release reset
	end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		power3 <= 1'b0;
		power4 <= 1'b0;
		#200;
		power1 <= 1'b1;
		#200;
		power2 <= 1'b1;
		#200;
		power3 <= 1'b1;
		#200;
		power4 <= 1'b1;
	end

    /*
	always @(mprj_io) begin
		#1 $display("MPRJ-IO state = %b ", mprj_io[7:0]);
	end
    */

    	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD1V8;
    	wire VDD3V3;
	wire VSS;
    
	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign USER_VDD3V3 = power3;
	assign USER_VDD1V8 = power4;
	assign VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (USER_VDD3V3),
		.vdda2    (USER_VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (USER_VDD1V8),
		.vccd2	  (USER_VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
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
		.FILENAME("spinet.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
