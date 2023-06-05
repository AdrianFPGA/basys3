//----------------------------------------------
// Hive2Ram.v Module - Single Port RAM               
// Digilent Basys 3             
// Bee Invaders Tutorial_4
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Hive2Ram Module
module Hive2Ram(
    input wire clk_pix,
    input wire [11:0] H2address,    // (11:0) or 2^12 or 4096, need 56 x 39 = 2184
    output reg [7:0] H2dout,        // (7:0) 8 bit pixel value from Hive1
    input wire write,               // 1=write, 0=read data
    input wire [7:0] data           // (7:0) 8 bit pixel value to Hive1
    );

    (*ROM_STYLE="block"*) reg [7:0] H2memory_array [0:2183]; // 8 bit values for 2184 pixels of Hive1 (56 x 39)

    initial begin
            $readmemh("Hive1.mem", H2memory_array);
    end

    always @ (posedge clk_pix)
         if(write)
            H2memory_array[H2address] <= data;
        else
            H2dout <= H2memory_array[H2address]; 
endmodule