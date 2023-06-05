//----------------------------------------------
// Hive3Ram.v Module - Single Port RAM               
// Digilent Basys 3             
// Bee Invaders Tutorial_5
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Hive3Ram Module
module Hive3Ram(
    input wire clk_pix,
    input wire [11:0] H3address,        // Address to read/write data from/to Hive3 (2^12 or 4095, need 66 x 39 = 2574)
    input wire [1:0] write3,            // 1 = write, 0 = read data
    input wire [7:0] data3,             // 8 bit pixel value to Hive3
    output reg [7:0] H3dout             // 8 bit pixel value from Hive3
    );

    (*RAM_STYLE="block"*) reg [7:0] H3memory_array [0:2573]; // 8 bit values for 2574 pixels of Hive3 (66 x 39)
    initial $readmemh("Hive1.mem", H3memory_array);
            
    always @ (posedge clk_pix)   
        if (write3==1)
            H3memory_array[H3address] <= data3;      
        else
            H3dout <= H3memory_array[H3address]; 
endmodule