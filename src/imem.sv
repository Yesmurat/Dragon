`timescale 1ns/1ps
// Instruction Memory 64 words x 32 bits

module imem (
    
        input logic  [31:0] a,
        output logic [31:0] rd

    );

    logic [31:0] ROM[63:0];
    
    initial $readmemh("...", ROM);

    assign rd = ROM[ a[31:2] ];

endmodule // Instruction memory