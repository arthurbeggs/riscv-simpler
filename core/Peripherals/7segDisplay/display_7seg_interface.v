////////////////////////////////////////////////////////////////////////////////
//           RISC-V SiMPLE - Interface dos Displays de 7 Segmentos            //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module display_7seg_interface (
    input [31:0] data,

    // Displays de 7 Segmentos
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5,
    output [6:0] HEX6,
    output [6:0] HEX7

    // Pontos dos displays não são habilitados na DE2-115
    // output HEX0_DP,
    // output HEX1_DP,
    // output HEX2_DP,
    // output HEX3_DP,
    // output HEX4_DP,
    // output HEX5_DP,
    // output HEX6_DP,
    // output HEX7_DP
);

    // assign HEX0_DP=1'b1;
    // assign HEX1_DP=1'b1;
    // assign HEX2_DP=1'b1;
    // assign HEX3_DP=1'b1;
    // assign HEX4_DP=1'b1;
    // assign HEX5_DP=1'b1;
    // assign HEX6_DP=1'b1;
    // assign HEX7_DP=1'b1;

    decoder_7seg decoder_7seg_0 (
        .In(data[3:0]),
        .Out(HEX0)
    );

    decoder_7seg decoder_7seg_1 (
        .In(data[7:4]),
        .Out(HEX1)
    );

    decoder_7seg decoder_7seg_2 (
        .In(data[11:8]),
        .Out(HEX2)
    );

    decoder_7seg decoder_7seg_3 (
        .In(data[15:12]),
        .Out(HEX3)
    );

    decoder_7seg decoder_7seg_4 (
        .In(data[19:16]),
        .Out(HEX4)
    );

    decoder_7seg decoder_7seg_5 (
        .In(data[23:20]),
        .Out(HEX5)
    );

    decoder_7seg decoder_7seg_6 (
        .In(data[27:24]),
        .Out(HEX6)
    );

    decoder_7seg decoder_7seg_7 (
        .In(data[31:28]),
        .Out(HEX7)
    );

endmodule
