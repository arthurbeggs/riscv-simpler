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
    wire [7:0]  translated_byte_enable;
    wire [63:0] fetched;
    wire [63:0] sign_adjusted;


    assign is_data_mem = (address >= `DATA_BEGIN) && (address <= `DATA_END);


    // Instância de RAM da memória de dados (1024 words de 64 bits)
    data_memory data_memory(
    	.address(address[13:3]),
    	.byteena(translated_byte_enable),
    	.clock(clk),
    	.data(write_data),
    	.rden(read_en),
    	.wren(write_acknowledged),
    	.q(fetched)
    );

    always @(*) begin
        if (read_en) begin
            if (is_data_mem)    data_fetched = sign_adjusted;
            else                data_fetched = 64'hzzzzzzzzzzzzzzzz;
        end
        else data_fetched = 64'hzzzzzzzzzzzzzzzz;
    end

    // Cálculo de bytes ativados
    always @(*) begin
        case (byte_enable[1:0])
            2'b00:
                translated_byte_enable = 8'b00000001;
            2'b01:
                translated_byte_enable = 8'b00000011;
            2'b10:
                translated_byte_enable = 8'b00001111;
            2'b11:
                translated_byte_enable = 8'b11111111;
            default:
                translated_byte_enable = 8'b00000000;
        endcase
    end

    // Extensão de sinal
    always @(*) begin
        if (byte_enable[2] == 1) begin
            case (byte_enable[1:0])
                2'b00:
                    sign_adjusted = { {56{fetched[31]}}, fetched };
                2'b01:
                    sign_adjusted = { {32{fetched[31]}}, fetched };
                2'b10:
                    sign_adjusted = { {32{fetched[31]}}, fetched };
                2'b11:
                    sign_adjusted = fetched;
                default:
                    sign_adjusted = 64'b0;
            endcase
        end
        else sign_adjusted = fetched; //TODO: Verificar se posições não lidas de memória são carregadas com 0 ou outro valor;
    end

    always @(*) begin
        if (posedge core_clk) write_acknowledged = ( write_en ? 1'b1 : 1'b0);
        else write_acknowledged = 1'b0;
    end

endmodule
