

addi $a0, $0, 5		# n
addi $a0, $a0, 1
addi $v0, $0, 1		# result
addi $a1, $0, 1		# i = 1

beq $a0, $0, noll	# n == 0
add  $0, $0, $0		# NOP

loop:
	beq $a1, $a0, end		# i == n
	add  $0, $0, $0		# NOP
	
	mul $v0, $v0, $a1		# multiply with i
	addi $a1, $a1, 1		# i++
	beq $0, $0, loop		# loop
	add  $0,$0,$0	  # NOP

noll:
	addi $v0, $0, 1

end:
	add  $0,$0,$0	  # NOP
	beq $0, $0, end
