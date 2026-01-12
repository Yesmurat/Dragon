module pc_reg #(
    parameter XLEN = 32
) (

    input logic         clk,
    input logic         en,
    input logic         reset,

    input logic [XLEN-1:0]  PC_new,
    output logic [XLEN-1:0] PC
    
);

    always_ff @( posedge clk or posedge reset ) begin : pc_register

        if (reset) begin
            PC <= '0;
        end

        else if (en) begin
            PC <= PC_new;    
        end

    end
    
endmodule