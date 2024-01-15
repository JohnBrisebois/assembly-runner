.data 

.text

.globl menu

menu:
	sw $ra, 100($sp)

	jal printMenu
	
	li $t1, 0
	sw $t1, 0xffff0004
	
	jal menuLoop
	
	lw $ra, 100($sp)
	jr $ra

printMenu:
	sw $ra, 104($sp)
	# load color white
	li $t1, 0x00ffffff
	# load color black
	li $t2, 0x00000000
	# load display address
	la $t3, 0x10010000
	
	li $s1, 0
	
	fillBlack:
		sw $t2, ($t3)
		add $t3, $t3, 4
		add $s1, $s1, 1
		blt $s1, 8192, fillBlack
	
	# print characters to screen
	la $t3, 0x10010000
	
	jal P
	jal R
	jal E
	jal S
	jal S
	jal _
	jal S
	jal P
	jal A
	jal C
	jal E
	jal _
	jal T
	jal O
	jal _
	jal S
	jal T
	jal A
	jal R
	jal T
	
	# load the new display address for the next sentence
	la $t3, 0x10010000
	add $t3, $t3, 5120
	
	jal P
	jal R
	jal E
	jal S
	jal S
	jal _
	jal E
	jal S
	jal C
	jal _
	jal T
	jal O
	jal _
	jal E
	jal X
	jal I
	jal T
	
	la $t3, 0x10010000
	add $t3, $t3, 15360
	
	jal J
	jal U
	jal M
	jal P
	jal scolon
	jal _
	jal S
	jal P
	jal A
	jal C
	jal E
	
	la $t3, 0x10010000
	add $t3, $t3, 20480
	
	jal D
	jal O
	jal D
	jal G
	jal E
	jal scolon
	jal _
	jal S
	
	la $t3, 0x10010000
	add $t3, $t3, 25600
	
	jal M
	jal E
	jal N
	jal U
	jal scolon
	jal _
	jal E
	jal S
	jal C
	
	lw $ra, 104($sp)
	jr $ra

menuLoop:

	lw $t4, 0xffff0000
	
	andi $t4, $t4, 1
	
	lw $t3, 400($sp) # increment frame counter for seed
	add $t3, $t3, 1
	blt $t3, 10000, skipZero # to avoid overflow, zero the seed if its above 10000
	li $t3, 0
	skipZero:
	sw $t3, 400($sp)
	
	beqz $t4, menuLoop
	
	lw $t4, 0xffff0004
	
	beq $t4, 27, exit # if key is exc, exit
	
	bne $t4, 32, menuLoop # if its not space, loop
	
	li $t4, 0
	sw $t4, 0xffff0004
	
	jr $ra
	
# below are the functions that print characters on screen

_:

	add $t3, $t3, 12
	
	jr $ra
	
P:
	li $t1, 0x00ffffff
	
	sw $t1, 516($t3)
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 528($t3)
	sw $t1, 1028($t3)
	sw $t1, 1044($t3)
	sw $t1, 1540($t3)
	sw $t1, 1556($t3)
	sw $t1, 2052($t3)
	sw $t1, 2056($t3)
	sw $t1, 2060($t3)
	sw $t1, 2064($t3)
	sw $t1, 2564($t3)
	sw $t1, 3076($t3)
	sw $t1, 3588($t3)
	
	add $t3, $t3, 24
	
	jr $ra
	
R:
	li $t1, 0x00ffffff
	
	sw $t1, 516($t3)
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 528($t3)
	sw $t1, 1028($t3)
	sw $t1, 1044($t3)
	sw $t1, 1540($t3)
	sw $t1, 1556($t3)
	sw $t1, 2052($t3)
	sw $t1, 2056($t3)
	sw $t1, 2060($t3)
	sw $t1, 2064($t3)
	sw $t1, 2564($t3)
	sw $t1, 2576($t3)
	sw $t1, 3076($t3)
	sw $t1, 3092($t3)
	sw $t1, 3588($t3)
	sw $t1, 3604($t3)
	
	add $t3, $t3, 24
	jr $ra
	
