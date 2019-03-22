# Teste para verificacao da simulacao por forma de onda no Quartus-II
# Descomentar as instrucoes da FPU para testar o Uniciclo e o Multiciclo
# os registradores $t0 e $f8 são as saidas

.data
NUM: .word 5
F1: .float 3.66666666

.text	
	la $t1,NUM		# $t1 = Endereco NUM
	lw $t0,0($t1)		# $t0 = numero 5
	sw $t0,8($t1)		# grava número em NUM+8 na memória
	lw $t0,8($t1)		# Le o numero gravado
	beq $t0,$zero,FIM  	# caso o numero lido seja 0 é porque deu ruim no sw ou no lw
	mtc1 $t0,$f8		# passa o numero para o C1
	cvt.s.w $f8,$f8		# converte o numero para fp 40A00000
	mov.s $f0,$f8		# copia para $f0
	l.s $f8,F1   		# carrega o numero em F1 3.6666666  406aaaab
	add.s $f8,$f8,$f0	# soma 5.0+3.6666666 = 8.6666667  410aaaab
	sqrt.s $f8,$f8		# raiz de 8.6666667 = 2.943920... 403c6931
	c.lt.s 4,$f8,$f0	# compara  2.943920... < 5.0 ? aciona flag 4
	bc1t 4,PULA		# se for verdadeiro PULA
	li $t0,0xEEEE		# diz que houve EEEErro
FIM1:	j FIM1			# trava o processador
PULA:	#sw $zero,0($zero)
	jal MULT		# testa o jal
	cvt.w.s $f8,$f8		# converte 8.6666667 para inteiro (FPGA!=Mars)
	mfc1 $t0,$f8		# coloca em $t0 8(Mars) ou 9(FPGA)
FIM:	j FIM			# trava o processsador

MULT: mul.s $f8,$f8,$f8		# testa mul  $f8*$f8 = 8.666666  406aaaab
FORA: jr $ra  			# testa jr
