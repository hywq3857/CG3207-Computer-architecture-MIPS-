#Written by Hu Yang
			.data
	var0:	.word	0
	var1:	.word	1
	var2:	.word	2
	var3:	.word	3
	var4:	.word	4
	var5:	.word	5
	
	addr1:	.word	0 # declare storage for var1; initial value is 00

	.globl main
	.text
main:
	nop
	nop
	nop

	
	lw $t0, var2 #t0 = 2
	nop
	nop
	nop
	lw $t1, var3 #t1 = 3
	
	nop
	nop
	nop

	sub $t2, $t0, $t1 #t2 = ffffffff
	nop
	nop
	nop
label4:
	#bgezal $t1, main
	nop
	add $t0, $t0, $t2, # t0 = 1
	multu $t2, $t0 # hi = 0, lo = 6
	mfhi $t4 # t4 = 0
	mflo $t3 # t3 = fffffff
label1:
	#lw $t2, var5 # t2 = 5
	#sub $t0, $t2, $t3 #t0 = ffffffff
	mult $t3, $t0 # hi = ffffffff, lo = ffffffff
	mfhi $t4 # t4 = ffffffff
	mflo $t5 # t5 = ffffffff
	
	#add $t3, $t0, $t2 # t3 = 5
	addi $t3, $t0, 4 # t3 = 5
	sub $t4, $t3, $t2 # t4 = 6
	slti $s5, $t3, 3 # s5 = 0
	slti $s5, $t3, 30 # s5 =1
	and $t5, $t4, $t3 # t5 = 4
	or  $t6, $t4, $t3 # t6 = 7
	jal shift # $31 = 0040006c
	nop
	nop
	nop
	j main
shift:	
nop	
nop
	nop	

	j label2
	nop	
	nop	
	nop	
	nop	
label2:
	nor $s6, $s7, $s3 # s1 = 0
	ori $s4, 1	 # s4 = 3
	slt $t8, $s1, $s4 # t8 = 1
	slt $t8, $s4, $s1 # t8 = 0
	xor $t0, $s7, $s3 #t0 = c000000
	lui $t1, 0x0040
	addi $t1, $t1,0xcc
	
label3:	

	addu $s4, $s4, $s4 #s4=6
	subu $s4, $s4, $s5#s4 = 5
	nop
	nop
	nop
	sw $s4, addr1 # store contents of register $t6 into RAM:  addr1 = $s4 
	nop
	nop
	nop
	lw $s2, addr1	#have problem here # s2 = fffffffa
	nop
	nop
	nop
	j main
