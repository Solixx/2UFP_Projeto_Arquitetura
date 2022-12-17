.data
MSGColuna: 	.asciiz "Insira uma coluna \n"
MSGLinha: 	.asciiz "Insira uma linha \n"
Enter:		.asciiz "\n"

.align 2
tabuleiro: 	.space 400	# Tabuleiro 
copiaTabuleiro:	.space 400	# Copia do tabuleiro (mostrar na tela do jogo)
arrayDePos:	.word		# Posições para colocar os barcos (usado na função gerarTabuleiro)
valTabuleiro:	.space 400

.text
.globl main
main:

jal fase1Main

Exit:
li $v0, 10
syscall





fase1Main:
# $t1 -> tamanho do barco
# $t2 -> letra do Barco
#TODO
addi $sp, $sp, -4
sw $ra, 0($sp)
jal zerarTabuleiro
addi $t1, $0, 5
li $t2, 'C'
jal gerarTabuleiro
jal displayTabuleiro
#TODO

lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra




gerarTabuleiro:
# a0 -> Size do Barco
# a1 -> Letra do Barco
# $s0 -> tabuleiro
# $s1 -> Poisções das Peças do Barco
# $t1 -> posição do barco antes de chackar se vazia / posição do barco para add Letra
# $t2 -> Valor na Pos do tabuleiro
# $t3 -> Axis (Horizontal = 0 / Vertical = 1)
# $t4 ->
# $t5 -> size Barco *4
# $t9 -> I

add $sp, $sp, -12	# Baixar a Stack
sw $ra, 0($sp)		# Guardar o $ra desta função
add $a0, $t1, $0	# Guardar o Size do Barco em $a0
add $a1, $t2, $0	# Guardar a Letra do Barco em $a1
sw $a0, 4($sp)		# Guardo o Size do Barco na stack pq vou perder o valor de $a0 noutras funções
sw $a1, 8($sp)		# Guardo a Letra do Barco na stack pq vou perder o valor de $a1 noutras funções
la $s0, tabuleiro	# Guardar o endereço do tabuleiro em $s0
la $s1, arrayDePos	# Guardar o endereço do arrayDePos em $s1
#TODO
gerarPos:
	jal gerarAxRandom		# Função que gera Numero entre 0 < 2
	add $t3, $v0, $0		# Guarda o valor que vai ser usado para saber em que direção adicionar as peças do barco
	addi $t3, $0, 1
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras funções)
	beq $t3, 0, validacoesHor
	validacoesVert:
		addi $t4, $0, 100
		add $t5, $a0, -1
		mul $t5, $t5, 10
		sub $t4, $t4, $t5
		jal gerarNumeroRandomVert	# Função que gera Numero entre 0 < 60
		add $t1, $v0, $0		# Guarda a primeira posiçãop gerada pela função "gerarNumeroRandom"
		mul $t1, $t1, 4			# Multiplicar essa posição para ser usada nos arrays
	j sair_validacoes
	validacoesHor:
		jal gerarNumeroRandom		# Função que gera Numero entre 0 < 100
		add $t1, $v0, $0		# Guarda a primeira posiçãop gerada pela função "gerarNumeroRandom"
		mul $t1, $t1, 4			# Multiplicar essa posição para ser usada nos arrays
		
		mul $t5, $a0, 4
		Hor_t1_entre_0_36:
		bge $t1, 40, Hor_t1_entre_40_76
			addi $t4, $0, 40
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_40_76:
		bge $t1, 80, Hor_t1_entre_80_116
			addi $t4, $0, 80
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_80_116:
		bge $t1, 120, Hor_t1_entre_120_156
			addi $t4, $0, 120
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_120_156:
		bge $t1, 160, Hor_t1_entre_160_196
			addi $t4, $0, 160
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_160_196:
		bge $t1, 200, Hor_t1_entre_200_236
			addi $t4, $0, 200
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_200_236:
		bge $t1, 240, Hor_t1_entre_240_276
			addi $t4, $0, 240
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_240_276:
		bge $t1, 280, Hor_t1_entre_280_316
			addi $t4, $0, 280
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_280_316:
		bge $t1, 320, Hor_t1_entre_320_356
			addi $t4, $0, 320
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_320_356:
		bge $t1, 360, Hor_t1_entre_360_396
			addi $t4, $0, 360
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_360_396:
		bge $t1, 400, sair_validacoes
			addi $t4, $0, 400
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
	sair_validacoes:
	la $s0, tabuleiro		# Voltar a meter o valor do endereço do tabuleiro em $a0 pois foi perdido na função anterior "gerarNumeroRandom"
	add $s0, $s0, $t1		# Meter $s0 na posição gerada aleatóriamente
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras funções)
	addi $t9, $0, 0			# i = 0
	forSizeBarco:
		beq $t9, $a0, breakForSizeBarco	# If(I < Size) SAI -> breakForSizeBarco
		lw $t2, 0($s0)			# Recebe o valor dessa posição em $t2
		bne $t2, '0', gerarPos		# If($t2 != '0') SAI -> gerarPos
		beq $t3, 0, fazHorizontal	# If($t3 == 0) ($t2 = 0 -> Horizontal / $t2 = 1 -> Vertical)
		fazVertical:
			addi $s0, $s0, 40		# Ando para baixo no tabuleiro
			sw $t1, 0($s1)			# Guarda o valor de $t1 em $s1(array com as posições onde vão ser inseridas as letras do barco no tabuleiro)
			addi $t1, $t1, 40		# $t1 + 40 para andar para baixo no tabuleiro (várias peças do barco)
			j sairDeAxis
		fazHorizontal:
			addi $s0, $s0, 4		# Ando para a direita no tabuleiro
			sw $t1, 0($s1)			# Guarda o valor de $t1 em $s1(array com as posições onde vão ser inseridas as letras do barco no tabuleiro)
			addi $t1, $t1, 4		# $t1 + 4 para andar para a direita no tabuleiro (várias peças do barco)
			j sairDeAxis
		sairDeAxis:
		addi $s1, $s1, 4		# Mudar de posição do vetor
		addi $t9, $t9, 1		# I++
		j forSizeBarco
