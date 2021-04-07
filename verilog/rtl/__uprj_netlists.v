`include "defines.v"

`ifdef GL
	`include "gl/user_project_wrapper.v"
`else
    `include "user_project_wrapper.v"
`endif