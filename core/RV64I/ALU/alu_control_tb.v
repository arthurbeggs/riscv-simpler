////////////////////////////////////////////////////////////////////////////////
//                RISC-V SiMPLE - TestBench - Controle da ULA                 //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps


module alu_control_tb;

reg  inst_bit30;
reg  [1:0] alu_op;
reg  [2:0] inst_funct3;
wire [3:0] alu_funct;


alu_control dut(
    .alu_op(alu_op),
    .inst_funct3(inst_funct3),
    .inst_bit30(inst_bit30),
    .alu_funct(alu_funct)
);


// Eventos
event sim_dn;
event evaluate;
event error;

// Valor esperado para branches
reg [2:0] branch_funct;

// Controle de passagens dos loops
integer inner_break;
integer outer_break;


initial
    begin: initial_values
        // Inicialização de drivers
        inst_bit30  = 1'b0;
        alu_op      = 2'b00;
        inst_funct3 = 3'b000;


        // Monitoramento de I/O
        $display("##############################################");
        // $display("\t\t  Time inst_bit30 alu_op inst_funct3 alu_funct");
        // $monitor("%d \t %b \t %b \t %b \t %b", $time, inst_bit30, alu_op, inst_funct3, alu_funct);
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
        #40
        outer_break = 0;

        for (alu_op = 2'b00; outer_break == 0;
             alu_op = alu_op + 2'b01) begin

            inner_break = 0;

            for (inst_funct3 = 3'b000; inner_break == 0;
                 inst_funct3 = inst_funct3 + 3'b001) begin

                inst_bit30 = 1'b0;
                // Compara se o valor de saída alu_funct é igual ao esperado
                #20 -> evaluate;

                #20
                inst_bit30 = 1'b1;
                // Compara se o valor de saída alu_funct é igual ao esperado
                #20 -> evaluate;

                #20
                // Testa se inst_funct3 já chegou ao valor máximo
                if (inst_funct3 == 3'b111) inner_break = 1;
            end

            // Testa se alu_op já chegou ao valor máximo
            if (alu_op == 2'b11) outer_break = 1;
        end

        // Finalização do teste
        $display("Testbench evaluation PASSED!");
        -> sim_dn;
    end


initial
    forever begin: expected_values
        @ (evaluate);
        if (alu_op == 2'b00) begin
            if (alu_funct != {1'b0, `ALU_ADD_SUB}) begin
                $display("TestBench evaluation FAILED!");
                -> sim_dn;
                -> error;
            end
        end

        else if (alu_op == 2'b01) begin
            if (alu_funct != {1'b1, `ALU_ADD_SUB}) begin
                $display("TestBench evaluation FAILED!");
                -> sim_dn;
                -> error;
            end
        end

        else if (alu_op == 2'b10) begin
            if (alu_funct != {((((inst_funct3 == `ALU_ADD_SUB) || (inst_funct3 == `ALU_SHIFTR)) && inst_bit30) ? 1'b1 : 1'b0), inst_funct3}) begin
                $display("TestBench evaluation FAILED!");
                -> sim_dn;
                -> error;
            end
        end

        else if (alu_op == 2'b11) begin
            if (alu_funct != {1'b1, branch_funct}) begin
                $display("TestBench evaluation FAILED!");
                -> sim_dn;
                -> error;
            end
        end
    end

// Mapeamento de inst_funct3 para funções de branch
always @ ( * ) begin
    case (inst_funct3)
        `BRANCH_EQ,
        `BRANCH_NE:
            branch_funct = `ALU_ADD_SUB;

        `BRANCH_LT,
        `BRANCH_GE:
            branch_funct = `ALU_SLT;

        `BRANCH_LTU,
        `BRANCH_GEU:
            branch_funct = `ALU_SLTU;

        default:
            branch_funct = 3'b0;
    endcase
end

endmodule
