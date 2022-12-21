.data
frameBuffer:		.space 0x80000

MSGColuna: 		.asciiz "Insira uma coluna \n"
MSGLinha: 		.asciiz "Insira uma linha \n"
Enter:			.asciiz "\n"
JogadaRepetida:		.asciiz "Posicao inserida anteriormente, insira posicao nova \n"
JogadaAgua:		.asciiz "Agua \n"
JogadaBomba:		.asciiz "Bomba \n"
JogadaAfundou:		.asciiz "Afundou \n"
Menu:			.asciiz "Insira 'a' -> Jogar Sozinho / 'b' -> Jogar Vs PC / 'e' -> Sair \n"
teclaMenuErro:		.asciiz "Essa op??o n?o existe no menu, insira um nova op??o \n"
vezJogarPC:		.asciiz "Vez Do Computador \n"
vezJogarUtilizador:	.asciiz "Vez Do Utilizador \n"
editSizeBarcosMenu:	.asciiz "Editar tamanho dos Barcos? 1 -> Editar \n"
editSizeBarcoOption:	.asciiz "0 -> Utilizar Tamanho Padrao / Tamanho maximo de um barco e 10 \n"
editSizeBarco:		.asciiz "Editar tamanho do Barco - "
editNumCarrier:		.asciiz "Insira o numero de barcos Carrier (max de barcos = 10)\n"
editNumBattleship:	.asciiz "Insira o numero de barcos Battleship (max = 10)\n"
editNumDestroyer:	.asciiz "Insira o numero de barcos Destroyer (max = 10)\n"
editNumSubmarine:	.asciiz "Insira o numero de barcos Submarine (max = 10)\n"
editNumPatrol:		.asciiz "Insira o numero de barcos Patrol (max = 10)\n"
barcoCarrier:		.asciiz "Carrier\n"
barcoBattleship:	.asciiz "Battleship\n"
barcoDestroyer:		.asciiz "Destroyer\n"
barcoSubmarine:		.asciiz "Submarine\n"
barcoPatrol:		.asciiz "Patrol\n"
pontosUtilizador:	.asciiz "Pontuacao Utilizador: "
pontosPC:		.asciiz "Pontuacao PC: "

.align 2
tabuleiro: 		.space 400	# Tabuleiro 
tabuleiroPC: 		.space 400	# TabuleiroPC 
copiaTabuleiro:		.space 400	# Copia do tabuleiro (mostrar na tela do jogo)
copiaTabuleiroPC:	.space 400	# Copia do tabuleiroPC (mostrar na tela do jogo)
arrayDePos:		.space 400	# Posi??es para colocar os barcos (usado na fun??o gerarTabuleiro)
valTabuleiro:		.space 400	# Usado para dar display ao tabuleiro FInal
valCopiaTabuleiro:	.space 4	# Usado para dar display ao valor do tabulerio como carater
barcos:			.space 400	# Array com as informa??es de cada barco (1-Numero do Barco (tabuleiro) / 2-Tamnaho / 3-Contador (Verificar Afundou))
barcosPC:		.space 400	# Array com as informa??es de cada barco (1-Numero do Barco (tabuleiro) / 2-Tamnaho / 3-Contador (Verificar Afundou))
carrier:		.space 8	# Braco Carrier (1- Letra / 2- Tamanho)
battleship:		.space 8	# Braco Carrier (1- Letra / 2- Tamanho)
destroyer:		.space 8	# Braco Carrier (1- Letra / 2- Tamanho)
submarine:		.space 8	# Braco Carrier (1- Letra / 2- Tamanho)
patrol:			.space 8	# Braco Carrier (1- Letra / 2- Tamanho)
arrayPontuacao:		.space 8	# Pontuacoes (1 -> Utilizador / 2 -> PC)

.text
.globl main
main:
# $t1 -> opcao
cicloMenu:
	li $v0, 4
	la $a0, Menu
	syscall
	li $v0, 12
	syscall
	add $t1, $v0, $0
	li $v0, 4
	la $a0, Enter
	syscall
	beq $t1, 'e', sairPrograma
		beq $t1, 'a', jogoSozinho
		beq $t1, 'b', jogoPc
		teclaErrada:
		li $v0, 4
		la $a0, teclaMenuErro
		syscall
		j cicloMenu
		jogoSozinho:
		jal fase1Main
		j cicloMenu
		jogoPc:
		#jal fase2Main
		j cicloMenu
	sairPrograma:
	j Exit
j Exit

Exit:
li $v0, 10
syscall


fase1Main:
# $t0 -> endere?o do barco 	// a0
# $s0 -> endere?o do tabuleiro
# $s1 -> endere?o dos barcos
# $t1 -> numero do barco 	//s2
# $t2 -> tamanho do barco 	// t1
# $t3 -> letra do Barco 	//$t2

addi $sp, $sp, -12
sw $ra, 0($sp)
la $s0, tabuleiro
la $s1, barcos
sw $s0, 4($sp)
sw $s1, 8($sp)
addi $t1, $0, 1
jal barcosPadra
jal zerarTabuleiro

la $t0, carrier
lw $t2, 4($t0)
lw $s0, 4($sp)
jal gerarTabuleiro

add $t1, $v0, $0
lw $s1, 8($sp)
addi $s1, $s1, 12
sw $s1, 8($sp)
la $t0, battleship
lw $t2, 4($t0)
lw $s0, 4($sp)
jal gerarTabuleiro

