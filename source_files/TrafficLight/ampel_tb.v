`timescale 1ms / 1ms

module ampel_tb();

    reg RESN, CLK, BTN;
    wire [2 : 0] RGB;
    
    // TrafficLight(ampel) DUT instantiation
    ampel dut(.RESN(RESN), .CLK(CLK), .BTN(BTN), .RGB(RGB));
    
    // Overriding the CLOCK_SIGNALS parameter according to clock freq
    defparam dut.CLOCK_SIGNALS = 32'd10;
    
    //Initialize clock and other stuff
    initial 
    begin
        RESN = 1'b0;
        BTN = 1'b0;
        CLK = 1'b0;
    end
    
    //clock generation (2MHz for now)
    always #250 CLK = !CLK;
    
    //Stimuli generation
    initial
    begin  
        @(negedge CLK); // wait for a negative edge
        RESN = 1'b1;
        BTN = 1'b1;
        repeat(3) begin
            @(negedge CLK);
        end   
        BTN = 1'b0;
        
        
        
        #35000 $finish;
    end
      

endmodule