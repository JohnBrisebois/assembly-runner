.data

.text

.globl generate
.globl refreshDelay
.globl deathReset

generate:

	sw $ra, 300($sp)

	li $t4, 40
	sw $t4, 100($sp) # cloud x
	sw $t4, 104($sp) # y
	sw $t4, 108($sp) # length
	div $t4, $t4, 4
	sw $t4, 112($sp) # height
	
	li $t4, 1
	sw $t4, 1016($sp) #load frame num
	
	li $t4, 0
	sw $t4, 408($sp) # set frame counter to 0 (for difficulty level)
	sw $t4, 404($sp) # set frame counter to 0 (since last spike)
	
	li $t4, 15 # set X and Y of player
	sw $t4, 1000($sp)
	li $t4, 58
	sw $t4, 1004($sp)
	
	# set start difficulty (higher easier)
	li $t4, 20
	sw $t4, 700($sp)
	
	j refresh

	lw $ra, 300($sp)
	jr $ra

refresh:
	# jumping check
	lw $t4, 0xffff0004 # load key pressed
	lw $t3, 1032($sp) # load jump state
	beq $t3, 1, jumpUp
	beq $t3, 2, jumpDown
	beq $t4, 32, jumpStart
	jumpElse:
	
	# dodge check
	lw $t4, 0xffff0004 # load key pressed
	lw $t3, 1040($sp) # load dodge state
	beq $t3, 1, dodgeCont
	beq $t4, 115, dodgeStart
	dodgeElse:
	
	# menu check
	lw $t4, 0xffff0004 # load key pressed
	beq $t4, 27, escMenu
	
	jal printScreen
	
	# obstacle check
	
	
	jal genObstacle
	
	jal updateObstacle
	
	jal checkCollision
	
	# refresh display
	
	jal refreshDelay
	
	j refresh
	
# loop through a long operation to delay between frames
refreshDelay:

	lw $t4, 704($sp)
	li $t3, 0
	delayLoop:
	add $t3, $t3, 1
	blt, $t3, $t4, delayLoop
	
	jr $ra
	

jumpStart:
	
	lw $t3, 1040($sp) # load dodge state
	li $t4, 0
	sw $t4, 1040($sp) # set dodge state to 0
	
	li $t3, 1
	sw $t3, 1032($sp) # set jump state to 1
	li $t3, 16
	sw $t3, 1036($sp) # set jump counter
	

	j jumpUp
	
	
	jumpUp:
		lw $t4, 1004($sp) # get Y
		lw $t3, 1036($sp) # get jump counter
		sub $t4, $t4, $t3 #increment Y
		sw $t4, 1004($sp)
		
		div $t3, $t3, 2
		sw $t3, 1036($sp) # increment jump counter
	
		li $t2, 2
		sw $t2, 1016($sp) # freeze frame
	
		bgt $t3, 1, jumpElse
	
		li $t3, 2
		sw $t3, 1032($sp) # set jump state
		sw $t3, 1036($sp) # set jump counter
		
		j jumpElse

	jumpDown:
	
		lw $t4, 1004($sp) # get Y
		lw $t3, 1036($sp) # get jump counter
		add $t4, $t4, $t3 #increment Y
		sw $t4, 1004($sp)
			
		li $t2, 2
		sw $t2, 1016($sp) # freeze frame
		
		mul $t3, $t3, 2
		sw $t3, 1036($sp) # increment jump counter
		ble $t3, 16, jumpElse
	
		li $t3, 0
		sw $t3, 1032($sp) # set jump state
	
		li $t3, 0
		sw $t3, 0xffff0004 # load key pressed
	

		j jumpElse
		
genObstacle:
	sw $ra, 200($sp)
	
	lw $t4, 400($sp) # increment frame counter for seed
	add $t4, $t4, 1
	sw $t4, 400($sp)
	
	lw $t3, 404($sp) # increment frame counter since last spike
	add $t3, $t3, 1
	sw $t3, 404($sp)
	
	lw $t4, 408($sp) # increment frame counter for difficulty
	add $t4, $t4, 1
	sw $t4, 408($sp)
	
	li $a0, 1 # set seed
	move $a1, $t4
	li $v0, 40
	syscall
	
	jal setDifficulty
	
	lw $a1, 700($sp) # get skill level (higher = easier)
	
	li $a0, 1 # generate rand num from seed
	li $v0, 42
	syscall
	
	ble $t3, 5, skipOver # if less than 30 frames passed, skip
	
	bne $a0, 1, skipGen # if the random num isnt 1, skip
	
		jal addObstacle
	
	skipGen:
	
	bne $a0, 2, skipOver # if the random num isnt 2, skip overhead
	
		jal addObstacle
	
	skipOver:
	
	
	lw $ra, 200($sp)
	jr $ra

setDifficulty:

	lw $t4, 408($sp)
	
	move  $a0, $t4
	li $v0, 1
    	syscall
    	
	blt $t4, 200, skipDiff
	
	li $t4, 0
	sw $t4, 408($sp) # reset counter
	
	lw $t4, 700($sp)
	
	ble $t4, 5, skipDiff
	
	sub $t4, $t4, 5
	sw $t4, 700($sp)
	
	skipDiff:
	jr $ra
	
