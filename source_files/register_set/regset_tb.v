`timescale 1ns / 1ns;

module regset_tb();

    // Inputs
    reg CLK;
    reg RES;
    reg write_enable;
    reg [31 : 0] D;
    reg [4 : 0] A_D;
    reg [4 : 0] A_Q0;
    reg [4 : 0] A_Q1;
    
    // Outputs
    wire [31 : 0] Q0;
    wire [31 : 0] Q1;
    
    integer i;
    
    // Initialise DUT
    regset dut(.CLK(CLK),
               .RES(RES),
               .write_enable(write_enable),
               .D(D),
               .A_D(A_D),
               .A_Q0(A_Q0),
               .A_Q1(A_Q1),
               .Q0(Q0),
               .Q1(Q1));
    
    // Initialize values
    initial begin 
        CLK = 1'b0;
    end
    
    // Clock generation
    always begin
        #5 CLK = ~CLK;
    end    
    
   // Stimuli generation
   initial begin
        
        RES = 1;
        @(negedge CLK); // wait for negative edge
        RES = 0;
        
        // Check whether all registers reset or not
        for(i = 0; i < 32; i = i + 1)
        begin
        
            A_Q0 = i; A_Q1 = i;
            @(negedge CLK);
            
            if(Q0 != 32'd0 || Q1 != 32'd0)
            begin
                $display("Fault in Reset");
                $finish;
            end    
            
        end
        
        $display("Reset test passed!");
        
        //write and read tests for general purpose registers
        $srandom(42); // Seeding the random number generator
        
        for(i = 1; i < 32; i = i + 1)
        begin
            D = $urandom;
            A_D = i;
            write_enable = 1'b1; 
            A_Q0 = i; A_Q1 = i;
            @(negedge CLK);
            write_enable = 1'b0;
            if(Q0 != D && Q0 != D) begin
                $display("Fault in General Purpose read/write");
                $finish;
            end            
        end
        
        $display("General Purpose read/write passed!");
        
        // Checking the R0 read/write
        D = $urandom;
        A_D = 5'd0;
        write_enable = 1'b1; 
        A_Q0 = 5'd0; A_Q1 = 5'd0;
        @(negedge CLK);
        write_enable = 1'b0;
        if(Q0 != 32'd0 && Q0 != 32'd0) begin
            $display("Fault in R0 read/write");
            $finish;
        end  
        
        $display("R0 read/write passed!");
        $display("All tests passed!");
        $finish;                  
   end

endmodule