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
teclaMenuErro:		.asciiz "Essa opcaoo nao existe no menu, insira um nova opcaoo \n"
vezJogarPC:		.asciiz "Vez Do Computador \n"
vezJogarUtilizador:	.asciiz "Vez Do Utilizador \n"
editSizeBarcosMenu:	.asciiz "Editar tamanho dos Barcos? 1 -> Editar \n"
editSizeBarcoOption:	.asciiz "0 -> Utilizar Tamanho Padrao / Tamanho maximo de um barco e 9 \n"
editSizeBarco:		.asciiz "Editar tamanho do Barco - "
editNumCarrier:		.asciiz "Insira o numero de barcos Carrier (max de barcos = 9)\n"
editNumBattleship:	.asciiz "Insira o numero de barcos Battleship (max = 9)\n"
editNumDestroyer:	.asciiz "Insira o numero de barcos Destroyer (max = 9)\n"
editNumSubmarine:	.asciiz "Insira o numero de barcos Submarine (max = 9)\n"
editNumPatrol:		.asciiz "Insira o numero de barcos Patrol (max = 9)\n"
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
	li $v0, 4		# print String
	la $a0, Menu		# escreve o que tem na label Menu
	syscall
	li $v0, 12		# lê carater
	syscall
	add $t1, $v0, $0	# guarda em $t1 o carater inserido
	li $v0, 4		# print String
	la $a0, Enter		# escreve o que tem na label Enter
	syscall
	beq $t1, 'e', sairPrograma		# if ($t1 == 'e') -> sairPrograma
		beq $t1, 'a', jogoSozinho	# if($t1 == 'a') -> jogoSozinho
		beq $t1, 'b', jogoPc		# if ($t1 == 'b') -> jogoPC
		teclaErrada:			# else inserio uma tecla que nao existe nas opcoes
		li $v0, 4			# print String
		la $a0, teclaMenuErro		# escreve o que tem na label teclaMenuErro
		syscall
		j cicloMenu			# Volta ao ciclo do menu
		jogoSozinho:			
		jal fase1Main			# Chama a funcao fase1Main
		j cicloMenu			# Volta ao ciclo do menu
		jogoPc:
		jal fase2Main			# Chama a funcao fase2Main
		j cicloMenu			# Volta ao ciclo do menu
	sairPrograma:
	j Exit					# Jump para saida do programa
j Exit						# Jump para saida do programa

Exit:
li $v0, 10	# Sair do programa
syscall


fase1Main:
# $t0 -> endere?o do barco 
# $s0 -> endere?o do tabuleiro
# $s2 -> numero do barco
# $s1 -> endere?o dos barcos
# $t1 -> numero do barco 
# $t2 -> tamanho do barco 
# $t3 -> letra do Barco 

addi $sp, $sp, -16		# Baixa stack em 16
sw $ra, 0($sp)			# Guarda $ra na posicao 0 da stack
la $s0, tabuleiro		# $s0 recebe o endereco do array tabuleiro
la $s1, barcos			# $s1 recebe o endereco do array barcos
sw $s0, 4($sp)			# Guarda $s0 na stack
sw $s1, 8($sp)			# Guarda $s1 na stack
addi $s2, $0, 1			# Inicializa $s2 = 1
sw $s2, 12($sp)			# Guarda $s2 na stack
jal barcosPadra			# Chama a funcao barcosPadra (cria e inicializa os arrays dos barcos com as posicoes padrao dos mesmos)
jal zerarTabuleiro		# Chama a funcao zerarTabuleiro (serve para inicializar o tabuleiro a '-')

la $t0, carrier			# $t0 recebe o endereco do array do barco Carrier
lw $t2, 4($t0)			# Recebe em $t2 o tamanho do barco Carrier (da memoria)
lw $s0, 4($sp)			# Recebe o endereco do tabuleiro (da stack)
jal gerarTabuleiro		# Chama a funcao gerarTabuleiro (funcao que gera um barco no tabuleiro)

lw $s2, 12($sp)			# Recebe o numero do barco (da stack)
addi $s2, $s2, 1		# Incrementa $s2++
sw $s2, 12($sp)			# Guarda $s2 na stack
lw $s1, 8($sp)			# Recebe o endereco do array dos barcos para $s1 (da stack)
addi $s1, $s1, 12		# Avanca 12 (4) posicoes no array (pois cada barco tem reservadas 4 posicoes para as suas informacoes se quero mudar de barcos ando 4 posicoes)
sw $s1, 8($sp)			# Guarda $s1 na stack
la $t0, battleship		# Recebe o endereco do array do barco battleship
lw $t2, 4($t0)			# Recebe o tamanho do barco (da stack)
lw $s0, 4($sp)			# Recebe o endereco do tabuleiro (da stack)
jal gerarTabuleiro		# Chama a funcao gerarTabuleiro (funcao que gera um barco no tabuleiro)

lw $s1, 8($sp)			# Recebe o endereco do array dos barcos para $s1 (da stack)
addi $s1, $s1, 12		# Avanca 12 (4) posicoes no array (pois cada barco tem reservadas 4 posicoes para as suas informacoes se quero mudar de barcos ando 4 posicoes)
sw $s1, 8($sp)			# Guarda $s1 na stack
lw $s2, 12($sp)			# Recebe o numero atual do barco que vai ser inserido no tabuleiro (da stack)
addi $s2, $s2, 1		# Incrementa $s2++
sw $s2, 12($sp)			# Guarda $s2 na stack
la $t0, destroyer		# Recebe o endereco do array do barco destroyer
lw $t2, 4($t0)			# Recebe o tamanho do barco (da stack)
lw $s0, 4($sp)			# Recebe o endereco do tabuleiro (da stack)
jal gerarTabuleiro		# Chama a funcao gerarTabuleiro (funcao que gera um barco no tabuleiro)

lw $s1, 8($sp)			# Recebe o endereco do array dos barcos para $s1 (da stack)
addi $s1, $s1, 12		# Avanca 12 (4) posicoes no array (pois cada barco tem reservadas 4 posicoes para as suas informacoes se quero mudar de barcos ando 4 posicoes)
sw $s1, 8($sp)			# Guarda $s1 na stack
lw $s2, 12($sp)			# Recebe o numero atual do barco que vai ser inserido no tabuleiro (da stack)
addi $s2, $s2, 1		# Incrementa $s2++
sw $s2, 12($sp)			# Guarda $s2 na stack
la $t0, submarine		# Recebe o endereco do array do barco submarine
lw $t2, 4($t0)			# Recebe o tamanho do barco (da stack)
lw $s0, 4($sp)			# Recebe o endereco do tabuleiro (da stack)
jal gerarTabuleiro		# Chama a funcao gerarTabuleiro (funcao que gera um barco no tabuleiro)

