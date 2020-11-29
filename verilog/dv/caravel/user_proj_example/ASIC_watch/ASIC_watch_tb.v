`default_nettype none

`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"

module ASIC_watch_tb;
    reg clock;
    reg RSTB;
    reg power1, power2;
    reg power3, power4;

    wire gpio;
    wire [37:0] mprj_io;
    // inputs
    reg clk_32768;
    reg safemode;

    // outputs
    wire [6:0] segment_hxxx;
    wire [6:0] segment_xhxx;
    wire [6:0] segment_xxhx;
    wire [6:0] segment_xxxh;

    assign segment_hxxx[0] = uut.gpio_control_in[8].pad_gpio_out;
    assign segment_hxxx[1] = uut.gpio_control_in[9].pad_gpio_out;
    assign segment_hxxx[2] = uut.gpio_control_in[10].pad_gpio_out;
    assign segment_hxxx[3] = uut.gpio_control_in[11].pad_gpio_out;
    assign segment_hxxx[4] = uut.gpio_control_in[12].pad_gpio_out;
    assign segment_hxxx[5] = uut.gpio_control_in[13].pad_gpio_out;
    assign segment_hxxx[6] = uut.gpio_control_in[14].pad_gpio_out;

    assign segment_xhxx[0] = uut.gpio_control_in[15].pad_gpio_out;
    assign segment_xhxx[1] = uut.gpio_control_in[16].pad_gpio_out;
    assign segment_xhxx[2] = uut.gpio_control_in[17].pad_gpio_out;
    assign segment_xhxx[3] = uut.gpio_control_in[18].pad_gpio_out;
    assign segment_xhxx[4] = uut.gpio_control_in[19].pad_gpio_out;
    assign segment_xhxx[5] = uut.gpio_control_in[20].pad_gpio_out;
    assign segment_xhxx[6] = uut.gpio_control_in[21].pad_gpio_out;

    assign segment_xxhx[0] = uut.gpio_control_in[22].pad_gpio_out;
    assign segment_xxhx[1] = uut.gpio_control_in[23].pad_gpio_out;
    assign segment_xxhx[2] = uut.gpio_control_in[24].pad_gpio_out;
    assign segment_xxhx[3] = uut.gpio_control_in[25].pad_gpio_out;
    assign segment_xxhx[4] = uut.gpio_control_in[26].pad_gpio_out;
    assign segment_xxhx[5] = uut.gpio_control_in[27].pad_gpio_out;
    assign segment_xxhx[6] = uut.gpio_control_in[28].pad_gpio_out;

    assign segment_xxxh[0] = uut.gpio_control_in[29].pad_gpio_out;
    assign segment_xxxh[1] = uut.gpio_control_in[30].pad_gpio_out;
    assign segment_xxxh[2] = uut.gpio_control_in[31].pad_gpio_out;
    assign segment_xxxh[3] = uut.gpio_control_in[32].pad_gpio_out;
    assign segment_xxxh[4] = uut.gpio_control_in[33].pad_gpio_out;
    assign segment_xxxh[5] = uut.gpio_control_in[34].pad_gpio_out;
    assign segment_xxxh[6] = uut.gpio_control_in[35].pad_gpio_out;

    assign mprj_io[36] = safemode ;
    assign mprj_io[37] = clk_32768;

    // External clock is used by default.  Make this artificially fast for the
    // simulation.  Normally this would be a slow clock and the digital PLL
    // would be the fast clock.

    always #12.5 clock <= (clock === 1'b0);
    always #12.5 clk_32768 <= (clk_32768 === 1'b0);

    initial begin
        clock = 0;
        clk_32768 = 0;
        safemode = 0;
    end


    initial begin
        $dumpfile("ASIC_watch.vcd");
        $dumpvars(0, ASIC_watch_tb);

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
        .FILENAME("ASIC_watch.hex")
    ) spiflash (
        .csb(flash_csb),
        .clk(flash_clk),
        .io0(flash_io0),
        .io1(flash_io1),
        .io2(),         // not used
        .io3()          // not used
    );

endmodule
