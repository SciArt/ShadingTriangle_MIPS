# $s1 - amount of pixels
# $s2 - width in pixels
# $s3 - height in pixels

# VERTICLE
# [X   ][Y   ][A][R][G][B]
# 4 bytes, 4 bytes, 1 byte, 1 bytes, 1 bytes, 1 bytes
# Size of the structure: 12 bytes

# $t1 - address to 1. verticle
# $t2 - address to 2. verticle
# $t3 - address to 3. verticle


.data
# Header without first 2 bytes "BM"
header:		.space	68

# Space for 3 verticles
verticles:	.space	36

# Space for dx_b, dx_e
diff_ratio:	.space	8

# Space for color shading informations
# Very similar to the dx_b, dx_e, but not for coords
l_A_p:		.space	4
l_R_p:		.space	4
l_G_p:		.space	4
l_B_p:		.space	4
l_A_e:		.space	4
l_R_e:		.space	4
l_G_e:		.space	4
l_B_e:		.space	4

# Space for color value (left and right side of horizontal line)
c_A_p:		.space	4
c_R_p:		.space	4
c_G_p:		.space	4
c_B_p:		.space	4
c_A_e:		.space	4
c_R_e:		.space	4
c_G_e:		.space	4
c_B_e:		.space	4

# Space for current color value for current (x,y)
#c_A:		.space	1
#c_R:		.space	1
#c_G:		.space	1
#c_B:		.space	1

bitmap:		.ascii "BM"

input_file:	.asciiz	"input.bmp"
output_file:	.asciiz	"output.bmp"

prompt1:	.asciiz	"Bitmap properties:\nAmount of pixels*4: "
prompt2:	.asciiz	"\nWidth in pixels: "
prompt3:	.asciiz "\nHeight in pixels: "
error:		.asciiz "Cannot open BMP file"

prompt4:	.asciiz "\nEnter the data of the 1. verticle:\n(format: [X][Y][A][R][G][B])\n"
prompt5:	.asciiz "\nEnter the data of the 2. verticle:\n(format: [X][Y][A][R][G][B])\n"
prompt6:	.asciiz "\nEnter the data of the 3. verticle:\n(format: [X][Y][A][R][G][B])\n"

prompt_check:	.asciiz "\nObliczone:\n"

.text
.globl	main

