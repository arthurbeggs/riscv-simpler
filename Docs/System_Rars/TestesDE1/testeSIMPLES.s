# Teste para verificacao da simulacao por forma de onda no Quartus-II
.data
.text
	la $t1,0x10011FF4  # entre a RAM e SRAM
	li $t0,5
	nop
	sw $t0,0($t1)
	addi $t0,$t0,-1
	nop
	sw $t0,4($t1)
	addi $t0,$t0,-1
	nop
	sw $t0,8($t1)
	addi $t0,$t0,-1
	nop
	sw $t0,12($t1)
	addi $t0,$t0,-1
	nop
	sw $t0,16($t1)
	addi $t0,$t0,-1
	nop
	sw $t0,20($t1)

	lw $t0,0($t1)
	lw $t0,4($t1)
	lw $t0,8($t1)
	lw $t0,12($t1)
	lw $t0,16($t1)
	lw $t0,20($t1)

FIM1: 	j FIM1
