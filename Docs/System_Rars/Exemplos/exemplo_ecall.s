#################################################
#  Programa de exemplo de uso dos syscalls   	#
#  Versão Polling				#
#  Fev 2019	- 2019/1		      	#
#  Marcus Vinicius Lamar		      	#
#################################################
# Conecte o BitMap Display Tool E o Keyboard Display MMIO Tool

.include "../macros2.s"			# inclui arquivo de macros e definicoes no inicio do programa

.data 
FILE: .string "display.bin"			# string do nome do arquivo
STR0: .string "tecla pressionada: "		# string da mensagem0
STR1: .string "ascii da tecla: "		# string da mensagem 1

.text
main: 	M_SetEcall(exceptionHandling)	# Macro de SetEcall

# Abre o arquivo
	la a0,FILE
	li a1,0
	li a2,0
	li a7,1024
	ecall
	mv s0,a0		# salva o descritor do arquivo
	
# Le o arquivos para a memoria VGA frame 0
	mv a0,s0
	li a1,VGAADDRESSINI0
	li a2,76800
	li a7,63
	ecall

# Limpa a tela frame1
	li a0,0xFF
	li a1,1
	li a7,48
	ecall

#Fecha o arquivo
	mv a7,s0
	li a7,57
	ecall

# Escreve a string do endereço a0, na posição (a1,a2) com as cores a3, na frame a4		
	la a0,STR0   	# Endereco da STR
	li a1,0		# coluna
	li a2,0		# linha
	li a3,0xC7FF	# cores de fundo(FF) e frente(00) do texto, obs.: C7 eh transparente
	li a4,0		# frame 1
	li a7,104	# syscall de print string		
	ecall


# Escreve a string do endereço a0, na posição (a1,a2) com as cores a3, na frame a4		
	la a0,STR1   	# Endereco da STR
	li a1,0		# coluna
	li a2,8		# linha
	li a3,0xC7FF	# cores de fundo(FF) e frente(00) do texto, obs.: C7 eh transparente
	li a4,0		# frame 1
	li a7,104	# syscall de print string		
	ecall


MAINLOOP: jal KEYBOARD       	# Verifica se houve tecla pressionada


	mv a0,t2		# imprime o código ascii da tecla pressionada
	li a1,128		# coluna
	li a2,8			# linha
	li a3,0xFF00		# cores de fundo(FF) e frente(00) do texto
	li a4,0			# frame 1
	li a7,101		# syscall de print int	
	ecall	  
	  
	mv a0,t2		# imprime a tecla lida no nariz do sapo
	li a1,152		# coluna
	li a2,0			# linha
	li a3,0x3807		# cores de fundo(0x38) e frente(0x07) do caracter ASCII do teclado
	li a4,0			# frame 1
	li a7,111		# syscall de print char
	ecall 

  	j MAINLOOP		# volta ao loop principal

FIM:	li a7,10		# syscall de Exit
	ecall

KEYBOARD: 	li t1,KDMMIO_Ctrl	# carrega o endereço de controle do KDMMIO
		lw t0,0(t1)		# le a palavra de controle
		andi t0,t0,0x0001	# mascara o bit menos signifcativo
   		beq t0,zero,PULA   	# Se não há tecla pressionada então vá para PULA
  		lw t2,4(t1)  		# le a tecla pressionada
		sw t2,12(t1)  		# escreve a tecla do no display de texto	
	
PULA:	jr ra

.include "../SYSTEMv13.s"			# carrega as rotinas do sistema no final
