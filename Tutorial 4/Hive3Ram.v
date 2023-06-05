//----------------------------------------------
// Hive3Ram.v Module - Single Port RAM               
// Digilent Basys 3             
// Bee Invaders Tutorial_4
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Hive3Ram Module
module Hive3Ram(
    input wire clk_pix,
    input wire [11:0] H3address,    // (11:0) or 2^12 or 4096, need 56 x 39 = 2184
    output reg [7:0] H3dout,        // (7:0) 8 bit pixel value from Hive1
    input wire write,               // 1=write, 0=read data
    input wire [7:0] data           // (7:0) 8 bit pixel value to Hive1
    );

    (*ROM_STYLE="block"*) reg [7:0] H3memory_array [0:2183]; // 8 bit values for 2184 pixels of Hive1 (56 x 39)

    initial begin
            $readmemh("Hive1.mem", H3memory_array);
    end

    always @ (posedge clk_pix)
         if(write)
            H3memory_array[H3address] <= data;
        else
            H3dout <= H3memory_array[H3address]; 
endmodule