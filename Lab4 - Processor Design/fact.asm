addi $v0, $0, 0		# Return register
addi $a0, $0, 5		# n
addi $a1, $0, 1		# i
addi $v1, $0, 0		# return for multiply
addi $a2, $v1, 1		# val 1(Loop mult Counter)

beq  $a0, $0, noll	# n == 0 (Om n == 0, gå till noll)
add  $0, $0, $0		# NOP

addi $at, $0, 1		# n == 1 (Om n == 1, gå till noll)
beq  $a0, $at, noll	# ^
add  $0, $0, $0		# NOP

loop:
	beq  $a1, $a0, stop 	# i == n, stop (Om Counter == n, stop)
	add  $0, $0, $0		# NOP

	add  $a2, $a2, $v1 	#a2 + return from mult
	addi $a3, $a1, 1		#$a3 = i+1
	addi $v1, $0, 0		#reset return from mult
	# Multiplies $a2 with $a3 and returns in $v1
	multiply:
		beq  $a2, $0, done
		add  $0, $0, $0	# NOP
		
		add  $v1, $v1, $a3 #return + a3
		addi $a2, $a2, -1 

		beq  $0, $0, multiply	# UNCONDITIONAL JUMP
		add  $0, $0, $0	# NOP
	
	done:
		addi $a1, $a1, 1	# i++
		
		beq  $0, $0, loop	# UNCONDITIONAL JUMP
		add  $0, $0, $0		# NOP

noll:
	addi $v1, $0, 1
	beq  $0, $0, stop		# UNCONDITIONAL JUMP
	add  $0, $0, $0			# NOP

stop:
	add  $v0, $v0, $v1		# Increment global return
	beq  $0, $0, end			# UNCONDITIONAL JUMP
	add  $0, $0, $0			# NOP

end:
	beq $0, $0, end			# NOP
	add  $0, $0, $0			# NOP