main:
	
	# opening the bitmap file (input_file)
	li	$v0, 13
	la	$a0, input_file
	li	$a1, 0	# read flag
	li	$a2, 0	# ignore mode
	syscall
	move	$s6, $v0 # save the file descriptor
	
	bltz	$v0, fail	
	
	# reading header from bitmap (first 70 bytes)
	li	$v0, 14
	move	$a0, $s6
	la	$a1, header
	li	$a2, 2
	syscall
	
	li	$v0, 14
	move	$a0, $s6
	la	$a1, header
	li	$a2, 68
	syscall
	
	lw	$s1, header+32 # saving amount of pixels
	lw	$s2, header+16 # saving width of bitmap
	lw	$s3, header+20 # saving height of bitmap
	
	# printing bitmap properties
	
	# print amount of pixels*4
	li	$v0, 4	# print string
	la	$a0, prompt1
	syscall
	li	$v0, 1	# print int
	move	$a0, $s1
	syscall
	
	# print width of bitmap
	li	$v0, 4	# print string
	la	$a0, prompt2
	syscall
	li	$v0, 1	# print int
	move	$a0, $s2
	syscall
		
	# print height of bitmap
	li	$v0, 4	# print string
	la	$a0, prompt3
	syscall
	li	$v0, 1	# print int
	move	$a0, $s3
	syscall
	
	# allocate space for pixels' info - (A,R,G,B)
	li	$v0, 9
	move	$a0, $s1	
	syscall
	move	$s0, $v0 # save address of allocated memory
	
	# load pixels from bitmap
	
	li	$v0, 14
	move	$a0, $s6
	la	$a1, ($s0)
	move	$a2, $s1 # pixels*4 bytes
	syscall
	
	# closing file (input_file)
	li	$v0, 16
	move	$a0, $s6
	syscall

	
	# loading verticles
	
	# FIRST VERTICLE
	
	li	$v0, 4	# print string
	la	$a0, prompt4
	syscall
	
	# X
	li	$v0, 5
	syscall
	sw	$v0, verticles
	
	# Y
	li	$v0, 5
	syscall
	sw	$v0, verticles+4
	
	# A
	li	$v0, 5
	syscall
	sb	$v0, verticles+8
	
	# R
	li	$v0, 5
	syscall
	sb	$v0, verticles+9
	
	# G
	li	$v0, 5
	syscall
	sb	$v0, verticles+10
	
	# B
	li	$v0, 5
	syscall
	sb	$v0, verticles+11
	
	# SECOND VERTICLE
	
	li	$v0, 4	# print string
	la	$a0, prompt5
	syscall
	
	# X
	li	$v0, 5
	syscall
	sw	$v0, verticles+12
	
	# Y
	li	$v0, 5
	syscall
	sw	$v0, verticles+16
	
	# A
	li	$v0, 5
	syscall
	sb	$v0, verticles+20
	
	# R
	li	$v0, 5
	syscall
	sb	$v0, verticles+21
	
	# G
	li	$v0, 5
	syscall
	sb	$v0, verticles+22
	
	# B
	li	$v0, 5
	syscall
	sb	$v0, verticles+23
	
	# THIRD VERTICLE
	
	li	$v0, 4	# print string
	la	$a0, prompt6
	syscall
	
	# X
	li	$v0, 5
	syscall
	sw	$v0, verticles+24
	
	# Y
	li	$v0, 5
	syscall
	sw	$v0, verticles+28
	
	# A
	li	$v0, 5
	syscall
	sb	$v0, verticles+32
	
	# R
	li	$v0, 5
	syscall
	sb	$v0, verticles+33
	
	# G
	li	$v0, 5
	syscall
	sb	$v0, verticles+34
	
	# B
	li	$v0, 5
	syscall
	sb	$v0, verticles+35
	
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# $s1, $s2, $s3, $s6, $s0
#
# $s1 - size of data sector (pixels*4) in bytes  @@@@@ Don't need it
# $s2 - width in pixels
# $s3 - height in pixels
# $s6 - file descriptor 	but file is closed so I can use it
#
# $s0 - address of pixels data (on the heap)
#
# VERTICLE (12 bytes)
# [X   ][Y   ][A][R][G][B]
# 4 bytes, 4 bytes, 1 byte, 1 bytes, 1 bytes, 1 bytes
#
# $t1 - address to 1. verticle // after sorting it is the verticle with the lowest "y"
# $t2 - address to 2. verticle
# $t3 - address to 3. verticle // after sorting it is the verticle with the highest "y"
#
# diff_ratio (16 bytes)
# each 4 bytes 
# [dx_b] [dx_e] [dl_b] [dl_e]

# sorting verticles from lowest to highest (according to the Y axis)
sort:
	la	$t1, verticles
	la	$t2, verticles+12
	la	$t3, verticles+24
	
check_t1_t2:
	lw	$t4, 4($t1)
	lw	$t5, 4($t2)
	
	bgt	$t5, $t4, check_t1_t3	# t2 > t1 -> skip the switching t1 with t2
	move	$t0, $t1
	move	$t1, $t2
	move	$t2, $t0 
check_t1_t3:
	lw	$t4, 4($t1)
	lw	$t5, 4($t3)
	
	bgt	$t5, $t4, check_t2_t3	# t3 > t1 -> skip the switching t1 with t3
	move	$t0, $t1
	move	$t1, $t3
	move	$t3, $t0
check_t2_t3:
	lw	$t4, 4($t2)
	lw	$t5, 4($t3)

	bgt	$t5, $t4, begin_of_drawing	# t3 > t2 -> skip the switching t2 with t3
	move	$t0, $t2
	move	$t2, $t3
	move	$t3, $t0
	
begin_of_drawing:
	
	#Check sorting
	li	$v0, 1
	lw	$t0, 4($t1)
	la	$a0, ($t0)
	syscall
	
	li	$v0, 1
	lw	$t0, 4($t2)
	la	$a0, ($t0)
	syscall
	
	li	$v0, 1
	lw	$t0, 4($t3)
	la	$a0, ($t0)
	syscall
	
# $s4 - current x
# $s5 - current y
# $s6 - x_b ... x_begin, but it is more like x13
# $s7 - x_e ... x_end, but it is more like x12 or x23

# $t8 - lower of the x_b and x_e while drawing single line
# $t9 - bigger of the x_b and x_e while drawing single line