lw $s1, 8($sp)			# Recebe o endereco do array dos barcos para $s1 (da stack)
addi $s1, $s1, 12		# Avanca 12 (4) posicoes no array (pois cada barco tem reservadas 4 posicoes para as suas informacoes se quero mudar de barcos ando 4 posicoes)
sw $s1, 8($sp)			# Guarda $s1 na stack
lw $s2, 12($sp)			# Recebe o numero atual do barco que vai ser inserido no tabuleiro (da stack)
addi $s2, $s2, 1		# Incrementa $s2++
sw $s2, 12($sp)			# Guarda $s2 na stack
la $t0, patrol			# Recebe o endereco do array do barco patrol
lw $t2, 4($t0)			# Recebe o tamanho do barco (da stack)
lw $s0, 4($sp)			# Recebe o endereco do tabuleiro (da stack)
jal gerarTabuleiro		# Chama a funcao gerarTabuleiro (funcao que gera um barco no tabuleiro)

lw $s0, 4($sp)			# Recebe o endereco do tabuleiro (da stack)
#jal displayTabuleiro		# Chama a funcao para dar display ao tabuleiro
la $s1, barcos			# Recebe o endereco do array dos barcos para $s1
jal jogo			# Chama a funcao do jogo

lw $ra, 0($sp)			# Recebe o $ra (da stack)
addi $sp, $sp, 16		# Sube a stack
jr $ra				# Returna da funcao


fase2Main:
# $t5 -> endere?o do barco 
# $s0 -> endere?o do tabuleiro
# $s1 -> endere?o dos barcos
# $s2 -> numero do barco
# $s3 -> endere?o dos barcosPC
# $s4 -> contador de barcos (max 10)
# $s5 -> I
# $s6 -> contador da pos atual do array de barcos
# $s7 -> endereço do array de pontuacoes
# $t1 -> numero do barco 
# $t2 -> tamanho do barco 
# $t3 -> letra do Barco	
# $t4 -> pontuacoes		
# $t0 -> Editar tamanho de barcos ou nao (1 -> editar) / numero de barcos (menu utilizador)

addi $sp, $sp, -40		# Baixa a stack
sw $ra, 0($sp)			# Guarda $ra na stack
la $s0, tabuleiro		# Recebe o endereco do tabuleiro
la $s1, barcos			# Recebe o endereco do array dos barcos
la $s3, barcosPC		# Recebe o endereco do array dos barcos do PC
addi $s4, $0, 1			# Inicializa $s4 = 1
add $s5, $0, $0			# Inicializa $s5 = 0		
add $s6, $0, $0			# Inicializa $s6 = 0
la $s7, arrayPontuacao		# Recebe o endereco do array de pontuacoes
sw $s0, 4($sp)			# Guarda $s0 (tabuleiro) na stack
la $s0, tabuleiroPC		# Recebe o endereco do tabuleiro do PC
sw $s0, 8($sp)			# Guarda $s0 (tabuleiroPC) na stack
sw $s1, 12($sp)			# Guarda $s1 na stack
sw $s3, 16($sp)			# Guarda $s3 na stack
sw $s4, 20($sp)			# Guarda $s4 na stack
sw $s5, 24($sp)			# Guarda $s5 na stack
sw $s6, 28($sp)			# Guarda $s6 na stack
sw $s7, 32($sp)			# Guarda $s7 na stack

li $v0, 4			# Print String
la $a0, editSizeBarcosMenu	# Escreve o que tem na label editSizeBarcosMenu
syscall
li $v0, 5			# Receber um inteiro
syscall
add $t0, $v0, $0		# Igualar $t1 ao inteiro inserido pelo utilizador
beq $t0, 1, editarSizeBarcos	# if($t0 == 1) editarSizeBarcos
lw $s1, 16($sp)			# Recebe o endereco dos barcos do PC (da stack)
jal barcosPadra			# Chama a funcao de criar e inicializar os barcos com infos padrao
j sairBarcos			# Jump para sair da parte dos barcos
lw $s1, 12($sp)			# Recebe o endereco dos barcos do Utilizador (da stack)
jal barcosPadra			# Chama a funcao de criar e inicializar os barcos com infos padrao
editarSizeBarcos:		# Se o utilizador escolheu eidtar o tamanho dos barcos
lw $s1, 12($sp)			# Recebe o endereco dos barcos do Utilizador (da stack)
jal barcosEdit			# Chama a funcao que cria e iniializa os barcos com um tamanho escolhido pelo utilizador
sairBarcos:			# sair das infos dos barcos
addi $s2, $0, 1			# Inicializar $s2 = 1
sw $s2, 36($sp)			# Guardar $s2 na stack
lw $s0, 8($sp)			# Recebe o endereco do tabuleiro do PC
jal zerarTabuleiro		# Chama a funcao para inicializar o tabuleir a '-'

lw $s0, 4($sp)			# Recebe o endereco do tabuleiro do Utilizador
jal zerarTabuleiro		# Chama a funcao para inicializar o tabuleir a '-'

