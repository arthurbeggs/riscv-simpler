///////////////////////////////////////////////////////////////////////////////
//                     RISC-V SiMPLE - Módulo Top Level                      //
//                                                                           //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple        //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module fpga_top (
    // Osciladores
    input       CLOCK_50,
    input       CLOCK2_50,

    // Botões e Switches
    input [3:0] KEY,
    input [9:0] SW,

    `ifdef USE_LEDS
        output [9:0]    LEDR,
    `endif

    `ifdef USE_7SEG
        output [6:0]    HEX0,
        output [6:0]    HEX1,
        output [6:0]    HEX2,
        output [6:0]    HEX3,
        output [6:0]    HEX4,
        output [6:0]    HEX5,
    `endif

    `ifdef USE_VIDEO
        output [7:0]    VGA_B,
        output          VGA_BLANK_N,
        output          VGA_CLK,
        output [7:0]    VGA_G,
        output          VGA_HS,
        output [7:0]    VGA_R,
        output          VGA_SYNC_N,
        output          VGA_VS,
    `endif

    `ifdef USE_AUDIO
        input   AUD_ADCDAT,
        inout   AUD_ADCLRCK,
        inout   AUD_BCLK,
        output  AUD_DACDAT,
        inout   AUD_DACLRCK,
        output  AUD_XCK,
    `endif

    `ifdef USE_KEYBOARD
        inout   PS2_CLK,
        inout   PS2_CLK2,
        inout   PS2_DAT,
        inout   PS2_DAT2,
    `endif


    `ifdef DEBUG
    `endif

);

