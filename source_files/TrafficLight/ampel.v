module ampel(
    input BTN,
    input RESN,
    input CLK,
    output [2 : 0] RGB);
    
    //parameter CLOCK_SIGNALS = 32'd10; //for 2Hz
   parameter CLOCK_SIGNALS = 32'd500000000; //for 100 MHz

    //Instantiating the control unit which contains timer as well
    ctrl_ampel cu(.BTN(BTN), .RES(!RESN), .CLK(CLK), .RGB(RGB));
    defparam cu.CLOCK_SIGNALS = CLOCK_SIGNALS;
   
endmodule