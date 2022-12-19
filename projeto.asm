.data
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

.text
.globl main
main:
# $t1 -> op??o
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
		jal fase2Main
		j cicloMenu
	sairPrograma:
	j Exit
j Exit

Exit:
li $v0, 10
syscall





fase1Main:
# $a0 -> endere?o do barco
# $s0 -> endere?o do tabuleiro
# $s1 -> endere?o dos barcos
# $s2 -> numero do barco
# $t1 -> tamanho do barco
# $t2 -> letra do Barco

la $s1, barcos
addi $s2, $0, 1
addi $sp, $sp, -4
sw $ra, 0($sp)
jal barcosPadra
la $s0, tabuleiro
jal zerarTabuleiro
la $a0, carrier
#lw $t2, 0($a0)
lw $t1, 4($a0)
#addi $t1, $0, 5
#li $t2, 'C'
la $s0, tabuleiro
jal gerarTabuleiro
la $s0, tabuleiro
addi $s1, $s1, 12
add $s2, $v0, $0
la $a0, battleship
lw $t2, 0($a0)
lw $t1, 4($a0)
#addi $t1, $0, 4
#li $t2, 'B'
la $s0, tabuleiro
jal gerarTabuleiro
addi $s1, $s1, 12
add $s2, $v0, $0
la $a0, destroyer
#lw $t2, 0($a0)
lw $t1, 4($a0)
#addi $t1, $0, 3
#li $t2, 'D'
la $s0, tabuleiro
jal gerarTabuleiro
la $s0, tabuleiro
addi $s1, $s1, 12
add $s2, $v0, $0
la $a0, submarine
#lw $t2, 0($a0)
lw $t1, 4($a0)
#addi $t1, $0, 3
#li $t2, 'S'
la $s0, tabuleiro
jal gerarTabuleiro
la $s0, tabuleiro
addi $s1, $s1, 12
add $s2, $v0, $0
la $a0, patrol
#lw $t2, 0($a0)
lw $t1, 4($a0)
#addi $t1, $0, 2
#li $t2, 'P'
la $s0, tabuleiro
jal gerarTabuleiro

la $s0, tabuleiro
jal displayTabuleiro

la $s1, barcos
jal jogo

lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra




fase2Main:
# $a0 -> endere?o do barco
# $s0 -> endere?o do tabuleiro
# $s1 -> endere?o dos barcos
# $s2 -> numero do barco
# $s3 -> endere?o dos barcosPC
# $s4 -> contador de barcos (max 10)
# $s5 -> I
# $s6 -> contador da pos atual do array de barcos
# $t0 -> Editar tamanho de barcos ou nao (1 -> editar) / numero de barcos (menu utilizador)
# $t1 -> tamanho do barco
# $t2 -> letra do Barco

addi $sp, $sp, -16
sw $ra, 0($sp)
add $s4, $0, $0
sw $s4, 4($sp)
add $s5, $0, $0
sw $s5, 8($sp)
add $s6, $0, $0
sw $s6, 12($sp)
# Tabuleiro Para Jogador

li $v0, 4
la $a0, editSizeBarcosMenu
syscall
li $v0, 5
syscall
add $t0, $v0, $0
beq $t0, 1, editarSizeBarcos
la $s1, barcosPC
#addi $s2, $0, 1
jal barcosPadra
j sairBarcos
la $s1, barcos
jal barcosPadra
editarSizeBarcos:
la $s1, barcosPC
#jal barcosEdit
la $s1, barcos
jal barcosEdit
sairBarcos:
addi $s2, $0, 1
la $s0, tabuleiroPC
jal zerarTabuleiro

#la $s1, barcos
#addi $s2, $0, 1
#jal barcosPadra
la $s0, tabuleiro
jal zerarTabuleiro

numCarrier:
li $v0, 4
la $a0, editNumCarrier
syscall
li $v0, 5
syscall
add $t0, $v0, $0
lw $s5, 8($sp)
cicloNumCarrier:
bge $s5, $t0, numBattleship
lw $s4, 4($sp)
bge $s4, 10, iniciarJogoPC
#Gerar Carrier Utilizador
la $s1, barcos
add $s1, $s1, $s6
la $a0, carrier
lw $t1, 4($a0)
la $s0, tabuleiro
jal gerarTabuleiro
#Gerar Carrier PC
la $s1, barcosPC
add $s1, $s1, $s6
la $a0, carrier
lw $t1, 4($a0)
la $s0, tabuleiroPC
jal gerarTabuleiro
add $s2, $v0, $0
addi $s4, $s4, 1
sw $s4, 4($sp)
addi $s5, $s5, 1
addi $s6, $s6, 12
j cicloNumCarrier

