// TODO: Fazer cabeçalho

module control_transfer_singlecycle (
    input  branch_en,
    input  jal_en,
    input  jalr_en,
    input  result_bit0,
    input  result_eq_zero,
    input  [2:0] inst_funct3,

    output reg [1:0] pc_sel
);

always @ ( * ) begin
    if (branch_en) begin
        case (inst_funct3)
            `BRANCH_EQ:
                pc_sel = result_eq_zero ? 2'b01 : 2'b00;

            `BRANCH_NE:
                pc_sel = result_eq_zero ? 2'b00 : 2'b01;

            `BRANCH_LT:
                pc_sel = result_bit0    ? 2'b01 : 2'b00;

            `BRANCH_GE:
                pc_sel = result_bit0    ? 2'b00 : 2'b01;

            `BRANCH_LTU:
                pc_sel = result_bit0    ? 2'b01 : 2'b00;

            `BRANCH_GEU:
                pc_sel = result_bit0    ? 2'b00 : 2'b01;

            default:
                // NOTE: Instrução inválida
                pc_sel = 2'b00;

        endcase
    end

    else if (jal_en) begin
        pc_sel = 2'b01;
    end

    else if (jalr_en) begin
        pc_sel = 2'b10;
    end

    else begin
        pc_sel = 2'b00;
    end
end


endmodule
