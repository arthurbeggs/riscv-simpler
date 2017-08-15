////////////////////////////////////////////////////////////////////////////////
//                    RISC-V SiMPLE - Controle do Uniciclo                    //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  Desabilite o "soft-wrapping" de seu editor para visualizar corretamente!  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


module control_singlecycle (
    input  [6:0] inst_opcode,

    output pc_write_en,             // Habilita escrita de PC
    output jal_en,                  // JAL
    output jalr_en,                 // JALR
    output branch_en,               // Branching
    output data_mem_read_en,        // Habilita leitura da memória de dados
    output data_mem_write_en,       // Habilita escrita na memória de dados
    output regfile_write_en,        // Habilita escrita no regfile
    output [2:0] mem_to_reg_sel,    // Seleciona a entrada de escrita do regfile
    output [1:0] alu_op,            // Seleciona a funcionalidade da ULA
    output alu_src_a_sel,           // Seleciona a entrada A da ULA
    output alu_src_b_sel            // Seleciona a entrada B da ULA
);

reg  [13:0] control;

assign pc_write_en          = control[13];
assign jal_en               = control[12];
assign jalr_en              = control[11];
assign branch_en            = control[10];
assign data_mem_read_en     = control[9];
assign data_mem_write_en    = control[8];
assign regfile_write_en     = control[7];
assign mem_to_reg_sel       = control[6:4]; // ALU || MEM || OP-32 || LUI|| pc+4
assign alu_op               = control[3:2]; // ADD || SUB || OP || Branch
assign alu_src_a_sel        = control[1];   // rs1_data || pc
assign alu_src_b_sel        = control[0];   // rs2_data || immediate


// Define valores iniciais dos sinais de controle
initial begin
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        //                                                                                                    //
        //                                            data_mem_write_en                                       //
        //                                                   |                                                //
        //                                data_mem_read_en   |  regfile_write_en                              //
        //                                            |      |      |                                         //
        //                                 branch_en  |      |      |   mem_to_reg_sel                        //
        //                                     |      |      |      |       |                                 //
        //                           jalr_en   |      |      |      |       |    alu_op                       //
        //                              |      |      |      |      |       |       |                         //
        //                    jal_en    |      |      |      |      |       |       |   alu_sel_src_a         //
        //                       |      |      |      |      |      |       |       |      |                  //
        //         pc_write_en   |      |      |      |      |      |       |       |      |   alu_sel_src_b  //
        //                |      |      |      |      |      |      |       |       |      |      |           //
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 3'b000 , 2'b00 , 1'b0 , 1'b0 };
end

// Gera os sinais de controle de acordo com o opcode da instrução atual
always @ ( * ) begin
    case (inst_opcode)
        `OPC_LOAD:
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b1 , 3'b001 , 2'b00 , 1'b0 , 1'b1 };

        // `OPC_LOAD_FP:
        // `OPC_custom0:
        // `OPC_MISC_MEM:
        `OPC_OP_IMM:
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 3'b000 , 2'b10 , 1'b0 , 1'b1 };

        `OPC_AUIPC:
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 3'b000 , 2'b00 , 1'b1 , 1'b1 };

        `OPC_OP_IMM_32:
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 3'b010 , 2'b10 , 1'b0 , 1'b1 };

        // `OPC_LEN_48b0:
        `OPC_STORE:
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 3'b000 , 2'b00 , 1'b0 , 1'b1 };

        // `OPC_STORE_FP:
        // `OPC_custom1:
        // `OPC_AMO:
        `OPC_OP:
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 3'b000 , 2'b10 , 1'b0 , 1'b0 };

        `OPC_LUI:
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 3'b011 , 2'b00 , 1'b0 , 1'b0 };

        `OPC_OP_32:
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 3'b010 , 2'b10 , 1'b0 , 1'b0 };

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
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b1 , 1'b0 , 1'b0 , 1'b0 , 3'b000 , 2'b11 , 1'b0 , 1'b0 };

        `OPC_JALR:
            control = { 1'b1 , 1'b0 , 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 3'b100 , 2'b00 , 1'b0 , 1'b1 };

        // `OPC_reserved1:
        `OPC_JAL:
            control = { 1'b1 , 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b1 , 3'b100 , 2'b00 , 1'b1 , 1'b1 };

        // `OPC_SYSTEM:
        // `OPC_reserved2:
        // `OPC_custom3:
        // `OPC_LEN_80b:

        default:
            control = { 1'b1 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 1'b0 , 3'b000 , 2'b00 , 1'b0 , 1'b0 };

    endcase
end


endmodule
