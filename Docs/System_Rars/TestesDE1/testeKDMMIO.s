.data
BUFFER: .asciiz "                                                                         "

.text				
	
	la 	$s0, 0xFF100000			# Execucao com Polling do KD MMIO
	la 	$s1, 0xFF100100			# BUFFER0
	la 	$s2, 0xFF100520			# KEYMAP
	la 	$s3,BUFFER
	
loop:  	lw     	$t0, 0($s0)   			# le o bit de flag do teclado
 #  	lw 	$s3, 4($s0)			# mostra o ascii da tecla pressionad
#	beq	$t0,$zero,loop
	lw	$t2, 0($s1)			# mostra o BUFFER0
   	lw 	$t3, 4($s1)			# mostra o BUFFER1
#	lw	$t4, 0($s2)			# mostra o KEYMAP0
 #   	lw 	$t5, 4($s2)			# mostra o KEYMAP1
#	lw	$t6, 8($s2)			# mostra o KEYMAP2
 #   	lw 	$t7, 12($s2)			# mostra o KEYMAP3
 	andi	$t0,$t0,0x0001    	    	
	beq	$t0,$zero,loop
	lw     	$t1, 4($s0)   			# mostra ascii da tecla
	sb	$t1,0($s3)
	addi 	$s3,$s3,1
	j loop
