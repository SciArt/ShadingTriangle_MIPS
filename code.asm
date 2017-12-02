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
# $s1 - size of data sector (pixels*4) in bytes
# $s2 - width in pixels
# $s3 - height in pixels
# $s6 - file descriptor
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
	
	bgt	$t3, $t1, check_t2_t3	# t3 > t1 -> skip the switching t1 with t3
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
	
between_y1_y2:
	
between_y2_y3:

end_of_drawing:

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
	move	$a2, $s1
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
