#=================================================================
# Copyright 2022 Georgia Tech.  All rights reserved.
# The materials provided by the instructor in this course are for
# the use of the students currently enrolled in the course.
# Copyrighted course materials may not be further disseminated.
# This file must not be made publicly available anywhere.
# =================================================================
#     F i n d  T u m b l i n g G e o r g e  i n  a  C r o w d
#
# P1-2
# Student Name: Puneet Bansal
# Date: 2/22/22
#
# This routine finds an exact match of George's face which may be
# rotated in a crowd of tumbling (rotated) faces.
#
#===========================================================================
# CHANGE LOG: brief description of changes made from P1-2-shell.asm
# to this version of code.
# Date  Modification
# 02/22 Looping through pixels, check where the shirt is
# 02/23 If the shirt is found, and the face is 0 deg check if the face is valid
# 02/26 Wrote code for 90 degree rotation and 180 degree
# 02/27 Wrote code for the 270 degree rotation 
# 02/27 Wrote code to check the face to ensure that it is george (FindFeatures label)
# 03/01 Wrote code to ensure code doesnt go out of bounds
# 03/02 Wrote code to properly add values to register 2
#===========================================================================

.data
Array:  .alloc	1024

.text

FindGeorge:	addi	$1, $0, Array			# point to array base
		swi	570								# generate tumbling crowd
		addi $10, $0, 128 					# $10 is the counter and pointer to array 
		add $1, $1, $10     				# moves array to start of register 10 count
		addi $23, $0, 3						# $23 = blue
		addi $22, $0, 5						# $22 = yellow
		addi $21, $0, 2      				# $21 = red
		addi $20, $0, 8						# $20 = black
		addi $19, $0, 7						# $19 = green
		addi $18, $0, 1						# $18 = white
		add $15, $31, $0					# stores exit address
		addi $2, $0, Array					# stores start of memory address
Loop: 	lbu  $4, 0($1) 						# $4 is the pixel that it is currently checking
		bne  $4, $18 Then 					# if the pixel is not equal to white jump to then:
											# 0 degree code:
		addi $4,$1,-126						# adds the furthest change of pixels upward to 4
		slti $3, $4, Array 					# is $4 < array address
		bne $3, $0, Else1					# upper bounds checker
		addi $4,$1, 578						# adds the furthest change of pixels downward to 4
		addi $3, $2, 4096					# makes array address to max
		slt $3, $4, $3						# is $4 < $3
		beq $3, $0, Else1					# lower bounds checker
		lbu  $4, 128($1)					# grabs pixel two rows below white pixel
		beq $4, $19, green 					# check if pixel is green 2 rows below white pixel
		bne $4, $22, Else1					# check if pixel is yellow 2 rows below white pixel
		lbu $4, 384($1)						# grab pixel down 6 rows
		beq $4, $20, Go    					# check if pixel is black
		lbu  $4, 2($1)						# if its not black, grab pixel over 2 right
		beq $4, $21, Go2					# check if pixel is red
		addi $4, $1, -1						# Move $6 to corner white pixel
		j move								# jump to move label
Go:     addi $4, $1, -2						# Move $6 to corner white pixel
		j move								# jump to move label
Go2: 	addi $4, $1, -3						# Move $6 to corner white pixel
		j move								# jump to move label
green:  lbu  $4, 1($1)						# grab pixel one over to the right
		beq $4, $21, Go3  					# Check if the pixel is red
		addi $4, $1, 0 						# moves $6 to corner
		j move								# corner found, move to checking face
Go3: 	addi $4, $1, -4						# you are at the other corner
move: 	lbu  $25, 256($4) 					# Check for dimple (black) 					
		lbu  $26, 128($4)					# Check for eye (green) 					
		lbu  $27, 129($4)					# check for sunglasses (not green)				
		lbu  $28,  576($4)					# check for blue shirt (blue)					
		lbu  $16, -64($4)					# check for hat (red)
		lbu  $3, 192($4)					# check for yellow
		addi $24, $0, 0						# boolean value of found
		jal FindFeatures 					# jump to check features
		beq $24, $0, Then					# if face is found
		sub $4, $4, $2						# grab the offset of memory address and actual location in array
		addi $2, $4, -126					# gets the hat top point
		sll $2, $2, 16						# adds the value to register 2
		addi $4, $4, 578					# gets the bottom shirt value 
		or $2, $2, $4						# add the shirt value to the $2
		j Test  							# exit if the face is found
											# 90 degree code:
