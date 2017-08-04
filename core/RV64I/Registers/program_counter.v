// TODO: Fazer cabeçalho;

module program_counter (
    input  clk,
    input  rst,
    
    input  pc_en,
    input  [31:0] next_pc,

    output reg [31:0] pc
);

initial begin
    pc = `INITIAL_PC;
end

always @ (posedge clk) begin
    if (rst) begin
        pc = `INITIAL_PC;
    end

    else if (pc_en) begin       // Habilta a escrita de PC
        pc = next_pc;
    end
end

endmodule
