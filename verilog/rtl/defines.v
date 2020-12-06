`default_nettype none
// Global parameters

`define MPRJ_IO_PADS 38
`define MPRJ_PWR_PADS 4		/* vdda1, vccd1, vdda2, vccd2 */

// Size of soc_mem_synth

// Type and size of soc_mem
// `define USE_OPENRAM
`define USE_CUSTOM_DFFRAM
// don't change the following without double checking addr widths
`define MEM_WORDS 256

// Number of columns in the custom memory; takes one of three values:
// 1 column : 1 KB, 2 column: 2 KB, 4 column: 4KB
`define COLS 1

// not really parameterized but just to easily keep track of the number
// of ram_block across different modules
`define RAM_BLOCKS 2

// Clock divisor default value
`define CLK_DIV 3'b010

// GPIO conrol default mode and enable
`define DM_INIT 3'b110
`define OENB_INIT 1'b1