between_y1_y2:
	# If y1 == y3 -> jump to end_of_drawing
	lw	$t4, 4($t1) # y1
	lw	$t5, 4($t3) # y3
	beq	$t4, $t5, end_of_drawing
	
	# Calculating dx13 (current dx_b)
	sub	$t6, $t5, $t4	# y3 - y1
	
	lw	$t4, ($t1) # x1
	lw	$t5, ($t3) # x3
	sub	$t7, $t5, $t4	# x3 - x1
	
	sll	$t7, $t7, 16	# Shift (x3-x1) by 16 bits
	div	$t0, $t7, $t6	# (x3-x1)/(y3-y1)
	sw	$t0, diff_ratio # save calculations, dx_b	
	
	lw	$t4, ($t1) # x1
	sll	$s4, $t4, 16 # x = x1 and shifted by 16
	sll	$s6, $t4, 16 # x_b = x1 and shifted by 16
	sll	$s7, $t4, 16 # x_e = x1 and shifted by 16
	
	# @@@@@@@@@@@@@@@@@@@@ CALCULATING COLOR DIFFERENCES l_*_p, l_A_p etc @@@@@@@@@@@@@@@
	
	# We have got a (y3 - y1), so we need just (A3 - A1), (R3 - R1), (G3 - G1), (B3 - B1)
	# I am not sure if (y3 - y1) survived the dividing :(
	
	# For [A]lpha:
	
	lbu	$t4, 8($t1) # A1 - not shifted	
	lbu	$t5, 8($t3) # A3 - not shifted
		
	sub	$t7, $t5, $t4 # A3 - A1 - not shifted
		
	lw	$t4, 4($t1) # y1 - not shifted
	lw	$t5, 4($t3) # y3 - not shifted
	sub	$t6, $t5, $t4 # y3 - y1 - not shifted
	
	sll	$t7, $t7, 16 # (A3-A1) - shifted
	div	$t0, $t7, $t6 # (A3-A1)/(y3-y1) - shifted
	sw	$t0, l_A_p # shifted
	
	# For [R]ed:
	
	lbu	$t4, 9($t1) # R1 - not shifted	
	lbu	$t5, 9($t3) # R3 - not shifted
		
	sub	$t7, $t5, $t4 # R3 - R1 - not shifted
		
	lw	$t4, 4($t1) # y1 - not shifted
	lw	$t5, 4($t3) # y3 - not shifted
	sub	$t6, $t5, $t4 # y3 - y1 - not shifted
	
	sll	$t7, $t7, 16 # (R3-R1) - shifted
	div	$t0, $t7, $t6 # (R3-R1)/(y3-y1) - shifted
	sw	$t0, l_R_p # shifted
		
	# For [G]reen:
	
	lbu	$t4, 10($t1) # G1 - not shifted	
	lbu	$t5, 10($t3) # G3 - not shifted
		
	sub	$t7, $t5, $t4 # G3 - G1 - not shifted
		
	lw	$t4, 4($t1) # y1 - not shifted
	lw	$t5, 4($t3) # y3 - not shifted
	sub	$t6, $t5, $t4 # y3 - y1 - not shifted
	
	sll	$t7, $t7, 16 # (G3-G1) - shifted
	div	$t0, $t7, $t6 # (G3-G1)/(y3-y1) - shifted
	sw	$t0, l_G_p # shifted
	
	# For [B]lue:	
	
	lbu	$t4, 11($t1) # B1 - not shifted	
	lbu	$t5, 11($t3) # B3 - not shifted
		
	sub	$t7, $t5, $t4 # B3 - B1 - not shifted
		
	lw	$t4, 4($t1) # y1 - not shifted
	lw	$t5, 4($t3) # y3 - not shifted
	sub	$t6, $t5, $t4 # y3 - y1 - not shifted
	
	sll	$t7, $t7, 16 # (B3-B1) - shifted
	div	$t0, $t7, $t6 # (B3-B1)/(y3-y1) - shifted
	sw	$t0, l_B_p # shifted
	
	# @@@@@@@@@@@@@@@@@@@@ END OF CALCULATING COLOR DIFFERENCES @@@@@@@@@@@@@@@@@@@@@@@@
	# @@@@@@@@@@@@@@@@@@@ COLOR c_*_p and c_*_e 
	
	# A
	lbu	$t0, 8($t1) # A1
	sll	$t0, $t0, 16 # A1 shifted
	sw	$t0, c_A_p # store A1 shifted
	sw	$t0, c_A_e # store A1 shifted	
	
	# R
	lbu	$t0, 9($t1) # R1
	sll	$t0, $t0, 16 # R1 shifted
	sw	$t0, c_R_p # store R1 shifted
	sw	$t0, c_R_e # store R1 shifted
	
	# G
	lbu	$t0, 10($t1) # G1
	sll	$t0, $t0, 16 # G1 shifted
	sw	$t0, c_G_p # store G1 shifted
	sw	$t0, c_G_e # store G1 shifted	
	
	# B
	lbu	$t0, 11($t1) # B1
	sll	$t0, $t0, 16 # B1 shifted
	sw	$t0, c_B_p # store B1 shifted
	sw	$t0, c_B_e # store B1 shifted	
	
	# @@@@@@@@@@@@@@@@@@@ END OF COLOR c_*_p and c_*_e
	
	lw	$t4, 4($t1) # y1
	move	$s5, $t4 # y = y1
	
	# If y1 == y2 -> jump to between_y2_y3
	#lw	$t4, 4($t1) # $t4 is already setted to y1
	lw	$t5, 4($t2) # y2
	beq	$t4, $t5, between_y2_y3
	
	# Calculating dx12 (current dx_e)
	sub	$t6, $t5, $t4	# y2 - y1
	
	lw	$t4, ($t1) # x1
	lw	$t5, ($t2) # x2
	sub	$t7, $t5, $t4 # x2 - x1
	
	sll	$t7, $t7, 16	# Shift (x2 - x1) by 16 bits
	div	$t0, $t7, $t6	# (x2 - x1) / (y2 - y1)
	sw	$t0, diff_ratio+4 # save calculations, dx_e
	
	# @@@@@@@@@@@@@@@@@@@@ CALCULATING COLOR DIFFERENCES l_*_e, l_A_e etc @@@@@@@@@@@@@@@
	
	# We have got a (y2 - y1), so we need just (A3 - A1), (R3 - R1), (G3 - G1), (B3 - B1)
	# I am not sure if (y2 - y1) survived the dividing :(
	
	# For [A]lpha:
	
	lbu	$t4, 8($t1) # A1
	lbu	$t5, 8($t2) # A2
	sub	$t7, $t5, $t4	# A2 - A1
	
	lw	$t4, 4($t1) # y1
	lw	$t5, 4($t2) # y2
	sub	$t6, $t5, $t4	# y2 - y1
	
	sll	$t7, $t7, 16	# Shift (A2-A1) by 16 bits
	div	$t0, $t7, $t6	# (A2-A1)/(y2-y1)
	sw	$t0, l_A_e
	
	# For [R]ed:
	
	lbu	$t4, 9($t1) # R1
	lbu	$t5, 9($t2) # R2
	sub	$t7, $t5, $t4	# R2 - R1
	
	lw	$t4, 4($t1) # y1
	lw	$t5, 4($t2) # y2
	sub	$t6, $t5, $t4	# y2 - y1
	
	sll	$t7, $t7, 16	# Shift (R2-R1) by 16 bits
	div	$t0, $t7, $t6	# (R2-R1)/(y2-y1)
	sw	$t0, l_R_e
	
	# For [G]reen:
	
	lbu	$t4, 10($t1) # G1
	lbu	$t5, 10($t2) # G2
	sub	$t7, $t5, $t4	# G2 - G1
	
	lw	$t4, 4($t1) # y1
	lw	$t5, 4($t2) # y2
	sub	$t6, $t5, $t4	# y2 - y1
	
	sll	$t7, $t7, 16	# Shift (G2-G1) by 16 bits
	div	$t0, $t7, $t6	# (G2-G1)/(y2-y1)
	sw	$t0, l_G_e
	
	# For [B]lue:
	
	lbu	$t4, 11($t1) # B1
	lbu	$t5, 11($t2) # B2
	sub	$t7, $t5, $t4	# B2 - B1
	
	lw	$t4, 4($t1) # y1
	lw	$t5, 4($t2) # y2
	sub	$t6, $t5, $t4	# y2 - y1
	
	sll	$t7, $t7, 16	# Shift (B2-B1) by 16 bits
	div	$t0, $t7, $t6	# (B2-B1)/(y2-y1)
	sw	$t0, l_B_e
	
	# @@@@@@@@@@@@@@@@@@@@ END OF CALCULATING COLOR DIFFERENCES @@@@@@@@@@@@@@@@@@@@@@@@	
	
	# x = x_b = x_e = x1 and y = y1 - it is already setted
