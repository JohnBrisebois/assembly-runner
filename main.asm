.data 


.text

.globl main
.globl exit

main:
	
	
	###############################################################
	#     ADJUST $t4 IF THE GAME IS RUNNING TOO SLOW OR FAST      #
	#               $t4 IS THE TIME BETWEEN FRAMES                #
	#                       HIGHER = SLOWER                       #
	###############################################################
	li $t4, 50000 # <<<<---- ADJUST AS NEEDED
	sw $t4, 704($sp)
	
	jal menu

	jal generate
	
exit:
	li $v0, 10
    	syscall
