import pipeline_pkg::ifid_t;

module if_stage (
    
        input logic  [31:0] PC,
        
        output ifid_t outputs
        
    );

    always_comb begin

        outputs.PC = PC;
        outputs.PCPlus4 = PC + 32'd4;
        
    end

    imem instr_mem(

        .address    (PC),
        .rd         (outputs.instr)

    );

endmodule // IF stage