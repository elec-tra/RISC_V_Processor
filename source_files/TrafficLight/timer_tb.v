`timescale 1ms / 1ms

module timer_tb();

    reg RES, CLK;
    wire TICK;
    
    // Timer DUT instantiation
    timer dut(.RES(RES), .CLK(CLK), .TICK(TICK));
    
    // Overriding the CLOCK_SIGNALS parameter according to clock freq
    defparam dut.CLOCK_SIGNALS = 32'd10;
    
    //Initialize clock and other stuff
    initial 
    begin
        RES = 1'b1;
        CLK = 1'b0;
    end
    
    //clock generation (2MHz for now)
    always #250 CLK = !CLK;
    
    //Stimuli generation
    initial
    begin  
        @(negedge CLK); // wait for a negative edge
        RES = 1'b0;
        
        @(posedge TICK); // wait for TICK to get 1
        $finish;
    end
      

endmodule