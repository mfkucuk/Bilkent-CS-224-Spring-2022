	.text
	
	# create array
	jal createArray
	
	# call array operations
	move $a0, $v0
	move $a1, $v1
	
	jal arrayOperations
	
	# exit the program
	li $v0, 10
	syscall
	
createArray:

	# ask for array size
	la $a0, prompt1
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	
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
	move $v1, $t1
	
	jr $ra
	
arrayOperations:
	
	subi $sp, $sp, 12
	
	# store arguments and return address to stack
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	
	# display array
	move $t0, $a0
	move $t1, $a1
	
	la $a0, msg6
	li $v0, 4
	syscall
	
dsply:
	lw $t2, 0($t0)
	
	move $a0, $t2
	li $v0, 1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, dsply
	
	la $a0, newline
	li $v0, 4
	syscall
	
	# find min
	lw $a0, 8($sp)
	lw $a1, 4($sp)
	jal min
	
	# display min
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
	
	# find max	
	lw $a0, 8($sp)
	lw $a1, 4($sp)
	jal max
	
	# display max
	move $t0, $v0
	
	la $a0, msg2
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	# find sum			
	lw $a0, 8($sp)
	lw $a1, 4($sp)
	jal sum
	
	# display sum
	move $t0, $v0
	
	la $a0, msg3
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	# check if the array is a palindrome or not
	lw $a0, 8($sp)
	lw $a1, 4($sp)
	jal palindrome
	
	# display result
	move $t0, $v0
	beq $t0, 0, fail
	
	la $a0, msg4
	li $v0, 4
	syscall
	j end
	
fail:
	la $a0, msg5
	li $v0, 4
	syscall

end:
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra
	
min:
	move $t0, $a0
	move $t1, $a1
	lw $t2, 0($t0)
	
loop1:
	lw $t3, 0($t0)
	bgt $t2, $t3, setMin
back1:
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, loop1
	
	move $v0, $t2
	jr $ra
	
setMin:
	move $t2, $t3	
	j back1
	
max:
	move $t0, $a0
	move $t1, $a1
	lw $t2, 0($t0)
	
loop2:
	lw $t3, 0($t0)
	blt $t2, $t3, setMax
back2:
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, loop2
	
	move $v0, $t2
	jr $ra
	
setMax:
	move $t2, $t3	
	j back2
	

sum:
	move $t0, $a0
	move $t1, $a1
	li $t2, 0
	
loop3:
	lw $t3, 0($t0)
	add $t2, $t2, $t3
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, loop3
	
	
	move $v0, $t2
	jr $ra 
	
palindrome:
	move $t0, $a0
	move $t1, $a1
	mul $t2, $t1, 4
	subi $t2, $t2, 4
	div $t1, $t1, 2
	
loop4:
	lw $t3, 0($t0)
	add $t0, $t0, $t2
	lw $t4, 0($t0)
	sub $t0, $t0, $t2
	bne $t3, $t4, no
	subi $t2, $t2, 8
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, loop4
	
	li $v0, 1
	j yes

no:
	li $v0, 0

yes:
	jr $ra
	
	.data
newline:
	.asciiz "\n"
space:	.asciiz " "
prompt1:
	.asciiz	"Enter the number of elements: "
prompt2:
	.asciiz	"Enter "
prompt3:
	.asciiz	" numbers: \n"
msg1:	.asciiz	"Min: "
msg2:	.asciiz	"Max: "
msg3:	.asciiz	"Sum: "
msg4:	.asciiz	"Array is a palindrome\n"
msg5:	.asciiz	"Array is not a palindrome\n"
msg6:	.asciiz	"Array: "