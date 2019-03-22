#########################################################
#  Programa de exemplo de uso do Bitmap Display Tool   	#
#  OAC Abril 2018			  		#
#  Marcus Vinicius Lamar		  		#
#########################################################
#
# Cuidar que o arquivo display.bin deve estar no mesmo diretório do Rars!
# Use o programa paint.net (baixar da internet) para gerar o arquivo .bmp de imagem 320x240 e 24 bits/pixel 
# para então usar o programa bmp2oac.exe para gerar o arquivo .bin correspondente

.data
FILE: .string "display.bin"

.text

# Preenche a tela de vermelho
	li t1,0xFF000000	# endereco inicial da Memoria VGA
	li t2,0xFF012C00	# endereco final 
	li t3,0x07070707	# cor vermelho|vermelho|vermelhor|vermelho
LOOP: 	beq t1,t2,FORA	# Se for o último endereço então sai do loop
	sw t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,4		# soma 4 ao endereço
	j LOOP			# volta a verificar
FORA:
# Abre o arquivo
	la a0,FILE		# Endereço da string do nome do arquivo
	li a1,0		# Leitura
	li a2,0		# binário
	li a7,1024		# syscall de open file
	ecall			# retorna em $v0 o descritor do arquivo
	
	mv t0,a0		# salva o descritor em $t0
	
# Le o arquivos para a memoria VGA
	mv a0,t0		# $a0 recebe o descritor
	li a1,0xFF000000	# endereco de destino dos bytes lidos
	li a2,76800		# quantidade de bytes
	li a7,63		# syscall de read file
	ecall			# retorna em $v0 o numero de bytes lidos

#Fecha o arquivo
	mv a0,t0		# $a0 recebe o descritor
	li a7,57		# syscall de close file
	ecall			# retorna se foi tudo Ok

# devolve o controle ao sistema operacional
FIM:	li a7,10		# syscall de exit
	ecall
