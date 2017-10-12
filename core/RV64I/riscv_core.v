////////////////////////////////////////////////////////////////////////////////
//                  RISC-V SiMPLE - Soft core RISC-V SiMPLE                   //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module riscv_core (
    // Avalon clock

    // Avalon Reset

    // Avalon-MM

    // Avalon Conduit (7seg display)

);


`ifdef SINGLECYCLE_DATAPATH

    // datapath_singlecycle datapath_singlecycle(
    //     .clk(),
    //     .rst(),
    //     .inst(),
    //     .pc(),
    //     .data_mem_data_fetched(),
    //     .data_mem_read_en(),
    //     .data_mem_write_en(),
    //     .data_mem_addr(),
    //     .data_mem_write_data(),
    //     .data_mem_width()
    // );

`endif


endmodule // risc_v_core
