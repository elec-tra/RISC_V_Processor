`timescale 1ns / 1ns

module system_tb();

    reg CLK;
    reg RES;
   
    wire [31:0] data_read;
    wire [31:0] data_adr;
    wire data_req;
    wire data_gnt;    
    wire data_rvalid;
    
    proc cpu
    (
    .clk(CLK),
    .res(RES),
    .instr_read(data_read),
    .instr_gnt(data_gnt),
    .instr_r_valid(data_rvalid),
    .instr_adr(data_adr),
    .instr_req(data_req)
    );
    
    memory_sim im
    (
            .clk_i(CLK),
            .data_read(data_read),
            .data_write(32'd0),
            .data_adr(data_adr),
            .data_req(data_req),
            .data_gnt(data_gnt),
            .data_rvalid(data_rvalid),
            .data_write_enable(1'b0)
    );
    
    
    
        initial begin 
            CLK = 1'b1;
            RES = 1'b1;
        end
        
        always begin
            #40 CLK = ~CLK;
        end    
    
        initial 
        begin
            @(negedge CLK);
            @(negedge CLK);
            RES = 1'b0;
        
            repeat(100) begin
                @(negedge CLK);
            end 
        $finish;
        end
       
endmodule