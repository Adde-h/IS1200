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
mytime:	.word 0x5959
timstr:	.ascii "text more text lots of text\0" #Detta allokerar ett minne i memory för att spara längre bytes, Detta skriver över flera minnes adresser
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
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

hexasc:
	andi $a0,$a0,0xF		# Lägger till 0xF, Zero-extendar alla bitar utom sista 4 bitarna
	ble $a0,0x9,num		# Jämnför $a0 med 9, ifall det är mindre eller lika med 9 då hoppa till num
	nop
	
	addi $v0,$a0,0x37	# Adderar hexa 37 till $a0 för att komma till ASCII bokstäverna och för över till $v0 för returvärde
	j end
	nop

num:
	addi $v0,$a0,0x30	# Adderar hexa 37 till $a0 för att komma till ASCII siffrorna och för över till $v0 för returvärde
	
end: 
	jr $ra
	nop

delay:
	li $t0,0			#Denna konstant ska vara enkelt att ändra
	move $t1, $a0		#Flyttar konstanten (ms) till $t1
	
while:
	ble $t1, 0, exit		#ms > 0
	nop
	sub $t1, $t1,1		#ms = ms - 1
	li $t2, 0		# int i = 0
	
for:
	bge $t2, $t0, while	# i < $t0, i < konstant
	nop
	addi $t2, $t2, 1		# i = i + 1
	
	j for			#Fortsätter tills i < $t0 inte längre gäller
	nop
	
	j while			#Fortsätter att kolla ifall while satsen fortfarande gäller
	nop
exit: 				
 	jr $ra			#Hoppar ut ur programmet
 	nop
 	
time2string:
	
	PUSH $ra			#Behövs PUSHAs för att sedan återkomma till Main metoden
	PUSH $s0			#Behövs PUSHAs för att spara förgående $s0 värden
	PUSH $s1			#$s0 är där tiden ska sparas
					
	move $s0, $a0		#Adress till där vi sparar tiden som printas
	move $s1, $a1 		# Address av mytime finns i $a1, flyttas till $s1
	
	andi $t0, $s1, 0xf000	#Hämtar första nibble som är första i minuten. 1x:xx 
	srl $a0, $t0, 12		#Shiftar denna byte 12 bitar
	jal hexasc		#Hoppar till hexasc och konverterar till ASCII
	nop
	move $t1,$v0		#Flyttar ASCII-värdet till $t1
	sb $t1,0($s0)		#Sparar ASCII-värdet från $t1 på byte 0 av $s0
	
	andi $t0, $s1,0xf00	#Hämtar andra nibble som är första i minuten. x1:xx 
	srl $a0, $t0,8		#Shiftar denna byte 8 bitar
	jal hexasc		#Hoppar till hexasc och konverterar till ASCII
	nop
	move $t1, $v0		#Flyttar ASCII-värdet till $t1
	sb $t1,1($s0)		#Sparar ASCII-värdet från $t1 på byte 1 av $s0
	
	li $t1, 0x3a 		#ASCII värdet för :, och sparar detta i byte 2 av $s0
	sb $t1, 2($s0)
	
	andi $t0, $s1, 0xf0	#Hämtar tredje nibble som är första i sekunden. xx:1x 
	srl $a0, $t0, 4		#Shiftar denna byte 4 bitar
	jal hexasc		#Hoppar till hexasc och konverterar till ASCII
	nop
	move $t1, $v0		#Flyttar ASCII-värdet till $t1
	sb $t1,3($s0)		#Sparar ASCII-värdet från $t1 på byte 3 av $s0
	
	andi $a0, $s1, 0xf	#Hämtar fjärde/sista nibble som är första i sekunden. xx:x1 
				#Behöver ej shiftas
	jal hexasc		#Hoppar till hexasc och konverterar till ASCII
	nop
	move $t1, $v0		#Flyttar ASCII-värdet till $t1
	sb $t1,4($s0)		#Sparar ASCII-värdet från $t1 på byte 4 av $s0
	
	#Suprise Asignment
	lb $t6,3($s0)		#Hämtar näst sista sekunden och lagrar i $t6
	lb $t7,4($s0)		#Hämtar sista sekunden och lagrar i $t7
	
	beq $t7, 0x00000030, nextcheck	#Kollar ifall $t7 == Hex värde för 0
	nop				#True = hoppa till nextcheck annars gå till j final
	j final				# Hoppar till final
	nop
		
	
nextcheck:
	beq $t6, 0x00000030, xmark	#Kollar ifall $t6 == Hex värde för 0
	nop				#Ifall true då hoppa till xmark annars gå till j final
	j final
	nop
	
	
xmark:				# Sätter in X då tiden är xx:00, Resultat: xx:00X
	li $t1, 0x58 		#Sätter ASCII värdet för X
	sb $t1, 5($s0)		#och sparar detta i byte 5 av $s0
	
	li $t1,0			#Hämtar null byte 
	sb $t1, 6($s0)		#Sparar null byte på byte 6 av $s0
	j exitt2s		
	nop
	
final:
	li $t1,0
	sb $t1, 5($s0)		#Sparar null byte på byte 5 av $s0
	j exitt2s
	nop
	
exitt2s:				#Hoppar ut ur time2string funktionen
	POP $s1			#Popar först $s1 då den blev sist pushad
	POP $s0
	POP $ra
	jr $ra
	nop
