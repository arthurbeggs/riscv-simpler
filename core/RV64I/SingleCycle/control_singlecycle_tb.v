////////////////////////////////////////////////////////////////////////////////
//             RISC-V SiMPLE - TestBench - Controle do Uniciclo              //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps


module control_singlecycle_tb;

reg  [6:0] inst_opcode;
wire pc_write_en;
wire jal_en;
wire jalr_en;
wire branch_en;
wire data_mem_read_en;
wire data_mem_write_en;
wire regfile_write_en;
wire [2:0] mem_to_reg_sel;
wire [1:0] alu_op;
wire alu_src_a_sel;
wire alu_src_b_sel;

control_singlecycle dut(
    .inst_opcode(inst_opcode),
    .pc_write_en(pc_write_en),
    .jal_en(jal_en),
    .jalr_en(jalr_en),
    .branch_en(branch_en),
    .data_mem_read_en(data_mem_read_en),
    .data_mem_write_en(data_mem_write_en),
    .regfile_write_en(regfile_write_en),
    .mem_to_reg_sel(mem_to_reg_sel),
    .alu_op(alu_op),
    .alu_src_a_sel(alu_src_a_sel),
    .alu_src_b_sel(alu_src_b_sel)
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
        $display("\t\t  Time inst_opcode pc_write_en jal_en jalr_en branch_en data_mem_read_en data_mem_write_en regfile_write_en mem_to_reg_sel alu_op alu_src_a_sel alu_src_b_sel");
        $monitor("%d \t %b \t %b \t %b \t %b \t %b \t %b \t %b \t %b \t %b \t %b \t %b \t %b", $time, inst_opcode, pc_write_en, jal_en, jalr_en, branch_en, data_mem_read_en, data_mem_write_en, regfile_write_en, mem_to_reg_sel, alu_op, alu_src_a_sel, alu_src_b_sel);
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
