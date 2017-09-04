////////////////////////////////////////////////////////////////////////////////
//                    RISC-V SiMPLE - Contador de Programa                    //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module program_counter (
    input  clk,
    input  rst,

    input  pc_en,           // Habilita a escita do próximo contador de programa
    input  [31:0] next_pc,  // Entrada do registrador

    output reg [31:0] pc    // Saída do registrador
);


initial begin
    pc <= `INITIAL_PC;       // Constante que define o PC inicial
end

always @ (posedge clk) begin
    // Reseta o contador de programa
    if (rst) begin
        pc <= `INITIAL_PC;
    end

    // Habilta a escrita de PC
    else if (pc_en) begin
        pc <= next_pc;
    end
end

endmodule
