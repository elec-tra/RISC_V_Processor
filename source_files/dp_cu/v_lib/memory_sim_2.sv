`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2018 17:28:44
// Design Name: 
// Module Name: tb_dummy_mem_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module memory_sim_2
#(
  parameter MP          = 1,
  parameter MEMORY_SIZE = 265600,
  parameter BASE_ADDR   = 32'h0000_0000,
  parameter PROB_STALL  = 0.0,
  parameter TCP         = 40.0ns, // clock period, 1GHz clock
  parameter TA          = 0.8ns, // application time
  parameter TT          = 3.2ns,  // test time
  parameter MEMORY_INIT_FILE="simulate2.mem"
)
(
        input clk_i,
        output[31:0] data_read,
        input [31:0] data_write,
        input [31:0] data_adr,
        input data_req,
        output data_gnt,
        output data_rvalid,
        input data_write_enable
        /*,
        input randomize_i,
        input enable_i*/
    );
    
    tb_dummy_memory_pulp #(
        .MP(1),
        .MEMORY_SIZE(MEMORY_SIZE),
        .BASE_ADDR(BASE_ADDR),
        .PROB_STALL(PROB_STALL),
        .TCP(TCP),
        .TA(TA),
        .TT(TT),
        .MEMORY_INIT_FILE(MEMORY_INIT_FILE)
    ) dummy (
        .clk_i(clk_i),
        //.randomize_i(randomize_i),
        .randomize_i(1'b0),
        //.enable_i(enable_i),
        .enable_i(1'b1),
        .tcdm_req_i(data_req),
        .tcdm_data_i(data_write),
        .tcdm_wen_i(~data_write_enable),
        .tcdm_be_i(1'b1),
        .tcdm_add_i(data_adr),
        .tcdm_gnt_o(data_gnt),
        .tcdm_r_valid_o(data_rvalid),
        .tcdm_r_data_o(data_read)
    );

endmodule

module tb_dummy_memory_pulp
#(
  parameter MP          = 1,
  parameter MEMORY_SIZE = 1024,
  parameter BASE_ADDR   = 0,
  parameter PROB_STALL  = 0.0,
  parameter TCP         = 1.0ns, // clock period, 1GHz clock
  parameter TA          = 0.2ns, // application time
  parameter TT          = 0.8ns,  // test time
  parameter MEMORY_INIT_FILE="simulate.mem"
)
(
  input  logic                clk_i,
  input  logic                randomize_i,
  input  logic                enable_i,
  input  logic                tcdm_req_i     ,
  input  logic  [31:0]        tcdm_add_i     ,
  input  logic                tcdm_wen_i     ,
  input  logic                tcdm_be_i      ,
  input  logic  [31:0]        tcdm_data_i    ,
  output  logic               tcdm_gnt_o     ,
  output  logic [31:0]        tcdm_r_data_o  ,
  output  logic               tcdm_r_valid_o 
);

  //logic [MEMORY_SIZE-1:0][31:0] memory;
  int cnt = 0;

  logic [MP-1:0]       tcdm_req;
  logic [MP-1:0]       tcdm_gnt;
  logic [MP-1:0][31:0] tcdm_add;
  logic [MP-1:0]       tcdm_wen;
  logic [MP-1:0][3:0]  tcdm_be;
  logic [MP-1:0][31:0] tcdm_data;
  logic [MP-1:0][31:0] tcdm_r_data;
  logic [MP-1:0]       tcdm_r_valid;
  logic [MP-1:0][31:0] tcdm_r_data_int;
  logic [MP-1:0]       tcdm_r_valid_int;

  real probs [MP-1:0];

  logic clk_delayed;
  wire [31:0] read_tmp;
  xpm_memory_spram # (
    .MEMORY_SIZE        ( MEMORY_SIZE ),
    .MEMORY_PRIMITIVE   ( "block"                              ),
    .MEMORY_INIT_FILE   ( MEMORY_INIT_FILE                     ),
    //.MEMORY_INIT_FILE   ( "none"                       ),
    .MEMORY_INIT_PARAM  ( ""                                   ),
    .USE_MEM_INIT       ( 1                                    ),
    .WAKEUP_TIME        ( "disable_sleep"                      ),
    .MESSAGE_CONTROL    ( 0                                    ),
    .WRITE_DATA_WIDTH_A ( 32                                   ),
    .READ_DATA_WIDTH_A  ( 32                                   ),
    .BYTE_WRITE_WIDTH_A ( 8                                    ),
    .ADDR_WIDTH_A       ( 32                                   ),
    //      ),
    .READ_RESET_VALUE_A ( "0"                                  ),
    .ECC_MODE           ( "no_ecc"                             ),
    .AUTO_SLEEP_TIME    ( 0                                    ),
    .READ_LATENCY_A     ( 1                                    ),
    .WRITE_MODE_A       ( "read_first"                         )
  ) memory (
    .sleep          ( 1'b0                                 ),
    .clka           ( clk_i                                ),
    .rsta           ( 1'b0                                 ),
    .ena            ( 1'b1                                    ),
    .regcea         ( 1'b1                                 ),
    .wea            ( {4{tcdm_gnt[0] & ~tcdm_wen[0]}}            ),
    .addra          ((tcdm_add[0]-BASE_ADDR) >> 2           ),
    //$clog2(DATA_WIDTH/8)] ),
    .dina           ( tcdm_data[0]                          ),
    .injectsbiterra ( 1'b0                                 ),
    .injectdbiterra ( 1'b0                                 ),
    .douta          ( read_tmp                              ),
    .sbiterra       (                                      ),
    .dbiterra       (                                      )
  );

/*
          tcdm_r_data_int  [i] <= memory[(tcdm_add[i]-BASE_ADDR) >> 2];
tcdm_r_valid_int [i] <= tcdm_gnt[i];
end
// write
else if (tcdm_gnt[i] & ~tcdm_wen[i]) begin
memory[(tcdm_add[i]-BASE_ADDR) >> 2] <= tcdm_data [i];
*/
  always_ff @(posedge clk_i)
  begin : probs_proc
    for (int i=0; i<MP; i++) begin
      probs[i] = real'($urandom_range(0,1000))/1000.0;
    end
  end

  //generate

    for(genvar i=0; i<MP; i++) begin
      assign tcdm_gnt[i] = (probs[i] < PROB_STALL) ? 1'b0 : 1'b1;
    end

    //for(genvar ii=0; ii<MP; ii++) begin : binding_gen
      assign tcdm_req      [0] = tcdm_req_i;
      assign tcdm_add      [0] = tcdm_add_i;
      assign tcdm_wen      [0] = tcdm_wen_i;
      assign tcdm_be       [0] = tcdm_be_i;
      assign tcdm_data     [0] = tcdm_data_i;
      assign tcdm_gnt_o     = tcdm_gnt [0] & tcdm_req [0];
      assign tcdm_r_data_o  = (tcdm_r_valid [0]==1'b1) ? read_tmp : tcdm_r_data  [0];
      assign tcdm_r_valid_o = tcdm_r_valid [0];
    //end
/*
    for(genvar i=0; i<MEMORY_SIZE; i++) begin : outer
      always_ff @(posedge clk_i)
      begin
        if(randomize_i)
          memory[i] = $random();
      end
    end*/

 // endgenerate

  // assign clk_delayed = #(TA) clk_i;
  always @(clk_i)
  begin
    clk_delayed <= #(TA) clk_i;
  end

  always_ff @(posedge clk_i)
  begin : dummy_proc
    for (int i=0; i<MP; i++) begin
      if ((tcdm_req[i] & enable_i) == 1'b0) begin
        tcdm_r_data_int  [i] <= 'z;
        tcdm_r_valid_int [i] <= 1'b0;
      end
      else begin
        // read
        if (tcdm_gnt[i] & tcdm_wen[i]) begin
          tcdm_r_data_int  [i] <= read_tmp;
          tcdm_r_valid_int [i] <= tcdm_gnt[i];
        end
        // write
        else if (tcdm_gnt[i] & ~tcdm_wen[i]) begin
          //memory[(tcdm_add[i]-BASE_ADDR) >> 2] <= tcdm_data [i];//done
          tcdm_r_data_int  [i] <= tcdm_data [i];
          tcdm_r_valid_int [i] <= 1'b1;
        end
        // no-grant
        else if (~tcdm_gnt[i]) begin
          tcdm_r_data_int  [i] <= 'x;
          tcdm_r_valid_int [i] <= 1'b0;
        end
        else begin
          tcdm_r_data_int  [i] <= 'z;
          tcdm_r_valid_int [i] <= 1'b0;
        end
      end
    end
  end

  always_ff @(posedge clk_delayed)
  begin
    tcdm_r_data  <= tcdm_r_data_int;
    tcdm_r_valid <= tcdm_r_valid_int;
  end

endmodule // tb_dummy_memory