numBattleship:
li $v0, 4
la $a0, editNumBattleship
syscall
li $v0, 5
syscall
add $t0, $v0, $0
lw $s5, 8($sp)
cicloNumBattleship:
bge $s5, $t0, numDestroyer
lw $s4, 4($sp)
bge $s4, 10, iniciarJogoPC
la $s1, barcos
add $s1, $s1, $s6
#Gerar Carrier Utilizador
la $a0, battleship
lw $t1, 4($a0)
la $s0, tabuleiro
jal gerarTabuleiro
#Gerar Carrier PC
la $s1, barcosPC
add $s1, $s1, $s6
la $a0, battleship
lw $t1, 4($a0)
la $s0, tabuleiroPC
jal gerarTabuleiro
add $s2, $v0, $0
addi $s4, $s4, 1
sw $s4, 4($sp)
addi $s5, $s5, 1
addi $s6, $s6, 12
j cicloNumBattleship


numDestroyer:
li $v0, 4
la $a0, editNumDestroyer
syscall
li $v0, 5
syscall
add $t0, $v0, $0
lw $s5, 8($sp)
cicloNumDestroyer:
bge $s5, $t0, numSubmarine
lw $s4, 4($sp)
bge $s4, 10, iniciarJogoPC
la $s1, barcos
add $s1, $s1, $s6
#Gerar Carrier Utilizador
la $a0, destroyer
lw $t1, 4($a0)
la $s0, tabuleiro
jal gerarTabuleiro
#Gerar Carrier PC
la $s1, barcosPC
add $s1, $s1, $s6
la $a0, destroyer
lw $t1, 4($a0)
la $s0, tabuleiroPC
jal gerarTabuleiro
add $s2, $v0, $0
addi $s4, $s4, 1
sw $s4, 4($sp)
addi $s5, $s5, 1
addi $s6, $s6, 12
j cicloNumDestroyer

numSubmarine:
li $v0, 4
la $a0, editNumSubmarine
syscall
li $v0, 5
syscall
add $t0, $v0, $0
lw $s5, 8($sp)
cicloNumSubmarine:
bge $s5, $t0, numPatrol
lw $s4, 4($sp)
bge $s4, 10, iniciarJogoPC
la $s1, barcos
add $s1, $s1, $s6
#Gerar Carrier Utilizador
la $a0, submarine
lw $t1, 4($a0)
la $s0, tabuleiro
jal gerarTabuleiro
#Gerar Carrier PC
la $s1, barcosPC
add $s1, $s1, $s6
la $a0, submarine
lw $t1, 4($a0)
la $s0, tabuleiroPC
jal gerarTabuleiro
add $s2, $v0, $0
addi $s4, $s4, 1
sw $s4, 4($sp)
addi $s5, $s5, 1
addi $s6, $s6, 12
j cicloNumSubmarine

numPatrol:
li $v0, 4
la $a0, editNumPatrol
syscall
li $v0, 5
syscall
add $t0, $v0, $0
lw $s5, 8($sp)
cicloNumPatrol:
bge $s5, $t0, iniciarJogoPC
lw $s4, 4($sp)
bge $s4, 10, iniciarJogoPC
la $s1, barcos
add $s1, $s1, $s6
#Gerar Carrier Utilizador
la $a0, patrol
lw $t1, 4($a0)
la $s0, tabuleiro
jal gerarTabuleiro
#Gerar Carrier PC
la $s1, barcosPC
add $s1, $s1, $s6
la $a0, patrol
lw $t1, 4($a0)
la $s0, tabuleiroPC
jal gerarTabuleiro
add $s2, $v0, $0
add $s2, $v0, $0
addi $s4, $s4, 1
sw $s4, 4($sp)
addi $s5, $s5, 1
addi $s6, $s6, 12
j cicloNumPatrol


# Tabuleiro Para PC
#la $s1, barcosPC
#addi $s2, $0, 1
#jal barcosPadra
#la $s0, tabuleiroPC
#jal zerarTabuleiro

#la $a0, carrier
#lw $t1, 4($a0)
#la $s0, tabuleiroPC
#jal gerarTabuleiro

#add $s2, $v0, $0
#la $s0, tabuleiroPC
#addi $s1, $s1, 12
#la $a0, battleship
#lw $t2, 0($a0)
#lw $t1, 4($a0)
#la $s0, tabuleiroPC
#jal gerarTabuleiro

#addi $s1, $s1, 12
#add $s2, $v0, $0
#la $a0, destroyer
#lw $t1, 4($a0)
#la $s0, tabuleiroPC
#jal gerarTabuleiro

#la $s0, tabuleiroPC
#addi $s1, $s1, 12
#add $s2, $v0, $0
#la $a0, submarine
#lw $t1, 4($a0)
#la $s0, tabuleiroPC
#jal gerarTabuleiro

#la $s0, tabuleiroPC
#addi $s1, $s1, 12
#add $s2, $v0, $0
#la $a0, patrol
#lw $t1, 4($a0)
#la $s0, tabuleiroPC
#jal gerarTabuleiro


iniciarJogoPC:
la $s0, tabuleiro
jal displayTabuleiro

