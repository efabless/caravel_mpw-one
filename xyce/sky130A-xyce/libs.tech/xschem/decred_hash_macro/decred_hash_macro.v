`include "decred_defines.v"

`ifdef USE_SYSTEM_VERILOG
`define CS_INDEX(a) \
	480-(a*32)+:32

`define SIGMA_INDEX(a,b) \
	892-(a*64)-(b*4)+:4
`endif

`define NUM_OF_THREADS 6

module blake256_qr(
		input wire clk,
		input wire [31 : 0]  m0,
		input wire [31 : 0]  m1,
		input wire [31 : 0]  cs0,
		input wire [31 : 0]  cs1,

		input wire [31 : 0]  a,
		input wire [31 : 0]  b,
		input wire [31 : 0]  c,
		input wire [31 : 0]  d,

		output wire [31 : 0] a_prim,
		output wire [31 : 0] b_prim,
		output wire [31 : 0] c_prim,
		output wire [31 : 0] d_prim
);

  //----------------------------------------------------------------
  // QR module regs/wires
  //----------------------------------------------------------------
  reg [31 : 0] internal_a_prim;
  reg [31 : 0] internal_b_prim;
  reg [31 : 0] internal_c_prim;
  reg [31 : 0] internal_d_prim;

  assign a_prim = internal_a_prim;
  assign b_prim = internal_b_prim;
  assign c_prim = internal_c_prim;
  assign d_prim = internal_d_prim;

  reg [31 : 0] a_reg[2:0];
  reg [31 : 0] b_reg[2:0];
  reg [31 : 0] c_reg[2:0];
  reg [31 : 0] d_reg[2:0];
  
  reg [31 : 0] a_reg2[2:0];
  reg [31 : 0] c_reg2[2:0];
  reg [31 : 0] d_reg2[2:0];

  reg [31 : 0] m1_cs0_reg[1:0];

  //----------------------------------------------------------------
  // qr
  //
  // The actual quarterround engine
  //----------------------------------------------------------------
  always @(posedge clk)
    begin : qr
	   
		//a ? a + b + (msr(2i) ? csr(2i+1))
		//d ? (d?a)»16
		//c?c+d
		//b ? (b?c)»12
		//a ? a + b + (msr(2i+1) ? csr(2i))
		//d ? (d?a)»8
		//c?c+d
		//b ? (b?c)»7
		
		a_reg[0] <= (a + b + (m0 ^ cs1));
		b_reg[0] <= b;
		c_reg[0] <= c;
		d_reg[0] <= d;
		// register duplication
		a_reg2[0] <= (a + b + (m0 ^ cs1));
		c_reg2[0] <= c;
		d_reg2[0] <= d;
		m1_cs0_reg[0] <= (m1 ^ cs0);
		
		a_reg[1] <= a_reg[0];
		b_reg[1] <= (b_reg[0] ^ (c_reg2[0] + (((d_reg2[0] ^ a_reg2[0]) << 16) | ((d_reg2[0] ^ a_reg2[0])  >> 16))));
		c_reg[1] <= (c_reg[0] + (((d_reg[0] ^ a_reg[0]) << 16) | ((d_reg[0] ^ a_reg[0])  >> 16)));
		d_reg[1] <= (((d_reg[0] ^ a_reg[0]) << 16) | ((d_reg[0] ^ a_reg[0])  >> 16));
		m1_cs0_reg[1] <= m1_cs0_reg[0];

		a_reg[2] <= (a_reg[1] + ((b_reg[1] << 20) | (b_reg[1] >> 12)) + m1_cs0_reg[1]);
		b_reg[2] <= ((b_reg[1] << 20) | (b_reg[1] >> 12));
		c_reg[2] <= c_reg[1];
		d_reg[2] <= (d_reg[1] ^ (a_reg[1] + ((b_reg[1] << 20) | (b_reg[1] >> 12)) + m1_cs0_reg[1]));

      internal_a_prim <= a_reg[2];
      internal_b_prim <= (((b_reg[2] ^ (c_reg[2] + ((d_reg[2] << 24) | (d_reg[2] >> 8)))) << 25) | ((b_reg[2] ^ (c_reg[2] + ((d_reg[2] << 24) | (d_reg[2] >> 8)))) >> 7));
      internal_c_prim <= (c_reg[2] + ((d_reg[2] << 24) | (d_reg[2] >> 8)));
      internal_d_prim <= ((d_reg[2] << 24) | (d_reg[2] >> 8));
		
		/*a_reg[0] <= (a + b + (m0 ^ cs1));
		b_reg[0] <= (b ^ (c + (((d ^ (a + b + (m0 ^ cs1))) << 16) | ((d ^ (a + b + (m0 ^ cs1)))  >> 16))));
		c_reg[0] <= (c + (((d ^ (a + b + (m0 ^ cs1))) << 16) | ((d ^ (a + b + (m0 ^ cs1)))  >> 16)));
		d_reg[0] <= (((d ^ (a + b + (m0 ^ cs1))) << 16) | ((d ^ (a + b + (m0 ^ cs1)))  >> 16));
		m1_cs0_reg <= (m1 ^ cs0);

		a_reg[1] <= (a_reg[0] + ((b_reg[0] << 20) | (b_reg[0] >> 12)) + m1_cs0_reg);
		b_reg[1] <= ((b_reg[0] << 20) | (b_reg[0] >> 12));
		c_reg[1] <= c_reg[0];
		d_reg[1] <= (d_reg[0] ^ (a_reg[0] + ((b_reg[0] << 20) | (b_reg[0] >> 12)) + m1_cs0_reg));

      internal_a_prim <= a_reg[1];
      internal_b_prim <= (((b_reg[1] ^ (c_reg[1] + ((d_reg[1] << 24) | (d_reg[1] >> 8)))) << 25) | ((b_reg[1] ^ (c_reg[1] + ((d_reg[1] << 24) | (d_reg[1] >> 8)))) >> 7));
      internal_c_prim <= (c_reg[1] + ((d_reg[1] << 24) | (d_reg[1] >> 8)));
      internal_d_prim <= ((d_reg[1] << 24) | (d_reg[1] >> 8));
		*/

    end // qr
endmodule // blake256_qr

