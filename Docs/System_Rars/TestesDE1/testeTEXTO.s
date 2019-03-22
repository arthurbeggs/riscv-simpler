.include "../SYSTEMv1.s"

.data
TEXTO: .asciiz  "A"
TEXTO2: .asciiz "B"

.text
LOOP:	la $sp, 0x10011FFC
	la $a0,TEXTO
	li $a1,0
	li $a2,0
	li $a3,0x00FF
	li $v0,104
	syscall
	la $a0,TEXTO2
	li $a1,0
	li $a2,0
	li $a3,0x00FF
	li $v0,104	
	syscall
 	j LOOP
