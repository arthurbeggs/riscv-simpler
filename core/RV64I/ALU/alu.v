////////////////////////////////////////////////////////////////////////////////
//                 RISC-V SiMPLE - Unidade Lógica Aritmética                  //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module alu (
    input  [3:0] alu_funct,     // alu_funct[3] escolhe ADD || SUB, SRL || SRA;
                                // alu_funct[2:0] define a função da ULA (funct3)

    input  [63:0] operand_a,    // Entrada A da ULA
    input  [63:0] operand_b,    // Entrada B da ULA

    output reg [63:0] result,   // Resultado da operação executada

    output result_eq_zero       // Indica se result == 64'b0
);


assign result_eq_zero   = (result == 64'b0);


always @ ( * ) begin
    case (alu_funct[2:0])        // funct3
        `ALU_ADD_SUB:
            // (`ALU_ADD_SUB || `ALU_SHIFTR) && inst_bit30) ? SUB : ADD;
            case (alu_funct[3])
                1'b0:   // ADD
                    result = operand_a + operand_b;

                1'b1:   // SUB
                    result = operand_a - operand_b;
            endcase

        `ALU_SLL:
                result = operand_a << operand_b[5:0];

        `ALU_SLT:
            result = operand_a < operand_b;

        `ALU_SLTU:
            result = $unsigned(operand_a) < $unsigned(operand_b);

        `ALU_XOR:
            result = operand_a ^ operand_b;

        `ALU_SHIFTR:
            // (`ALU_ADD_SUB || `ALU_SHIFTR) && inst_bit30) ? SRA : SRL;
            case (alu_funct[3])
                1'b0:   // SRL
                    result = operand_a >> operand_b[5:0];
                1'b1:   // SRA
                    result = operand_a >>> operand_b[5:0];
            endcase

        `ALU_OR:
            result = operand_a | operand_b;

        `ALU_AND:
            result = operand_a & operand_b;
    endcase
end


endmodule