lw $s1, 8($sp)
addi $s1, $s1, 12
sw $s1, 8($sp)
add $t1, $v0, $0
la $t0, destroyer
lw $t2, 4($t0)
lw $s0, 4($sp)
jal gerarTabuleiro

lw $s1, 8($sp)
addi $s1, $s1, 12
sw $s1, 8($sp)
add $t1, $v0, $0
la $t0, submarine
lw $t2, 4($t0)
lw $s0, 4($sp)
jal gerarTabuleiro

lw $s1, 8($sp)
addi $s1, $s1, 12
sw $s1, 8($sp)
add $t1, $v0, $0
la $t0, patrol
lw $t2, 4($t0)
lw $s0, 4($sp)
jal gerarTabuleiro

lw $s0, 4($sp)
#jal displayTabuleiro
la $s1, barcos
jal jogo

lw $ra, 0($sp)
addi $sp, $sp, 12
jr $ra




jogo:
# a0 -> endere?o dos barcos
# a1 -> endereco do tabulerio 		// s0
# $s0 -> endere?o do copiaTabuleiro  	//s1
# $t1 -> char coluna
# $t2 -> numero linha
# $t3 -> posi??o escolhida pelo utilizador final / size do barco acertado
# $t4 -> valores dos tabuleiros
# $t5 -> Valor a por no tabuleiro (X -> Bomba / 0 -> Agua)
# $t6 -> contadores de barcos

add $sp, $sp, -16
sw $ra, 0($sp)
add $a0, $s1, $0
add $a1, $s0, $0
la $s0, copiaTabuleiro
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $s0, 12($sp)
jal zerarTabuleiroCopia
cicloJogo:
	jal displayTabuleiroJogo
	posUtilizador:
	lw $a0, 4($sp)
	li $v0, 12
	syscall
	add $t1, $v0, $0
	li $v0, 5
	syscall
	add $t2, $v0, $0
	addi $t1, $t1, -97	# Passar de A -> 1, b -> 2 etc... (96 ? o valor de A)
	bge $t1, 10, posUtilizador
	bge $t2, 10, posUtilizador
	mul $t1, $t1, 4
	mul $t2, $t2, 40
	add $t3, $t1, $t2
	bge $t3, 400, posUtilizador
	
	lw $a1, 8($sp)
	la $t0, copiaTabuleiro
	add $t0, $t0, $t3
	lw $t4, 0($t0)
	bne $t4, '-', jogadaRepetida
		add $a1, $a1, $t3
		lw $t4, 0($a1)
		beq $t4, '-', aguaJogada
		lw $a0, 4($sp)
		cicloVerArrayBarco:
			lw $t6, 0($a0)
			bne $t4, $t6, incrementar_a0
			lw $t3, 4($a0)
			lw $t6, 8($a0)
			addi $t6, $t6, 1
			sw $t6, 8($a0)
			la $t5, 'X'
			sw $t5, 0($t0)
			jal displayTabuleiroJogo
			bne $t3, $t6, acertouJogada
				li $v0, 4
				la $a0, JogadaAfundou
				syscall
			acertouJogada:
			li $v0, 4
			la $a0, JogadaBomba
			syscall
			j chekarSeTodosBarcosAfundaram
			incrementar_a0:
			addi $a0, $a0, 12 
			j cicloVerArrayBarco
		aguaJogada:
		la $t5, '0'
		sw $t5, 0($t0)
		jal displayTabuleiroJogo
		li $v0, 4
		la $a0, JogadaAgua
		syscall
		j posUtilizador

		chekarSeTodosBarcosAfundaram:
		lw $a0, 4($sp)
		# t4 -> barco
		# t5 -> size barco
		# t6 -> contador barco
		ciclo_chekarSeTodosBarcosAfundaram:
		lw $t4, 0($a0)
		lw $t5, 4($a0)
		lw $t6, 8($a0)
		bne $t5, $t6, posUtilizador
		bge $t4, 100, sairJogo
		add $a0, $a0, 12
		j ciclo_chekarSeTodosBarcosAfundaram
	jogadaRepetida:
	li $v0, 4
	la $a0, JogadaRepetida
	syscall
	j posUtilizador
j cicloJogo

sairJogo:
zerarArrayBarcos:
lw $a0, 4($sp)
# t4 -> barco
# t5 -> size barco
# t6 -> contador barco
ciclo_zerarArrayBarcos:
lw $t4, 0($a0)
bge $t4, 100, sairJogoDepoisDeZerar
add $t4, $0, $0
sw $t4, 0($a0)
add $a0, $a0, 12
j ciclo_zerarArrayBarcos

sairJogoDepoisDeZerar:
add $t4, $0, $0
sw $t4, 0($a0)
lw $ra, 0($sp)
add $sp, $sp, 16
jr $ra



