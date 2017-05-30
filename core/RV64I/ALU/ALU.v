// TODO: Cabeçalho

module alu (
    input  [4:0] alu_function,      // alu_function[4] escolhe shamts de 5 ou 6 bits;
                                    // alu_function[3] escolhe ADD | SUB, SRL | SRA;
                                    // alu_function[2:0] define o "supergrupo" de funções

    input  [63:0] operand_a,
    input  [63:0] operand_b,

    output reg [63:0] result,
    
    output result_lsb,              // Bit menos significativo do resultado
    output result_eq_zero           // Indica se result == 64'b0
);

assign result_lsb       = result[0];
assign result_eq_zero   = (result == 64'b0);

// NOTE: Um segundo/terceiro nível de lógica reduz LUT's, mas aumenta o tempo de propagação. O que seria melhor aqui? A síntese já escolhe o melhor?

always @ ( * ) begin
    case (alu_function[2:0])
        `ALU_ADD_SUB:
            case (alu_function[3])        // (inst[30] & Rtype) ? SUB : ADD;
                1'b0:   // ADD
                    result = operand_a + operand_b;
                1'b1:   // SUB
                    result = operand_a - operand_b;
            endcase
        `ALU_SLL:
            case (alu_function[4])
                1'b0:   // 64 bits de range
                    result = operand_a << operand_b[5:0];
                1'b1:   // 32 bits de range
                    result = operand_a << operand_b[4:0];
            endcase
        `ALU_SLT:
            result = operand_a < operand_b;
        `ALU_SLTU:
            result = $unsigned(operand_a) < $unsigned(operand_b);
        `ALU_XOR:
            result = operand_a ^ operand_b;
        `ALU_SHIFTR:
            case (alu_function[3])        // (inst[30] & Rtype) ? SRA : SRL;
                1'b0:   // SRL
                case (alu_function[4])
                    1'b0:   // 64 bits de range
                        result = operand_a >> operand_b[5:0];
                    1'b1:   // 32 bits de range
                        result = operand_a >> operand_b[4:0];
                endcase
                1'b1:   // SRA
                case (alu_function[4])
                    1'b0:   // 64 bits de range
                        result = operand_a >>> operand_b[5:0];
                    1'b1:   // 32 bits de range
                        result = operand_a >>> operand_b[4:0];
                endcase
            endcase
        `ALU_OR:
            result = operand_a | operand_b;
        `ALU_AND:
            result = operand_a & operand_b;
    endcase
end


endmodule
