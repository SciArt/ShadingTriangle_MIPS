.data
header:		.space	68
bitmap:		.ascii "BM"

input_file:	.asciiz	"input.bmp"
output_file:	.asciiz	"output.bmp"

prompt1:	.asciiz	"Bitmap properties:\nAmount of pixels: "
prompt2:	.asciiz	"\nWidth in pixels: "
prompt3:	.asciiz "\nHeight in pixels: "
error:		.asciiz "Cannot open BMP file"

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
	
	# reading header from bitmap (first 54 bytes)
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
	
	lw	$s1, header+32 # saving data offset
	lw	$s2, header+16 # saving width of bitmap	
	lw	$s3, header+20 # saving height of bitmap
	
	# printing bitmap properties
	
	# print data offset
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
	
	
	# closing file (input_file)
	li	$v0, 16
	move	$a0, $s6
	syscall
	
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
	la	$a1, bitmap
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
