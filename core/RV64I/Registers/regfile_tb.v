////////////////////////////////////////////////////////////////////////////////
//             RISC-V SiMPLE - TestBench - Banco de Registradores             //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps


module regfile_tb;

reg  clk;
reg  rst;
reg  write_en;
reg  [4:0]  rd_addr;
reg  [4:0]  rs1_addr;
reg  [4:0]  rs2_addr;
reg  [63:0] rd_data;
wire [63:0] rs1_data;
wire [63:0] rs2_data;


regfile dut(
    .clk(clk),
    .rst(rst),
    .write_en(write_en),
    .rd_addr(rd_addr),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_data(rd_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);


// Eventos
event rst_en;
event rst_dn;
event sim_dn;


initial
    begin: initial_values
        // Inicialização de drivers
        clk   = 0;
        rst   = 0;
        write_en = 0;
        rd_addr  = 5'b0;
        rs1_addr = 5'b0;
        rs2_addr = 5'b0;
        rd_data  = 63'b0;

        // Monitoramento de I/O
        $display("#####################################");
        $display("\t\t\t\t   Time clk rst write_en rd_addr rs1_addr rs2_addr rd_data rs1_data rs2_data");
        $monitor("%d \t %b \t %b \t %b \t %d \t %d \t %d \t %h \t %h \t %h", $time, clk, rst, write_en, rd_addr, rs1_addr, rs2_addr, rd_data, rs1_data, rs2_data);
    end


// Clock de 50 MHz
always #10 clk = !clk;


// Ciclo de reinicialização
initial
    forever begin: reset
        @ (rst_en);
        @ (negedge clk);
        $display("\t\t\t\t # Reset asserted!");
        rst = 1'b1;

        repeat(4) begin
            @ (negedge clk);
        end

        $display("\t\t\t\t # Reset de-asserted!");
        rst = 1'b0;
        -> rst_dn;
    end


// Encerra a simulação
initial
    @ (sim_dn) begin: simulation_done
        #5 $finish;
    end


// Teste
initial
    begin: test_case
        // Reset inicial com escrita desabilitada
        #10 -> rst_en;
        @ (rst_dn);
        write_en = 1'b1;



        // Finalização do teste
        #10 -> sim_dn;
    end

endmodule
