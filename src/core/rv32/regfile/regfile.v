///////////////////////////////////////////////////////////////////////////////
//                   RISC-V SiMPLE - Banco de Registradores                  //
//                                                                           //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple        //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module regfile (
    input  clock,
    input  reset,
    input  write_enable,        // Habilita a escrita no banco de registradores
    input  [4:0] rd_address,    // Endereço do registrador rd
    input  [4:0] rs1_address,   // Endereço do registrador rs1
    input  [4:0] rs2_address,   // Endereço do registrador rs2
    input  [31:0] rd_data,      // Dado a ser gravado no registrador rd
    output [31:0] rs1_data,     // Dado lido do registrador rs1
    output [31:0] rs2_data      // Dado lido do registrador rs2
);

// 32 registradores de 32 bits
reg [31:0] register [0:31];

// Contador para loop de inicialização de registradores
integer i;

// Inicia os registradores
initial begin
    for (i = 0; i <= 31; i = i + 1)
        register[i] <= 64'b0;
    // TODO: Inserir registradores com valor inicial != 64'b0
end

// Lê os dados dos registradores rs1 e rs2
assign rs1_data = register[rs1_address];
assign rs2_data = register[rs2_address];

// Grava novos valores no banco de registradores
always @ (posedge clock or posedge reset) begin
    // Reseta os registradores
    if (reset) begin
        for (i = 0; i <= 31; i = i + 1)
            register[i] <= 64'b0;
        // TODO: Inserir registradores com valor inicial != 64'b0
    end

    else if (write_enable)
        if (rd_address != 5'b0)
            register[rd_address] <= rd_data;
end

endmodule

