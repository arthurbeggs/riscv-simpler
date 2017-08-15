////////////////////////////////////////////////////////////////////////////////
//            RISC-V SiMPLE - Unidade de Transferência de Controle            //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module control_transfer_singlecycle (
    input  branch_en,           // Instrução == Branch
    input  jal_en,              // Instrução == JAL
    input  jalr_en,             // Instrução == JALR
    input  result_eq_zero,      // Sinal de resultado da ULA == 64'b0
    input  [2:0] inst_funct3,   // Campo funct3 da instrução

    output reg [1:0] pc_sel     // Seletor do multiplexer de próximo PC
);


always @ ( * ) begin
    // Se instrução == Branch, próximo PC pode ser PC+4 ou PC+imm
    // alu_result[0] == !result_eq_zero
    if (branch_en) begin
        case (inst_funct3)
            `BRANCH_EQ:
                pc_sel = result_eq_zero ? 2'b01 : 2'b00;

            `BRANCH_NE:
                pc_sel = result_eq_zero ? 2'b00 : 2'b01;

            `BRANCH_LT:
                pc_sel = result_eq_zero ? 2'b00 : 2'b01;

            `BRANCH_GE:
                pc_sel = result_eq_zero ? 2'b01 : 2'b00;

            `BRANCH_LTU:
                pc_sel = result_eq_zero ? 2'b00 : 2'b01;

            `BRANCH_GEU:
                pc_sel = result_eq_zero ? 2'b01 : 2'b00;

            default:
                // Instrução inválida
                pc_sel = 2'b00;
        endcase
    end

    // Se instrução == JAL, próximo PC == PC+imm
    else if (jal_en) begin
        pc_sel = 2'b01;
    end

    // Se instrução == JALR, próximo PC == {(rs1_data + imm)[31:1], 1'b0}
    else if (jalr_en) begin
        pc_sel = 2'b10;
    end

    // Se a instrução for qualquer outra, próximo PC == PC+4
    else begin
        pc_sel = 2'b00;
    end
end


endmodule
