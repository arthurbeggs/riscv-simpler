///////////////////////////////////////////////////////////////////////////////
//                    RISC-V SiMPLE - Contador de Parada                     //
//                                                                           //
//       Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                           BSD 3-Clause License                            //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module break_countdown (
    input  clock_50mhz,
    input  countdown_enable,
    input  reset,
    output reg countdown_timed_up
);

integer counter;

initial begin
    counter             <= 0;
    countdown_timed_up  <= 1'b0;
end

always @ (posedge clock_50mhz or posedge reset) begin
    if (reset) begin
        counter             <= 0;
        countdown_timed_up  <= 1'b0;
    end
    else if (countdown_enable) begin
        if (counter >= `TIMEUP_CYCLES) begin
            counter             <= 0;
            countdown_timed_up  <= 1'b1;
        end
        else begin
            counter             <= counter + 1;
            countdown_timed_up  <= 1'b0;
        end
    end
    else begin
        counter             <= 0;
        countdown_timed_up  <= 1'b0;
    end
end

endmodule

