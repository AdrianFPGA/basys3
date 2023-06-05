//----------------------------------------------
// Alien2Rom.v Module
// Single Port ROM              
// Digilent Basys 3             
// Bee Invaders Tutorial_3
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Alien2Rom module
module Alien2Rom(
    input wire [9:0] A2address, // (9:0) or 2^10 or 1024, need 31 x 21 = 651
    input wire clk_pix,
    output reg [7:0] A2dout     // (7:0) 8 bit pixel value from Alien2.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] A2memory_array [0:650]; // 8 bit values for 651 pixels of Alien2 (31 x 21)

    initial
    begin
        $readmemh("Alien2.mem", A2memory_array);
    end

    always @ (posedge clk_pix)
            A2dout <= A2memory_array[A2address];     
endmodule