E:
	li $t1, 0x00ffffff
	
	sw $t1, 516($t3)
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 528($t3)
	sw $t1, 532($t3)
	sw $t1, 1028($t3)
	sw $t1, 1540($t3)
	sw $t1, 2052($t3)
	sw $t1, 2056($t3)
	sw $t1, 2060($t3)
	sw $t1, 2064($t3)
	sw $t1, 2068($t3)
	sw $t1, 2564($t3)
	sw $t1, 3076($t3)
	sw $t1, 3588($t3)
	sw $t1, 3592($t3)
	sw $t1, 3596($t3)
	sw $t1, 3600($t3)
	sw $t1, 3604($t3)
	
	add $t3, $t3, 24
	jr $ra
	
S:
	li $t1, 0x00ffffff
	
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 528($t3)
	sw $t1, 1028($t3)
	sw $t1, 1044($t3)
	sw $t1, 1540($t3)
	sw $t1, 2056($t3)
	sw $t1, 2060($t3)
	sw $t1, 2064($t3)
	sw $t1, 2580($t3)
	sw $t1, 3076($t3)
	sw $t1, 3092($t3)
	sw $t1, 3592($t3)
	sw $t1, 3596($t3)
	sw $t1, 3600($t3)
	
	add $t3, $t3, 24
	jr $ra
	
N:
	li $t1, 0x00ffffff
	
	sw $t1, 516($t3)
	sw $t1, 532($t3)
	sw $t1, 1028($t3)
	sw $t1, 1032($t3)
	sw $t1, 1044($t3)
	sw $t1, 1540($t3)
	sw $t1, 1548($t3)
	sw $t1, 1556($t3)
	sw $t1, 2052($t3)
	sw $t1, 2060($t3)
	sw $t1, 2068($t3)
	sw $t1, 2564($t3)
	sw $t1, 2576($t3)
	sw $t1, 2580($t3)
	sw $t1, 3076($t3)
	sw $t1, 3088($t3)
	sw $t1, 3092($t3)
	sw $t1, 3588($t3)
	sw $t1, 3604($t3)
	
	
	add $t3, $t3, 24
	jr $ra
	
A:
	li $t1, 0x00ffffff
	
	sw $t1, 524($t3)
	sw $t1, 1032($t3)
	sw $t1, 1040($t3)
	sw $t1, 1540($t3)
	sw $t1, 1556($t3)
	sw $t1, 2052($t3)
	sw $t1, 2068($t3)
	sw $t1, 2564($t3)
	sw $t1, 2568($t3)
	sw $t1, 2572($t3)
	sw $t1, 2576($t3)
	sw $t1, 2580($t3)
	sw $t1, 3076($t3)
	sw $t1, 3092($t3)
	sw $t1, 3588($t3)
	sw $t1, 3604($t3)
	
	
	add $t3, $t3, 24
	jr $ra

C:
	li $t1, 0x00ffffff
	
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 528($t3)
	sw $t1, 1028($t3)
	sw $t1, 1044($t3)
	sw $t1, 1540($t3)
	sw $t1, 2052($t3)
	sw $t1, 2564($t3)
	sw $t1, 3076($t3)
	sw $t1, 3092($t3)
	sw $t1, 3592($t3)
	sw $t1, 3596($t3)
	sw $t1, 3600($t3)
	
	add $t3, $t3, 24
	jr $ra
	
T:
	li $t1, 0x00ffffff
	
	sw $t1, 516($t3)
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 528($t3)
	sw $t1, 532($t3)
	sw $t1, 1036($t3)
	sw $t1, 1548($t3)
	sw $t1, 2060($t3)
	sw $t1, 2572($t3)
	sw $t1, 3084($t3)
	sw $t1, 3596($t3)
	
	add $t3, $t3, 24
	jr $ra
	
O:
	li $t1, 0x00ffffff
	
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 528($t3)
	sw $t1, 1028($t3)
	sw $t1, 1044($t3)
	sw $t1, 1540($t3)
	sw $t1, 1556($t3)
	sw $t1, 2052($t3)
	sw $t1, 2068($t3)
	sw $t1, 2564($t3)
	sw $t1, 2580($t3)
	sw $t1, 3076($t3)
	sw $t1, 3092($t3)
	sw $t1, 3592($t3)
	sw $t1, 3596($t3)
	sw $t1, 3600($t3)
	
	add $t3, $t3, 24
	jr $ra
	
