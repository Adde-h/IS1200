  # labwork.S
  # Written 2015 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1 2015-2016.
  # The macros PUSH and POP are in the public domain.

.global delay  
.global	time2string 
.global enable_interrupt

.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm

  # You can add your own code here
  #
  
  hexasc:
  	andi $t0,$a0,0xf		# taking only the last four bits
  
 	ble $t0,9,number
 	nop		
 	ble $t0,15,letters
 	nop
  
  	number:
  		addi $v0,$t0,0x30	# register $v0 has the seven least significant bits, an ASCII code 
  		jr $ra			# 0x30 converts numbers to ASCII
  	
 	letters:
 		addi $v0,$t0,0x37	# register $v0 has the seven least significant bits, 0x37 is for 
 		jr $ra			# the letters 
 		
 delay_old:
 	jr $ra
	nop
	
delay:
	PUSH $ra
	li $t1,1000			# load 1000 ms to register t1 (t1 is like ms)
	li $t2, 0 			# int i = 0
	li $t3, 9000000			# constant from code
	
	while: 
		ble $t1, 0, finish	# branch less or equal for 0 and t1
		nop			# no operation
		sub $t1, $t1, 1		# ms = ms - 1
	
		for:
			beq $t2, $t3, while	#  i < 4711;
			nop
			addi $t2, $t2, 1	# i = i + 1 
			j for			# go back to start of loop
			nop

	finish:
		POP $ra
		jr $ra
		nop

	
	
time2string:
	PUSH $s1
	PUSH $ra
	move $s1,$a0
	

	andi $t0, $a1, 0xf000
	srl $a0,$t0,12
	jal hexasc
	nop
	move $a2,$v0
	sb $a2,0($s1)
	
	andi $t0, $a1, 0x0f00
	srl $a0,$t0,8
	jal hexasc
	nop
	move $a2,$v0
	sb $a2,1($s1)
	
	li $t0, 0x3a
	sb $t0, 2($s1)
	
	andi $t0, $a1, 0x00f0
	srl $a0,$t0,4
	jal hexasc
	nop
	move $a2,$v0
	sb $a2,3($s1)
	
	andi $t0, $a1, 0x000f
	srl $a0,$t0,0
	jal hexasc
	nop
	move $a2,$v0
	sb $a2,4($s1)
	
	li $t0, 0x0
	sb $t0,5($s1)
	
	POP $ra
	POP $s1
	
	jr $ra
	nop
	
	nop
	
 enable_interrupt:
 	ei
 	jr $ra
 	nop