la $s0, tabuleiroPC
jal displayTabuleiro

la $s1, barcos
la $s3, barcosPC
jal jogoPC

lw $ra, 0($sp)
addi $sp, $sp, 16
jr $ra



jogo:
# a0 -> endere?o dos barcos
# $s0 -> endere?o do tabuleiro
# $s1 -> endere?o do copiaTabuleiro
# $t1 -> char coluna
# $t2 -> numero linha
# $t3 -> posi??o escolhida pelo utilizador final / size do barco acertado
# $t4 -> valores dos tabuleiros
# $t5 -> Valor a por no tabuleiro (X -> Bomba / 0 -> Agua)
# $t6 -> contadores de barcos

add $sp, $sp, -8
sw $ra, 0($sp)
add $a0, $s1, $0
sw $a0, 4($sp)
la $s0, tabuleiro
la $s1, copiaTabuleiro
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
	mul $t1, $t1, 4
	mul $t2, $t2, 40
	add $t3, $t1, $t2
	bge $t3, 400, posUtilizador
	
	la $s0, tabuleiro
	la $s1, copiaTabuleiro
	add $s1, $s1, $t3
	lw $t4, 0($s1)
	bne $t4, '-', jogadaRepetida
		add $s0, $s0, $t3
		lw $t4, 0($s0)
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
			sw $t5, 0($s1)
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
		sw $t5, 0($s1)
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
add $sp, $sp, 8
jr $ra



jogoPC:
# a0 -> endere?o dos barcos
# a1 -> endereco dos barcosPC
# $s0 -> endere?o do tabuleiro
# $s1 -> endere?o do copiaTabuleiro
# $s2 -> endere?o do tabuleiroPC
# $s3 -> endere?o do copiaTabuleiroPC
# $s0 -> endere?o do tabuleiroPC
# $s1 -> endere?o do copiaTabuleiroPC
# $t1 -> char coluna
# $t2 -> numero linha
# $t3 -> posi??o escolhida pelo utilizador final / size do barco acertado
# $t4 -> valores dos tabuleiros
# $t5 -> Valor a por no tabuleiro (X -> Bomba / 0 -> Agua)
# $t6 -> contadores de barcos
# $t7 -> vez de jogar (1 -> Utilizador / 2-> PC)

add $sp, $sp, -12
sw $ra, 0($sp)
#TODO
add $a0, $s1, $0
sw $a0, 4($sp)
add $a1, $s3, $0
sw $a1, 8($sp)
la $s0, tabuleiro
la $s1, copiaTabuleiro
la $s2, tabuleiroPC
la $s3, copiaTabuleiroPC
add $t7, $0, $0
jal copiarTabuleiroCopia
jal zerarTabuleiroCopiaPC
cicloJogoPC:
	jal displayTabuleiroJogoPC
	validarVezJogada:
	beq $t7, 2, vezPC
	vezUtilizador:
	li $v0, 4
	la $a0, vezJogarUtilizador
	syscall
	lw $a1, 8($sp)
	li $v0, 12
	syscall
	add $t1, $v0, $0
	li $v0, 5
	syscall
	add $t2, $v0, $0
	addi $t1, $t1, -97	# Passar de A -> 1, b -> 2 etc... (96 ? o valor de A)
	mul $t1, $t1, 4
	mul $t2, $t2, 40
	add $t3, $t1, $t2
	bge $t3, 400, vezUtilizador
	
	la $s2, tabuleiroPC
	la $s3, copiaTabuleiroPC
	add $s3, $s3, $t3
	lw $t4, 0($s3)
	bne $t4, '-', jogadaRepetidaUtilizador
		add $s2, $s2, $t3
		lw $t4, 0($s2)
		beq $t4, '-', aguaJogadaUtilizador
		lw $a1, 8($sp)
		cicloVerArrayBarcoUtilizador:
			lw $t6, 0($a1)
			bne $t4, $t6, incrementar_a1_Utilizador
			lw $t3, 4($a1)
			lw $t6, 8($a1)
			addi $t6, $t6, 1
			sw $t6, 8($a1)
			la $t5, 'X'
			sw $t5, 0($s3)
			jal displayTabuleiroJogoPC
			bne $t3, $t6, acertouJogadaUtilizador
				li $v0, 4
				la $a0, JogadaAfundou
				syscall
			acertouJogadaUtilizador:
			li $v0, 4
			la $a0, JogadaBomba
			syscall
			j chekarSeTodosBarcosAfundaramUtilizador
			incrementar_a1_Utilizador:
			addi $a1, $a1, 12 
			j cicloVerArrayBarcoUtilizador
		aguaJogadaUtilizador:
		la $t5, '0'
		sw $t5, 0($s3)
		jal displayTabuleiroJogoPC
		li $v0, 4
		la $a0, JogadaAgua
		syscall
		addi $t7, $0, 2
		j validarVezJogada
		
		chekarSeTodosBarcosAfundaramUtilizador:
		lw $a1, 8($sp)
		ciclo_chekarSeTodosBarcosAfundaramUtilizador:
		lw $t4, 0($a1)
		lw $t5, 4($a1)
		lw $t6, 8($a1)
		bne $t5, $t6, vezUtilizador
		bge $t4, 100, sairJogoPC
		add $a1, $a1, 12
		j ciclo_chekarSeTodosBarcosAfundaramUtilizador
	jogadaRepetidaUtilizador:
	li $v0, 4
	la $a0, JogadaRepetida
	syscall
	j vezUtilizador
	
	vezPC:
	li $v0, 4
	la $a0, vezJogarPC
	syscall
	lw $a0, 4($sp)
	jal gerarNumeroRandom
	mul $t3, $v0, 4
	bge $t3, 400, vezPC
	
	la $s0, tabuleiro
	la $s1, copiaTabuleiro
	add $s1, $s1, $t3
	lw $t4, 0($s1)
	beq $t4, '0', jogadaRepetidaPC
	beq $t4, 'X', jogadaRepetidaPC
		add $s0, $s0, $t3
		lw $t4, 0($s0)
		beq $t4, '-', aguaJogadaPC
		lw $a0, 4($sp)
		cicloVerArrayBarcoPC:
			lw $t6, 0($a0)
			bne $t4, $t6, incrementar_a0_PC
			lw $t3, 4($a0)
			lw $t6, 8($a0)
			addi $t6, $t6, 1
			sw $t6, 8($a0)
			la $t5, 'X'
			sw $t5, 0($s1)
			jal displayTabuleiroJogo
			j chekarSeTodosBarcosAfundaramPC
			incrementar_a0_PC:
			addi $a0, $a0, 12
			j cicloVerArrayBarcoPC
		aguaJogadaPC:
		la $t5, '0'
		sw $t5, 0($s1)
		jal displayTabuleiroJogo
		addi $t7, $0, 1
		j validarVezJogada
		
		chekarSeTodosBarcosAfundaramPC:
		lw $a0, 4($sp)
		ciclo_chekarSeTodosBarcosAfundaramPC:
		lw $t4, 0($a0)
		lw $t5, 4($a0)
		lw $t6, 8($a0)
		bne $t5, $t6, vezPC
		bge $t4, 100, sairJogoPC
		add $a0, $a0, 12
		j ciclo_chekarSeTodosBarcosAfundaramPC
	jogadaRepetidaPC:
	j vezPC