`ifndef USE_SYSTEM_VERILOG
module Sigma_CS#(
  parameter QR_OFFSET=0
)(
		input wire [3  : 0]  round,
		input wire           qr_base,

		output wire [3  : 0] sigma0_out,
		output wire [3  : 0] sigma1_out
);

  //----------------------------------------------------------------
  // Sigma_CS module regs/wires
  //----------------------------------------------------------------
  reg [3  : 0] internal_sigma0_out;
  reg [3  : 0] internal_sigma1_out;

  assign sigma0_out = internal_sigma0_out;
  assign sigma1_out = internal_sigma1_out;

  //----------------------------------------------------------------
  // Sigma_CS lookup
  //----------------------------------------------------------------
  always @*
    begin : s_cs
      case (QR_OFFSET)
		  /* Offset 0 */
		  0: begin
  	       case ({round,qr_base})
		      5'b00000,
		      5'b10100: begin 
		        internal_sigma0_out = 4'd0;
			     internal_sigma1_out = 4'd1;
		      end
			   5'b00001,
		      5'b10101: begin 
		        internal_sigma0_out = 4'd8;
				  internal_sigma1_out = 4'd9;
		      end
				
				5'b00010,
				5'b10110: begin 
				  internal_sigma0_out = 4'd14;
				  internal_sigma1_out = 4'd10;
			   end
				5'b00011,
				5'b10111: begin 
				  internal_sigma0_out = 4'd1;
				  internal_sigma1_out = 4'd12;
			   end
				
				5'b00100,
				5'b11000: begin 
				  internal_sigma0_out = 4'd11;
				  internal_sigma1_out = 4'd8;
				end
				5'b00101,
				5'b11001: begin 
				  internal_sigma0_out = 4'd10;
				  internal_sigma1_out = 4'd14;
				end
				
				5'b00110,
				5'b11010: begin 
				  internal_sigma0_out = 4'd7;
				  internal_sigma1_out = 4'd9;
				end
				5'b00111,
				5'b11011: begin 
				  internal_sigma0_out = 4'd2;
				  internal_sigma1_out = 4'd6;
				end
				
				5'b01000: begin 
				  internal_sigma0_out = 4'd9;
				  internal_sigma1_out = 4'd0;
				end
				5'b01001: begin 
				  internal_sigma0_out = 4'd14;
				  internal_sigma1_out = 4'd1;
				end
				
				5'b01010: begin 
				  internal_sigma0_out = 4'd2;
				  internal_sigma1_out = 4'd12;
				end
				5'b01011: begin 
				  internal_sigma0_out = 4'd4;
				  internal_sigma1_out = 4'd13;
				end
				
				5'b01100: begin 
				  internal_sigma0_out = 4'd12;
				  internal_sigma1_out = 4'd5;
				end
				5'b01101: begin 
				  internal_sigma0_out = 4'd0;
				  internal_sigma1_out = 4'd7;
				end
				
				5'b01110: begin 
				  internal_sigma0_out = 4'd13;
				  internal_sigma1_out = 4'd11;
				end
				5'b01111: begin 
				  internal_sigma0_out = 4'd5;
				  internal_sigma1_out = 4'd0;
				end
				
				5'b10000: begin 
				  internal_sigma0_out = 4'd6;
				  internal_sigma1_out = 4'd15;
				end
				5'b10001: begin 
				  internal_sigma0_out = 4'd12;
				  internal_sigma1_out = 4'd2;
				end
				
				5'b10010: begin 
				  internal_sigma0_out = 4'd10;
				  internal_sigma1_out = 4'd2;
				end
				5'b10011: begin 
				  internal_sigma0_out = 4'd15;
				  internal_sigma1_out = 4'd11;
				end
				default: begin
				  internal_sigma0_out = 4'd0;
				  internal_sigma1_out = 4'd0;
			    end
			 endcase // ({round,qr_base}) /* Offset 0 */
		  end // 0

		  /* Offset 1 */
		  1: begin
		    case ({round,qr_base})
			   5'b00000,
				5'b10100: begin 
				  internal_sigma0_out = 4'd2;
				  internal_sigma1_out = 4'd3;
				end
				5'b00001,
				5'b10101: begin 
				  internal_sigma0_out = 4'd10;
				  internal_sigma1_out = 4'd11;
				end
				
				5'b00010,
				5'b10110: begin 
				  internal_sigma0_out = 4'd4;
				  internal_sigma1_out = 4'd8;
				end
				5'b00011,
				5'b10111: begin 
				  internal_sigma0_out = 4'd0;
				  internal_sigma1_out = 4'd2;
				end
				
				5'b00100,
				5'b11000: begin 
				  internal_sigma0_out = 4'd12;
				  internal_sigma1_out = 4'd0;
				end
				5'b00101,
				5'b11001: begin 
				  internal_sigma0_out = 4'd3;
				  internal_sigma1_out = 4'd6;
				end
				
				5'b00110,
				5'b11010: begin 
				  internal_sigma0_out = 4'd3;
				  internal_sigma1_out = 4'd1;
				end
				5'b00111,
				5'b11011: begin 
				  internal_sigma0_out = 4'd5;
				  internal_sigma1_out = 4'd10;
				end
				
				5'b01000: begin 
				  internal_sigma0_out = 4'd5;
				  internal_sigma1_out = 4'd7;
				end
				5'b01001: begin 
				  internal_sigma0_out = 4'd11;
				  internal_sigma1_out = 4'd12;
				end
				
				5'b01010: begin 
				  internal_sigma0_out = 4'd6;
				  internal_sigma1_out = 4'd10;
				end
				5'b01011: begin 
				  internal_sigma0_out = 4'd7;
				  internal_sigma1_out = 4'd5;
				end
				
				5'b01100: begin 
				  internal_sigma0_out = 4'd1;
				  internal_sigma1_out = 4'd15;
				end
				5'b01101: begin 
				  internal_sigma0_out = 4'd6;
				  internal_sigma1_out = 4'd3;
				end
				
				5'b01110: begin 
				  internal_sigma0_out = 4'd7;
				  internal_sigma1_out = 4'd14;
				end
				5'b01111: begin 
				  internal_sigma0_out = 4'd15;
				  internal_sigma1_out = 4'd4;
				end
				
				5'b10000: begin 
				  internal_sigma0_out = 4'd14;
				  internal_sigma1_out = 4'd9;
				end
				5'b10001: begin 
				  internal_sigma0_out = 4'd13;
				  internal_sigma1_out = 4'd7;
				end
				
				5'b10010: begin 
				  internal_sigma0_out = 4'd8;
				  internal_sigma1_out = 4'd4;
				end
				5'b10011: begin 
				  internal_sigma0_out = 4'd9;
				  internal_sigma1_out = 4'd14;
				end
				default: begin
				  internal_sigma0_out = 4'd0;
				  internal_sigma1_out = 4'd0;
			    end
			 endcase // ({round,qr_base}) /* Offset 1 */
		  end // 1  
		  
		  /* Offset 2 */
		  2: begin
		    case ({round,qr_base})
				5'b00000,
				5'b10100: begin 
				  internal_sigma0_out = 4'd4;
				  internal_sigma1_out = 4'd5;
				end
				5'b00001,
				5'b10101: begin 
				  internal_sigma0_out = 4'd12;
				  internal_sigma1_out = 4'd13;
				end
				
				5'b00010,
				5'b10110: begin 
				  internal_sigma0_out = 4'd9;
				  internal_sigma1_out = 4'd15;
				end
				5'b00011,
				5'b10111: begin 
				  internal_sigma0_out = 4'd11;
				  internal_sigma1_out = 4'd7;
				end
				
				5'b00100,
				5'b11000: begin 
				  internal_sigma0_out = 4'd5;
				  internal_sigma1_out = 4'd2;
				end
				5'b00101,
				5'b11001: begin 
				  internal_sigma0_out = 4'd7;
				  internal_sigma1_out = 4'd1;
				end
				
				5'b00110,
				5'b11010: begin 
				  internal_sigma0_out = 4'd13;
				  internal_sigma1_out = 4'd12;
				end
				5'b00111,
				5'b11011: begin 
				  internal_sigma0_out = 4'd4;
				  internal_sigma1_out = 4'd0;
				end
				
				5'b01000: begin 
				  internal_sigma0_out = 4'd2;
				  internal_sigma1_out = 4'd4;
				end
				5'b01001: begin 
				  internal_sigma0_out = 4'd6;
				  internal_sigma1_out = 4'd8;
				end
				
				5'b01010: begin 
				  internal_sigma0_out = 4'd0;
				  internal_sigma1_out = 4'd11;
				end
				5'b01011: begin 
				  internal_sigma0_out = 4'd15;
				  internal_sigma1_out = 4'd14;
				end
				
				5'b01100: begin 
				  internal_sigma0_out = 4'd14;
				  internal_sigma1_out = 4'd13;
				end
				5'b01101: begin 
				  internal_sigma0_out = 4'd9;
				  internal_sigma1_out = 4'd2;
				end
				
				5'b01110: begin 
				  internal_sigma0_out = 4'd12;
				  internal_sigma1_out = 4'd1;
				end
				5'b01111: begin 
				  internal_sigma0_out = 4'd8;
				  internal_sigma1_out = 4'd6;
				end
				
				5'b10000: begin 
				  internal_sigma0_out = 4'd11;
				  internal_sigma1_out = 4'd3;
				end
				5'b10001: begin 
				  internal_sigma0_out = 4'd1;
				  internal_sigma1_out = 4'd4;
				end
				
				5'b10010: begin 
				  internal_sigma0_out = 4'd7;
				  internal_sigma1_out = 4'd6;
				end
				5'b10011: begin 
				  internal_sigma0_out = 4'd3;
				  internal_sigma1_out = 4'd12;
				end
				default: begin
				  internal_sigma0_out = 4'd0;
				  internal_sigma1_out = 4'd0;
			    end
			 endcase // ({round,qr_base}) /* Offset 2 */
		  end // 2  
		  
		  /* Offset 3 */
		  3: begin
		    case ({round,qr_base})
				5'b00000,
				5'b10100: begin 
				  internal_sigma0_out = 4'd6;
				  internal_sigma1_out = 4'd7;
				end
				5'b00001,
				5'b10101: begin 
				  internal_sigma0_out = 4'd14;
				  internal_sigma1_out = 4'd15;
				end
				
				5'b00010,
				5'b10110: begin 
				  internal_sigma0_out = 4'd13;
				  internal_sigma1_out = 4'd6;
				end
				5'b00011,
				5'b10111: begin 
				  internal_sigma0_out = 4'd5;
				  internal_sigma1_out = 4'd3;
				end
		  
				5'b00100,
				5'b11000: begin 
				  internal_sigma0_out = 4'd15;
				  internal_sigma1_out = 4'd13;
				end
				5'b00101,
				5'b11001: begin 
				  internal_sigma0_out = 4'd9;
				  internal_sigma1_out = 4'd4;
				end
		  
				5'b00110,
				5'b11010: begin 
				  internal_sigma0_out = 4'd11;
				  internal_sigma1_out = 4'd14;
				end
				5'b00111,
				5'b11011: begin 
				  internal_sigma0_out = 4'd15;
				  internal_sigma1_out = 4'd8;
				end
		  
				5'b01000: begin 
				  internal_sigma0_out = 4'd10;
				  internal_sigma1_out = 4'd15;
				end
				5'b01001: begin 
				  internal_sigma0_out = 4'd3;
				  internal_sigma1_out = 4'd13;
				end
		
				5'b01010: begin 
				  internal_sigma0_out = 4'd8;
				  internal_sigma1_out = 4'd3;
				end
				5'b01011: begin 
				  internal_sigma0_out = 4'd1;
				  internal_sigma1_out = 4'd9;
				end

				5'b01100: begin 
				  internal_sigma0_out = 4'd4;
				  internal_sigma1_out = 4'd10;
				end
				5'b01101: begin 
				  internal_sigma0_out = 4'd8;
				  internal_sigma1_out = 4'd11;
				end
		  
				5'b01110: begin 
				  internal_sigma0_out = 4'd3;
				  internal_sigma1_out = 4'd9;
				end
				5'b01111: begin 
				  internal_sigma0_out = 4'd2;
				  internal_sigma1_out = 4'd10;
				end
				
				5'b10000: begin 
				  internal_sigma0_out = 4'd0;
				  internal_sigma1_out = 4'd8;
				end
				5'b10001: begin 
				  internal_sigma0_out = 4'd10;
				  internal_sigma1_out = 4'd5;
				end
				
				5'b10010: begin 
				  internal_sigma0_out = 4'd1;
				  internal_sigma1_out = 4'd5;
				end
				5'b10011: begin 
				  internal_sigma0_out = 4'd13;
				  internal_sigma1_out = 4'd0;
				end
				default: begin
				  internal_sigma0_out = 4'd0;
				  internal_sigma1_out = 4'd0;
			    end
			 endcase // ({round,qr_base}) /* Offset 3 */
		  end // 3
		  default: begin
		    internal_sigma0_out = 4'd0;
			internal_sigma1_out = 4'd0;
		  end
		endcase
    end // s_cs
endmodule // Sigma_CS
`endif