breakForSizeBarco:
lw $a0, 4($sp)		# Receber da stack o valor de $a0 (size do Braco)
lw $a1, 8($sp)		# Receber da stack a letra do barco
addi $t9, $0 0		# I = 0
forAddBarco:
	beq $t9, $a0, sairGerarBarco		# If(I < Size) SAI -> breakForSizeBarco
	addi $s1, $s1, -4			# Baixa as posições do vetor de $s1(posições das peças do barco)
	lw $t1, 0($s1)				# Recebe o valor de $s1(posições do tabuleiro) para $t1	
	la $s0, tabuleiro
	add $s0, $s0, $t1			# Anda no tabuleiro para as várias posições
	sw $a1, 0($s0)				# Guarda o valor de $a1(letra do barco) na posição $s0(tabuleiro)
	addi $t9, $t9, 1			# I++
	j forAddBarco
sairGerarBarco:
#TODO
lw $ra, 0($sp)
addi $sp, $sp, 12
jr $ra







gerarNumeroRandom:
li $a1, 100	#valor maximo do numero aleatorio
li $v0, 42	#gerar numero aleatorio
syscall
add $a0, $a0, 0 #valor minimo do numero aleatorio
add $v0, $a0, $0
jr $ra

gerarNumeroRandomVert:
add $a0, $t5, $0
move $a1, $a0	#valor maximo do numero aleatorio
li $v0, 42	#gerar numero aleatorio
syscall
add $a0, $a0, 0 #valor minimo do numero aleatorio
add $v0, $a0, $0
jr $ra

gerarAxRandom:
li $a1, 2	#valor maximo do numero aleatorio
li $v0, 42	#gerar numero aleatorio
syscall
add $a0, $a0, 0 #valor minimo do numero aleatorio
add $v0, $a0, $0
jr $ra




zerarTabuleiro:
#t1 -> i
#t2 -> '0'

la $a0, tabuleiro
add $t1, $0, $0
li $t2, '0'
zerar_tabuleiro_for:
	bge $t1, 100, sair_zerar_tabuleiro_for		# i >= 100 sai do ciclo
	sw $t2, 0($a0)
	addi $a0, $a0, 4
	addi $t1, $t1, 1
	j zerar_tabuleiro_for
sair_zerar_tabuleiro_for:
jr $ra


displayTabuleiro:
#a0 -> tabuleiro
#t1 -> i
#t2 -> j
#t3 -> endereço
#t4 -> val do endereço
la $s0, tabuleiro
#add $t3, $0, $0
add $t1, $0, $0
#add $t3, $a0, $0
displayTabuleiro_1for:
	bge $t1, 10, sair_displayTabuleiro_1for		# i >= 10 sai do ciclo
	add $t2, $0, $0
	displayTabuleiro_2for:
		bge $t2, 10, sair_displayTabuleiro_2for		# j >= 10 sai do ciclo
		#add $s0, $t3, $0
		#add $t3, $a0, $0
		li $v0, 4
		lw $t4, 0($s0)
		sw $t4, valTabuleiro
		la $a0, valTabuleiro
		syscall
		#add $t3, $t3, 4
		addi $s0, $s0, 4
		addi $t2, $t2, 1
		j displayTabuleiro_2for
	sair_displayTabuleiro_2for:
	li $v0, 4
	la $a0, Enter
	syscall
	addi $t1, $t1, 1
	j displayTabuleiro_1for
sair_displayTabuleiro_1for:
jr $ra
