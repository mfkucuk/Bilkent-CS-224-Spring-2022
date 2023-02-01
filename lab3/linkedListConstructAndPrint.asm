	.text
# CS224 Spring 2022, Program to be used in Lab3
# March 7, 2022
# 
	li	$a0, 10 	#create a linked list with 10 nodes
	jal	createLinkedList
	
# Linked list is pointed by $v0
	move	$t0, $v0
	move	$a0, $v0	# Pass the linked list address in $a0
	jal 	printLinkedList
	
# Display a linked list in reverse order recursively
	la 	$a0, newline
	li	$v0, 4
	syscall
	la 	$a0, msg1
	li	$v0, 4
	syscall
	
	move	$a0, $t0
	jal 	displayReverseOrderRecursively
	
# Duplicate a linked list iteratively
	la 	$a0, newline
	li	$v0, 4
	syscall
	la	$a0, msg2
	li	$v0, 4
	syscall
	
	move	$a0, $t0
	jal	duplicateListIterative
	
	move 	$a0, $v0
	jal	printLinkedList
	
# Duplicate a linked list recursively
	li	$s3, 0
	la 	$a0, newline
	li	$v0, 4
	syscall
	la	$a0, msg3
	li	$v0, 4
	syscall
	
	move	$a0, $t0
	jal	duplicateListRecursive
	
	move	$a0, $v0
	jal	printLinkedList
	
# Stop. 
	li	$v0, 10
	syscall

createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 12
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s1, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 12		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s1, 4($s2)	# Store the data value.
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
#=========================================================
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
displayReverseOrderRecursively:
	# load the current node
	move 	$s0, $a0
	
	# load the adress of the next node
	lw	$s1, 0($s0)
	lw	$s2, 4($s0)
	addi	$s3, $s3, 1

	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp)
	bne	$s1, 0x00000000, E1
	jr 	$ra

E1:	move	$a0, $s1 	
	jal 	displayReverseOrderRecursively
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	
	
	jr	$ra
	
duplicateListIterative:
	addi	$sp, $sp, -32
	sw	$s0, 28($sp)
	sw	$s1, 24($sp)
	sw	$s2, 20($sp)
	sw	$s3, 16($sp)
	sw	$s4, 12($sp)
	sw	$s5, 8($sp)
	sw	$s6, 4($sp)
	sw	$ra, 0($sp)
	
	# get head node.
	move 	$s0, $a0
	
	lw	$s1, 0($s0)
	lw 	$s2, 4($s0)
	
	# create head node for the new list.
	li 	$a0, 8
	li 	$v0, 9
	syscall
	sw	$s2, 4($v0)
	move	$s6, $v0
	move 	$s3, $s6
	move	$s0, $s1
	
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, msg4
	li	$v0, 4
	syscall
	
	move	$a0, $s6
	li	$v0, 34
	syscall
	
	la	$a0, msg5
	li	$v0, 4
	syscall
	
	move	$a0, $s2	
	li	$v0, 1
	syscall
	
duplicateNodeIterative:
	lw	$s1, 0($s0)
	lw	$s2, 4($s0)
	
	li	$a0, 8
	li	$v0, 9
	syscall
	move 	$s4, $v0
	sw 	$s2, 4($s4)
	sw 	$zero, 0($s4)
	sw 	$s4, 0($s3)
	move	$s3, $s4
	
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, msg4
	li	$v0, 4
	syscall
	
	move	$a0, $s3	
	li	$v0, 34
	syscall
	
	la	$a0, msg5
	li	$v0, 4
	syscall
	
	move	$a0, $s2	
	li	$v0, 1
	syscall
	
	beq	$s1, 0x00000000, L1
	
	move	$s0, $s1
	j	duplicateNodeIterative

L1:
	lw	$s0, 28($sp)
	lw	$s1, 24($sp)
	lw	$s2, 20($sp)
	lw	$s3, 16($sp)
	lw	$s4, 12($sp)
	lw	$s5, 8($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 32
	move	$v0, $s6
	jr 	$ra
	
duplicateListRecursive:
	bne	$s3, $zero, head
	move 	$s0, $a0
	lw 	$s1, 0($s0)
	lw 	$s2, 4($s0)
	li	$a0, 12
	li	$v0, 9
	syscall
	sw	$s2, 4($v0)
	sw	$zero, 0($v0)
	move	$s4, $v0
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, msg4
	li	$v0, 4
	syscall
	
	move	$a0, $s4	
	li	$v0, 34
	syscall
	
	la	$a0, msg5
	li	$v0, 4
	syscall
	
	move	$a0, $s2	
	li	$v0, 1
	syscall
	j 	E2
head:
	move	$s0, $a0
	lw 	$s1, 0($s0)
	lw 	$s2, 4($s0)
	li	$a0, 12
	li	$v0, 9
	syscall
	sw	$s2, 4($v0)
	sw	$zero, 0($v0)
	sw	$v0, 0($s4)
	move	$s4, $v0
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, msg4
	li	$v0, 4
	syscall
	
	move	$a0, $s4
	li	$v0, 34
	syscall
	
	la	$a0, msg5
	li	$v0, 4
	syscall
	
	move	$a0, $s2	
	li	$v0, 1
	syscall
E2:
	addi	$sp, $sp, -8
	sw	$s4, 4($sp)
	sw	$ra, 0($sp)
	addi	$s3, $s3, 1
	bne	$s1, 0x00000000, E3
	addi 	$sp, $sp, 8
	jr	$ra	
E3:	
	move	$a0, $s1
	jal	duplicateListRecursive
	
	lw	$ra, 0($sp)
	lw	$v0, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
	
	
#=========================================================		
	.data
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
	
msg1:
	.asciiz "\n Display linked list in a reverse order recursively."
	
msg2:
	.asciiz "\n Duplicate linked list itaretively."

msg3:
	.asciiz	"\n Duplicate linked list recursively."
	
msg4:	
	.asciiz	"\n Address of Duplicated Node: "
	
msg5:
	.asciiz "\n Value of Duplicated Node: "
	
newline:
	.asciiz	"\n"