j cicloJogoPC

sairJogoPC:
zerarArrayBarcosPC:
lw $a0, 4($sp)
ciclo_zerarArrayBarcosPC:
lw $t4, 0($a0)
bge $t4, 100, zerarArrayBarcosUtilizador
add $t4, $0, $0
sw $t4, 0($a0)
add $a0, $a0, 12
j ciclo_zerarArrayBarcosPC

zerarArrayBarcosUtilizador:
lw $a1, 4($sp)
ciclo_zerarArrayBarcosUtilizador:
lw $t4, 0($a1)
bge $t4, 100, sairJogoDepoisDeZerarPC
add $t4, $0, $0
sw $t4, 0($a1)
add $a1, $a1, 12
j ciclo_zerarArrayBarcosUtilizador

sairJogoDepoisDeZerarPC:
add $t4, $0, $0
sw $t4, 0($a0)
sw $t4, 0($a1)
#TODO
lw $ra, 0($sp)
add $sp, $sp, 12
jr $ra

copiarTabuleiroCopia:
#t1 -> i
#t2 -> '0'

la $a0, copiaTabuleiro
la $a1, tabuleiro
add $t1, $0, $0
#li $t2, '-'
copiar_tabuleiroCopia_for:
	lw $t2, 0($a1)
	bge $t1, 100, sair_copiar_tabuleiroCopia_for		# i >= 100 sai do ciclo
	sw $t2, 0($a0)
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	addi $t1, $t1, 1
	j copiar_tabuleiroCopia_for
sair_copiar_tabuleiroCopia_for:
jr $ra

zerarTabuleiroCopia:
#t1 -> i
#t2 -> '0'

la $a0, copiaTabuleiro
add $t1, $0, $0
li $t2, '-'
zerar_tabuleiroCopia_for:
	bge $t1, 100, sair_zerar_tabuleiroCopia_for		# i >= 100 sai do ciclo
	sw $t2, 0($a0)
	addi $a0, $a0, 4
	addi $t1, $t1, 1
	j zerar_tabuleiroCopia_for
sair_zerar_tabuleiroCopia_for:
jr $ra

zerarTabuleiroCopiaPC:
#t1 -> i
#t2 -> '0'

la $a0, copiaTabuleiroPC
add $t1, $0, $0
li $t2, '-'
zerar_tabuleiroCopiaPC_for:
	bge $t1, 100, sair_zerar_tabuleiroCopiaPC_for		# i >= 100 sai do ciclo
	sw $t2, 0($a0)
	addi $a0, $a0, 4
	addi $t1, $t1, 1
	j zerar_tabuleiroCopiaPC_for
