.data
A:
	.word -20
	.word -19
	.word 77
	.word 79
	.word 80
	.word 1024
	.word 10222
	.word 10223
len:
	.word 8


.globl main
.text

main:
    #We ask for the value to search as user input
    la $a0, A
    la $a1, len
    lw $a1, 0($a1)
    li $a2, 0
    move $a3, $a1

    #Last argument gets delegated to the stack
    li $v0, 5
    syscall
    move $s0, $v0
    #Store the val to be looked on the stack
    sw $s0, 0($sp)
    addi $sp, $sp, -4
    jal binary_search
    addi $sp, $sp, 4

    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 10
    syscall

binary_search:
    slt $t1, $a3, $a2
    bne $t1, $zero, faliure
    add $t1, $a2, $a3
    # $t1 = mid
    srl $t1, $t1, 1
    # $t2 = 4 * mid (for offset reasons)
    # $t2 = A + 4* mid to read
    sll $t2, $t1, 2
    add $t2, $t2, $a0
    # Load the appropriate word
    # $t4 has value
    # $t3 has A[mid]
    lw $t3, 0($t2)
    lw $t4, 4($sp)
    beq $t3, $t4, sucess
    slt $t5, $t3, $t4
    bne $t5, $zero, less_than
    addi $a3, $t1, -1
    sw $ra, 0($sp)
    sw $t4, -4($sp)
    addi $sp, $sp, -8
    jal binary_search
    addi $sp, 8
    lw $ra, 0($sp)
    lw $t4, -4($sp)
    jr $ra  

    

less_than:
    addi $a2, $t1, 1
    sw $ra, 0($sp)
    sw $t4, -4($sp)
    addi $sp, $sp, -8
    jal binary_search
    addi $sp, 8
    lw $ra, 0($sp)
    lw $t4, -4($sp)
    jr $ra


sucess:
    move $v0, $t1
    jr $ra

faliure:
    li $v0, -1
    jr $ra

