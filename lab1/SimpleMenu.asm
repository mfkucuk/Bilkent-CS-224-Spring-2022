#
#      Simple menu: Performs various operations on an array.
#	
		
	.text
	
	# ask the user the array size
	la $a0, prompt1 # prompt message to be printed
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# store the array size in memory
	sw $v0, size
	
	# ask the user the enter the elements
	la $t0, array
	lw $t1, size
	
	la $a0, prompt2
	li $v0, 4
	syscall
	
	move $a0, $t1
	li $v0, 1
	syscall
	
	la $a0, prompt3
	li $v0, 4
	syscall
	
input:
	li $v0, 5
	syscall
	sw $v0, 0($t0)	
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, input
	
	# display the menu and ask for choice
menu:
	li $v0, 4
	la $a0, opt1
	syscall
	la $a0, opt2
	syscall
	la $a0, opt3
	syscall
	la $a0, opt4
	syscall
	la $a0, msg1
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 1, one
	beq $v0, 2, two
	beq $v0, 3, three
	beq $v0, 4, quit
	bgt $v0, 4, menu
	
one:
	# load the array and array size
	la $t0, array
	lw $t1, size
	li $t4, 0 # $t4: sum = 0

	# take input from the user
	la $a0, prompt4
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t2, $v0
	
	# find the sum of the numbers which are smaller than the input number
loop1:
	lw $t3, 0($t0)
	blt $t3, $t2, sum
return:
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, loop1
	
	# display the sum
	la $a0, msg2
	li $v0, 4
	syscall
	
	move $a0, $t4
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	# return to menu
	j menu
	
sum:
	add $t4, $t4, $t3
	j return
	
two:
	# load the array and array size
	la $t0, array
	lw $t1, size
	li $t2, 0 # $t2: number of even elements = 0
	li $t3, 0 # $t3: number of odd elements = 0
	li $t4, 2
	
	# count odd and even elements
loop2:
	lw $t5, 0($t0)
	div $t5, $t4
	mfhi $t6
	beq $t6, 1, odd
	beq $t6, $zero, even
back:
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, loop2
	
	# display the odd and even count
	# even
	la $a0, msg3
	li $v0, 4
	syscall
	
	move $a0, $t2
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	# odd
	la $a0, msg4
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	# return to menu
	j menu

odd:
	# increment odd count
	addi $t3, $t3, 1
	j back
	
even:
	# increment even count
	addi $t2, $t2, 1
	j back
	
three:
	# load the array and array size
	la $t0, array
	lw $t1, size
	li $t3, 0 # counter

	# take input from the user
	la $a0, prompt4
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t2, $v0
	
	# count the number which are not divisible by $t2
loop3:
	lw $t4, 0($t0)
	div $t4, $t2
	mfhi $t5
	bne $t5, $zero, count
again:
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bne $t1, $zero, loop3
	
	# display the count
	la $a0, msg5
	li $v0, 4
	syscall
	
	move $a0, $t2
	li $v0, 1
	syscall
	
	la $a0, msg6
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	# return to menu
	j menu
	
	
count:
	addi $t3, $t3, 1
	j again
	
quit:
	la $a0, msg7
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
	
	
	.data
array:	.space	400
size:	.space 4
prompt1:
	.asciiz	"Enter the size of the array: "
prompt2:
	.asciiz	"Enter "
prompt3:
	.asciiz	" numbers: \n"
prompt4:
	.asciiz	"Enter a number: "
opt1:	.asciiz	"1. Find summation of numbers stored in the array which is less than an input number\n"
opt2:	.asciiz	"2. Find the numbers of even and odd numbers and display them\n"
opt3:	.asciiz	"3. Display the number of occurrences of the array elements NOT divisible by a certain input number\n"
opt4:	.asciiz	"4. Quit\n"
msg1:	.asciiz	"Choose an option (1-4): "	
msg2:	.asciiz	"Sum is: "
msg3:	.asciiz "Number of even numbers: "
msg4:	.asciiz	"Number of odd numbers: " 
msg5:	.asciiz	"Number of elements which are not divisible by "
msg6:	.asciiz	": "
msg7:	.asciiz "Thank you for using simple menu\n\n"
newline:
	.asciiz "\n"
	
############# End of Simple Menu ################
