.data


.text

.globl printScreen

printScreen:

	sw $ra, 200($sp)
	
	lw $t3, 0xffff0004
	
	la $t0, -40000($sp) # load the location in stack we will put the pixels (for fillBack)
	li $s1, 0 #fillback counter
	
	jal fillBack
	
	la $t0, -40000($sp) # load the stack address for the rest
	
	lw $t4, 100($sp) # move the cloud location to the left (this was the first thing i did, so its a bit messier than later functions)
	sub $t4, $t4, 1
	sw $t4, 100($sp)
	
	
	jal drawCloud
	
	jal drawGuy
	
	jal refreshSpikes
	
	jal drawPixels
	
	lw $ra, 200($sp)
	jr $ra
	
fillBack:
	sw $ra, 204($sp)
	
	bgt $s1, 7423, fillGround
	
	li $t2, 0x00B3E7FF #set t2 to light blue
	sw $t2, 0($t0) # insert sky color into stack
	add $t0, $t0, 4
	
	
	add $s1, $s1, 1
	blt $s1, 8192, fillBack
	
fillGround:

	li $t2, 0x0037A200 #set t2 to ground
	sw $t2, 0($t0) # load ground color into stack
	add $t0, $t0, 4
	add $s1, $s1, 1
	blt $s1, 8192, fillBack
	
	
	lw $ra, 204($sp)
	jr $ra
	
	

	
drawCloud:
	sw $ra, 204($sp)
	
	la $t0, -40000($sp)
	lw $s3, 112($sp) # height
	li $s2, 0 # y offset
	
	jal cloudStack
	
	lw $ra, 204($sp)
	jr $ra
	
cloudStack:
	sw $ra, 208($sp)
	j cloudStackLoop
cloudStackLoop:

	
	li $s1, 0 # x offset
	jal cloudLine
	
	add $s2, $s2, 1
	blt $s2, $s3, cloudStackLoop
	
	lw $ra, 208($sp)
	jr $ra
# cloudline draws the cloud in a series of lines
cloudLine:

	lw $t4, 100($sp) #load x coord of cloud
	lw $t5, 104($sp) #load y
	lw $t6, 108($sp) #load length
	
	# convert X and Y and length to a stack/pixel location 
	add $t4, $t4, $s1
	add $t4, $t4, $s2
	sub $t5, $t5, $s2
	sub $t6, $t6, $s2
	sub $t6, $t6, $s2
	sub $t6, $t6, $s2
	
	sub $t5, $t5, 1 #calc pixel num
	mul $t5, $t5, 4
	mul $t4, $t4, 4
	mul $t5, $t5, 128
	add $t8, $t5, $t4
	
	li $t2, 0x00EDFAFC #load color white
	
	add $t0, $t0, $t8
	sw $t2, 0($t0) # insert color white
	
	add $s1, $s1, 1
	
	
	la $t0, -40000($sp)
	
	blt $s1, $t6, cloudLine
	
	jr $ra
	
drawGuy:
	sw $ra, 204($sp)
	
	#la $t0, 0x10010000 #load base display
	la $t0, -40000($sp)
	lw $t4, 1000($sp) #load x
	lw $t5, 1004($sp) #load y
	
	sub $t5, $t5, 1 #calc pixel num
	mul $t5, $t5, 4
	mul $t4, $t4, 4
	mul $t5, $t5, 128
	add $t8, $t5, $t4
	
	li $t2, 0x00000000 #load color black
	
	add $t0, $t0, $t8 # get address of pixel
	
	lw $t3, 1016($sp) #load frame num
	
	
	# check what frame we are on, and choose to draw the appropriate one
	beq $t3, 1, frameOne
	beq $t3, 2, frameTwo
	beq $t3, 3, frameOne
	beq $t3, 4, frameThree
	
	beq $t3, 11, frameDodgeOne
	beq $t3, 12, frameDodgeTwo
	
	j frameTwo
		
frameOne: #pushing up
	
	sw $t2, 8($t0) #change foot color
	sw $t2, 12($t0) #change foot color
	sw $t2, -504($t0) #change foot color
	sw $t2, -512($t0) #change leg color
	sw $t2, -516($t0) #change leg color
	sw $t2, -520($t0) #change leg color
	sw $t2, -1016($t0) #change leg color
	sw $t2, -1024($t0) #change leg color
	sw $t2, -1532($t0) #change leg color
	sw $t2, -1536($t0) #change hip color
	sw $t2, -2036($t0) #change arm color
	sw $t2, -2040($t0) #change arm color
	sw $t2, -2048($t0) #change body color
	sw $t2, -2052($t0) #change arm color
	sw $t2, -2556($t0) #change body color
	sw $t2, -2564($t0) #change arm color
	sw $t2, -3068($t0) #change body color
	sw $t2, -3072($t0) #change arm color
	sw $t2, -3572($t0) #change head color
	sw $t2, -3576($t0) #change head color
	sw $t2, -4084($t0) #change head color
	sw $t2, -4088($t0) #change head color
	
	lw $t3, 1016($sp)
	add $t3, $t3, 1
	sw $t3, 1016($sp) #set frame num
	
	lw $ra, 204($sp)
	jr $ra

