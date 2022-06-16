`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2022 10:51:02 AM
// Design Name: 
// Module Name: fa_tb
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


module fa_tb();
reg t_a, t_b, t_cin;
wire t_sum, t_cout;

fa dut(.a(t_a), .b(t_b), .c_in(t_cin), .s(t_sum), .c_out(t_cout));
initial
begin
    t_a = 0; t_b = 0; t_cin = 0;
    #10
    t_a = 0; t_b = 0; t_cin = 1;
    #10
    t_a = 0; t_b = 1; t_cin = 0;
    #10
    t_a = 0; t_b = 1; t_cin = 1;
    #10
    //------------------------//
    t_a = 1; t_b = 0; t_cin = 0;
    #10
    t_a = 1; t_b = 0; t_cin = 1;
    #10
    t_a = 1; t_b = 1; t_cin = 0;
    #10
    t_a = 1; t_b = 1; t_cin = 1;
    #10
    $stop;
end
endmodule
