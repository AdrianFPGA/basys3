//----------------------------------------------
// BBulletRom.v Module
// Single Port ROM              
// Digilent Basys 3             
// Bee Invaders Tutorial_5
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup BBulletRom module
module BBulletRom(
    input wire [3:0] BBaddress, // 2^4 or 15, need 1 x 7 = 7
    input wire clk_pix,
    output reg [7:0] BBdout     // (7:0) 8 bit pixel value from BBullet.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] BBmemory_array [0:6]; // 8 bit values for 7 pixels of BBullet (1 x 7)

    initial
    begin
        $readmemh("BBullet.mem", BBmemory_array);
    end

    always @ (posedge clk_pix)
            BBdout <= BBmemory_array[BBaddress];     
endmodule