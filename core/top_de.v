////////////////////////////////////////////////////////////////////////////////
//                     RISC-V SiMPLE - Módulo Top Level                       //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////

module top_de (
    // Osciladores
    // input  CLOCK_50,

    // Switches
    input  [17:15] SW,
    input  [1:0]   KEY,

    // Displays de 7 Segmentos
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5,
    output [6:0] HEX6,
    output [6:0] HEX7

);

    // Informações de debug
    reg  [31:0] debug_data;
    wire [31:0] pc_addr;
    wire [31:0] inst_data;
    wire [63:0] reg_writeback;
    // Fim das informações de debug

    riscv_core riscv_core (
        .clk(KEY[1]),       //FIXME: Sinais temporários
        .clk_mem(KEY[0]),   //FIXME: Sinais temporários
        .rst(SW[15]),       //FIXME: Sinais temporários

        // Informações de debug
        .pc_addr(pc_addr),
        .inst_data(inst_data),
        .reg_writeback(reg_writeback)
        // Fim das informações de debug
    );


    //TODO: Interface de Clock



    display_7seg_interface display_7seg_interface (
        .data(debug_data),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .HEX6(HEX6),
        .HEX7(HEX7)
    );


    // Define dado de debug a ser mostrado nos displays de 7 segmentos
    //FIXME: Colocar dentro do display_7seg_interface
    always @(*) begin
        case (SW[17:16])
            2'b00: debug_data = pc_addr;
            2'b01: debug_data = inst_data;
            2'b10: debug_data = reg_writeback[31:0];
            2'b11: debug_data = reg_writeback[63:32];
        endcase
    end

endmodule
