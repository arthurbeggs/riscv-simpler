# Teste para verificacao da simulacao por forma de onda no Quartus Prime
# A execução deve ser a mesma no Rars e na DE1-SoC
# Se for diferente deve ser devido a hazards não tratados no hardware
# Onde colocar nops de forma a corrigir os hazards?

.data
	NUM: .word 0x00400000
.text
INICIO: auipc tp,0x00fc10
	lw t0,0(tp)
	jalr ra,t0,0
	li t0,0xEEE
	j Fim
PULA:	li t0,0xCCC
Fim:	j Fim

 
 

	
