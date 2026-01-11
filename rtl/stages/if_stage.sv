import pipeline_pkg::ifid_t;

module if_stage (
    
        input logic  [31:0] PC,
        
        output ifid_t outputs,

        output logic [31:0] PCPlus4F
        
    );

    always_comb begin

        outputs.PC = PC;
        outputs.PCPlus4 = PC + 32'd4;
        PCPlus4F = PC + 32'd4;
        
    end

    imem instr_mem(

        .address    (PC[31:2]),
        .rd         (outputs.instr)

    );

endmodule // IF stage