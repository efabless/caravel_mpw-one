`default_nettype none

`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"

module seven_segment_tb;
    reg clock;
    reg RSTB;
    reg power1, power2;
    reg power3, power4;

    wire gpio;
    wire [37:0] mprj_io;
    wire [6:0] segments;

    
    assign segments = { 
        uut.gpio_control_in[14].pad_gpio_out,
        uut.gpio_control_in[13].pad_gpio_out,
        uut.gpio_control_in[12].pad_gpio_out,
        uut.gpio_control_in[11].pad_gpio_out,
        uut.gpio_control_in[10].pad_gpio_out,
        uut.gpio_control_in[ 9].pad_gpio_out,
        uut.gpio_control_in[ 8].pad_gpio_out
        };

    // External clock is used by default.  Make this artificially fast for the
    // simulation.  Normally this would be a slow clock and the digital PLL
    // would be the fast clock.

    always #12.5 clock <= (clock === 1'b0);

    initial begin
        clock = 0;
    end

    initial begin
        $dumpfile("seven_segment.vcd");
        $dumpvars(0, seven_segment_tb);

        // Repeat cycles of 1000 clock edges as needed to complete testbench
        repeat (15) begin
            repeat (1000) @(posedge clock);
            // $display("+1000 cycles");
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test Mega-Project IO Ports (RTL) Failed");
        $display("%c[0m",27);
        $finish;
    end

    initial begin
        // Observe segments counting from 0 to 9

        wait(segments == 7'b0111111); 
        wait(segments == 7'b0000110);
        wait(segments == 7'b1011011);
        wait(segments == 7'b1001111);
        wait(segments == 7'b1100110);
        wait(segments == 7'b1101101);
        wait(segments == 7'b1111100);
        wait(segments == 7'b0000111);
        wait(segments == 7'b1111111);
        wait(segments == 7'b1111111);
        wait(segments == 7'b1100111);

        $display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
        $finish;
    end

    initial begin
        RSTB <= 1'b0;
        #2000;
        RSTB <= 1'b1;       // Release reset
    end

    initial begin       // Power-up sequence
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
    wire USER_VDD3V3 = power3;
    wire USER_VDD1V8 = power4;
    assign VSS = 1'b0;

    caravel uut (
        .vddio    (VDD3V3),
        .vssio    (VSS),
        .vdda     (VDD3V3),
        .vssa     (VSS),
        .vccd     (VDD1V8),
        .vssd     (VSS),
        .vdda1    (USER_VDD3V3),
        .vdda2    (USER_VDD3V3),
        .vssa1    (VSS),
        .vssa2    (VSS),
        .vccd1    (USER_VDD1V8),
        .vccd2    (USER_VDD1V8),
        .vssd1    (VSS),
        .vssd2    (VSS),
        .clock    (clock),
        .gpio     (gpio),
        .mprj_io  (mprj_io),
        .flash_csb(flash_csb),
        .flash_clk(flash_clk),
        .flash_io0(flash_io0),
        .flash_io1(flash_io1),
        .resetb   (RSTB)
    );

    spiflash #(
        .FILENAME("seven_segment.hex")
    ) spiflash (
        .csb(flash_csb),
        .clk(flash_clk),
        .io0(flash_io0),
        .io1(flash_io1),
        .io2(),         // not used
        .io3()          // not used
    );

endmodule
