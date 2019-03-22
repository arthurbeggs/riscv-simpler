# Teste para verificacao do desempenho em 10 segundos

.data
.text
	li s0,2			# valor de parada para conferência do valor de t3 no Rars
	li t0,1
	li t1,0xFFFFFFFF
	li t3,0
LOOP:	divu t2,t1,t0
	add t3,t3,t2
	addi t0,t0,1
	beq t0,s0,FIM
	j LOOP
FIM:	j FIM
