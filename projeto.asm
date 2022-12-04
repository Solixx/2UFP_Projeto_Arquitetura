.data
MSGColuna: .asciiz "Insira uma coluna \n"
MSGLinha: .asciiz "Insira uma linha \n"

.align 2
tabuleiro: .space 400

.text
.globl main
main:
#t1 -> Numero aleatorio
#s0 -> endereço do vetor tabuleiro

add $t1, $0, $0
la $s0, tabuleiro
#jal gerarNumeroRandom
#add $t1, $v0, $0
jal gerarCarrier

exit:
li $v0, 10
syscall

gerarNumeroRandom:
li $a1, 100	#valor maximo do numero aleatorio
li $v0, 42	#gerar numero aleatorio
syscall
add $a0, $a0, 0 #valor minimo do numero aleatorio
jr $ra

gerarAxRandom:
li $a1, 2	#valor maximo do numero aleatorio
li $v0, 42	#gerar numero aleatorio
syscall
add $a0, $a0, 1 #valor minimo do numero aleatorio
jr $ra

gerarCarrier:
#a0 -> endereço do tabuleiro
#s1 -> linha e coluna (pos do tabuleiro)
#t1 -> i
#t2 -> temp Linha e coluna (pos do tabuleiro)
#t3 -> erro (bool)
#t4 -> size
#t5 -> linha e coluna * 4 (pos do tabuleiro em Bytes)
#t6 -> val do tabuleiro na pos
#t7 -> Axis

add $a0, $s0, $0	#endereço do tabuleiro
add $sp, $sp, -4 
sw $ra, 0($sp)
add $s1, $0, $0
add $t2, $0, $0
add $t3, $0, $0
addi $t4, $0, 5
All_doWhile_Carrier:
	add $t3, $0, $0
	add $t4, $0, 5
	cheakFirstPos_doWhile_Carrier:
		jal gerarNumeroRandom
		add $s1, $v0, $0
		slti $t0, $s1, 100
		bne $t0, $0, cheakFirstPos_doWhile_Carrier	#Se $t2 > 100
		beq $t0, 100, cheakFirstPos_doWhile_Carrier	#Se $t2 == 100
		mul $t5, $s1, 4
		add $a0, $a0, $t5
		lw $t6, 0($a0)
		beq $t6, $0, saida_cheakFirstPos_doWhile_Carrier
		j cheakFirstPos_doWhile_Carrier
	saida_cheakFirstPos_doWhile_Carrier:
	add $t2, $t5, $0
	jal gerarAxRandom
	add $t7, $v0, $0
	bne $t7, $0, vertical_Carrier
	horizontal_Carrier:
	add $t1, $0, $0
	forLoop_Horizontal_Carrier:
		slt $t0, $t1, $t4
		bne $t0, 0, forLoop_Horizontal_Carrier
		slti $t0, $t2, 0
		beq $t0, 0, skip_temp_igual_0
		add $t2, $0, $0
		skip_temp_igual_0:
		bne $t3, $0, erro_zerar_Carrier		# if(erro != 0)
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, $0, horizontal_right_Carriet	# if(tabuleiro[linha][coluna-i] == '0')
		bge $t2, 100, horizontal_right_Carriet	# if(tempColuna >= 100)
		blt $t2, 0, horizontal_right_Carriet	# if(tempColuna < 0)
		li $t6, 'C'
		sw $t6, 0($a0)
		add $t3, $0, $0
		beq $t1, $0, increment_forLoop_Horizontal_Carrier
		addi $t2, $t2, -4
		j increment_forLoop_Horizontal_Carrier
		
		horizontal_right_Carriet:
		add $t2, $t2, $t1
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, $0, erro_Pos_Carrier		# if(tabuleiro[linha][coluna-i] == '0')
		bge $t2, 100, erro_Pos_Carrier		# if(tempColuna >= 100)
		blt $t2, 0, erro_Pos_Carrier		# if(tempColuna < 0)
		li $t6, 'C'
		sw $t6, 0($a0)
		add $t3, $0, $0
		j increment_forLoop_Horizontal_Carrier
		
		erro_Pos_Carrier:
		addi $t3, $0, 1
		add $t4, $0, $t1
		addi $t1, $0, -1
		add $t2, $0, $s1
		
		
		erro_zerar_Carrier:
		la $a0, tabuleiro
		add $a0, $a0, $t2
		lw $t6, 0($a0)
		bne $t6, 'C', horizontal_right_Carriet	# if(tabuleiro[linha][coluna-i] == 'C')
		add $t6, $0, $0
		sw $t6, 0($a0)
		beq $t1, $0, increment_forLoop_Horizontal_Carrier
		addi $t2, $t2, -4
		j checkIigualSize_Horizontal_Carrier
		
		checkIigualSize_Horizontal_Carrier:
		bne $t1, $t4, checkIigualSize_noErrors_Horizontal_Carrier
		
		checkIigualSize_noErrors_Horizontal_Carrier:
		bne $t1, $t4, increment_forLoop_Horizontal_Carrier:
		add $t3, $0, $0
		
		increment_forLoop_Horizontal_Carrier:
		addi $t1, $t1, 1
		j forLoop_Horizontal_Carrier
	vertical_Carrier:
lw $ra, 0($sp)
add $sp, $sp, 4
jr $ra