drawing_lines_between_y1_y2:
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	
	move	$v0, $s6 # xp
	sra	$v0, $v0, 16
	
	move	$v1, $s7 # xe
	sra	$v1, $v1, 16
	
	sub	$t0, $v1, $v0 # int(x_e) - int(x_b)
	
	sll	$v0, $v0, 16 # int(xp)
	sll	$v1, $v1, 16 # int(xe)
	
	li	$t6, 1
	beqz	$t0, skip_div_xe_xb_1
	
	li	$t4, 1
	sll	$t4, $t4, 16
	div	$t6, $t4, $t0 # 1 / (x_e - x_b), it is shifted by 16 bit to the left
skip_div_xe_xb_1:
	
	# $t6 = 1 / (x_e - x_b)
	# $t8 is the lower one of the $s6 and $s7
	# $t9 is the bigger one of the $s6 and $s7
	# removing shift by shifting to the right by 16
	sra	$t8, $s6, 16
	sra	$t9, $s7, 16
	#move	$v0, $s6
	ble	$s6, $s7, skip_switch_in_y1_y2
	sra	$t8, $s7, 16
	sra	$t9, $s6, 16
	#move	$v0, $s7
	
skip_switch_in_y1_y2:
	#addi	$t8, $t8, 1
	#addi	$t9, $t9, -1
	move	$s4, $t8 # x = lower of the x_b and x_e
	
