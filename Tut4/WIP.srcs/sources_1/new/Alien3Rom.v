//------------------------------------------------------
// Alien3Rom Module - Single Port ROM : Digilent Basys 3               
// BeeInvaders Tutorial 4 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//------------------------------------------------------
`timescale 1ns / 1ps

// Setup Alien1Rom Module
module Alien3Rom(
    input wire [9:0] i_A3addr, // (9:0) or 2^10 or 1024, need 31 x 27 = 837
    input wire i_clk2,
    output reg [7:0] o_A3data // (7:0) 8 bit pixel value from Alien3.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] A3memory_array [0:836]; // 8 bit values for 837 pixels of Alien3 (31 x 27)

    initial begin
            $readmemh("Alien3.mem", A3memory_array);
    end

    always @ (posedge i_clk2)
            o_A3data <= A3memory_array[i_A3addr];     
endmodule