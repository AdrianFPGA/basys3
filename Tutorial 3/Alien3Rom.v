//----------------------------------------------
// Alien3Rom.v Module
// Single Port ROM              
// Digilent Basys 3             
// Bee Invaders Tutorial_3
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Alien3Rom module
module Alien3Rom(
    input wire [9:0] A3address, // (9:0) or 2^10 or 1024, need 31 x 27 = 837
    input wire clk_pix,
    output reg [7:0] A3dout     // (7:0) 8 bit pixel value from Alien3.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] A3memory_array [0:836]; // 8 bit values for 837 pixels of Alien3 (31 x 27)

    initial
    begin
        $readmemh("Alien3.mem", A3memory_array);
    end

    always @ (posedge clk_pix)
            A3dout <= A3memory_array[A3address];     
endmodule