single_line_between_y1_y2:
	# $s1 - place for pixel on heap
	mul	$s1, $s5, $s2	# y * width	
	add	$s1, $s1, $s4	# y * width + x
	sll	$s1, $s1, 2	# 4*(y*width + x)
	
	addu	$s1, $s0, $s1
	
	# Calculating color
	
	sll	$t7, $s4, 16 # Shifting 'x' by 16 bit to the left, saving in $t7
	#move	$t0, $t8
	#sll	$t0, $t0, 16
	#sub	$t7, $t7, $t8
	
	#sub	$t7, $s4, $t8 # x - int(xp)
	#sll	$t7, $t7, 16
	#add	$t7, $t7, $v0 # (x - int(xp)) + xp
	
	# A
	
	lw	$t4, c_A_p
	lw	$t5, c_A_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
	
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, ($s1)
	
	# B
	
	lw	$t4, c_B_p
	lw	$t5, c_B_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
	
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, 1($s1)
	
	# G
	lw	$t4, c_G_p
	lw	$t5, c_G_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
	
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, 2($s1)
	
	# R
				
	lw	$t4, c_R_p
	lw	$t5, c_R_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
			
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, 3($s1)
	
	
	addiu	$s4, $s4, 1 # x = x + 1
	
	# if x < bigger of the x_b and x_e
	blt	$s4, $t9, single_line_between_y1_y2
	
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	# x_b = x_b + dx13
	lw	$t0, diff_ratio
	add	$s6, $s6, $t0
	
	# x_e = x_e + dx12
	lw	$t0, diff_ratio+4
	add	$s7, $s7, $t0
	
	# @@@@@@@ CALCULATING COLORS
		
	# A
	
	lw	$t0, l_A_p
	lw	$t7, c_A_p
	add	$t7, $t7, $t0
	sw	$t7, c_A_p
	
	lw	$t0, l_A_e
	lw	$t7, c_A_e
	add	$t7, $t7, $t0
	sw	$t7, c_A_e
	
	# R
	lw	$t0, l_R_p
	lw	$t7, c_R_p
	add	$t7, $t7, $t0
	sw	$t7, c_R_p
	
	lw	$t0, l_R_e
	lw	$t7, c_R_e
	add	$t7, $t7, $t0
	sw	$t7, c_R_e
	
	# G
	
	lw	$t0, l_G_p
	lw	$t7, c_G_p
	add	$t7, $t7, $t0
	sw	$t7, c_G_p
	
	lw	$t0, l_G_e
	lw	$t7, c_G_e
	add	$t7, $t7, $t0
	sw	$t7, c_G_e
	
	# B
	
	lw	$t0, l_B_p
	lw	$t7, c_B_p
	add	$t7, $t7, $t0
	sw	$t7, c_B_p
	
	lw	$t0, l_B_e
	lw	$t7, c_B_e
	add	$t7, $t7, $t0
	sw	$t7, c_B_e
	
	# @@@@@@@ END OF CALCULATING COLORS
	
	addiu	$s5, $s5, 1 # y = y + 1
	
	# If y < y2 -> jump to "drawing_lines_between_y1_y2"
	lw	$t0, 4($t2) # y2
	blt	$s5, $t0, drawing_lines_between_y1_y2
		
	