// threads, q_step_base (0,4), input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
`define NEXT_STATE(stateName, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr) \
    qr_ctr_reg[0] <= q_step_base; \
	 qr_ctr_reg[1] <= q_step_base+1; \
	 qr_ctr_reg[2] <= q_step_base+2; \
	 qr_ctr_reg[3] <= q_step_base+3; \
	 input_qr_ptr <= thread; \
	 input_qr_cols <= input_cols; \
	 input_qr_diags <= input_diags; \
	 update_mreg <= mreg_update; \
	 update_mreg_ptr <= mreg_ptr; \
	 output_qr_ptr <= qr_output_ptr; \
	 output_qr_cols <= output_cols; \
	 output_qr_diags <= output_diags; \
	 ctr_reg_check <= ctr_check; \
	 ctr_reg_ptr <= ctr_ptr; \
    main_sr_state_reg <= stateName; 

module decred_hash_macro #(
  parameter UPPER_NONCE_START=0,
  parameter NONCE_START=0,
  parameter NONCE_STRIDE=`NUM_OF_THREADS
)(

		input wire            CLK,
		input wire            HASH_EN,
`ifdef USE_REG_WRITE_TO_HASHMACRO
		input wire            MACRO_WR_SELECT,
		input wire [7  : 0]   DATA_TO_HASH,
`else
		input wire  [255 : 0] MIDSTATE,
		input wire  [127 : 0] HEADERDATA,
		input wire  [31  : 0] ENONCE_IN,
		input wire  [31  : 0] TARGET_MASK,
`endif
		input wire            MACRO_RD_SELECT,
		input wire	[5   : 0] HASH_ADDR,

		output wire	[3   : 0] THREAD_COUNT,

		output wire           DATA_AVAILABLE,
		output wire [7  : 0]  DATA_FROM_HASH
);

`ifdef USE_VARIABLE_NONCE_OFFSET
 `ifdef FULL_CHIP_SIM
  `define NONCE_START_VAL  ({registers[58], registers[57], registers[56]})
  `define NONCE_STRIDE_VAL ({registers[60], registers[59]})
  `else
  `define NONCE_START_VAL  ({registers[57], registers[56]})
  `define NONCE_STRIDE_VAL ({registers[59], registers[58]})
 `endif
`else
  `define NONCE_START_VAL  NONCE_START
  `define NONCE_STRIDE_VAL NONCE_STRIDE
`endif

`ifdef USE_REG_WRITE_TO_HASHMACRO

  wire  [255 : 0] MIDSTATE;
  wire  [127 : 0] HEADERDATA;
  wire  [31  : 0] ENONCE_IN;
  wire  [31  : 0] TARGET_MASK;
`endif

  //----------------------------------------------------------------
  // Internal constant and parameter definitions
  //----------------------------------------------------------------

  localparam V8_INIT  = 32'h243F6A88;
  localparam V9_INIT  = 32'h85A308D3;
  localparam V10_INIT = 32'h13198A2E;
  localparam V11_INIT = 32'h03707344;
  localparam V12_INIT = 32'ha4093d82;
  localparam V13_INIT = 32'h299F3470;
  localparam V14_INIT = 32'h082EFA98;
  localparam V15_INIT = 32'hEC4E6C89;
  localparam M13_INIT = 32'h80000001;
  localparam M15_INIT = 32'h000005a0;

  localparam BLAKE256R14_ROUNDS = 4'd14;
  
  localparam NUM_THREADS = 6;
  
  localparam NUM_ENGINES = 4;
  
  genvar i;
  
`ifdef USE_SYSTEM_VERILOG
  // CS[16]
  localparam [511:0] CS = {
		32'h243F6A88, 32'h85A308D3, 32'h13198A2E, 32'h03707344,
		32'hA4093822, 32'h299F31D0, 32'h082EFA98, 32'hEC4E6C89,
		32'h452821E6, 32'h38D01377, 32'hBE5466CF, 32'h34E90C6C,
		32'hC0AC29B7, 32'hC97C50DD, 32'h3F84D5B5, 32'hB5470917};
		
  localparam [895:0] SIGMA = {
		4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10,4'd11,4'd12,4'd13,4'd14,4'd15,
		4'd14,4'd10,4'd4, 4'd8, 4'd9, 4'd15,4'd13,4'd6, 4'd1, 4'd12,4'd0, 4'd2, 4'd11,4'd7, 4'd5, 4'd3,
		4'd11,4'd8, 4'd12,4'd0, 4'd5, 4'd2, 4'd15,4'd13,4'd10,4'd14,4'd3, 4'd6, 4'd7, 4'd1, 4'd9, 4'd4,
		4'd7, 4'd9, 4'd3, 4'd1, 4'd13,4'd12,4'd11,4'd14,4'd2, 4'd6, 4'd5, 4'd10,4'd4, 4'd0, 4'd15,4'd8,
		4'd9, 4'd0, 4'd5, 4'd7, 4'd2, 4'd4, 4'd10,4'd15,4'd14,4'd1, 4'd11,4'd12,4'd6, 4'd8, 4'd3, 4'd13,
		4'd2, 4'd12,4'd6, 4'd10,4'd0, 4'd11,4'd8, 4'd3, 4'd4, 4'd13,4'd7, 4'd5, 4'd15,4'd14,4'd1, 4'd9,
		4'd12,4'd5, 4'd1, 4'd15,4'd14,4'd13,4'd4, 4'd10,4'd0, 4'd7, 4'd6, 4'd3, 4'd9, 4'd2, 4'd8, 4'd11,
		4'd13,4'd11,4'd7, 4'd14,4'd12,4'd1, 4'd3, 4'd9, 4'd5, 4'd0, 4'd15,4'd4, 4'd8, 4'd6, 4'd2, 4'd10,
		4'd6, 4'd15,4'd14,4'd9, 4'd11,4'd3, 4'd0, 4'd8, 4'd12,4'd2, 4'd13,4'd7, 4'd1, 4'd4, 4'd10,4'd5,
		4'd10,4'd2, 4'd8, 4'd4, 4'd7, 4'd6, 4'd1, 4'd5, 4'd15,4'd11,4'd9, 4'd14,4'd3, 4'd12,4'd13,4'd0,
		4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9, 4'd10,4'd11,4'd12,4'd13,4'd14,4'd15,
		4'd14,4'd10,4'd4, 4'd8, 4'd9, 4'd15,4'd13,4'd6, 4'd1, 4'd12,4'd0, 4'd2, 4'd11,4'd7, 4'd5, 4'd3,
		4'd11,4'd8, 4'd12,4'd0, 4'd5, 4'd2, 4'd15,4'd13,4'd10,4'd14,4'd3, 4'd6, 4'd7, 4'd1, 4'd9, 4'd4,
		4'd7, 4'd9, 4'd3, 4'd1, 4'd13,4'd12,4'd11,4'd14,4'd2, 4'd6, 4'd5, 4'd10,4'd4, 4'd0, 4'd15,4'd8};
`endif

  assign THREAD_COUNT = `NUM_OF_THREADS;

  //----------------------------------------------------------------
  // QR instance regs/wires
  //----------------------------------------------------------------
  
  reg [31 : 0]  qr_m0[3:0];
  reg [31 : 0]  qr_m1[3:0];
  reg [31 : 0]  qr_cs0[3:0];
  reg [31 : 0]  qr_cs1[3:0];
  reg [31 : 0]  qr_a[3:0];
  reg [31 : 0]  qr_b[3:0];
  reg [31 : 0]  qr_c[3:0];
  reg [31 : 0]  qr_d[3:0];
  wire [31 : 0] qr_a_prim[3:0];
  wire [31 : 0] qr_b_prim[3:0];
  wire [31 : 0] qr_c_prim[3:0];
  wire [31 : 0] qr_d_prim[3:0];

  //----------------------------------------------------------------
  // Instantiation of the qr modules
  //----------------------------------------------------------------
  for (i = 0; i < NUM_ENGINES; i = i + 1) begin: qr_engine_multi_block
    blake256_qr qr(
		.clk(CLK),
		.m0(qr_m0[i]),
		.m1(qr_m1[i]),
		.cs0(qr_cs0[i]),
		.cs1(qr_cs1[i]),

	   .a(qr_a[i]),
      .b(qr_b[i]),
      .c(qr_c[i]),
      .d(qr_d[i]),

      .a_prim(qr_a_prim[i]),
      .b_prim(qr_b_prim[i]),
      .c_prim(qr_c_prim[i]),
      .d_prim(qr_d_prim[i])
    );
  end
  
  //----------------------------------------------------------------
  // Superround regs/wires
  //----------------------------------------------------------------
  reg [31 : 0]  v_reg [NUM_THREADS-1:0][15 : 0];
  reg [31 : 0]  m_reg [15 : 0];

  reg [31 : 0]  m_reg3 [NUM_THREADS-1: 0];
  reg [31 : 0]  m_reg4 [NUM_THREADS-1: 0];

  reg           value_ready_for_test;
  
  reg [63 : 0]  target_check;
  
  reg [31 : 0]  m_save[1 : 0];
  
  reg [3   : 0] qr_ctr_reg[3:0];
  reg [3   : 0] ctr_reg[NUM_THREADS-1: 0];

  reg				 init_vreg_state;
  reg  		 	 update_vregs;
  reg [3 :0] 	 update_vreg_ptr;
  
  reg 			 update_mreg;
  reg [3 :0]	 update_mreg_ptr;
  
  reg				 input_qr_cols;
  reg				 input_qr_diags;
  reg [3 :0]	 input_qr_ptr;
  
  reg				 output_qr_cols;
  reg				 output_qr_diags;
  reg [3 :0]	 output_qr_ptr;
  
  reg				 ctr_reg_check;
  reg [3 :0]	 ctr_reg_ptr;

  reg [13 : 0] main_sr_state_reg;
  
`ifndef USE_SYSTEM_VERILOG
  reg [31 : 0]  CS[31:0];
  wire [3  : 0] s0[3:0];
  wire [3  : 0] s1[3:0];
`endif

  localparam MAIN_SR_STATE1  = 14'h0001;
  localparam MAIN_SR_STATE2  = 14'h0002;
  localparam MAIN_SR_STATE3  = 14'h0004;
  localparam MAIN_SR_STATE4  = 14'h0008;
  localparam MAIN_SR_STATE5  = 14'h0010;
  localparam MAIN_SR_STATE6  = 14'h0020;
  localparam MAIN_SR_STATE7  = 14'h0040;
  localparam MAIN_SR_STATE8  = 14'h0080;
  localparam MAIN_SR_STATE9  = 14'h0100;
  localparam MAIN_SR_STATE10 = 14'h0200;
  localparam MAIN_SR_STATE11 = 14'h0400;
  localparam MAIN_SR_STATE12 = 14'h0800;
  localparam MAIN_SR_STATE13 = 14'h1000;
  localparam MAIN_SR_STATE14 = 14'h2000;

`ifndef USE_SYSTEM_VERILOG
  //----------------------------------------------------------------
  // Instantiation of the sigma muxes
  //----------------------------------------------------------------
  for (i = 0; i < NUM_ENGINES; i = i + 1) begin: sigma_multi_block
    Sigma_CS #(.QR_OFFSET(i)) sigmacs(
		.round(ctr_reg[input_qr_ptr]),
		.qr_base(qr_ctr_reg[i][2]),

		.sigma0_out(s0[i]),
		.sigma1_out(s1[i])
    );
  end
`endif

  //----------------------------------------------------------------
  // M0/M1/CS0/CS1 Selector
  //----------------------------------------------------------------
  always @ (posedge CLK)
  begin

    if (input_qr_cols || input_qr_diags) begin
`ifdef USE_SYSTEM_VERILOG
      qr_m0[0]  <= m_reg[SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],(qr_ctr_reg[0]*2))]];
	   qr_m1[0]  <= m_reg[SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],((qr_ctr_reg[0]*2)+1))]];
	   qr_cs0[0] <= CS[`CS_INDEX(SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],(qr_ctr_reg[0]*2))])];
	   qr_cs1[0] <= CS[`CS_INDEX(SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],((qr_ctr_reg[0]*2)+1))])];
	 
	   qr_m0[1]  <= m_reg[SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],(qr_ctr_reg[1]*2))]];
	   qr_m1[1]  <= m_reg[SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],((qr_ctr_reg[1]*2)+1))]];
	   qr_cs0[1] <= CS[`CS_INDEX(SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],(qr_ctr_reg[1]*2))])];
	   qr_cs1[1] <= CS[`CS_INDEX(SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],((qr_ctr_reg[1]*2)+1))])];
	 
	   qr_m0[2]  <= m_reg[SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],(qr_ctr_reg[2]*2))]];
	   qr_m1[2]  <= m_reg[SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],((qr_ctr_reg[2]*2)+1))]];
	   qr_cs0[2] <= CS[`CS_INDEX(SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],(qr_ctr_reg[2]*2))])];
	   qr_cs1[2] <= CS[`CS_INDEX(SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],((qr_ctr_reg[2]*2)+1))])];
	 
	   qr_m0[3]  <= m_reg[SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],(qr_ctr_reg[3]*2))]];
	   qr_m1[3]  <= m_reg[SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],((qr_ctr_reg[3]*2)+1))]];
	   qr_cs0[3] <= CS[`CS_INDEX(SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],(qr_ctr_reg[3]*2))])];
	   qr_cs1[3] <= CS[`CS_INDEX(SIGMA[`SIGMA_INDEX(ctr_reg[input_qr_ptr],((qr_ctr_reg[3]*2)+1))])];
