`timescale 1ns / 1ps

`define ADD 5'h1
`define SUB 5'h2
`define MUL 5'h3
`define AND 5'h4
`define OR 5'h5
`define XOR 5'h6
`define SLL 5'h7
`define SRA 5'h8
`define SRL 5'h9
`define SLT 5'hA
`define SLTU 5'hB

`define BEQ 5'hC
`define BNE 5'hD
`define BLT 5'hE
`define BGE 5'hF 
`define BLTU 5'h10
`define BGEU 5'h11 

`define SLLI 5'h12
`define SRLI 5'h13
`define SRAI 5'h14

`define LUI 5'h15
`define AUIPC 5'h16

module alu_tb();
reg [31:0]A, B;
reg [4:0]S;
wire [31:0]Q;
wire CMP;
reg [31:0]L; //L- Desired Output
reg CMP_T; //CMP_T- Desired Output

alu dut(.A(A), .B(B), .S(S), .Q(Q), .CMP(CMP));
initial
begin
    //Unimplemented Case
    A=-1; B=1; S=5'd0; L=0; #10
    if(Q != L)
    begin
        $display("Test pattern 1 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //ADD: Addition
    //Test Case 1:
    A=-1; B=1; S=`ADD; L=0; #10
    if(Q != L)
    begin
        $display("Test pattern 2 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    //Test Case 2:
    A=-1; B=-1; S=`ADD; L=-2; #10
    if(Q != L)
    begin
        $display("Test pattern 3 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SUB: Subtraction
    //Test Case 1:
    A=-1; B=1; S=`SUB; L=-2; #10
    if(Q != L)
    begin
        $display("Test pattern 4 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    //Test Case 2:
    A=-1; B=-1; S=`SUB; L=0; #10
    if(Q != L)
    begin
        $display("Test pattern 5 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //AND: Bitwise AND
    A=32'hF0F0_F0F0; B=32'h0FF0_F00F; S=`AND; L=32'h00F0_F000; #10
    if(Q != L)
    begin
        $display("Test pattern 6 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //OR: Bitwise OR
    A=32'hF0F0_F0F0; B=32'h0FF0_F00F; S=`OR; L=32'hFFF0_F0FF; #10
    if(Q != L)
    begin
        $display("Test pattern 7 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //XOR: Bitwise XOR
    A=32'hF0F0_F0F0; B=32'h0FF0_F00F; S=`XOR; L=32'hFF00_00FF; #10
    if(Q != L)
    begin
        $display("Test pattern 8 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SLL: Logical shift to left
    A=32'hF0F0_F0F7; B=32'd2; S=`SLL; L=32'hC3C3_C3DC; #10
    if(Q != L)
    begin
        $display("Test pattern 9 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SRA: Arithmetic shift to right
    //Test Case 1:
    A=32'hF0F0_F0F7; B=32'd3; S=`SRA; L=32'hFE1E_1E1E; #10
    if(Q != L)
    begin
        $display("Test pattern 10 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SRL: Logical shift to right
    A=32'hF0F0_F0F7; B=32'd5; S=`SRL; L=32'h0787_8787; #10
    if(Q != L )
    begin
        $display("Test pattern 11 failed: Q=%h L=%h", Q, L);
        $finish;
    end
    
    //SLT: Signed compare
    //Test Case 1:
    A=-35; B=-75; S=`SLT; L=32'd0; CMP_T=1'b0; #10
    if((Q != L) && (CMP != CMP_T))
    begin
        $display("Test pattern 12 failed: Q=%h L=%h -- CMP=%b CMP_T=%b", Q, L, CMP, CMP_T);
        $finish;
    end
    //Test Case 2:
    A=-65510; B=-26; S=`SLT; L=1; CMP_T=1'b1; #10
    if((Q != L) && (CMP != CMP_T))
    begin
        $display("Test pattern 13 failed: Q=%h L=%h -- CMP=%b CMP_T=%b", Q, L, CMP, CMP_T);
        $finish;
    end
    
    //SLTU: Unsigned compare
    //Test Case 1:
    A=61; B=4294967231; S=`SLTU; L=32'd1; CMP_T=1'b1; #10
    if((Q != L) && (CMP != CMP_T))
    begin
        $display("Test pattern 14 failed: Q=%h L=%h -- CMP=%b CMP_T=%b", Q, L, CMP, CMP_T);
        $finish;
    end
    //Test Case 2:
    A=928; B=741; S=`SLTU; L=0; CMP_T=1'b0; #10
    if((Q != L) && (CMP != CMP_T))
    begin
        $display("Test pattern 15 failed: Q=%h L=%h -- CMP=%b CMP_T=%b", Q, L, CMP, CMP_T);
        $finish;
    end
    
    //------------------------------------------------------------------//
    
    //BEQ: Equal comparision
    //Test Case 1:
    A=-27650; B=-27650; S=`BEQ; CMP_T=1'b1; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 16 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    //Test Case 2:
    A=928; B=741; S=`BEQ; CMP_T=1'b0; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 17 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    
    //BNE: Unequal comparision
    //Test Case 1:
    A=-27650; B=0; S=`BNE; CMP_T=1'b1; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 18 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    //Test Case 2:
    A=742; B=742; S=`BNE; CMP_T=1'b0; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 19 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    
    //BLT: Signed lesser than comparision
    //Test Case 1:
    A=-48; B=2795; S=`BLT; CMP_T=1'b1; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 20 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    //Test Case 2:
    A=928; B=741; S=`BLT; CMP_T=1'b0; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 21 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    
    //BGE: Signed greater than or equal comparision
    //Test Case 1:
    A=-472543; B=-27; S=`BGE; CMP_T=1'b0; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 22 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    //Test Case 2:
    A=928; B=741; S=`BGE; CMP_T=1'b1; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 23 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    //Test Case 3:
    A=-923687; B=-923687; S=`BGE; CMP_T=1'b1; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 24 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    
    //BLTU: Unsigned lesser than comparison
    A=8; B=5298; S=`BLTU; CMP_T=1'b1; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 25 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    
    //BGEU: Unsigned greater than or equal comparison
    A=238; B=65298; S=`BGEU; CMP_T=1'b0; #10
    if(CMP != CMP_T)
    begin
        $display("Test pattern 26 failed: CMP=%b CMP_T=%b", CMP, CMP_T);
        $finish;
    end
    
    //Failure Cases:
    //SRA: Arithmetic shift to right
    A=32'h00F0_F0F7; B=-4; S=`SRA; L=32'h000F_0F0F; #10
    if(Q != L)
    begin
        $display("Test pattern 27 failed: Q=%h L=%h", Q, L);
        $finish;
     end
    
    $display("Simulation Successfull!");
end
endmodule
