//////////////////////////////////////////////////////////////////////////
//          Multiplexer Parametrizado criado por jakobjones             //
//   Fonte: https://alteraforum.com/forum/showthread.php?t=22519        //
//                                                                      //
//          Modificado por @arthurbeggs para Verilog-2001               //
//////////////////////////////////////////////////////////////////////////
//                          MODO DE USO                                 //
//                                                                      //
// TODO: Testar se a concatenação funciona no instanciamento            //
// mux #(                                                               //
//     .WIDTH(64),     // Largura da palavra                            //
//     .CHANNELS(2)    // Quantidade de entradas SEMPRE IGUAL a 2^n     //
// ) nome_do_mux (                                                      //
//     .in_bus({in1, in2, ...}),   // Sinais de entrada concatenados    //
//     .sel(sel_signal),           // Sinal de seleção de entrada       //
//     .out(out_signal)            // Sinal de saída                    //
// );                                                                   //
//////////////////////////////////////////////////////////////////////////

module mux #(
    parameter WIDTH    = 64,    // Parâmetros default
    parameter CHANNELS = 2) (

    input   [(CHANNELS*WIDTH)-1:0]  in_bus,
    input   [$clog2(CHANNELS)-1:0]  sel,        // Log base 2 para determinar largura do sinal de seleção

    output  [WIDTH-1:0]             out
);

genvar ig;

wire    [WIDTH-1:0] input_array [0:CHANNELS-1];     // Vetor de palavras de #(WIDTH) bits com #(CHANNELS) posições.

assign  out = input_array[sel];

generate
    for(ig=0; ig<CHANNELS; ig=ig+1) begin: array_assignments
        assign  input_array[ig] = in_bus[(ig*WIDTH)+:WIDTH];    // Seletor indexado: data[offset+:width] == data[(offset+width-1):offset]
    end
endgenerate


endmodule
