`include caravel.v
// `include mgmt_protect.v

module caravel_lvs_top(vddio, vssio, vdda, vssa, vccd,
	vdda1, vdda2, vssa1, vssa2, vccd1, vccd2, vssd1, vssd2,
	gpio, mprj_io, clock, resetb,
	flash_csb, flash_clk, flash_io0, flash_io1);

    inout vddio, vssio, vdda, vssa, vccd;
    inout vdda1, vdda2, vssa1, vssa2, vccd1, vccd2, vssd1, vssd2;
    inout gpio;
    inout [37:0] mprj_io;
    input clock;
    input resetb;
    output flash_csb, flash_clk;
    inout flash_io0, flash_io1;

    wire [3:0] pwr_ctrl_out;

    /* Just instantiate caravel, but tie the grounds together:
     * vssio = vssio + vssd
     */

    caravel top (
	.vddio(vddio),
	.vssio(vssio),
	.vdda(vdda),
	.vssa(vssa),
	.vccd(vccd),
	.vssd(vssio),
	.vdda1(vdda1),
	.vdda2(vdda2),
	.vssa1(vssa1),
	.vssa2(vssa2),
	.vccd1(vccd1),
	.vccd2(vccd2),
	.vssd1(vssd1),
	.vssd2(vssd2),
	.gpio(gpio),
	.mprj_io(mprj_io),
	.pwr_ctrl_out(pwr_ctrl_out),
	.clock(clock),
	.resetb(resetb),
	.flash_csb(flash_csb),
	.flash_clk(flash_clk),
	.flash_io0(flash_io0),
	.flash_io1(flash_io1)
    );
endmodule