numCarrier:
li $v0, 4			# Print String
la $a0, editNumCarrier		# Escreve o que tem na label editNumCarrier
syscall
li $v0, 5			# recebe um inteiro
syscall
bge $v0, 10, numCarrier
add $t0, $v0, $0		# iguala $t0 ao inteiro inserido pelo utilizador
lw $s5, 24($sp)			# Recebe o valor de $s5(I) (da stack)
cicloNumCarrier:		# Ciclo para o barco carrier
bge $s5, $t0, numBattleship	# If(I >= numeroDeBarcos) passa para o proximo barco
lw $s4, 20($sp)			# Recebe o valor atual de barcos (usado para saber se nao ultrapassou os 10 barcos do limit)
bge $s4, 10, iniciarJogoPC	# Se o numero de barcos for >= 10 vai direto para o inicializar o jogo
#Gerar Carrier Utilizador
lw $s1, 12($sp)			# Recebe o endereco do array dos barcos (da stack)
add $s1, $s1, $s6		# anda $s6 posicoes do array ( de 12 em 12 (assembly) / de 4 em 4 (C))
la $t5, carrier			# Recebe o endereco do barcos carrier
lw $t2, 4($t5)			# Recebe o tamanho do barco
lw $s0, 4($sp)			# Recebe o endereco do tabuleiro (da stack)
jal gerarTabuleiro		# Chama a funcao de gerarTabuleiro 
#Gerar Carrier PC
lw $s1, 16($sp)			# Recebe o endereco dos barcos do PC (da stack)
add $s1, $s1, $s6		# Avanca $s6 posicoes do array (12 em 12 (assembly) /  4 em 4 (C))
la $t5, carrier			# Rece o endereco do barco carrier
lw $t2, 4($t5)			# Recebe o tamanho do barco
lw $s0, 8($sp)			# Recebe o endereco do tabuleiro do PC (da stack)
jal gerarTabuleiro		# Chama a funcao de gerarTabuleiro 
lw $s2, 36($sp)			# Recebe o numero atual do barco que vai ser usado para o tabuleiro
addi $s2, $s2, 1		# Inrementa $s2++
sw $s2, 36($sp)			# Guarda $s2 na stack
addi $s4, $s4, 1		# Incrementa $s4++ (contador de barcos)
sw $s4, 20($sp)			# Guardar o valor de $s4 na stack
addi $s5, $s5, 1		# Inrecementa $s5++ (I)
addi $s6, $s6, 12		# Incrementa $s6 + 12 (posicoe sdo array de barcos)
j cicloNumCarrier		# Volta ao ciclo

numBattleship:
li $v0, 4			
la $a0, editNumBattleship	
syscall
li $v0, 5
syscall
bge $v0, 10, numBattleship
add $t0, $v0, $0		# Guarda em $t0 o inteiro do utilizador
lw $s5, 24($sp)			# recebe I
cicloNumBattleship:
bge $s5, $t0, numDestroyer	# If(I >= numeroDeBarcos) passa para o proximo barco
lw $s4, 20($sp)			# recebe contador de barcos
bge $s4, 10, iniciarJogoPC	# if ($s4 >= 10)
lw $s1, 12($sp)			# recebe endereco barcos 
add $s1, $s1, $s6		# avanca posicoes
#Gerar Carrier Utilizador
la $t5, battleship		
lw $t2, 4($t5)			# recebe tamanho do barco
lw $s0, 4($sp)			# recebe tabuleiro
jal gerarTabuleiro
#Gerar Carrier PC
lw $s1, 16($sp)			# recebe endereco barcos PC
add $s1, $s1, $s6		# avanca posicoes
la $t5, battleship
lw $t2, 4($t5)			# recebe tamanho barco
lw $s0, 8($sp)
jal gerarTabuleiro
lw $s2, 36($sp)			# recebe numero do barco (no tabuleiro)
addi $s2, $s2, 1		# incremenat
sw $s2, 36($sp)			# guarda
addi $s4, $s4, 1		# contador de barcos +1
sw $s4, 20($sp)			# guarda
addi $s5, $s5, 1		# I ++
addi $s6, $s6, 12		# incrmenat posicoes (array de barcos)
j cicloNumBattleship

numDestroyer:
li $v0, 4
la $a0, editNumDestroyer
syscall
li $v0, 5
syscall
bge $v0, 10, numDestroyer
add $t0, $v0, $0		# recebe o inteiro do utilizador
lw $s5, 24($sp)			# recebe I
cicloNumDestroyer:
bge $s5, $t0, numSubmarine	# If(I >= numeroDeBarcos) passa para o proximo barco
lw $s4, 20($sp)			# recebe contador de barcos
bge $s4, 10, iniciarJogoPC	# if($s4 >= 10)
lw $s1, 12($sp)			# recebe endereco barcos
add $s1, $s1, $s6		# incremenat $S6 posicoes
#Gerar Carrier Utilizador
la $t5, destroyer		
lw $t2, 4($t5)			# recebe tamnho do barco
lw $s0, 4($sp)		
jal gerarTabuleiro
#Gerar Carrier PC
lw $s1, 16($sp)			# recebe endereco barcos do PC
add $s1, $s1, $s6		# incremenat $S6 posicoes
la $t5, destroyer
lw $t2, 4($t5)			# recebe tamanho do barco
lw $s0, 8($sp)
jal gerarTabuleiro
lw $s2, 36($sp)			# recebe numero do barco (no tabuleiro)
addi $s2, $s2, 1		# $s2++
sw $s2, 36($sp)			# guarda $s2
addi $s4, $s4, 1		# numero de barcos ++
sw $s4, 20($sp)			# guarda
addi $s5, $s5, 1		# i++
addi $s6, $s6, 12		# incrementa posicoes do array de barcos +12
j cicloNumDestroyer

numSubmarine:
li $v0, 4
la $a0, editNumSubmarine
syscall
li $v0, 5
syscall
bge $v0, 10, numSubmarine
add $t0, $v0, $0		# recebe o inteiro do utilizador
lw $s5, 24($sp)			# recebe I
cicloNumSubmarine:
bge $s5, $t0, numPatrol	# If(I >= numeroDeBarcos) passa para o proximo barco
lw $s4, 20($sp)			# recebe contador de barcos
bge $s4, 10, iniciarJogoPC	# if ($s4 >= 10)
lw $s1, 12($sp)			# recebe endereco de barcos
add $s1, $s1, $s6		# avanca $s6 posicoes do array
#Gerar Carrier Utilizador
la $t5, submarine
lw $t2, 4($t5)			# recebe tamanho do barco
lw $s0, 4($sp)
jal gerarTabuleiro
#Gerar Carrier PC
lw $s1, 16($sp)			# recebe endereco de barcos PC
add $s1, $s1, $s6		# incremenat $s6 posicos no array
la $t5, submarine	
lw $t2, 4($t5)			# recebe tamanho do barco
lw $s0, 8($sp)
jal gerarTabuleiro
lw $s2, 36($sp)			# recebe numero do barco no tabuleiro
addi $s2, $s2, 1		# incremenat $s2++
sw $s2, 36($sp)			# guarda $s2 na stack
addi $s4, $s4, 1		# incrementa o contador de barcos
sw $s4, 20($sp)			# guarda na stack $s4
addi $s5, $s5, 1		# i++
addi $s6, $s6, 12		# increenta o avanco de posicoes do array de barcos
j cicloNumSubmarine

