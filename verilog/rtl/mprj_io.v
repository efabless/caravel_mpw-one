module mprj_io(
	inout vdd,
	inout vdd1v8,
	inout vss,
	input vddio_q,
	input vssio_q,
	input analog_a,
	input analog_b,
	input [`MPRJ_IO_PADS-1:0] io,
	input [`MPRJ_IO_PADS-1:0] io_out,
	input [`MPRJ_IO_PADS-1:0] oeb_n,
    input [`MPRJ_IO_PADS-1:0] hldh_n,
	input [`MPRJ_IO_PADS-1:0] enh,
    input [`MPRJ_IO_PADS-1:0] inp_dis,
    input [`MPRJ_IO_PADS-1:0] ib_mode_sel,
    input [`MPRJ_IO_PADS-1:0] analog_en,
    input [`MPRJ_IO_PADS-1:0] analog_sel,
    input [`MPRJ_IO_PADS-1:0] analog_pol,
    input [`MPRJ_IO_PADS*3-1:0] dm,
	output [`MPRJ_IO_PADS-1:0] io_in
);

	`MPRJ_IO_PAD_V(io, io_in, io_out, `MPRJ_IO_PADS, 
		oeb_n, hldh_n, enh, inp_dis, ib_mode_sel,
		analog_en, analog_sel, analog_pol, dm);

endmodule