`timescale 1ns / 1ns

module pc_tb();

    // Testbench Outputs
    reg CLK;
    reg RES;
    reg ENABLE;
    reg MODE;
    reg [31 : 0] D;
    
    // Testbench Inputs
    wire [31 : 0] PC_OUT;
    
    //Desired Value
    reg [31:0]L; //L- Desired Output
    
    integer i;
    
    pc dut(.CLK(CLK), .RES(RES), .ENABLE(ENABLE), .MODE(MODE), .D(D),   .PC_OUT(PC_OUT));
    
        // Initialize values
        initial begin 
            CLK = 1'b0;
        end
    
        // Clock generation
        //ON TIME = (10 * 1ns) = 10ns
        //OFF TIME = (10 * 1ns) = 10ns
        //PERIOD = 20ns
        always begin
            #10 CLK = ~CLK;
        end    
    
        // Stimuli generation
        initial begin
        
        //1. RESET TEST: PC Reset with Value 0x1A00_0000
        RES = 1;
        @(negedge CLK); // wait for negative edge
        RES = 0;
        /*Inputs are don't care*/ L=32'h1A00_0000;
        if(PC_OUT != L)
        begin
            $display("Test pattern 1 failed: PC_OUT=%h L=%h", PC_OUT, L);
            $finish;
        end   
        $display("Reset test passed!");
        
        
        //2. ENABLE = 1, MODE = 0 TEST: INCREMENT BY 4
        RES=0; ENABLE=1'b1; MODE=1'b0; L=32'h1A00_0000;
        
        for(i = 1; i <= 100; i = i + 1)
        begin
            L = L + 32'd4;
            @(posedge CLK);
            @(negedge CLK);
            if(PC_OUT != L)
            begin
                $display("Test pattern 2 failed at iteration %d: PC_OUT=%h L=%h", i, PC_OUT, L);
                $finish;
            end            
        end
        $display("ENABLE = 1, Program counter incremented by 4, test passed!");
        
        
        //3. ENABLE = 0, MODE = 0 TEST: Program Counter not enabled
        RES=0; ENABLE=1'b0; MODE=1'b0; L=PC_OUT;
        for(i = 1; i <= 10; i = i + 1)
        begin
            @(posedge CLK);
            @(negedge CLK);
            if(PC_OUT != L)
            begin
                $display("Test pattern 3 failed at iteration %d: PC_OUT=%h L=%h", i, PC_OUT, L);
                $finish;
            end
        end
        $display("ENABLE = 0, Program counter not incremented, test passed!");
        
        
        //4. ENABLE = 1, MODE = 1 TEST: LOAD A JUMP ADDRESS
        RES=0; ENABLE=1'b1; MODE=1'b1; D=32'hF1E2_A960; L=D;
        @(posedge CLK);
        @(negedge CLK);
        if(PC_OUT != L)
        begin
            $display("Test pattern 4 failed: PC_OUT=%h L=%h", PC_OUT, L);
            $finish;
        end
        $display("ENABLE = 1, New Jump address loaded into Program counter, test passed!");
        
        //5. ENABLE = 0, MODE = 1 TEST: Program Counter not enabled
        RES=0; ENABLE=1'b0; MODE=1'b1; D=32'h0000_0000; L=32'hF1E2_A960;
        @(posedge CLK);
        @(negedge CLK);
        if(PC_OUT != L)
        begin
            $display("Test pattern 5 failed: PC_OUT=%h L=%h", PC_OUT, L);
            $finish;
        end
        $display("ENABLE = 0, New Jump address not loaded into Program counter, test passed!");
        
        $display("All tests passed!");
        $finish;
   end
endmodule
