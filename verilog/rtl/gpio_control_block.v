/* 
 *---------------------------------------------------------------------
 * This block interfaces between the sky130_fd_io GPIOv2 pad, the
 * caravel management area, and the user project area.
 *
 * The management area has ultimate control over the setting of the
 * pad, and can modify all core-voltage inputs to the pad and monitor
 * the output.
 *
 * The user project will rely on the management SoC startup program
 * to configure each I/O pad to a fixed configuration except for
 * the output enable which remains under user control.
 *
 * This module is bit-sliced.  Instantiate once for each GPIO pad.
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
    parameter PAD_CTRL_BITS = 13
) (
    // Management Soc-facing signals
    input  	 resetn,		// Global reset
    input  	 serial_clock,

    inout        mgmt_gpio_io,		// Management to/from pad

    // Serial data chain for pad configuration
    input  	 serial_data_in,
    output 	 serial_data_out,

    // User-facing signals
    input        user_gpio_out,		// User space to pad
    input        user_gpio_outenb,	// Output enable (user)
    output	 user_gpio_in,		// Pad to user space

    // Pad-facing signals (Pad GPIOv2)
    output	 pad_gpio_holdover,
    output	 pad_gpio_slow_sel,
    output	 pad_gpio_vtrip_sel,
    output       pad_gpio_inenb,
    output       pad_gpio_ib_mode_sel,
    output	 pad_gpio_ana_en,
    output	 pad_gpio_ana_sel,
    output	 pad_gpio_ana_pol,
    output [2:0] pad_gpio_dm,
    output       pad_gpio_outenb,
    output	 pad_gpio_out,
    input	 pad_gpio_in
);

    /* Parameters defining the bit offset of each function in the chain */
    localparam MGMT_EN = 0;
    localparam OEB = 1;
    localparam HLDH = 2;
    localparam ENH  = 3;
    localparam INP_DIS = 4;
    localparam MOD_SEL = 5;
    localparam AN_EN = 6;
    localparam AN_SEL = 7;
    localparam AN_POL = 8;
    localparam SLOW = 9;
    localparam TRIP = 10;
    localparam DM = 11;

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

    /* Derived output values */
    wire	pad_gpio_holdover;
    wire	pad_gpio_slow_sel;
    wire	pad_gpio_vtrip_sel;
    wire      	pad_gpio_inenb;
    wire       	pad_gpio_ib_mode_sel;
    wire	pad_gpio_ana_en;
    wire	pad_gpio_ana_sel;
    wire	pad_gpio_ana_pol;
    wire [2:0]  pad_gpio_dm;
    wire        pad_gpio_outenb;
    wire	pad_gpio_out;
    wire	pad_gpio_in;

    /* Serial shift for the above (latched) values */
    reg [PAD_CTRL_BITS-1:0] shift_register;

    /* Utilize reset and clock to encode a load operation */
    wire load_data;
    wire int_reset;

    /* Create internal reset and load signals from input reset and clock */
    assign serial_data_out = shift_register[PAD_CTRL_BITS-1]; 
    assign int_reset = (~resetn) & (~serial_clock);
    assign load_data = (~resetn) & serial_clock;

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
	    mgmt_ena <= 1'b0;
	    gpio_holdover <= 1'b0;	// All signals latched in hold mode
	    gpio_slow_sel <= 1'b0;	// Fast slew rate
	    gpio_vtrip_sel <= 1'b0;	// CMOS mode
            gpio_ib_mode_sel <= 1'b0;	// CMOS mode
	    gpio_inenb <= 1'b0;		// Input enabled
	    gpio_outenb <= 1'b1;	// Output disabled
	    gpio_dm <= 3'b001;		// Configured as input only
	    gpio_ana_en <= 1'b0;	// Digital enabled
	    gpio_ana_sel <= 1'b0;	// Don't-care when gpio_ana_en = 0
	    gpio_ana_pol <= 1'b0;	// Don't-care when gpio_ana_en = 0
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

    /* If pad is configured for input and dm[2:1] is 01, then pad is	*/
    /* configured as pull-up or pull-down depending on dm[0], and to	*/
    /* set the pullup or pulldown condition, the pad output bit must	*/
    /* be set to the opposite state of dm[0].				*/
    /* 		dm[0] = 0 is pull-down;  dm[0] = 1 is pull-up.		*/
    /* Otherwise, the output 

    assign pad_gpio_out = (mgmt_ena) ? mgmt_gpio_io :
		(((gpio_dm[2:1] == 2'b01) && (gpio_inenb == 1'b0)) ?
			~gpio_dm[0] : user_gpio_out);

    /* When under user control, gpio_outenb = 1 means that the pad is	*/
    /* configured as input, and the user outenb is unused.  Otherwise,	*/
    /* the pad outenb signal is controlled by the user.			*/

    assign pad_gpio_outenb = (mgmt_ena) ? gpio_outenb : 
		((gpio_outenb == 1) ? 1'b1 : user_gpio_outenb);

    /* User gpio_in is grounded when the management controls the pad	*/
    assign user_gpio_in = (mgmt_ena) ? 1'b0 : pad_gpio_in;

    /* Management I/O line is set from the pad when the pad is		*/
    /* configured for input.						*/
    assign mgmt_gpio_io = (gpio_inenb == 0) ? pad_gpio_in : 1'bz;

endmodule
