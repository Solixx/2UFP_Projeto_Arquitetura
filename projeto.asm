.data
MSGColuna: 	.asciiz "Insira uma coluna \n"
MSGLinha: 	.asciiz "Insira uma linha \n"
Enter:		.asciiz "\n"

.align 2
tabuleiro: 	.space 400	# Tabuleiro 
copiaTabuleiro:	.space 400	# Copia do tabuleiro (mostrar na tela do jogo)
arrayDePos:	.word		# Posi��es para colocar os barcos (usado na fun��o gerarTabuleiro)
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
addi $t1, $0, 4
li $t2, 'B'
jal gerarTabuleiro
addi $t1, $0, 3
li $t2, 'D'
jal gerarTabuleiro
addi $t1, $0, 3
li $t2, 'S'
jal gerarTabuleiro
addi $t1, $0, 2
li $t2, 'P'
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
# $s1 -> Pois��es das Pe�as do Barco
# $t1 -> posi��o do barco antes de chackar se vazia / posi��o do barco para add Letra
# $t2 -> Valor na Pos do tabuleiro
# $t3 -> Axis (Horizontal = 0 / Vertical = 1)
# $t4 -> valor para valida��es como numero max etc.. / recebe o valor de uma posi��o do tabuleiro para teste de posi��es com '0'
# $t5 -> size Barco *4
# $t6 -> Saber se vou validar cima/baixo 	(0 -> validar ambas / 1 -> nao validar cima / 2 -> n�o validar baixo)
# $t7 -> Saber se vou validar esquerda/direita 	(0 -> validar / 1 -> nao validar esquerda / 2 -> n�o validar direita)
# $t9 -> I

