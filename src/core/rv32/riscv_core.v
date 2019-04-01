///////////////////////////////////////////////////////////////////////////////
//                  RISC-V SiMPLE - Soft core RISC-V SiMPLE                  //
//                                                                           //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple        //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module riscv_core (
    input  clock,
    input  reset,

    input  [31:0] data_mem_data_fetched,
    output [31:0] data_mem_address,
    output [31:0] data_mem_write_data,
    output [2:0]  data_mem_width,
    output data_mem_read_enable,
    output data_mem_write_enable,

    output [31:0] inst,
    output [31:0] pc
);


`ifdef UNICICLO
singlecycle_datapath singlecycle_datapath (
    .clock                  (clock),
    .reset                  (reset),
    .data_mem_data_fetched  (data_mem_data_fetched),
    .data_mem_read_enable   (data_mem_read_enable),
    .data_mem_write_enable  (data_mem_write_enable),
    .data_mem_address       (data_mem_address),
    .data_mem_write_data    (data_mem_write_data),
    .data_mem_width         (data_mem_width),
    .inst                   (inst),
    .pc                     (pc)
);
`endif



endmodule

