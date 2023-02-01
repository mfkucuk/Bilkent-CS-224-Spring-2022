	.text
	# take input
	la $a0, prompt1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, num
	
	la $a0, prompt2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, shiftAmount
	
	# display the original number in hex form
	lw $a0, num
	li $v0, 34
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	# call shift left circular sub-program
	lw $a0, num
	lw $a1, shiftAmount
	jal shiftLeftCircular
	
	move $t0, $v0
	
	# display the number shifted to left
	la $a0, msg2
	li $v0, 4
	syscall
	
	lw $a0, shiftAmount
	li $v0, 1
	syscall
	
	la $a0, msg1
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 34
	syscall
		
	la $a0, newline
	li $v0, 4
	syscall
	
	# call shift right circular sub-program
	lw $a0, num
	lw $a1, shiftAmount
	jal shiftRightCircular
	
	# display the number shifted to right
	la $a0, msg3
	li $v0, 4
	syscall
	
	lw $a0, shiftAmount
	li $v0, 1
	syscall
	
	la $a0, msg1
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 34
	syscall
		
	la $a0, newline
	li $v0, 4
	syscall
	
	# exit the program
	li $v0, 10
	syscall
	
		

shiftLeftCircular:
	move $t0, $a0	# number to be shifted 
	move $t1, $a1	# shift amount

shiftl:
	# check if the number is negative. if it is negative msb must be 1, otherwise 0.
	slt $t2, $t0, $zero
	
	# shift the number to the left by 1 bit. add the previous msb to the current lsb.
	sll $t0, $t0, 1
	add $t0, $t0, $t2
	addi $t1, $t1, -1
	bne $t1, $zero, shiftl
	
	# return the result
	move $v0, $t0
	jr $ra
	
		
shiftRightCircular:	
	move $t0, $a0
	move $t1, $a1
	li $t3, 2		# number 2 for division
	li $t4, 0x80000000	# using this value to add 1 to msb
	
shiftr:
	div $t0, $t3
	mfhi $t2
	mult $t2, $t4
	mflo $t2
	srl $t0, $t0, 1
	add $t0, $t0, $t2
	addi $t1, $t1, -1
	bne $t1, $zero, shiftr
	
	# return the result
	move $v0, $t0
	jr $ra
		
	.data
num:	.space	4
shiftAmount:
	.space	4
newline:
	.asciiz	"\n"
prompt1:
	.asciiz	"Enter the number to be shifted: "
prompt2:
	.asciiz	"Enter the shift amount: "
msg1:	.asciiz	"): "
msg2:	.asciiz	"(Shift Left Circular "
msg3:	.asciiz	"(Shift Right Circular "