add $sp, $sp, -12	# Baixar a Stack
sw $ra, 0($sp)		# Guardar o $ra desta fun��o
add $a0, $t1, $0	# Guardar o Size do Barco em $a0
add $a1, $t2, $0	# Guardar a Letra do Barco em $a1
sw $a0, 4($sp)		# Guardo o Size do Barco na stack pq vou perder o valor de $a0 noutras fun��es
sw $a1, 8($sp)		# Guardo a Letra do Barco na stack pq vou perder o valor de $a1 noutras fun��es
add $t1, $0, $0
add $t2, $0, $0
add $t3, $0, $0
add $t4, $0, $0
add $t5, $0, $0
add $t6, $0, $0
add $t7, $0, $0
la $s0, tabuleiro	# Guardar o endere�o do tabuleiro em $s0
la $s1, arrayDePos	# Guardar o endere�o do arrayDePos em $s1
#TODO
gerarPos:
	jal gerarAxRandom		# Fun��o que gera Numero entre 0 < 2
	add $t3, $v0, $0		# Guarda o valor que vai ser usado para saber em que dire��o adicionar as pe�as do barco
	addi $t3, $0, 0
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun��es)
	beq $t3, 0, validacoesHor
	validacoesVert:
		addi $t4, $0, 100		# Igualo $t4 = 100 (valor maximo do tabuleiro sem ser multiplicado por 4 / 0-100)
		add $t5, $a0, -1		# Size do barco -1
		mul $t5, $t5, 10		# (Size do barco-1) * 10
		sub $t4, $t4, $t5		# 100 - ((Size do barco-1) * 10) / Usado para saber o limite do numero gerado na fun��o gerarNumeroRandomVert (tabuleiro sem ser multiplicado por 4 / 0-100)
		jal gerarNumeroRandomVert	# Fun��o que gera Numero entre 0 < 60
		add $t1, $v0, $0		# Guarda a primeira posi��op gerada pela fun��o "gerarNumeroRandom"
		addi $t1, $0, 0
		
		jal validarCima		# Chama fun��o que vai validar se vou precisar validar a linha de cima
		add $t6, $v0, $0		# recebe o valor da fun��o
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun��es)
		j sairValidarCimaBaixo		# se $t6 = 1 ent�o estou na primeira linha e n�o preciso de fazer "validarLinhaBaixo"
		
		jal validarBaixo
		add $t6, $v0, $0
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun��es)
		
		sairValidarCimaBaixo:
		mul $t1, $t1, 4			# Multiplicar essa posi��o para ser usada nos arrays
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun��es)
		
	j sair_validacoes
	validacoesHor:
		jal gerarNumeroRandom		# Fun��o que gera Numero entre 0 < 100
		add $t1, $v0, $0		# Guarda a primeira posi��op gerada pela fun��o "gerarNumeroRandom"
		addi $t1, $0, 0
		mul $t1, $t1, 4			# Multiplicar essa posi��o para ser usada nos arrays
		lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun��es)
		mul $t5, $a0, 4			# Size do barco * 4
		Hor_t1_entre_0_36:		# Testes na primeira linha
		bge $t1, 40, Hor_t1_entre_40_76		# if($t1 >= 40) vai para o teste da 2� linha
			addi $t4, $0, 40		# $t4 = 40 ultima celula/coluna da linha
			sub $t4, $t4, $t5		# 40- (size do barco * 4) = � linha que ele pode ser colocado e n�o passar o limite da linha (ex: 36 passa a 20 num barco de size 5 assim vai do meio da linha at� ao fim nem ultrapassar)
			addi $t6, $0, 1			# Igual $t6 a 1 para saber que n�o vou validar a linha de cima (pois n�o existe)
			ble $t1, $t4, sair_validacoes	# se a posi��o que o barco vai ser colocado for maior que 40 - (size do barco * 4) ent mete o barco em $t4 (ex: 36 passa a 20 num barco de size 5 assim vai do meio da linha at� ao fim nem ultrapassar)
			add $t1, $0, $t4		# iguala $t1 a $t4
			j sair_validacoes		# sair das valida��es
		Hor_t1_entre_40_76:			# Mesma coisa da de cima mas para a 2� linha
		bge $t1, 80, Hor_t1_entre_80_116
			addi $t4, $0, 80
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_80_116:			# Mesma coisa da de cima mas para a 3� linha
		bge $t1, 120, Hor_t1_entre_120_156
			addi $t4, $0, 120
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_120_156:			# Mesma coisa da de cima mas para a 4� linha
		bge $t1, 160, Hor_t1_entre_160_196
			addi $t4, $0, 160
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_160_196:			# Mesma coisa da de cima mas para a 5� linha
		bge $t1, 200, Hor_t1_entre_200_236
			addi $t4, $0, 200
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes	
		Hor_t1_entre_200_236:			# Mesma coisa da de cima mas para a 6� linha
		bge $t1, 240, Hor_t1_entre_240_276
			addi $t4, $0, 240
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_240_276:			# Mesma coisa da de cima mas para a 7� linha
		bge $t1, 280, Hor_t1_entre_280_316
			addi $t4, $0, 280
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_280_316:			# Mesma coisa da de cima mas para a 8� linha
		bge $t1, 320, Hor_t1_entre_320_356
			addi $t4, $0, 320
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_320_356:			# Mesma coisa da de cima mas para a 9� linha
		bge $t1, 360, Hor_t1_entre_360_396
			addi $t4, $0, 360
			sub $t4, $t4, $t5
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
		Hor_t1_entre_360_396:			# Mesma coisa da de cima mas para a 10� linha
		bge $t1, 400, sair_validacoes
			addi $t4, $0, 400
			sub $t4, $t4, $t5
			addi $t6, $0, 2			# Igual $t6 a 2 para saber que n�o vou validar a linha de baixo (pois n�o existe)
			ble $t1, $t4, sair_validacoes
			add $t1, $0, $t4
			j sair_validacoes
			
	sair_validacoes:
	la $s0, tabuleiro		# Voltar a meter o valor do endere�o do tabuleiro em $a0 pois foi perdido na fun��o anterior "gerarNumeroRandom"
	add $s0, $s0, $t1		# Meter $s0 na posi��o gerada aleat�riamente
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun��es)
	
	jal validacoesEsquerda		# chama a fun��o que valida se vou ter de validar o lado esquerdo da posi��o
	add $t7, $v0, $0
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun��es)
	beq $t7, 1, validacoesPosicoes	# Se $t7 = 1 quer dizer q n vou validar � esquerda ent n�o preciso de ver a "validacoesDireita"
	
	jal validacoesDireita		# chama a fun��o que valida se vou ter de validar o lado esquerdo da posi��o
	add $t7, $v0, $0
	lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun��es)
	
	validacoesPosicoes:
	lw $t4, 0($s0)			# Recebe o valor do tabuleiro
	bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	j mainTeste1			# else salta para o prox teste
	mainTeste1:
	beq $t6, 1, mainTeste2		# Se $t6 = 1 n�o � para validar linha de cima ent�o dou skip a esta valida��o
	lw $t4, -40($s0)		# recebe o valor da linha de cima do tabulerio
	bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	j mainTeste2			# else salta para o prox teste
	mainTeste2:
	beq $t6, 1, mainTeste3		# Se $t6 = 1 n�o � para validar linha de cima ent�o dou skip a esta valida��o
	beq $t7, 2, mainTeste3		# Se $t6 = 1 n�o � para validar coluna da esquerda ent�o dou skip a esta valida��o
	lw $t4, -36($s0)		# recebe o valor da diagonal cima � direita de cima do tabulerio
	bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	j mainTeste3			# else salta para o prox teste
	mainTeste3:
	beq $t7, 2, mainTeste4		# Se $t6 = 1 n�o � para validar coluna da esquerda ent�o dou skip a esta valida��o
	lw $t4, 4($s0)			# recebe o valor da direita do tabulerio
	bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	j mainTeste4			# else salta para o prox teste
	mainTeste4:
	beq $t6, 2, mainTeste5		# Se $t6 = 2 n�o � para validar linha de baixo ent�o dou skip a esta valida��o
	beq $t7, 2, mainTeste5		# Se $t6 = 1 n�o � para validar coluna da esquerda ent�o dou skip a esta valida��o
	lw $t4, 44($s0)			# recebe o valor da diagonal baixo � direita do tabulerio
	bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	j mainTeste5			# else salta para o prox teste
	mainTeste5:
	beq $t6, 2, mainTeste6		# Se $t6 = 2 n�o � para validar linha de baixo ent�o dou skip a esta valida��o
	lw $t4, 40($s0)			# recebe o valor da linha de baixo do tabulerio
	bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	j mainTeste6			# else salta para o prox teste
	mainTeste6:
	beq $t6, 2, mainTeste7		# Se $t6 = 2 n�o � para validar linha de baixo ent�o dou skip a esta valida��o
	beq $t7, 1, mainTeste7		# Se $t6 = 1 n�o � para validar linha de cima ent�o dou skip a esta valida��o
	lw $t4, 36($s0)			# recebe o valor da diagonal baixo � esquerda do tabulerio
	bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	j mainTeste7			# else salta para o prox teste
	mainTeste7:
	beq $t7, 1, mainTeste8		# Se $t6 = 1 n�o � para validar coluna da esquerda ent�o dou skip a esta valida��o
	lw $t4, -4($s0)			# recebe o valor da esquerda do tabulerio
	bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	j mainTeste8			# else salta para o prox teste
	mainTeste8:
	beq $t6, 1, sairTeste		# Se $t6 = 1 n�o � para validar linha de cima ent�o dou skip a esta valida��o
	beq $t7, 1, sairTeste		# Se $t6 = 1 n�o � para validar linha de cima ent�o dou skip a esta valida��o
	lw $t4, -44($s0)		# recebe o valor da diagonal de cima � esquerda do tabulerio
	bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
	j sairTeste			# else salta para o prox teste
	
	sairTeste:
	addi $t9, $0, 0			# i = 0
	forSizeBarco:
		beq $t9, $a0, breakForSizeBarco	# If(I < Size) SAI -> breakForSizeBarco
		lw $t2, 0($s0)			# Recebe o valor dessa posi��o em $t2
		bne $t2, '0', gerarPos		# If($t2 != '0') SAI -> gerarPos
		beq $t3, 0, fazHorizontal	# If($t3 == 0) ($t2 = 0 -> Horizontal / $t2 = 1 -> Vertical)
		fazVertical:
			addi $s0, $s0, 40		# Ando para baixo no tabuleiro
			sw $t1, 0($s1)			# Guarda o valor de $t1 em $s1(array com as posi��es onde v�o ser inseridas as letras do barco no tabuleiro)
			addi $t1, $t1, 40		# $t1 + 40 para andar para baixo no tabuleiro (v�rias pe�as do barco)
			j sairDeAxis
		fazHorizontal:
			addi $s0, $s0, 4		# Ando para a direita no tabuleiro
			sw $t1, 0($s1)			# Guarda o valor de $t1 em $s1(array com as posi��es onde v�o ser inseridas as letras do barco no tabuleiro)
			addi $t1, $t1, 4		# $t1 + 4 para andar para a direita no tabuleiro (v�rias pe�as do barco)
			
			jal validacoesDireita		# chama a fun��o que valida se vou ter de validar o lado esquerdo da posi��o
			add $t7, $v0, $0
			lw $a0, 4($sp)			# Receber o size do barco pela stack (pois perco o valor do $a0 noutras fun��es)
			
			validacoesPosicoesHor:
			lw $t4, 0($s0)			# Recebe o valor do tabuleiro
			bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			j horTeste1			# else salta para o prox teste
			horTeste1:
			beq $t6, 1, horTeste2		# Se $t6 = 1 n�o � para validar linha de cima ent�o dou skip a esta valida��o
			lw $t4, -40($s0)		# recebe o valor da linha de cima do tabulerio
			bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			j horTeste2			# else salta para o prox teste
			horTeste2:
			beq $t6, 1, horTeste3		# Se $t6 = 1 n�o � para validar linha de cima ent�o dou skip a esta valida��o
			beq $t7, 2, horTeste3		# Se $t6 = 1 n�o � para validar coluna da esquerda ent�o dou skip a esta valida��o
			lw $t4, -36($s0)		# recebe o valor da diagonal cima � direita de cima do tabulerio
			bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			j horTeste3			# else salta para o prox teste
			horTeste3:
			beq $t7, 2, horTeste4		# Se $t6 = 1 n�o � para validar coluna da esquerda ent�o dou skip a esta valida��o
			lw $t4, 4($s0)			# recebe o valor da direita do tabulerio
			bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			j horTeste4			# else salta para o prox teste
			horTeste4:
			beq $t6, 2, horTeste5		# Se $t6 = 2 n�o � para validar linha de baixo ent�o dou skip a esta valida��o
			beq $t7, 2, horTeste5		# Se $t6 = 1 n�o � para validar coluna da esquerda ent�o dou skip a esta valida��o
			lw $t4, 44($s0)			# recebe o valor da diagonal baixo � direita do tabulerio
			bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			j horTeste5			# else salta para o prox teste
			horTeste5:
			beq $t6, 2, horTeste6		# Se $t6 = 2 n�o � para validar linha de baixo ent�o dou skip a esta valida��o
			lw $t4, 40($s0)			# recebe o valor da linha de baixo do tabulerio
			bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			j horTeste6			# else salta para o prox teste
			horTeste6:
			beq $t6, 2, horTeste7		# Se $t6 = 2 n�o � para validar linha de baixo ent�o dou skip a esta valida��o
			beq $t7, 1, horTeste7		# Se $t6 = 1 n�o � para validar linha de cima ent�o dou skip a esta valida��o
			lw $t4, 36($s0)			# recebe o valor da diagonal baixo � esquerda do tabulerio
			bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			j horTeste7			# else salta para o prox teste
			horTeste7:
			beq $t6, 1, sairTesteHor	# Se $t6 = 1 n�o � para validar linha de cima ent�o dou skip a esta valida��o
			beq $t7, 1, sairTesteHor	# Se $t6 = 1 n�o � para validar linha de cima ent�o dou skip a esta valida��o
			lw $t4, -44($s0)		# recebe o valor da diagonal de cima � esquerda do tabulerio
			bne $t4, '0', gerarPos		# if($t4 != '0') vai para gerarPos
			j sairTesteHor			# else salta para o prox teste
			
			sairTesteHor:
			j sairDeAxis
		sairDeAxis:
		addi $s1, $s1, 4		# Mudar de posi��o do vetor
		addi $t9, $t9, 1		# I++
		j forSizeBarco
