`timescale 1ns/1ps

import pipeline_pkg::ifid_t;

module if_stage #(
    
        parameter XLEN = 32,
        parameter MEMORY_CAPACITY = 256
        
    ) (
    
        // input logic             clk,
        input logic  [XLEN-1:0] PC,

        output logic [XLEN-1:0] PCPlus4F,
        output ifid_t           outputs
        
    );

    always_comb begin

        outputs.PC      = PC;
        outputs.PCPlus4 = PC + 4;
        PCPlus4F        = PC + 4;
        
    end

    (* dont_touch = "true" *) imem #(

        .XLEN               (XLEN),
        .MEMORY_CAPACITY    (MEMORY_CAPACITY)

    ) instr_mem(

        // .clk        (clk),
        .address    ( PC[ XLEN-1 : 2 ] ),
        .rd         ( outputs.instr )

    );

endmodule // IF stage