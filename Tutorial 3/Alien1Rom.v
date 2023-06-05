//----------------------------------------------
// Alien1Rom.v Module
// Single Port ROM              
// Digilent Basys 3             
// Bee Invaders Tutorial_3
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Alien1Rom module
module Alien1Rom(
    input wire [9:0] A1address, // (9:0) or 2^10 or 1024, need 31 x 26 = 806
    input wire clk_pix,
    output reg [7:0] A1dout     // (7:0) 8 bit pixel value from Alien1.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] A1memory_array [0:805]; // 8 bit values for 806 pixels of Alien1 (31 x 26)

    initial
    begin
        $readmemh("Alien1.mem", A1memory_array);
    end

    always @ (posedge clk_pix)
            A1dout <= A1memory_array[A1address];     
endmodule