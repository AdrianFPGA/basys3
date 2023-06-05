//----------------------------------------------
// BeeSprite.v Module         
// Digilent Basys 3             
// Bee Invaders Tutorial_2
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup BeeSprite module
module BeeSprite(
    input wire clk_pix,
    input wire [9:0] sx, 
    input wire [9:0] sy,
    input wire de,
    output reg [1:0] BeeSpriteOn, // 1=on, 0=off
    output wire [7:0] dataout
    );

    // instantiate BeeRom code
    reg [9:0] address; // 2^10 or 1024, need 34 x 27 = 918
    BeeRom BeeVRom (
        .address(address),
        .clk_pix(clk_pix),
        .dataout(dataout)
    );
    
    // setup character positions and sizes
    reg [9:0] BeeX = 297; // Bee X start position
    reg [8:0] BeeY = 433; // Bee Y start position
    localparam BeeWidth = 34; // Bee width in pixels
    localparam BeeHeight = 27; // Bee height in pixels
    
    // check if sx,sy are within the confines of the Bee character
    always @ (posedge clk_pix)
    begin
        if(de)
            begin
                if(sx==BeeX-2 && sy==BeeY)  // sx=295
                    begin
                        address <= 0;       // 1st Entry: address = 0
                        BeeSpriteOn <=1;
                    end
                if((sx>BeeX-2) && (sx<BeeX+BeeWidth-1) && (sy>BeeY-1) && (sy<BeeY+BeeHeight)) // sx = 296 to 329 = 33 Entries
                    begin
                        address <= (sx+2-BeeX) + ((sy-BeeY)*BeeWidth); // 2nd Entry: address = 296 + 2 - 297 = 1
                        BeeSpriteOn <=1;
                    end
                else
                    BeeSpriteOn <=0;
            end
    end
endmodule