Else1: 	addi $4,$1,-256     				# adds the furthest change of pixels upward to 4
		slti $3, $4, Array 					# is $4 < array address
		bne $3, $0, Else2					# upper bounds checker
		addi $4,$1, 130						# adds the furthest change of pixels downward to 4
		addi $3, $2, 4096					# makes array address to max	
		slt $3, $4, $3						# is $4 < $3
		beq $3, $0, Else2					# lower bounds checker
		lbu  $4, -2($1)						# grabs pixel two colmuns to the left
		beq $4, $19, green2 				# check if pixel is green 2 rows below white pixel
		bne $4, $22, Else2					# check if pixel is yellow 2 rows below white pixel
		lbu $4, -6($1)						# grab pixel down 6 rows
		beq $4, $20, Go4    				# check if pixel is black
		lbu  $4, 128($1)					# if not black move over 2 to the right
		beq $4, $21, Go5					# check if its red
		addi $4, $1, -64					# Move $6 to corner white pixel
		j move2								# jump to move2 label
Go4:     addi $4, $1, -128					# Move $6 to corner white pixel
		j move2								# jump to move2 label
Go5: 	addi $4, $1, -192					# Move $6 to corner white pixel
		j move2								# jump to move3 label
green2: lbu $4, -64($1) 					# moves pixel over by 1
		beq $4, $21, Go6  					# Check if the pixel is red
		addi $4, $1, -256 					# moves $6 to corner
		j move2								# corner found, move to checking face
Go6: 	addi $4, $1, 0						# you are at the other corner
move2: 	lbu  $25, -4($4) 					# Check for dimple (black) 					
		lbu  $26, -2($4)					# Check for eye (green) 					
		lbu  $27, 62($4)					# check for sunglasses (not green)				
		lbu  $28,  -9($4)					# check for blue shirt (blue)					
		lbu  $16, 1($4)					    # check for hat (red)
		lbu  $3, -3($4)					    # check for yellow
		addi $24, $0, 0						# boolean value of found
		jal FindFeatures 					# jump to check features
		beq $24, $0, Then					# if face is found
		sub $4, $4, $2						# grab the offset of memory address and actual location in array
		addi $2, $4, 130  					# gets the hat top point
		sll $2, $2, 16						# adds the value to register 2
		addi $4, $4, 119					# gets the bottom shirt value 
		or $2, $2, $4						# add the shirt value to the $2
		j Test  							# exit if the face is found
											# 180 degree code:	
Else2:  addi $4,$1,-578						# adds the furthest change of pixels upward to 4
		slti $3, $4, Array 					# is $4 < array address
		bne $3, $0, Else3					# upper bounds checker
		addi $4,$1, 126						# adds the furthest change of pixels downward to 4
		addi $3, $2, 4096					# makes array address to max
		slt $3, $4, $3						# is $4 < $3
		beq $3, $0, Else3					# lower bounds checker		
		lbu $4, -128($1)					# grabs pixel two rows below
		beq $4, $19, green3 			    # check if pixel is green 2 rows below white pixel
		bne $4, $22, Else3					# check if pixel is yellow 2 rows below white pixel
		lbu $4, -384($1)					# move pixel down 6 rows
		beq $4, $20, Go7    				# check if pixel is black					
		lbu  $4, -2($1)						# not black, move over 2
		beq $4, $21, Go8					# check if its red
		addi $4, $1, 1						# Move $6 to corner white pixel
		j move3								# jump to move3 label
Go7:     addi $4, $1, 2						# Move $6 to corner white pixel
		j move3								# jump to move3 label
Go8: 	addi $4, $1, 3						# Move $6 to corner white pixel
		j move3								# jump to move3 label
green3: lbu  $4, -1($1)						# moves pixel over by 1
		beq $4, $21, Go9  					# Check if the pixel is red
		addi $4, $1, 0 					    # moves $6 to corner
		j move3								# corner found, move to checking face
