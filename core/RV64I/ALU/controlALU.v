// TODO: Cabeçalho

module alu_control (
    input  [1:0] alu_op,
    input  [6:0] instr_opcode,
    input  [2:0] instr_funct3,  // Campo funct3 da instrução
    input  instr_bit30,         // instr[30] arbitra funções da ALU com mesmo funct3

    output [4:0] alu_function
);

// Verifica se a instrução atual opera em 32 ou 64 bits. Verdadeiro para 32 bits, falso para 64 bits.
wire word_instr = ((instr_opcode == OPC_OP_IMM_32) || (instr_opcode == OPC_OP_32)) ? 1'b1 : 1'b0;

always @ ( * ) begin
    case (alu_op)
        2'b00:
            alu_function = {2'b00, ALU_ADD_SUB};
        2'b01:
            alu_function = {2'b01, ALU_ADD_SUB};
        2'b10:
            alu_function = {word_instr , instr_bit30, instr_funct3};
        default:
            alu_function = {2'b00, ALU_ADD_SUB};
    endcase
end
