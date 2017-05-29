// NOTE: Colocar cabeçalho

//   _____                               _
//  |  __ \                             | |
//  | |__) |_ _ _ __ __ _ _ __ ___   ___| |_ _ __ ___  ___
//  |  ___/ _` | '__/ _` | '_ ` _ \ / _ \ __| '__/ _ \/ __|
//  | |  | (_| | | | (_| | | | | | |  __/ |_| | | (_) \__ \
//  |_|   \__,_|_|  \__,_|_| |_| |_|\___|\__|_|  \___/|___/
//

parameter

// Opcodes (NOTE: Instruções comprimidas omitidas)
    OPC_LOAD        = 7'b0000011,
    // OPC_LOAD_FP     = 7'b0000111,
    // OPC_custom0     = 7'b0001011,
    // OPC_MISC_MEM    = 7'b0001111,
    OPC_OP_IMM      = 7'b0010011,
    OPC_AUIPC       = 7'b0010111,
    OPC_OP_IMM_32   = 7'b0011011,
    // OPC_LEN_48b0    = 7'b0011111,
    OPC_STORE       = 7'b0100011,
    // OPC_STORE_FP    = 7'b0100111,
    // OPC_custom1     = 7'b0101011,
    // OPC_AMO         = 7'b0101111,
    OPC_OP          = 7'b0110011,
    OPC_LUI         = 7'b0110111,
    OPC_OP_32       = 7'b0111011,
    // OPC_LEN_64b     = 7'b0111111,
    // OPC_MADD        = 7'b1000011,
    // OPC_MSUB        = 7'b1000111,
    // OPC_NMSUB       = 7'b1001011,
    // OPC_NMADD       = 7'b1001111,
    // OPC_OP_FP       = 7'b1010011,
    // OPC_reserved0   = 7'b1010111,
    // OPC_custom2     = 7'b1011011,
    // OPC_LEN_48b1    = 7'b1011111,
    OPC_BRANCH      = 7'b1100011,
    OPC_JALR        = 7'b1100111,
    // OPC_reserved1   = 7'b1101011,
    OPC_JAL         = 7'b1101111,
    OPC_SYSTEM      = 7'b1110011,
    // OPC_reserved2   = 7'b1110111,
    // OPC_custom3     = 7'b1111011,
    // OPC_LEN_80b     = 7'b1111111,

// Interpretação do campo funct3 para a Unidade Lógica e Aritmética
    ALU_ADD_SUB     = 3'b000,       // (inst[30] & Rtype) ? SUB : ADD;
    ALU_SLL         = 3'b001,
    ALU_SLT         = 3'b010,
    ALU_SLTU        = 3'b011,
    ALU_XOR         = 3'b100,
    ALU_SHIFTR      = 3'b101,       // (inst[30] & Rtype) ? SRA : SRL;
    ALU_OR          = 3'b110,
    ALU_AND         = 3'b111,


// Operações da ULA de Ponto flutuante
    // FALUOP_ = ,