breakForSizeBarco:
lw $a0, 4($sp)		# Receber da stack o valor de $a0 (size do Braco)
lw $a1, 8($sp)		# Receber da stack a letra do barco
addi $t9, $0 0		# I = 0
forAddBarco:
	beq $t9, $a0, sairGerarBarco		# If(I < Size) SAI -> breakForSizeBarco
	addi $s1, $s1, -4			# Baixa as posi��es do vetor de $s1(posi��es das pe�as do barco)
	lw $t1, 0($s1)				# Recebe o valor de $s1(posi��es do tabuleiro) para $t1	
	la $s0, tabuleiro
	add $s0, $s0, $t1			# Anda no tabuleiro para as v�rias posi��es
	sw $a1, 0($s0)				# Guarda o valor de $a1(letra do barco) na posi��o $s0(tabuleiro)
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
#t3 -> endere�o
#t4 -> val do endere�o
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

validarCima:
add $v0, $t6, $0
add $a0, $t1, $0
bge $a0, 10, sairValidarCima	# if($t1 >= 10) salta para o prox teste pois n�o estamos na primeira linha
addi $v0, $0, 1			# Igual $t6 a 1 para saber que n�o vou validar a linha de cima (pois n�o existe)
sairValidarCima:
jr $ra
	
validarBaixo:
add $v0, $t6, $0
add $a0, $t1, $0
blt $a0, 90, sairValidarBaixo	# if($t1 < 90) sai dos testes pois n�o estamos na linha de baixo
addi $v0, $0, 2			# Igual $t6 a 2 para saber que n�o vou validar a linha de baixo (pois n�o existe)
sairValidarBaixo:
jr $ra