`else
      qr_m0[0] <= m_reg[s0[0]];
	  qr_m1[0] <= m_reg[s1[0]];
	  qr_cs0[0] <= CS[s0[0]];
	  qr_cs1[0] <= CS[s1[0]];
	  qr_m0[1] <= m_reg[s0[1]];
	  qr_m1[1] <= m_reg[s1[1]];
	  qr_cs0[1] <= CS[s0[1]];
	  qr_cs1[1] <= CS[s1[1]];
	  qr_m0[2] <= m_reg[s0[2]];
	  qr_m1[2] <= m_reg[s1[2]];
	  qr_cs0[2] <= CS[s0[2]];
	  qr_cs1[2] <= CS[s1[2]];
	  qr_m0[3] <= m_reg[s0[3]];
	  qr_m1[3] <= m_reg[s1[3]];
	  qr_cs0[3] <= CS[s0[3]];
	  qr_cs1[3] <= CS[s1[3]];
`endif
    end
  end
  
  //----------------------------------------------------------------
  // v_reg initialization
  //----------------------------------------------------------------
  always @ (posedge CLK)
  begin
    
	 if (update_vregs) begin
		v_reg[update_vreg_ptr][00] <= MIDSTATE[255 : 224];
		v_reg[update_vreg_ptr][01] <= MIDSTATE[223 : 192];
		v_reg[update_vreg_ptr][02] <= MIDSTATE[191 : 160];
		v_reg[update_vreg_ptr][03] <= MIDSTATE[159 : 128];
		v_reg[update_vreg_ptr][04] <= MIDSTATE[127 :  96];
		v_reg[update_vreg_ptr][05] <= MIDSTATE[95  :  64];
		v_reg[update_vreg_ptr][06] <= MIDSTATE[63  :  32];
		v_reg[update_vreg_ptr][07] <= MIDSTATE[31  :   0];
		v_reg[update_vreg_ptr][08] <= V8_INIT;
		v_reg[update_vreg_ptr][09] <= V9_INIT;
		v_reg[update_vreg_ptr][10] <= V10_INIT;
		v_reg[update_vreg_ptr][11] <= V11_INIT;
		v_reg[update_vreg_ptr][12] <= V12_INIT;
		v_reg[update_vreg_ptr][13] <= V13_INIT;
		v_reg[update_vreg_ptr][14] <= V14_INIT;
		v_reg[update_vreg_ptr][15] <= V15_INIT;
	 end
  end
	 

  //----------------------------------------------------------------
  // m_reg input
  //----------------------------------------------------------------
  always @ (posedge CLK)
  begin
    if (HASH_EN == 0)
    begin
	   // M0 = Block height
	   m_reg[00] <= HEADERDATA[127:96 ];
	   // M1 = Size (Number of bytes the serialized block occupies)
	   m_reg[01] <= HEADERDATA[95 :64 ];
	   // M2 = Timestamp of when the block was created
	   m_reg[02] <= HEADERDATA[63 :32 ];
		// M3/M4 = Nonce, starts at parameter values
	   m_reg[03] <= 0;
	   m_reg[04] <= 0;
	   m_reg[05] <= ENONCE_IN[31 : 0 ];
	   m_reg[06] <= 0;
	   m_reg[07] <= 0;
	   m_reg[08] <= 0;
	   m_reg[09] <= 0;
	   m_reg[10] <= 0;
	   m_reg[11] <= 0;
	   // M12 = Stake Version
	   m_reg[12] <= HEADERDATA[31:0];
	   m_reg[13] <= M13_INIT;
	   m_reg[14] <= 0;
	   m_reg[15] <= M15_INIT;
	   
