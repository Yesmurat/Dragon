import pipeline_pkg::*;
import hazard_io::*;

`timescale 1ns/1ps

module datapath (
    
                input logic         clk,
                input logic         reset,
                
                // input signals from Hazard Unit
                // input logic         StallF,
                // input logic         StallD,
                // input logic         FlushD,
                // input logic         FlushE,
                // input logic  [1:0]  ForwardAE,
                // input logic  [1:0]  ForwardBE,
                input hazard_out dp_inputs,
                output hazard_in dp_outputs

                // outputs to Hazard Unit
                // output logic [4:0]  Rs1D,
                // output logic [4:0]  Rs2D,
                // output logic [4:0]  Rs1E,
                // output logic [4:0]  Rs2E,
                // output logic [4:0]  RdE,
                // output logic [4:0]  RdM,
                // output logic [4:0]  RdW,

                // output logic        ResultSrcE_zero,
                // output logic        RegWriteM,
                // output logic        RegWriteW,
                // output logic        PCSrcE

);

    logic [31:0] PCF_new;
    logic [31:0] PCPlus4F;
    logic [31:0] PCF;
    logic [31:0] PCTargetE;

    logic [31:0] ResultW;
    logic [31:0] ALUResultM;

    ifid_t ifid_d, ifid_q;
    idex_t idex_d, idex_q;
    exmem_t exmem_d, exmem_q;
    memwb_t memwb_d, memwb_q;

    // PC mux
    assign PCF_new = PCSrcE ? PCTargetE : PCPlus4F;

    pc_reg PC_reg (

        .clk        (clk),
        .en         (~StallF),
        .reset      (reset),

        .PC_new     (PCF_new),
        .PC         (PCF)

    );

    if_stage IF (

        .PC         (PCF),
        .outputs    (ifid_d)

    );

    ifid_reg IFID_reg (

        .clk        (clk),
        .en         (~StallD),
        .reset      (reset | FlushD),

        .inputs     (ifid_d),
        .outputs    (ifid_q)

    );

    id_stage ID (

        .clk            (clk),
        .reset          (reset | FlushD),
        
        .RegWriteW      (RegWriteW),
        .RdW            (RdW),
        .ResultW        (ResultW),
        
        .inputs         (ifid_q),
        .outputs        (idex_d),

        .Rs1D           ( dp_outputs.Rs1D ),
        .Rs2D           ( dp_outputs.Rs2D )

    );

    idex_reg IDEX_reg (

        .clk        (clk),
        .en         (1'b1),
        .reset      (reset | FlushE),

        .inputs     (idex_d),
        .outputs    (idex_q)

    );

    ex_stage EX (

        .ResultW         (ResultW),
        .ALUResultM      (ALUResultM),
        .ForwardAE       (ForwardAE),
        .ForwardBE       (ForwardBE),

        .PCSrcE          (PCSrcE),
        .PCTargetE       (PCTargetE),

        .Rs1E            ( dp_outputs.Rs1E),
        .Rs2E            ( dp_outputs.Rs2E),
        .RdE             ( dp_outputs.RdE),
        .ResultSrcE_zero ( dp_outputs.ResultSrcE_zero),

        .inputs          (idex_q),
        .outputs         (exmem_d)

    );

    exmem_reg EXMEM_reg (

        .clk        (clk),
        .en         (1'b1),
        .reset      (reset),

        .inputs     (exmem_d),
        .outputs    (exmem_q)

    );

    mem_stage MEM (

        .clk        (clk),
        .inputs     (exmem_q),
        .outputs    (memwb_d),

        .ALUResultM (ALUResultM),

        .RdM        ( dp_outputs.RdM ),
        .RegWriteM  ( dp_outputs. RegWriteM )

    );

    memwb_reg MEMWB_reg (

        .clk        (clk),
        .en         (1'b1),
        .reset      (reset),

        .inputs     (memwb_d),
        .outputs    (memwb_q)

    );

    wb_stage WB (

        .inputs         (memwb_q),

        .RegWriteW      (RegWriteW),
        .RdW            (RdW),
        .ResultW        (ResultW)

    );

    assign PCPlus4F = ifid_d.PCPlus4;

endmodule