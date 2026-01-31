`timescale 1ns/1ps

module testbench;

    localparam CLK_PERIOD = 10;
    localparam XLEN       = 32;
    localparam MEMORY_CAPACITY = 256;

    logic clk;
    logic reset;
    logic [31:0] RD_instr;
    logic [XLEN-1:0] RD_data;

    riscv #(
        
        .XLEN       (XLEN),
        .MEMORY_CAPACITY (MEMORY_CAPACITY)

    ) dut (

        .clk            (clk),
        .reset          (reset),
        
        .RD_instr       (RD_instr),
        .RD_data        (RD_data)

    );

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
        reset = 1;
        #7;
        reset = 0;
        #1000;
        $stop;
    end

endmodule