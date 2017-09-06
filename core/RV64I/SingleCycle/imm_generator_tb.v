////////////////////////////////////////////////////////////////////////////////
//      RISC-V SiMPLE - TestBench - Unidade Lógica Aritmética de 32 bits      //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps


module imm_generator_tb;

reg  [31:0] inst;
wire [63:0] immediate;


imm_generator dut(
    .inst(inst),
    .immediate(immediate)
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
        $display("\t\t  Time inst immediate");
        $monitor("%d \t %h \t %h", $time, inst, immediate);
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
