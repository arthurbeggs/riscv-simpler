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

    // Botões e Switches
    input [3:0] KEY,
    // input [9:0] SW
    input [5:0] SW
);

// Clocks e reset
wire reset;
wire core_clock;
wire clock_100mhz;
wire clock_50mhz;
wire clock_25mhz;
wire clock_18mhz;

// Instrução e Program Counter
wire [31:0] inst;
wire [31:0] pc;

// Barramento da memória de dados
wire [31:0] bus_data_fetched;
wire [31:0] bus_address;
wire [31:0] bus_write_data;
wire [2:0]  bus_format;
wire bus_read_enable;
wire bus_write_enable;


assign bus_data_fetched = 32'hzzzzzzzz; // XXX

clock_interface clock_interface (
    .clock_reference        (CLOCK_50),
    .core_clock_divisor     (SW[4:0]),
    .reset_button           (KEY[0]),
    .frequency_mode_button  (KEY[1]),
    .clock_mode_button      (KEY[2]),
    .manual_clock_button    (KEY[3]),
    .countdown_enable       (SW[5]),
    .hard_breakpoint        (1'b0),
    .soft_breakpoint        (1'b0),
    .clock_100mhz           (clock_100mhz),
    .clock_50mhz            (clock_50mhz),
    .clock_25mhz            (clock_25mhz),
    .clock_18mhz            (clock_18mhz),
    .core_clock             (core_clock),
    .reset                  (reset)
);

riscv_core riscv_core (
    .clock                  (core_clock),
    .clock_memory           (clock_100mhz),
    .reset                  (reset),
    .bus_data_fetched       (bus_data_fetched),
    .bus_address            (bus_address),
    .bus_write_data         (bus_write_data),
    .bus_format             (bus_format),
    .bus_read_enable        (bus_read_enable),
    .bus_write_enable       (bus_write_enable),
    .inst                   (inst),
    .pc                     (pc)
);

endmodule

