////////////////////////////////////////////////////////////////////////////////
//      RISC-V SiMPLE - TestBench - Unidade Lógica Aritmética de 32 bits      //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps


module alu32_tb;

reg  [3:0]  alu_funct;
reg  [31:0] operand_a;
reg  [31:0] operand_b;
wire [63:0] result;


alu32 dut(
    .alu_funct(alu_funct),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .result(result)
);


// Eventos
event sim_dn;
event evaluate;
event error;


initial
    begin: initial_values
        // Inicialização de drivers


        // Monitoramento de I/O
        $display("##############################################");
        $display("\t\t  Time alu_funct operand_a operand_b result");
        $monitor("%d \t %b \t %b \t %b \t %b", $time, alu_funct, operand_a, operand_b, result);
    end


// Encerra a simulação
initial
    @ (sim_dn) begin: simulation_done
        #5 $display("##############################################");
        $finish;

    end


// Teste
initial
    begin: test_case


        // Finalização do teste
        $display("Testbench evaluation PASSED!");
        -> sim_dn;
    end


initial
    forever begin: expected_values
        @ (evaluate);


        if (1) begin
            if (0) begin
                $display("TestBench evaluation FAILED!");
                -> sim_dn;
                -> error;
            end
        end
    end

endmodule