frameTwo: #mid air

	sw $t2, -1012($t0) #change foot color
	sw $t2, -1008($t0) #change foot color
	sw $t2, -1524($t0) #change leg color
	sw $t2, -1536($t0) #change leg color
	sw $t2, -1540($t0) #change leg color
	sw $t2, -1544($t0) #change leg color
	sw $t2, -2036($t0) #change leg color
	sw $t2, -2040($t0) #change leg color
	sw $t2, -2044($t0) #change leg color
	sw $t2, -2048($t0) #change leg color
	sw $t2, -2056($t0) #change foot color
	sw $t2, -2060($t0) #change foot color
	sw $t2, -2560($t0) #change body color
	sw $t2, -3060($t0) #change arm color
	sw $t2, -3064($t0) #change arm color
	sw $t2, -3068($t0) #change arm color
	sw $t2, -3080($t0) #change hand color
	sw $t2, -3568($t0) #change hand color
	sw $t2, -3580($t0) #change arm color
	sw $t2, -3584($t0) #change arm color
	sw $t2, -3588($t0) #change arm color
	sw $t2, -4088($t0) #change head color
	sw $t2, -4084($t0) #change head color
	sw $t2, -4596($t0) #change head color
	sw $t2, -4600($t0) #change head color
	

	
	li $t2, 3
	sw $t2, 1016($sp) #set frame num
	
	lw $ra, 204($sp)
	jr $ra
	

frameThree: #lowest point

	sw $t2, 0($t0) #change foot color
	sw $t2, -4($t0) #change foot color
	sw $t2, -512($t0) #change leg color
	sw $t2, -1024($t0) #change leg color
	sw $t2, -508($t0) #change leg color
	sw $t2, -1536($t0) #change body color
	sw $t2, -2048($t0) #change body color
	sw $t2, -2556($t0) #change body color
	sw $t2, -3068($t0) #change neck color
	sw $t2, -3572($t0) #change head color
	sw $t2, -3576($t0) #change head color
	sw $t2, -4084($t0) #change head color
	sw $t2, -4088($t0) #change head color
	
	li $t2, 1
	sw $t2, 1016($sp) #set frame num
	
	lw $ra, 204($sp)
	jr $ra
# start dodge frame
frameDodgeOne:

	sw $t2, 16($t0) #change foot color
	sw $t2, 4($t0) #change leg color
	sw $t2, 0($t0) #change leg color
	sw $t2, -4($t0) #change foot color
	sw $t2, -500($t0) #change leg color
	sw $t2, -504($t0) #change leg color
	sw $t2, -508($t0) #change leg color
	sw $t2, -1024($t0) #change body color
	sw $t2, -1032($t0) #change hand color
	sw $t2, -1524($t0) #change arm color
	sw $t2, -1528($t0) #change arm color
	sw $t2, -1536($t0) #change body color
	sw $t2, -1544($t0) #change arm color
	sw $t2, -2044($t0) #change arm color
	sw $t2, -2048($t0) #change body color
	sw $t2, -2052($t0) #change arm color
	sw $t2, -2556($t0) #change head color
	sw $t2, -2560($t0) #change head color
	sw $t2, -3068($t0) #change head color
	sw $t2, -3072($t0) #change head color
	
	
	lw $ra, 204($sp)
	jr $ra
#mid dodge frame
frameDodgeTwo:

	sw $t2, 20($t0) #change foot color
	sw $t2, 8($t0) #change leg color
	sw $t2, 4($t0) #change body color
	sw $t2, 0($t0) #change body color
	sw $t2, -4($t0) #change body color
	sw $t2, -12($t0) #change hand color
	sw $t2, -496($t0) #change leg color
	sw $t2, -500($t0) #change leg color
	sw $t2, -504($t0) #change leg color
	sw $t2, -512($t0) #change arm color
	sw $t2, -516($t0) #change neck color
	sw $t2, -520($t0) #change arm color
	sw $t2, -524($t0) #change arm color
	sw $t2, -1028($t0) #change head color
	sw $t2, -1032($t0) #change head color
	sw $t2, -1540($t0) #change head color
	sw $t2, -1544($t0) #change head color
	
	lw $ra, 204($sp)
	jr $ra
	
