///////////////////////////////////////////////////////////////////////////////
//              RISC-V SiMPLE - Testbench do Módulo Top Level                //
//                                                                           //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple        //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

`timescale 1 ns / 1 ns

module fpga_top_tb;

reg clock;
reg [3:0] key;
reg [7:0] switch;

fpga_top dut(
    .CLOCK_50(clock),

`ifdef USE_LEDS
    .LEDR(),
`endif

`ifdef USE_7SEG
    .HEX0(),
    .HEX1(),
    .HEX2(),
    .HEX3(),
    .HEX4(),
    .HEX5(),
`endif

`ifdef USE_VIDEO
    .VGA_B(),
    .VGA_BLANK_N(),
    .VGA_CLK(),
    .VGA_G(),
    .VGA_HS(),
    .VGA_R(),
    .VGA_SYNC_N(),
    .VGA_VS(),
`endif

`ifdef USE_AUDIO
    .AUD_ADCDAT(),
    .AUD_ADCLRCK(),
    .AUD_BCLK(),
    .AUD_DACDAT(),
    .AUD_DACLRCK(),
    .AUD_XCK(),
`endif

`ifdef USE_KEYBOARD
    .PS2_CLK(),
    .PS2_CLK2(),
    .PS2_DAT(),
    .PS2_DAT2(),
`endif

`ifdef DEBUG
`endif

    .KEY(key),
    .SW(switch)
);


initial begin
    clock   <= 1'b0;
    key     <= 4'b1111;
    switch  <= 8'b00000011;
    #40;
    key     <= 4'b1001;
    #40;
    key     <= 4'b1111;
    #40;
    key     <= 4'b1110;
    #200;
    key     <= 4'b1111;
    #40;
    key     <= 4'b1001;
    #40;
    key     <= 4'b1111;
end

always begin
    #10 clock <= ~clock;
end

always begin
    #2000000;
    $finish;
end

endmodule

