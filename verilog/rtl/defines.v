// Global parameters

`define MPRJ_IO_PADS 38
`define MPRJ_PWR_PADS 4		/* vdda1, vccd1, vdda2, vccd2 */

// Size of soc_mem_synth

// Type and size of soc_mem
// `define USE_OPENRAM
`define USE_CUSTOM_DFFRAM
// don't change the following without double checking addr widths
`define MEM_WORDS 256

// not really parameterized but just to easily keep track of the number
// of ram_block across different modules
`define RAM_BLOCKS 2