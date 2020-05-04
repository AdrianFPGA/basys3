//-----------------------------------------------------
// Hive5Rom Module - Single Port ROM : Digilent Basys 3               
// BeeInvaders Tutorial 4 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//-----------------------------------------------------
`timescale 1ns / 1ps

// Setup Hive5Rom Module
module Hive5Rom(
    input wire [11:0] i_addr, // (11:0) or 2^12 or 4096, need 56 x 39 = 2184
    input wire i_clk2,
    output reg [7:0] o_data // (7:0) 8 bit pixel value from Hive5
    );

    (*ROM_STYLE="block"*) reg [7:0] H5memory_array [0:2183]; // 8 bit values for 2184 pixels of Hive5 (56 x 39)

    initial begin
            $readmemh("Hive1.mem", H5memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= H5memory_array[i_addr];     
endmodule