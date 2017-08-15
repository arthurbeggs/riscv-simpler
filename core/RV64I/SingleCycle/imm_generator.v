////////////////////////////////////////////////////////////////////////////////
//                    RISC-V SiMPLE - Geração de Imediatos                    //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  Desabilite o "soft-wrapping" de seu editor para visualizar corretamente!  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


module imm_generator (
    input  [31:0] inst,
    output reg [63:0] immediate
);


// TODO: Produzir uma versão melhor
wire [63:0] imm_I, imm_S, imm_B, imm_U, imm_J;

// Imediatos
//      63...........31.30........20.19........12.11.....11.10.........5.4............1.0....0
// I = {{53{inst[31]}},                                     inst[30:25], inst[24:20]};
// S = {{53{inst[31]}},                                     inst[30:25], inst[11:7]};
// B = {{52{inst[31]}}, inst[7],                            inst[30:25], inst[11:8],   1`b0};
// U = {{33{inst[31]}}, inst[30:20], inst[19:12],                                      12`b0};
// J = {{44{inst[31]}},              inst[19:12], inst[20], inst[30:25], inst[24:21],  1`b0};

always @ ( * ) begin
    case (inst[6:0]) // Opcode
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
            
            // Tipo U possui o menor fanout para o bit inst[31];
            immediate = {{33{inst[31]}}, inst[30:20], inst[19:12], {12'b0}};
    endcase
end


endmodule
