// TODO: Cabeçalho

module alu (
    input  [3:0] alu_funct,     // alu_funct[3] escolhe ADD || SUB, SRL || SRA;
                                // alu_funct[2:0] define o "supergrupo" de funções (funct3)

    input  [63:0] operand_a,
    input  [63:0] operand_b,

    output reg [63:0] result,

    output result_eq_zero           // Indica se result == 64'b0
);

assign result_eq_zero   = (result == 64'b0);


always @ ( * ) begin
    case (alu_funct[2:0])        // funct3
        `ALU_ADD_SUB:
            case (alu_funct[3])  // (`ALU_ADD_SUB || `ALU_SHIFTR) && inst_bit30) ? SUB : ADD;
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
            case (alu_funct[3])  // (`ALU_ADD_SUB || `ALU_SHIFTR) && inst_bit30) ? SRA : SRL;
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
