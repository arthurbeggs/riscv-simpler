// TODO: Cabeçalho

module imm_generator(
    input  [31:0] inst,
    output [63:0] immediate
);

`ifdef IMM_GEN_OPTIMAL
    // TODO: Implementar a geração de imediato otimizada;
`endif


// Geração de imediatos menos robusta
`ifndef IMM_GEN_OPTIMAL
    wire [63:0] imm_I, imm_S, imm_B, imm_U, imm_J;

    assign imm_I = {53{inst[31]}, inst[30:25], inst[24:20]};
    assign imm_S = {53{inst[31]}, inst[30:25], inst[11:7]};
    assign imm_B = {52{inst[31]}, inst[7], inst[30:25], inst[11:8], 1b'0};
    assign imm_U = {33{inst[31]}, inst[30:20], inst[19:12], 12b'0};
    assign imm_J = {44{inst[31]}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1b'0};

    always @ ( * ) begin
        case (inst[6:0]) // == inst_opcode
            OPC_LOAD,
            // OPC_LOAD_FP,
            OPC_OP_IMM,
            OPC_OP_IMM_32,
            OPC_JALR:   // Opcodes com imediato do tipo I
                immediate = imm_I;

            // OPC_STORE_FP,
            OPC_STORE:  // Opcodes com imediato do tipo S
                immediate = imm_S;

            OPC_BRANCH: // Opcodes com imediato do tipo B
                immediate = imm_B;

            OPC_AUIPC,
            OPC_LUI:    // Opcodes com imediato do tipo U
                immediate = imm_U;

            OPC_JAL:    // Opcodes com imediato do tipo J
                immediate = imm_J;

            default:
                immediate = 64'b0;
        endcase
    end

`endif