addObstacle:

	li $t4, 0
	sw $t4, 404($sp) # frames since last spike: 0
	
	lw $t4, 1100($sp) #get number of spikes
	add $t4, $t4, 4
	sw $t4, 1100($sp) # add one
	
	li $t4, 7 # set spike width
	sw $t4, 1104($sp)
	li $t4, 5 # set spike height
	sw $t4, 1108($sp)
	
	li $t9, 124 #set new X coord
	
	lw $t1, 1200($sp) # move spikes X up thru stack.  this lets us keep track of whats on the screen and what's "garbage"
	lw $t2, 1204($sp)
	lw $t3, 1208($sp)
	lw $t4, 1212($sp)
	lw $t5, 1216($sp)
	lw $t6, 1220($sp)
	lw $t7, 1224($sp)
	lw $t8, 1228($sp)
	
	sw $t1, 1204($sp)
	sw $t2, 1208($sp)
	sw $t3, 1212($sp)
	sw $t4, 1216($sp)
	sw $t5, 1220($sp)
	sw $t6, 1224($sp)
	sw $t7, 1228($sp)
	
	lw $t1, 1300($sp) # move spikes type up thru stack
	lw $t2, 1304($sp)
	lw $t3, 1308($sp)
	lw $t4, 1312($sp)
	lw $t5, 1316($sp)
	lw $t6, 1320($sp)
	lw $t7, 1324($sp)
	lw $t8, 1328($sp)
		
	sw $t1, 1304($sp)
	sw $t2, 1308($sp)
	sw $t3, 1312($sp)
	sw $t4, 1316($sp)
	sw $t5, 1320($sp)
	sw $t6, 1324($sp)
	sw $t7, 1328($sp)
	
	sw $t9, 1200($sp)
	sw $a0, 1300($sp)
	
	
	jr $ra
	
updateObstacle:
	li $s2, 0
uObsLoop:
	add $sp, $sp, $s2 # go to index of spike coord
	
	lw $t4, 1200($sp) # load spikes x
	sub $t4, $t4, 4 # move to the left
	sw $t4, 1200($sp)
	bgt $t4, 0, skipObs # if the spikes X is greater than 0, skip these commands
	
	li $t4, 0
	sw $t4, 1200($sp) # set X to 0
	 
	skipObs:
	sub $sp, $sp, $s2
	add $s2, $s2, 4
	ble $s2, 28, uObsLoop
	
	jr $ra
	
checkCollision:
	sw $ra, 204($sp)
	li $s2, 0
# loop through spikes and check collision
cCLoop:
	add $sp, $sp, $s2
	lw $t4, 1200($sp) # load obstacle x
	lw $t7, 1300($sp) # load obstacle type
	sub $sp, $sp, $s2
	lw $t5, 1000($sp) # load player x
	
	# make obstacle collision at the center (since X is leftmost side)
	add $t4, $t4, 3
	
	sub $t6, $t4, $t5 #compare coords
	
	bgtu $t6, 2, skipDeath # if no spike at our X, skip
	
	beq $t7, 2, cOLoop # if type is 2 (overhead) continue in overhead loop
	
	lw $t4, 1108($sp) # load spike height
	lw $t5, 1104($sp) # load spike width
	lw $t6, 1004($sp) # load player y
	
	div $t5, $t5, 2
	add $t5, $t5, 1
	mul $t4, $t5, $t4
	
	add $t4, $t4, 5 # account for ground
	li $t5, 64
	subu $t4, $t5, $t4 # subtract from top of screen (top is y coord 0)
	
	bltu $t6, $t4, skipDeath # if we are above the spike at our X, skip
	
	# death :(
    	j deathReset
	
	skipDeath:
	
	add $s2, $s2, 4
	ble $s2, 28, cCLoop
	
	lw $ra, 204($sp)
	jr $ra

# overhead columns check collision
cOLoop:

	lw $t6, 1004($sp) # load player y
	lw $t3, 1040($sp) # load dodge state
	
	# if we are jumping, death
	blt $t6, 58, oDeath
	
	# if we are dodging, no death :)
	beq $t3, 1, skipODeath
	
	oDeath: # death :(
	j deathReset
	
	skipODeath:
	
	# cycle obstacle and continue loop
	add $s2, $s2, 4
	ble $s2, 28, cCLoop
	
	lw $ra, 204($sp)
	jr $ra



dodgeStart:
	li $t3, 1
	sw $t3, 1040($sp) # set dodge state to 1
	li $t3, 5
	sw $t3, 1044($sp) # set dodge counter
	
	dodgeCont:
	
	lw $t3, 1044($sp) # load dodge counter
	
	li $t2, 11
	sw $t2, 1016($sp) # freeze frame to crouch
	
	beq $t3, 5, skipFrameOne # if its the last or the first frame of the anim, dont freeze to lying
	beq $t3, 1, skipFrameOne
	
	li $t2, 12
	sw $t2, 1016($sp) # freeze frame to lying
	
	skipFrameOne:
	
	sub $t3, $t3, 1
	sw $t3, 1044($sp) # set dodge counter
	
	bge, $t3, 0, dodgeElse
	
	li $t2, 1
	sw $t2, 1016($sp) # unfreeze frames
	
	li $t3, 0
	sw $t3, 0xffff0004 # load key pressed
	
	li $t3, 0
	sw $t3, 1040($sp) # set dodge state to 0
	
	j dodgeElse

# death function
deathReset:
	# multiply the frame delay by 10, so we dont instantly go to menu
	lw $t4, 704($sp)
	mul $t4, $t4, 10
	sw $t4, 704($sp)
	jal refreshDelay
	
	escMenu:
	jal resetStack
	
	sub $sp, $sp, 5000
	j main
# reset the stack.  this is a bit hacky but i noticed some functions assumed 0 on stack and some things were messed up on restart
resetStack:
	li $t1, 0
	resetLoop:
	sw $t1, ($sp)
	add $sp, $sp, 4
	add $t1, $t1, 4
	blt $t1, 2000, resetLoop
	
	jr $ra