sair_zerar_tabuleiroCopiaPC_for:
jr $ra

displayTabuleiroJogo:
#a0 -> tabuleiro
#t1 -> i
#t2 -> j
#t3 -> endere?o
#t4 -> val do endere?o
# $t5 -> valor da posicao do array tabuleiro
la $s0, copiaTabuleiro
#add $t3, $0, $0
add $t1, $0, $0
#add $t3, $a0, $0
displayTabuleiroJogo_1for:
	bge $t1, 10, sair_displayTabuleiroJogo_1for		# i >= 10 sai do ciclo
	add $t2, $0, $0
	displayTabuleiroJogo_2for:
		bge $t2, 10, sair_displayTabuleiroJogo_2for		# j >= 10 sai do ciclo
		#add $s0, $t3, $0
		#add $t3, $a0, $0
		lw $t4, 0($s0)
		beq $t4, '-', printStringJogo
		beq $t4, '0', printStringJogo
		beq $t4, 'X', printStringJogo
		li $v0, 1
		move $a0, $t4
		syscall
		j incrementarS0
		printStringJogo:
		li $v0, 4
		sw $t4, valCopiaTabuleiro
		la $a0, valCopiaTabuleiro
		syscall
		#add $t3, $t3, 4
		incrementarS0:
		addi $s0, $s0, 4
		addi $t2, $t2, 1
		j displayTabuleiroJogo_2for
	sair_displayTabuleiroJogo_2for:
	li $v0, 4
	la $a0, Enter
	syscall
	addi $t1, $t1, 1
	j displayTabuleiroJogo_1for
sair_displayTabuleiroJogo_1for:
li $v0, 4
la $a0, Enter
syscall
jr $ra


displayTabuleiroJogoPC:
#a0 -> tabuleiro
#t1 -> i
#t2 -> j
#t3 -> endere?o
#t4 -> val do endere?o
la $s0, copiaTabuleiroPC
#add $t3, $0, $0
add $t1, $0, $0
#add $t3, $a0, $0
displayTabuleiroJogoPC_1for:
	bge $t1, 10, sair_displayTabuleiroJogoPC_1for		# i >= 10 sai do ciclo
	add $t2, $0, $0
	displayTabuleiroJogoPC_2for:
		bge $t2, 10, sair_displayTabuleiroJogoPC_2for		# j >= 10 sai do ciclo
		#add $s0, $t3, $0
		#add $t3, $a0, $0
		li $v0, 4
		lw $t4, 0($s0)
		sw $t4, valCopiaTabuleiro
		la $a0, valCopiaTabuleiro
		syscall
		#add $t3, $t3, 4
		addi $s0, $s0, 4
		addi $t2, $t2, 1
		j displayTabuleiroJogoPC_2for
	sair_displayTabuleiroJogoPC_2for:
	li $v0, 4
	la $a0, Enter
	syscall
	addi $t1, $t1, 1
	j displayTabuleiroJogoPC_1for
sair_displayTabuleiroJogoPC_1for:
li $v0, 4
la $a0, Enter
syscall
jr $ra

