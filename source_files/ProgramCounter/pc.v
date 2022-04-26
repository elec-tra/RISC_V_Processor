`timescale 1ns / 1ps

module pc(
    input [31 : 0] D,
    input ENABLE,
    input CLK,
    input RES,
    input MODE,
    output reg [31 : 0] PC_OUT
);

    always @(posedge CLK)
    begin
        if(RES == 1'b1) begin //RESET LOGIC
            PC_OUT <= 32'h1A00_0000;
        end

        else if((ENABLE == 1'b1) && (MODE == 1'b0)) begin //INCREMENT BY 4 LOGIC
            PC_OUT <= PC_OUT + 32'd4;
        end
        
        else if((ENABLE == 1'b1) && (MODE == 1'b1)) begin //JUMP TO ADDRESS LOGIC
            PC_OUT <= D;
        end
    end 
    
endmodule
