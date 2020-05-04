//------------------------------------------------------
// Alien1Rom Module - Single Port ROM : Digilent Basys 3               
// BeeInvaders Tutorial 4 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//------------------------------------------------------
`timescale 1ns / 1ps

// Setup Alien1Rom Module
module Alien1Rom(
    input wire [9:0] i_A1addr, // (9:0) or 2^10 or 1024, need 31 x 26 = 806
    input wire i_clk2,
    output reg [7:0] o_A1data // (7:0) 8 bit pixel value from Alien1.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] A1memory_array [0:805]; // 8 bit values for 806 pixels of Alien1 (31 x 26)

    initial begin
            $readmemh("Alien1.mem", A1memory_array);
    end

    always @ (posedge i_clk2)
            o_A1data <= A1memory_array[i_A1addr];     
endmodule
