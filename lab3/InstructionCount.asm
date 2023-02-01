	.data
	newline:	.asciiz		"\n"
	msg1:		.asciiz		"add: "
	msg2: 		.asciiz		"lw: "
	msg3:		.asciiz		"ori: "
	
	
	.text
L1:
	add $t7, $t7, $zero
	add $t6, $t7, $t7
	lw $t5, L1
	ori $t5, $t6, 0xffff0000

	# call instruction count sub-program
	la $a0, L3
	la $a1, L4
	jal instructionCount
	
	# print add count
	la $a0, msg1
	li $v0, 4
	syscall
	
	add $a0, $zero, $s0
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall

	# print lw count
	la $a0, msg2
	li $v0, 4
	syscall
	
	add $a0, $zero, $s1
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	# print ori count
	la $a0, msg3
	li $v0, 4
	syscall
	
	add $a0, $zero, $s2
	li $v0, 1
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
L2:
	
	# exit the program
	li $v0, 10
	syscall
	
	
instructionCount:
L3:
	add $t0, $zero, $a0
	add $t1, $zero, $a1
	add $s0, $zero, $zero
	add $s1, $zero, $zero
	add $s2, $zero, $zero

loop:
	lw $t2, 0($t0)
	andi $t3, $t2, 0xfc00003f
	beq $t3, 0x00000020, if1
	andi $t3, $t2, 0xfc000000
	beq $t3, 0x8c000000, if2
	beq $t3, 0x34000000, if3
	j else
	
if1:
	addi $s0, $s0, 1
	j else
if2:
	addi $s1, $s1, 1
	j else
if3:
	addi $s2, $s2, 1
	j else
else:
	addi $t0, $t0, 4
	bne $t0, $t1, loop

	jr $ra
L4:
