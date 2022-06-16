module timer(
    input RES,
    input CLK,
    
    output TICK
);

    //parameter CLOCK_SIGNALS = 32'd10; //for 2Hz
    parameter CLOCK_SIGNALS = 32'd500000000; //for 100 MHz
   
    reg [ 31 : 0 ] count = 32'd0;
    reg tick_val = 1'b0;
     
    always @(posedge CLK, posedge RES)
    begin
    
        if(RES == 1'b1) begin
            tick_val = 1'b0;
            count = 32'd0;
        end    
            
        else begin
        
            if(count == (CLOCK_SIGNALS - 1)) // 0 is included as well
                tick_val = 1'b1;
           
            else 
                count = count + 1;
                
        end
        
    end
    
    assign TICK = tick_val;
    

endmodule
