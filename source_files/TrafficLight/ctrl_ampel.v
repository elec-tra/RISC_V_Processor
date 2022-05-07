module ctrl_ampel(
    //input TICK,
    input RES,
    input CLK,
    input BTN,
    
    output CNTR_RES, 
    output [2 : 0] RGB);
    
     //parameter CLOCK_SIGNALS = 32'd10; //for 2Hz
    parameter CLOCK_SIGNALS = 32'd500000000; //for 100 MHz
   
    
    reg [2 : 0] state; // state = 3'd1, 3'd2, 3'd3, 3'd4, 3'd5 
    reg [2 : 0] rgb_val;
    reg  tmr_res;
    
    wire TICK;
    
    // connect timer to control unit
    timer tmr(.RES(CNTR_RES), .CLK(CLK), .TICK(TICK));
    defparam tmr.CLOCK_SIGNALS = CLOCK_SIGNALS;
    
    //state transition based on clock and reset
    always @(posedge CLK, posedge RES)
    begin
        if(RES == 1'b1) begin 
            state = 3'd1;
            tmr_res = 1'd1;  
         end       
        
        else begin 
        
            //tmr_res = 1'd0;  
                
            case(state)
            
                3'd1 : begin 
                if (BTN == 1'b1) begin
                    state = 3'd2;
                    tmr_res = 1'd1;
                    end   
                end
                
                3'd2 : begin 
                tmr_res = 1'd0;
                if (TICK == 1'b1) begin
                    state = 3'd3;
                    tmr_res = 1'd1;
                    end    
                end
                
                3'd3 : begin
                tmr_res = 1'd0; 
                if (TICK == 1'b1) begin
                    state = 3'd4;
                    tmr_res = 1'd1;
                    end               
                end
                
                3'd4 : begin
                tmr_res = 1'd0;
                if (TICK == 1'b1) begin
                    state = 3'd5;
                    tmr_res = 1'd1;
                    end          
                end
                
                3'd5 : begin
                tmr_res = 1'd0;
                if (TICK == 1'b1) begin
                    state = 3'd1;
                    tmr_res = 1'd1; 
                    end   
                end
                
                default : state = 3'd1;
               
            endcase 
             
        end
           
    end
    
    //outputs based on current state
    always @(state)
    begin
        case(state)
            3'd1 : rgb_val <= 3'b100; //RED
            3'd2 : rgb_val <= 3'b100; //RED
            3'd3 : rgb_val <= 3'b110; //YELLOW
            3'd4 : rgb_val <= 3'b010; //GREEN
            3'd5 : rgb_val <= 3'b110; // YELLOW
            default : rgb_val <= 3'b100; // Any invalid state should bring to initial red value
        endcase
    end
    
    assign RGB = rgb_val;
    assign CNTR_RES = tmr_res;
    
endmodule