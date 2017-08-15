////////////////////////////////////////////////////////////////////////////////
//         RISC-V SiMPLE - Unidade Lógica Aritmética de 32 e 64 bits          //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module alu_complete (
    input  [4:0] alu_funct,     // alu_funct[4] escolhe entre OP e OP32
                                // alu_funct[3] escolhe ADD || SUB, SRL || SRA;
                                // alu_funct[2:0] define a função da ULA (funct3)

    input  [63:0] operand_a,    // Entrada A da ULA
    input  [63:0] operand_b,    // Entrada B da ULA

    output reg [63:0] result,   // Resultado da operação executada

    output result_eq_zero       // Indica se result == 64'b0
);

reg [63:0] new_operand_a;
reg [63:0] new_operand_b;
reg [63:0] partial_result;

assign result_eq_zero   = (result == 64'b0);


always @ ( * ) begin
    if (alu_funct[4]) begin     // Função
        new_operand_a = { {33{operand_a[31]}}, operand_a[30:0] };
        new_operand_b = { {33{operand_b[31]}}, operand_b[30:0] };
    end

    else begin
        new_operand_a = operand_a;
        new_operand_b = operand_b;
    end
end


always @ ( * ) begin
    if (alu_funct[4]) begin     // Função
        result = { {33{partial_result[31]}}, partial_result[30:0] };
    end

    else begin
        result = partial_result;
    end
end


always @ ( * ) begin
    case (alu_funct[2:0])        // funct3
        `ALU_ADD_SUB:
            // (`ALU_ADD_SUB || `ALU_SHIFTR) && inst_bit30) ? SUB : ADD;
            case (alu_funct[3])
                1'b0:   // ADD
                    partial_result = new_operand_a + new_operand_b;

                1'b1:   // SUB
                    partial_result = new_operand_a - new_operand_b;
            endcase

        `ALU_SLL:
            if (alu_funct[4]) begin     // Função
                partial_result = new_operand_a << new_operand_b[4:0];
            end

            else begin
                partial_result = new_operand_a << new_operand_b[5:0];
            end

        `ALU_SLT:
            partial_result = new_operand_a < new_operand_b;

        `ALU_SLTU:
            partial_result = $unsigned(new_operand_a) < $unsigned(new_operand_b);

        `ALU_XOR:
            partial_result = new_operand_a ^ new_operand_b;

        `ALU_SHIFTR:
            // (`ALU_ADD_SUB || `ALU_SHIFTR) && inst_bit30) ? SRA : SRL;
            case (alu_funct[3])
                1'b0:   // SRL
                    if (alu_funct[4]) begin     // Função
                        partial_result = new_operand_a >> new_operand_b[4:0];
                    end

                    else begin
                        partial_result = new_operand_a >> new_operand_b[5:0];
                    end

                1'b1:   // SRA
                    if (alu_funct[4]) begin     // Função
                        partial_result = new_operand_a >>> new_operand_b[4:0];
                    end

                    else begin
                        partial_result = new_operand_a >>> new_operand_b[5:0];
                    end
            endcase

        `ALU_OR:
            partial_result = new_operand_a | new_operand_b;

        `ALU_AND:
            partial_result = new_operand_a & new_operand_b;
    endcase
end


endmodule
