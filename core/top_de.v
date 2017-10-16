////////////////////////////////////////////////////////////////////////////////
//                     RISC-V SiMPLE - Módulo Top Level                       //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////

module top_de (

);


    riscv_core riscv_core(
        .clk(),
        .clk_mem(),
        .rst(),

        // Informações de debug
        .pc_addr(),
        .inst_data(),
        .reg_writeback()
        // Fim das informações de debug
    );

endmodule
