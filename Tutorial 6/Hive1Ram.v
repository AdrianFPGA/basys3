//----------------------------------------------
// Hive1Ram.v Module - Single Port RAM              
// Digilent Basys 3             
// Bee Invaders Tutorial_6
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Hive1Ram Module
module Hive1Ram(
    input wire clk_pix,
    input wire [11:0] H1address,        // Address to read/write data from/to Hive1 (2^12 or 4095, need 66 x 39 = 2574)
    input wire [1:0] write1,            // 1 = write, 0 = read data
    input wire [7:0] data1,             // 8 bit pixel value to Hive1
    output reg [7:0] H1dout             // 8 bit pixel value from Hive1
    );

    (*RAM_STYLE="block"*) reg [7:0] H1memory_array [0:2573]; // 8 bit values for 2574 pixels of Hive1 (66 x 39)
    initial $readmemh("Hive1.mem", H1memory_array);
            
    always @ (posedge clk_pix)   
        if (write1==1)
            H1memory_array[H1address] <= data1;      
        else
            H1dout <= H1memory_array[H1address]; 
endmodule