`ifndef USE_SYSTEM_VERILOG
	  // CS Constants
	  CS[00] <= 32'h243F6A88;
	  CS[01] <= 32'h85A308D3;
	  CS[02] <= 32'h13198A2E;
	  CS[03] <= 32'h03707344;
	  CS[04] <= 32'hA4093822;
	  CS[05] <= 32'h299F31D0;
	  CS[06] <= 32'h082EFA98;
	  CS[07] <= 32'hEC4E6C89;
	  CS[08] <= 32'h452821E6;
	  CS[09] <= 32'h38D01377;
	  CS[10] <= 32'hBE5466CF;
	  CS[11] <= 32'h34E90C6C;
	  CS[12] <= 32'hC0AC29B7;
	  CS[13] <= 32'hC97C50DD;
	  CS[14] <= 32'h3F84D5B5;
	  CS[15] <= 32'hB5470917;
`endif
	   
	 end else begin
      if (update_mreg) begin
        m_reg[03] <= m_reg3[update_mreg_ptr];
        m_reg[04] <= m_reg4[update_mreg_ptr];
      end
    end
  end
  
  //----------------------------------------------------------------
  // qr input
  //----------------------------------------------------------------
  always @ (posedge CLK)
  begin
	 if (input_qr_cols) begin
		qr_a[0] <= v_reg[input_qr_ptr][00];
      qr_b[0] <= v_reg[input_qr_ptr][04];
      qr_c[0] <= v_reg[input_qr_ptr][08];
      qr_d[0] <= v_reg[input_qr_ptr][12];
			 
		qr_a[1] <= v_reg[input_qr_ptr][01];
      qr_b[1] <= v_reg[input_qr_ptr][05];
      qr_c[1] <= v_reg[input_qr_ptr][09];
      qr_d[1] <= v_reg[input_qr_ptr][13];
			 
		qr_a[2] <= v_reg[input_qr_ptr][02];
      qr_b[2] <= v_reg[input_qr_ptr][06];
      qr_c[2] <= v_reg[input_qr_ptr][10];
      qr_d[2] <= v_reg[input_qr_ptr][14];
			 
		qr_a[3] <= v_reg[input_qr_ptr][03];
      qr_b[3] <= v_reg[input_qr_ptr][07];
      qr_c[3] <= v_reg[input_qr_ptr][11];
      qr_d[3] <= v_reg[input_qr_ptr][15];
	 end
	 
	 if (input_qr_diags) begin
		qr_a[0] <= v_reg[input_qr_ptr][00];
      qr_b[0] <= v_reg[input_qr_ptr][05];
      qr_c[0] <= v_reg[input_qr_ptr][10];
      qr_d[0] <= v_reg[input_qr_ptr][15];
			 
      qr_a[1] <= v_reg[input_qr_ptr][01];
      qr_b[1] <= v_reg[input_qr_ptr][06];
      qr_c[1] <= v_reg[input_qr_ptr][11];
      qr_d[1] <= v_reg[input_qr_ptr][12];
			 
		qr_a[2] <= v_reg[input_qr_ptr][02];
      qr_b[2] <= v_reg[input_qr_ptr][07];
      qr_c[2] <= v_reg[input_qr_ptr][08];
      qr_d[2] <= v_reg[input_qr_ptr][13];
			 
		qr_a[3] <= v_reg[input_qr_ptr][03];
      qr_b[3] <= v_reg[input_qr_ptr][04];
      qr_c[3] <= v_reg[input_qr_ptr][09];
      qr_d[3] <= v_reg[input_qr_ptr][14];
	 end
  end

  //----------------------------------------------------------------
  // qr output
  //----------------------------------------------------------------
  always @ (posedge CLK)
  begin
	 
	 if (output_qr_cols) begin
	   v_reg[output_qr_ptr][00] <= qr_a_prim[0];
      v_reg[output_qr_ptr][04] <= qr_b_prim[0];
      v_reg[output_qr_ptr][08] <= qr_c_prim[0];
      v_reg[output_qr_ptr][12] <= qr_d_prim[0];
			 
		v_reg[output_qr_ptr][01] <= qr_a_prim[1];
      v_reg[output_qr_ptr][05] <= qr_b_prim[1];
      v_reg[output_qr_ptr][09] <= qr_c_prim[1];
      v_reg[output_qr_ptr][13] <= qr_d_prim[1];
			 
		v_reg[output_qr_ptr][02] <= qr_a_prim[2];
      v_reg[output_qr_ptr][06] <= qr_b_prim[2];
      v_reg[output_qr_ptr][10] <= qr_c_prim[2];
      v_reg[output_qr_ptr][14] <= qr_d_prim[2];
			 
		v_reg[output_qr_ptr][03] <= qr_a_prim[3];
      v_reg[output_qr_ptr][07] <= qr_b_prim[3];
      v_reg[output_qr_ptr][11] <= qr_c_prim[3];
      v_reg[output_qr_ptr][15] <= qr_d_prim[3];
	 end
	 
	 if (output_qr_diags) begin
	   v_reg[output_qr_ptr][00] <= qr_a_prim[0];
      v_reg[output_qr_ptr][05] <= qr_b_prim[0];
      v_reg[output_qr_ptr][10] <= qr_c_prim[0];
      v_reg[output_qr_ptr][15] <= qr_d_prim[0];
			 
		v_reg[output_qr_ptr][01] <= qr_a_prim[1];
      v_reg[output_qr_ptr][06] <= qr_b_prim[1];
      v_reg[output_qr_ptr][11] <= qr_c_prim[1];
      v_reg[output_qr_ptr][12] <= qr_d_prim[1];
			 
		v_reg[output_qr_ptr][02] <= qr_a_prim[2];
      v_reg[output_qr_ptr][07] <= qr_b_prim[2];
      v_reg[output_qr_ptr][08] <= qr_c_prim[2];
      v_reg[output_qr_ptr][13] <= qr_d_prim[2];
			 
		v_reg[output_qr_ptr][03] <= qr_a_prim[3];
      v_reg[output_qr_ptr][04] <= qr_b_prim[3];
      v_reg[output_qr_ptr][09] <= qr_c_prim[3];
      v_reg[output_qr_ptr][14] <= qr_d_prim[3];
	 end
  end
  
  //----------------------------------------------------------------
  // ctr_reg setting
  //----------------------------------------------------------------
  always @ (posedge CLK)
  begin : ctr_reg_setting
    integer i;
    if (HASH_EN == 0) begin
	   for (i = 0; i < NUM_THREADS; i = i + 1) begin
		  ctr_reg[i] <= 0;
		end
	 end else begin
	 
	   if (input_qr_diags && qr_ctr_reg[0] == 4) begin
		
		  ctr_reg[input_qr_ptr] <= ctr_reg[input_qr_ptr] + 1'b1;
		
		end
		
		if (ctr_reg_check && ctr_reg[ctr_reg_ptr] == BLAKE256R14_ROUNDS) begin
		
		  ctr_reg[ctr_reg_ptr] <= 0;
		
		end
	 
	 end
  end

  //----------------------------------------------------------------
  // ctr_reg check
  //----------------------------------------------------------------
  always @ (posedge CLK)
  begin : ctr_logic
	 integer i;

	 if (HASH_EN == 0) begin
	   for (i = 0; i < NUM_THREADS; i = i + 1) begin
		   m_reg3[i] <= `NONCE_START_VAL + i;
		   m_reg4[i] <= UPPER_NONCE_START;
     end

		init_vreg_state 	<= 1;
      update_vregs 		<= 1;
      update_vreg_ptr 	<= 0;
		
		value_ready_for_test <= 0;
	 
	 end else begin
	   
		if (ctr_reg_check && ctr_reg[ctr_reg_ptr] == BLAKE256R14_ROUNDS) begin

	     for (i = 6; i < 8; i = i + 1) begin
	       target_check[224-(i*32)+: 32] <=  MIDSTATE[224-(i*32)+: 32] ^ v_reg[ctr_reg_ptr][i] ^ v_reg[ctr_reg_ptr][i + 8];
		  end

		  m_save[1] <= m_reg3[ctr_reg_ptr];
		  m_save[0] <= m_reg4[ctr_reg_ptr];

		  m_reg3[ctr_reg_ptr] <= m_reg3[ctr_reg_ptr] + `NONCE_STRIDE_VAL;
		  if ((m_reg3[ctr_reg_ptr]+`NONCE_STRIDE_VAL) < m_reg3[ctr_reg_ptr]) begin

		    m_reg4[ctr_reg_ptr] <= m_reg4[ctr_reg_ptr] + 1;
		  end
				
		  value_ready_for_test <= 1;
	   end
	   else begin
	     value_ready_for_test <= 0;
      end
		
		if (init_vreg_state || (ctr_reg_check && ctr_reg[ctr_reg_ptr] == BLAKE256R14_ROUNDS)) begin
		  update_vregs    	<= 1;
		  update_vreg_ptr 	<= ctr_reg_ptr;
		end
		
		if (ctr_reg_check == 0) begin
		
		  init_vreg_state 	<= 0;
		  update_vregs    	<= 0;
		
		end
    
	 end
  end

  //----------------------------------------------------------------
  // Superound FSM
  //----------------------------------------------------------------
  always @ (posedge CLK)
  begin : v_logic

    if (HASH_EN == 0)
    begin

	   qr_ctr_reg[0] <= 0;
		qr_ctr_reg[1] <= 0;
		qr_ctr_reg[2] <= 0;
		qr_ctr_reg[3] <= 0;

		update_mreg			<= 1; // for initial m_reg loading
		update_mreg_ptr	<= 0; // for initial m_reg loading
		
		input_qr_ptr 		<= 0;
		input_qr_cols 		<= 0;
		input_qr_diags 	<= 0;
		
		output_qr_ptr 		<= 2; // preload for loop rolled
		output_qr_cols 	<= 0;	// preload for loop rolled
		output_qr_diags 	<= 1;	// preload for loop rolled
		
		ctr_reg_check     <= 1; // for initial v_reg loading
		ctr_reg_ptr       <= 1; // for initial v_reg loading

	   main_sr_state_reg <= MAIN_SR_STATE1;

    end
    else begin

      case (main_sr_state_reg)

        MAIN_SR_STATE1: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
          `NEXT_STATE(MAIN_SR_STATE2, 0, 0, 	 1, 			 0, 		     1, 			   1, 		 3, 			    0, 			  1, 			    1, 		   2)
        end

        MAIN_SR_STATE2: begin

          // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE3, 1, 0, 	 1, 			 0, 		     1, 			   2, 		 4, 			    0, 			  1, 			    1, 		   3)
        end

        MAIN_SR_STATE3: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE4, 2, 0, 	 1, 			 0, 		     1, 			   3, 		 5, 			    0, 			  1, 			    1, 		   4)
        end

        MAIN_SR_STATE4: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE5, 3, 0, 	 1, 			 0, 		     1, 			   4, 		 0, 			    0, 			  0, 			    1, 		   5)
        end

        MAIN_SR_STATE5: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE6, 4, 0, 	 1, 			 0, 		     1, 			   5, 		 0, 			    0, 			  0, 			    0, 		   0)
        end

        MAIN_SR_STATE6: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE7, 5, 0, 	 1, 			 0, 		     1, 			   0, 		 0, 			    1, 			  0, 			    0, 		   0)
        end

        MAIN_SR_STATE7: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE8, 0, 4, 	 0, 			 1, 		     1, 			   1, 		 1, 			    1, 			  0, 			    0, 		   0)
        end

        MAIN_SR_STATE8: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE9, 1, 4, 	 0, 			 1, 		     1, 			   2, 		 2, 			    1, 			  0, 			    0, 		   0)
        end

        MAIN_SR_STATE9: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE10, 2, 4,  0, 			 1, 		     1, 			   3, 		 3, 			    1, 			  0, 			    0, 		   0)
        end

        MAIN_SR_STATE10: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE11, 3, 4,  0, 			 1, 		     1, 			   4, 		 4, 			    1, 			  0, 			    0, 		   0)
        end

        MAIN_SR_STATE11: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE12, 4, 4,  0, 			 1, 		     1, 			   5, 		 5, 			    1, 			  0, 			    0, 		   0)
        end

        MAIN_SR_STATE12: begin
		  
			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE13, 5, 4,  0, 			 1, 		     0, 			   0, 		 0, 			    0, 			  1, 			    0, 		   0)
        end

        MAIN_SR_STATE13: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE14, 0, 0,  0, 			 0, 		     0, 			   0, 		 1, 			    0, 			  1, 			    1, 		   0)
        end

        MAIN_SR_STATE14: begin

			 // next state, thread, q_step_base, input_cols, input_diags, mreg_update, mreg_ptr, qr_output_ptr, output_cols, output_diags, ctr_check, ctr_ptr
			 `NEXT_STATE(MAIN_SR_STATE1, 0, 0,   0, 			 0, 		     1, 			   0, 		 2, 			    0, 			  1, 			    1, 		   1)
        end

      endcase
    end
  end

  //----------------------------------------------------------------
  // Solution qualifier
  //----------------------------------------------------------------
  reg           int_internal_reg;
  reg [63  : 0] nonce_enonce_out_reg;

  wire targetCheckSub;
  wire targetMaskSub;
    
  assign targetCheckSub  =  (target_check[31  :  0] == 32'h0);
  assign targetMaskSub  =  ((target_check[63 : 32] & TARGET_MASK[31 :  0]) == 32'h0);
  
  always @ (posedge CLK)
  begin
    if (value_ready_for_test && targetCheckSub && targetMaskSub)
    begin
      int_internal_reg <= 1;
      nonce_enonce_out_reg <= {m_save[1],m_save[0]};
    end else
    begin
      int_internal_reg <= 0;
    end
  end

  //----------------------------------------------------------------
  // inbound reg block
  //----------------------------------------------------------------
`ifdef USE_REG_WRITE_TO_HASHMACRO
  // MIDSTATE    = 31:0   : 0x00 - 0x1F
  // TARGET_MASK = 35:32  : 0x20 - 0x23
  // HEADERDATA  = 51:36  : 0x24 - 0x33
  // EXTRANONCE  = 55:52  : 0x34 - 0x37
  // NONCE_START = 57:56  : 0x39 - 0x38
  // STRIDE      = 59:58  : 0x3B - 0x3A
