// TODO: Cabeçalho

module regfile (
    input  write_enable,
    input  [4:0] write_reg,
    input  [4:0] read_reg1,
    input  [4:0] read_reg2,

    input  [63:0] write_data,
    output [63:0] read_data1,
    output [63:0] read_data2,

    input clk,
    input rst
);

// 32 registradores de 64 bits
reg [63:0] registers [0:31];

// Contador para loop de inicialização de registradores
integer i;

initial begin
    for (i = 0; i <= 31; i = i + 1)
        registers[i] <= 64'b0;
    // NOTE: Inserir registradores com valor inicial != 64'b0
end

assign read_data1 = registers[read_reg1];
assign read_data2 = registers[read_reg2];


always @ ( posedge clk ) begin
    if (rst) begin
        for (i = 0; i <= 31; i = i + 1)
            registers[i] <= 64'b0;
        // NOTE: Inserir registradores com valor inicial != 64'b0
    end
    else if (write_enable)
        if (write_reg != 5'b0)
            registers[write_reg] <= write_data;
end
