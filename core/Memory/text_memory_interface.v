////////////////////////////////////////////////////////////////////////////////
//               RISC-V SiMPLE - Interface da Memória de Texto                //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////

module text_memory_interface (
    input  clk,

    input  read_en,
    input  write_en,

    input  [31:0] address,
    input  [31:0] write_data,
    output reg [31:0] data_fetched
);

    wire        is_text_mem;
    wire [31:0] fetched;


    assign is_text_mem = (address >= `TEXT_BEGIN) && (address <= `TEXT_END);


    // Instância de RAM da memória de texto (1024 words de 32 bits)
    text_memory text_memory(
        .address(address[11:2]),
        .clock(clk),
        .data(write_data),
        .rden(read_en),
        .wren(write_en),
        .q(fetched)
    );


    always @(*) begin
        if (read_en) begin
            if (is_text_mem)    data_fetched = fetched;
            else                data_fetched = 32'hzzzzzzzz;
        end
        else data_fetched = 32'hzzzzzzzz;
    end


endmodule
