`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2022 09:04:12 AM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define ALU_ADD_OP 6'b00_0001   //1
`define ALU_SUB_OP 6'b10_0001   //33
`define ALU_AND_OP 6'b01_1101   //29
`define ALU_OR_OP 6'b01_1001    //25
`define ALU_XOR_OP 6'b01_0001   //17
`define ALU_SLL_OP 6'b00_0101   //5
`define ALU_SRA_OP 6'b11_0101   //53
`define ALU_SRL_OP 6'b01_0101   //21
`define ALU_SLT_OP 6'b00_1001   //9
`define ALU_SLTU_OP 6'b00_1101  //13
`define ALU_BEQ_OP 6'b?0_0011   //3, 35
`define ALU_BNE_OP 6'b?0_0111   //7, 39
`define ALU_BLT_OP 6'b?1_0011   //19, 51
`define ALU_BGE_OP 6'b?1_0111   //23, 55
`define ALU_BLTU_OP 6'b?1_1011  //27, 59
`define ALU_BGEU_OP 6'b?1_1111  //31, 63

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

				`ALU_SLT_OP: begin Q = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; 
							 CMP = ($signed(A) < $signed(B)) ? 1 : 0;
							 end 

				`ALU_SLTU_OP: begin Q = (A < B) ? 32'd1 : 32'd0; 
				              CMP = (A < B) ? 1 : 0;
				              end

				`ALU_BEQ_OP: CMP = (A == B) ? 1 : 0;
				`ALU_BNE_OP: CMP = (A != B) ? 1 : 0;
				`ALU_BLT_OP: CMP = ($signed(A) < $signed(B)) ? 1 : 0;
				`ALU_BGE_OP: CMP = ($signed(A) >= $signed(B)) ? 1 : 0;
				`ALU_BLTU_OP: CMP = (A < B) ? 1 : 0;
				`ALU_BGEU_OP: CMP = (A >= B) ? 1 : 0;

				default : begin Q=32'd0; 
				                CMP = 0;
				          end

			endcase

		end

endmodule