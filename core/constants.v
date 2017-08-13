////////////////////////////////////////////////////////////////////////////////
//                         RISC-V SiMPLE - Constantes                         //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


// Opcodes (NOTE: Instruções comprimidas omitidas)
`define    OPC_LOAD        7'b0000011
// `define    OPC_LOAD_FP     7'b0000111
// `define    OPC_custom0     7'b0001011
// `define    OPC_MISC_MEM    7'b0001111
`define    OPC_OP_IMM      7'b0010011
`define    OPC_AUIPC       7'b0010111
`define    OPC_OP_IMM_32   7'b0011011
// `define    OPC_LEN_48b0    7'b0011111
`define    OPC_STORE       7'b0100011
// `define    OPC_STORE_FP    7'b0100111
// `define    OPC_custom1     7'b0101011
// `define    OPC_AMO         7'b0101111
`define    OPC_OP          7'b0110011
`define    OPC_LUI         7'b0110111
`define    OPC_OP_32       7'b0111011
// `define    OPC_LEN_64b     7'b0111111
// `define    OPC_MADD        7'b1000011
// `define    OPC_MSUB        7'b1000111
// `define    OPC_NMSUB       7'b1001011
// `define    OPC_NMADD       7'b1001111
// `define    OPC_OP_FP       7'b1010011
// `define    OPC_reserved0   7'b1010111
// `define    OPC_custom2     7'b1011011
// `define    OPC_LEN_48b1    7'b1011111
`define    OPC_BRANCH      7'b1100011
`define    OPC_JALR        7'b1100111
// `define    OPC_reserved1   7'b1101011
`define    OPC_JAL         7'b1101111
// `define    OPC_SYSTEM      7'b1110011
// `define    OPC_reserved2   7'b1110111
// `define    OPC_custom3     7'b1111011
// `define    OPC_LEN_80b     7'b1111111

// Interpretação do campo funct3 para a Unidade Lógica e Aritmética
`define    ALU_ADD_SUB     3'b000       // (inst[30] & Rtype) ? SUB : ADD;
`define    ALU_SLL         3'b001
`define    ALU_SLT         3'b010
`define    ALU_SLTU        3'b011
`define    ALU_XOR         3'b100
`define    ALU_SHIFTR      3'b101       // (inst[30] & Rtype) ? SRA : SRL;
`define    ALU_OR          3'b110
`define    ALU_AND         3'b111

// Operações da ULA de Ponto flutuante
// `define    FALUOP_

// Interpretação do campo funct3 para Branches
`define    BRANCH_EQ       3'b000
`define    BRANCH_NE       3'b001
`define    BRANCH_LT       3'b100
`define    BRANCH_GE       3'b101
`define    BRANCH_LTU      3'b110
`define    BRANCH_GEU      3'b111

`define    INITIAL_PC      32'b0