validacoesEsquerda:
add $v0, $t7, $0
add $a0, $t1, $0				# Valida��es para saber se vou validar � esquerda (basicamente saber se esta posi��o � a mais � esquerda da linha pois � a unica que n�o precisa validar � esquerda)
	bne $a0, 0, t7Test1_Esq			# if($t1 != 0)	valor � esquerda da 1� linha salta para prox teste
		addi $v0, $0, 1			# else adiciona 1 a $t7 para saber que n�o vou validar � esquerda
		j validacoesEsquerdaSair	# Salta para as validacoes das posi��es � volta
	t7Test1_Esq:
	bne $a0, 40, t7Test2_Esq		# Mesmo da valida��o de cima mas para a 2� linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test2_Esq:
	bne $a0, 80, t7Test3_Esq		# Mesmo da valida��o de cima mas para a 3� linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test3_Esq:
	bne $a0, 120, t7Test4_Esq		# Mesmo da valida��o de cima mas para a 4� linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test4_Esq:
	bne $a0, 160, t7Test5_Esq		# Mesmo da valida��o de cima mas para a 5� linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test5_Esq:
	bne $a0, 200, t7Test6_Esq		# Mesmo da valida��o de cima mas para a 6� linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test6_Esq:
	bne $a0, 240, t7Test7_Esq		# Mesmo da valida��o de cima mas para a 7� linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test7_Esq:
	bne $a0, 280, t7Test8_Esq		# Mesmo da valida��o de cima mas para a 8� linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test8_Esq:
	bne $a0, 320, t7Test9_Esq		# Mesmo da valida��o de cima mas para a 9� linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
	t7Test9_Esq:
	bne $a0, 360, validacoesEsquerdaSair	# Mesmo da valida��o de cima mas para a 10� linha
		addi $v0, $0, 1
		j validacoesEsquerdaSair