`ifdef USE_VARIABLE_NONCE_OFFSET
 `ifdef FULL_CHIP_SIM
  reg  [7:0] registers [60:0];
 `else
  reg  [7:0] registers [59:0];
 `endif
`else
  reg  [7:0] registers [55:0];
`endif
  wire [7:0] data_in_bus;

  assign data_in_bus = DATA_TO_HASH;

  always @ (posedge CLK)
  begin
    if (MACRO_WR_SELECT)
	 begin
      registers[HASH_ADDR] <= data_in_bus;
	 end
  end

  assign MIDSTATE = {registers[0], registers[1], registers[2], registers[3],
						registers[4], registers[5], registers[6], registers[7],
						registers[8], registers[9], registers[10],registers[11],
						registers[12],registers[13],registers[14],registers[15],
						registers[16],registers[17],registers[18],registers[19],
						registers[20],registers[21],registers[22],registers[23],
						registers[24],registers[25],registers[26],registers[27],
						registers[28],registers[29],registers[30],registers[31]};
  assign TARGET_MASK = {registers[32],registers[33],registers[34],registers[35]};
  assign HEADERDATA = {registers[36],registers[37],registers[38],registers[39],
						registers[40],registers[41],registers[42],registers[43],
						registers[44],registers[45],registers[46],registers[47],
						registers[48],registers[49],registers[50],registers[51]};
  assign ENONCE_IN = {registers[52],registers[53],registers[54],registers[55]};

