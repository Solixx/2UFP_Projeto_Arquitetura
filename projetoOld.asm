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
#s0 -> endere�o do vetor tabuleiro

add $t1, $0, $0
la $s0, tabuleiro
jal zerarTabuleiro
#jal gerarNumeroRandom
#add $t1, $v0, $0
addi $s1, $0, 5
jal gerarCarrier
jal gerarCarrier
#jal displayTabuleiro
addi $s1, $0, 5
#jal gerarCarrier
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
#t3 -> endere�o
#t4 -> val do endere�o
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
#a0 -> endere�o tabuleiro
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
li $a1, 2	#valor maximo do numero aleatorio
li $v0, 42	#gerar numero aleatorio
syscall
add $a0, $a0, 0 #valor minimo do numero aleatorio
add $v0, $a0, $0
jr $ra

gerarCarrier:
#a0 -> endere�o do tabuleiro
#a1 -> size
#t4 -> linha e coluna (pos do tabuleiro)
#t1 -> i
#t2 -> temp Linha e coluna * 4 (pos do tabuleiro)
#t3 -> erro (bool)
#t5 -> linha e coluna * 4 (pos do tabuleiro em Bytes)
#t6 -> val do tabuleiro na pos
#t7 -> Axis

add $a0, $s0, $0	#endere�o do tabuleiro
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
		bne $t6, '0', cheakFirstPos_doWhile_Carrier		#Validar tabuleiro[linha][coluna] != '0'
		mul $t5, $t4, 4
		add $t5, $t5, 40
		bge $t5, 100, skip_val_1
		la $a0, tabuleiro
		add $a0, $a0, $t5
		lw $t6, 0($a0)
		bne $t6, '0', cheakFirstPos_doWhile_Carrier		#Validar tabuleiro[linha+1][coluna] != '0'
		skip_val_1:
		mul $t5, $t4, 4
		add $t5, $t5, -40
		blt $t5, 0, skip_zerar_t5_1
		la $a0, tabuleiro
		add $a0, $a0, $t5
		lw $t6, 0($a0)
		bne $t6, '0', cheakFirstPos_doWhile_Carrier		#Validar tabuleiro[linha-1][coluna] != '0'
		skip_zerar_t5_1:
		mul $t5, $t4, 4
		add $t5, $t5, 4
		bge $t5, 100, skip_val_2
		la $a0, tabuleiro
		add $a0, $a0, $t5
		lw $t6, 0($a0)
		bne $t6, '0', cheakFirstPos_doWhile_Carrier		#Validar tabuleiro[linha][coluna+1] != '0'
		skip_val_2:
		mul $t5, $t4, 4
		add $t5, $t5, 44
		bge $t5, 100, skip_val_3
		la $a0, tabuleiro
		add $a0, $a0, $t5
		lw $t6, 0($a0)
		bne $t6, '0', cheakFirstPos_doWhile_Carrier		#Validar tabuleiro[linha+1][coluna+1] != '0'
		skip_val_3:
		mul $t5, $t4, 4
		add $t5, $t5, -36
		blt $t5, 0, skip_zerar_t5_2
		add $t5, $0, $0
		skip_zerar_t5_2:
		la $a0, tabuleiro
		add $a0, $a0, $t5
		lw $t6, 0($a0)
		bne $t6, '0', cheakFirstPos_doWhile_Carrier		#Validar tabuleiro[linha-1][coluna+1] != '0'
		mul $t5, $t4, 4
		add $t5, $t5, -4
		blt $t5, 0, skip_zerar_t5_3
		add $t5, $0, $0
		skip_zerar_t5_3:
		la $a0, tabuleiro
		add $a0, $a0, $t5
		lw $t6, 0($a0)
		bne $t6, '0', cheakFirstPos_doWhile_Carrier		#Validar tabuleiro[linha][coluna-1] != '0'
		mul $t5, $t4, 4
		add $t5, $t5, 36
		bge $t5, 100, skip_val_4
		la $a0, tabuleiro
		add $a0, $a0, $t5
		lw $t6, 0($a0)
		bne $t6, '0', cheakFirstPos_doWhile_Carrier		#Validar tabuleiro[linha+1][coluna-1] != '0'
		skip_val_4:
		mul $t5, $t4, 4
		add $t5, $t5, -44
		blt $t5, 0, skip_zerar_t5_4
		add $t5, $0, $0
		skip_zerar_t5_4:
		la $a0, tabuleiro
		add $a0, $a0, $t5
		lw $t6, 0($a0)
		mul $t5, $t4, 4
		beq $t6, '0', saida_cheakFirstPos_doWhile_Carrier	#Validar tabuleiro[linha-1][coluna-1] == '0'
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
		bge $t2, $0, test_0_Horizontal_Carriet
		addi $t2, $0, 0
		j skip_temp_igual_Horizontal_Carriet
		
		test_0_Horizontal_Carriet:
		bge $t4, 0, test_0_temp_Horizontal_Carriet
		j test_10_Horizontal_Carriet
		test_0_temp_Horizontal_Carriet:
		bge $t4, 10, test_10_temp_Horizontal_Carriet
		bge $t2, 0,  skip_temp_igual_Horizontal_Carriet
		add $t2, $0, $0
		j test_10_Horizontal_Carriet
		
		test_10_Horizontal_Carriet:
		bge $t4, 10, test_10_temp_Horizontal_Carriet
		j test_20_Horizontal_Carriet
		test_10_temp_Horizontal_Carriet:
		bge $t4, 20, test_20_temp_Horizontal_Carriet
		bge $t2, 40, skip_temp_igual_Horizontal_Carriet	#Comparar com 40 pois s�o os bytes de cada linha de 10 digitos
		addi $t2, $0, 40
		j test_20_Horizontal_Carriet
		
		test_20_Horizontal_Carriet:
		bge $t4, 20, test_20_temp_Horizontal_Carriet
		j test_30_Horizontal_Carriet
		test_20_temp_Horizontal_Carriet:
		bge $t4, 30, test_30_temp_Horizontal_Carriet
		bge $t2, 80,  skip_temp_igual_Horizontal_Carriet		#Comparar com 80 pois s�o os bytes de cada linha de 10 digitos
		addi $t2, $0, 80
		j test_30_Horizontal_Carriet
		
		test_30_Horizontal_Carriet:
		bge $t4, 310, test_30_temp_Horizontal_Carriet
		j test_40_Horizontal_Carriet
		test_30_temp_Horizontal_Carriet:
		bge $t4, 40, test_40_temp_Horizontal_Carriet
		bge $t2, 120,  skip_temp_igual_Horizontal_Carriet	#Comparar com 120 pois s�o os bytes de cada linha de 10 digitos
		addi $t2, $0, 120
		j test_40_Horizontal_Carriet
		
		test_40_Horizontal_Carriet:
		bge $t4, 40, test_40_temp_Horizontal_Carriet
		j test_50_Horizontal_Carriet
		test_40_temp_Horizontal_Carriet:
		bge $t4, 50, test_50_temp_Horizontal_Carriet
		bge $t2, 160, skip_temp_igual_Horizontal_Carriet	#Comparar com 160 pois s�o os bytes de cada linha de 10 digitos
		addi $t2, $0, 160
		j test_50_Horizontal_Carriet
		
		test_50_Horizontal_Carriet:
		bge $t4, 50, test_50_temp_Horizontal_Carriet
		j test_60_Horizontal_Carriet
		test_50_temp_Horizontal_Carriet:
		bge $t4, 60, test_60_temp_Horizontal_Carriet
		bge $t2, 200, skip_temp_igual_Horizontal_Carriet		#Comparar com 200 pois s�o os bytes de cada linha de 10 digitos
		addi $t2, $0, 200
		j test_60_Horizontal_Carriet
		
		test_60_Horizontal_Carriet:
		bge $t4, 60, test_60_temp_Horizontal_Carriet
		j test_70_Horizontal_Carriet
		test_60_temp_Horizontal_Carriet:
		bge $t4, 70, test_70_temp_Horizontal_Carriet
		bge $t2, 240,  skip_temp_igual_Horizontal_Carriet		#Comparar com 240 pois s�o os bytes de cada linha de 10 digitos
		addi $t2, $0, 240
		j test_70_Horizontal_Carriet
		
		test_70_Horizontal_Carriet:
		bge $t4, 70, test_70_temp_Horizontal_Carriet
		j test_80_Horizontal_Carriet
		test_70_temp_Horizontal_Carriet:
		bge $t4, 80, test_80_temp_Horizontal_Carriet
		bge $t2, 280,  skip_temp_igual_Horizontal_Carriet		#Comparar com 280 pois s�o os bytes de cada linha de 10 digitos
		addi $t2, $0, 280
		j test_80_Horizontal_Carriet
		
		test_80_Horizontal_Carriet:
		bge $t4, 80, test_80_temp_Horizontal_Carriet
		j test_90_Horizontal_Carriet
		test_80_temp_Horizontal_Carriet:
		bge $t4, 90, test_90_temp_Horizontal_Carriet
		bge $t2, 320,  skip_temp_igual_Horizontal_Carriet	#Comparar com 320 pois s�o os bytes de cada linha de 10 digitos
		addi $t2, $0, 320
		j test_90_Horizontal_Carriet
		
		test_90_Horizontal_Carriet:
		bge $t4, 90, test_90_temp_Horizontal_Carriet
		j skip_temp_igual_Horizontal_Carriet
		test_90_temp_Horizontal_Carriet:
		bge $t2, 360,  skip_temp_igual_Horizontal_Carriet	#Comparar com 360 pois s�o os bytes de cada linha de 10 digitos
		addi $t2, $0, 360
		j skip_temp_igual_Horizontal_Carriet

		skip_temp_igual_Horizontal_Carriet:
		bne $t3, $0, erro_zerar_Horizontal_Carrier		# if(erro != 0)
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, '0', horizontal_right_Carriet	# if(tabuleiro[linha][coluna-i] != '0')
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, -4
		blt $a0, 0, skip_val_a0_horLeft_1
		lw $t6, 0($a0)
		bne $t6, '0', horizontal_right_Carriet	# tabuleiro[linha][tempColuna-1] != '0'
		skip_val_a0_horLeft_1:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, 40
		bge $a0, 100, skip_val_a0_horLeft_2
		lw $t6, 0($a0)
		bne $t6, '0', horizontal_right_Carriet	# tabuleiro[linha+1][tempColuna] != '0'
		skip_val_a0_horLeft_2:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, -44
		blt $a0, 0, skip_val_a0_horLeft_3
		lw $t6, 0($a0)
		bne $t6, '0', horizontal_right_Carriet	# tabuleiro[linha-1][tempColuna-1] != '0'
		skip_val_a0_horLeft_3:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, 36
		bge $a0, 100, skip_val_a0_horLeft_4
		lw $t6, 0($a0)
		bne $t6, '0', horizontal_right_Carriet	# tabuleiro[linha+1][tempColuna-1] != '0'
		skip_val_a0_horLeft_4:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, -40
		blt $a0, 0, skip_val_a0_horLeft_5
		lw $t6, 0($a0)
		bne $t6, '0', horizontal_right_Carriet	# tabuleiro[linha-1][tempColuna] != '0'
		skip_val_a0_horLeft_5:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, 44
		bge $a0, 100, skip_val_a0_horLeft_6
		lw $t6, 0($a0)
		bne $t6, '0', horizontal_right_Carriet	# tabuleiro[linha+1][tempColuna+1] != '0'
		skip_val_a0_horLeft_6:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, -36
		blt $a0, 0, skip_val_a0_horLeft_7
		lw $t6, 0($a0)
		bne $t6, '0', horizontal_right_Carriet	# tabuleiro[linha-1][tempColuna+1] != '0'
		skip_val_a0_horLeft_7:
		la $a0, tabuleiro
		add $a0, $a0, $t2
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
		bne $t6, '0', erro_Pos_Horizontal_Carrier		# if(tabuleiro[linha][tempColuna+i] != '0')
		
		
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, 4
		bge $a0, 100, skip_val_a0_horRight_1
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Horizontal_Carrier	# tabuleiro[linha][(tempColuna+i)+1] != '0'
		skip_val_a0_horRight_1:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, 40
		bge $a0, 100, skip_val_a0_horRight_2
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Horizontal_Carrier	# tabuleiro[linha+1][tempColuna] != '0'
		skip_val_a0_horRight_2:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, -44
		blt $a0, 0, skip_val_a0_horRight_3
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Horizontal_Carrier	# tabuleiro[linha-1][tempColuna-1] != '0'
		skip_val_a0_horRight_3:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, 36
		bge $a0, 100, skip_val_a0_horRight_4
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Horizontal_Carrier	# tabuleiro[linha+1][tempColuna-1] != '0'
		skip_val_a0_horRight_4:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, -40
		blt $a0, 0, skip_val_a0_horRight_5
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Horizontal_Carrier	# tabuleiro[linha-1][tempColuna] != '0'
		skip_val_a0_horRight_5:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, 44
		bge $a0, 100, skip_val_a0_horRight_6
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Horizontal_Carrier	# tabuleiro[linha+1][tempColuna+1] != '0'
		skip_val_a0_horRight_6:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		add $a0, $a0, -36
		blt $a0, 0, skip_val_a0_horRight_7
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Horizontal_Carrier	# tabuleiro[linha-1][tempColuna+1] != '0'
		skip_val_a0_horRight_7:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		
		
		
		bge $t2, 400, erro_Pos_Horizontal_Carrier		# if(tempColuna >= 400)
		blt $t2, 0, erro_Pos_Horizontal_Carrier			# if(tempColuna < 0)
		li $t6, 'C'
		sw $t6, 0($a0)
		add $t3, $0, $0
		sub $t2, $t2, $t1
		div $t1, $t1, 4
		j increment_forLoop_Horizontal_Carrier
		
		erro_Pos_Horizontal_Carrier:
		addi $t3, $0, 1
		add $a1, $0, $t1
		addi $t1, $0, -1
		add $t2, $0, $t5
		j increment_forLoop_Horizontal_Carrier
		
		
		erro_zerar_Horizontal_Carrier:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, 'C', erro_zerar_rightCheck_Horizontal_Carrier	# if(tabuleiro[linha][coluna-i] != 'C')
		li $t6, '0'
		sw $t6, 0($a0)
		#beq $t1, $0, increment_forLoop_Horizontal_Carrier
		addi $t2, $t2, -4
		j checkIigualSize_Horizontal_Carrier
		erro_zerar_rightCheck_Horizontal_Carrier:
		add $t2, $t2, 4
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, 'C', increment_forLoop_Horizontal_Carrier	# if(tabuleiro[linha][coluna-i] != 'C')
		bge $t2, 400, increment_forLoop_Horizontal_Carrier	# if(tempColuna >= 400)
		blt $t2, 0, increment_forLoop_Horizontal_Carrier	# if(tempColuna < 0)
		li $t6, '0'
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
	add $t1, $0, $0
	forLoop_Vertical_Carrier:
		slt $t0, $t1, $a1
		beq $t0, 0, checkSaida_All_doWhile_Carrier
		#slti $t0, $t2, 0
		#beq $t0, 0, skip_temp_igual_0_Carriet
		#add $t2, $0, $0
		
		test_0_Vertical_Carriet:
		bge $t2, 0, test_0_temp_Vertical_Carriet
		blt $t2, 0, transformInPositive_vertical_Carriet
		j skip_addt2_vertical_Carriet
		test_0_temp_Vertical_Carriet:
		bge $t2, 0, skip_addt2_vertical_Carriet
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		beq $t6, '0', skip_addt2_vertical_Carriet
		addi $t2, $t2, 40
		j skip_addt2_vertical_Carriet
		
		transformInPositive_vertical_Carriet:
		addi $t4, $0, -40
		sub $t2, $t2, $t4
		j test_0_Vertical_Carriet
		
		skip_addt2_vertical_Carriet:
		
		bne $t3, $0, erro_zerar_Vertical_Carrier		# if(erro != 0)
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, '0', vertical_right_Carriet	# if(tabuleiro[linha][coluna-i] != '0')
		
		
		la $a0, tabuleiro
		addi $t2, $t2, 4
		add $a0, $a0, $t2
		sub $t2, $t2, -4
		#add $a0, $a0, 4
		#bge $a0, 400, skip_val_a0_verUp_1
		bge $t2, 400, skip_val_a0_verUp_1
		lw $t6, 0($a0)
		bne $t6, '0', vertical_right_Carriet	# tabuleiro[linha][(tempColuna+i)+1] != '0'
		skip_val_a0_verUp_1:
		la $a0, tabuleiro
		addi $t2, $t2, -4
		add $a0, $a0, $t2
		addi $t2, $t2, 4
		#addi $a0, $a0, -4
		#blt $a0, 0, skip_val_a0_verUp_2
		blt $t2, 0, skip_val_a0_verUp_2
		lw $t6, 0($a0)
		bne $t6, '0', vertical_right_Carriet	# tabuleiro[linha+1][tempColuna] != '0'
		skip_val_a0_verUp_2:
		la $a0, tabuleiro
		addi $t2, $t2, -44
		add $a0, $a0, $t2
		addi $t2, $t2, 44
		#add $a0, $a0, -44
		#blt $a0, 0, skip_val_a0_verUp_3
		blt $t2, 0, skip_val_a0_verUp_3
		lw $t6, 0($a0)
		bne $t6, '0', vertical_right_Carriet	# tabuleiro[linha-1][tempColuna-1] != '0'
		skip_val_a0_verUp_3:
		la $a0, tabuleiro
		addi $t2, $t2, 36
		add $a0, $a0, $t2
		addi $t2, $t2, -36
		#add $a0, $a0, 36
		#bge $a0, 400, skip_val_a0_verUp_4
		bge $t2, 400, skip_val_a0_verUp_4
		lw $t6, 0($a0)
		bne $t6, '0', vertical_right_Carriet	# tabuleiro[linha+1][tempColuna-1] != '0'
		skip_val_a0_verUp_4:
		la $a0, tabuleiro
		addi $t2, $t2, -40
		add $a0, $a0, $t2
		addi $t2, $t2, 40
		#add $a0, $a0, -40
		#blt $a0, 0, skip_val_a0_verUp_5
		blt $t2, 0, skip_val_a0_verUp_5
		lw $t6, 0($a0)
		bne $t6, '0', vertical_right_Carriet	# tabuleiro[linha-1][tempColuna] != '0'
		skip_val_a0_verUp_5:
		la $a0, tabuleiro
		addi $t2, $t2, 44
		add $a0, $a0, $t2
		addi $t2, $t2, -44
		#add $a0, $a0, 44
		#bge $a0, 400, skip_val_a0_verUp_6
		bge $t2, 400, skip_val_a0_verUp_6
		lw $t6, 0($a0)
		bne $t6, '0', vertical_right_Carriet	# tabuleiro[linha+1][tempColuna+1] != '0'
		skip_val_a0_verUp_6:
		la $a0, tabuleiro
		addu $t2, $t2, -36
		add $a0, $a0, $t2
		addi $t2, $t2, 36
		#add $a0, $a0, -36
		#blt $a0, 0, skip_val_a0_verUp_7
		blt $t2, 0, skip_val_a0_verUp_7
		lw $t6, 0($a0)
		bne $t6, '0', vertical_right_Carriet	# tabuleiro[linha-1][tempColuna+1] != '0'
		skip_val_a0_verUp_7:
		
		bge $t2, 400, vertical_right_Carriet	# if(tempColuna >= 400)
		blt $t2, 0, vertical_right_Carriet	# if(tempColuna < 0)
		li $t6, 'C'
		sw $t6, 0($a0)
		add $t3, $0, $0
		#beq $t1, $0, increment_forLoop_Vertical_Carrier
		addi $t2, $t2, -40
		j increment_forLoop_Vertical_Carrier
		
		vertical_right_Carriet:
		mul $t1, $t1, 40
		add $t2, $t2, $t1
		div $t1, $t1, 40
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Vertical_Carrier		# if(tabuleiro[linha][coluna-i] != '0')
		
		la $a0, tabuleiro
		addi $t2, $t2, 4
		add $a0, $a0, $t2
		addi $t2, $t2, -4
		#add $a0, $a0, 4
		#bge $a0, 400, skip_val_a0_verDown_1
		bge $t2, 400, skip_val_a0_verDown_1
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Vertical_Carrier	# tabuleiro[linha][(tempColuna+i)+1] != '0'
		skip_val_a0_verDown_1:
		la $a0, tabuleiro
		addi $t2, $t2, -4
		add $a0, $a0, $t2
		addi $t2, $t2, 4
		#addi $a0, $a0, -4
		#blt $a0, 0, skip_val_a0_verDown_2
		blt $t2, 0, skip_val_a0_verDown_2
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Vertical_Carrier	# tabuleiro[linha+1][tempColuna] != '0'
		skip_val_a0_verDown_2:
		la $a0, tabuleiro
		addi $t2, $t2, -44
		add $a0, $a0, $t2
		addi $t2, $t2, 44
		#add $a0, $a0, -44
		#blt $a0, 0, skip_val_a0_verDown_3
		blt $t2, 0, skip_val_a0_verDown_3
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Vertical_Carrier	# tabuleiro[linha-1][tempColuna-1] != '0'
		skip_val_a0_verDown_3:
		la $a0, tabuleiro
		addi $t2, $t2, 36
		add $a0, $a0, $t2
		addi $t2, $t2, -36
		#add $a0, $a0, 36
		#bge $a0, 400, skip_val_a0_verDown_4
		bge $t2, 400, skip_val_a0_verDown_4
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Vertical_Carrier	# tabuleiro[linha+1][tempColuna-1] != '0'
		skip_val_a0_verDown_4:
		la $a0, tabuleiro
		addi $t2, $t2, 40
		add $a0, $a0, $t2
		addi $t2, $t2, -40
		#addi $a0, $a0, 40
		#bge $a0, 400, skip_val_a0_verDown_5
		bge $t2, 400, skip_val_a0_verDown_5
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Vertical_Carrier	# tabuleiro[linha-1][tempColuna] != '0'
		skip_val_a0_verDown_5:
		la $a0, tabuleiro
		addi $t2, $t2, 44
		add $a0, $a0, $t2
		addi $t2, $t2, -44
		#add $a0, $a0, 44
		#bge $a0, 400, skip_val_a0_verDown_6
		bge $t2, 400, skip_val_a0_verDown_6
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Vertical_Carrier	# tabuleiro[linha+1][tempColuna+1] != '0'
		skip_val_a0_verDown_6:
		la $a0, tabuleiro
		addi $t2, $t2, -36
		add $a0, $a0, $t2
		addi $t2, $t2, 36
		#add $a0, $a0, -36
		#blt $a0, 0, skip_val_a0_verDown_7
		blt $t2, 0, skip_val_a0_verDown_7
		lw $t6, 0($a0)
		bne $t6, '0', erro_Pos_Vertical_Carrier	# tabuleiro[linha-1][tempColuna+1] != '0'
		skip_val_a0_verDown_7:
		mul $t1, $t1, 40
		
		bge $t2, 400, erro_Pos_Vertical_Carrier		# if(tempColuna >= 400)
		blt $t2, 0, erro_Pos_Vertical_Carrier		# if(tempColuna < 0)
		li $t6, 'C'
		sw $t6, 0($a0)
		add $t3, $0, $0
		sub $t2, $t2, $t1
		div $t1, $t1, 40
		j increment_forLoop_Vertical_Carrier
		
		erro_Pos_Vertical_Carrier:
		addi $t3, $0, 1
		add $a1, $0, $t1
		addi $t1, $0, -1
		add $t2, $0, $t5
		j increment_forLoop_Vertical_Carrier
		
		
		erro_zerar_Vertical_Carrier:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, 'C', erro_zerar_rightCheck_Vertical_Carrier	# if(tabuleiro[linha][coluna-i] != 'C')
		li $t6, '0'
		sw $t6, 0($a0)
		#beq $t1, $0, increment_forLoop_Vertical_Carrier
		addi $t2, $t2, -40
		j checkIigualSize_Vertical_Carrier
		erro_zerar_rightCheck_Vertical_Carrier:
		add $t2, $t2, 40
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, 'C', increment_forLoop_Vertical_Carrier	# if(tabuleiro[linha][coluna-i] != 'C')
		bge $t2, 400, increment_forLoop_Vertical_Carrier	# if(tempColuna >= 400)
		blt $t2, 0, increment_forLoop_Vertical_Carrier	# if(tempColuna < 0)
		li $t6, '0'
		sw $t6, 0($a0)
		j checkIigualSize_Vertical_Carrier
		
		checkIigualSize_Vertical_Carrier:
		bne $t1, $a1, checkIigualSize_noErrors_Vertical_Carrier
		j checkSaida_All_doWhile_Carrier
		
		checkIigualSize_noErrors_Vertical_Carrier:
		bne $t1, $a1, increment_forLoop_Vertical_Carrier
		add $t3, $0, $0
		j checkSaida_All_doWhile_Carrier
		
		increment_forLoop_Vertical_Carrier:
		addi $t1, $t1, 1
		j forLoop_Vertical_Carrier
checkSaida_All_doWhile_Carrier:
bne $t3, $0, All_doWhile_Carrier

lw $ra, 0($sp)
add $sp, $sp, 4
jr $ra
