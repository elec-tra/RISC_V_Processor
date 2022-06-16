`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2022 07:26:01 PM
// Design Name: 
// Module Name: test_tb
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


module test_tb();
reg t_a, t_b;
wire t_output;

test dut(.a(t_a), .b(t_b), .y(t_output));
initial
begin
    t_a = 0; t_b = 0;
    #10
    t_a = 1; t_b = 0;
    #10
    t_a = 0; t_b = 1;
    #10
    t_a = 1; t_b = 1;
    #10
    $stop;
end
endmodule
