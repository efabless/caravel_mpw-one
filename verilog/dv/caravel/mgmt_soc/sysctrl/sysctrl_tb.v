
`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"

module sysctrl_tb;
	reg clock;
	reg RSTB;

	wire gpio;
	wire [15:0] checkbits;
	wire [36:0] mprj_io;
	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire SDO;

	assign checkbits = mprj_io[31:16];

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #10 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	initial begin
		$dumpfile("sysctrl_tb.vcd");
		$dumpvars(0, sysctrl_tb);
		repeat (25) begin
			repeat (1000) @(posedge clock);
			$display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		$display ("Monitor: Timeout, Test GPIO (RTL) Failed");
		 $display("%c[0m",27);
		$finish;
	end

	always @(checkbits) begin
		if(checkbits == 16'hA040) begin
			$display("System control Test started");
		end
		else if(checkbits == 16'hAB40) begin
			$display("%c[1;31m",27);
			$display("Monitor: System control (RTL) Test failed");
			$display("%c[0m",27);
			$finish;
		end
		else if(checkbits == 16'hAB41) begin
			$display("Monitor: System control product ID read passed");
		end
        else if(checkbits == 16'hAB50) begin
            $display("%c[1;31m",27);
			$display("Monitor: System control manufacture ID read failed");
			$display("%c[0m",27);
			$finish;
        end else if(checkbits == 16'hAB51) begin
			$display("Monitor: System control manufacture ID read passed");
        end
        else if(checkbits == 16'hAB60) begin
            $display("%c[1;31m",27);
			$display("Monitor: System control mask rev read failed");
			$display("%c[0m",27);
			$finish;
        end else if(checkbits == 16'hAB61) begin
			$display("Monitor: System control mask rev read passed");
        end
        else if(checkbits == 16'hAB70) begin
            $display("%c[1;31m",27);
			$display("Monitor: System control pll-bypass read failed");
			$display("%c[0m",27);
			$finish;
        end else if(checkbits == 16'hAB71) begin
			$display("Monitor: System control pll-bypass read passed");
        end
        else if(checkbits == 16'hAB80) begin
            $display("%c[1;31m",27);
			$display("Monitor: System control pll-config read failed");
			$display("%c[0m",27);
			$finish;
        end else if(checkbits == 16'hAB81) begin
			$display("Monitor: System control pll-config read passed");
        end
        else if(checkbits == 16'hAB90) begin
            $display("%c[1;31m",27);
			$display("Monitor: System control spi-enables read failed");
			$display("%c[0m",27);
			$finish;
        end else if(checkbits == 16'hAB91) begin
			$display("Monitor: System control spi-enables read passed");
			$display("Monitor: Sysctrl (RTL) test passed.");
            $finish;
        end
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

	always @(checkbits) begin
		#1 $display("GPIO state = %b ", checkbits);
	end

	wire VDD3V3;
	wire VDD1V8;
	wire VSS;
	
	assign VSS = 1'b0;
	assign VDD1V8 = 1'b1;
	assign VDD3V3 = 1'b1;

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock    (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("sysctrl.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