refreshSpikes: # loops through active spikes
	sw $ra, 212($sp) 
	#lw $s1, 1200($sp) # load X coord
	li $s2, 0 # set counter
	rfSpikesLoop:
		add $sp, $sp, $s2
		lw $s3, 1200($sp) #get x coord at $sp + counter
		sub $sp, $sp, $s2
		
		bgtz $s3, drawObs
			
		skipSpike:
		add $s2, $s2, 4 #increment counter to next spike coords
		ble $s2, 28, rfSpikesLoop
		lw $ra, 212($sp)
		jr $ra
# draw obstacle	
drawObs:
	add $sp, $sp, $s2
	lw $t4, 1300($sp) #get type (spike or colomn)
	sub $sp, $sp, $s2
	
	beq $t4, 1, drawSpike
	beq $t4, 2, drawOverhead
	j skipSpike

	

drawSpike:
	#sw $ra, 204($sp)
	add $sp, $sp, $s2
	lw $t4, 1200($sp) #get x coord
	sub $sp, $sp, $s2
	
	mul $t4, $t4, 4
	#la $t0, 0x10010000 #load base display
	la $t0, -40000($sp)
	
	add $t0, $t0, 29180 # set pixel address
	add $t0, $t0, $t4
	li $t2, 0x00757575 # load color black
	lw $t1, 1108($sp) # load column height
	sub $t1, $t1, 1
	lw $t6, 1104($sp) # load spike width
	li $t5, 0 # load length counter
	
	jal preColumnLoop
	
	j skipSpike
	
	preColumnLoop:
		sw $ra, 208($sp)
	columnLoop:
	
		li $t3, 0 # load height counter
		jal spikeColumnUp
		
		add $t0, $t0, 4 # add X increment
		add $t5, $t5, 1 # add length increment
		li $t4, 5 # load column height
		add $t1, $t1, $t4 # add to current height
		div $t4, $t6, 2 # halve the length
		blt $t5, $t4, columnLoop
	
	columnLoopDown:
		li $t3, 0 # load height counter
		jal spikeColumnUp
		add $t0, $t0, 4 # add X increment
		add $t5, $t5, 1 # add length increment
		li $t4, 5 # load column height
		sub $t1, $t1, $t4 # sub from current height
		blt $t5, $t6, columnLoopDown
		
		lw $ra, 208($sp)
		jr $ra
	
	spikeColumnUp:
		
		mul $t8, $t3, 512 # convert vertical to address offset
		sub $t8, $t0, $t8 # set address of pixel
		sw $t2, ($t8) # set pixel color
		add $t3, $t3, 1 # increment height
		blt $t3, $t1, spikeColumnUp	
		
		
		
		jr $ra
	

drawOverhead:

	add $sp, $sp, $s2
	lw $t4, 1200($sp) #get x coord
	sub $sp, $sp, $s2
	
	mul $t4, $t4, 4
	#la $t0, 0x10010000 #load base display
	la $t0, -40000($sp)
	
	add $t0, $t0, 26620 # set pixel address
	add $t0, $t0, $t4
	li $t2, 0x00757575 # load color grey
	sub $t1, $t1, 1
	lw $t6, 1104($sp) # load ovrHead width
	li $t5, 0 # load width counter
	
	jal preOvrCLoop
	
	j skipSpike
	
# draw column as a series of lines
	preOvrCLoop:
		sw $ra, 208($sp)
	ovrRLoop:
		li $t3, 0 # load height counter
		jal ovrCLoop
		add $t0, $t0, 4
		
		add $t5, $t5, 1
		blt $t5, $t6, ovrRLoop
		
		lw $ra, 208($sp)
		jr $ra
		
	ovrCLoop:
		
		mul $t8, $t3, 512 # convert vertical to address offset
		sub $t8, $t0, $t8 # set address of pixel
		sw $t2, ($t8) # set pixel color
		add $t3, $t3, 1
		blt $t3, 54, ovrCLoop
	
		jr $ra
# copy the colors we put in the stack onto the display address.  This prevents flickering	
drawPixels:
	sw $ra, 204($sp)

	la $t1, 0x10010000 #load base display addr
	la $t0, -40000($sp)
	li $s2, 0
	
drawPixelRows:
	li $s1, 0
	add $s2, $s2, 1
	# draw them in vertical lines, to prevent screen tearing
	jal drawPixelColumns
	sub $t1, $t1, 32764
	sub $t0, $t0, 32764
	
    	
	blt $s2, 128, drawPixelRows
	
	lw $ra 204($sp)
	jr $ra

drawPixelColumns:
	
	lw $t2, ($t0)
	sw $t2, ($t1)
	add $t0, $t0, 512
	add $t1, $t1, 512
	add $s1, $s1, 1
	blt $s1, 64, drawPixelColumns
	
	jr $ra
