////////////////////////////////////////////////////////////////////////////////
//      RISC-V SiMPLE - TestBench - Unidade Lógica Aritmética de 32 bits      //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps


module control_transfer_singlecycle_tb;

reg  branch_en;
reg  jal_en;
reg  jalr_en;
reg  result_eq_zero;
reg  [2:0] inst_funct3;
wire [1:0] pc_sel;


control_transfer_singlecycle dut(
    .branch_en(branch_en),
    .jal_en(jal_en),
    .jalr_en(jalr_en),
    .result_eq_zero(result_eq_zero),
    .inst_funct3(inst_funct3),
    .pc_sel(pc_sel)
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
        $display("\t\t  Time branch_en jal_en jalr_en result_eq_zero inst_funct3 pc_sel");
        $monitor("%d \t %b\t %b\t %b\t %b\t %b\t %b", $time, branch_en, jal_en, jalr_en, result_eq_zero, inst_funct3, pc_sel);
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
