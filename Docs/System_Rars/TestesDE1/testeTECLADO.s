# ####################################### #
# #  Teste da interface PS2 com teclado # #
# #   2017/2				# #
# ####################################### #

.include "../SYSTEMv1.s"

.data 
TEXTO:  .asciiz "texto de teste"
INI:	.space 264
FIM:	.word 0

.text
	li $v0,5
	syscall

	li $v0,10
	syscall

#	la $sp,FIM
	la $s0,Buffer0Teclado  	#Buffer0
	la $s1,Buffer1Teclado	#Buffer1
	la $s2,KeyMap0  	#ScanKey0
	la $s3,KeyMap1		#ScanKey1

LOOP1:	lw $t0,0($s0)
	lw $t1,0($s1)
	lw $t2,0($s2)
	lw $t3,0($s3)
#	j LOOP1
	li $v0,104
	la $a0,TEXTO
	li $a1,0
	li $a2,0
	li $a3,0x00FF
	syscall
	
	li $v0,8		# readString
	la $a0,TEXTO
	li $a1,10
	syscall

	li $v0,104
	la $a0,TEXTO
	li $a1,0
	li $a2,0
	li $a3,0x00FF
	syscall

fim:	j fim













