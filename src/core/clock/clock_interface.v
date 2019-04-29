///////////////////////////////////////////////////////////////////////////////
//                    RISC-V SiMPLE - Interface de Clocks                    //
//                                                                           //
//       Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                           BSD 3-Clause License                            //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module clock_interface (
    input  clock_reference,
    input  [4:0] core_clock_divisor,
    input  reset_button,
    input  frequency_mode_button,
    input  clock_mode_button,
    input  manual_clock_button,
    input  countdown_enable,
    input  hard_breakpoint,
    input  soft_breakpoint,

    output clock_100mhz,
    output clock_50mhz,
    output clock_25mhz,
    output clock_18mhz,
    output core_clock,
    output reset
);

wire clock_divided;
wire countdown_timed_up;
wire pll_locked;
wire countdown_reset;
wire slow_mode;

clock_control clock_control (
    .clock_100mhz           (clock_100mhz),
    .pll_locked             (pll_locked),
    .clock_divided          (clock_divided),
    .reset_button           (reset_button),
    .frequency_mode_button  (frequency_mode_button),
    .clock_mode_button      (clock_mode_button),
    .manual_clock_button    (manual_clock_button),
    .hard_breakpoint        (hard_breakpoint),
    .soft_breakpoint        (soft_breakpoint),
    .countdown_timed_up     (countdown_timed_up),
    .slow_mode              (slow_mode),
    .countdown_reset        (countdown_reset),
    .core_clock             (core_clock),
    .reset                  (reset)
);

clock_divider clock_divider (
    .clock_100mhz   (clock_100mhz),
    .reset          (reset),
    .clock_divisor  (core_clock_divisor),
    .slow_mode      (slow_mode),
    .clock_divided  (clock_divided)
);

break_countdown break_countdown (
    .clock_50mhz            (clock_50mhz),
    .countdown_enable       (countdown_enable),
    .reset                  (countdown_reset),
    .countdown_timed_up     (countdown_timed_up)
);

`ifdef DE2_115
pll pll (
    .inclk0         (clock_reference),
    .c0             (clock_100mhz),
    .c1             (clock_50mhz),
    .c2             (clock_25mhz),
    .c3             (clock_18mhz),
    .locked         (pll_locked)
);
`endif
`ifdef DE1_SOC
pll pll (
    .refclk         (clock_reference),
    .rst            (1'b0),
    .outclk_0       (clock_100mhz),
    .outclk_1       (clock_50mhz),
    .outclk_2       (clock_25mhz),
    .outclk_3       (clock_18mhz),
    .locked         (pll_locked)
);
`endif

endmodule

