.include "../SYSTEMv1.s"

.text

	la $s0,IrDA_CTRL  	#IRDA_CONTROL_ADDRESS
	la $s1,IrDA_RX		#IRDA_READ_ADDRESS
	la $s2,IrDA_TW 		#IRDA_WRITE_ADDRESS

LOOP:	lw $a0,0($s0)
	bne $a0, $zero, LOOP 
	li $a1, 0xFF0000FF
	li $a2, 0x00000001
	sw $a1, 0($s2)
	sw $a2, 0($s0)
	
	lw $s3, 0($s1)
	j LOOP
