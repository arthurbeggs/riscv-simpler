///////////////////////////////////////////////////////////////////////////////
//                         RISC-V SiMPLE - Controle da ULA                   //
//                                                                           //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple        //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module alu_control (
    input  [1:0] alu_op_type,
    input  [2:0] inst_funct3,
    output reg [4:0] alu_function
);

wire [4:0] default_funct;
wire [4:0] secondary_funct;
wire [4:0] branch_funct;
`ifdef M_MODULE
    wire [4:0] m_extension_funct;
`endif

always @ (*) begin
    alu_function = `ALU_ZERO;
    case (alu_op_type)
        2'b00:  alu_function = default_funct;
        2'b01:  alu_function = secondary_funct;
        2'b10:  alu_function = branch_funct;
`ifdef M_MODULE
        2'b11:  alu_function = m_extension_funct;
`endif
    endcase
end

always @ (*) begin
    default_funct = `ALU_ZERO;
    case (funct3)
        FUNCT3_ALU_ADD_SUB: default_funct = `ALU_ADD;
        FUNCT3_ALU_SLL:     default_funct = `ALU_SLL;
        FUNCT3_ALU_SLT:     default_funct = `ALU_SLT;
        FUNCT3_ALU_SLTU:    default_funct = `ALU_SLTU;
        FUNCT3_ALU_XOR:     default_funct = `ALU_XOR;
        FUNCT3_ALU_SHIFTR:  default_funct = `ALU_SRL;
        FUNCT3_ALU_OR:      default_funct = `ALU_OR;
        FUNCT3_ALU_AND:     default_funct = `ALU_AND;
    endcase
end

always @ (*) begin
    secondary_funct = `ALU_ZERO;
    case (funct3)
        FUNCT3_ALU_ADD_SUB: secondary_funct = `ALU_SUB;
        FUNCT3_ALU_SHIFTR:  secondary_funct = `ALU_SRA;
    endcase
end

always @ (*) begin
    branch_funct = `ALU_ZERO;
    case (funct3)
        FUNCT3_BRANCH_EQ:   branch_funct = `ALU_SUB;
        FUNCT3_BRANCH_NE:   branch_funct = `ALU_SUB;
        FUNCT3_BRANCH_LT:   branch_funct = `ALU_SLT;
        FUNCT3_BRANCH_GE:   branch_funct = `ALU_SLT;
        FUNCT3_BRANCH_LTU:  branch_funct = `ALU_SLTU;
        FUNCT3_BRANCH_GEU:  branch_funct = `ALU_SLTU;
    endcase
end

`ifdef M_MODULE
    always @ (*) begin
        m_extension_funct = `ALU_ZERO;
        case (funct3)
            FUNCT3_ALU_MUL:     m_extension_funct = `ALU_MUL;
            FUNCT3_ALU_MULH:    m_extension_funct = `ALU_MULH;
            FUNCT3_ALU_MULHSU:  m_extension_funct = `ALU_MULHSU;
            FUNCT3_ALU_MULHU:   m_extension_funct = `ALU_MULHU;
            FUNCT3_ALU_DIV:     m_extension_funct = `ALU_DIV;
            FUNCT3_ALU_DIVU:    m_extension_funct = `ALU_DIVU;
            FUNCT3_ALU_REM:     m_extension_funct = `ALU_REM;
            FUNCT3_ALU_REMU:    m_extension_funct = `ALU_REMU;
        endcase
    end
`endif

endmodule

