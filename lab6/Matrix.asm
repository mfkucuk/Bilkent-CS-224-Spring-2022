	.data
	m1:	.asciiz		"\n1. Create matrix and initalize\n2. Create matrix\n3. Display a matrix element\n4. Display a matrix\n5. Copy matrix\n6. Quit\n"
	m2:	.asciiz		"Desired element is "
	m3:	.asciiz		"Matrix is \n"
	p1:	.asciiz		"Enter an option (1-6): "
	p2:	.asciiz		"Enter row: "
	p3:	.asciiz		"Enter column: "
	p4:	.asciiz		"Enter row "
	p5:	.asciiz		"(1: row-wise, 2: col-wise): "
	col:	.asciiz		": \n"
	tab:	.asciiz		"\t"
	nl:	.asciiz		"\n"
	
	
	
	.text
	
	# Provide a simple menu for the user
menu:
	la	$a0, m1
	li	$v0, 4
	syscall
	
	la	$a0, p1
	li	$v0, 4
	syscall

	li	$v0, 5
	syscall
	
	beq	$v0, 1, one
	beq	$v0, 2, two
	beq	$v0, 3, three
	beq	$v0, 4, four
	beq	$v0, 5, five
	beq	$v0, 6, end
	
	j 	menu

one:
	# Ask for number of rows
	la	$a0, p2
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	move	$t0, $v0
	move	$t2, $t0
	
	# Ask for number of columns
	la	$a0, p3
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	move	$a0, $t0
	move	$a1, $v0
	move	$t3, $v0
	
	jal	createMatrixAndInit
	move	$t1, $v0
	
	j	menu
	
two:
	# Ask for number of rows
	la	$a0, p2
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	move	$t0, $v0
	move	$t2, $t0
	
	# Ask for number of columns
	la	$a0, p3
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	move	$a0, $t0
	move	$a1, $v0
	move	$t3, $v0
	
	jal	createMatrix
	move	$t1, $v0
	
	j	menu
	
three:
	# Ask for row number
	la	$a0, p2
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	move	$a1, $v0
	
	# Ask for col number
	la	$a0, p3
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	move	$a2, $v0
	move	$a0, $t1
	
	jal	displayElement
	j	menu

four:
	move	$a0, $t1
	move	$a1, $t2
	move	$a2, $t3
	jal	displayMatrix
	j	menu

five:
	move	$a0, $t1
	move	$a1, $t2
	move	$a2, $t3
	
	jal	copyMatrix
	move	$t1, $v0
	j	menu
			
	
	
	# End-of-program
end:
	li	$v0, 10
	syscall


createMatrixAndInit:
	# Put items in a stack
	addi	$sp, $sp, -24
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	
	# Initalize registers
	move	$s1, $a0
	move	$s2, $a1
	
	mul	$a0, $s1, $s2
	mul	$a0, $a0, 4
	li	$v0, 9
	syscall
	
	move	$s0, $v0
	li	$s3, 1
	li	$s4, 1
	
	move	$s5, $s0
	
	# Initalize matrix elements (by taking input)
L2:
	li	$s4, 1
	
	la	$a0, p4
	li	$v0, 4
	syscall
	
	move	$a0, $s3
	li	$v0, 1
	syscall
	
	la	$a0, col
	li	$v0, 4
	syscall
	
	L3:
		li	$v0, 5
		syscall
		sw	$v0, 0($s0)
		addi	$s0, $s0, 4
		addi	$s4, $s4, 1
		ble	$s4, $s2, L3
		
	addi	$s3, $s3, 1
	ble	$s3, $s1, L2
	
	# Return the address of the first element
	move	$v0, $s5
	
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra

createMatrix:
	# Put items in a stack
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	# Initalize registers
	move	$s1, $a0
	move	$s2, $a1
	
	mul	$a0, $s1, $s2
	mul	$a0, $a0, 4
	li	$v0, 9
	syscall
	
	move	$s0, $v0
	mul	$s3, $s1, $s2
	li	$s4, 1
	
	move	$v0, $s0
	
	# Initalize matrix elements (consecutively)
L1:
	sw	$s4, 0($s0)
	addi	$s4, $s4, 1
	addi	$s0, $s0, 4
	addi	$s3, $s3, -1
	bne	$s3, $zero, L1
	
	# Return the address of the first element
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	addi	$sp, $sp, 20
	
	jr	$ra

displayElement:
	# Put elements into the stack
	
	
	# Calculate offset
	move	$s0, $a1	# row off-set
	move	$s1, $a2	# col off-set
	
	# row off-set
	addi	$s0, $s0, -1
	mul	$s0, $s0, 4
	mul	$s0, $s0, $t2
	
	# col off-set
	addi	$s1, $s1, -1
	mul	$s1, $s1, 4
	
	# fetch the desired matrix element
	add	$s2, $s0, $s1
	add	$a0, $a0, $s2
	lw	$s0, 0($a0)
	
	la	$a0, m2
	li	$v0, 4
	syscall
	
	move	$a0, $s0
	li	$v0, 1
	syscall
	
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	addi	$sp, $sp, 12
	
	jr	$ra
	
displayMatrix:
	# Put elements into the stack
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	# Initalize registers
	move	$s0, $a0
	mul	$s1, $a1, $a2
	li	$s2, 0
	li	$s3, 0
	
	la	$a0, m3
	li	$v0, 4
	syscall
	
L4:
	lw	$s3, 0($s0)
	
	move	$a0, $s3
	li	$v0, 1
	syscall
	
	la	$a0, tab
	li	$v0, 4
	syscall
	
	addi	$s0, $s0, 4
	addi	$s2, $s2, 1
	
	# check if a new line is needed
	div	$s2, $a1
	mfhi	$s4
	beq	$s4, $zero, pnl
cont:
	bne	$s1, $s2, L4
	
	
	j	done

pnl:
	la	$a0, nl
	li	$v0, 4
	syscall
	j	cont
	
done:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	addi	$sp, $sp, 20
	
	jr	$ra
	

copyMatrix:
	# Put elements into the stack
	addi	$sp, $sp, -32
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	sw	$s6, 24($sp)
	sw	$s7, 28($sp)
	
	# Initalize registers
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	
	mul	$a0, $s1, $s2
	mul	$a0, $a0, 4
	li	$v0, 9
	syscall
	move	$s3, $v0
	move	$s4, $v0
	
	# row-wise or col-wise?
	la	$a0, p5
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	
	beq	$v0, 1, rowwise
	
	# col-wise here
L6:
	move	$s2, $a2
	
	L7:
		lw	$s6, 0($s0)
		sw	$s6, 0($s3)
		mul	$s7, $a2, 4
		add	$s0, $s0, $s7
		add	$s3, $s3, $s7
		addi	$s2, $s2, -1
		bne	$s2, $zero, L7
		
	move	$s7, $a2
	move	$s5, $a1
	mul	$s7, $s7, $s5
	mul	$s7, $s7, 4
	sub	$s0, $s0, $s7
	sub	$s3, $s3, $s7
	addi	$s0, $s0, 4
	addi	$s3, $s3, 4
	addi	$s1, $s1, -1
	bne	$s1, $zero, L6
	
	j	exit
rowwise:
	mul	$s5, $s1, $s2
L5:
	lw	$s6, 0($s0)
	sw	$s6, 0($s3)
	addi	$s0, $s0, 4
	addi	$s3, $s3, 4
	addi	$s5, $s5, -1
	bne	$s5, $zero, L5

exit:
	move	$v0, $s4
	
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	addi	$sp, $sp, 32
	
	jr	$ra