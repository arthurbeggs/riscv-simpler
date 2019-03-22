#################################################
#	Testbench para a ISA RV32IM
#  Baseado no trabalho:
# 
#
# Marcus Vinicius Lamar
# 2018/2
#################################################

.eqv RV32M 1	# define se testa ou nao mul e div

.data
N:	.word 5
N2:	.word 10
N3:	.word 0
NH:	.half 2
NH1:	.half 0
NB:	.byte 2
NB1:	.byte 0
MSG:	.string "Endereco do erro : "
MSG2:	.string "Nao ha erros :)"

.include "..\macros2.s"

.text
	la t1, N	#t1 = N
	lw t0, 0(t1)
	sw t0, 8(t1)
	lw t0, 8(t1)
	bne t0, zero, PULAERRO1
	jal t0, ERRO
	
PULAERRO1: li t1, 10
	add t0, t0, t0	#t0 = 5 + 5
	beq t0, t1, PULAERRO2
	jal t0, ERRO
	
PULAERRO2: sub t0, t0, t0 #t0 = 0
	beq t0, zero, PULAERRO3
	jal t0, ERRO

PULAERRO3: li t0, 5
	and t0, t0, zero #and t0, 0 = 0
	beq t0, zero, PULAERRO4
	jal t0, ERRO
	
PULAERRO4: li t0, 1
	li t1, 0
	li t2, 1
	or t0, t0, t1 #or, t0, t1 = 1
	beq t0, t2, PULAERRO5
	jal t0, ERRO
	
PULAERRO5: li t0, 1
	li t1, 1
	li t2, 0
	xor t0, t0, t1 #xor, t0, t1 = 0
	beq t0, t2, PULAERRO6
	jal t0, ERRO
	
PULAERRO6: li t0, 5
	li t1, 3
	slt t0, t0, t1 #t0 < t1 = 0
	beq t0, zero, PULAERRO7
	jal t0, ERRO
	
PULAERRO7: li t0, 5
	li t1, 3
	li t2, 1
	sltu t0, t1, t0 #t1 < t0 = 1
	beq t0, t2, PULAERRO8
	jal t0, ERRO
	
PULAERRO8: li t0, 4
	li t1, 1
	li t2, 8
	sll t0, t0, t1 #t0 = t0 << t1
	beq t0, t2, PULAERRO9 #t0 = 8
	
PULAERRO9: li t0, 4
	li t1, 1
	li t2, 2
	srl t0, t0, t1
	beq t0, t2, PULAERRO10
	jal t0, ERRO
	
PULAERRO10: li t0, 4
	li t1, 1
	li t2, 2
	sra t0, t0, t1
	beq t0, t2, PULAERRO11
	jal t0, ERRO

PULAERRO11: li t0, 5
	li t2, 10
	addi t0, t0, 5
	beq t0, t2, PULAERRO12
	jal t0, ERRO
	
PULAERRO12: andi t0, zero, 1
	beq t0, zero, PULAERRO13
	jal t0, ERRO

PULAERRO13: li t0, 1
	li t2, 1
	xori t0, t0, 0
	beq t0, t2, PULAERRO14
	jal t0, ERRO

PULAERRO14: li t0, 2
	slti t0, t0, 1 #t0 = t0 < 1
	beq t0, zero, PULAERRO15
	jal t0, ERRO
	
PULAERRO15: li t0, 2
	sltiu t0, t0, 1
	beq t0, zero, PULAERRO16
	jal t0, ERRO
	
PULAERRO16: li t0, 2
	li t1, 4
	slli t0, t0, 1
	beq t0, t1, PULAERRO17
	jal t0, ERRO
	
PULAERRO17: li t0, 2
  	li t2, 1
  	srai t0, t0, 1
  	beq t0, t2, PULAERRO18
  	jal t0, ERRO
 
PULAERRO18: auipc t0, 0 #PC
  	auipc t1, 0 #PC + 4
  	li t2, 4
  	sub t1, t1, t2 #t1 = t1 - 4
  	beq t0, t1, PULAERRO19
  	jal t0, ERRO
  	
PULAERRO19: li t0, 0
	lui t0, 1 #t0 = 4096
	li t1, 4096
	beq t0, t1, PULAERRO20
	jal t0, ERRO
	
PULAERRO20: li t0, 0
	beq zero, t0, PULAERRO21
	jal t0, ERRO
	
