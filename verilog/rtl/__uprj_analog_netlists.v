`define USE_POWER_PINS

`include "defines.v"

`ifdef GL
	`include "gl/__user_analog_project_wrapper.v"
`else
    `include "__user_analog_project_wrapper.v"
`endif
