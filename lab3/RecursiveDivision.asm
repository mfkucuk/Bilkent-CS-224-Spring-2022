	.data
	A:		.space		4
	B:		.space		4
	
	newline:	.asciiz		"\n\n"
	prompt1:	.asciiz		"Enter a number: "	
	prompt2:	.asciiz		"Enter another number: "
	prompt3:	.asciiz		"Do you want to continue? (Yes: 1, No: 0): "
	msg1: 		.asciiz		"Result is "
	error:		.asciiz		"Error: zero division\n"
	
	.text
	
	# ask for input
again:
	la $a0, prompt1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	sw $v0, A
	
	la $a0, prompt2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	sw $v0, B
	
	# call recursiveDivision sub-program to perform integer division
	lw $a0, A
	lw $a1, B
	jal recursiveDivision
	
	# display the result
	move $t0, $v0
	la $a0, msg1
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	# ask if the user wants to continue
	la $a0, prompt3
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	bne $v0, $zero, again
	
	# exit the program
	li $v0, 10
	syscall
	
recursiveDivision:
	beq $a1, $zero, zero
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	bge $a0, $a1, else
	li $v0, 0
	addi $sp, $sp, 4
	jr $ra
else:	sub $a0, $a0, $a1
	jal recursiveDivision
	
	addi $v0, $v0, 1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra 
	
zero:
	la $a0, error
	li $v0, 4
	syscall
	li $v0, 0
	jr $ra
