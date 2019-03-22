# ####################################### #
# #   Teste do teclado INKEY	    	# #
# #   Syscall 47	 		# #
# ####################################### #
# Uso com o SYSTEMv41.s			  #

.data
key1:   .asciiz     "Key 1:"
key2:   .asciiz     "Key 2:"

.text
	jal clearScreen
main:	jal inKey
	j main

clearScreen: li $v0, 48   # Chama o syscall ClearScreen
	li $a0, 0x004B
	syscall
	jr $ra

inKey:
    addi $sp, $sp, -8		# Salva $s0 e $s1 na pilha
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    li $v0, 47
    syscall                 # syscall inKey
    move $s0, $v0
    move $s1, $v1
	
    li $v0, 104
    la $a0, key1
    li $a1, 5
    li $a2, 10
    li $a3, 0x4BB4
    syscall
	
    li $v0, 104
    la $a0, key2
    li $a1, 5
    li $a2, 20
    li $a3, 0x4BB4
    syscall

printKey1: beq $s0, $zero, eraseKey1
    li $v0, 111
    move $a0, $s0
    li $a1, 200
    li $a2, 10
    li $a3, 0x4BB4
    syscall
    j printKey2

# Para apagar, printa o caracter '0', mas com a cor do caracter igual a cor do fundo.	
eraseKey1: li $v0, 111
    li $a0, 0x30
    li $a1, 200
    li $a2, 10
    li $a3, 0x4B4B
    syscall
	
printKey2: beq $s1, $zero, eraseKey2
    li $v0, 111
    move $a0, $s1
    li $a1, 200
    li $a2, 20
    li $a3, 0x4BB4
    syscall
    j endInKey

# Para apagar, printa o caracter '0', mas com a cor do caracter igual a cor do fundo.	
eraseKey2: li $v0, 111
    li $a0, 0x30
    li $a1, 200
    li $a2, 20
    li $a3, 0x4B4B
    syscall
	
endInKey:
    lw $s0, 0($sp)			# recupera $s0 e $s1 da pilha
    lw $s1, 4($sp)
    addi $sp, $sp, 8
    jr $ra
