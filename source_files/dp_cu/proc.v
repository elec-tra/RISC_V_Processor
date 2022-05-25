//Adapted from riscv-defines @ pulp
`define OPCODE_OP 7'h33 //Done
`define OPCODE_OPIMM 7'h13 //Done
`define OPCODE_STORE 7'h23
`define OPCODE_LOAD 7'h03
`define OPCODE_BRANCH 7'h63
`define OPCODE_JALR 7'h67
`define OPCODE_JAL 7'h6f
`define OPCODE_AUIPC 7'h17
`define OPCODE_LUI 7'h37

module proc(
	input clk,
	input res,
	input [31 : 0] instr_read,
	input instr_gnt,
	input instr_r_valid,
	input [31 : 0] data_read,
	input data_gnt,
	input data_r_valid,
	//input irq,
	//input [4 : 0] irq_id,
	
	output [31 : 0] instr_adr,
	output instr_req,
    output [31 : 0] data_write,
	output [31 : 0] data_adr,
	output data_req,
	output data_write_enable
	//output [3 : 0] data_be,
	//output irq_ack,
	//output [4 : 0] irq_ack_id
);

	//-----Wires & Registers-----

	//PC
	wire PCSrc;
	wire [31 : 0] Jmp_adr;
	wire reg_pc_select;

	//Control Unit
	wire [6 : 0] Opcode;
	wire Branch;
	wire MemtoReg;
	wire [1 : 0] ALUOp;
	wire ALUSrc1; //For Reg/PC to ALU_A
	wire ALUSrc2; //For Reg/Imm to ALU_B
	wire ALUSrc1_5; // for zero
	wire ALUSrc2_5; // for 4
	wire RegWrite;

	//Register Set
	wire [4 : 0] Read_register_1;
	wire [4 : 0] Read_register_2;
	wire [4 : 0] Write_register;
	wire [31 : 0] Write_data;
	wire [31 : 0]Read_data_1;
	wire [31 : 0] Read_data_2;

	//Immediate Generation
	reg [31 : 0] imm_gen_output;
	wire [31 : 0] imm_gen_output_lshifted;

	//ALU
	wire[5 : 0] ALU_control;
	wire [31 : 0] ALU_A;
	wire [31 : 0] ALU_A_1; // for additional 0
	wire [31 : 0] ALU_B;
	wire [31 : 0] ALU_B_1; // for additional 4
	wire [31 : 0] ALU_result;
	wire Zero;

	//-----Wire Assignments-----

	//PC
	assign PCSrc = Branch & Zero;

	//Control Unit
	assign Opcode = instr_read[6 : 0]; //One input to CU 

	//Register Set
	assign Read_register_1 = instr_read[19 : 15];
	assign Read_register_2 = instr_read[24 : 20];
	assign Write_register = instr_read[11 : 7];

	//Immediate Generation
	assign imm_gen_output_lshifted = imm_gen_output << 1'd1; 

	//ALU
	assign ALU_control = {instr_read[30], instr_read[14 : 12], ALUOp};

	//-----Component definitions-----

	//PC
	MUX_2x1_32 JMP_ADR_SELECT(.I0(instr_adr + imm_gen_output_lshifted), .I1(Read_data_1 + imm_gen_output_lshifted), .S(reg_pc_select), .Y(Jmp_adr)); //CHECKED
	pc PC(.CLK(clk), .RES(res), .ENABLE(!res), .MODE(PCSrc), .D(Jmp_adr), .PC_OUT(instr_adr)); //CHECKED

	//Instruction Memory (TODO: Instantiation)
	//Not a part of processor so only need to use outside ports for input and output

	//Control unit (TODO: Instantiation)
	ctrl CU(.RES(res), .CLK(clk), .opcode(Opcode), .MODE(Branch), 
			.instr_req(instr_req), .instr_gnt(instr_gnt), .instr_r_valid(instr_r_valid),
			.write_enable(RegWrite), .ALUSrcMux1(ALUSrc1), .ALUSrcMux1_S(ALUSrc1_5), .ALUSrcMux2(ALUSrc2), 
			.ALUSrcMux2_S(ALUSrc2_5), .ALUOp(ALUOp), .reg_pc_select(reg_pc_select),
			.alu_dm_select(MemtoReg),
			.data_write_enable(data_write_enable), .data_req(data_req), .data_gnt(data_gnt),
			.data_r_valid(data_r_valid)); //CHECKED

	//Register Set
	regset Register_Set(.D(Write_data), .A_D(Write_register), .A_Q0(Read_register_1), .A_Q1(Read_register_2),
	                    .write_enable(RegWrite), .RES(res), .CLK(clk), .Q0(Read_data_1), .Q1(Read_data_2)); //CHECKED

	//Immediate Generator
	always @(Opcode)
	begin
	   imm_gen_output <= 32'd0;
	   
		casez(Opcode)
			`OPCODE_OPIMM: imm_gen_output <= { {20{instr_read[31]}}, instr_read[31 : 20] }; //CHECKED
			`OPCODE_STORE: imm_gen_output <= { {20{instr_read[31]}}, instr_read[31 : 25], instr_read[11 : 7] }; //CHECKED
			`OPCODE_LOAD: imm_gen_output <= { {20{instr_read[31]}}, instr_read[31 : 20] }; //CHECKED
			`OPCODE_BRANCH: imm_gen_output <= { {19{instr_read[31]}} ,instr_read[31], instr_read[7], instr_read[30 : 25], instr_read[11 : 8], 1'b0}; //CHECKED
			`OPCODE_JALR: imm_gen_output <= { {20{instr_read[31]}}, instr_read[31 : 20] }; //CHECKED
			`OPCODE_JAL: imm_gen_output <= { {11{instr_read[31]}}, instr_read[31], instr_read[19 : 12], instr_read[20], instr_read[30 : 21], 1'b0}; //CHECKED
			`OPCODE_AUIPC: imm_gen_output <= {instr_read[31 : 12], {12{1'b0}} }; //CHECKED
			`OPCODE_LUI: imm_gen_output <= {instr_read[31 : 12], {12{1'b0}} }; //CHECKED

			default: imm_gen_output <= 32'd0; //CHECKED

		endcase
	end
	

	//ALU 
	MUX_2x1_32 MUX_ALU_1(.I0(Read_data_1), .I1(instr_adr), .S(ALUSrc1), .Y(ALU_A_1)); //CHECKED
	MUX_2x1_32 MUX_ALU_1_5(.I0(ALU_A_1), .I1(32'd0), .S(ALUSrc1_5), .Y(ALU_A));
	
	MUX_2x1_32 MUX_ALU_2(.I0(Read_data_2), .I1(imm_gen_output), .S(ALUSrc2), .Y(ALU_B_1)); //CHECKED
	MUX_2x1_32 MUX_ALU_2_5(.I0(ALU_B_1), .I1(32'd4), .S(ALUSrc2_5), .Y(ALU_B));
	
	alu ALU(.S(ALU_control), .A(ALU_A), .B(ALU_B), .CMP(Zero), .Q(ALU_result)); //CHECKED
	

	//Data Memory //Checked for now
	//Not a part of processor so only need to use outside ports for input and output
	assign data_adr = ALU_result;
	assign data_write = Read_data_2;
	MUX_2x1_32 MUX_DATA(.I0(ALU_result), .I1(data_read), .S(MemtoReg), .Y(Write_data)); //CHECKED

endmodule