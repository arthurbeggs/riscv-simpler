// TODO: Fazer cabeçalho

module adder #(
    parameter WIDTH = 32 ) (

    input [WIDTH-1:0] operand_a,
    input [WIDTH-1:0] operand_b,

    output reg [WIDTH-1:0] result
);

always @ ( * ) begin
    result = operand_a + operand_b;
end


endmodule
