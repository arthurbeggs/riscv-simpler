// TODO: Cabeçalho

module alu32 (
    input  [3:0] alu_funct,     // alu_funct[3] escolhe ADD || SUB, SRL || SRA;
                                // alu_funct[2:0] define o "supergrupo" de funções
    input  [31:0] operand_a,
    input  [31:0] operand_b,

    output [63:0] result32
);

reg [31:0] part_result;

assign result32 = { {32{part_result[31]}}, part_result[31:0] };


// NOTE: Há ambiguidades na especificação. Verificar se as operações de 32 bits estão corretas ou se entendi errado.

always @ ( * ) begin
    case (alu_funct[2:0])        // funct3
        `ALU_ADD_SUB:
            case (alu_funct[3])  // (inst[30] & Rtype) ? SUB : ADD;
                1'b0:   // ADD
                    part_result = operand_a[31:0] + operand_b[31:0];
                1'b1:   // SUB
                    part_result = operand_a[31:0] - operand_b[31:0];
            endcase

        `ALU_SLL:
            part_result = operand_a[31:0] << operand_b[5:0];

        `ALU_SHIFTR:
            case (alu_funct[3])        // (inst[30] & Rtype) ? SRA : SRL;
                1'b0:   // SRL
                    part_result = operand_a[31:0] >> operand_b[4:0];
                1'b1:   // SRA
                    part_result = operand_a[31:0] >>> operand_b[4:0];
            endcase

        default:      // Funções não usadas em OP_32 e OP_32_IMM foram retiradas para simplificar o hardware.
            part_result = 32'b0;

    endcase
end


endmodule
