# Teste dos syscalls 1xx que usam o SYSTEMv1.s
# Conectar o BitMap Display e o KD MMIO para executar
# na DE1SoC e no Mars deve ter o mesmo comportamento sem alaterar nada!

.include "SYSTEMv1.s"

.data
FLOAT: .float 3.14159265659
msg1: .asciiz "Organizacao Arquitetura de Computadores 2018/1 !"
msg2: .asciiz "Digite seu Nome:"
msg3: .asciiz "Digite sua Idade:"
msg4: .asciiz "Digite seu peso:"
msg5: .asciiz "Numero Randomico:"
msg6: .asciiz "Tempo do Sistema:"
buffer: .asciiz "                                "

.text				
	jal CLS
	jal PRINTSTR1
	jal INPUTSTR
	jal INPUTINT
	jal INPUTFP
	jal RAND
	jal TIME
	jal TOCAR
	jal SLEEP

	li $v0,10
	syscall
	
			
# CLS Clear Screen
CLS:	li $a0,0x07
	li $v0,148
	syscall
	jr $ra
				
# syscall print string
PRINTSTR1: li $v0,104
	la $a0,msg1
	li $a1,0
	li $a2,0
	li $a3,0xFF00
	syscall
	
	jr $ra
	
	
INPUTSTR: li $v0,104
	la $a0,msg2
	li $a1,0
	li $a2,24
	li $a3,0xFF00
	syscall
	
# syscall read string
	li $v0,108
	la $a0,buffer
	li $a1,32
	syscall
	
# syscall print string	
	li $v0,104
	la $a0,buffer
	li $a1,144
	li $a2,24
	li $a3,0xFF00
	syscall
	
	
	jr $ra
	
# syscall read int
	# syscall print string	
INPUTINT: li $v0,104
	la $a0,msg3
	li $a1,0
	li $a2,32
	li $a3,0xFF00
	syscall

	# syscall read int
	li $v0,105
	syscall
	
	move $t0,$v0

#PI:	li $t0,-123456
	# syscall print int	
PRINTINT:	li $v0,101
	move $a0,$t0
	li $a1,152
	li $a2,32
	li $a3,0xFF00
	syscall
	
	jr $ra
	
# syscall read float
	# syscall print string	
INPUTFP: li $t0,0 
	l.s $f0,FLOAT		# testa para ver se tem a FPU
	mfc1 $t0,$f0
	beq $t0,$zero,FORAFP

 
  	li $v0,104
	la $a0,msg4
	li $a1,0
	li $a2,40
	li $a3,0xFF00
	syscall
	
	li $v0,106
	syscall
	
	mov.s $f12,$f0
#	l.s $f12,FLOAT
	
	# syscall print float
	li $v0,102
	li $a1,144
	li $a2,40
	li $a3,0xFF00
	syscall
	
FORAFP:	jr $ra
	
	# Contatos imediatos do terceiro grau
TOCAR:	li $a0,62
	li $a1,500
	li $a2,16
	li $a3,127
	li $v0,133
	syscall
	
	li $a0,64
	li $a1,500
	li $a2,16
	li $a3,127
	li $v0,133
	syscall
	
	li $a0,61
	li $a1,500
	li $a2,16
	li $a3,127
	li $v0,133
	syscall
	
	li $a0,50
	li $a1,500
	li $a2,16
	li $a3,127
	li $v0,133
	syscall
	
	
	li $a0,55
	li $a1,800
	li $a2,16
	li $a3,127
	li $v0,131
	syscall
	
	jr $ra
	
#	li $a0,60
#	li $a1,600
#	move $a2,$t0
#	li $a3,127
#	li $v0,31
#	syscall

		
# syscall rand
	# syscall print string	
RAND:	li $v0,104
	la $a0,msg5
	li $a1,0
	li $a2,48
	li $a3,0xFF00
	syscall

	# syscall Rand
	li $v0,141
	syscall
	
	# print int em hex
	li $v0,134  #134
	li $a1,148
	li $a2,48
	li $a3,0xFF00
	syscall
	
	jr $ra
	
	
	
# syscall time
	# syscall print string	
TIME:	li $v0,104
	la $a0,msg6
	li $a1,0
	li $a2,56
	li $a3,0xFF00
	syscall

	li $v0,130
	syscall
	
	move $t0,$a0
	move $t1,$a1
	
	#print int
	move $a0,$t0
	li $v0,101
	li $a1,148
	li $a2,56
	li $a3,0xFF00
	syscall
	
	#print int
	move $a0,$t1
	li $v0,101
	li $a1,244
	li $a2,56
	li $a3,0xFF00
	syscall
	
	jr $ra
	
# syscall sleep
SLEEP:	li $t0,5
LOOPHMS:li $a0,1000   # 1 segundo
	li $v0,132
	syscall
	
	addi $t0,$t0,-1
	#print seg
	move $a0,$t0
	li $v0,101
	li $a1,120
	li $a2,120
	li $a3,0xFF00
	syscall
	
	bne $t0,$zero, LOOPHMS
		
	jr $ra
	











