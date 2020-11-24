  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2			# change a0 here for different delay times in seconds 
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
 stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  hexasc:
  	andi $t0,$a0,0xf		# taking only the last four bits
  
 	ble $t0,9,number
 	nop		
 	ble $t0,15,letters
 	nop
  
  	number:
  		addi $v0,$t0,0x30	# register $v0 has the seven least significant bits, an ASCII code 
  		jr $ra			# 0x30 converts numbers to ASCII
  		nop
  	
 	letters:
 		addi $v0,$t0,0x37	# register $v0 has the seven least significant bits, 0x37 is for 
 		jr $ra			# the letters 
 		nop
 		
delay_old:
 	jr $ra
	nop
	
delay:
	PUSH $ra
	li $t2, 0 			# int i = 0
	li $t3, 4711			# constant from code 4711  # change this in the lab
	
	while: 
		ble $a0, 0, finish	# branch less or equal for 0 and t1
		nop			# no operation
		sub $a0, $a0, 1		# ms = ms - 1
	
		for:
			beq $t2, $t3, while	#  i < 4711;
			nop
			addi $t2, $t2, 1	# i = i + 1 
			j for			# go back
			nop

finish:
	POP $ra
	jr $ra
	nop

	
	
time2string:
	PUSH $s1
	PUSH $ra
	move $s1,$a0
	
	# do intial comparison
	andi $t0,$a1,0xff		# mask last two digits but eight bits of ASCII code
	beq $t0, 0, DING		# compare to 0 and branch to DING function
	nop

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
	
	li $t0 0x3a
	sb $t0 2($s1)
	
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
	continue2:
	move $a2,$v0
	sb $a2,4($s1)	
	
	li $t0, 0x0
	sb $t0,5($s1)
	
	end:
		POP $ra
		POP $s1
	
	jr $ra
	nop
	
	DING:
		li $t1, 0x44
		li $t2, 0x49
		li $t3, 0x4e
		li $t4, 0x47
		li $t5,0x0
		
		sb $t1,0($s1)
		sb $t2,1($s1)
		sb $t3,2($s1)
		sb $t4,3($s1)
		sb $t5,4($s1)
	
	j end
	nop