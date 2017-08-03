// TODO: Cabeçalho

module alu32 (
    input  [3:0] alu_function,      // alu_function[3] escolhe ADD || SUB, SRL || SRA;
                                    // alu_function[2:0] define o "supergrupo" de funções
    input  [63:0] operand_a,
    input  [63:0] operand_b,

    output [63:0] result
);

reg [31:0] result_32;

assign result = { {32{result_32[31]}}, result_32[31:0] };


// NOTE: Há ambiguidades na especificação. Verificar se as operações de 32 bits estão corretas ou se entendi errado.

always @ ( * ) begin
    case (alu_function[2:0])        // funct3
        `ALU_ADD_SUB:
            case (alu_function[3])  // (inst[30] & Rtype) ? SUB : ADD;
                1'b0:   // ADD
                    result_32 = operand_a[31:0] + operand_b[31:0];
                1'b1:   // SUB
                    result_32 = operand_a[31:0] - operand_b[31:0];
            endcase

        `ALU_SLL:
            result_32 = operand_a[31:0] << operand_b[5:0];

        `ALU_SHIFTR:
            case (alu_function[3])        // (inst[30] & Rtype) ? SRA : SRL;
                1'b0:   // SRL
                    result_32 = operand_a[31:0] >> operand_b[4:0];
                1'b1:   // SRA
                    result_32 = operand_a[31:0] >>> operand_b[4:0];
            endcase

        default:      // Funções não usadas em OP_32 e OP_32_IMM foram retiradas para simplificar o hardware.
            result_32 = 32'b0;

    endcase
end


endmodule