displayTabuleiro:
#a0 -> tabuleiro
#t9 -> i
#t8 -> j
#t4 -> val do endere?o
# t5 -> pos atual
add $sp, $sp, -4
add $a0, $s0, $0
sw $a0, 0($sp)
add $t9, $0, $0
add $t5, $0, $0
displayTabuleiro_1for:
	bge $t9, 10, sair_displayTabuleiro_1for		# i >= 10 sai do ciclo
	add $t8, $0, $0
	displayTabuleiro_2for:
		bge $t8, 10, sair_displayTabuleiro_2for		# j >= 10 sai do ciclo
		lw $t4, 0($a0)
		beq $t4, '-', printString
		li $v0, 1
		move $a0, $t4
		syscall
		j increment_displayTabuleiro_2for
		printString:
		li $v0, 4
		sw $t4, valTabuleiro
		la $a0, valTabuleiro
		syscall
		j increment_displayTabuleiro_2for
		increment_displayTabuleiro_2for:
		addi $t5, $t5, 4
		lw $a0, 0($sp)
		add $a0, $a0, $t5
		addi $t8, $t8, 1
		j displayTabuleiro_2for
	sair_displayTabuleiro_2for:
	li $v0, 4
	la $a0, Enter
	syscall
	lw $a0, 0($sp)
	add $a0, $a0, $t5
	addi $t9, $t9, 1
	j displayTabuleiro_1for
sair_displayTabuleiro_1for:
li $v0, 4
la $a0, Enter
syscall
add $sp, $sp, 4
jr $ra

displayTabuleiroJogo:
#a0 -> tabuleiro
#t1 -> i
#t2 -> j
#t3 -> endere?o
#t4 -> val do endere?o
# $t5 -> valor da posicao do array tabuleiro

add $sp, $sp, -4
la $s0, copiaTabuleiro
sw $s0, 0($sp)
add $t1, $0, $0
displayTabuleiroJogo_1for:
	bge $t1, 10, sair_displayTabuleiroJogo_1for		# i >= 10 sai do ciclo
	add $t2, $0, $0
	displayTabuleiroJogo_2for:
		bge $t2, 10, sair_displayTabuleiroJogo_2for		# j >= 10 sai do ciclo
		lw $t4, 0($s0)
		beq $t4, '-', printStringJogo
		beq $t4, '0', printStringJogo
		beq $t4, 'X', printStringJogo
		li $v0, 1
		move $a0, $t4
		syscall
		lw $s0, 0($sp)
		j incrementarS0
		printStringJogo:
		li $v0, 4
		sw $t4, valCopiaTabuleiro
		la $a0, valCopiaTabuleiro
		syscall
		lw $s0, 0($sp)
		incrementarS0:
		addi $s0, $s0, 4
		sw $s0, 0($sp)
		addi $t2, $t2, 1
		j displayTabuleiroJogo_2for
	sair_displayTabuleiroJogo_2for:
	li $v0, 4
	la $a0, Enter
	syscall
	lw $s0, 0($sp)
	addi $t1, $t1, 1
	j displayTabuleiroJogo_1for
sair_displayTabuleiroJogo_1for:
li $v0, 4
la $a0, Enter
syscall
add $sp, $sp, 4
jr $ra

zerarTabuleiroCopia:
# a0 -> endereco de copiaTabuleiro
#t9 -> i
#t2 -> '0'

#la $a0, copiaTabuleiro
add $a0, $s0, $0
add $t9, $0, $0
li $t2, '-'
zerar_tabuleiroCopia_for:
	bge $t9, 100, sair_zerar_tabuleiroCopia_for		# i >= 100 sai do ciclo
	sw $t2, 0($a0)
	addi $a0, $a0, 4
	addi $t9, $t9, 1
	j zerar_tabuleiroCopia_for
sair_zerar_tabuleiroCopia_for:
jr $ra


gerarTabuleiro:
# $a0 -> Size do Barco
# $a1 -> Numero do Barco
# $a2 -> array dos barcos
# $t8 -> Posicoes das Pecas do Barco
# $t1 -> posi??o do barco antes de chackar se vazia / posi??o do barco para add Letra
# $t2 -> Valor na Pos do tabuleiro
# $t3 -> Axis (Horizontal = 0 / Vertical = 1)
# $t4 -> valor para valida??es como numero max etc.. / recebe o valor de uma posi??o do tabuleiro para teste de posi??es com '0'
# $t5 -> size Barco *4
# $t6 -> Saber se vou validar cima/baixo 	(0 -> validar ambas / 1 -> nao validar cima / 2 -> n?o validar baixo)
# $t7 -> Saber se vou validar esquerda/direita 	(0 -> validar / 1 -> nao validar esquerda / 2 -> n?o validar direita)
# $t9 -> I

