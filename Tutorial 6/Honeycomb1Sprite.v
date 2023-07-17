//----------------------------------------------
// Honeycomb1Sprite.v Module         
// Digilent Basys 3             
// Bee Invaders Tutorial_6
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Honeycomb1Sprite module
module Honeycomb1Sprite(
    input wire clk_pix,                         // 25.2MHz pixel clock
    input wire [9:0] sx,
    input wire [9:0] sy,
    input wire de,
    output reg [1:0] Honeycomb1SpriteOn,        // 1=on, 0=off
    output wire [7:0] Honeycomb1dout            // pixel value from Honeycomb1.mem
    );

    // instantiate Honeycomb1Rom
    reg [10:0] Honeycomb1address;               // 2^11 or 2047, need 82 x 13 = 1066
    Honeycomb1Rom Honeycomb1VRom (
        .Honeycomb1address(Honeycomb1address),
        .clk_pix(clk_pix),
        .Honeycomb1dout(Honeycomb1dout)
    );
    
    // setup Honeycomb1 character positions and sizes
    localparam Honeycomb1Width = 82;            // Score width in pixels
    localparam Honeycomb1Height = 13;           // Score height in pixels
    localparam Honeycomb1X = 279;               // Honeycomb1 X position
    localparam Honeycomb1Y = 6;                 // Honeycomb1 Y position
    
    always @ (posedge clk_pix)
    begin
        // if sx,sy are within the confines of the Score character, switch the Score On
        if(de)
            begin
                if((sx==Honeycomb1X-2) && (sy==Honeycomb1Y))              
                    begin
                        Honeycomb1address <=0;                       
                        Honeycomb1SpriteOn <=1;
                    end
                if((sx>Honeycomb1X-2) && (sx<Honeycomb1X+(Honeycomb1Width*1)-1) && (sy>Honeycomb1Y-1) && (sy<Honeycomb1Y+Honeycomb1Height))
                    begin
                        Honeycomb1SpriteOn <=1;
                            Honeycomb1address <= Honeycomb1address + 1;
                    end
                else 
                        Honeycomb1SpriteOn <=0;
            end
    end
endmodule