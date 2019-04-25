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
    input  [2:0]  data_format,
    input  [31:0] address,
    input  [31:0] write_data,
    output reg [31:0] data_fetched
);

wire [31:0] fetched;
reg  [31:0] read_pos_fix;
reg  [31:0] write_pos_fix;
reg  [31:0] sign_fix;
reg  [3:0]  translated_byte_enable;
reg         write_allowed;
wire        is_data_memory;

assign is_data_memory = (address >= `DATA_BEGIN) && (address <= `DATA_END);

data_memory data_memory(
    .address    (address[16:2]),
    .byteena    (translated_byte_enable),
    .clock      (clock),
    .data       (write_pos_fix),
    .wren       (write_allowed),
    .q          (fetched)
);

// Ajusta posição do dado a ser escrito
always @ (*) begin
   write_pos_fix = write_data << (4'd8 * address[1:0]);
end

// Cálculo de bytes habilitados
always @ (*) begin
   case (data_format[1:0])
       2'b00:   translated_byte_enable = 4'b0001 << address[1:0];
       2'b01:   translated_byte_enable = 4'b0011 << address[1:0];
       2'b10:   translated_byte_enable = 4'b1111 << address[1:0];
       default: translated_byte_enable = 4'b0000;
   endcase
end

// Ajusta posição do dado lido
always @ (*) begin
   read_pos_fix = fetched >> (4'd8 * address[1:0]);
end

// Extensão de sinal
always @ (*) begin
   if (data_format[2] == 0) begin
       case (data_format[1:0])
           2'b00:   sign_fix = {{24{read_pos_fix[7]}}, read_pos_fix[7:0]};
           2'b01:   sign_fix = {{16{read_pos_fix[15]}}, read_pos_fix[15:0]};
           2'b10:   sign_fix = read_pos_fix[31:0];
           default: sign_fix = 32'b0;
       endcase
   end
   else             sign_fix = read_pos_fix;
end

always @ (*) begin
    if (is_data_memory) begin
        if (read_enable) data_fetched = sign_fix;
        else             data_fetched = 32'b1;
    end
    else                 data_fetched = 32'hzzzzzzzz;
end

// Escreve na borda negativa de clock do processador
always @ (*) begin
   if (~core_clock) write_allowed = ( write_enable ? 1'b1 : 1'b0);
   else             write_allowed = 1'b0;
end

endmodule

