////////////////////////////////////////////////////////////////////////////////
//                 RISC-V SiMPLE - Caminho de Dados Uniciclo                  //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module datapath_singlecycle (
    input  clk,
    input  rst,

    input  [31:0] inst,         // Instrução atual
    output [31:0] pc,           // Program Counter atual

    input  [63:0] data_mem_data_fetched,  // Dado recebido da memória de dados
    output data_mem_read_en,              // Habilita leitura da mem de dados
    output data_mem_write_en,             // Habilita escrita da mem de dados
    output [31:0] data_mem_addr,          // Endereço desejado da mem de dados
    output [63:0] data_mem_write_data,    // Dado a ser escrito na mem de dados
    output [2:0]  data_mem_width          // Largura do dado a ser lido/escrito
);


wire [1:0]   pc_sel;            // Seletor do mux_pc_sel
wire [31:0]  pc_plus_4;         // pc + 4
wire [31:0]  pc_plus_immediate; // pc + immediate
wire [31:0]  next_pc;           // PC da próxima instrução

wire [63:0] immediate;          // Imediato gerado.

wire [3:0]  alu_funct;          // Função executada pela ULA
wire [63:0] alu_operand_a;      // Entrada A da ULA
wire [63:0] alu_operand_b;      // Entrada B da ULA
wire [63:0] alu_result;         // Resultado do cálculo da ULA de 64 bits
wire [63:0] alu32_result;       // Resultado do cálculo da ULA de 32 bits
wire alu_result_eq_zero;        // Resultado da ULA de 64 bits == 0 ? 1 : 0

wire pc_write_en;               // Habilita escrita do próximo pc no registrador
wire jal_en;                    // Transferência de controle - instrução JAL
wire jalr_en;                   // Transferência de controle - instrução JALR
wire branch_en;                 // Transferência de controle - Branches
wire regfile_write_en;          // Habilita escrita no banco de registradores
wire [2:0] mem_to_reg_sel;      // Seletor do mux_mem_to_reg
wire [1:0] alu_op;              // Sinal de controle recebido por alu_control
wire alu_src_a_sel;             // Seletor do mux da entrada A da ULA
wire alu_src_b_sel;             // Seletor do mux da entrada B da ULA

wire [63:0]  rd_data;           // Dado a ser escrito no registrador rd
wire [63:0]  rs1_data;          // Saída do registrador rs1
wire [63:0]  rs2_data;          // Saída do registrador rs2


// Barramentos de entrada dos multiplexadores
wire [511:0] mem_to_reg_bus;    // Barramento de entrada do mux_mem_to_reg
wire [127:0] next_pc_bus;       // Barramento de entrada do mux_pc_sel
wire [127:0] operand_a_bus;     // Barramento de entrada do mux_operand_a
wire [127:0] operand_b_bus;     // Barramento de entrada do mux_operand_b

// 8 entradas de 64 bits
assign mem_to_reg_bus   = { 64'b0,                      // mux_mem_to_reg_in[7]
                            64'b0,                      // mux_mem_to_reg_in[6]
                            64'b0,                      // mux_mem_to_reg_in[5]
                            {32'b0, pc_plus_4},         // mux_mem_to_reg_in[4]
                            immediate,                  // mux_mem_to_reg_in[3]
                            alu32_result,               // mux_mem_to_reg_in[2]
                            data_mem_data_fetched,      // mux_mem_to_reg_in[1]
                            alu_result };               // mux_mem_to_reg_in[0]

// 4 entradas de 32 bits
assign next_pc_bus      = { 32'b0,                      // mux_pc_sel_in[3]
                            {alu_result[31:1], 1'b0},   // mux_pc_sel_in[2]
                            pc_plus_immediate,          // mux_pc_sel_in[1]
                            pc_plus_4};                 // mux_pc_sel_in[0]

// 2 entradas de 64 bits
assign operand_a_bus    = { {32'b0, pc},                // mux_operand_a_in[1]
                            rs1_data };                 // mux_operand_a_in[0]

// 2 entradas de 64 bits
assign operand_b_bus    = { immediate,                  // mux_operand_b_in[1]
                            rs2_data };                 // mux_operand_b_in[0]



// Ligação das demais portas de entrada e saída do módulo
assign data_mem_addr        = alu_result[31:0];
assign data_mem_write_data  = rs2_data;
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
    .result(alu32_result)
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
    .alu_src_a_sel(alu_src_a_sel),
    .alu_src_b_sel(alu_src_b_sel)
);


control_transfer_singlecycle control_transfer_singlecycle (
    .branch_en(branch_en),
    .jal_en(jal_en),
    .jalr_en(jalr_en),
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
    .in_bus(mem_to_reg_bus),    // Sinais de entrada concatenados
    .sel(mem_to_reg_sel),       // Sinal de seleção de entrada
    .out(rd_data)               // Sinal de saída
);


mux #(
    .WIDTH(32),                 // Largura da palavra
    .CHANNELS(4)                // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_pc_sel (
    .in_bus(next_pc_bus),       // Sinais de entrada concatenados
    .sel(pc_sel),               // Sinal de seleção de entrada
    .out(next_pc)               // Sinal de saída
);


mux #(
    .WIDTH(64),                 // Largura da palavra
    .CHANNELS(2)                // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_operand_a (
    .in_bus(operand_a_bus),     // Sinais de entrada concatenados
    .sel(alu_src_a_sel),        // Sinal de seleção de entrada
    .out(alu_operand_a)         // Sinal de saída
);


mux #(
    .WIDTH(64),                 // Largura da palavra
    .CHANNELS(2)                // Quantidade de entradas SEMPRE IGUAL a 2^n
) mux_operand_b (
    .in_bus(operand_b_bus),     // Sinais de entrada concatenados
    .sel(alu_src_b_sel),        // Sinal de seleção de entrada
    .out(alu_operand_b)         // Sinal de saída
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
    .rd_addr(inst[11:7]),
    .rs1_addr(inst[19:15]),
    .rs2_addr(inst[24:20]),
    .rd_data(rd_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);




endmodule
