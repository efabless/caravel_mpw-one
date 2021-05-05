// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

/* 
 *---------------------------------------------------------------------
 * See gpio_control_block for description.  This module is like
 * gpio_contro_block except that it has an additional two management-
 * Soc-facing pins, which are the out_enb line and the output line.
 * If the chip is configured for output with the oeb control
 * register = 1, then the oeb line is controlled by the additional
 * signal from the management SoC.  If the oeb control register = 0,
 * then the output is disabled completely.  The "io" line is input
 * only in this module.
 *
 *---------------------------------------------------------------------
 */

/*
 *---------------------------------------------------------------------
 *
 * This module instantiates a shift register chain that passes through
 * each gpio cell.  These are connected end-to-end around the padframe
 * periphery.  The purpose is to avoid a massive number of control
 * wires between the digital core and I/O, passing through the user area.
 *
 * See mprj_ctrl.v for the module that registers the data for each
 * I/O and drives the input to the shift register.
 *
 *---------------------------------------------------------------------
 */

module gpio_control_block #(
    parameter PAD_CTRL_BITS = 13,
    // Parameterized initial startup state of the pad.
    // The default parameters if unspecified is for the pad to be
    // an input with no pull-up or pull-down, so that it is disconnected
    // from the outside world.
    parameter HOLD_INIT = 1'b0,
    parameter SLOW_INIT = 1'b0,
    parameter TRIP_INIT = 1'b0,
    parameter IB_INIT = 1'b0,
    parameter IENB_INIT = 1'b0,
    parameter OENB_INIT = `OENB_INIT,
    parameter DM_INIT = `DM_INIT,
    parameter AENA_INIT = 1'b0,
    parameter ASEL_INIT = 1'b0,
    parameter APOL_INIT = 1'b0
) (
    `ifdef USE_POWER_PINS
         inout vccd,
         inout vssd,
         inout vccd1,
         inout vssd1,
    `endif

    // Management Soc-facing signals
    input  	 wire resetn,		// Global reset, locally propagated
    output   wire resetn_out,
    input  	 wire serial_clock,		// Global clock, locally propatated
    output   wire serial_clock_out,

    output   wire mgmt_gpio_in,		// Management from pad (input only)
    input    wire mgmt_gpio_out,    // Management to pad (output only)
    input    wire mgmt_gpio_oeb,	// Management to pad (output only)

    // Serial data chain for pad configuration
    input  	 wire serial_data_in,
    output 	 wire serial_data_out,

    // User-facing signals
    input    wire user_gpio_out,		// User space to pad
    input    wire user_gpio_oeb,		// Output enable (user)
    output	 wire user_gpio_in,		// Pad to user space

    // Pad-facing signals (Pad GPIOv2)
    output	 wire pad_gpio_holdover,
    output	 wire pad_gpio_slow_sel,
    output	 wire pad_gpio_vtrip_sel,
    output   wire pad_gpio_inenb,
    output   wire pad_gpio_ib_mode_sel,
    output	 wire pad_gpio_ana_en,
    output	 wire pad_gpio_ana_sel,
    output	 wire pad_gpio_ana_pol,
    output   wire [2:0] pad_gpio_dm,
    output   wire pad_gpio_outenb,
    output	 wire pad_gpio_out,
    input	 wire pad_gpio_in,

    // to provide a way to automatically disable/enable output
    // from the outside with needing a conb cell
    output	 wire one,
    output	 wire zero
);

    /* Parameters defining the bit offset of each function in the chain */
    localparam MGMT_EN = 0;
    localparam OEB = 1;
    localparam HLDH = 2;
    localparam INP_DIS = 3;
    localparam MOD_SEL = 4;
    localparam AN_EN = 5;
    localparam AN_SEL = 6;
    localparam AN_POL = 7;
    localparam SLOW = 8;
    localparam TRIP = 9;
    localparam DM = 10;

    /* Internally registered signals */
    reg	 	mgmt_ena;		// Enable management SoC to access pad
    reg	 	gpio_holdover;
    reg	 	gpio_slow_sel;
    reg	  	gpio_vtrip_sel;
    reg  	gpio_inenb;
    reg	 	gpio_ib_mode_sel;
    reg  	gpio_outenb;
    reg [2:0] 	gpio_dm;
    reg	 	gpio_ana_en;
    reg	 	gpio_ana_sel;
    reg	 	gpio_ana_pol;

    wire gpio_in_unbuf;
    wire gpio_logic1;

    /* Serial shift for the above (latched) values */
    reg [PAD_CTRL_BITS-1:0] shift_register;

    /* Utilize reset and clock to encode a load operation */
    wire load_data;
    wire int_reset;

    /* Create internal reset and load signals from input reset and clock */
    assign serial_data_out = shift_register[PAD_CTRL_BITS-1]; 
    assign int_reset = (~resetn) & (~serial_clock);
    assign load_data = (~resetn) & serial_clock;

    /* Propagate the clock and reset signals so that they aren't wired	*/
    /* all over the chip, but are just wired between the blocks.	*/
    assign serial_clock_out = serial_clock;
    assign resetn_out = resetn;

    always @(posedge serial_clock or posedge int_reset) begin
	if (int_reset == 1'b1) begin
	    /* Clear shift register */
	    shift_register <= 'd0;
	end else begin
	    /* Shift data in */
	    shift_register <= {shift_register[PAD_CTRL_BITS-2:0], serial_data_in};
	end
    end

    always @(posedge load_data or posedge int_reset) begin
	if (int_reset == 1'b1) begin
	    /* Initial state on reset:  Pad set to management input */
	    mgmt_ena <= 1'b1;		// Management SoC has control over all I/O
	    gpio_holdover <= HOLD_INIT;	 // All signals latched in hold mode
	    gpio_slow_sel <= SLOW_INIT;	 // Fast slew rate
	    gpio_vtrip_sel <= TRIP_INIT; // CMOS mode
            gpio_ib_mode_sel <= IB_INIT; // CMOS mode
	    gpio_inenb <= IENB_INIT;	 // Input enabled
	    gpio_outenb <= OENB_INIT;	 // (unused placeholder)
	    gpio_dm <= DM_INIT;		 // Configured as input only
	    gpio_ana_en <= AENA_INIT;	 // Digital enabled
	    gpio_ana_sel <= ASEL_INIT;	 // Don't-care when gpio_ana_en = 0
	    gpio_ana_pol <= APOL_INIT;	 // Don't-care when gpio_ana_en = 0
	end else begin
	    /* Load data */
	    mgmt_ena 	     <= shift_register[MGMT_EN];
	    gpio_outenb      <= shift_register[OEB];
	    gpio_holdover    <= shift_register[HLDH]; 
	    gpio_inenb 	     <= shift_register[INP_DIS];
	    gpio_ib_mode_sel <= shift_register[MOD_SEL];
	    gpio_ana_en      <= shift_register[AN_EN];
	    gpio_ana_sel     <= shift_register[AN_SEL];
	    gpio_ana_pol     <= shift_register[AN_POL];
	    gpio_slow_sel    <= shift_register[SLOW];
	    gpio_vtrip_sel   <= shift_register[TRIP];
	    gpio_dm 	     <= shift_register[DM+2:DM];

	end
    end

    /* These pad configuration signals are static and do not change	*/
    /* after setup.							*/

    assign pad_gpio_holdover 	= gpio_holdover;
    assign pad_gpio_slow_sel 	= gpio_slow_sel;
    assign pad_gpio_vtrip_sel	= gpio_vtrip_sel;
    assign pad_gpio_ib_mode_sel	= gpio_ib_mode_sel;
    assign pad_gpio_ana_en	= gpio_ana_en;
    assign pad_gpio_ana_sel	= gpio_ana_sel;
    assign pad_gpio_ana_pol	= gpio_ana_pol;
    assign pad_gpio_dm		= gpio_dm;
    assign pad_gpio_inenb 	= gpio_inenb;

    /* Implement pad control behavior depending on state of mgmt_ena */

//    assign gpio_in_unbuf =    (mgmt_ena) ? 1'b0 : pad_gpio_in;
//    assign mgmt_gpio_in =    (mgmt_ena) ? ((gpio_inenb == 1'b0) ?
//					pad_gpio_in : 1'bz) : 1'b0;

    assign gpio_in_unbuf =   pad_gpio_in;
    // This causes conflict if output and input drivers are both enabled. . .
    // assign mgmt_gpio_in = (gpio_inenb == 1'b0) ? pad_gpio_in : 1'bz;
    assign mgmt_gpio_in =    (gpio_inenb == 1'b0 && gpio_outenb == 1'b1)? pad_gpio_in : 1'bz;

    assign pad_gpio_outenb =  (mgmt_ena) ? ((mgmt_gpio_oeb == 1'b1) ? gpio_outenb :
					1'b0) : user_gpio_oeb;
    assign pad_gpio_out    =  (mgmt_ena) ? 
			((mgmt_gpio_oeb == 1'b1) ?
			((gpio_dm[2:1] == 2'b01) ? ~gpio_dm[0] : mgmt_gpio_out) :
			mgmt_gpio_out) :
			user_gpio_out; 

    /* Buffer user_gpio_in with an enable that is set by the user domain vccd */

    sky130_fd_sc_hd__conb_1 gpio_logic_high (
`ifdef USE_POWER_PINS
            .VPWR(vccd1),
            .VGND(vssd1),
            .VPB(vccd1),
            .VNB(vssd1),
`endif
            .HI(gpio_logic1),
            .LO()
    );

    sky130_fd_sc_hd__einvp_8 gpio_in_buf (
`ifdef USE_POWER_PINS
            .VPWR(vccd),
            .VGND(vssd),
            .VPB(vccd),
            .VNB(vssd),
`endif
            .Z(user_gpio_in),
            .A(~gpio_in_unbuf),
            .TE(gpio_logic1)
    );

    sky130_fd_sc_hd__conb_1 const_source (
`ifdef USE_POWER_PINS
            .VPWR(vccd),
            .VGND(vssd),
            .VPB(vccd),
            .VNB(vssd),
`endif
            .HI(one),
            .LO(zero)
    );

endmodule
