//----------------------------------------------
// DigitsRom.v Module
// Single Port ROM              
// Digilent Basys 3             
// Bee Invaders Tutorial_6
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup DigitsRom module
module DigitsRom(
    input wire [10:0] Digitsaddress,        // 2^11 or 2047, need 110 x 13 = 1430
    input wire clk_pix,                     // pixel clock
    output reg [7:0] Digitsdout             // 8 bit pixel value from Score.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] Digitsmemory_array [0:1429]; // 8 bit values for 1430 pixels of Digits (110 x 13)

    initial 
    begin
        $readmemh("Digits.mem", Digitsmemory_array);
    end

    always@(posedge clk_pix)
            Digitsdout <= Digitsmemory_array[Digitsaddress];     
endmodule
