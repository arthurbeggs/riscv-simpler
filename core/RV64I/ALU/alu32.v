////////////////////////////////////////////////////////////////////////////////
//            RISC-V SiMPLE - Unidade Lógica Aritmética de 32 bits            //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module alu32 (
    input  [3:0] alu_funct,     // alu_funct[3] escolhe ADD || SUB, SRL || SRA;
                                // alu_funct[2:0] define o "supergrupo" de funções
    input  [31:0] operand_a,    // Entrada A da ULA
    input  [31:0] operand_b,    // Entrada B da ULA

    output [63:0] result        // Resultado da operação executada
);


reg [31:0] part_result;         // Resultado parcial (sem extensão de sinal)

assign result = { {33{part_result[31]}}, part_result[30:0] };


// NOTE: Há ambiguidades na especificação. Verificar se as operações de 32 bits estão corretas ou se entendi errado.

always @ ( * ) begin
    case (alu_funct[2:0])   // funct3
        `ALU_ADD_SUB:
            // (`ALU_ADD_SUB || `ALU_SHIFTR) && inst_bit30) ? SUB : ADD;
            case (alu_funct[3])
                1'b0:   // ADD
                    part_result = operand_a[31:0] + operand_b[31:0];

                1'b1:   // SUB
                    part_result = operand_a[31:0] - operand_b[31:0];
            endcase

        `ALU_SLL:
            part_result = operand_a[31:0] << operand_b[4:0];

        `ALU_SHIFTR:
            // (`ALU_ADD_SUB || `ALU_SHIFTR) && inst_bit30) ? SRA : SRL;
            case (alu_funct[3])
                1'b0:   // SRL
                    part_result = operand_a[31:0] >> operand_b[4:0];

                1'b1:   // SRA
                    part_result = operand_a[31:0] >>> operand_b[4:0];
            endcase

        // Funções não usadas em OP_32 e OP_32_IMM foram retiradas para simplificar o hardware.
        default:
            part_result = 32'b0;

    endcase
end


endmodule
