	.data
	
	prompt1:	.asciiz		"Enter the number of elements: "
	prompt2:	.asciiz		"Enter "
	prompt3:	.asciiz		" numbers: \n"
	newline:	.asciiz		"\n"
	tab:		.asciiz		"	"
	
	
	
	
	.text
	
	# ask the user to create an array
	jal createArray
	
	# call bubble sort
	move $a0, $v0
	move $a1, $v1
	
	beq $v1, $zero, end
	
	jal bubbleSort
	
	# end program
end:
	li $v0, 10
	syscall
	
	
	
	
createArray:

	# ask for array size
	la $a0, prompt1
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	
	beq $v0, $zero, zero
	
	# store array size in stack
	move $t1, $v0
	
	# allocate space for an array with the specified size.
	mul $v0, $v0, 4
	move $a0, $v0
	li $v0, 9
	syscall
	
	move $t0, $v0
	
	# make the user initalize the array	
	move $t2, $t0
	move $t3, $t1
	
	la $a0, prompt2
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	la $a0, prompt3
	li $v0, 4
	syscall
	
input:
	li $v0, 5
	syscall
	sw $v0, 0($t2)
	addi $t2, $t2, 4
	addi $t3, $t3, -1
	bne $t3, $zero, input
	
	move $v0, $t0
zero:
	move $v1, $t1
	jr $ra	
	
bubbleSort:
	addi $sp, $sp, -12
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	
	# sort the array using bubble sort
	move $t0, $a0	# array
	move $t1, $a1	# array size
	beq $t1, 1, sorted
	li $t3, 0	# temp
	addi $t7, $t1, -1
	move $t6, $t7
	mul $t7, $t7, 4
	
loop1:
	li $t2, 0
	
	loop2:
		lw $t4, 0($t0)
		addi $t0, $t0, 4
		lw $t5, 0($t0)
		blt $t4, $t5, skip
		lw $t3, 0($t0)
		sw $t4, 0($t0)
		addi $t0, $t0, -4
		sw $t5, 0($t0)
		addi $t0, $t0, 4
	skip:
		addi $t2, $t2, 1
		bne $t2, $t6, loop2
		
	
	
	sub $t0, $t0, $t7 
	addi $t1, $t1, -1
	bne $t1, $zero, loop1
	
sorted:
	
	lw $a1, 4($sp)
	move $a0, $t0
	jal processSortedArray
	
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
processSortedArray:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# initalize values
	move $t0, $a0	# array
	move $t1, $a1	# array size
	li $t2, 1	# index
	addi $t1, $t1, 1
	
loop3:
	lw $t3, 0($t0)
	
	# calculate sum of digits
	move $a0, $t3
	jal sumDigits
	
	# print the line
	move $t4, $v0
	
	move $a0, $t2
	li $v0, 1
	syscall
	
	la $a0, tab
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	la $a0, tab
	li $v0, 4
	syscall
	
	move $a0, $t4
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	addi $t2, $t2, 1
	addi $t0, $t0, 4
	bne $t1, $t2, loop3
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
	
	
sumDigits:
	li $v0, 0
	li $t6, 10
	move $t5, $a0
	bgt $t5, $zero, pos
	
	mul $t5, $t5, -1
pos:	
	div $t5, $t6
	mflo $t5
	mfhi $t7
	add $v0, $v0, $t7
	bne $t5, $zero, pos
	
	jr $ra
	
	
	
	
	
	
	
	
	
