// TODO: Cabeçalho;

module control_singlecycle (
    input  [6:0] inst_opcode,

    output pc_write_enable,         // Habilita escrita de PC
    output jal_enable,
    output jalr_enable,
    output branch_enable,
    output data_mem_read_enable,    // NOTE: Read enable é necessário?
    output data_mem_write_enable,   // Habilita escrita na memória de dados
    output regfile_write_enable,    // Habilita escrita no regfile
    output [1:0] mem_to_reg_sel,    // Seleciona a entrada de escrita do regfile
    output [1:0] alu_op,            // Seleciona a funcionalidade da ALU
    output [1:0] alu_sel_src_a,     // Seleciona a entrada A da ALU
    output alu_sel_src_b            // Seleciona a entrada B da ALU
);

reg  [13:0] control_signals;

assign pc_write_enable          = control_signals[13];
assign jal_enable               = control_signals[12];
assign jalr_enable              = control_signals[11];
assign branch_enable            = control_signals[10];
assign data_mem_read_enable     = control_signals[9];
assign data_mem_write_enable    = control_signals[8];
assign regfile_write_enable     = control_signals[7];
assign mem_to_reg_sel           = control_signals[6:5];
assign alu_op                   = control_signals[4:3];
assign alu_sel_src_a            = control_signals[2:1];     // rs1 || pc || 64'b0 || XXXX
assign alu_sel_src_b            = control_signals[0];


// NOTE: A estratégia de código compacto é uma boa ideia?

initial begin
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //                                                                                                        //
            //                                             data_mem_write_enable                                      //
            //                                                       |                                                //
            //                                 data_mem_read_enable  |  regfile_write_enable                          //
            //                                                |      |      |                                         //
            //                                 branch_enable  |      |      |   mem_to_reg_sel                        //
            //                                         |      |      |      |       |                                 //
            //                           jalr_enable   |      |      |      |       |    alu_op                       //
            //                                  |      |      |      |      |       |       |                         //
            //                      jal_enable  |      |      |      |      |       |       |   alu_sel_src_a         //
            //                           |      |      |      |      |      |       |       |       |                 //
            //         pc_write_enable   |      |      |      |      |      |       |       |       |   alu_sel_src_b //
            //                    |      |      |      |      |      |      |       |       |       |      |          //
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 2'b00 , 2'b00 , 2'b00 , 1'b0 };
end

always @ ( * ) begin
    case (inst_opcode)
        `OPC_LOAD:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b1 , 2'b01 , 2'b00 , 2'b00 , 1'b1 };
        // `OPC_LOAD_FP:
        // `OPC_custom0:
        // `OPC_MISC_MEM:
        `OPC_OP_IMM:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b10 , 2'b00 , 1'b1 };
        `OPC_AUIPC:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b00 , 2'b01 , 1'b1 };
        `OPC_OP_IMM_32:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b10 , 2'b00 , 1'b1 };
        // `OPC_LEN_48b0:
        `OPC_STORE:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 2'b00 , 2'b00 , 2'b00 , 1'b1 };
        // `OPC_STORE_FP:
        // `OPC_custom1:
        // `OPC_AMO:
        `OPC_OP:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b10 , 2'b00 , 1'b0 };
        `OPC_LUI:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b00 , 2'b10 , 1'b1 };
        `OPC_OP_32:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b10 , 2'b00 , 1'b0 };
        // `OPC_LEN_64b:
        // `OPC_MADD:
        // `OPC_MSUB:
        // `OPC_NMSUB:
        // `OPC_NMADD:
        // `OPC_OP_FP:
        // `OPC_reserved0:
        // `OPC_custom2:
        // `OPC_LEN_48b1:
        `OPC_BRANCH:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b0 , 1'b0 , 2'b00 , 2'b11 , 2'b00 , 1'b0 };
        `OPC_JALR:
            control_signals = { 1'b1 , 1'b0 , 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b00 , 2'b00 , 1'b1 };
        // `OPC_reserved1:
        `OPC_JAL:
            control_signals = { 1'b1 , 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 2'b00 , 2'b00 , 2'b01 , 1'b1 };
        // `OPC_SYSTEM:
        // `OPC_reserved2:
        // `OPC_custom3:
        // `OPC_LEN_80b:

        default:
            control_signals = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 2'b00 , 2'b00 , 2'b00 , 1'b0 };

    endcase
end


endmodule