gerarTabuleiro:
# a0 -> Size do Barco
# a1 -> Numero do Barco
# $a2 -> array dos barcos
# $s0 -> tabuleiro
# $t8 -> Pois??es das Pe?as do Barco
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
add $a0, $t1, $0	# Guardar o Size do Barco em $a0
add $a1, $s2, $0	# Guardar a Letra do Barco em $a1
add $a2, $s1, $0
sw $a0, 4($sp)		# Guardo o Size do Barco na stack pq vou perder o valor de $a0 noutras fun??es
sw $a1, 8($sp)		# Guardo a Letra do Barco na stack pq vou perder o valor de $a1 noutras fun??es
sw $a2, 12($sp)		# Guardo a Letra do Barco na stack pq vou perder o valor de $a1 noutras fun??es
add $a3, $s0, $0
sw $a3, 16($sp)
#la $s0, tabuleiro	# Guardar o endere?o do tabuleiro em $s0
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
	add $t3, $v0, $0		# Guarda o valor que vai ser usado para saber em que dire??o adicionar as pe?as do barco
	#addi $t3, $0, 0
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
		#addi $t1, $0, 0
		
		jal validarCima		# Chama fun??o que vai validar se vou precisar validar a linha de cima
		add $t6, $v0, $0		# recebe o valor da fun??o
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
		#lw $a3, 16($sp)
		j sairValidarCimaBaixo		# se $t6 = 1 ent?o estou na primeira linha e n?o preciso de fazer "validarLinhaBaixo"
		
		jal validarBaixo
		add $t6, $v0, $0
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
		#lw $a3, 16($sp)
		
		sairValidarCimaBaixo:
		mul $t1, $t1, 4			# Multiplicar essa posi??o para ser usada nos arrays
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
		#lw $a3, 16($sp)
		
	j sair_validacoes
	validacoesHor:
		jal gerarNumeroRandom		# Fun??o que gera Numero entre 0 < 100
		add $t1, $v0, $0		# Guarda a primeira posi??op gerada pela fun??o "gerarNumeroRandom"
		#addi $t1, $0, 0
		mul $t1, $t1, 4			# Multiplicar essa posi??o para ser usada nos arrays
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
		#lw $a3, 16($sp)
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
	#la $s0, tabuleiro		# Voltar a meter o valor do endere?o do tabuleiro em $a0 pois foi perdido na fun??o anterior "gerarNumeroRandom"
	#lw $a3, 16($sp)
	add $a3, $a3, $t1		# Meter $a3 na posi??o gerada aleat?riamente
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
	#lw $a3, 16($sp)
	
	jal validacoesEsquerda		# chama a fun??o que valida se vou ter de validar o lado esquerdo da posi??o
	add $t7, $v0, $0
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
	#lw $a3, 16($sp)
	beq $t7, 1, validacoesPosicoes	# Se $t7 = 1 quer dizer q n vou validar ? esquerda ent n?o preciso de ver a "validacoesDireita"
	
	jal validacoesDireita		# chama a fun??o que valida se vou ter de validar o lado esquerdo da posi??o
	add $t7, $v0, $0
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
	#lw $a3, 16($sp)
	
	validacoesPosicoes:
	lw $t4, 0($a3)			# Recebe o valor do tabuleiro
	#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	#bne $t4, 0, gerarPos
	bne $t4, '-', gerarPos
	j mainTeste1			# else salta para o prox teste
	mainTeste1:
	beq $t6, 1, mainTeste2		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
	lw $t4, -40($a3)		# recebe o valor da linha de cima do tabulerio
	#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	#bne $t4, 0, gerarPos	
	bne $t4, '-', gerarPos
	j mainTeste2			# else salta para o prox teste
	mainTeste2:
	beq $t6, 1, mainTeste3		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
	beq $t7, 2, mainTeste3		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
	lw $t4, -36($a3)		# recebe o valor da diagonal cima ? direita de cima do tabulerio
	#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	#bne $t4, 0, gerarPos
	bne $t4, '-', gerarPos
	j mainTeste3			# else salta para o prox teste
	mainTeste3:
	beq $t7, 2, mainTeste4		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
	lw $t4, 4($a3)			# recebe o valor da direita do tabulerio
	#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	#bne $t4, 0, gerarPos
	bne $t4, '-', gerarPos
	j mainTeste4			# else salta para o prox teste
	mainTeste4:
	beq $t6, 2, mainTeste5		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
	beq $t7, 2, mainTeste5		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
	lw $t4, 44($a3)			# recebe o valor da diagonal baixo ? direita do tabulerio
	#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	#bne $t4, 0, gerarPos	
	bne $t4, '-', gerarPos
	j mainTeste5			# else salta para o prox teste
	mainTeste5:
	beq $t6, 2, mainTeste6		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
	lw $t4, 40($a3)			# recebe o valor da linha de baixo do tabulerio
	#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	#bne $t4, 0, gerarPos	
	bne $t4, '-', gerarPos
	j mainTeste6			# else salta para o prox teste
	mainTeste6:
	beq $t6, 2, mainTeste7		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
	beq $t7, 1, mainTeste7		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
	lw $t4, 36($a3)			# recebe o valor da diagonal baixo ? esquerda do tabulerio
	#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	#bne $t4, 0, gerarPos
	bne $t4, '-', gerarPos
	j mainTeste7			# else salta para o prox teste
	mainTeste7:
	beq $t7, 1, mainTeste8		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
	lw $t4, -4($a3)			# recebe o valor da esquerda do tabulerio
	#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	#bne $t4, 0, gerarPos	
	bne $t4, '-', gerarPos
	j mainTeste8			# else salta para o prox teste
	mainTeste8:
	beq $t6, 1, sairTeste		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
	beq $t7, 1, sairTeste		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
	lw $t4, -44($a3)		# recebe o valor da diagonal de cima ? esquerda do tabulerio
	#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	#bne $t4, 0, gerarPos	
	bne $t4, '-', gerarPos
	j sairTeste			# else salta para o prox teste
	
	sairTeste:
	addi $t9, $0, 0			# i = 0
	forSizeBarco:
		beq $t9, $a0, breakForSizeBarco	# If(I < Size) SAI -> breakForSizeBarco
		lw $t2, 0($a3)			# Recebe o valor dessa posi??o em $t2
		#bne $t2, '0', gerarPos		# If($t2 != '0') SAI -> gerarPos
		#bne $t2, 0, gerarPos	
		bne $t2, '-', gerarPos	
		beq $t3, 0, fazHorizontal	# If($t3 == 0) ($t2 = 0 -> Horizontal / $t2 = 1 -> Vertical)
		fazVertical:
			addi $a3, $a3, 40		# Ando para baixo no tabuleiro
			sw $t1, 0($t8)			# Guarda o valor de $t1 em $t8(array com as posi??es onde v?o ser inseridas as letras do barco no tabuleiro)
			addi $t1, $t1, 40		# $t1 + 40 para andar para baixo no tabuleiro (v?rias pe?as do barco)
			
			jal validarBaixo
			add $t6, $v0, $0
			lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun??es)
			#lw $a3, 16($sp)
			
			validacoesPosicoesVert:
			lw $t4, 0($a3)			# Recebe o valor do tabuleiro
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos	
			bne $t4, '-', gerarPos
			j vertTeste1			# else salta para o prox teste
			vertTeste1:
			beq $t6, 1, vertTeste2		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			beq $t7, 2, vertTeste2		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, -36($a3)		# recebe o valor da diagonal cima ? direita de cima do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos	
			bne $t4, '-', gerarPos
			j vertTeste2			# else salta para o prox teste
			vertTeste2:
			beq $t7, 2, vertTeste3		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, 4($a3)			# recebe o valor da direita do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos	
			bne $t4, '-', gerarPos
			j vertTeste3			# else salta para o prox teste
			vertTeste3:
			beq $t6, 2, vertTeste4		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			beq $t7, 2, vertTeste4		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, 44($a3)			# recebe o valor da diagonal baixo ? direita do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos
			bne $t4, '-', gerarPos
			j vertTeste4			# else salta para o prox teste
			vertTeste4:
			beq $t6, 2, vertTeste5		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			lw $t4, 40($a3)			# recebe o valor da linha de baixo do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos
			bne $t4, '-', gerarPos
			j vertTeste5			# else salta para o prox teste
			vertTeste5:
			beq $t6, 2, vertTeste6		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			beq $t7, 1, vertTeste6		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			lw $t4, 36($a3)			# recebe o valor da diagonal baixo ? esquerda do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos	
			bne $t4, '-', gerarPos
			j vertTeste6			# else salta para o prox teste
			vertTeste6:
			beq $t7, 1, vertTeste7		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, -4($a3)			# recebe o valor da esquerda do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos	
			bne $t4, '-', gerarPos
			j vertTeste7			# else salta para o prox teste
			vertTeste7:
			beq $t6, 1, sairTesteVert	# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			beq $t7, 1, sairTesteVert	# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			lw $t4, -44($a3)		# recebe o valor da diagonal de cima ? esquerda do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos	
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
			#lw $a3, 16($sp)
			
			validacoesPosicoesHor:
			lw $t4, 0($a3)			# Recebe o valor do tabuleiro
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos
			bne $t4, '-', gerarPos
			j horTeste1			# else salta para o prox teste
			horTeste1:
			beq $t6, 1, horTeste2		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			lw $t4, -40($a3)		# recebe o valor da linha de cima do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos	
			bne $t4, '-', gerarPos
			j horTeste2			# else salta para o prox teste
			horTeste2:
			beq $t6, 1, horTeste3		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			beq $t7, 2, horTeste3		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, -36($a3)		# recebe o valor da diagonal cima ? direita de cima do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos
			bne $t4, '-', gerarPos
			j horTeste3			# else salta para o prox teste
			horTeste3:
			beq $t7, 2, horTeste4		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, 4($a3)			# recebe o valor da direita do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos
			bne $t4, '-', gerarPos
			j horTeste4			# else salta para o prox teste
			horTeste4:
			beq $t6, 2, horTeste5		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			beq $t7, 2, horTeste5		# Se $t6 = 1 n?o ? para validar coluna da esquerda ent?o dou skip a esta valida??o
			lw $t4, 44($a3)			# recebe o valor da diagonal baixo ? direita do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos	
			bne $t4, '-', gerarPos
			j horTeste5			# else salta para o prox teste
			horTeste5:
			beq $t6, 2, horTeste6		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			lw $t4, 40($a3)			# recebe o valor da linha de baixo do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos	
			bne $t4, '-', gerarPos
			j horTeste6			# else salta para o prox teste
			horTeste6:
			beq $t6, 2, horTeste7		# Se $t6 = 2 n?o ? para validar linha de baixo ent?o dou skip a esta valida??o
			beq $t7, 1, horTeste7		# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			lw $t4, 36($a3)			# recebe o valor da diagonal baixo ? esquerda do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos	
			bne $t4, '-', gerarPos
			j horTeste7			# else salta para o prox teste
			horTeste7:
			beq $t6, 1, sairTesteHor	# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			beq $t7, 1, sairTesteHor	# Se $t6 = 1 n?o ? para validar linha de cima ent?o dou skip a esta valida??o
			lw $t4, -44($a3)		# recebe o valor da diagonal de cima ? esquerda do tabulerio
			#bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			#bne $t4, 0, gerarPos
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
	#la $s0, tabuleiro
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



