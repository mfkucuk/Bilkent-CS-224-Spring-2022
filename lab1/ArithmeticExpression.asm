	.text
	############################
	# load the values from the memory
	lw $t0, A
	lw $t1, B
	lw $t2, C
	
	sub $t3, $t1, $t2 # subtraction
	mult $t3, $t0 # multiplication
	mflo $t3
	
	# subtract 16 from register 3 until it is smaller than 16
mod:
	subi $t3, $t3, 16
	bge $t3, 16, mod
	
	# store the result in x
	sw $t3, X
	
	# exit the program
	li $v0, 10
	syscall
	
	############################
	.data
A:	.word	15
B:	.word	5
C:	.word	3
X:	.space	4