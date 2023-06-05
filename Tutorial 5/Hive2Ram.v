//----------------------------------------------
// Hive2Ram.v Module - Single Port RAM               
// Digilent Basys 3             
// Bee Invaders Tutorial_5
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Hive2Ram Module
module Hive2Ram(
    input wire clk_pix,
    input wire [11:0] H2address,        // Address to read/write data from/to Hive2 (2^12 or 4095, need 66 x 39 = 2574)
    input wire [1:0] write2,            // 1 = write, 0 = read data
    input wire [7:0] data2,             // 8 bit pixel value to Hive2
    output reg [7:0] H2dout             // 8 bit pixel value from Hive2
    );

    (*RAM_STYLE="block"*) reg [7:0] H2memory_array [0:2573]; // 8 bit values for 2574 pixels of Hive2 (66 x 39)
    initial $readmemh("Hive1.mem", H2memory_array);
            
    always @ (posedge clk_pix)   
        if (write2==1)
            H2memory_array[H2address] <= data2;      
        else
            H2dout <= H2memory_array[H2address]; 
endmodule