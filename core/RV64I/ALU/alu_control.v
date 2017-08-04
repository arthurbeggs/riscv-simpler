// TODO: Cabeçalho

module alu_control (
    input  [1:0] alu_op,        // ADD || SUB || OP || Branch
    input  [2:0] inst_funct3,   // Campo funct3
    input  inst_bit30,          // inst[30] arbitra funções da ALU com mesmo funct3

    output reg [3:0] alu_funct
);


// Verifica se a instrução atual é SUB ou SRA
wire secondary_funct = (((inst_funct3 == `ALU_ADD_SUB) || (inst_funct3 == `ALU_SHIFTR)) && inst_bit30) ? 1'b1 : 1'b0;


// Escolhe a função utilizada para os branches
reg [2:0] branch_funct;

always @ ( * ) begin
    case (inst_funct3)
        `BRANCH_EQ,
        `BRANCH_NE:
            branch_funct = `ALU_ADD_SUB;

        `BRANCH_LT,
        `BRANCH_GE:
            branch_funct = `ALU_SLT;

        `BRANCH_LTU,
        `BRANCH_GEU:
            branch_funct = `ALU_SLTU;

        default:
            branch_funct = 3'b0;
    endcase
end


always @ ( * ) begin
    case (alu_op)
        2'b00:
            alu_funct = {1'b0, `ALU_ADD_SUB};
        2'b01:
            alu_funct = {1'b1, `ALU_ADD_SUB};
        2'b10:  // OPC_OP, OPC_OP_32, OPC_OP_IMM e OPC_OP_IMM_32
            alu_funct = {secondary_funct, inst_funct3};
        2'b11:  // Branches
            alu_funct = {1'b1, branch_funct};   // alu_funct[3] == 1 para subtrair operandos
    endcase
end


endmodule
