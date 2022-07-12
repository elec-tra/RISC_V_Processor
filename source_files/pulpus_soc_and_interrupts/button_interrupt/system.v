module system(
    input BOARD_CLK,
    input BOARD_RESN,
    input [3 : 0] BOARD_BUTTON,
    input [3 : 0] BOARD_SWITCH,
    input BOARD_UART_RX,
    
    output [3 : 0] BOARD_LED,
    output [2 : 0] BOARD_LED_RGB0,
    output [2 : 0] BOARD_LED_RGB1,
    output BOARD_VGA_HSYNC,
    output BOARD_VGA_VSYNC,
    output [3 : 0] BOARD_VGA_R,
    output [3 : 0] BOARD_VGA_G,
    output [3 : 0] BOARD_VGA_B,
    output BOARD_UART_TX
);

    wire CLK;
    wire RES;
    
    reg [3 : 0] button_array;
    
    // reg test
    reg clk;
   
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
    
    wire irq;
    wire [4 : 0] irq_id;
    wire irq_ack;
	wire [4 : 0] irq_ack_id;


pulpus psoc(
/* BOARD SIGNALS */
     .BOARD_CLK(clk),
     .BOARD_RESN(BOARD_RESN),   
     
     .BOARD_LED(BOARD_LED),
     .BOARD_LED_RGB0(BOARD_LED_RGB0),
     .BOARD_LED_RGB1(BOARD_LED_RGB1),
     
     .BOARD_BUTTON(BOARD_BUTTON),
//     .BOARD_BUTTON(button_array),
     .BOARD_SWITCH(BOARD_SWITCH),
     
     .BOARD_VGA_HSYNC(BOARD_VGA_HSYNC),
     .BOARD_VGA_VSYNC(BOARD_VGA_VSYNC),
     .BOARD_VGA_R(BOARD_VGA_R),
     .BOARD_VGA_B(BOARD_VGA_B),
     .BOARD_VGA_G(BOARD_VGA_G),      
     .BOARD_UART_RX(BOARD_UART_RX),
     .BOARD_UART_TX(BOARD_UART_TX), 
      
     /* CORE SIGNALS */
         .CPU_CLK(CLK),  
         .CPU_RES(RES),
     //output .CACHE_RES,
      
      // Instruction memory interface
         .INSTR_REQ(instr_req),
         .INSTR_GNT(instr_gnt),
         .INSTR_RVALID(instr_r_valid),
         .INSTR_ADDR(instr_adr),
         .INSTR_RDATA(instr_read),
   
      // Data memory interface
         .DATA_REQ(data_req),
         .DATA_GNT(data_gnt),
         .DATA_RVALID(data_r_valid),
         .DATA_WE(data_write_enable),
         .DATA_BE(4'b1111),
         .DATA_ADDR(data_adr),
         .DATA_WDATA(data_write),
         .DATA_RDATA(data_read),
         
         //Interrupt outputs
         .IRQ(irq),                 // level sensitive IR lines
         .IRQ_ID(irq_id),
         //Interrupt inputs
         .IRQ_ACK(irq_ack),             // irq ack
         .IRQ_ACK_ID(irq_ack_id)
     );
     
proc cpu(
.clk(CLK),
.res(RES),

.instr_read_in(instr_read),
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
.data_write_enable(data_write_enable),
.irq(irq),
.irq_id(irq_id),
.irq_ack(irq_ack),
.irq_ack_id(irq_ack_id)
);

`ifdef XILINX_SIMULATOR
// Vivado Simulator (XSim) specific code
initial
begin
clk=0;
end
always
#5 clk=~clk;

initial
    begin  
        button_array = 4'b0000;
        repeat(125) begin
            @(negedge CLK);
        end
        button_array = 4'b0001;
        repeat(2) begin
            @(negedge CLK);
        end
        button_array = 4'b0000;
    end
`else
always @(BOARD_CLK)
clk=BOARD_CLK;
`endif

endmodule