add $sp, $sp, -20	# Baixar a Stack
sw $ra, 0($sp)		# Guardar o $ra desta fun??o
add $a0, $t2, $0	# Guardar o Size do Barco em $a0
add $a1, $t1, $0	# Guardar a Numero do Barco em $a1
add $a2, $s1, $0	# Endereco do barco
add $a3, $s0, $0	# Endereco do tabuleiro
sw $a0, 4($sp)		# Guardo o Size do Barco na stack pq vou perder o valor de $a0 noutras funcoes
sw $a1, 8($sp)		# Guardo a Numero do Barco na stack pq vou perder o valor de $a1 noutras funcoes
sw $a2, 12($sp)		# Guardo a Enderco do Barco na stack pq vou perder o valor de $a1 noutras funcoes
sw $a3, 16($sp)		# Guardar o endereco do tauleiro na stack
la $t8, arrayDePos	# Guardar o endere?o do arrayDePos em $t8
gerarPos:
	add $t1, $0, $0
	add $t2, $0, $0
	add $t3, $0, $0
	add $t4, $0, $0
	add $t5, $0, $0
	add $t6, $0, $0
	add $t7, $0, $0
	jal gerarAxRandom		# Fun??o que gera Numero entre 0 < 2
	add $t3, $v0, $0		# Guarda o valor que vai ser usado para saber em que direcao adicionar as pecas do barco
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
	lw $a3, 16($sp)
	beq $t3, 0, validacoesHor
	validacoesVert:
		addi $t4, $0, 100		# Igualo $t4 = 100 (valor maximo do tabuleiro sem ser multiplicado por 4 / 0-100)
		add $t5, $a0, -1		# Size do barco -1
		mul $t5, $t5, 10		# (Size do barco-1) * 10
		sub $t4, $t4, $t5		# 100 - ((Size do barco-1) * 10) / Usado para saber o limite do numero gerado na fun??o gerarNumeroRandomVert (tabuleiro sem ser multiplicado por 4 / 0-100)
		jal gerarNumeroRandomVert	# Fun??o que gera Numero entre 0 < 60
		add $t1, $v0, $0		# Guarda a primeira posi??op gerada pela fun??o "gerarNumeroRandom"

		jal validarCima		# Chama fun??o que vai validar se vou precisar validar a linha de cima
		add $t6, $v0, $0		# recebe o valor da fun??o
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
		j sairValidarCimaBaixo		# se $t6 = 1 ent?o estou na primeira linha e n?o preciso de fazer "validarLinhaBaixo"
		
		jal validarBaixo
		add $t6, $v0, $0
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
		
		sairValidarCimaBaixo:
		mul $t1, $t1, 4			# Multiplicar essa posi??o para ser usada nos arrays
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
	j sair_validacoes
	validacoesHor:
		jal gerarNumeroRandom		# Fun??o que gera Numero entre 0 < 100
		add $t1, $v0, $0		# Guarda a primeira posi??op gerada pela fun??o "gerarNumeroRandom"
		mul $t1, $t1, 4			# Multiplicar essa posi??o para ser usada nos arrays
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
		mul $t5, $a0, 4			# Size do barco * 4
		Hor_t1_entre_0_36:		# Testes na primeira linha
		bge $t1, 40, Hor_t1_entre_40_76		# if($t1 >= 40) vai para o teste da 2? linha
			addi $t4, $0, 40		# $t4 = 40 ultima celula/coluna da linha
			sub $t4, $t4, $t5		# 40- (size do barco * 4) = ? linha que ele pode ser colocado e n?o passar o limite da linha (ex: 36 passa a 20 num barco de size 5 assim vai do meio da linha at? ao fim nem ultrapassar)
			addi $t6, $0, 1			# Igual $t6 a 1 para saber que n?o vou validar a linha de cima (pois n?o existe)
			ble $t1, $t4, sair_validacoes	# se a posi??o que o barco vai ser colocado for maior que 40 - (size do barco * 4) ent mete o barco em $t4 (ex: 36 passa a 20 num barco de size 5 assim vai do meio da linha at? ao fim nem ultrapassar)
			add $t1, $0, $t4		# iguala $t1 a $t4
			j sair_validacoes		# sair das valida??es
		Hor_t1_entre_40_76:			# Mesma coisa da de cima mas para a 2? linha
		bge $t1, 80, Hor_t1_entre_80_116
			addi $t4, $0, 80
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_80_116:			# Mesma coisa da de cima mas para a 3? linha
		bge $t1, 120, Hor_t1_entre_120_156
			addi $t4, $0, 120
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_120_156:			# Mesma coisa da de cima mas para a 4? linha
		bge $t1, 160, Hor_t1_entre_160_196
			addi $t4, $0, 160
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_160_196:			# Mesma coisa da de cima mas para a 5? linha
		bge $t1, 200, Hor_t1_entre_200_236
			addi $t4, $0, 200
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes	
		Hor_t1_entre_200_236:			# Mesma coisa da de cima mas para a 6? linha
		bge $t1, 240, Hor_t1_entre_240_276
			addi $t4, $0, 240
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_240_276:			# Mesma coisa da de cima mas para a 7? linha
		bge $t1, 280, Hor_t1_entre_280_316
			addi $t4, $0, 280
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_280_316:			# Mesma coisa da de cima mas para a 8? linha
		bge $t1, 320, Hor_t1_entre_320_356
			addi $t4, $0, 320
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_320_356:			# Mesma coisa da de cima mas para a 9? linha
		bge $t1, 360, Hor_t1_entre_360_396
			addi $t4, $0, 360
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_360_396:			# Mesma coisa da de cima mas para a 10? linha
		bge $t1, 400, sair_validacoes
			addi $t4, $0, 400
			sub $t4, $t4, $t5
			addi $t6, $0, 2			# Igual $t6 a 2 para saber que n?o vou validar a linha de baixo (pois n?o existe)
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
			
	sair_validacoes:
	add $a3, $a3, $t1		# Meter $a3 na posi??o gerada aleat?riamente
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
	
	jal validacoesEsquerda		# chama a fun??o que valida se vou ter de validar o lado esquerdo da posi??o
	add $t7, $v0, $0
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
	beq $t7, 1, validacoesPosicoes	# Se $t7 = 1 quer dizer q n vou validar ? esquerda ent n?o preciso de ver a "validacoesDireita"
	
	jal validacoesDireita		# chama a fun??o que valida se vou ter de validar o lado esquerdo da posi??o
	add $t7, $v0, $0
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
	
	validacoesPosicoes:
	lw $t4, 0($a3)			# Recebe o valor do tabuleiro
	bne $t4, '-', gerarPos
	j mainTeste1			# else salta para o prox teste
	mainTeste1:
	beq $t6, 1, mainTeste2		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
	lw $t4, -40($a3)		# recebe o valor da linha de cima do tabulerio
	bne $t4, '-', gerarPos
	j mainTeste2			# else salta para o prox teste
	mainTeste2:
	beq $t6, 1, mainTeste3		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
	beq $t7, 2, mainTeste3		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
	lw $t4, -36($a3)		# recebe o valor da diagonal cima ? direita de cima do tabulerio
	bne $t4, '-', gerarPos
	j mainTeste3			# else salta para o prox teste
	mainTeste3:
	beq $t7, 2, mainTeste4		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
	lw $t4, 4($a3)			# recebe o valor da direita do tabulerio
	bne $t4, '-', gerarPos
	j mainTeste4			# else salta para o prox teste
	mainTeste4:
	beq $t6, 2, mainTeste5		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
	beq $t7, 2, mainTeste5		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
	lw $t4, 44($a3)			# recebe o valor da diagonal baixo ? direita do tabulerio
	bne $t4, '-', gerarPos
	j mainTeste5			# else salta para o prox teste
	mainTeste5:
	beq $t6, 2, mainTeste6		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
	lw $t4, 40($a3)			# recebe o valor da linha de baixo do tabulerio
	bne $t4, '-', gerarPos
	j mainTeste6			# else salta para o prox teste
	mainTeste6:
	beq $t6, 2, mainTeste7		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
	beq $t7, 1, mainTeste7		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
	lw $t4, 36($a3)			# recebe o valor da diagonal baixo ? esquerda do tabulerio
	bne $t4, '-', gerarPos
	j mainTeste7			# else salta para o prox teste
	mainTeste7:
	beq $t7, 1, mainTeste8		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
	lw $t4, -4($a3)			# recebe o valor da esquerda do tabulerio
	bne $t4, '-', gerarPos
	j mainTeste8			# else salta para o prox teste
	mainTeste8:
	beq $t6, 1, sairTeste		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
	beq $t7, 1, sairTeste		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
	lw $t4, -44($a3)		# recebe o valor da diagonal de cima ? esquerda do tabulerio
	bne $t4, '-', gerarPos
	j sairTeste			# else salta para o prox teste
	
	sairTeste:
	addi $t9, $0, 0			# i = 0
	forSizeBarco:
		beq $t9, $a0, breakForSizeBarco	# If(I < Size) SAI -> breakForSizeBarco
		lw $t2, 0($a3)			# Recebe o valor dessa posi??o em $t2
		bne $t2, '-', gerarPos	
		beq $t3, 0, fazHorizontal	# If($t3 == 0) ($t2 = 0 -> Horizontal / $t2 = 1 -> Vertical)
		fazVertical:
			addi $a3, $a3, 40		# Ando para baixo no tabuleiro
			sw $t1, 0($t8)			# Guarda o valor de $t1 em $t8(array com as posi??es onde v?o ser inseridas as letras do barco no tabuleiro)
			addi $t1, $t1, 40		# $t1 + 40 para andar para baixo no tabuleiro (v?rias pe?as do barco)
			
			jal validarBaixo
			add $t6, $v0, $0
			lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
			
			validacoesPosicoesVert:
			lw $t4, 0($a3)			# Recebe o valor do tabuleiro
			bne $t4, '-', gerarPos
			j vertTeste1			# else salta para o prox teste
			vertTeste1:
			beq $t6, 1, vertTeste2		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			beq $t7, 2, vertTeste2		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, -36($a3)		# recebe o valor da diagonal cima ? direita de cima do tabulerio
			bne $t4, '-', gerarPos
			j vertTeste2			# else salta para o prox teste
			vertTeste2:
			beq $t7, 2, vertTeste3		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, 4($a3)			# recebe o valor da direita do tabulerio
			bne $t4, '-', gerarPos
			j vertTeste3			# else salta para o prox teste
			vertTeste3:
			beq $t6, 2, vertTeste4		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			beq $t7, 2, vertTeste4		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, 44($a3)			# recebe o valor da diagonal baixo ? direita do tabulerio
			bne $t4, '-', gerarPos
			j vertTeste4			# else salta para o prox teste
			vertTeste4:
			beq $t6, 2, vertTeste5		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			lw $t4, 40($a3)			# recebe o valor da linha de baixo do tabulerio
			bne $t4, '-', gerarPos
			j vertTeste5			# else salta para o prox teste
			vertTeste5:
			beq $t6, 2, vertTeste6		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			beq $t7, 1, vertTeste6		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			lw $t4, 36($a3)			# recebe o valor da diagonal baixo ? esquerda do tabulerio
			bne $t4, '-', gerarPos
			j vertTeste6			# else salta para o prox teste
			vertTeste6:
			beq $t7, 1, vertTeste7		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, -4($a3)			# recebe o valor da esquerda do tabulerio
			bne $t4, '-', gerarPos
			j vertTeste7			# else salta para o prox teste
			vertTeste7:
			beq $t6, 1, sairTesteVert	# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			beq $t7, 1, sairTesteVert	# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			lw $t4, -44($a3)		# recebe o valor da diagonal de cima ? esquerda do tabulerio
			bne $t4, '-', gerarPos
			j sairTesteVert			# else salta para o prox teste
			
			sairTesteVert:
			j sairDeAxis
		fazHorizontal:
			addi $a3, $a3, 4		# Ando para a direita no tabuleiro
			sw $t1, 0($t8)			# Guarda o valor de $t1 em $t8(array com as posi??es onde v?o ser inseridas as letras do barco no tabuleiro)
			addi $t1, $t1, 4		# $t1 + 4 para andar para a direita no tabuleiro (v?rias pe?as do barco)
			
			jal validacoesDireita		# chama a fun??o que valida se vou ter de validar o lado esquerdo da posi??o
			add $t7, $v0, $0
			lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
			
			validacoesPosicoesHor:
			lw $t4, 0($a3)			# Recebe o valor do tabuleiro
			bne $t4, '-', gerarPos
			j horTeste1			# else salta para o prox teste
			horTeste1:
			beq $t6, 1, horTeste2		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			lw $t4, -40($a3)		# recebe o valor da linha de cima do tabulerio
			bne $t4, '-', gerarPos
			j horTeste2			# else salta para o prox teste
			horTeste2:
			beq $t6, 1, horTeste3		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			beq $t7, 2, horTeste3		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, -36($a3)		# recebe o valor da diagonal cima ? direita de cima do tabulerio
			bne $t4, '-', gerarPos
			j horTeste3			# else salta para o prox teste
			horTeste3:
			beq $t7, 2, horTeste4		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, 4($a3)			# recebe o valor da direita do tabulerio
			bne $t4, '-', gerarPos
			j horTeste4			# else salta para o prox teste
			horTeste4:
			beq $t6, 2, horTeste5		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			beq $t7, 2, horTeste5		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, 44($a3)			# recebe o valor da diagonal baixo ? direita do tabulerio
			bne $t4, '-', gerarPos
			j horTeste5			# else salta para o prox teste
			horTeste5:
			beq $t6, 2, horTeste6		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			lw $t4, 40($a3)			# recebe o valor da linha de baixo do tabulerio
			bne $t4, '-', gerarPos
			j horTeste6			# else salta para o prox teste
			horTeste6:
			beq $t6, 2, horTeste7		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			beq $t7, 1, horTeste7		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			lw $t4, 36($a3)			# recebe o valor da diagonal baixo ? esquerda do tabulerio
			bne $t4, '-', gerarPos
			j horTeste7			# else salta para o prox teste
			horTeste7:
			beq $t6, 1, sairTesteHor	# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			beq $t7, 1, sairTesteHor	# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			lw $t4, -44($a3)		# recebe o valor da diagonal de cima ? esquerda do tabulerio
			bne $t4, '-', gerarPos
			j sairTesteHor			# else salta para o prox teste
			
			sairTesteHor:
			j sairDeAxis
		sairDeAxis:
		addi $t8, $t8, 4		# Mudar de posi??o do vetor
		addi $t9, $t9, 1		# I++
		j forSizeBarco