numPatrol:
li $v0, 4
la $a0, editNumPatrol
syscall
li $v0, 5
syscall
bge $v0, 10, numPatrol
add $t0, $v0, $0		# recebe o inteiro do utilizador
lw $s5, 24($sp)			# recebe o I
cicloNumPatrol:
bge $s5, $t0, iniciarJogoPC	# If(I >= numeroDeBarcos) vai para o iniciar Jogo
lw $s4, 20($sp)			# recebe o contador de barcos
bge $s4, 10, iniciarJogoPC	# if($s4 >= 10)
lw $s1, 12($sp)			# recebe o endereco de barcos
add $s1, $s1, $s6		# avanca $s6 posicoes
#Gerar Carrier Utilizador
la $t5, patrol		
lw $t2, 4($t5)			# recebe tamanho do barco de $t5
lw $s0, 4($sp)			
jal gerarTabuleiro
#Gerar Carrier PC	
lw $s1, 16($sp)			# recebe o endereco de barcos PC
add $s1, $s1, $s6		# avanca $s6 posicoes no array
la $t5, patrol
lw $t2, 4($t5)			# recebe o tamanho do barco
lw $s0, 8($sp)
jal gerarTabuleiro
lw $s2, 36($sp)			# recebe o numero do barco no tabuleiro
addi $s2, $s2, 1		# incrementa $s2++
sw $s2, 36($sp)			# guarda $s2 na stack
addi $s4, $s4, 1		# contador de barcos ++
sw $s4, 20($sp)			# guarda na stacl
addi $s5, $s5, 1		# i++
addi $s6, $s6, 12		# incrementa o avanco de posicoes no array de barcos
j cicloNumPatrol

iniciarJogoPC:
lw $s0, 4($sp)			# recebe o endereco do tabuleiro
jal displayTabuleiro		# chama funcao de display do tabuleiro

lw $s0, 8($sp)			# recebe o endereco do tabuleiro do PC
#jal displayTabuleiro

lw $s1, 12($sp)			# recebe o endereco do array de barcos
lw $s3, 16($sp) 		# recebe o endereco do array de barcos do PC
jal jogoPC			# chama a funcao do jogo (jogoPC)
	
li $v0, 4			
la $a0, pontosUtilizador
syscall
li $v0, 1			# print inteiro
lw $t4, 0($s7)			# recebe o valor da primeira posicao do arary de pontuacoes (pontuacao do utilzaidor)
move $a0, $t4			# move o valor para $a0
syscall
li $v0, 4
la $a0, Enter
syscall
li $v0, 4
la $a0, pontosPC
syscall
li $v0, 1			# print inteiro
lw $t4, 4($s7)			# recebe o valor da primeira posicao do arary de pontuacoes (pontuacao do PC)
move $a0, $t4			# move o valor para $a0
syscall				
li $v0, 4
la $a0, Enter
syscall

lw $ra, 0($sp)			# recebe o $ra
addi $sp, $sp, 40		# sube a stack
jr $ra


jogo:
# a0 -> endere?o dos barcos
# a1 -> endereco do tabulerio 	
# $s0 -> endere?o do copiaTabuleiro  
# $t1 -> char coluna
# $t2 -> numero linha
# $t3 -> posi??o escolhida pelo utilizador final / size do barco acertado
# $t4 -> valores dos tabuleiros
# $t5 -> Valor a por no tabuleiro (X -> Bomba / 0 -> Agua)
# $t6 -> contadores de barcos

add $sp, $sp, -16		# baixa a stack
sw $ra, 0($sp)			# guarda $ra
add $a0, $s1, $0		# recebe em $a0 o valor de $s1
add $a1, $s0, $0		# recebe em $a1 o valor de $s0	
la $s0, copiaTabuleiro		# recebe o endereco de copiaTabuleiro
sw $a0, 4($sp)			# guarda $a0 na stack
sw $a1, 8($sp)			# guarda $a1 na stack
sw $s0, 12($sp)			# guarda $s0 na stack
jal zerarTabuleiroCopia		# chama a funcao de zerarTabuleiroCopia cria e inicializa a copiaTabuleiro a '-'
cicloJogo:
	jal displayTabuleiroJogo	# chama funcao de display do tabuleiro do jogo (copiaTabuleiro)
	posUtilizador:
	lw $a0, 4($sp)			# recebe o endereco dos barcos
	li $v0, 12			# le carater do teclado (linha do tabuleiro)
	syscall
	add $t1, $v0, $0		# iguala $t1 ao carater inserido pelo utilzaidor
	li $v0, 5			# le inteiro do teclado (coluna do tabuleiro) 
	syscall
	add $t2, $v0, $0		# iguala $t2 ao inteiro inserido pelo utilzaidor	
	addi $t1, $t1, -97		# Passar de A -> 1, b -> 2 etc... (97 e o valor de A)
	bge $t1, 10, posUtilizador	# if(valor da letra >= 10) esta fora do tabuleiro volta a pedir todo de novo ao utilzador
	bge $t2, 10, posUtilizador	# if(coluna >= 10) esta fora do tabuleiro volta a pedir todo de novo ao utilzador
	mul $t1, $t1, 4			# multiplica o valor da letra * 4 para usar nas posicoes do array dos tabuleiros (4 -> por ser coluna)
	mul $t2, $t2, 40		# multiplica o valor da letra * 40 para usar nas posicoes do array dos tabuleiros (40 -> por ser linha)
	add $t3, $t1, $t2		# soma todo para $t3 e isto e a posicao no array dos tabuleiros
	bge $t3, 400, posUtilizador	# if ($t3 >= 400) esta fora do tabuleiro volta a pedir todo de novo ao utilizador
	
	lw $a1, 8($sp)			# recebe o endereco do tabuleiro
	la $t0, copiaTabuleiro		# recebe o endereco da copiaTabuleiro
	add $t0, $t0, $t3		# avanca para a posicao que o utilizador escolheu no array copiaTabuleiro
	lw $t4, 0($t0)			# recebe o valor dessa posicao
	bne $t4, '-', jogadaRepetida	# if($t4 != '-') esta posicaoja foi inserida anteriormente 
		add $a1, $a1, $t3			# avanca para a posicao inserida pelo utilizador no tabuleiro
		lw $t4, 0($a1)				# recebe o valor em $t4
		beq $t4, '-', aguaJogada		# if($t4 == '-') nao havia barco nessa posicao ent e agua
		lw $a0, 4($sp)				# else{ recebe o endereco do array de barcos
		cicloVerArrayBarco:
			lw $t6, 0($a0)				# recebe o valor do endereco de barcos	
			bne $t4, $t6, incrementar_a0		# if(barco da posicao utilizador != barco do array) continua a avancar no array ate encontrar o barco certo
			lw $t3, 4($a0)				# se os barcos sao iguais, recebe o tamanho do barco do array de barcos
			lw $t6, 8($a0)				# recebe o contador de quantas pecas desse barco foram destruidas
			addi $t6, $t6, 1			# incrementa o numero de pecas destruidas
			sw $t6, 8($a0)				# guarda no array
			la $t5, 'X'				# $t5 = 'X'
			sw $t5, 0($t0)				# guarda 'X' no copiaTabuleiro na posicao do utilizador
			jal displayTabuleiroJogo		# chama funcao de display do tabuleiro
			bne $t3, $t6, acertouJogada		# if(tamanho do barco != contador de pecas destruidas) barco ainda nao afundou
				li $v0, 4			# else escreve "afundou" na consola
				la $a0, JogadaAfundou
				syscall
			acertouJogada:
			li $v0, 4				# escreve "bomba" na consola
			la $a0, JogadaBomba
			syscall
			j chekarSeTodosBarcosAfundaram		# jump para ver se todos os barcos do array ja foram afundados
			incrementar_a0:
			addi $a0, $a0, 12 			# incrementa endereco de barcos para continuar no ciclo para ver os barcos do array e o barco do tabuleiro acertado
			j cicloVerArrayBarco
		aguaJogada:
		la $t5, '0'			# $t5 = '0'
		sw $t5, 0($t0)			# guarda '0' no copiaTabuleiro na posicao do utilizador
		jal displayTabuleiroJogo	# chama funcao de display do tabuleiro
		li $v0, 4			# escreve "agua" na consola
		la $a0, JogadaAgua
		syscall
		j posUtilizador			# volta a pedir as posicoes ao utilizador

		chekarSeTodosBarcosAfundaram:
		lw $a0, 4($sp)			# recebe o endereco dos barcos
		# t4 -> barco
		# t5 -> size barco
		# t6 -> contador barco
		ciclo_chekarSeTodosBarcosAfundaram:	
		lw $t4, 0($a0)				# recebe o numero do barcos 
		lw $t5, 4($a0)				# recebe o tamanho do barco
		lw $t6, 8($a0)				# recebe o contador de pecas destruidas do barco
		bne $t5, $t6, posUtilizador		# if($t5 != $t6) existe pelo menis um barco que ainda nao afundou ent o jogo ainda n acaba
		bge $t4, 100, sairJogo			# if($t4 >= 100) todos os barcos afundaram (100 e um valor escolhido por mim como ultimo valor do array de barcos se chegar ate este valor quer dizer q todos os barco afundaram)
		add $a0, $a0, 12			# incremenat o array de barcos (12 em 12 (assembly) / 4 em 4 (C)) pois ada barco tem 4 posicoes reservadas para si no array
		j ciclo_chekarSeTodosBarcosAfundaram	# chama o ciclo de novo
	jogadaRepetida:
	li $v0, 4			# Escreve que a posicao ja foi inserida anteriormente e pede ao utilizador para inserir outra
	la $a0, JogadaRepetida
	syscall
	j posUtilizador
