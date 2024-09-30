

main:
	li $v0, 5
	syscall
	move $s0, $v0

	li $v0, 5
	syscall
	move $s1, $v0

	add $s2, $s1, $s0


	move $a0, $s2
	li $v0, 1
	syscall

	
	li $v0, 10
	syscall

