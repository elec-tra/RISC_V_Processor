`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2022 08:16:36 AM
// Design Name: 
// Module Name: ctrl
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


module ctrl(
    //Control Unit Management port
    input wire RES,
    input wire CLK,
    
//    //CPU Instruction input port
//    input wire [6 : 0] opcode,
//    input wire [2 : 0] funct3,
//    input wire [6 : 0] funct7,

    //CPU Instruction input port
    input wire [6 : 0] opcode,
    
    //Program Counter Control port
    output reg MODE,                // 0-means increment by 4
    
    //Instruction Memory Control port
    //output reg data_write_enable,   // 0-means read; 1-means write 
    output reg instr_req,
    input wire instr_gnt,
    input wire instr_r_valid,
    
    //Register set Control port
    output reg write_enable,        // 0-means read; 1-means write
    
    //MUX(ALU) Control port
    output reg ALUSrcMux1,         // 0-means Q0; 1-means Program Counter Value
    output reg ALUSrcMux2,         // 0-means Q1; 1-means Immediate value
    //output reg ALUSrcMux3,        // 0-means Q1; 1-means Immediate Value
    
//    //ALU Control Port
//    output reg [5 : 0] S
    
    //ALU Control Port
    output reg [1 : 0] ALUOp
);

    localparam
        Ready = 1'b0,
        wait_for_instruction = 1'b1;
    
    reg stateMoore_reg, stateMoore_next;

    always @(posedge CLK, posedge RES)
    begin
        if(RES == 1'b1) // reset
        begin
            stateMoore_reg <= Ready;
        end
        else
        begin
            stateMoore_reg <= stateMoore_next;
        end
    end
    
    always @(stateMoore_reg, instr_gnt, instr_r_valid, opcode)
    begin
        // store current state as next, required: when no case statement is satisfied
        stateMoore_next = stateMoore_reg;
        
        //Default Signals
        MODE = 1'b0;                //Program counter increment by 4
        //data_write_enable = 1'b0;   //Instruction Memory is readonly
        
        instr_req = 1'b0;
        ALUSrcMux1 = 1'b0;
        ALUSrcMux2 = 1'b0;
        ALUOp = 2'b11;
        write_enable = 1'b0;
        
        casez(stateMoore_reg)
            Ready:
            begin
                instr_req = 1'b1; //Read request
                if(instr_gnt == 1'b1)
                begin
                    stateMoore_next = wait_for_instruction;
                end
            end
                    
            wait_for_instruction:
            begin
                instr_req = 1'b0;
                if(instr_r_valid == 1'b1)
                begin
                    casez(opcode)
                    
                        7'b0110111:     //LUI
                        begin
                            ALUSrcMux1 = 1'b0;  //A = don't care
                            ALUSrcMux2 = 1'b1;  //B = Immediate value
                            ALUOp = 2'b10;
                            write_enable = 1'b1;
                        end
                        
                        7'b0010111:     //AUIPC
                        begin
                            ALUSrcMux1 = 1'b1;  //A = Program Counter Value
                            ALUSrcMux2 = 1'b1;  //B = Immediate value
                            ALUOp = 2'b00;
                            write_enable = 1'b1;
                        end
                        
                        7'b0010011:     //I-type Instruction
                        begin
                            ALUSrcMux1 = 1'b0;  //A = Q0
                            ALUSrcMux2 = 1'b1;  //B = Immediate value
                            ALUOp = 2'b00;
                            write_enable = 1'b1;
                        end
                        
                        7'b0110011:     //R-type Instruction
                        begin
                            ALUSrcMux1 = 1'b0;  //A = Q0
                            ALUSrcMux2 = 1'b0;  //B = Q1
                            ALUOp = 2'b01;
                            write_enable = 1'b1;
                        end
                        
                        default:
                        begin
                            ALUSrcMux1 = 1'b0;
                            ALUSrcMux2 = 1'b0;
                            ALUOp = 2'b11;
                            write_enable = 1'b0;
                        end
                    endcase
                stateMoore_next = Ready;
                end
            end
            default:
            begin
                stateMoore_next = Ready;
                ALUSrcMux1 = 1'b0;
                ALUSrcMux2 = 1'b0;
                ALUOp = 2'b11;
                write_enable = 1'b0;
            end
        endcase
    end
    
endmodule