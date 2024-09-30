.globl main


.text
main:

    li $a0, 5
    jal factorial
    
    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 10
    syscall



factorial:
    beq $a0, $zero, base
    sw $a0, 0($sp)
    sw $ra, -4($sp)
    addi $sp, -8
    addi $a0, -1
    jal factorial
    addi $sp, 8
    lw $a0, 0($sp)
    lw $ra, -4($sp)
    mul $v0, $v0, $a0
    jr $ra

base:
    li $v0, 1
    jr $ra
