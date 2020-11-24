  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,1		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  #
  
hexasc:
	andi $a0,$a0,0xF		# L�gger till 0xF, Zero-extendar alla bitar utom sista 4 bitarna
	ble $a0,0x9,num		# J�mnf�r $a0 med 9, ifall det �r mindre eller lika med 9 d� hoppa till num
	
	addi $v0,$a0,0x37	# Adderar hexa 37 till $a0 f�r att komma till ASCII bokst�verna och f�r �ver till $v0 f�r returv�rde
	j end

num:
	addi $v0,$a0,0x30	# Adderar hexa 37 till $a0 f�r att komma till ASCII siffrorna och f�r �ver till $v0 f�r returv�rde
	
end: 
	jr $ra