breakForSizeBarco:
lw $a0, 4($sp)		# Receber da stack o valor de $a0 (size do Braco)
lw $a1, 8($sp)		# Receber da stack a letra do barco
lw $a3, 16($sp)
addi $t9, $0 0		# I = 0
forAddBarco:
	beq $t9, $a0, addBarcoArrayBarcos	# If(I < Size) SAI -> breakForSizeBarco
	addi $t8, $t8, -4			# Baixa as posi??es do vetor de $t8(posi??es das pe?as do barco)
	lw $t1, 0($t8)				# Recebe o valor de $t8(posi??es do tabuleiro) para $t1	
	lw $a3, 16($sp)
	add $a3, $a3, $t1			# Anda no tabuleiro para as v?rias posi??es
	sw $a1, 0($a3)				# Guarda o valor de $a1(letra do barco) na posi??o $a3(tabuleiro)
	addi $t9, $t9, 1			# I++
	j forAddBarco
addBarcoArrayBarcos:
	lw $a0, 4($sp)		# Receber da stack o valor de $a0 (size do Braco)
	lw $a1, 8($sp)		# Receber da stack a letra do barco
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	sw $a1, 0($a2)
	addi $a2, $a2, 4
	sw $a0, 0($a2)
	addi $a2, $a2, 4
	sw $0, 0($a2)
	addi $a2, $a2, 4
	addi $t9, $0, 100	# Usar $t9 para meter -1 valor que vai ser usado como fim do array dos barcos
	sw $t9, 0($a2)		# Numero 0 no fim do array usado depois para valida??es noutras fun??es ex: jogo (para saber o fim do array dos barcos)
