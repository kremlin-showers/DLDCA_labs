
	.data
prompt1: .asciiz "Enter the First Integer: "
prompt2: .asciiz "Enter the Second Integer: "
newline: .asciiz "\n"
bye: .asciiz "The Sum Of the Two Integers is: "
	.globl main
	.text

main:
	la $a0, prompt1
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	move $s0, $v0

	la $a0, prompt2
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	move $s1, $v0

	add $s2, $s1, $s0

	la $a0, bye
	li $v0, 4
	syscall

	move $a0, $s2
	li $v0, 1
	syscall

	la $a0, newline
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall

