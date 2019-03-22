# testa a excecao de instrução inválida

.include "../SYSTEMv1.s"

.text
MAIN:	la $t0,MAIN
	la $t1,0xFFFFFFFF  # instrução inválida
	sw $t1,24($t0)
	nop
	nop
	nop		  #local da instrução inválida
	nop

	li $v0,10
	syscall
