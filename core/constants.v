// NOTE: Colocar cabeçalho

//  .d8888b.                             888                      888
// d88P  Y88b                            888                      888
// 888    888                            888                      888
// 888         .d88b.  88888b.  .d8888b  888888  8888b.  88888b.  888888 .d88b.  .d8888b
// 888        d88""88b 888 "88b 88K      888        "88b 888 "88b 888   d8P  Y8b 88K
// 888    888 888  888 888  888 "Y8888b. 888    .d888888 888  888 888   88888888 "Y8888b.
// Y88b  d88P Y88..88P 888  888      X88 Y88b.  888  888 888  888 Y88b. Y8b.          X88
//  "Y8888P"   "Y88P"  888  888  88888P'  "Y888 "Y888888 888  888  "Y888 "Y8888   88888P'
//
//
//


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
