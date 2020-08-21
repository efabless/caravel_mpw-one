
`timescale 1 ns / 1 ps

`include "crossbar.v"
`include "dummy_slave.v"

`ifndef AW
    `define AW 32
`endif
`ifndef DW
    `define DW 32
`endif
`ifndef NM
    `define NM 2
`endif

`ifndef NS
    `define NS 4
`endif

`ifndef SLAVE_ADR
    `define SLAVE_ADR { \
        {8'hB0, {24{1'b0}}},\
        {8'hA0, {24{1'b0}}},\
        {8'h90, {24{1'b0}}},\
        {8'h80, {24{1'b0}}}\
    }\
`endif

`ifndef ADR_MASK
    `define ADR_MASK { \
        {8'hFF, {24{1'b0}}}, \
        {8'hFF, {24{1'b0}}}, \
        {8'hFF, {24{1'b0}}}, \
        {8'hFF, {24{1'b0}}}  \
    }\
`endif

module crossbar_wb_tb;

    localparam SEL = `DW / 8;

    reg wb_clk_i;           
    reg wb_rst_i;     

    // Masters interface
    reg [`NM-1:0] wbm_cyc_i;       
    reg [`NM-1:0] wbm_stb_i;       
    reg [`NM-1:0] wbm_we_i;     
    reg [(`NM*(`DW/8))-1:0] wbm_sel_i;     
    reg [(`NM*`AW)-1:0] wbm_adr_i;        
    reg [(`NM*`DW)-1:0] wbm_dat_i;       
    wire [`NM-1:0] wbm_ack_o; 
    wire [`NM-1:0] wbm_err_o;       
    wire [(`NM*`DW)-1:0] wbm_dat_o;       

    // Slaves interfaces
    wire [`NS-1:0] wbs_ack_o;       
    wire [(`NS*`DW)-1:0] wbs_dat_i;
    wire [`NS-1:0] wbs_cyc_o;        
    wire [`NS-1:0] wbs_stb_o;       
    wire [`NS-1:0] wbs_we_o;        
    wire [(`NS*(`DW/8))-1:0] wbs_sel_o;       
    wire [(`NS*`AW)-1:0] wbs_adr_o;       
    wire [(`NS*`DW)-1:0] wbs_dat_o;  
    
    wb_xbar #(
        .NM(`NM),
        .NS(`NS),
        .AW(`AW),
        .DW(`DW),
        .SLAVE_ADR(`SLAVE_ADR),
        .ADR_MASK(`ADR_MASK) 
    )
    wb_xbar(
        .wb_clk_i(wb_clk_i),           
        .wb_rst_i(wb_rst_i),     
        // Masters interface
        .wbm_cyc_i(wbm_cyc_i),       
        .wbm_stb_i(wbm_stb_i),       
        .wbm_we_i (wbm_we_i),     
        .wbm_sel_i(wbm_sel_i),     
        .wbm_adr_i(wbm_adr_i),        
        .wbm_dat_i(wbm_dat_i),       
        .wbm_ack_o(wbm_ack_o), 
        .wbm_dat_o(wbm_dat_o),       
        // Slaves interfaces
        .wbs_ack_i(wbs_ack_o),       
        .wbs_dat_i(wbs_dat_o),
        .wbs_cyc_o(wbs_cyc_o),        
        .wbs_stb_o(wbs_stb_o),       
        .wbs_we_o(wbs_we_o),        
        .wbs_sel_o(wbs_sel_o),       
        .wbs_adr_o(wbs_adr_o),       
        .wbs_dat_o(wbs_dat_i)     
    );

    // Instantiate four dummy slaves for testing
    dummy_slave dummy_slaves [`NS-1:0](
        .wb_clk_i({`NS{wb_clk_i}}),
        .wb_rst_i({`NS{wb_rst_i}}),
        .wb_stb_i(wbs_stb_o),
        .wb_cyc_i(wbs_cyc_o),
        .wb_we_i(wbs_we_o),
        .wb_sel_i(wbs_sel_o),
        .wb_adr_i(wbs_adr_o),
        .wb_dat_i(wbs_dat_i),
        .wb_dat_o(wbs_dat_o),
        .wb_ack_o(wbs_ack_o)
    );

    initial begin
        wb_clk_i  = 0;           
        wb_rst_i  = 0;     
        wbm_cyc_i = 0;       
        wbm_stb_i = 0;       
        wbm_we_i  = 0;     
        wbm_sel_i = 0;     
        wbm_adr_i = 0;        
        wbm_dat_i = 0;  
    end
   
    always #1 wb_clk_i = ~wb_clk_i;

    initial begin
        $dumpfile("crossbar_wb_tb.vcd");
        $dumpvars(0, crossbar_wb_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test Crossbar Switch Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;

    reg [`AW*`NS-1:0] addresses = {
        {8'hB0, {24{1'b0}}},
        {8'hA0, {24{1'b0}}},
        {8'h90, {24{1'b0}}},
        {8'h80, {24{1'b0}}}
    };

    reg [`DW-1:0] m0_slave_data;
    reg [`DW-1:0] m1_slave_data;
    reg [`AW-1:0] slave_adr;

    initial begin
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0;
        #2;

        // Case 1: Master0 addresses slave 0 and Master 2 Addresses slave 1
        slave_adr = addresses[`AW-1:0];
        m0_slave_data = $urandom_range(0, 2**(`DW-2));
        write(slave_adr, m0_slave_data, 0);

        #2;
        read(slave_adr, 0);
        if (wbm_dat_o[0*`DW+: `DW] !== m0_slave_data) begin
            $display("Error reading from slave");
            $finish;
        end
        
        #10;
        slave_adr = addresses[`AW*2-1:`AW*1];
        m1_slave_data = $urandom_range(0, 2**(`DW-2));
        write(slave_adr, m1_slave_data, 1);
        #2;
        read(slave_adr, 1);
        #10;
        if (wbm_dat_o[1*`DW+: `DW] !== m1_slave_data) begin
            $display("Error reading from slave");
            $finish;
        end
        #10;
        // Case 2: Master0 addresses slave 0 and Master 2 Addresses slave 1 simultaenously
        slave_adr = addresses[`AW-1:0];
        m0_slave_data = $urandom_range(0, 2**(`DW-2));

        wbm_stb_i[0] = 1;
        wbm_cyc_i[0] = 1;
        wbm_we_i [0]  = 1;
        wbm_sel_i[0*SEL+: SEL] = {SEL{1'b1}};
        wbm_adr_i[0*`AW+: `AW] = slave_adr;
        wbm_dat_i[0*`DW+: `DW] = m0_slave_data;

        slave_adr = addresses[`AW*2-1:`AW*1];
        m1_slave_data = $urandom_range(0, 2**(`DW-2));

        wbm_stb_i[1] = 1;
        wbm_cyc_i[1] = 1;
        wbm_we_i[1]  = 1;
        wbm_sel_i[1*SEL+: SEL] = {SEL{1'b1}};
        wbm_adr_i[1*`AW+: `AW] = slave_adr;
        wbm_dat_i[1*`DW+: `DW] = m1_slave_data;

        wait(wbm_ack_o[0] && wbm_ack_o[1]);
        wait(!wbm_ack_o[0] && !wbm_ack_o[1]);
        
        // Read
        wbm_we_i  = 2'b00;
        wait(wbm_ack_o[0] && wbm_ack_o[1]);
        wait(!wbm_ack_o[0] && !wbm_ack_o[1]);

        if (wbm_dat_o[0*`DW+: `DW] !== m0_slave_data) begin
            $display("Error reading from slave");
            $finish;
        end
       
        // Case 3: Master0 addresses slave 0 and Master 2 Addresses slave 1 simultaenously
        slave_adr = addresses[`AW-1:0];
        m0_slave_data = $urandom_range(0, 2**(`DW-2));

        wbm_stb_i[0] = 1;
        wbm_cyc_i[0] = 1;
        wbm_we_i [0]  = 1;
        wbm_sel_i[0*SEL+: SEL] = {SEL{1'b1}};
        wbm_adr_i[0*`AW+: `AW] = slave_adr;
        wbm_dat_i[0*`DW+: `DW] = m0_slave_data;

        slave_adr = addresses[`AW-1:0];
        m1_slave_data = $urandom_range(0, 2**(`DW-2));

        wbm_stb_i[1] = 1;
        wbm_cyc_i[1] = 1;
        wbm_we_i [1]  = 1;
        wbm_sel_i[1*SEL+: SEL] = {SEL{1'b1}};
        wbm_adr_i[1*`AW+: `AW] = slave_adr;
        wbm_dat_i[1*`DW+: `DW] = m1_slave_data;

        wait(wbm_ack_o[0] && !wbm_ack_o[1]);
        wait(!wbm_ack_o[0] && !wbm_ack_o[1]);
        
        // Read
        wbm_we_i  = 2'b00;
        wait(wbm_ack_o[0]);
        wait(!wbm_ack_o[0]);
        if (wbm_dat_o[0*`DW+: `DW] !== m0_slave_data) begin
            $display("Error reading from slave");
            $finish;
        end

        $finish;
    end

    task read;
        input addr;
        input mindex;
        begin 
            @(posedge wb_clk_i) begin
                wbm_stb_i[mindex] = 1;
                wbm_cyc_i[mindex] = 1;
                wbm_we_i[mindex]  = 0;
                $display("Read cycle from master %0b started", mindex);
            end
            wait(wbm_ack_o[mindex]);
            wait(!wbm_ack_o[mindex]);
            wbm_stb_i[mindex] = 0;
            wbm_cyc_i[mindex] = 0;
            $display("Read cycle from master %0b ended.", mindex);
        end
    endtask

    task write;
        input [`AW-1:0] adr;
        input [`DW-1:0] data;
        input integer mindex;

        begin 
            @(posedge wb_clk_i) begin
                wbm_stb_i[mindex] = 1;
                wbm_cyc_i[mindex] = 1;
                wbm_we_i[mindex]  = 1;
                wbm_sel_i[mindex*SEL+: SEL] = {SEL{1'b1}};
                wbm_adr_i[mindex*`AW+: `AW] = adr;
                wbm_dat_i[mindex*`DW+: `DW] = data;
                $display("Write cycle from master %0b started", mindex);
            end
           
            wait(wbm_ack_o[mindex]);
            wait(!wbm_ack_o[mindex]);
            wbm_stb_i[mindex] = 0;
            wbm_cyc_i[mindex] = 0;
            $display("Write cycle from master %0b ended.", mindex);
        end
    endtask

endmodule