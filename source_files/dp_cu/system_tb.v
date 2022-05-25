`timescale 1ns / 1ns

module system_tb();

    reg CLK;
    reg RES;
   
    wire [31:0] data_read;
    wire [31:0] data_adr;
    wire data_req;
    wire data_gnt;    
    wire data_r_valid;
    wire [31 : 0] data_write;
    wire data_write_enable;
    
   	wire [31 : 0] instr_read;
    wire instr_gnt;
    wire instr_r_valid;
	wire [31 : 0] instr_adr;
    wire instr_req;

    
    proc cpu
    (
    .clk(CLK),
    .res(RES),
    
    .instr_read(instr_read),
    .instr_gnt(instr_gnt),
    .instr_r_valid(instr_r_valid),
    .instr_adr(instr_adr),
    .instr_req(instr_req),
    
    .data_read(data_read),
    .data_gnt(data_gnt),
    .data_r_valid(data_r_valid),
    .data_write(data_write),
    .data_adr(data_adr),
    .data_req(data_req),
    .data_write_enable(data_write_enable)
    
    );
    
    memory_sim im // Instruction Memory
    (
            .clk_i(CLK),
            .data_read(instr_read),
            .data_write(32'd0),
            .data_adr(instr_adr),
            .data_req(instr_req),
            .data_gnt(instr_gnt),
            .data_rvalid(instr_r_valid),
            .data_write_enable(1'b0)
    );
    
    memory_sim_2 dm // Data Memory
    (
            .clk_i(CLK),
            .data_read(data_read),
            .data_write(data_write),
            .data_adr(data_adr),
            .data_req(data_req),
            .data_gnt(data_gnt),
            .data_rvalid(data_r_valid),
            .data_write_enable(data_write_enable)
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
        
            repeat(10) begin
                @(negedge CLK);
            end 
        $finish;
        end
       
endmodule