sairGerarBarco:
addi $v0, $a1, 1
lw $ra, 0($sp)
addi $sp, $sp, 20
jr $ra




zerarTabuleiro:
# $a0 -> endere?o tabuleiro
#t9 -> i
#t2 -> '0'

#la $a0, tabuleiro
add $a0, $s0, $0
add $t9, $0, $0
li $t2, '-'
zerar_tabuleiro_for:
	bge $t9, 100, sair_zerar_tabuleiro_for		# i >= 100 sai do ciclo
	sw $t2, 0($a0)
	addi $a0, $a0, 4
	addi $t9, $t9, 1
	j zerar_tabuleiro_for
sair_zerar_tabuleiro_for:
jr $ra


barcosEdit:
# $t0 -> endere?o do barco	//s0
# $t2 -> tamanho do barco	//t0
# $t1 -> valores

li $v0, 4
la $a0, editSizeBarcoOption
syscall
li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoCarrier
syscall
li $v0, 5
syscall
add $t2, $v0, $0

carrierBarcoEdit:
la $t0, carrier
la $t1, 'C'
sw $t1, 0($t0)
ble $t2, 0, tamanhoPadraoCarrier
add $t1, $0, $t2
j skipEditCarrier
tamanhoPadraoCarrier:
addi $t1, $0, 5
skipEditCarrier:
sw $t1, 4($t0)

