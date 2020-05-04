//------------------------------------------------------
// Alien2Rom Module - Single Port ROM : Digilent Basys 3               
// BeeInvaders Tutorial 4 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//------------------------------------------------------
`timescale 1ns / 1ps

// Setup Alien1Rom Module
module Alien2Rom(
    input wire [9:0] i_A2addr, // (9:0) or 2^10 or 1024, need 31 x 21 = 651
    input wire i_clk2,
    output reg [7:0] o_A2data // (7:0) 8 bit pixel value from Alien2.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] A2memory_array [0:650]; // 8 bit values for 651 pixels of Alien2 (31 x 21)

    initial begin
            $readmemh("Alien2.mem", A2memory_array);
    end

    always @ (posedge i_clk2)
            o_A2data <= A2memory_array[i_A2addr];     
endmodule