barcosPadra:
# $s0 -> endere?o do barco
# $t1 -> valores
carrierBarcoPadrao:
la $s0, carrier
la $t1, 'C'
sw $t1, 0($s0)
addi $t1, $0, 5
sw $t1, 4($s0)
battleshipBarcoPadrao:
la $s0, battleship
la $t1, 'B'
sw $t1, 0($s0)
addi $t1, $0, 4
sw $t1, 4($s0)
destroyerBarcoPadrao:
la $s0, destroyer
la $t1, 'D'
sw $t1, 0($s0)
addi $t1, $0, 3
sw $t1, 4($s0)
submarineBarcoPadrao:
la $s0, submarine
la $t1, 'S'
sw $t1, 0($s0)
addi $t1, $0, 3
sw $t1, 4($s0)
patrolBarcoPadrao:
la $s0, patrol
la $t1, 'P'
sw $t1, 0($s0)
addi $t1, $0, 2
sw $t1, 4($s0)
jr $ra



barcosEdit:
# $s0 -> endere?o do barco
# $t0 -> tamanho do barco
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
add $t0, $v0, $0

carrierBarcoEdit:
la $s0, carrier
la $t1, 'C'
sw $t1, 0($s0)
ble $t0, 0, tamanhoPadraoCarrier
add $t1, $0, $t0
j skipEditCarrier
tamanhoPadraoCarrier:
addi $t1, $0, 5
skipEditCarrier:
sw $t1, 4($s0)

