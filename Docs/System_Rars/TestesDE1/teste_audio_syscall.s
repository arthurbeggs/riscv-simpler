.include "../macro.s"

# Inicio da musica do Mario

.text
	M_SetEcall(exceptionHandling)	# Macro de SetEcall - não tem ainda na DE1-SoC
	
	li	a0, 66
	li	a1, 200
	li	a2, 1
	li	a3, 127
	li	a7, 31
	ecall
	li	a0, 76
	li	a1, 200
	li	a2, 4
	li	a3, 127
	li	a7, 33
	ecall
	
	li	a0, 66
	li	a1, 200
	li	a2, 1
	li	a3, 127
	li	a7, 31
	ecall
	li	a0, 76
	li	a1, 200
	li	a2, 4
	li	a3, 127
	li	a7, 33
	ecall
	
	li	a0, 66
	li	a1, 200
	li	a2, 1
	li	a3, 0
	li	a7, 31
	ecall
	li	a0, 76
	li	a1, 200
	li	a2, 4
	li	a3, 0
	li	a7, 33
	ecall
	
	li	a0, 66
	li	a1, 200
	li	a2, 1
	li	a3, 127
	li	a7, 31
	ecall
	li	a0, 76
	li	a1, 200
	li	a2, 4
	li	a3, 127
	li	a7, 33
	ecall
	
	li	a0, 66
	li	a1, 200
	li	a2, 1
	li	a3, 0
	li	a7, 31
	ecall
	li	a0, 76
	li	a1, 200
	li	a2, 4
	li	a3, 0
	li	a7, 33
	ecall
	
	li	a0, 66
	li	a1, 200
	li	a2, 1
	li	a3, 127
	li	a7, 31
	ecall
	li	a0, 72
	li	a1, 200
	li	a2, 4
	li	a3, 127
	li	a7, 33
	ecall

	li	a0, 66
	li	a1, 200
	li	a2, 1
	li	a3, 127
	li	a7, 31
	ecall
	li	a0, 76
	li	a1, 200
	li	a2, 4
	li	a3, 127
	li	a7, 33
	ecall
	
	li	a0, 66
	li	a1, 200
	li	a2, 1
	li	a3, 0
	li	a7, 31
	ecall
	li	a0, 76
	li	a1, 200
	li	a2, 4
	li	a3, 0
	li	a7, 33
	ecall
	
	li	a0, 67
	li	a1, 200
	li	a2, 1
	li	a3, 127
	li	a7, 31
	ecall
	li	a0, 71
	li	a1, 200
	li	a2, 4
	li	a3, 127
	li	a7, 31
	ecall
	
	li	a0, 79
	li	a1, 200
	li	a2, 1
	li	a3, 127
	li	a7, 33
	ecall
	li	a0, 76
	li	a1, 500
	li	a2, 4
	li	a3, 0
	li	a7, 33
	ecall

	li	a0, 67
	li	a1, 600
	li	a2, 6
	li	a3, 127
	li	a7, 33
	ecall
	
	
end_loop:	
	li	a7, 10
	ecall

	
.include "../SYSTEMv11.s"