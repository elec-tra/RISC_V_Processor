auipc x1, 0xbcd     #R1 = 1abcd004
addi x3, x0, 0x32   #R3 = 00000032
add x4, x3, x3      #R4 = 00000064
lui x5, 0x1A000      #R5 = 1A00_0000
lw x6, 0x30(x5)      #R6 = mem(1a00002C) = dead0000
lw x7 0x34(x5)       #R7 = mem(1a000030) = 0000beef
add x8, x6, x7      #R8 = deadbeef
sw x8, 0x38(x5)      #MEM[1a000034] = R8 = deadbeef
add x0, x0, x0		#NOP
lw x9, 0x38(x5)      #R9 = deadbeef
jalr x10, 0(x1)     #R10 = pc + 4, pc = x1 = 1abcd004