j cicloJogo
sairJogo:
zerarArrayBarcos:
lw $a0, 4($sp)		# recebe o endereco dos barcos
# t4 -> barco
# t5 -> size barco
# t6 -> contador barco
ciclo_zerarArrayBarcos:
lw $t4, 0($a0)				# recebe o numero do barco
bge $t4, 100, sairJogoDepoisDeZerar	# if($t4 >= 100) ja zerou todos os barcos
add $t4, $0, $0				# iguala $t4 = 0
sw $t4, 0($a0)				# insere no array de barcos
add $a0, $a0, 12			# avanca 12 posicoes no array
j ciclo_zerarArrayBarcos		# chama o ciclo de novo

sairJogoDepoisDeZerar:
add $t4, $0, $0			# iguala $t4 = 0
sw $t4, 0($a0)			# guarda no aray de barcos (para substituir o 100 por 0)
lw $ra, 0($sp)			# recebe $ra
add $sp, $sp, 16		# sube a stack
jr $ra				# returna da funcao



jogoPC:
# a0 -> endere?o dos barcos
# a1 -> endereco dos barcosPC
# a2 -> Pontuacoes
# $s0 -> endere?o do tabuleiro
# $s1 -> endere?o do copiaTabuleiro
# $s2 -> endere?o do tabuleiroPC
# $s3 -> endere?o do copiaTabuleiroPC
# $t1 -> char coluna
# $t2 -> numero linha
# $t3 -> posi??o escolhida pelo utilizador final / size do barco acertado
# $t4 -> valores dos tabuleiros
# $t5 -> Valor a por no tabuleiro (X -> Bomba / 0 -> Agua)
# $t6 -> contadores de barcos
# $t7 -> vez de jogar (1 -> Utilizador / 2-> PC)
add $sp, $sp, -32		# baixar a stack
sw $ra, 0($sp)			# guardar $ra na stack
add $a0, $s1, $0		# $a0 recebe o valor de $s1 (endereco do aray dos barcos)
add $a2, $s7, $0		# $a2 recebe o valor de $s7 (endereco do aray de pontuacoes)
add $a1, $s3, $0		# $a1 recebe o valor de $s3 (endereco do aray dos barcosPC)
la $s0, tabuleiro
la $s1, copiaTabuleiro
la $s2, tabuleiroPC
la $s3, copiaTabuleiroPC
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $a2, 12($sp)
sw $s0, 16($sp)
sw $s1, 20($sp)
sw $s2, 24($sp)
sw $s3, 28($sp)
add $t7, $0, $0
addi $t9, $0, -1
jal copiarTabuleiroCopia	# funcao que copia o tabuleiro utilizador para a copia Tabuleiro utilizador
jal zerarTabuleiroCopiaPC	# cria e inicializa a '-' a opia do tabuleiro do PC
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
cicloJogoPC:
	jal displayTabuleiroBitMap	# funcao que da displçay ao tabuleiro no bitmap
	jal displayTabuleiroJogoPC	# funcao que da display ao tabuleiro do jogo
	lw $a0, 4($sp)			
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	validarVezJogada:
	beq $t7, 2, vezPC		# if($t7 == 2) e o PC a jogar
	vezUtilizador:
	li $v0, 4			
	la $a0, vezJogarUtilizador
	syscall
	lw $a1, 8($sp)			# recebe endereco barcos PC
	li $v0, 12
	syscall
	add $t1, $v0, $0		# recebe coluna inserida pelo utilizador
	li $v0, 5
	syscall
	add $t2, $v0, $0		# recebe linha inserida pelo utilizador
	addi $t1, $t1, -97		# Passar de A -> 1, b -> 2 etc... (97 e o valor de A)
	bge $t1, 10, vezUtilizador	# if(coluna > 10) esta fora fo tabuleiro volta a pedir ao utlizador as posicoes
	bge $t2, 10, vezUtilizador	# if(linha > 10) esta fora fo tabuleiro volta a pedir ao utlizador as posicoes
	mul $t1, $t1, 4			# multiplica coluna * 4 (colunas sao de 4 rm 4)
	mul $t2, $t2, 40		# multiplica linha * 40 (linhas sao de 40 em 40)
	add $t3, $t1, $t2		# soma linhas e coluna e recebe a posicao no array que o utilizador escolheu
	bge $t3, 400, vezUtilizador	# if(pos do utilizador > 400) esta fora do array pede tudo de novo ao utilizador
	
	lw $s2, 24($sp)			# recebe endereco de tabuleiroPC
	lw $s3, 28($sp)			# recebe endereco de copiaTabuleiroPC
	add $s3, $s3, $t3		# avanca a copiaTabuleiroPC ate a posicao do utilizador
	lw $t4, 0($s3)			# recebe o valor
	bne $t4, '-', jogadaRepetidaUtilizador		# if($t4 != '-') esta posicaoja foi inserida anteriormente
		add $s2, $s2, $t3			# avanca tabuleiroPC para a posicao do utilizador
		lw $t4, 0($s2)				# recebe o valor
		beq $t4, '-', aguaJogadaUtilizador	# if($t4 == '-') n tem barco
		lw $a1, 8($sp)				# else{ recebe o endereco de barcosPC
		cicloVerArrayBarcoUtilizador:		
			lw $t6, 0($a1)					
			bne $t4, $t6, incrementar_a1_Utilizador		# if($t4 != $t6) o barco da pos atual do aaray n e o mesmo da pos do tabulerio ent vai incremenatr a0
			
			lw $t3, 4($a1)					# else{ recebe o tamanho do barco
			lw $t6, 8($a1)					# recebe o contador de pecas destruidas do barco
			addi $t6, $t6, 1				# incrementa 1 peca destruida	
			sw $t6, 8($a1)					# guarda no array
			la $t5, 'X'					
			sw $t5, 0($s3)					# guarda 'X' no copiaTabuleiroPC na pos do utilziador
			#jal displayTabuleiroJogoPC
			bne $t3, $t6, acertouJogadaUtilizador		# if($t4 != $t6) barco n afundou
				li $v0, 4				# else{ escreve 'afundou' na consola
				la $a0, JogadaAfundou
				syscall
			acertouJogadaUtilizador:
			
			div $t1, $t1, 4			# divide $t1 por 4 (para returnar ao valor original da coluna)
			div $t2, $t2, 40		# divide $t2 por 40 (para returnar ao valor original da linha)
			mul $t1, $t1, 25		# multiplica por 25 (diferenca de cada quadrado no bitmap)
			mul $t2, $t2, 25		# multiplica por 25 (diferenca de cada quadrado no bitmap)
			add $t1, $t1, 260		# adiciona 260 diferenca entre cada peca do tabuleiro do utilizador para o tabulerio do pc
			#li $a0,20
			add $a0, $0, $t1		# codigo para criar quadrado no bitmap
			li $a1,20	
			#li $a2,20
			add $a2, $0, $t2
			li $a3,20
			addi $t9, $0, 16711680		# Cor vermelho
			jal rectangle
		
			lw $a0, 4($sp)
			lw $a1, 8($sp)
			lw $a2, 12($sp)
			
			li $v0, 4			# Escreve 'bomba' na consola
			la $a0, JogadaBomba
			syscall
			j chekarSeTodosBarcosAfundaramUtilizador
			incrementar_a1_Utilizador:
			addi $a1, $a1, 12 
			j cicloVerArrayBarcoUtilizador
		aguaJogadaUtilizador:
		
		div $t1, $t1, 4			# divide $t1 por 4 (para returnar ao valor original da coluna)
		div $t2, $t2, 40		# divide $t2 por 40 (para returnar ao valor original da linha)
		mul $t1, $t1, 25		# multiplica por 25 (diferenca de cada quadrado no bitmap)
		mul $t2, $t2, 25		# multiplica por 25 (diferenca de cada quadrado no bitmap)
		add $t1, $t1, 260		# adiciona 260 diferenca entre cada peca do tabuleiro do utilizador para o tabulerio do pc
		#li $a0,20
		add $a0, $0, $t1		# codigo para criar quadrado no bitmap
		li $a1,20
		#li $a2,20
		add $a2, $0, $t2
		li $a3,20
		addi $t9, $0, 65535 		# Cor aqua
		jal rectangle
		
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		
		la $t5, '0'			# insere '0' no copiaTabuleiroPC
		sw $t5, 0($s3)
		#jal displayTabuleiroJogoPC
		li $v0, 4			# Escreve 'agua' na cosola
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
		bge $t4, 100, vitoriaUtilizador
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
	#jal gerarNumeroRandom
	jal gerarLinhaColunaRandom	# gera aleatoriamente uma coluna 0-10
	add $t1, $v0, $0
	jal gerarLinhaColunaRandom	# gera aleatoriamente uma linha 0-10
	add $t2, $v0,$0
	bge $t1, 10, vezPC
	bge $t2, 10, vezPC
	mul $t1, $t1, 4
	mul $t2, $t2, 40
	add $t3, $t1, $t2
	bge $t3, 400, vezPC
	
	lw $s0, 16($sp)
	lw $s1, 20($sp)
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
			#jal displayTabuleiroJogo
			
			div $t1, $t1, 4
			div $t2, $t2, 40
			mul $t1, $t1, 25
			mul $t2, $t2, 25
			#li $a0,20
			add $a0, $0, $t1
			li $a1,20
			#li $a2,20
			add $a2, $0, $t2
			li $a3,20
			addi $t9, $0, 16711680		# Cor vermelho
			jal rectangle
		
			lw $a0, 4($sp)
			lw $a1, 8($sp)
			lw $a2, 12($sp)
			
			j chekarSeTodosBarcosAfundaramPC
			incrementar_a0_PC:
			addi $a0, $a0, 12
			j cicloVerArrayBarcoPC
		aguaJogadaPC:
		
		div $t1, $t1, 4
		div $t2, $t2, 40
		mul $t1, $t1, 25
		mul $t2, $t2, 25
		#li $a0,20
		add $a0, $0, $t1
		li $a1,20
		#li $a2,20
		add $a2, $0, $t2
		li $a3,20
		addi $t9, $0, 65535 	# Cor aqua
		jal rectangle
		
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		
		la $t5, '0'
		sw $t5, 0($s1)
		#jal displayTabuleiroJogo
		addi $t7, $0, 1
		j validarVezJogada
		
		chekarSeTodosBarcosAfundaramPC:
		lw $a0, 4($sp)
		ciclo_chekarSeTodosBarcosAfundaramPC:
		lw $t4, 0($a0)
		lw $t5, 4($a0)
		lw $t6, 8($a0)
		bne $t5, $t6, vezPC
		bge $t4, 100, vitoriaPC
		add $a0, $a0, 12
		j ciclo_chekarSeTodosBarcosAfundaramPC
	jogadaRepetidaPC:
	j vezPC
