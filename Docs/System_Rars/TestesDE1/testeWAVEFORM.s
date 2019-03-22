# Teste para verificacao da simulacao por forma de onda no Quartus-II
# Descomentar as instrucoes da FPU para testar o Uniciclo e o Multiciclo
# os registradores $t0 e $f8 são as saidas

.data
NUM: .word 5,4,3,2,1
F1: .float 1.0
F2: .float 3.333

.text
	la $t1,NUM    		# testa lui e ori
	lw $t0,0($t1)  		# testa lw
	l.s $f1,F1   		# testalwc1
	l.s $f10,F2
	mtc1 $zero,$f8 		# testa mtc1
	sw $t0,4($t1)   	# testa sw
LOOP: 	beq $t0,$zero, FIM   	# testa beq
	addi $t0,$t0,-1	  	#testa addi
	jal PROC  		#testa jal
	j LOOP     		# testa j
	
FIM: 	j FIM   		# para parar o processador sem syscall 10

PROC: add.s $f8,$f8,$f1  	# Para testar FPU no Uni e Multi
      c.le.s 4,$f8,$f10
      bc1t 4,FORA
      add.s $f8,$f8,$f8
FORA: jr $ra  			# testa jr