`endif

  //----------------------------------------------------------------
  // outbound reg block
  //----------------------------------------------------------------

  reg solution_ready;
  assign DATA_AVAILABLE = solution_ready;

  always @ (posedge CLK)
  begin
    if ((HASH_EN == 0) || (MACRO_RD_SELECT))
	 begin
      solution_ready <= 0;
	 end else
    if (int_internal_reg == 1'b1)
    begin
	   solution_ready <= 1;
    end
  end

  reg				output_enable;

  reg  [7:0]	data_output_bus;
  assign DATA_FROM_HASH = (MACRO_RD_SELECT) ? data_output_bus : 8'bZ;

  always @ (*)
  begin
    case (HASH_ADDR)
      0:  data_output_bus <= nonce_enonce_out_reg[7 : 0];
      1:  data_output_bus <= nonce_enonce_out_reg[15: 8];
      2:  data_output_bus <= nonce_enonce_out_reg[23:16];
      3:  data_output_bus <= nonce_enonce_out_reg[31:24];
      4:  data_output_bus <= nonce_enonce_out_reg[39:32];
      5:  data_output_bus <= nonce_enonce_out_reg[47:40];
      6:  data_output_bus <= nonce_enonce_out_reg[55:48];
      7:  data_output_bus <= nonce_enonce_out_reg[63:56];
    default: data_output_bus <= 8'h4A;
    endcase
  end

endmodule // blake256r14_core
