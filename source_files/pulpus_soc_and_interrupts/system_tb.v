`timescale 1ns/1ps

module system_tb();

    wire clk;
    wire BOARD;
    
    system sys(.BOARD_CLK(), .BOARD_RESN);

`ifdef XILINX_SIMULATOR
// Vivado Simulator (XSim) specific code
initial
begin
clk=0;
end
always
#5 clk=~clk;
`else
always @(BOARD_CLK)
clk=BOARD_CLK;
`endif

endmodule