PULAERRO21: li t0, 5
	bne zero, t0, PULAERRO22
	jal t0, ERRO
	
PULAERRO22: li t0, 5
	li t1, 2
	bge t0, t1, PULAERRO23
	jal t0, ERRO
	
PULAERRO23: li t0, 5
	li t1, 2
	bgeu t0, t1, PULAERRO24
	jal t0, ERRO
	
PULAERRO24: li t0, 5
	li t1, 2
	blt t1, t0, PULAERRO25
	jal t0, ERRO
	
PULAERRO25: li t0, 5
	li t1, 2
	bltu t1, t0, PULAERRO26
	jal t0, ERRO
	
PULAERRO26: la t2, ERRO
	jal PULAERRO27
	jalr t0, t2, 0

PULAERRO27: la t2, PULAERRO28
	jalr t0, t2, 0
	jal t0, ERRO
	
PULAERRO28: la t1, NB
	lb t0, 0(t1)
	sb t0, 1(t1)
	lb t0, 1(t1)
	bne t0, zero, PULAERRO29
	jal t0, ERRO
	
PULAERRO29: la t1, NB
	lbu t0, 0(t1)
	sb  t0, 1(t1)
	lbu t0, 1(t1)
	bne t0, zero, PULAERRO30
	jal t0, ERRO
	
PULAERRO30: la t1, NH
	lh t0, 0(t1)
	sh t0, 2(t1)
	lh t0, 2(t1)
	bne t0, zero, PULAERRO31
	jal t0, ERRO
	
PULAERRO31: la t1, NH
	lhu t0, 0(t1)
	sh  t0, 2(t1)
	lhu t0, 2(t1)
	bne t0, zero, MUL
	jal t0, ERRO
	
MUL:	li t0, RV32M	#Se RV32M for 1 as multiplicacoes sao testadas
	bne t0, zero, PULAERRO32 
	jal t0, END
		
PULAERRO32: li t0, 5
	li t1, 3
	li t2, 15
	mul t0, t0, t1
	beq t0, t2, PULAERRO33
	jal t0, ERRO

PULAERRO33: li t0, 0x00000002
	li t1, 0x00000009
	mulh t0, t0, t1
	beq t0, zero, PULAERRO34
	jal t0, ERRO
	
PULAERRO34: li t0, 0x00000002
	li t1, 0x00000009
	mulhu t0, t0, t1
	beq t0, zero, PULAERRO35
	jal t0, ERRO

PULAERRO35: li t0, 0x00000002
	li t1, 0x00000009
	mulhsu t0, t0, t1
	beq t0, zero, PULAERRO36
	jal t0, ERRO
	
PULAERRO36: li t0, 4
	li t1, 2
	div t0, t0, t1
	beq t0, t1, PULAERRO37
	jal t0, ERRO
	
PULAERRO37: li t0, 4
	li t1, 2
	divu t0, t0, t1
	beq t0, t1, PULAERRO38
	jal t0, ERRO
	
PULAERRO38: li t0, 5
	li t1, 3
	li t2, 2
	rem t0, t0, t1
	beq t0, t2, PULAERRO39
	jal t0, ERRO
	
PULAERRO39: li t0, 5
	li t1, 3
	li t2, 2
	remu t0, t0, t1
	beq t0, t2, SUCESSO
	jal t0, ERRO

SUCESSO: M_SetEcall(exceptionHandling)	

   	li a0, 0x38
	li a7, 148
	M_Ecall

	#print string sucesso
	li a3,0x3800
LOOP:	li a7, 104
	la a0, MSG2
	li a1, 100
	li a2, 0
	M_Ecall
	addi a3,a3,1
	j LOOP
	
	#end
	addi a7, zero, 10
	M_Ecall
	
ERRO:	mv s0,t0
	M_SetEcall(exceptionHandling)
		
	li a0, 0x07
	li a7, 148
	M_Ecall
	
	#Print string erro
	li a7, 104
	la a0, MSG
	li a1, 0
	li a2, 0
	li a3, 0x0700
	M_Ecall
	
	#print endereco erro
	addi a0, s0, -12 #Endereco onde ocorreu o erro
	li a7, 134
	li a1, 148
	li a2, 0
	li a3, 0x0700
	M_Ecall
	
	#end
END: addi a7, zero, 10
	M_Ecall
	
.include "..\SYSTEMv12.s"
	
