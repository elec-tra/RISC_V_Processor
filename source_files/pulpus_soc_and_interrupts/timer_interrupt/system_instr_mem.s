00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
beq x0, x0, 0x2C    # PC = 0x0x1C00_8080, Timer Interrupt
00000000
00000000
00000000
button interrupt jump
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
addi x11, x0, 0x4	# Timer ISR at address 0x1C00_8080	# x11 = 0x0000_0004
addi x12, x11, 0x4	# x12 = 0x0000_0008
mret
00000000		# Isolation
Next ISR 		#at address 0x1C00_8094

# Timer Interrupt Start Time: 5620ns