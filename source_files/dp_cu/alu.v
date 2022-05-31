/*
Implemented operations of the ALU

ADD: Addition
SUB: Subtraction
AND: Bitwise AND
OR: Bitwise OR
XOR: Bitwise XOR
SLL: Logical shift to left
SRA: Arithmetic shift to right
SRL: Logical shift to right
SLT: Signed compare
SLTU: Unsigned compare
BEQ: Equal comparison
BNE: Unequal comparison
BLT: Signed lesser than comparison
BGE: Signed greater than comparison
BLTU: Unsigned lesser than comparison
BGEU: Unsigned greater than comparison

Extensions:

LUI: rd <- (Direct value<<12)
AUIPC: rd <- (Direct value<<12) + Program Counter value
ADDI : Add Immediate
SLTI : Signed Compare Immediate
SLTIU : Unsigned Compare Immediate
XORI : XOR Immediate
ORI : OR_Immediate
ANDI : AND Immediate
SLLI : Shift Left Logical Immediate
SRLI : Shift Right Logical Immediate
SRAI : Shift Right Arithmetic Immediate


The CMP signal is always „1“ if the comparison is true, otherwise it is “0”.
*/

/*

Bits of RISC-V that define S in our case : 

[30](func7), [14:12](func3), [6:5](opcode)

*/

`define ALU_ADD_OP 6'b0_000_01
`define ALU_SUB_OP 6'b1_000_01
`define ALU_AND_OP 6'b0_111_01
`define ALU_OR_OP 6'b0_110_01
`define ALU_XOR_OP 6'b0_100_01
`define ALU_SLL_OP 6'b0_001_01
`define ALU_SRA_OP 6'b1_101_01
`define ALU_SRL_OP 6'b0_101_01
`define ALU_SLT_OP 6'b0_010_01
`define ALU_SLTU_OP 6'b0_011_01
`define ALU_BEQ_OP 6'b?_000_11
`define ALU_BNE_OP 6'b?_001_11
`define ALU_BLT_OP 6'b?_100_11  //19, 51
`define ALU_BGE_OP 6'b?_101_11  //23, 55
`define ALU_BLTU_OP 6'b?_110_11 //27, 59
`define ALU_BGEU_OP 6'b?_111_11 //31, 63

//Extensions
`define ALU_LUI_OP 6'b?_???_10 //Custom ALUOp bit 10 for LUI
//`define ALU_AIUPC_OP 6'b?_???_00 //Least priority for now in I-Type

`define ALU_ADDI_OP 6'b?_000_00
`define ALU_SLTI_OP 6'b?_010_00
`define ALU_SLTIU_OP 6'b?_011_00
`define ALU_XORI_OP 6'b?_100_00
`define ALU_ORI_OP 6'b?_110_00
`define ALU_ANDI_OP 6'b?_111_00
`define ALU_SLLI_OP 6'b0_001_00
`define ALU_SRLI_OP 6'b0_101_00
`define ALU_SRAI_OP 6'b1_101_00


module alu (
input [ 5 : 0 ] S ,
input [ 31 : 0 ] A,
input [ 31 : 0 ] B,
output reg CMP,
output reg [ 31 : 0 ] Q
) ;

	always @( S , A, B)

		begin

			Q=32'd0 ; CMP = 0;

			// If several cases apply, only the first case is executed

			casez ( S )

				`ALU_SUB_OP: Q = $signed(A) - $signed(B);
				`ALU_ADD_OP: Q = $signed(A) + $signed(B);

				`ALU_AND_OP: Q = A & B;
				`ALU_OR_OP: Q = A | B;
				`ALU_XOR_OP: Q = A ^ B; 

				`ALU_SLL_OP: Q = A << B;
				`ALU_SRA_OP: Q = $signed(A) >>> $signed(B);
				`ALU_SRL_OP: Q = A >> B;

				`ALU_SLT_OP: /*begin Q = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; 
							 CMP = ($signed(A) < $signed(B)) ? 1 : 0;
							 end */ Q = $signed(A) + $signed(B);

				`ALU_SLTU_OP: begin Q = (A < B) ? 32'd1 : 32'd0; 
				              CMP = (A < B) ? 1 : 0;
				              end

				`ALU_BEQ_OP: CMP = (A == B) ? 1 : 0;
				`ALU_BNE_OP: CMP = (A != B) ? 1 : 0;
				`ALU_BLT_OP: CMP = ($signed(A) < $signed(B)) ? 1 : 0;
				`ALU_BGE_OP: CMP = ($signed(A) >= $signed(B)) ? 1 : 0;
				`ALU_BLTU_OP: CMP = (A < B) ? 1 : 0;
				`ALU_BGEU_OP: CMP = (A >= B) ? 1 : 0;

				
				//Extensions
			    `ALU_ADDI_OP: Q = $signed(A) + $signed(B);

				`ALU_ANDI_OP: Q = A & B;
				`ALU_ORI_OP: Q = A | B;
				`ALU_XORI_OP: Q = A ^ B; 

				`ALU_SLLI_OP: Q = A << B[4 : 0];
				`ALU_SRAI_OP: Q = $signed(A) >>> $signed(B[4 : 0]);
				`ALU_SRLI_OP: Q = A >> B[4 : 0];

				`ALU_SLTI_OP: //begin Q = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; 
							// CMP = ($signed(A) < $signed(B)) ? 1 : 0;
							// end  
							 Q = $signed(A) + $signed(B);

				`ALU_SLTIU_OP: begin Q = (A < B) ? 32'd1 : 32'd0; 
				              CMP = (A < B) ? 1 : 0;
				              end

				`ALU_LUI_OP: begin Q = A + B;
				                   CMP = 1;
				                   end

				/*`ALU_AIUPC_OP: Q = B + A;			  

				
				default: begin Q = 32'd0; 
				                CMP = 0;
						  end*/			  

			endcase

		end

endmodule		