j cicloJogoPC
vitoriaUtilizador:
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $t5, 0($a2)			# recbe pontuacao do utilizador
addi $t4, $t5, 5		# adiciona 5
sw $t4, 0($a2)			# guarda
lw $t5, 4($a2)			# recbe pontuacao do PC
addi $t4, $t5, -3		# decrementa -3
blt $t4, 0, igualarDerrotaPC0	# if($t4 < 0) vai igualar $t4 = 0 pois n existem pontuacoes negativas
sw $t4, 4($a2)			# guarda
j sairJogoPC
igualarDerrotaPC0:
add $t4, $0, $0			# iguala $t4 = 0
sw $t4, 4($a2)			# guarda
j sairJogoPC
vitoriaPC:
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $t5, 4($a2)
addi $t4, $t5, 5
sw $t4, 4($a2)
lw $t5, 0($a2)
addi $t4, $t5, -3
blt $t4, 0, igualarDerrotaUtilizador0
sw $t4, 0($a2)
j sairJogoPC
igualarDerrotaUtilizador0:
add $t4, $0, $0
sw $t4, 0($a2)
j sairJogoPC
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
lw $ra, 0($sp)
add $sp, $sp, 32
jr $ra




copiarTabuleiroCopia:
# a0 -> copiaTabulerio
# a1 -> tabuleiro
#t1 -> i
#t2 -> valor da pos de $a1
add $a0, $s1, $0
add $a1, $s0, $0
add $t1, $0, $0
copiar_tabuleiroCopia_for:
	lw $t2, 0($a1)		# recebo o valor do tabuleiro
	bge $t1, 100, sair_copiar_tabuleiroCopia_for		# i >= 100 sai do ciclo
	sw $t2, 0($a0)		# guardo o valor na copiaTabuleiro
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	addi $t1, $t1, 1
	j copiar_tabuleiroCopia_for
