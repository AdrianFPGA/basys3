//----------------------------------------------
// Hive4Ram.v Module - Single Port RAM              
// Digilent Basys 3             
// Bee Invaders Tutorial_6
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Hive4Ram Module
module Hive4Ram(
    input wire clk_pix,
    input wire [11:0] H4address,        // Address to read/write data from/to Hive4 (2^12 or 4095, need 66 x 39 = 2574)
    input wire [1:0] write4,            // 1 = write, 0 = read data
    input wire [7:0] data4,             // 8 bit pixel value to Hive4
    output reg [7:0] H4dout             // 8 bit pixel value from Hive4
    );

    (*RAM_STYLE="block"*) reg [7:0] H4memory_array [0:2573]; // 8 bit values for 2574 pixels of Hive4 (66 x 39)
    initial $readmemh("Hive1.mem", H4memory_array);
            
    always @ (posedge clk_pix)   
        if (write4==1)
            H4memory_array[H4address] <= data4;      
        else
            H4dout <= H4memory_array[H4address]; 
endmodule