
`timescale 1 ns / 1 ps

`include "sysctrl.v"

module sysctrl_wb_tb;

    reg wb_clk_i;
	reg wb_rst_i;

    reg wb_stb_i;
    reg wb_cyc_i;
	reg wb_we_i;
	reg [3:0] wb_sel_i;
	reg [31:0] wb_dat_i;
	reg [31:0] wb_adr_i;

	wire wb_ack_o;
	wire [31:0] wb_dat_o;
    
    initial begin
        wb_clk_i = 0; 
        wb_rst_i = 0;
        wb_stb_i = 0; 
        wb_cyc_i = 0;  
        wb_sel_i = 0;  
        wb_we_i  = 0;  
        wb_dat_i = 0; 
        wb_adr_i = 0; 
    end

    always #1 wb_clk_i = ~wb_clk_i;
    
    initial begin
        $dumpfile("sysctrl_wb_tb.vcd");
        $dumpvars(0, sysctrl_wb_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test System Control Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;
    
    // System Control Default Register Addresses 
    wire [31:0] pll_out_adr   = uut.BASE_ADR | uut.PLL_OUT;  
    wire [31:0] trap_out_adr  = uut.BASE_ADR | uut.TRAP_OUT;
    wire [31:0] irq7_src_adr  = uut.BASE_ADR | uut.IRQ7_SRC;

    reg pll_output_dest;
    reg trap_output_dest;
    reg irq_7_inputsrc;
   
    initial begin
        // Reset Operation
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0;
        #2;
        
        pll_output_dest   = 1'b1;
        trap_output_dest  = 1'b1;
        irq_7_inputsrc    = 1'b1;

        // Write to System Control Registers
        write(pll_out_adr, pll_output_dest);
        write(trap_out_adr, trap_output_dest);
        write(irq7_src_adr, irq_7_inputsrc);
        #2;
        read(pll_out_adr);
        if (wb_dat_o !== pll_output_dest) begin
            $display("Error reading PLL output destination register.");
            $finish;
        end

        read(trap_out_adr);
        if (wb_dat_o !== trap_output_dest) begin
            $display("Error reading trap output destination register.");
            $finish;
        end

        read(irq7_src_adr);
        if (wb_dat_o !== irq_7_inputsrc) begin
            $display("Error reading IRQ7 input source register.");
            $finish;
        end

        $display("Success!");
        $finish;
    end
    
    task write;
        input [32:0] addr;
        input [32:0] data;
        begin 
            @(posedge wb_clk_i) begin
                wb_stb_i = 1;
                wb_cyc_i = 1;
                wb_sel_i = 4'hF; 
                wb_we_i = 1;     
                wb_adr_i = addr;
                wb_dat_i = data;
                $display("Monitor: Write Cycle Started.");
            end
            // Wait for an ACK
            wait(wb_ack_o == 1);
            wait(wb_ack_o == 0);
            wb_cyc_i = 0;
            wb_stb_i = 0;
            $display("Monitor: Write Cycle Ended.");
        end
    endtask
    
    task read;
        input [32:0] addr;
        begin 
            @(posedge wb_clk_i) begin
                wb_stb_i = 1;
                wb_cyc_i = 1;
                wb_we_i = 0;
                wb_adr_i = addr;
                $display("Monitor: Read Cycle Started.");
            end
            // Wait for an ACK
            wait(wb_ack_o == 1);
            wait(wb_ack_o == 0);
            wb_cyc_i = 0;
            wb_stb_i = 0;
            $display("Monitor: Read Cycle Ended.");
        end
    endtask

    sysctrl_wb uut(
        .wb_clk_i(wb_clk_i),
	    .wb_rst_i(wb_rst_i),
        .wb_stb_i(wb_stb_i),
	    .wb_cyc_i(wb_cyc_i),
	    .wb_sel_i(wb_sel_i),
	    .wb_we_i(wb_we_i),
	    .wb_dat_i(wb_dat_i),
	    .wb_adr_i(wb_adr_i), 
        .wb_ack_o(wb_ack_o),
	    .wb_dat_o(wb_dat_o)
    );
    
endmodule