li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoBattleship
syscall
li $v0, 5
syscall
add $t2, $v0, $0

battleshipBarcoEdit:
la $t0, battleship
la $t1, 'B'
sw $t1, 0($t0)
ble $t2, 0, tamanhoPadraoBattleship
add $t1, $0, $t2
j skipEditBattleship
tamanhoPadraoBattleship:
addi $t1, $0, 4
skipEditBattleship:
sw $t1, 4($t0)

li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoDestroyer
syscall
li $v0, 5
syscall
add $t2, $v0, $0

destroyerBarcoEdit:
la $t0, destroyer
la $t1, 'D'
sw $t1, 0($t0)
ble $t2, 0, tamanhoPadraoDestroyer
add $t1, $0, $t2
j skipEditDestroyer
tamanhoPadraoDestroyer:
addi $t1, $0, 3
skipEditDestroyer:
sw $t1, 4($t0)

li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoSubmarine
syscall
li $v0, 5
syscall
add $t2, $v0, $0

submarineBarcoEdit:
la $t0, submarine
la $t1, 'S'
sw $t1, 0($t0)
ble $t2, 0, tamanhoPadraoSubmarine
add $t1, $0, $t2
j skipEditSubmarine
tamanhoPadraoSubmarine:
addi $t1, $0, 3
skipEditSubmarine:
sw $t1, 4($t0)

li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoPatrol
syscall
li $v0, 5
syscall
add $t2, $v0, $0

patrolBarcoEdit:
la $t0, patrol
la $t1, 'P'
sw $t1, 0($t0)
ble $t2, 0, tamanhoPadraoPatrol
add $t1, $0, $t2
j skipEditPatrol
tamanhoPadraoPatrol:
addi $t1, $0, 2
skipEditPatrol:
sw $t1, 4($t0)
jr $ra


barcosPadra:
# $t0 -> endere?o do barco
# $t9 -> valores
carrierBarcoPadrao:
la $t0, carrier
la $t9, 'C'
sw $t9, 0($t0)
addi $t9, $0, 5
sw $t9, 4($t0)
battleshipBarcoPadrao:
la $t0, battleship
la $t9, 'B'
sw $t9, 0($t0)
addi $t9, $0, 4
sw $t9, 4($t0)
destroyerBarcoPadrao:
la $t0, destroyer
la $t9, 'D'
sw $t9, 0($t0)
addi $t9, $0, 3
sw $t9, 4($t0)
submarineBarcoPadrao:
la $t0, submarine
la $t9, 'S'
sw $t9, 0($t0)
addi $t9, $0, 3
sw $t9, 4($t0)
patrolBarcoPadrao:
la $t0, patrol
la $t9, 'P'
sw $t9, 0($t0)
addi $t9, $0, 2
sw $t9, 4($t0)
jr $ra



gerarLinhaColunaRandom:
li $a1, 10	#valor maximo do numero aleatorio
li $v0, 42	#gerar numero aleatorio
syscall
add $a0, $a0, 0 #valor minimo do numero aleatorio
add $v0, $a0, $0
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


validarCima:
add $v0, $t6, $0
add $a0, $t1, $0
bge $a0, 10, sairValidarCima	# if($t1 >= 10) salta para o prox teste pois n?o estamos na primeira linha
addi $v0, $0, 1			# Igual $t6 a 1 para saber que n?o vou validar a linha de cima (pois n?o existe)
sairValidarCima:
jr $ra
	
validarBaixo:
add $v0, $t6, $0
add $a0, $t1, $0
blt $a0, 90, sairValidarBaixo	# if($t1 < 90) sai dos testes pois n?o estamos na linha de baixo
addi $v0, $0, 2			# Igual $t6 a 2 para saber que n?o vou validar a linha de baixo (pois n?o existe)
sairValidarBaixo:
jr $ra

validacoesEsquerda:
add $v0, $t7, $0
add $a0, $t1, $0				# Valida??es para saber se vou validar ? esquerda (basicamente saber se esta posi??o ? a mais ? esquerda da linha pois ? a unica que n?o precisa validar ? esquerda)
	bne $a0, 0, t7Test1_Esq			# if($t1 != 0)	valor ? esquerda da 1? linha salta para prox teste
		addi $v0, $0, 1			# else adiciona 1 a $t7 para saber que n?o vou validar ? esquerda
		j validacoesEsquerdaSair	# Salta para as validacoes das posi??es ? volta
	t7Test1_Esq:
	bne $a0, 40, t7Test2_Esq		# Mesmo da valida??o de cima mas para a 2? linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test2_Esq:
	bne $a0, 80, t7Test3_Esq		# Mesmo da valida??o de cima mas para a 3? linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test3_Esq:
	bne $a0, 120, t7Test4_Esq		# Mesmo da valida??o de cima mas para a 4? linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test4_Esq:
	bne $a0, 160, t7Test5_Esq		# Mesmo da valida??o de cima mas para a 5? linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test5_Esq:
	bne $a0, 200, t7Test6_Esq		# Mesmo da valida??o de cima mas para a 6? linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test6_Esq:
	bne $a0, 240, t7Test7_Esq		# Mesmo da valida??o de cima mas para a 7? linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test7_Esq:
	bne $a0, 280, t7Test8_Esq		# Mesmo da valida??o de cima mas para a 8? linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test8_Esq:
	bne $a0, 320, t7Test9_Esq		# Mesmo da valida??o de cima mas para a 9? linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test9_Esq:
	bne $a0, 360, validacoesEsquerdaSair	# Mesmo da valida??o de cima mas para a 10? linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
