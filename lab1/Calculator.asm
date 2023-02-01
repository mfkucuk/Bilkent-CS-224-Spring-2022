#
#     Arithmetic Expression: Calculates (a^2 + 3ab) / ((a+b)*modb)
#
	
	.text
	
	# take input
	la $a0, prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	sw $v0, A
	
	la $a0, prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	sw $v0, B
	
	# (a^2 + 3ab) / ((a+b)*modb)
	lw $t0, A
	lw $t1, B
	li $t2, 3
	
	# numerator
	mult $t0, $t0
	mflo $t3
	
	mult $t0, $t1
	mflo $t4
	
	mult $t2, $t4
	mflo $t4
	
	add $t3, $t3, $t4
	
	# denominator
	add $t5, $t0, $t1
	
	div $t5, $t1
	mfhi $t6
	
	# result
	div $t3, $t6
	mflo $t7
	
	# print
	move $a0, $t7
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
	.data
A:	.space	4
B:	.space	4
prompt:	.asciiz "Enter a number: "

######## End of Arithmetic Expression ############