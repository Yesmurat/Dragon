import hazard_io::*;

`timescale 1ns/1ps

module hazard (
    
        // input logic  [4:0] Rs1D, Rs2D,
        // input logic  [4:0] Rs1E, Rs2E, RdE,
        // input logic        PCSrcE, 
        // input logic        ResultSrcE_zero,
        // input logic  [4:0] RdM,
        // input logic        RegWriteM,
        // input logic  [4:0] RdW,
        // input logic        RegWriteW,
        input hazard_in inputs,

        // output logic       StallF,
        // output logic       StallD, FlushD,
        // output logic       FlushE,
        // output logic [1:0] ForwardAE, ForwardBE
        output hazard_out outputs

);

    logic lwStall;

    always_comb begin

        // Source A forwarding
        if ( ( ( inputs.Rs1E == inputs.RdM ) && inputs.RegWriteM ) && ( inputs.Rs1E != 0 ) )
            outputs.ForwardAE = 2'b10;

        else if ( ( ( inputs.Rs1E == inputs.RdW ) && inputs.RegWriteW ) && ( inputs.Rs1E != 0 ) )
            outputs.ForwardAE = 2'b01;

        else
            outputs.ForwardAE = 2'b00;

        // Source B forwarding
        if ( ( (inputs.Rs2E == inputs.RdM) && inputs.RegWriteM ) && (inputs.Rs2E != 0) )
            outputs.ForwardBE = 2'b10;

        else if ( ( (inputs.Rs2E == inputs.RdW) && inputs.RegWriteW ) && (inputs.Rs2E != 0) )
            outputs.ForwardBE = 2'b01;

        else
            outputs.ForwardBE = 2'b00;
        
    end

    // Load-use hazard
    assign lwStall = inputs.ResultSrcE_zero & ( ( inputs.Rs1D == inputs.RdE ) | ( inputs.Rs2D == inputs.RdE ) );

    // Stall IF & ID when a load hazard occurs
    assign outputs.StallF = lwStall;
    assign outputs.StallD = lwStall;

    // Flush when a branch is taken, jump occurs, or a load introduces a bubble
    assign outputs.FlushD = inputs.PCSrcE;
    assign outputs.FlushE = lwStall | inputs.PCSrcE;
    
endmodule