validacoesEsquerdaSair:
jr $ra

validacoesDireita:		# Valida??es para saber se vou validar ? direita (basicamente saber se esta posi??o ? a mais ? direita da linha pois ? a unica que n?o precisa validar ? direita)
add $v0, $t7, $0
add $a0, $t1, $0
	bne $a0, 36, t7Test1_Dir	# if($t1 != 0)	valor ? direita da 1? linha salta para prox teste
		addi $v0, $0, 2		# else adiciona 1 a $t7 para saber que n?o vou validar ? direita
		j validacoesDireitaSair	# Salta para as validacoes das posi??es ? volta
	t7Test1_Dir:
	bne $a0, 76, t7Test2_Dir	# Mesmo da valida??o de cima mas para a 2? linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test2_Dir:
	bne $a0, 116, t7Test3_Dir	# Mesmo da valida??o de cima mas para a 3? linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test3_Dir:
	bne $a0, 156, t7Test4_Dir	# Mesmo da valida??o de cima mas para a 4? linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test4_Dir:
	bne $a0, 196, t7Test5_Dir	# Mesmo da valida??o de cima mas para a 5? linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test5_Dir:
	bne $a0, 236, t7Test6_Dir	# Mesmo da valida??o de cima mas para a 6? linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test6_Dir:
	bne $a0, 276, t7Test7_Dir	# Mesmo da valida??o de cima mas para a 7? linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test7_Dir:
	bne $a0, 316, t7Test8_Dir	# Mesmo da valida??o de cima mas para a 8? linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test8_Dir:
	bne $a0, 356, t7Test9_Dir	# Mesmo da valida??o de cima mas para a 9? linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test9_Dir:
	bne $a0, 396, validacoesDireitaSair	# Mesmo da valida??o de cima mas para a 10? linha
		addi $v0, $0, 2
		j validacoesDireitaSair
validacoesDireitaSair:
jr $ra

rectangleBarco:
# $a0 is xmin (i.e., left edge; must be within the display)
# $a1 is width (must be nonnegative and within the display)
# $a2 is ymin  (i.e., top edge, increasing down; must be within the display)
# $a3 is height (must be nonnegative and within the display)

	beq $a1,$zero,rectangleReturn 	# zero width: draw nothing
	beq $a3,$zero,rectangleReturn 	# zero height: draw nothing

	li $t0,-1 			# color: white
	la $t1,frameBuffer
	add $a1,$a1,$a0 		# simplify loop tests by switching to first too-far value
	add $a3,$a3,$a2
	sll $a0,$a0,2 			# scale x values to bytes (4 bytes per pixel)
	sll $a1,$a1,2
	sll $a2,$a2,11 			# scale y values to bytes (512*4 bytes per display row)
	sll $a3,$a3,11
	addu $t2,$a2,$t1 		# translate y values to display row starting addresses
	addu $a3,$a3,$t1
	addu $a2,$t2,$a0 		# translate y values to rectangle row starting addresses
	addu $a3,$a3,$a0
	addu $t2,$t2,$a1 		# and compute the ending address for first rectangle row
	li $t4,0x800 			# bytes per display row


rectangle:
# $a0 is xmin (i.e., left edge; must be within the display)
# $a1 is width (must be nonnegative and within the display)
# $a2 is ymin  (i.e., top edge, increasing down; must be within the display)
# $a3 is height (must be nonnegative and within the display)

	beq $a1,$zero,rectangleReturn 	# zero width: draw nothing
	beq $a3,$zero,rectangleReturn 	# zero height: draw nothing

	#li $t0,-1 			# color: white
	add $t0, $0, $t9
	la $t1,frameBuffer
	add $a1,$a1,$a0 		# simplify loop tests by switching to first too-far value
	add $a3,$a3,$a2
	sll $a0,$a0,2 			# scale x values to bytes (4 bytes per pixel)
	sll $a1,$a1,2
	sll $a2,$a2,11 			# scale y values to bytes (512*4 bytes per display row)
	sll $a3,$a3,11
	addu $t2,$a2,$t1 		# translate y values to display row starting addresses
	addu $a3,$a3,$t1
	addu $a2,$t2,$a0 		# translate y values to rectangle row starting addresses
	addu $a3,$a3,$a0
	addu $t2,$t2,$a1 		# and compute the ending address for first rectangle row
	li $t4,0x800 			# bytes per display row

rectangleYloop:
	move $t3,$a2 			# pointer to current pixel for X loop; start at left edge

rectangleXloop:
	sw $t0,($t3)
	addiu $t3,$t3,4
	bne $t3,$t2,rectangleXloop 	# keep going if not past the right edge of the rectangle

	addu $a2,$a2,$t4 		# advace one row worth for the left edge
	addu $t2,$t2,$t4 		# and right edge pointers
	bne $a2,$a3,rectangleYloop 	# keep going if not off the bottom of the rectangle

rectangleReturn:
	jr $ra
