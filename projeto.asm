.data
MSGColuna: 	.asciiz "Insira uma coluna \n"
MSGLinha: 	.asciiz "Insira uma linha \n"
Enter:		.asciiz "\n"

.align 2
tabuleiro: 	.space 400
valTabuleiro: 	.word

.text
.globl main
main:
#t1 -> Numero aleatorio
#t2 -> size
#s0 -> endereço do vetor tabuleiro

add $t1, $0, $0
la $s0, tabuleiro
jal zerarTabuleiro
#jal gerarNumeroRandom
#add $t1, $v0, $0
addi $s1, $0, 5
jal gerarCarrier
#jal gerarCarrier
jal displayTabuleiro
j exit

exit:
li $v0, 10
syscall

displayTabuleiro:
#a0 -> tabuleiro
#t1 -> i
#t2 -> j
#t3 -> endereço
#t4 -> val do endereço
la $a0, tabuleiro
add $t3, $0, $0
add $t1, $0, $0
add $t3, $a0, $0
displayTabuleiro_1for:
	bge $t1, 10, sair_displayTabuleiro_1for		# i >= 10 sai do ciclo
	add $t2, $0, $0
	displayTabuleiro_2for:
		bge $t2, 10, sair_displayTabuleiro_2for		# j >= 10 sai do ciclo
		add $a0, $t3, $0
		#add $t3, $a0, $0
		li $v0, 4
		lw $t4, 0($t3)
		sw $t4, valTabuleiro
		la $a0, valTabuleiro
		syscall
		add $t3, $t3, 4
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

zerarTabuleiro:
#a0 -> endereço tabuleiro
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

gerarNumeroRandom:
li $a1, 100	#valor maximo do numero aleatorio
li $v0, 42	#gerar numero aleatorio
syscall
add $a0, $a0, 0 #valor minimo do numero aleatorio
add $v0, $a0, $0
jr $ra

gerarAxRandom:
li $a1, 1	#valor maximo do numero aleatorio
li $v0, 42	#gerar numero aleatorio
syscall
add $a0, $a0, 0 #valor minimo do numero aleatorio
add $v0, $a0, $0
jr $ra

gerarCarrier:
#a0 -> endereço do tabuleiro
#a1 -> size
#t4 -> linha e coluna (pos do tabuleiro)
#t1 -> i
#t2 -> temp Linha e coluna * 4 (pos do tabuleiro)
#t3 -> erro (bool)
#t5 -> linha e coluna * 4 (pos do tabuleiro em Bytes)
#t6 -> val do tabuleiro na pos
#t7 -> Axis