J:
	li $t1, 0x00ffffff
	
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 528($t3)
	sw $t1, 532($t3)
	sw $t1, 1040($t3)
	sw $t1, 1552($t3)
	sw $t1, 2064($t3)
	sw $t1, 2564($t3)
	sw $t1, 2576($t3)
	sw $t1, 3076($t3)
	sw $t1, 3088($t3)
	sw $t1, 3592($t3)
	sw $t1, 3596($t3)
	
	add $t3, $t3, 24
	jr $ra
	
U:
	li $t1, 0x00ffffff
	
	sw $t1, 516($t3)
	sw $t1, 532($t3)
	sw $t1, 1028($t3)
	sw $t1, 1044($t3)
	sw $t1, 1540($t3)
	sw $t1, 1556($t3)
	sw $t1, 2052($t3)
	sw $t1, 2068($t3)
	sw $t1, 2564($t3)
	sw $t1, 2580($t3)
	sw $t1, 3076($t3)
	sw $t1, 3092($t3)
	sw $t1, 3592($t3)
	sw $t1, 3596($t3)
	sw $t1, 3600($t3)
	
	add $t3, $t3, 24
	jr $ra
	
M:
	li $t1, 0x00ffffff
	
	sw $t1, 516($t3)
	sw $t1, 532($t3)
	sw $t1, 1028($t3)
	sw $t1, 1032($t3)
	sw $t1, 1040($t3)
	sw $t1, 1044($t3)
	sw $t1, 1540($t3)
	sw $t1, 1548($t3)
	sw $t1, 1556($t3)
	sw $t1, 2052($t3)
	sw $t1, 2060($t3)
	sw $t1, 2068($t3)
	sw $t1, 2564($t3)
	sw $t1, 2580($t3)
	sw $t1, 3076($t3)
	sw $t1, 3092($t3)
	sw $t1, 3588($t3)
	sw $t1, 3604($t3)
	
	add $t3, $t3, 24
	jr $ra
	
scolon: 
	li $t1, 0x00ffffff
	
	sw $t1, 1028($t3)
	sw $t1, 3076($t3)
	
	add $t3, $t3, 8
	jr $ra

D:
	li $t1, 0x00ffffff
	
	sw $t1, 516($t3)
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 528($t3)
	sw $t1, 1028($t3)
	sw $t1, 1044($t3)
	sw $t1, 1540($t3)
	sw $t1, 1556($t3)
	sw $t1, 2052($t3)
	sw $t1, 2068($t3)
	sw $t1, 2564($t3)
	sw $t1, 2580($t3)
	sw $t1, 3076($t3)
	sw $t1, 3092($t3)
	sw $t1, 3588($t3)
	sw $t1, 3592($t3)
	sw $t1, 3596($t3)
	sw $t1, 3600($t3)
	
	add $t3, $t3, 24
	jr $ra
	
G:
	li $t1, 0x00ffffff
	
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 528($t3)
	sw $t1, 1028($t3)
	sw $t1, 1044($t3)
	sw $t1, 1540($t3)
	sw $t1, 2052($t3)
	sw $t1, 2564($t3)
	sw $t1, 2576($t3)
	sw $t1, 2580($t3)
	sw $t1, 3076($t3)
	sw $t1, 3092($t3)
	sw $t1, 3592($t3)
	sw $t1, 3596($t3)
	sw $t1, 3600($t3)
	
	add $t3, $t3, 24
	jr $ra
	
X:
	li $t1, 0x00ffffff
	
	sw $t1, 516($t3)
	sw $t1, 532($t3)
	sw $t1, 1028($t3)
	sw $t1, 1044($t3)
	sw $t1, 1544($t3)
	sw $t1, 1552($t3)
	sw $t1, 2060($t3)
	sw $t1, 2568($t3)
	sw $t1, 2576($t3)
	sw $t1, 3076($t3)
	sw $t1, 3092($t3)
	sw $t1, 3588($t3)
	sw $t1, 3604($t3)
	
	add $t3, $t3, 24
	jr $ra
	
I:
	li $t1, 0x00ffffff
	
	sw $t1, 516($t3)
	sw $t1, 520($t3)
	sw $t1, 524($t3)
	sw $t1, 1032($t3)
	sw $t1, 1544($t3)
	sw $t1, 2056($t3)
	sw $t1, 2568($t3)
	sw $t1, 3080($t3)
	sw $t1, 3588($t3)
	sw $t1, 3592($t3)
	sw $t1, 3596($t3)
	
	add $t3, $t3, 16
	jr $ra