sair_copiar_tabuleiroCopia_for:
jr $ra



zerarTabuleiroCopiaPC:
# a0 -> copiaTabuleiroPC
#t1 -> i
#t2 -> '-'
add $a0, $s3, $0
add $t1, $0, $0
li $t2, '-'
zerar_tabuleiroCopiaPC_for:
	bge $t1, 100, sair_zerar_tabuleiroCopiaPC_for		# i >= 100 sai do ciclo
	sw $t2, 0($a0)		# Insiro '-' nas posicoes do copiaTabuleiroPC
	addi $a0, $a0, 4
	addi $t1, $t1, 1
	j zerar_tabuleiroCopiaPC_for
sair_zerar_tabuleiroCopiaPC_for:
jr $ra


displayTabuleiroBitMap:
# $s0 -> endereco copiaTabuleiroPC
# $s1 -> endereco copiaTabuleiro
#t7 -> i
#t8 -> j
#t5 -> axis X
#t4 -> val do endere?o
#t6 -> axis Y
#t9 -> cor
add $sp, $sp, -12
sw $ra, 0($sp)
la $s0, copiaTabuleiroPC
la $s1, copiaTabuleiro
sw $s0, 4($sp)
sw $s1, 8($sp)
addi $t5, $0, 0
add $t7, $0, $0
addi $t6, $0, 0
addi $t9, $0, -1
displayTabuleiroBitMap_1for:
	bge $t7, 10, sair_displayTabuleiroBitMap_1for		# i >= 10 sai do ciclo
	add $t8, $0, $0
	displayTabuleiroBitMap_2for:
		bge $t8, 10, sair_displayTabuleiroBitMap_2for		# j >= 10 sai do ciclo
		lw $t4, 0($s1)		# recebo o valor do copiaTabuleiro

		# codigo do quadrado no bitmap
		add $a0, $0, $t5		# adicono a $ao o valor da pos de X
		li $a1,20
		add $a2, $0, $t6		# adicono a $ao o valor da pos de Y	
		li $a3,20
		bne $t4, '-', bitMapComBarco	# if(valor do tabulerio != '-') e um barco
		jal rectangle			# else cria um quadrado branco
		j bitMapPc
		bitMapComBarco:
		addi $t9, $0, 200		# se e barco insere um quadrado com cor 200 (azul)
		jal rectangle
		addi $t9, $0, -1		# volta a cor branca
		j bitMapPc

		bitMapPc:
		add $t5, $t5, 260		# adicono a $t5 + 260 (260 e a diferenca entra os quadrados Utilizador apara os do PC)
		lw $t4, 0($s0)

		# codigo do quadrado no bitmap
		add $a0, $0, $t5		# adicono a $ao o valor da pos de X
		li $a1,20
		add $a2, $0, $t6		# adicono a $ao o valor da pos de Y	
		li $a3,20
		add $t5, $t5, -260		# volto $t5 ao valor do quandrado do utilizador
		jal rectangle
		
		addi $s0, $s0, 4
		addi $s1, $s1, 4
		add $t5, $t5, 25	# incremento $t5 + 25 ( 25 e a diferenca entre cada quadrado no axis X)
		addi $t8, $t8, 1
		j displayTabuleiroBitMap_2for
	sair_displayTabuleiroBitMap_2for:
	addi $t5, $0, 0		# igualo $t5 = 0 para voltar a primeira coluna 
	add $t6, $t6, 25	# incremento $t6 + 25 ( 25 e a diferenca entre cada quadrado no axis Y)
	addi $t7, $t7, 1
	j displayTabuleiroBitMap_1for