validacoesEsquerdaSair:
jr $ra


validacoesDireita:		# Valida��es para saber se vou validar � direita (basicamente saber se esta posi��o � a mais � direita da linha pois � a unica que n�o precisa validar � direita)
add $v0, $t7, $0
add $a0, $t1, $0
	bne $a0, 36, t7Test1_Dir	# if($t1 != 0)	valor � direita da 1� linha salta para prox teste
		addi $v0, $0, 2		# else adiciona 1 a $t7 para saber que n�o vou validar � direita
		j validacoesDireitaSair	# Salta para as validacoes das posi��es � volta
	t7Test1_Dir:
	bne $a0, 76, t7Test2_Dir	# Mesmo da valida��o de cima mas para a 2� linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test2_Dir:
	bne $a0, 116, t7Test3_Dir	# Mesmo da valida��o de cima mas para a 3� linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test3_Dir:
	bne $a0, 156, t7Test4_Dir	# Mesmo da valida��o de cima mas para a 4� linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test4_Dir:
	bne $a0, 196, t7Test5_Dir	# Mesmo da valida��o de cima mas para a 5� linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test5_Dir:
	bne $a0, 236, t7Test6_Dir	# Mesmo da valida��o de cima mas para a 6� linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test6_Dir:
	bne $a0, 276, t7Test7_Dir	# Mesmo da valida��o de cima mas para a 7� linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test7_Dir:
	bne $a0, 316, t7Test8_Dir	# Mesmo da valida��o de cima mas para a 8� linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test8_Dir:
	bne $a0, 356, t7Test9_Dir	# Mesmo da valida��o de cima mas para a 9� linha
		addi $v0, $0, 2
		j validacoesDireitaSair
	t7Test9_Dir:
	bne $a0, 396, validacoesDireitaSair	# Mesmo da valida��o de cima mas para a 10� linha
		addi $v0, $0, 2
		j validacoesDireitaSair
validacoesDireitaSair:
jr $ra