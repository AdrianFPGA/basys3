//----------------------------------------------
// Honeycomb1Rom.v Module
// Single Port ROM              
// Digilent Basys 3             
// Bee Invaders Tutorial_6
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Honeycomb1Rom module
module Honeycomb1Rom(
    input wire [10:0] Honeycomb1address,    // (2^11 or 2047, need 82 x 13 = 1066
    input wire clk_pix,                     // pixel clock
    output reg [7:0] Honeycomb1dout         // 8 bit pixel value from Honeycomb1.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] Honeycomb1memory_array [0:1065]; // 8 bit values for 1066 pixels of Honeycomb1

    initial 
    begin
        $readmemh("Honeycomb1.mem", Honeycomb1memory_array);
    end

    always@(posedge clk_pix)
            Honeycomb1dout <= Honeycomb1memory_array[Honeycomb1address];     
endmodule
