// TODO: Cabeçalho;

module control_singlecycle (
    input  [6:0] inst_opcode,

    output branch_enable,
    output data_mem_read_enable,    // NOTE: Read enable é necessário?
    output data_mem_write_enable,   // Habilita escrita na memória de dados
    output regfile_write_enable,    // Habilita escrita no regfile
    output pc_write_enable,         // Habilita escrita de PC
    output [1:0] mem_to_reg_sel,    // Seleciona a entrada de escrita do regfile
    output [1:0] alu_op,            // Seleciona a funcionalidade da ALU
    output [1:0] alu_sel_src_a,     // Seleciona a entrada A da ALU
    output [1:0] alu_sel_src_b,     // Seleciona a entrada B da ALU
);

wire [12:0] control_signals;

assign branch_enable            = control_signals[12];
assign data_mem_read_enable     = control_signals[11];
assign data_mem_write_enable    = control_signals[10];
assign regfile_write_enable     = control_signals[9];
assign pc_write_enable          = control_signals[8];
assign mem_to_reg_sel           = control_signals[7:6];
assign alu_op                   = control_signals[5:4];
assign alu_sel_src_a            = control_signals[3:2];
assign alu_sel_src_b            = control_signals[1:0];


// NOTE: A estratégia de código compacto é uma boa ideia?

// TODO: passar sinais PC e 64'b0 para alu_sel_src_b e retirar alu_sel_src_a;
// TODO: passar pc_write_enable para o MSB (fica mais fácil de desativá-lo);

initial begin
    control_signals = { 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b00 , 2'b00 , 2'b00 };
end

always @ ( * ) begin
    case (inst_opcode)
        OPC_LOAD:
            control_signals = { 1'b0 , 1'b1 , 1'b0 , 1'b1 , 1'b1 , 2'b01 , 2'b00 , 2'b00 , 2'b01 };
        // OPC_LOAD_FP:
        // OPC_custom0:
        // OPC_MISC_MEM:
        OPC_OP_IMM:
            control_signals = { 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b1 , 2'b00 , 2'b10 , 2'b00 , 2'b01 };
        OPC_AUIPC:                                                                // PC
            control_signals = { 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b1 , 2'b00 , 2'b00 , 2'b01 , 2'b01 };
        OPC_OP_IMM_32:
            control_signals = { 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b1 , 2'b00 , 2'b10 , 2'b00 , 2'b01 };
        // OPC_LEN_48b0:
        OPC_STORE:
            control_signals = { 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b1 , 2'b00 , 2'b00 , 2'b00 , 2'b01 };
        // OPC_STORE_FP:
        // OPC_custom1:
        // OPC_AMO:
        OPC_OP:
            control_signals = { 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b1 , 2'b00 , 2'b10 , 2'b00 , 2'b00 };
        OPC_LUI:                                                                 // 64'b0
            control_signals = { 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b1 , 2'b00 , 2'b00 , 2'b10 , 2'b01 };
        OPC_OP_32:
            control_signals = { 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b1 , 2'b00 , 2'b10 , 2'b00 , 2'b00 };
        // OPC_LEN_64b:
        // OPC_MADD:
        // OPC_MSUB:
        // OPC_NMSUB:
        // OPC_NMADD:
        // OPC_OP_FP:
        // OPC_reserved0:
        // OPC_custom2:
        // OPC_LEN_48b1:
        OPC_BRANCH:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b11 , 2'b00 , 2'b00 };
        OPC_JALR:
            control_signals = { 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b1 , 2'b00 , 2'b00 , 2'b00 , 2'b01 };
        // OPC_reserved1:
        OPC_JAL:                                                                  // PC
            control_signals = { 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b1 , 2'b00 , 2'b00 , 2'b01 , 2'b01 };
        // OPC_SYSTEM:
        // OPC_reserved2:
        // OPC_custom3:
        // OPC_LEN_80b:

        default:
            control_signals = { 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b00 , 2'b00 , 2'b00 };

    endcase
end
