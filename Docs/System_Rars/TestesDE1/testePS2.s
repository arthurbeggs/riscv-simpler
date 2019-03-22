.text

	la $s0,0xFF100100  	#BUFFER1
	la $s1,0xFF100104	#BUFFER2
	la $s2,0xFF100520	#KEY0
	la $s3,0xFF100524	#KEY1
	la $s4,0xFF100528	#KEY2
	la $s5,0xFF10052C	#KEY3
	
									
LOOP:	lw $t0,0($s0)
	lw $t1,0($s1)
	lw $t2,0($s2)
	lw $t3,0($s3)
	lw $t4,0($s4)
	lw $t5,0($s5)
	j LOOP
	