li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoBattleship
syscall
li $v0, 5
syscall
add $t0, $v0, $0

battleshipBarcoEdit:
la $s0, battleship
la $t1, 'B'
sw $t1, 0($s0)
ble $t0, 0, tamanhoPadraoBattleship
add $t1, $0, $t0
j skipEditBattleship
tamanhoPadraoBattleship:
addi $t1, $0, 4
skipEditBattleship:
sw $t1, 4($s0)

li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoDestroyer
syscall
li $v0, 5
syscall
add $t0, $v0, $0

destroyerBarcoEdit:
la $s0, destroyer
la $t1, 'D'
sw $t1, 0($s0)
ble $t0, 0, tamanhoPadraoDestroyer
add $t1, $0, $t0
j skipEditDestroyer
tamanhoPadraoDestroyer:
addi $t1, $0, 3
skipEditDestroyer:
sw $t1, 4($s0)

li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoSubmarine
syscall
li $v0, 5
syscall
add $t0, $v0, $0

submarineBarcoEdit:
la $s0, submarine
la $t1, 'S'
sw $t1, 0($s0)
ble $t0, 0, tamanhoPadraoSubmarine
add $t1, $0, $t0
j skipEditSubmarine
tamanhoPadraoSubmarine:
addi $t1, $0, 3
skipEditSubmarine:
sw $t1, 4($s0)

li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoPatrol
syscall
li $v0, 5
syscall
add $t0, $v0, $0

patrolBarcoEdit:
la $s0, patrol
la $t1, 'P'
sw $t1, 0($s0)
ble $t0, 0, tamanhoPadraoPatrol
add $t1, $0, $t0
j skipEditPatrol
tamanhoPadraoPatrol:
addi $t1, $0, 2
skipEditPatrol:
sw $t1, 4($s0)
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
# $a0 -> endere?o tabuleiro
#t1 -> i
#t2 -> '0'

#la $a0, tabuleiro
add $a0, $s0, $0
add $t1, $0, $0
li $t2, '-'
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
#t3 -> endere?o
#t4 -> val do endere?o
# t5 -> pos atual
add $sp, $sp, -4
add $a0, $s0, $0
sw $a0, 0($sp)
#la $s0, tabuleiro
#add $t3, $0, $0
add $t1, $0, $0
add $t5, $0, $0
#add $t3, $a0, $0
displayTabuleiro_1for:
	bge $t1, 10, sair_displayTabuleiro_1for		# i >= 10 sai do ciclo
	add $t2, $0, $0
	displayTabuleiro_2for:
		bge $t2, 10, sair_displayTabuleiro_2for		# j >= 10 sai do ciclo
		#add $s0, $t3, $0
		#add $t3, $a0, $0
		#li $v0, 4
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
		#move $a0, $t4
		syscall
		j increment_displayTabuleiro_2for
		#add $t3, $t3, 4
		increment_displayTabuleiro_2for:
		addi $t5, $t5, 4
		lw $a0, 0($sp)
		add $a0, $a0, $t5
		#addi $a0, $a0, 4
		addi $t2, $t2, 1
		j displayTabuleiro_2for
	sair_displayTabuleiro_2for:
	li $v0, 4
	la $a0, Enter
	syscall
	lw $a0, 0($sp)
	add $a0, $a0, $t5
	addi $t1, $t1, 1
	j displayTabuleiro_1for
sair_displayTabuleiro_1for:
li $v0, 4
la $a0, Enter
syscall
add $sp, $sp, 4
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
