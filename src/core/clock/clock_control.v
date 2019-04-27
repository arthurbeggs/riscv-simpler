///////////////////////////////////////////////////////////////////////////////
//                    RISC-V SiMPLE - Controle de Clocks                     //
//                                                                           //
//       Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                           BSD 3-Clause License                            //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module clock_control (
    input  clock_100mhz,
    input  pll_locked,
    input  clock_divided,
    input  reset_button,
    input  frequency_mode_button,
    input  clock_mode_button,
    input  manual_clock_button,
    input  hard_breakpoint,
    input  soft_breakpoint,
    input  countdown_timed_up,

    output countdown_reset,
    output reg slow_mode,
    output reg core_clock,
    output reg reset
);

reg  manual_mode;
reg  manual_clock;
reg  selected_clock;

// Sempre que entrar no modo manual, reseta o contador
assign countdown_reset = manual_mode;

initial begin
    slow_mode       <= 1'b1;
    core_clock      <= 1'b0;
    reset           <= 1'b1;
    manual_mode     <= 1'b1;
    manual_clock    <= 1'b0;
    selected_clock  <= 1'b0;
end

always @ (posedge clock_100mhz) begin
    if (~manual_clock_button)       manual_clock <= 1'b1;
    else                            manual_clock <= 1'b0;
end

always @ (posedge clock_100mhz or negedge reset_button) begin
    if (~reset_button)              reset <= 1'b1;
    else                            reset <= 1'b0;
end

always @ (negedge frequency_mode_button or posedge reset) begin
    if (reset)                      slow_mode <= 1'b1;
    else                            slow_mode <= ~slow_mode;
end

always @ (posedge reset or posedge hard_breakpoint or posedge soft_breakpoint
            or posedge countdown_timed_up or negedge clock_mode_button) begin
    if (reset)                      manual_mode <= 1'b1;
    else if (hard_breakpoint)       manual_mode <= 1'b1;
    else if (soft_breakpoint)       manual_mode <= 1'b1;
    else if (countdown_timed_up)    manual_mode <= 1'b1;
    else if (~clock_mode_button)    manual_mode <= ~manual_mode;
end

always @ (posedge clock_100mhz or posedge reset) begin
    if (reset)                      core_clock <= 1'b0;
    else if (pll_locked)            core_clock <= selected_clock;
end

always @ (posedge clock_100mhz or posedge reset) begin
    if (reset)                      selected_clock <= manual_clock;
    case (manual_mode)
        1'b0:                       selected_clock <= clock_divided;
        1'b1:                       selected_clock <= manual_clock;
        default:                    selected_clock <= manual_clock;
    endcase
end

endmodule