sair_displayTabuleiroBitMap_1for:
lw $ra, 0($sp)
add $sp, $sp, 12
jr $ra


displayTabuleiroJogoPC:
#a0 -> copiaTabuleiroPC
#t1 -> i
#t2 -> j
#t4 -> val do endere?o
add $sp, $sp -4
add $a0, $s3, $0
sw $a0, 0($sp)
add $t1, $0, $0
displayTabuleiroJogoPC_1for:
	bge $t1, 10, sair_displayTabuleiroJogoPC_1for		# i >= 10 sai do ciclo
	add $t2, $0, $0
	displayTabuleiroJogoPC_2for:
		bge $t2, 10, sair_displayTabuleiroJogoPC_2for		# j >= 10 sai do ciclo
		li $v0, 4
		lw $t4, 0($a0)			# recebo o valor do copiaTabuleiroPC
		sw $t4, valCopiaTabuleiro	# guardo o valor num array auxiliar para usar o seu endereco para escrever o valor na consola (como String)
		la $a0, valCopiaTabuleiro	# guardo o endereco do array auxiliar em a0 para escrever o seu valor na consola (como String)
		syscall
		lw $a0, 0($sp)
		addi $a0, $a0, 4
		sw $a0, 0($sp)
		addi $t2, $t2, 1
		j displayTabuleiroJogoPC_2for
	sair_displayTabuleiroJogoPC_2for:
	li $v0, 4
	la $a0, Enter
	syscall
	lw $a0, 0($sp)
	addi $t1, $t1, 1
	j displayTabuleiroJogoPC_1for
sair_displayTabuleiroJogoPC_1for:
li $v0, 4
la $a0, Enter
syscall
add $sp, $sp, 4
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
		lw $t4, 0($a0)				# recebo o valor do tabuleiro
		beq $t4, '-', printString		# if($t4 == '-') e string ent quero dar print na consola de uma string
		li $v0, 1				# else { passo o  valor para $a0 e escrevo na consola como inteiro
		move $a0, $t4
		syscall
		j increment_displayTabuleiro_2for
		printString:
		li $v0, 4
		sw $t4, valTabuleiro			# guardo o valor num array auxiliar para escrever como string
		la $a0, valTabuleiro			# guardo o endereco dese array auxiliar no $a0 para escrever na consola o seu valor
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
#s0 -> copiaTabuleiro
#t1 -> i
#t2 -> j
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
		lw $t4, 0($s0)				# recebo o valor do copiaTabuleiro
		beq $t4, '-', printStringJogo		# if($t4 == '-') e string quero dar print a uma string
		beq $t4, '0', printStringJogo		# if($t4 == '0') e string quero dar print a uma string
		beq $t4, 'X', printStringJogo		# if($t4 == 'X') e string quero dar print a uma string
		li $v0, 1
		move $a0, $t4				# else{ e inteiro movo o valor para $a0 e escrevo na consola
		syscall
		lw $s0, 0($sp)
		j incrementarS0
		printStringJogo:
		li $v0, 4
		sw $t4, valCopiaTabuleiro		# guardo o valor num arrray auxiliar para depois escrever como string
		la $a0, valCopiaTabuleiro		# $a0 recebe o endereco desse array auxiliar e escrever o seu valor na consola
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
#t2 -> '-'

add $a0, $s0, $0
add $t9, $0, $0
li $t2, '-'
zerar_tabuleiroCopia_for:
	bge $t9, 100, sair_zerar_tabuleiroCopia_for		# i >= 100 sai do ciclo
	sw $t2, 0($a0)		# insere '-' em todas as posicoes de copiaTabuleiro
	addi $a0, $a0, 4
	addi $t9, $t9, 1
	j zerar_tabuleiroCopia_for
sair_zerar_tabuleiroCopia_for:
jr $ra


gerarTabuleiro:
# $a0 -> Size do Barco
# $a1 -> Numero do Barco
# $a2 -> array dos barcos
# $a3 -> Endereco do tabuleiro
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
add $a1, $s2, $0	# Guardar a Numero do Barco em $a1
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
		add $t5, $a0, -1		# Size do barco -1 (precisa de ser -1 por causa dos arrays comecarem em 0 ent um barco de 5 vai de 0 a 4 no array)
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
	lw $a1, 8($sp)		# Receber da stack o Numero do barco
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
	sw $t2, 0($a0)		# escreve '-' em todas as posicoes do array
	addi $a0, $a0, 4
	addi $t9, $t9, 1
	j zerar_tabuleiro_for
sair_zerar_tabuleiro_for:
jr $ra


barcosEdit:
# $t0 -> endere?o do barco
# $t2 -> tamanho do barco
# $t1 -> valores do size do barco / letra do barco

carrierBarcoEditMenu:
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
bge $v0, 10, carrierBarcoEditMenu
add $t2, $v0, $0

carrierBarcoEdit:
la $t0, carrier
la $t1, 'C'			# letra do barco
sw $t1, 0($t0)			# guarda a letra na primeira posicao do array do barco
ble $t2, 0, tamanhoPadraoCarrier
add $t1, $0, $t2		# iguala $t1 ao tamanho do barco escolhido pelo utilizador
j skipEditCarrier
tamanhoPadraoCarrier:
addi $t1, $0, 5			# iguala $t1 ao tamanho padrao do barco
skipEditCarrier:
sw $t1, 4($t0)			# guarda o tamanho do barco na segunda posicao do array do barco

battleshipBarcoEditMenu:
li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoBattleship
syscall
li $v0, 5
syscall
bge $v0, 10, battleshipBarcoEditMenu
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

destroyerBarcoEditMenu:
li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoDestroyer
syscall
li $v0, 5
syscall
bge $v0, 10, destroyerBarcoEditMenu
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

submarineBarcoEditMenu:
li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoSubmarine
syscall
li $v0, 5
syscall
bge $v0, 10, submarineBarcoEditMenu
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

patrolBarcoEditMenu:
li $v0, 4
la $a0, editSizeBarco
syscall
li $v0, 4
la $a0, barcoPatrol
syscall
li $v0, 5
syscall
bge $v0, 10, patrolBarcoEditMenu
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
la $t9, 'C'		# letra do barco
sw $t9, 0($t0)		# guarda a letra na primeira posicao do array do barco
addi $t9, $0, 5		# tamanho do barco
sw $t9, 4($t0)		#  guarda o tamanho do barco na segunda posicao do array do barco
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
