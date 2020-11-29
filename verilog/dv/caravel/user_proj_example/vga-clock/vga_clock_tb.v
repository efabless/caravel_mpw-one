`default_nettype none

`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"

module vga_clock_tb;
    reg clock;
    reg RSTB;
    reg power1, power2;
    reg power3, power4;

    wire gpio;
    wire [37:0] mprj_io;
    wire [5:0] rrggbb;
    wire hsync, vsync;

    assign hsync = uut.gpio_control_in[11].pad_gpio_out;
    assign vsync = uut.gpio_control_in[12].pad_gpio_out;
    assign rrggbb = {
        uut.gpio_control_in[13].pad_gpio_out,
        uut.gpio_control_in[14].pad_gpio_out,
        uut.gpio_control_in[15].pad_gpio_out,
        uut.gpio_control_in[16].pad_gpio_out,
        uut.gpio_control_in[17].pad_gpio_out,
        uut.gpio_control_in[18].pad_gpio_out
    };

    reg adj_hrs = 0;
    reg adj_min = 0;
    reg adj_sec = 0;
   assign mprj_io[8] = adj_hrs;
   assign mprj_io[9] = adj_min;
   assign mprj_io[10] = adj_sec;
/* this doesn't work
    assign uut.gpio_control_in[ 8].pad_gpio_in = adj_hrs;
    assign uut.gpio_control_in[ 9].pad_gpio_in = adj_min;
    assign uut.gpio_control_in[10].pad_gpio_in = adj_sec;
    */

    // External clock is used by default.  Make this artificially fast for the
    // simulation.  Normally this would be a slow clock and the digital PLL
    // would be the fast clock.

    always #12.5 clock <= (clock === 1'b0);

    initial begin
        clock = 0;
    end

    initial begin
        $dumpfile("vga_clock.vcd");
        $dumpvars(0, vga_clock_tb);

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
        // wait for reset, we have 2 before the project is ready
        wait(uut.mprj.mprj.proj_2.reset == 1);
        wait(uut.mprj.mprj.proj_2.reset == 0);
        wait(uut.mprj.mprj.proj_2.reset == 1);
        wait(uut.mprj.mprj.proj_2.reset == 0);

        // press all the buttons! button clk_en deboucing is slow so don't want to wait around
        adj_hrs = 1;
        adj_min = 1;
        adj_sec = 1;
        wait(uut.mprj.mprj.proj_2.hrs_u == 1);
        $display ("adjusted hours ok");
        wait(uut.mprj.mprj.proj_2.min_u == 1);
        $display ("adjusted min ok");
        wait(uut.mprj.mprj.proj_2.sec_u == 1);
        $display ("adjusted sec ok");
        
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
        .FILENAME("vga_clock.hex")
    ) spiflash (
        .csb(flash_csb),
        .clk(flash_clk),
        .io0(flash_io0),
        .io1(flash_io1),
        .io2(),         // not used
        .io3()          // not used
    );

endmodule
