///////////////////////////////////////////////////////////////////////////////
//               RISC-V SiMPLE - Interface da Memória de Dados               //
//                                                                           //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple        //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

module data_memory_interface (
    input  clock,
    input  core_clock,
    input  read_enable,
    input  write_enable,
    input  [2:0] inst_funct3,
    input  [31:0] address,
    output reg [31:0] data_fetched
);

wire [31:0] fetched;
reg  [31:0] position_fix;
reg  [31:0] sign_fix;
reg  [3:0]  translated_byte_enable;
reg         write_acknowledged;

data_memory data_memory(
    .address    (address[15:2]),
    .byteena    (translated_byte_enable),
    .clock      (clock),
    .data       (fetched),
    .rden       (read_enable),
    .wren       (write_acknowledged),
    .q          (fetched)
);

// Cálculo de bytes habilitados
always @(*) begin
   translated_byte_enable = 4'b0000;
   case (inst_funct3[1:0])
       2'b00: translated_byte_enable = 4'b0001 << address[1:0];
       2'b01: translated_byte_enable = 4'b0011 << address[1:0];
       2'b10: translated_byte_enable = 4'b1111 << address[1:0];
   endcase
end

// Ajusta posição do dado lido
always @(*) begin
   position_fix = fetched >> address[1:0];
end

// Extensão de sinal
always @(*) begin
   if (inst_funct3[2] == 0) begin
       sign_fix = 32'b0;
       case (inst_funct3[1:0])
           2'b00: sign_fix = {{22{position_fix[31]}}, position_fix[7:0]};
           2'b01: sign_fix = {{16{position_fix[31]}}, position_fix[15:0]};
           2'b10: sign_fix = position_fix[31:0];
       endcase
   end
   else sign_fix = position_fix;
end

always @ (*) begin
    if ((address >= `DATA_BEGIN) && (address <= `DATA_END))
        data_fetched = fetched;
    else
        data_fetched = 32'hzzzzzzzz;
end

// Escreve na borda negativa de clock do processador
// NOTE: Baseado na estimativa de que o endereço de escrita terá sido calculado
//       após 1/2 ciclo de clock do processador. precisa ser verificado.
always @(*) begin
   if (~core_clock) write_acknowledged = ( write_enable ? 1'b1 : 1'b0);
   else             write_acknowledged = 1'b0;
end

endmodule

