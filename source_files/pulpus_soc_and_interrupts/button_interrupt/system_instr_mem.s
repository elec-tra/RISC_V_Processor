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
beq x0, x0, 0x2C    # at address=0x0x1C00_8028, PC = 0x0x1C00_8080, Timer Interrupt
00000000
00000000
00000000
00000000
beq x0, x0, 0x2A    # at address=0x0x1C00_803C, PC = 0x0x1C00_8090, Button Interrupt
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
addi x11, x0, 0x4       # Timer ISR at address 0x1C00_8080	# x11 = 0x0000_0004
addi x12, x11, 0x4      # x12 = 0x0000_0008
mret
00000000                # Isolation
lui x21 , 0x1a101	# Button ISR start at address=0x1C00_8090, x21 = 0x1A10_1000
addi x21, x21, 0x018	# x21 = 0x1A10_1018
lw x22, 0(x21)		# x22 = Mem(0x1A10_1081), Button Status
lui x23, 0x00040	# x23 = 0x0004_0000(Mask Register) To check button 0
and x24, x22, x23       # x24 = Button 0 status
or x25, x24, x0         # Transfer x24 value to x25
srli x23, x23, 0x1      # x23 = 0x0002_0000(Mask Register) To check button 1
and x24, x22, x23       # x24 = Button 1 status
or x25, x24, x25         # Transfer x24 value to x25
srli x23, x23, 0x1      # x23 = 0x0001_0000(Mask Register) To check button 2
and x24, x22, x23       # x24 = Button 2 status
or x25, x24, x25         # Transfer x24 value to x25
srli x25, x25, 0x10     # shift right x25 by 16 position, i.e all button status at LSB
lui x21 , 0x1a120	# x21 = 0x1A12_0000
sw x25, 0(x21)          # Update last 3 bits of LED register
mret

Note:
# Timer Interrupt Start Time: 5620ns
