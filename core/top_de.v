////////////////////////////////////////////////////////////////////////////////
//                     RISC-V SiMPLE - Módulo Top Level                       //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////

module top_de (
    // Osciladores
    input  iCLK_50,

    // Switches
    input  [17:14] iSW,

    // Displays de 7 Segmentos
    output [6:0] HEX0_D,
    output [6:0] HEX1_D,
    output [6:0] HEX2_D,
    output [6:0] HEX3_D,
    output [6:0] HEX4_D,
    output [6:0] HEX5_D,
    output [6:0] HEX6_D,
    output [6:0] HEX7_D,

    // Pontos dos displays
    output HEX0_DP,
    output HEX1_DP,
    output HEX2_DP,
    output HEX3_DP,
    output HEX4_DP,
    output HEX5_DP,
    output HEX6_DP,
    output HEX7_DP
);

    // Informações de debug
    wire [32:0] debug_data;
    wire [32:0] pc_addr;
    wire [32:0] inst_data;
    wire [63:0] reg_writeback;
    // Fim das informações de debug

    riscv_core riscv_core (
        .clk(iSW[15]),      //FIXME: Sinais temporários
        .clk_mem(iCLK_50),  //FIXME: Sinais temporários
        .rst(iSW[14]),      //FIXME: Sinais temporários

        // Informações de debug
        .pc_addr(pc_addr),
        .inst_data(inst_data),
        .reg_writeback(reg_writeback)
        // Fim das informações de debug
    );


    //TODO: Interface de Clock



    display_7seg_interface display_7seg_interface (
        .data(debug_data),
        .HEX0_D(HEX0_D),
        .HEX1_D(HEX1_D),
        .HEX2_D(HEX2_D),
        .HEX3_D(HEX3_D),
        .HEX4_D(HEX4_D),
        .HEX5_D(HEX5_D),
        .HEX6_D(HEX6_D),
        .HEX7_D(HEX7_D),
        .HEX0_DP(HEX0_DP),
        .HEX1_DP(HEX1_DP),
        .HEX2_DP(HEX2_DP),
        .HEX3_DP(HEX3_DP),
        .HEX4_DP(HEX4_DP),
        .EX5_DP(EX5_DP),
        .HEX6_DP(HEX6_DP),
        .HEX7_DP(HEX7_D)
    );


    // Define dado de debug a ser mostrado nos displays de 7 segmentos
    //FIXME: Colocar dentro do display_7seg_interface
    always @(*) begin
        case (iSW[17:16])
            2'b00: debug_data = pc_addr;
            2'b01: debug_data = inst_data;
            2'b10: debug_data = reg_writeback[31:0];
            2'b11: debug_data = reg_writeback[63:32];
        endcase
    end

endmodule
