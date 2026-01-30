`timescale 1ns/1ps

module wdext #(
    parameter XLEN = 32
) (

    input logic MemWriteM,
    input logic [ $clog2(XLEN/8)-1:0 ] byteAddrM,
    input logic [2:0] funct3M,
    output logic [ XLEN/8-1:0 ] byteEnable

);

    integer i;

    always_comb begin

        byteEnable = { (XLEN/8){1'b0} };

        if (MemWriteM) begin

            unique case (funct3M)

                3'b000: byteEnable = 1 << byteAddrM; // store byte

                3'b001: begin // store half word

                    for (i = 0; i < XLEN/8; i = i + 1) begin

                        if (i[0] == byteAddrM[0]) begin
                            byteEnable[i] = 1;
                        end

                    end

                end

                3'b010: byteEnable = { (XLEN/8){1'b1} }; // store word / store data

                default: byteEnable = { (XLEN/8){1'b0} };

            endcase

        end

    end
    
endmodule