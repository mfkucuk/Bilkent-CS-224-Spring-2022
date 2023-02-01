	.text
	
	# load the array
	la $t0, array
	
	# ask the user the number of elements
	la $a0, msg1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# store the size
	sw $v0, size
	
	# ask the user to enter elements for the array
	la $a0, msg2
	li $v0, 4
	syscall
	lw $a0, size
	li $v0, 1
	syscall
	la $a0, msg3
	li $v0, 4
	syscall
	lw $t1, size	# $t1 = size
	
input:
	li $v0, 5
	syscall
	sw $v0, 0($t0)
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, input
	
	# display the array
	la $t0, array
	lw $t1, size
	
	la $a0, msg4
	li $v0, 4
	syscall
	
display:
	lw $t2, 0($t0)
	add $a0, $zero, $t2
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, display
	la $a0, newline
	li $v0, 4
	syscall
	
	# check if both halfs are identical
	la $t0, array
	lw $t1, size
	li $t2, 2	# $t2 = 2
	div $t1, $t2
	mflo $t1
	mfhi $t2
	add $t3, $zero, $t1
	beq $t2, $zero, even
	
	# if the array size is odd add 1 to jump value
	addi $t3, $t3, 1
	
even:
	li $t6, 4
	mult $t3, $t6
	mflo $t3
again: 
	lw $t4, 0($t0)
	add $t0, $t0, $t3
	lw $t5, 0($t0)
	sub $t0, $t0, $t3
	bne $t4, $t5, fail
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, again
	
	# success
	la $a0, msg5
	li $v0, 4
	syscall
	j stop
	
	# fail
fail:
	la $a0, msg6
	li $v0, 4
	syscall
	
	# stop the program
stop:
	li $v0, 10
	syscall
	
	#############################
	.data
array:	.space	80
size:	.space	4
space:	.asciiz " "
newline: .asciiz "\n"
msg1:	.asciiz "Enter the number of elements: "
msg2:	.asciiz	"Enter "
msg3:	.asciiz	" numbers: \n"
msg4:	.asciiz "Array: "
msg5:	.asciiz	"Both halves are equal"
msg6:	.asciiz "Both halves are not equal"
	
