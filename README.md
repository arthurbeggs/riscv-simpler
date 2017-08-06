<p align="right">
    :us: <a href="https://github.com/arthurbeggs/riscv-simple/tree/docs#risc-v-simple-en">
        <b>English Version</b>
    </a>
</p>

# **RISC-V SiMPLE** [pt-br]

**RISC-V SiMPLE** (**Si**ngle-cycle **M**ulticycle **P**ipeline **L**earning **E**nvironment) é uma implementação didática de um *soft core* RISC-V RV64IMF com três microarquiteturas desenvolvido em Verilog. Quando completo, o projeto será utilizado nas aulas de Organização e Arquitetura de Computadores da Universidade de Brasília - UnB.

O processador possui interface Avalon para se comunicar com os periféricos das plataformas de desenvolvimento. O projeto utiliza a placa DE2-115 com FPGA Altera Cyclone IV para desenvolvimento e foi projetado para permitir a fácil adaptação para outras placas da Altera.

No momento da síntese, é possível escolher se a microarquitetura utilizada será uniciclo, multiciclo ou *pipeline*. Todas as três microarquiteturas são escalares, em ordem e com um único *hardware thread*.


## **Microarquiteturas**

### **Uniciclo**

O diagrama a seguir mostra o caminho de dados do *RISC-V SiMPLE Single-cycle*:

![Caminho de dados uniciclo](/docs/monograph/figs/singlecycle.png)

**No momento, o processador ainda não atende completamente às especificações do módulo RV64I.**

A tabela a seguir apresenta as instruções já implementadas:

|             |            |            |            |           |            |            |            |           |            |
|:--------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|
|  LUI      | AUIPC | JAL     | JALR    | BEQ    | BNE    | BLT     | BGE    | BLTU   | BGEU  |
|  LB       | LH       | LW     | LBU      | LHU   | SB       | SH      | SW     | ADDI   | SLTI    |
|  SLTIU  | XORI   | ORI    | ANDI    | SLLI   | SRLI     | SRAI   | ADD   | SUB     | SLL    |
|  SLT      | SLTU   | XOR   | SRL      | SRA   | OR       | AND   | LWU   | LD       | SD     |
| ADDIW | SLLIW | SRLIW | SRAIW | ADDW | SUBW | SLLW | SRLW | SRAW |          |


Para que o projeto seja completamente compatível com as especificações do módulo RV64I, é necessário implementar:

- [ ] Issue #3 - Tratamento de exceções, interrupções e *traps*;
- [ ] Issue #4 - Excessão de endereço de instrução desalinhado;
- [ ] Issue #5 - Excessão de acesso de memória proibido;
- [ ] Issue #6 - Excessão de instrução ilegal;
- [ ] Issue #7 - Registradores de Controle e Status (CSR);
- [ ] Issue #8 - Instruções CSR;
- [ ] Issue #9 - Instruções de ambiente (ECALL/EBREAK);
- [ ] Issue #10 - Instruções de FENCE;
- [ ] Issue #11 - Suporte para acesso desalinhado à memória de dados;
- [ ] Issue #12 - Pilha de endereço de retorno (RAS);


Após a completa adequação à especificação do módulo RV64I, os módulos M e F serão implementados.


### **Multiciclo**
**Não implementado.**


### **Pipeline**
**Não implementado.**


## **Documentação**

[Monografia - RISC-V SiMPLE](/docs/monograph/relatorio.pdf)

[ISA RISC-V - Especificação do Nível de Usuário \[en\]](https://riscv.org/specifications/)

[ISA RISC-V - Especificação do Nível Privilegiado \[en\]](https://riscv.org/specifications/privileged-isa/)




# **RISC-V SiMPLE** [en]

**RISC-V SiMPLE** (**Si**ngle-cycle **M**ulticycle **P**ipeline **L**earning **E**nvironment) is a didatic implementation of a RISC-V RV64IMF soft core with three microarchitectures developed in Verilog. When complete, the project will be used in Computer Architecture and Organization classes at Universidade de Brasilia -UnB.

The processor uses na Avalon interface to communicate with the peripherals of development platforms. The project is being developed using a DE2-115 board with Altera Cyclone IV FPGA and was designed to allow easy adaptation to other Altera boards.

At synthesis time, it is possible do choose whether the microarchitecture used will be single-cycle, multicycle or pipeline. All three microarchitectures are scalar, in-order, and with a single hardware thread.


## **Microarchitectures**

### **Single-cycle**

The follwing diagram shows the *RISC-V SiMPLE Single-cycle* datapath:

![Single-cycle datapath](/docs/monograph/figs/singlecycle.png)

**At this time, the processor still does not fully meet the RV64I module specs.**

The following table shows all instructions already implemented:

|             |            |            |            |           |            |            |            |           |            |
|:--------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|
|  LUI      | AUIPC | JAL     | JALR    | BEQ    | BNE    | BLT     | BGE    | BLTU   | BGEU  |
|  LB       | LH       | LW     | LBU      | LHU   | SB       | SH      | SW     | ADDI   | SLTI    |
|  SLTIU  | XORI   | ORI    | ANDI    | SLLI   | SRLI     | SRAI   | ADD   | SUB     | SLL    |
|  SLT      | SLTU   | XOR   | SRL      | SRA   | OR       | AND   | LWU   | LD       | SD     |
| ADDIW | SLLIW | SRLIW | SRAIW | ADDW | SUBW | SLLW | SRLW | SRAW |          |

in order for the project to be fully compliant with RV64I specs, it is necessary to implement:

- [ ] Issue #3 - Exception, interruption and trap handler;
- [ ] Issue #4 - Instruction misaligned address exception;
- [ ] Issue #5 - Forbidden memory access exception;
- [ ] Issue #6 - Illegal instruction exception;
- [ ] Issue #7 - Control and Status Registers (CSRs);
- [ ] Issue #8 - CSR instructions;
- [ ] Issue #9 - Environment instructions (ECALL/EBREAK);
- [ ] Issue #10 - FENCE instructions;
- [ ] Issue #11 - Support for misaligned data fetches;
- [ ] Issue #12 - Return Address Stack (RAS);

After complete compliance with RV64I spec, modules M and F will be implemented.


### **Multicycle**
**Unimplemented.**


### **Pipeline**
**Unimplemented.**


## **Documentation**

[Monografia - RISC-V SiMPLE \[pt-br\]](/docs/monograph/relatorio.pdf)

[ISA RISC-V - User-Level Specification](https://riscv.org/specifications/)

[ISA RISC-V - Privileged Level Specification](https://riscv.org/specifications/privileged-isa/)
