// TODO: Cabeçalho

module regfile (
    input clk,
    input rst,

    input  write_en,
    input  [4:0] write_reg,
    input  [4:0] read_reg_a,
    input  [4:0] read_reg_b,

    input  [63:0] write_data,
    output [63:0] reg_a_data,
    output [63:0] reg_b_data
);

// 32 registradores de 64 bits
reg [63:0] register [0:31];

// Contador para loop de inicialização de registradores
integer i;

initial begin
    for (i = 0; i <= 31; i = i + 1)
        register[i] <= 64'b0;
    // NOTE: Inserir registradores com valor inicial != 64'b0
end

assign reg_a_data = register[read_reg_a];
assign reg_b_data = register[read_reg_b];


always @ ( posedge clk ) begin
    if (rst) begin
        for (i = 0; i <= 31; i = i + 1)
            register[i] <= 64'b0;
        // NOTE: Inserir registradores com valor inicial != 64'b0
    end
    else if (write_en)
        if (write_reg != 5'b0)
            register[write_reg] <= write_data;
end


endmodule
