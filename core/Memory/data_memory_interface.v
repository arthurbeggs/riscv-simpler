////////////////////////////////////////////////////////////////////////////////
//               RISC-V SiMPLE - Interface da Memória de Dados                //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module data_memory_interface (
    input  clk,
    input  core_clk,

    input  read_en,
    input  write_en,
    input  [2:0]  byte_enable,

    input  [31:0] address,
    input  [63:0] write_data,
    output reg [63:0] data_fetched
);

    reg         write_acknowledged;
    wire        is_data_mem;
    reg  [15:0] translated_byte_enable;
    wire [63:0] fetched;
    reg  [63:0] position_fix;
    reg  [63:0] sign_fix;


    // Define intervalo da memória de dados.
    assign is_data_mem = (address >= `DATA_BEGIN) && (address <= `DATA_END);


    // Instância de RAM da memória de dados (1024 words de 64 bits)
    data_memory data_memory(
        .address(address[12:3]),
        .byteena(translated_byte_enable[7:0]),
        .clock(clk),
        .data(write_data),
        .rden(read_en),
        .wren(write_acknowledged),
        .q(fetched)
    );


    always @(*) begin
        if (read_en) begin
            if (is_data_mem)    data_fetched = sign_fix;
            else                data_fetched = 64'hzzzzzzzzzzzzzzzz;
        end
        else data_fetched = 64'hzzzzzzzzzzzzzzzz;
    end


    // Cálculo de bytes ativados
    //NOTE: Bits [15:8] servirão para leitura desalinhada.
    always @(*) begin
        case (byte_enable[1:0])
            2'b00:
                translated_byte_enable = 16'b0000000000000001 << address[2:0];
            2'b01:
                translated_byte_enable = 16'b0000000000000011 << address[2:0];
            2'b10:
                translated_byte_enable = 16'b0000000000001111 << address[2:0];
            2'b11:
                translated_byte_enable = 16'b0000000011111111 << address[2:0];
            default:
                translated_byte_enable = 16'b0000000000000000;
        endcase
    end


    // Ajusta posição do dado lido
    always @(*) begin
        position_fix = fetched >> address[2:0];
    end


    // Extensão de sinal
    always @(*) begin
        if (byte_enable[2] == 1) begin
            case (byte_enable[1:0])
                2'b00:  // Byte
                    sign_fix = { {56{position_fix[31]}}, position_fix[7:0] };
                2'b01:  // Half-word
                    sign_fix = { {48{position_fix[31]}}, position_fix[15:0] };
                2'b10:  // Word
                    sign_fix = { {32{position_fix[31]}}, position_fix[31:0] };
                2'b11:  // Double Word
                    sign_fix = position_fix;
                default:
                    sign_fix = 64'b0;
            endcase
        end
        else sign_fix = position_fix; //TODO: Verificar se posições não lidas de memória são carregadas com 0 ou outro valor. Se não forem, preencher com zeros.
    end

    // Escreve na borda negativa de clock do processador;
    //NOTE: Baseado na estimativa de que o endereço de escrita terá sido calculado após 1/2 ciclo de clock do processador. precisa ser verificado.
    always @(*) begin
        if (~core_clk) write_acknowledged = ( write_en ? 1'b1 : 1'b0);
        else write_acknowledged = 1'b0;
    end


endmodule
