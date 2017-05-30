// TODO: Cabeçalho

module alu_control (
    input  [1:0] alu_op,
    input  [6:0] inst_opcode,
    input  [2:0] inst_funct3,   // Campo funct3 da instrução
    input  inst_bit30,          // instr[30] arbitra funções da ALU com mesmo funct3

    output reg [4:0] alu_function
);

// TODO: Tentar melhorar a lógica de controle. Caminho crítico está longo.

// Verifica se a instrução atual opera em 32 ou 64 bits. Verdadeiro para 32 bits, falso para 64 bits.
wire word_inst = ((inst_opcode == `OPC_OP_IMM_32) || (inst_opcode == `OPC_OP_32)) ? 1'b1 : 1'b0;

// Escolhe a função utilizada para os branches
wire [2:0] branch_function = (((inst_funct3 == `BRANCH_EQ) || (inst_funct3 == `BRANCH_NE))
    ? `ALU_ADD_SUB      :    (((inst_funct3 == `BRANCH_LT) || (inst_funct3 == `BRANCH_GE))
        ? `ALU_SLT      :   (((inst_funct3 == `BRANCH_LTU) || (inst_funct3 == `BRANCH_GEU))
            ? `ALU_SLTU : 3'b0)));

// Verifica se a instrução atual é lógica/aritmética e usa a função secundária (subtração e shift aritmético)
wire secondary_function = ((((inst_funct3 == `ALU_ADD_SUB) || (inst_funct3 == `ALU_SHIFTR)) && inst_bit30)  ? 1'b1 : 1'b0);


always @ ( * ) begin
    case (alu_op)
        2'b00:
            alu_function = {2'b00, `ALU_ADD_SUB};
        2'b01:
            alu_function = {2'b01, `ALU_ADD_SUB};
        2'b10:  // OPC_OP, OPC_OP_32, OPC_OP_IMM e OPC_OP_IMM_32
            alu_function = {word_inst , secondary_function, inst_funct3};
        2'b11:  // Branches
            alu_function = {2'b01, branch_function};
    endcase
end


endmodule