between_y2_y3:
	# If y2 == y3 -> jump to end_of_drawing
	lw	$t4, 4($t2) # y2
	lw	$t5, 4($t3) # y3
	beq	$t4, $t5, end_of_drawing
	
	# It doesn't quite work... x_b has good value, I don't know why I've written this
	# x_b = x_b - d_x13 # I should do the same for color	
	# lw	$t0, diff_ratio
	# sub	$s6, $s6, $t0
	
	# Calculating dx23 (current dx_e)
	sub	$t6, $t5, $t4	# y3 - y2
	
	lw	$t4, ($t2) # x2
	lw	$t5, ($t3) # x3
	sub	$t7, $t5, $t4	# x3 - x2
	
	sll	$t7, $t7, 16	# Shift (x3-x2) by 16 bits
	div	$t0, $t7, $t6	# (x3-x2)/(y3-y2)
	sw	$t0, diff_ratio+4 # save calculations, dx_e
	

	sll	$s7, $t4, 16	# x_e = x2 and shifted by 16
	
	# @@@@@@@@@@@@@@@@@@@@ CALCULATING COLOR DIFFERENCES l_*_e, l_A_e etc @@@@@@@@@@@@@@@
	
	# We have got a (y3 - y2), so we need just (A3 - A1), (R3 - R1), (G3 - G1), (B3 - B1)
	# I am not sure if (y3 - y2) survived the dividing :(
	
	# For [A]lpha:
	
	lbu	$t4, 8($t2) # A2
	lbu	$t5, 8($t3) # A3
		
	sub	$t7, $t5, $t4	# A3 - A2
		
	lw	$t4, 4($t2) # y2
	lw	$t5, 4($t3) # y3
	
	sub	$t6, $t5, $t4	# y3 - y2
		
	sll	$t7, $t7, 16	# Shift (A3-A2) by 16 bits
	div	$t0, $t7, $t6	# (A3-A2)/(y3-y2)
	sw	$t0, l_A_e
	
	# For [R]ed:
	
	lbu	$t4, 9($t2) # R2
	lbu	$t5, 9($t3) # R3
		
	sub	$t7, $t5, $t4	# R3 - R2
		
	lw	$t4, 4($t2) # y2
	lw	$t5, 4($t3) # y3
	
	sub	$t6, $t5, $t4	# y3 - y2
		
	sll	$t7, $t7, 16	# Shift (R3-R2) by 16 bits
	div	$t0, $t7, $t6	# (R3-R2)/(y3-y2)
	sw	$t0, l_R_e
		
	# For [G]reen:
	
	lbu	$t4, 10($t2) # G2
	lbu	$t5, 10($t3) # G3
		
	sub	$t7, $t5, $t4	# G3 - G2
		
	lw	$t4, 4($t2) # y2
	lw	$t5, 4($t3) # y3
	
	sub	$t6, $t5, $t4	# y3 - y2
		
	sll	$t7, $t7, 16	# Shift (G3-G2) by 16 bits
	div	$t0, $t7, $t6	# (G3-G2)/(y3-y2)
	sw	$t0, l_G_e
	
	# For [B]lue:
	
	lbu	$t4, 11($t2) # B2
	lbu	$t5, 11($t3) # B3
		
	sub	$t7, $t5, $t4	# B3 - B2
		
	lw	$t4, 4($t2) # y2
	lw	$t5, 4($t3) # y3
	
	sub	$t6, $t5, $t4	# y3 - y2
		
	sll	$t7, $t7, 16	# Shift (B3-B2) by 16 bits
	div	$t0, $t7, $t6	# (B3-B2)/(y3-y2)
	sw	$t0, l_B_e
	
	# @@@@@@@@@@@@@@@@@@@@ END OF CALCULATING COLOR DIFFERENCES @@@@@@@@@@@@@@@@@@@@@@@@
	# @@@@@@@@@@@@@@@@@@@@ c_*_e @@@@@@@@@@@@@@@@@
	
	# A
	lbu	$t0, 8($t2)
	sll	$t0, $t0, 16
	sw	$t0, c_A_e	
	
	# R
	lbu	$t0, 9($t2)
	sll	$t0, $t0, 16
	sw	$t0, c_R_e
	
	# G
	lbu	$t0, 10($t2)
	sll	$t0, $t0, 16
	sw	$t0, c_G_e
	
	# B
	lbu	$t0, 11($t2)
	sll	$t0, $t0, 16
	sw	$t0, c_B_e
	
	# @@@@@@@@@@@@@@@@@@@@ end of c_*e @@@@@@@@@@@
		
