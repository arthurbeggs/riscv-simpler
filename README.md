<p style="text-align: right;">
    :us: <a href="https://github.com/arthurbeggs/riscv-simple/tree/docs#risc-v-simple-en">
        <b>English Version</b>
    </a>
</p>

# **RISC-V SiMPLE** [pt-br]

**RISC-V SiMPLE** (**Si**ngle-cycle **M**ulticycle **P**ipeline **L**earning **E**nvironment) é uma implementação didática de um processador RISC-V RV64IMF com três microarquiteturas sintetizáveis em FPGA. Quando completo, o projeto será utilizado nas aulas de Organização e Arquitetura de Computadores da Universidade de Brasília - UnB.

No momento da síntese, é possível escolher se a microarquitetura utilizada será uniciclo, multiciclo ou *pipeline*. Todas as três arquiteturas são escalares, em ordem e com um único *hardware thread*.


## **Uniciclo**

O caminho de dados já implementado é um *subset* do RV64I. A tabela a seguir apresenta as instruções já implementadas:


|             |            |            |            |           |            |            |            |           |            |
|:--------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|
|  LUI      | AUIPC | JAL     | JALR    | BEQ    | BNE    | BLT     | BGE    | BLTU   | BGEU  |
|  LB       | LH       | LW     | LBU      | LHU   | SB       | SH      | SW     | ADDI   | SLTI    |
|  SLTIU  | XORI   | ORI    | ANDI    | SLLI   | SRLI     | SRAI   | ADD   | SUB     | SLL    |
|  SLT      | SLTU   | XOR   | SRL      | SRA   | OR       | AND   | LWU   | LD       | SD     |
| ADDIW | SLLIW | SRLIW | SRAIW | ADDW | SUBW | SLLW | SRLW | SRAW |          |

O diagrama do caminho de dados é apresentado na figura a seguir:

![Caminho de dados uniciclo](/docs/monograph/figs/singlecycle.png)


## **Multiciclo**
**Não implementado.**


## **Pipeline**
**Não implementado.**




# **RISC-V SiMPLE** [en]

**RISC-V SiMPLE** (**Si**ngle-cycle **M**ulticycle **P**ipeline **L**earning **E**nvironment) is a didactic implementation of a RV64IMF ~~(at least it's the original idea)~~ with three different datapaths chosen at synthesis time. It should be used as a resource for Computer Organization and Architecture classes at Universidade de Brasília - UnB.
