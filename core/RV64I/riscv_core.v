////////////////////////////////////////////////////////////////////////////////
//                  RISC-V SiMPLE - Soft core RISC-V SiMPLE                   //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module riscv_core (
    input  clk,
    input  clk_mem,
    input  rst,

    // Informações de debug
    output [31:0] pc_addr,
    output [31:0] inst_data,
    output [63:0] reg_writeback
    // Fim das informações de debug
);


    `ifdef SINGLECYCLE_DATAPATH


        wire [31:0] pc;
        wire [31:0] inst;

        wire [63:0] data_mem_data_fetched;
        wire [31:0] data_mem_addr;
        wire [63:0] data_mem_write_data;
        wire [2:0]  data_mem_width;
        wire data_mem_read_en;
        wire data_mem_write_en;

        // Informações de debug
        wire [63:0] mem_to_reg_data;

        assign pc_addr          = pc;
        assign inst_data        = inst;
        assign reg_writeback    = mem_to_reg_data;
        // Fim das informações de debug




        datapath_singlecycle datapath_singlecycle(
            .clk(clk),
            .rst(rst),
            .inst(inst),
            .pc(pc),
            .data_mem_data_fetched(data_mem_data_fetched),
            .data_mem_read_en(data_mem_read_en),
            .data_mem_write_en(data_mem_write_en),
            .data_mem_addr(data_mem_addr),
            .data_mem_write_data(data_mem_write_data),
            .data_mem_width(data_mem_width),
            // Informação de debug
            .mem_to_reg_data(mem_to_reg_data)
            // Fim da informação de debug
        );


        data_memory_interface data_memory_interface(
            .clk(clk_mem),
            .read_en(data_mem_read_en),
            .write_en(data_mem_write_en),
            .byte_enable(data_mem_width),
            .address(data_mem_addr),
            .write_data(data_mem_write_data),
            .data_fetched(data_mem_data_fetched)
        );


        text_memory_interface text_memory_interface(
            .clk(clk_mem),
            .read_en(1'b1),
            .write_en(1'b0),
            .address(pc),
            .write_data(32'b0),
            .data_fetched(inst)
        );

    `endif


endmodule // risc_v_core