drawing_lines_between_y2_y3:

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	move	$v0, $s6 # xp
	sra	$v0, $v0, 16
	
	move	$v1, $s7 # xe
	sra	$v1, $v1, 16
	
	sub	$t0, $v1, $v0 # int(x_e) - int(x_b)
	
	sll	$v0, $v0, 16 # int(xp)
	sll	$v1, $v1, 16 # int(xe)
	
	li	$t6, 1
	beqz	$t0, skip_div_xe_xb_2
	
	li	$t4, 1
	sll	$t4, $t4, 16
	div	$t6, $t4, $t0 # 1 / (x_e - x_b), it is shifted by 16 bit to the left
skip_div_xe_xb_2:
	# $t8 is the lower one of the $s6 and $s7
	# $t9 is the bigger one of the $s6 and $s7
	# removing shift by shifting to the right by 16
	sra	$t8, $s6, 16 
	sra	$t9, $s7, 16
	ble	$s6, $s7, skip_switch_in_y2_y3
	sra	$t8, $s7, 16
	sra	$t9, $s6, 16

skip_switch_in_y2_y3:
	#addi	$t8, $t8, 1
	#addi	$t9, $t9, -1
	move	$s4, $t8 # x = lower of the x_b and x_e
	
single_line_between_y2_y3:	
	
	# $s1 - place for pixel on heap
	mul	$s1, $s5, $s2	# y * width	
	add	$s1, $s1, $s4	# y * width + x
	sll	$s1, $s1, 2	# 4*(y*width + x)
	
	addu	$s1, $s0, $s1
	
	# Calculating color
	
	sll	$t7, $s4, 16 # Shifting 'x' by 16 bit to the left, saving in $t7
	#move	$t0, $t8
	#sll	$t0, $t0, 16
	#sub	$t7, $t7, $t8
	
	#sub	$t7, $s4, $t8 # x - int(xp)
	#sll	$t7, $t7, 16
	#add	$t7, $t7, $v0 # (x - int(xp)) + xp
	
	# A
	
	lw	$t4, c_A_p
	lw	$t5, c_A_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
	
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, ($s1)
	
	# B
	
	lw	$t4, c_B_p
	lw	$t5, c_B_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
	
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, 1($s1)
	
	# G
	lw	$t4, c_G_p
	lw	$t5, c_G_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
	
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, 2($s1)
	
	# R
				
	lw	$t4, c_R_p
	lw	$t5, c_R_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
			
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, 3($s1)
	
	
	addiu	$s4, $s4, 1 # x = x + 1
	
	# if x < bigger of the x_b and x_e
	blt	$s4, $t9, single_line_between_y2_y3
	
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	
	# x_b = x_b + dx13
	lw	$t0, diff_ratio
	add	$s6, $s6, $t0
	
	# x_e = x_e + dx23
	lw	$t0, diff_ratio+4
	add	$s7, $s7, $t0
	
	# @@@@@@@ CALCULATING COLORS
		
	# A
	
	lw	$t0, l_A_p
	lw	$t7, c_A_p
	add	$t7, $t7, $t0
	sw	$t7, c_A_p
	
	lw	$t0, l_A_e
	lw	$t7, c_A_e
	add	$t7, $t7, $t0
	sw	$t7, c_A_e
	
	# R
	lw	$t0, l_R_p
	lw	$t7, c_R_p
	add	$t7, $t7, $t0
	sw	$t7, c_R_p
	
	lw	$t0, l_R_e
	lw	$t7, c_R_e
	add	$t7, $t7, $t0
	sw	$t7, c_R_e
	
	# G
	
	lw	$t0, l_G_p
	lw	$t7, c_G_p
	add	$t7, $t7, $t0
	sw	$t7, c_G_p
	
	lw	$t0, l_G_e
	lw	$t7, c_G_e
	add	$t7, $t7, $t0
	sw	$t7, c_G_e
	
	# B
	
	lw	$t0, l_B_p
	lw	$t7, c_B_p
	add	$t7, $t7, $t0
	sw	$t7, c_B_p
	
	lw	$t0, l_B_e
	lw	$t7, c_B_e
	add	$t7, $t7, $t0
	sw	$t7, c_B_e
	
	# @@@@@@@ END OF CALCULATING COLORS
	
	addiu	$s5, $s5, 1 # y = y + 1
	
	# If y < y3 -> jump to "drawing_lines_between_y2_y3"
	lw	$t0, 4($t3) # y3
	blt	$s5, $t0, drawing_lines_between_y2_y3
	
