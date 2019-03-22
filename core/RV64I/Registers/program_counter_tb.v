////////////////////////////////////////////////////////////////////////////////
//              RISC-V SiMPLE - TestBench - Contador de Programa              //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps


module program_counter_tb;

reg  clk;
reg  rst;
reg  pc_en;
reg  [31:0] next_pc;
wire [31:0] pc;


program_counter dut(
    .clk(clk),
    .rst(rst),
    .pc_en(pc_en),
    .next_pc(next_pc),
    .pc(pc)
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
        pc_en = 0;
        next_pc = 32'h00000000;

        // Monitoramento de I/O
        $display("################################");
        $display("\t\t\t\t   Time  clk\trst\tpc_en \t pc \t\t next_pc");
        $monitor("%d \t %b \t %b \t %b \t %h \t %h", $time, clk, rst, pc_en, pc, next_pc);
    end


// Clock de 50 MHz
always #10 clk = !clk;

// Incrementa o próximo PC após 17 ns
always @ (posedge clk) #17 next_pc = next_pc + 32'h00000004;


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
        pc_en = 1'b1;

        // Teste de ncremento de PC
        #80
        @ (negedge clk)
        pc_en = 1'b0;

        // Teste de escrita desabilitada
        #80
        @ (negedge clk)
        pc_en = 1'b1;

        // Teste de reset com escrita habilitada
        #80 -> rst_en;
        @ (rst_dn);

        // Finalização do teste
        #80 -> sim_dn;
    end

endmodule