add $a0, $s0, $0	#endereço do tabuleiro
add $a1, $s1, $0	#size Carrier
add $sp, $sp, -8 
sw $ra, 0($sp)
sw $a1, 4($sp)
add $t4, $0, $0
add $t2, $0, $0
add $t3, $0, $0
All_doWhile_Carrier:
	add $t3, $0, $0
	add $a1, $0, 5
	cheakFirstPos_doWhile_Carrier:
		jal gerarNumeroRandom
		lw $a1, 4($sp)
		add $t4, $v0, $0
		slti $t0, $t4, 100
		beq $t0, '0', cheakFirstPos_doWhile_Carrier	#Se $t2 > 100
		beq $t4, 100, cheakFirstPos_doWhile_Carrier	#Se $t2 == 100
		mul $t5, $t4, 4
		la $a0, tabuleiro
		add $a0, $a0, $t5
		lw $t6, 0($a0)
		beq $t6, '0', saida_cheakFirstPos_doWhile_Carrier	#48 é o valor de 0 em ascii
		j cheakFirstPos_doWhile_Carrier
	saida_cheakFirstPos_doWhile_Carrier:
	add $t2, $t5, $0
	jal gerarAxRandom
	lw $a1, 4($sp)
	add $t7, $v0, $0
	bne $t7, $0, vertical_Carrier			# 0 -> Horizontal / 1 -> Vertical
	horizontal_Carrier:
	add $t1, $0, $0
	forLoop_Horizontal_Carrier:
		slt $t0, $t1, $a1
		beq $t0, 0, checkSaida_All_doWhile_Carrier
		#slti $t0, $t2, 0
		#beq $t0, 0, skip_temp_igual_0_Carriet
		#add $t2, $0, $0
		bge $t2, $0, test_0_Carriet
		addi $t2, $0, 0
		j skip_temp_igual_Carriet
		
		test_0_Carriet:
		bge $t4, 0, test_0_temp_Carriet
		j test_10_Carriet
		test_0_temp_Carriet:
		bge $t4, 10, test_10_temp_Carriet
		bge $t2, 0,  skip_temp_igual_Carriet
		add $t2, $0, $0
		j test_10_Carriet
		
		test_10_Carriet:
		bge $t4, 10, test_10_temp_Carriet
		j test_20_Carriet
		test_10_temp_Carriet:
		bge $t4, 20, test_20_temp_Carriet
		bge $t2, 40, skip_temp_igual_Carriet	#Comparar com 40 pois são os bytes de cada linha de 10 digitos
		addi $t2, $0, 40
		j test_20_Carriet
		
		test_20_Carriet:
		bge $t4, 20, test_20_temp_Carriet
		j test_30_Carriet
		test_20_temp_Carriet:
		bge $t4, 30, test_30_temp_Carriet
		bge $t2, 80,  skip_temp_igual_Carriet		#Comparar com 80 pois são os bytes de cada linha de 10 digitos
		addi $t2, $0, 80
		j test_30_Carriet
		
		test_30_Carriet:
		bge $t4, 310, test_30_temp_Carriet
		j test_40_Carriet
		test_30_temp_Carriet:
		bge $t4, 40, test_40_temp_Carriet
		bge $t2, 120,  skip_temp_igual_Carriet	#Comparar com 120 pois são os bytes de cada linha de 10 digitos
		addi $t2, $0, 120
		j test_40_Carriet
		
		test_40_Carriet:
		bge $t4, 40, test_40_temp_Carriet
		j test_50_Carriet
		test_40_temp_Carriet:
		bge $t4, 50, test_50_temp_Carriet
		bge $t2, 160, skip_temp_igual_Carriet	#Comparar com 160 pois são os bytes de cada linha de 10 digitos
		addi $t2, $0, 160
		j test_50_Carriet
		
		test_50_Carriet:
		bge $t4, 50, test_50_temp_Carriet
		j test_60_Carriet
		test_50_temp_Carriet:
		bge $t4, 60, test_60_temp_Carriet
		bge $t2, 200, skip_temp_igual_Carriet		#Comparar com 200 pois são os bytes de cada linha de 10 digitos
		addi $t2, $0, 200
		j test_60_Carriet
		
		test_60_Carriet:
		bge $t4, 60, test_60_temp_Carriet
		j test_70_Carriet
		test_60_temp_Carriet:
		bge $t4, 70, test_70_temp_Carriet
		bge $t2, 240,  skip_temp_igual_Carriet		#Comparar com 240 pois são os bytes de cada linha de 10 digitos
		addi $t2, $0, 240
		j test_70_Carriet
		
		test_70_Carriet:
		bge $t4, 70, test_70_temp_Carriet
		j test_80_Carriet
		test_70_temp_Carriet:
		bge $t4, 80, test_80_temp_Carriet
		bge $t2, 280,  skip_temp_igual_Carriet		#Comparar com 280 pois são os bytes de cada linha de 10 digitos
		addi $t2, $0, 280
		j test_80_Carriet
		
		test_80_Carriet:
		bge $t4, 80, test_80_temp_Carriet
		j test_90_Carriet
		test_80_temp_Carriet:
		bge $t4, 90, test_90_temp_Carriet
		bge $t2, 320,  skip_temp_igual_Carriet	#Comparar com 320 pois são os bytes de cada linha de 10 digitos
		addi $t2, $0, 320
		j test_90_Carriet
		
		test_90_Carriet:
		bge $t4, 90, test_90_temp_Carriet
		j skip_temp_igual_Carriet
		test_90_temp_Carriet:
		bge $t2, 360,  skip_temp_igual_Carriet	#Comparar com 360 pois são os bytes de cada linha de 10 digitos
		addi $t2, $0, 360
		j skip_temp_igual_Carriet

		skip_temp_igual_Carriet:
		bne $t3, $0, erro_zerar_Carrier		# if(erro != 0)
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, '0', horizontal_right_Carriet	# if(tabuleiro[linha][coluna-i] != '0')
		bge $t2, 400, horizontal_right_Carriet	# if(tempColuna >= 400)
		blt $t2, 0, horizontal_right_Carriet	# if(tempColuna < 0)
		li $t6, 'C'
		sw $t6, 0($a0)
		add $t3, $0, $0
		#beq $t1, $0, increment_forLoop_Horizontal_Carrier
		addi $t2, $t2, -4
		j increment_forLoop_Horizontal_Carrier
		
		horizontal_right_Carriet:
		mul $t1, $t1, 4
		add $t2, $t2, $t1
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Carrier		# if(tabuleiro[linha][coluna-i] != '0')
		bge $t2, 400, erro_Pos_Carrier		# if(tempColuna >= 400)
		blt $t2, 0, erro_Pos_Carrier		# if(tempColuna < 0)
		li $t6, 'C'
		sw $t6, 0($a0)
		add $t3, $0, $0
		sub $t2, $t2, $t1
		div $t1, $t1, 4
		j increment_forLoop_Horizontal_Carrier
		
		erro_Pos_Carrier:
		addi $t3, $0, 1
		add $a1, $0, $t1
		addi $t1, $0, -1
		add $t2, $0, $t5
		j increment_forLoop_Horizontal_Carrier
		
		
		erro_zerar_Carrier:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, 'C', erro_zerar_rightCheck_Carrier	# if(tabuleiro[linha][coluna-i] != 'C')
		add $t6, $0, $0
		sw $t6, 0($a0)
		#beq $t1, $0, increment_forLoop_Horizontal_Carrier
		addi $t2, $t2, -4
		j checkIigualSize_Horizontal_Carrier
		erro_zerar_rightCheck_Carrier:
		add $t2, $t2, 4
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, 'C', increment_forLoop_Horizontal_Carrier	# if(tabuleiro[linha][coluna-i] != 'C')
		bge $t2, 400, increment_forLoop_Horizontal_Carrier	# if(tempColuna >= 400)
		blt $t2, 0, increment_forLoop_Horizontal_Carrier	# if(tempColuna < 0)
		add $t6, $0, $0
		sw $t6, 0($a0)
		j checkIigualSize_Horizontal_Carrier
		
		checkIigualSize_Horizontal_Carrier:
		bne $t1, $a1, checkIigualSize_noErrors_Horizontal_Carrier
		j checkSaida_All_doWhile_Carrier
		
		checkIigualSize_noErrors_Horizontal_Carrier:
		bne $t1, $a1, increment_forLoop_Horizontal_Carrier
		add $t3, $0, $0
		j checkSaida_All_doWhile_Carrier
		
		increment_forLoop_Horizontal_Carrier:
		addi $t1, $t1, 1
		j forLoop_Horizontal_Carrier
	vertical_Carrier:
checkSaida_All_doWhile_Carrier:
bne $t3, $0, All_doWhile_Carrier

lw $ra, 0($sp)
add $sp, $sp, 4
jr $ra
