`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2022 10:21:37 AM
// Design Name: 
// Module Name: alu_tb
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


module alu_tb();
reg [31:0]A, B;
reg [5:0]S;
wire [31:0]Q;
wire CMP;
reg [31:0]L; //L- Desired Output
reg CMP_T; //CMP_T- Desired Output

alu dut(.A(A), .B(B), .S(S), .Q(Q), .CMP(CMP));
initial
begin
    //Unimplemented Case
    A=-1; B=1; S=6'd0; L=0; #10
    if(Q != L)
    begin
        $display("Test pattern 1 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //ADD: Addition
    //Test Case 1:
    A=-1; B=1; S=6'd1; L=0; #10
    if(Q != L)
    begin
        $display("Test pattern 2 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    //Test Case 2:
    A=-1; B=-1; S=6'd1; L=-2; #10
    if(Q != L)
    begin
        $display("Test pattern 3 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SUB: Subtraction
    //Test Case 1:
    A=-1; B=1; S=6'd33; L=-2; #10
    if(Q != L)
    begin
        $display("Test pattern 4 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    //Test Case 2:
    A=-1; B=-1; S=6'd33; L=0; #10
    if(Q != L)
    begin
        $display("Test pattern 5 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //AND: Bitwise AND
    A=32'hF0F0_F0F0; B=32'h0FF0_F00F; S=6'd29; L=32'h00F0_F000; #10
    if(Q != L)
    begin
        $display("Test pattern 6 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //OR: Bitwise OR
    A=32'hF0F0_F0F0; B=32'h0FF0_F00F; S=6'd25; L=32'hFFF0_F0FF; #10
    if(Q != L)
    begin
        $display("Test pattern 7 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //XOR: Bitwise XOR
    A=32'hF0F0_F0F0; B=32'h0FF0_F00F; S=6'd17; L=32'hFF00_00FF; #10
    if(Q != L)
    begin
        $display("Test pattern 8 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SLL: Logical shift to left
    A=32'hF0F0_F0F7; B=32'd2; S=6'd5; L=32'hC3C3_C3DC; #10
    if(Q != L)
    begin
        $display("Test pattern 9 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SRA: Arithmetic shift to right
    //Test Case 1:
//    A=32'hF0F0_F0F7; B=32'd3; S=6'd53; L=32'hFE1E_1E1E; #10
//    if(Q != L)
//    begin
//        $display("Test pattern 10 failed: Q=%h L=%h", Q, L);
//        $finish;
//    end
    //Test Case 2:
    A=32'h00F0_F0F7; B=32'd4; S=6'd53; L=32'h000F_0F0F; #10
    if(Q != L)
    begin
        $display("Test pattern 11 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SRL: Logical shift to right
    A=32'hF0F0_F0F7; B=32'd5; S=6'd21; L=32'h0787_8787; #10
    if(Q != L)
    begin
        $display("Test pattern 12 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SLT: Signed compare
    //Test Case 1:
    A=-35; B=-35; S=6'd9; L=32'd1; #10
    if(Q != L)
    begin
        $display("Test pattern 13 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    //Test Case 2:
    A=100; B=-26; S=6'd9; L=0; #10
    if(Q != L)
    begin
        $display("Test pattern 14 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SLTU: Unsigned compare
    //Test Case 1:
    A=-65; B=4294967231; S=6'd13; L=32'd1; #10
    if(Q != L)
    begin
        $display("Test pattern 15 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    //Test Case 2:
    A=928; B=741; S=6'd13; L=0; #10
    if(Q != L)
    begin
        $display("Test pattern 16 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //------------------------------------------------------------------//
    
    //BEQ: Equal comparision
    //Test Case 1:
    A=-27650; B=-27650; S=6'd3; CMP_T=1'b1; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 17 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    //Test Case 2:
    A=928; B=741; S=6'd35; CMP_T=1'b0; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 18 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    
    //BNE: Unequal comparision
    A=-27650; B=0; S=6'd39; CMP_T=1'b1; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 19 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    
    //BLT: Signed lesser than comparision
    A=-48; B=2795; S=6'd51; CMP_T=1'b1; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 20 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    
    $display("Simulation Successfull!");
    $stop;
end
endmodule
