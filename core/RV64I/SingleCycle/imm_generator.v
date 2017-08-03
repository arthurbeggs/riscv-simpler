// TODO: Cabeçalho

module imm_generator (
    input  [31:0] inst,
    output reg [63:0] immediate
);

// `ifdef IMM_GEN_OPTIMAL
//
//     wire bit_0;
//     wire [3:0]  bit_4_1;
//     wire [5:0]  bit_10_5;
//     wire bit_11;
//     wire [7:0]  bit_19_12;
//     wire [10:0] bit_30_20;
//     wire [32:0] bit_63_31;
//
//     assign immediate = {bit_63_31, bit_30_20, bit_19_12, bit_11, bit_10_5, bit_4_1, bit_0};
//
//     always @ ( * ) begin
//
//     end
//
// `endif


// NOTE: Verificar como é sintetizado antes de tentar produzir uma versão melhor
// `ifndef IMM_GEN_OPTIMAL
    wire [63:0] imm_I, imm_S, imm_B, imm_U, imm_J;

// Imediatos
//      63...........31.30........20.19........12.11.....11.10.........5.4............1.0....0
// I = {{53{inst[31]}},                                     inst[30:25], inst[24:20]};
// S = {{53{inst[31]}},                                     inst[30:25], inst[11:7]};
// B = {{52{inst[31]}}, inst[7],                            inst[30:25], inst[11:8],   1`b0};
// U = {{33{inst[31]}}, inst[30:20], inst[19:12],                                      12`b0};
// J = {{44{inst[31]}},              inst[19:12], inst[20], inst[30:25], inst[24:21],  1`b0};

    always @ ( * ) begin
        case (inst[6:0]) // == inst_opcode
            `OPC_LOAD,
            // `OPC_LOAD_FP,
            `OPC_OP_IMM,
            `OPC_OP_IMM_32,
            `OPC_JALR:      // Opcodes com imediato do tipo I
                immediate = {{53{inst[31]}}, inst[30:25], inst[24:20]};

            // `OPC_STORE_FP,
            `OPC_STORE:     // Opcodes com imediato do tipo S
                immediate = {{53{inst[31]}}, inst[30:25], inst[11:7]};

            `OPC_BRANCH:    // Opcodes com imediato do tipo B
                immediate = {{52{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};

            `OPC_AUIPC,
            `OPC_LUI:       // Opcodes com imediato do tipo U
                immediate = {{33{inst[31]}}, inst[30:20], inst[19:12], 12'b0};

            `OPC_JAL:    // Opcodes com imediato do tipo J
                immediate = {{44{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], {1'b0}};

            default:
                // NOTE: verificar o melhor comportamento para default
                // immediate = 64'b0;
                immediate = {{33{inst[31]}}, inst[30:20], inst[19:12], {12'b0}}; // Tipo U possui o menor fan out para o bit inst[31];
        endcase
    end

// `endif


endmodule
