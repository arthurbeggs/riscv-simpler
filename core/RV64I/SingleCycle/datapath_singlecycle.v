////////////////////////////////////////////////////////////////////////////////
//                 RISC-V SiMPLE - Caminho de Dados Uniciclo                  //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module datapath_singlecycle (
    input  clk,
    input  rst,

    input  [31:0] inst,
    output [31:0] pc,

    input  [63:0] data_mem_data_fetched,
    output data_mem_read_en,
    output data_mem_write_en,
    output [31:0] data_mem_addr,
    output [63:0] data_mem_write_data,
    output [2:0]  data_mem_width
);


wire [1:0]   pc_sel;            // Seletor do mux do próximo pc
wire [31:0]  next_pc;           // PC da próxima instrução
wire [31:0]  pc_plus_4;         // pc + 4
wire [31:0]  pc_plus_immediate; // pc + immediate
wire [127:0] next_pc_bus;       // Barramento com todos os possíveis próximos Program Counters

wire [63:0] immediate;          // Imediato gerado.

wire [3:0]  alu_funct;          // Função executada pela ULA. Liga alu_control e alu.
wire [63:0] alu_operand_a;      // Liga mux de entrada das ULAs às entradas das ULAs.
wire [63:0] alu_operand_b;      // Liga mux de entrada das ULAs às entradas das ULAs.
wire [63:0] alu_result;         // Resultado do cálculo da ULA de 64 bits
wire [63:0] alu32_result;       // Resultado do cálculo da ULA de 32 bits
wire alu_result_eq_zero;        // Resultado da ULA de 64 bits == 0 ? 1 : 0

wire [127:0] operand_a_bus;     // Barramento com todos os possíveis operandos do mux da entrada A da ULA
wire [127:0] operand_b_bus;     // Barramento com todos os possíveis operandos do mux da entrada B da ULA

wire pc_write_en;               // Habilita escrita do próximo pc no registrador
wire jal_en;                    // Sinal de transferência de controle para instrução JAL
wire jalr_en;                   // Sinal de transferência de controle para instrução JALR
wire branch_en;                 // Sinal de transferência de controle para instruções de Branch
wire regfile_write_en;          // Habilita escrita no banco de registradores
wire [2:0] mem_to_reg_sel;      // Seletor do mux de write-back do banco de registradores
wire [1:0] alu_op;              // Liga control à alu_control e define a operação a ser executada
wire alu_sel_src_a;             // Seletor do mux da entrada A da ULA
wire alu_sel_src_b;             // Seletor do mux da entrada B da ULA

wire [63:0]  reg_a_data;        // Saída do registrador A do banco de registradores
wire [63:0]  reg_b_data;        // Saída do registrador B do banco de registradores
wire [63:0]  reg_write_data;    // Dado a ser escrito no banco de registradores
wire [511:0] reg_writeback_bus; // Barramento com todos os possíveis dados de write back


// Concatenação das entradas do mux, da maior para a menor
assign next_pc_bus = { 32'b0, {alu_result[31:1], 1'b0}, pc_plus_immediate, pc_plus_4};

assign reg_writeback_bus = { 64'b0, 64'b0, 64'b0, {32'b0, pc_plus_4}, immediate, alu32_result, data_mem_data_fetched, alu_result };

assign operand_a_bus = { {32'b0, pc}, reg_a_data };

assign operand_b_bus = { immediate , reg_b_data };


// Ligação das demais portas de entrada e saída do módulo
assign data_mem_addr        = alu_result[31:0];
assign data_mem_write_data  = reg_b_data;
assign data_mem_width       = inst[14:12];



adder #(
    .WIDTH(32)
) adder_pc_plus_4 (
    .operand_a(32'h00000004),
    .operand_b(pc),
    .result(pc_plus_4)
);


adder #(
    .WIDTH(32)
) adder_pc_plus_immediate (
    .operand_a(pc),
    .operand_b(immediate[31:0]),
    .result(pc_plus_immediate)
);


alu alu(
    .alu_funct(alu_funct),
    .operand_a(alu_operand_a),
    .operand_b(alu_operand_b),
    .result(alu_result),
    .result_eq_zero(alu_result_eq_zero)
);


alu32 alu32(
    .alu_funct(alu_funct),
    .operand_a(alu_operand_a[31:0]),
    .operand_b(alu_operand_b[31:0]),
    .result32(alu32_result)
);


alu_control alu_control(
    .alu_op(alu_op),
    .inst_funct3(inst[14:12]),
    .inst_bit30(inst[30]),
    .alu_funct(alu_funct)
);


control_singlecycle control_singlecycle(
    .inst_opcode(inst[6:0]),
    .pc_write_en(pc_write_en),
    .jal_en(jal_en),
    .jalr_en(jalr_en),
    .branch_en(branch_en),
    .data_mem_read_en(data_mem_read_en),
    .data_mem_write_en(data_mem_write_en),
    .regfile_write_en(regfile_write_en),
    .mem_to_reg_sel(mem_to_reg_sel),
    .alu_op(alu_op),
    .alu_sel_src_a(alu_sel_src_a),
    .alu_sel_src_b(alu_sel_src_b)
);


control_transfer_singlecycle control_transfer_singlecycle (
    .branch_en(branch_en),
    .jal_en(jal_en),
    .jalr_en(jalr_en),
    .result_bit0(alu_result[0]),
    .result_eq_zero(alu_result_eq_zero),
    .inst_funct3(inst[14:12]),
    .pc_sel(pc_sel)
);


imm_generator imm_generator(
    .inst(inst),
    .immediate(immediate)
);


mux #(
    .WIDTH(64),                 // Largura da palavra
    .CHANNELS(8)                // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_mem_to_reg (
    .in_bus(reg_writeback_bus), // Sinais de entrada concatenados
    .sel(mem_to_reg_sel),       // Sinal de seleção de entrada
    .out(reg_write_data)        // Sinal de saída
);


mux #(
    .WIDTH(32),             // Largura da palavra
    .CHANNELS(4)            // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_pc_sel (
    .in_bus(next_pc_bus),   // Sinais de entrada concatenados
    .sel(pc_sel),           // Sinal de seleção de entrada
    .out(next_pc)           // Sinal de saída
);


mux #(
    .WIDTH(64),             // Largura da palavra
    .CHANNELS(2)            // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_sel_operand_a (
    .in_bus(operand_a_bus), // Sinais de entrada concatenados
    .sel(alu_sel_src_a),    // Sinal de seleção de entrada
    .out(alu_operand_a)     // Sinal de saída
);


mux #(
    .WIDTH(64),             // Largura da palavra
    .CHANNELS(2)            // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_sel_operand_b (
    .in_bus(operand_b_bus), // Sinais de entrada concatenados
    .sel(alu_sel_src_b),    // Sinal de seleção de entrada
    .out(alu_operand_b)     // Sinal de saída
);


program_counter program_counter(
    .clk(clk),
    .rst(rst),
    .pc_en(pc_write_en),
    .next_pc(next_pc),
    .pc(pc)
);


regfile regfile(
    .clk(clk),
    .rst(rst),
    .write_en(regfile_write_en),
    .write_reg(inst[11:7]),
    .read_reg_a(inst[19:15]),
    .read_reg_b(inst[24:20]),
    .write_data(reg_write_data),
    .reg_a_data(reg_a_data),
    .reg_b_data(reg_b_data)
);




endmodule
