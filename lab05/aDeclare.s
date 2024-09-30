
.data
B:
	.byte 0
	.align 2
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
	la $s0, A
	lw $t1, 16($s0)
	lw $t2, 20($s0)
	add $t3, $t1, $t2
	move $a0, $t3
	li $v0, 1
	syscall

