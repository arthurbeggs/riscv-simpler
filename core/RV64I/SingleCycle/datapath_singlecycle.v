// TODO: Fazer cabeçalho

module datapath_singlecycle (
    input clk,
    input rst

    //TODO: colocar sinais das memórias de dados e instruções

);


adder #(
    .WIDTH(32)
) adder_pc_plus_4 (
    .operand_a(),
    .operand_b(),
    .result()
);


adder #(
    .WIDTH(32)
) adder_pc_plus_immediate (
    .operand_a(),
    .operand_b(),
    .result()
);


alu alu(
    .alu_funct(),
    .operand_a(),
    .operand_b(),
    .result(),
    .result_eq_zero()
);


alu32 alu32(
    .alu_funct(),
    .operand_a(),
    .operand_b(),
    .result32()
);


alu_control alu_control(
    .alu_op(),
    .inst_funct3(),
    .inst_bit30(),
    .alu_funct()
);


control_singlecycle control_singlecycle(
    .inst_opcode(),
    .pc_write_en(),
    .jal_en(),
    .jalr_en(),
    .branch_en(),
    .data_mem_read_en(),
    .data_mem_write_en(),
    .regfile_write_en(),
    .mem_to_reg_sel(),
    .alu_op(),
    .alu_sel_src_a(),
    .alu_sel_src_b()
);


control_transfer_singlecycle control_transfer_singlecycle (
    .branch_en(),
    .jal_en(),
    .jalr_en(),
    .result_bit0(),
    .result_eq_zero(),
    .inst_funct3(),
    .pc_sel()
);


imm_generator imm_generator(
    .inst(),
    .immediate()
);


mux #(
    .WIDTH(32),     // Largura da palavra
    .CHANNELS(4)    // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_mem_to_reg (
    .in_bus(),      // Sinais de entrada concatenados
    .sel(),           // Sinal de seleção de entrada
    .out()            // Sinal de saída
);


mux #(
    .WIDTH(32),     // Largura da palavra
    .CHANNELS(4)    // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_pc_sel (
    .in_bus(),      // Sinais de entrada concatenados
    .sel(),           // Sinal de seleção de entrada
    .out()            // Sinal de saída
);


mux #(
    .WIDTH(64),     // Largura da palavra
    .CHANNELS(2)    // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_sel_operand_a (
    .in_bus(),      // Sinais de entrada concatenados
    .sel(),           // Sinal de seleção de entrada
    .out()            // Sinal de saída
);


mux #(
    .WIDTH(64),     // Largura da palavra
    .CHANNELS(2)    // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_sel_operand_b (
    .in_bus(),      // Sinais de entrada concatenados
    .sel(),           // Sinal de seleção de entrada
    .out()            // Sinal de saída
);


program_counter program_counter(
    .clk(),
    .rst(),
    .pc_en(),
    .next_pc(),
    .pc()
);


regfile regfile(
    .clk(),
    .rst(),
    .write_en(),
    .write_reg(),
    .read_reg_a(),
    .read_reg_b(),
    .write_data(),
    .reg_a_data(),
    .reg_b_data()
);




endmodule
