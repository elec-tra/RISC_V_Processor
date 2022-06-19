# TIMER_CMP_LOW reg
lui x2, 0x1a10b		# x2 = 0x1A10_B000
addi x2, x2, 0x010	# x2 = 0x1A10_B010
addi x3, x0, 0xF	# x3 = 0x0000_0004
sw x3, 0(x2)

# INT_CNTRL
lui x1, 0x1a109		# x1 = 0x1A10_9000
addi x1, x1, 0x004	# x1 = 0x1A10_9004
addi x4, x0, 0x400	# x4 = 0x0000_0400
sw x4, 0(x1)

# CFG_REG_LOW reg 
lui x2, 0x1a10b		# x2 = 0x1A10_B000
addi x3, x0, 0x35	# x3 = 0x0000_0035
sw x3, 0(x2)

lui x2, 0x1a10b

lw x5, 0(x1)		#INT_CNTRL
lw x6, 0x010(x2)	#TIMER_CMP_LOW reg
lw x7, 0(x2)		#CFG_REG_LOW reg