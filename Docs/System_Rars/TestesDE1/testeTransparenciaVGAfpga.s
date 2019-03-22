.include "../SYSTEMv1.s"

.eqv TRANSPARENTE 0xC7C7C7C7
.eqv PRETO        0x00000000
.eqv ALGUMACOR    0xDDDDDDDD
.eqv OUTRACOR     0xAAAAAAAA
.eqv ROSA         0xC8C8C8C8
.eqv LINHAs       64

.macro _printLinha_  %Re
printLinha:
    sw      %Re, 0($t0)
    addi    $t0, $t0, 4
    addi    $t1, $t1, -4
    addi    $t2, $t2, -4
    beq     $t1, $zero, fim
    bne     $t2, $zero, printLinha
fim:
.end_macro


    .text
main:
    la      $t0, VGAADDRESSINI
    la      $t1, 25600      #76800

loop1:
    li      $t2, LINHAs
    la      $t3, PRETO
    _printLinha_ $t3
    beq     $t1, $zero, loop2

    li      $t2, LINHAs
    la      $t3, TRANSPARENTE
    _printLinha_ $t3
    beq     $t1, $zero, loop2

    li      $t2, LINHAs
    la      $t3, ROSA
    _printLinha_ $t3
    beq     $t1, $zero, loop2

    li      $t2, LINHAs
    la      $t3, TRANSPARENTE
    _printLinha_ $t3
    beq     $t1, $zero, loop2

    li      $t2, LINHAs
    la      $t3, PRETO
    _printLinha_ $t3
    beq     $t1, $zero, loop2

    j       loop1

loop2:
    la      $t1, 25600

loop22:
    li      $t2, LINHAs
    la      $t3, TRANSPARENTE
    _printLinha_ $t3
    beq     $t1, $zero, loop3

    li      $t2, LINHAs
    la      $t3, ALGUMACOR
    _printLinha_ $t3
    beq     $t1, $zero, loop3

    li      $t2, LINHAs
    la      $t3, TRANSPARENTE
    _printLinha_ $t3
    beq     $t1, $zero, loop3

    li      $t2, LINHAs
    la      $t3, OUTRACOR
    _printLinha_ $t3
    beq     $t1, $zero, loop3

    li      $t2, LINHAs
    la      $t3, TRANSPARENTE
    _printLinha_ $t3
    beq     $t1, $zero, loop3

    j       loop22

loop3:
    la      $t1, 25600

loop33:
    li      $t2, LINHAs
    la      $t3, ROSA
    _printLinha_ $t3
    beq     $t1, $zero, END

    li      $t2, LINHAs
    la      $t3, TRANSPARENTE
    _printLinha_ $t3
    beq     $t1, $zero, END

    li      $t2, LINHAs
    la      $t3, PRETO
    _printLinha_ $t3
    beq     $t1, $zero, END

    li      $t2, LINHAs
    la      $t3, TRANSPARENTE
    _printLinha_ $t3
    beq     $t1, $zero, END

    li      $t2, LINHAs
    la      $t3, ROSA
    _printLinha_ $t3
    beq     $t1, $zero, END

    j       loop33


END:
    li      $v0, 10
    syscall
