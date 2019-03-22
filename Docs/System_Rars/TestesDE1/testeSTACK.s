# testa o acesso à  pilha
.data
	
.text
	la $sp,0x10010008  # na memória de dados ou na SRAM (default)
	li $t0,1
	li $t1,2
	addi $sp,$sp,-8
	sw $t0,0($sp)
	sw $t1,4($sp)
	li $t0,3
	li $t1,4
	lw $t0,0($sp)
	lw $t1,4($sp)
	addi $sp,$sp,8
	
	li $t0,5
	li $t1,6
	addi $sp,$sp,-8
	sw $t0,0($sp)
	sw $t1,4($sp)
	li $t0,7
	li $t1,8
	lw $t0,0($sp)
	lw $t1,4($sp)
	addi $sp,$sp,8

FIM:	j FIM
