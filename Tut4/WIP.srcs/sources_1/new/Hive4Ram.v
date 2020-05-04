//-----------------------------------------------------
// Hive4Ram Module - Single Port RAM : Digilent Basys 3               
// BeeInvaders Tutorial 4 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//-----------------------------------------------------
`timescale 1ns / 1ps

// Setup Hive4Ram Module
module Hive4Ram(
    input wire [11:0] i_addr, // (11:0) or 2^12 or 4096, need 56 x 39 = 2184
    input wire i_clk2,
    output reg [7:0] o_data, // (7:0) 8 bit pixel value from Hive4
    input wire i_write, // 1=write, 0=read data
    input wire [7:0] i_data // (7:0) 8 bit pixel value to Hive4
    );

    (*ROM_STYLE="block"*) reg [7:0] H4memory_array [0:2183]; // 8 bit values for 2184 pixels of Hive4 (56 x 39)

    initial begin
            $readmemh("Hive1.mem", H4memory_array);
    end

    always @ (posedge i_clk2)
         if(i_write)
            H4memory_array[i_addr] <= i_data;
        else
            o_data <= H4memory_array[i_addr]; 
endmodule