.data
A:
	.word 0
	.word 0
	.word -1
	.word 2
	.word 0
	.word 2
	.word -1
	.word -1
len:
	.word 4

.globl main
.text

main:
	#Real part of elt
	li $v0, 5
	syscall
	move $s0, $v0
	
	#Imaginary part of elt
	li $v0, 5
	syscall
	move $s1, $v0

	move $a0, $s1
	la $a1, A
	add $a2, $zero, $zero
	la $s3, len
	lw $a3, 0($s3)

	#Stack Stuff
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	

	jal numLessThan
	# Stack Stuff
	addi $sp, $sp, 4

	#Print the value we got
	move $a0, $v0
	li $v0, 1
	syscall

	li $v0, 10
	syscall


numLessThan:
	# Just below the stack pointer is elt_Re, $a0 has elt_im, $a1 has *A
	# $a2 has Start, $a3 has end
	# Loads elt_Re into $t0
	# t1 Holds the count of numbers that are less than
	lw $t0, 4($sp)
	add $t1, $zero, $zero
	sll $t9, $a2, 3
	add $a1, $a1, $t9
	# Dealing with the stack and $ra
	sw $ra, 0($sp)
	addi $sp, $sp, -4


loop:
	# Stack Stuff
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	addi $sp, $sp, -4




# FUnction Call and Setup
	lw $t6, 0($a1)
	lw $t7 4($a1)
	move $a0, $t6
	move $a2, $t7
	lw $a1, 24($sp)
	lw $a3, 16($sp)
	jal isLessThan
	


# Stack restoration
	


	addi $sp, $sp, 4
	lw $a3, 0($sp)
	addi $sp, $sp, 4
	lw $a2, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)

	addi $a1, 8
	add $t1, $t1, $v0
	addi $a2, $a2, 1
	add $t3, $zero, $zero
	slt $t3 ,$a2, $a3
	bnez $t3, loop


return:
	move $v0, $t1
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra




isLessThan:
	# Receives re e1, re e2, im e1, im e2 in a0, a1, a2 and a3.
	slt $t1, $a0, $a1
	bnez $t1, sucess
	beq $a0, $a1, imcheck
	j faliure

imcheck:
	slt $t2, $a2, $a3
	bnez $t2, sucess
	j faliure

sucess:
	addi $v0, $zero, 1
	jr $ra
	
faliure:
	add $v0, $zero, $zero
	jr $ra