end_of_drawing:

# @@@@@@@@@@@@@@@@@@@@@@@@@ OSTATNIA LINIJKA @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	move	$v0, $s6 # xp
	sra	$v0, $v0, 16
	
	move	$v1, $s7 # xe
	sra	$v1, $v1, 16
	
	sub	$t0, $v1, $v0 # int(x_e) - int(x_b)
	
	sll	$v0, $v0, 16 # int(xp)
	sll	$v1, $v1, 16 # int(xe)
	
	li	$t6, 1
	beqz	$t0, skip_div_xe_xb_3
	
	li	$t4, 1
	sll	$t4, $t4, 16
	div	$t6, $t4, $t0 # 1 / (x_e - x_b), it is shifted by 16 bit to the left
skip_div_xe_xb_3:
	# $t8 is the lower one of the $s6 and $s7
	# $t9 is the bigger one of the $s6 and $s7
	# removing shift by shifting to the right by 16
	sra	$t8, $s6, 16 
	sra	$t9, $s7, 16
	ble	$s6, $s7, skip_switch_in_end
	sra	$t8, $s7, 16
	sra	$t9, $s6, 16

skip_switch_in_end:
	#addi	$t8, $t8, 1
	#addi	$t9, $t9, -1
	move	$s4, $t8 # x = lower of the x_b and x_e
	
single_line_end:	
	
	# $s1 - place for pixel on heap
	mul	$s1, $s5, $s2	# y * width	
	add	$s1, $s1, $s4	# y * width + x
	sll	$s1, $s1, 2	# 4*(y*width + x)
	
	addu	$s1, $s0, $s1
	
	# Calculating color
	
	sll	$t7, $s4, 16 # Shifting 'x' by 16 bit to the left, saving in $t7
	#move	$t0, $t8
	#sll	$t0, $t0, 16
	#sub	$t7, $t7, $t8
	
	#sub	$t7, $s4, $t8 # x - int(xp)
	#sll	$t7, $t7, 16
	#add	$t7, $t7, $v0 # (x - int(xp)) + xp
	
	# A
	
	lw	$t4, c_A_p
	lw	$t5, c_A_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
	
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, ($s1)
	
	# B
	
	lw	$t4, c_B_p
	lw	$t5, c_B_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
	
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, 1($s1)
	
	# G
	lw	$t4, c_G_p
	lw	$t5, c_G_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
	
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, 2($s1)
	
	# R
				
	lw	$t4, c_R_p
	lw	$t5, c_R_e
	sub	$t5, $t5, $t4 # (ce - cp) - shifted
			
	sub	$t0, $t7, $v0 # (x - xp) - shifted
			
	mul	$t0, $t5, $t0 # (ce - cp) * (x - xp) - shifted by 32
	mfhi	$t0 # not shifted
	
	mul	$t0, $t0, $t6 # (ce - cp) * (x - xp) / (xe - xp) - shifted
	add	$t0, $t4, $t0 # cp + (ce - cp) * (x - xp) / (xe - xp) - shifted
	sra	$t0, $t0, 16
		
	sb	$t0, 3($s1)
	
	addiu	$s4, $s4, 1 # x = x + 1
	
	# if x < bigger of the x_b and x_e
	blt	$s4, $t9, single_line_end
# @@@@@@@@@@@@@@@@@@@@@@@ KONIEC RYSOWANIA OSTATNIEJ LINIJKI @@@@@@@@@@@@@@@

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@	
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@	
	
save:
	# writing into file (creating file if such doesn't exist
	li	$v0, 13
	la	$a0, output_file
	li	$a1, 1	# write flag
	li	$a2, 0	# ignore mode
	syscall
	move	$s6, $v0
	
	# first 2 bytes "BM"
	li	$v0, 15
	move	$a0, $s6
	la	$a1, bitmap # Can be replaced by "li $a1, some_number"
	li	$a2, 2
	syscall
	
	# header
	li	$v0, 15
	move	$a0, $s6
	la	$a1, header
	li	$a2, 68
	syscall
	
	# from heap
	li	$v0, 15
	move	$a0, $s6
	la	$a1, ($s0)
	lw	$a2, header+32
	#move	$a2, $s1
	syscall
	
	# closing file
	
	li	$v0, 16
	move	$a0, $s6
	syscall	
	
end:
	li	$v0, 10
	syscall
	
fail:
	li	$v0, 4	# print string
	la	$a0, error
	syscall
	
	b	end