Go9: 	addi $4, $1, 4						# you are at the other corner
move3: 	lbu  $25, -256($4) 					# Check for dimple (black) 					
		lbu  $26, -128($4)					# Check for eye (green) 					
		lbu  $27, -129($4)					# check for sunglasses (not green)	
		lbu  $28,  -576($4)					# check for blue shirt (blue)					
		lbu  $16, 64($4)					# check for hat (red)
		lbu  $3, -192($4)					# check for yellow 
		addi $24, $0, 0						# boolean value of found
		jal FindFeatures 					# jump to check features
		beq $24, $0, Then					# if face is found
		sub $4, $4, $2						# grab the offset of memory address and actual location in array
		addi $2, $4, 126					# gets the hat top point
		sll $2, $2, 16						# adds the value to register 2
		addi $4, $4, -578					# gets the bottom shirt value 
		or $2, $2, $4						# add the shirt value to the $2
		j Test  							# exit if the face is found
											# 270 degree code:
Else3:  addi $4,$1,-130						# adds the furthest change of pixels upward to 4
		slti $3, $4, Array 					# is $4 < array address
		bne $3, $0, Then					# upper bounds checker
		addi $4,$1, 256						# adds the furthest change of pixels downward to 4
		addi $3, $2, 4096					# makes array address to max
		slt $3, $4, $3						# is $4 < $3
		beq $3, $0, Then					# lower bounds checker	
		lbu  $4, 2($1)						# grabs pixel two colmuns to the left
		beq $4, $19, green4 				# check if pixel is green 2 rows below white pixel
		bne $4, $22, Then					# check if pixel is yellow 2 rows below white pixel
		lbu $4, 6($1)						# move pixel down 6 rows
		beq $4, $20, Go10    				# check if black
		lbu  $4, -128($1)					# not black, move over 2
		beq $4, $21, Go11					# check if its red
		addi $4, $1, 64						# Move $6 to corner white pixel
		j move4								# jump to move4 label
Go10:     addi $4, $1, 128					# Move $6 to corner white pixel
		j move4								# jump to move4 label
Go11: 	addi $4, $1, 192					# Move $6 to corner white pixel
		j move4								# jump to move4 label
green4: lbu $4, 64($1)						# moves pixel over by 1
		beq $4, $21, Go12  					# Check if the pixel is red
		addi $4, $1, 256 					# moves $6 to corner
		j move4								# corner found, move to checking face
Go12: 	addi $4, $1, 0						# you are at the other corner
move4: 	lbu  $25, 4($4) 					# Check for dimple (black) 					
		lbu  $26, 2($4)						# Check for eye (green) 					
		lbu  $27, -62($4)					# check for sunglasses (not green)				
		lbu  $28,  9($4)					# check for blue shirt (blue)					
		lbu  $16, -1($4)					# check for hat (red)
		lbu  $3, 3($4)						# check for yellow
		addi $24, $0, 0						# boolean value of found
		jal FindFeatures 					# jump to check features
		beq $24, $0, Then					# if face is found
		sub $4, $4, $2						# grab the offset of memory address and actual location in array
		addi $2, $4, -130  					# gets the hat top point
		sll $2, $2, 16						# adds the value to register 2
		addi $4, $4, -119					# gets the bottom shirt value 
		or $2, $2, $4						# add the shirt value to the $2
		j Test  							# exit if the face is found
Then: 	addi $10, $10, 5					# increment the counter by 5
	  	addi $1, $1, 5  					# increment the array pointer by 5
	  	slti $3, $10, 3968					# check to make sure counter isnt going past limit
	  	bne $3, $0, Loop					# loop back if limit not reached
		j Test								# jump to test label if no face is found
											# Method that checks if the face is George
FindFeatures: bne $20, $25, exit			# check if pixel is black
		bne $19, $26, exit					# check if pixel is green
		beq $19, $27, exit					# check if pixel is not green
		bne $23, $28, exit					# check if pixel is blue
		bne $3, $22, exit					# check if pixel is yellow
		bne $21, $16 exit					# check if pixel is red
		addi $24, $0, 1						# face is found set $24 to 1
		exit: jr $31						# return to call
Test: 	swi	571								# submit answer and check
		jr	$15								# return to caller