
`timescale 1 ns / 1 ps

`include "harness.v"
`include "spiflash.v"

module sysctrl_tb;
	reg XCLK;
	reg XI;

	reg real adc_h, adc_l;
	reg real adc_0, adc_1;
	reg real comp_n, comp_p;
	reg SDI, CSB, SCK, RSTB;

	wire [15:0] gpio;
	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire flash_io2;
	wire flash_io3;
	wire SDO;

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
		$dumpfile("sysctrl_tb.vcd");
		$dumpvars(0, sysctrl_tb);
		repeat (25) begin
			repeat (1000) @(posedge XCLK);
			$display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		$display ("Monitor: Timeout, Test GPIO (RTL) Failed");
		 $display("%c[0m",27);
		$finish;
	end

	always @(gpio) begin
		if(gpio == 16'hA040) begin
			$display("System control Test started");
		end
		else if(gpio == 16'hAB40) begin
			$display("%c[1;31m",27);
			$display("Monitor: System control (RTL) Test failed");
			$display("%c[0m",27);
			$finish;
		end
		else if(gpio == 16'hAB41) begin
			$display("Monitor: System control product ID read passed");
		end
        else if(gpio == 16'hAB50) begin
            $display("%c[1;31m",27);
			$display("Monitor: System control manufacture ID read failed");
			$display("%c[0m",27);
			$finish;
        end else if(gpio == 16'hAB51) begin
			$display("Monitor: System control manufacture ID read passed");
        end
        else if(gpio == 16'hAB60) begin
            $display("%c[1;31m",27);
			$display("Monitor: System control mask rev read failed");
			$display("%c[0m",27);
			$finish;
        end else if(gpio == 16'hAB61) begin
			$display("Monitor: System control mask rev read passed");
        end
        else if(gpio == 16'hAB70) begin
            $display("%c[1;31m",27);
			$display("Monitor: System control pll-bypass read failed");
			$display("%c[0m",27);
			$finish;
        end else if(gpio == 16'hAB71) begin
			$display("Monitor: System control pll-bypass read passed");
        end
        else if(gpio == 16'hAB80) begin
            $display("%c[1;31m",27);
			$display("Monitor: System control pll-config read failed");
			$display("%c[0m",27);
			$finish;
        end else if(gpio == 16'hAB81) begin
			$display("Monitor: System control pll-config read passed");
        end
        else if(gpio == 16'hAB90) begin
            $display("%c[1;31m",27);
			$display("Monitor: System control spi-enables read failed");
			$display("%c[0m",27);
			$finish;
        end else if(gpio == 16'hAB91) begin
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

	always @(gpio) begin
		#1 $display("GPIO state = %b ", gpio);
	end

	wire VDD3V3;
	wire VDD1V8;
	wire VSS;
	
	assign VSS = 1'b0;
	assign VDD1V8 = 1'b1;
	assign VDD3V3 = 1'b1;

	harness uut (
		.vdd	  (VDD3V3),
		.vdd1v8	  (VDD1V8),
		.vss	  (VSS),
		.xi	      (XI),
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
		.FILENAME("sysctrl.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(flash_io2),
		.io3(flash_io3)
	);

endmodule
