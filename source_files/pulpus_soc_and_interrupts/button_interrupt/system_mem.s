# INT_CNTRL
lui x1, 0x1a109		# x1 = 0x1A10_9000
addi x1, x1, 0x004	# x1 = 0x1A10_9004
lui x4, 0x8			# x4 = 0x0000_8000, Enable Button Interrupt
sw x4, 0(x1)

# CFG_REG_LOW reg 
lui x2, 0x1a10b		# x2 = 0x1A10_B000
addi x3, x0, 0x34	# x3 = 0x0000_0034, Disable Timer Interrupt
sw x3, 0(x2)

# Verify
lw x5, 0(x1)		#INT_CNTRL
lui x2, 0x1a10b
lw x6, 0(x2)		#CFG_REG_LOW reg