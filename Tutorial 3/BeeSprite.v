//----------------------------------------------
// BeeSprite.v Module         
// Digilent Basys 3             
// Bee Invaders Tutorial_3
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
    output reg [1:0] BeeSpriteOn,   // 1=on, 0=off
    input wire btnR,                // right button
    input wire btnL,                // left button
    output wire [7:0] dataout
    );

    // instantiate BeeRom code
    reg [9:0] address;              // 2^10 or 1024, need 34 x 27 = 918
    BeeRom BeeVRom (
        .address(address),
        .clk_pix(clk_pix),
        .dataout(dataout)
    );
    
    // Instantiate Debounce
    wire sig_right;
    wire sig_left;
    
    Debounce deb_right (
        .clk_pix(clk_pix),
        .btn(btnR),
        .out(sig_right)
    );
    
    Debounce deb_left (
        .clk_pix(clk_pix),
        .btn(btnL),
        .out(sig_left)
    );
    
    // setup character positions and sizes
    reg [9:0] BeeX = 297;           // Bee X start position
    reg [8:0] BeeY = 433;           // Bee Y start position
    localparam BeeWidth = 34;       // Bee width in pixels
    localparam BeeHeight = 27;      // Bee height in pixels
  
    always @ (posedge clk_pix)
    begin
        // if sx,sy are within the confines of the Bee character, switch the Bee On and 
        if(de)
            begin
                if(sx==BeeX-2 && sy==BeeY)                  // Initially sx = 295 (297 - 2) = 1 pixel
                    begin
                        address <= 0;                       // Initially address = 0
                        BeeSpriteOn <=1;
                    end
                if((sx>BeeX-2) && (sx<BeeX+BeeWidth-1) && (sy>BeeY-1) && (sy<BeeY+BeeHeight)) // Thereafter sx = 296 to 329 = 33 pixels
                    begin
                        address <= address +1;              // Secondly address = (296 + 2 - 297) + (0 * 34) = 1
                        BeeSpriteOn <=1;
                    end
                else
                    BeeSpriteOn <=0;
            end
        // if left or right button pressed, move the Bee
        if (sx==639 && sy==479)                             // check for movement once every frame
            begin 
                if (sig_right == 1 && BeeX<640-BeeWidth)    // Check for right button
                    BeeX<=BeeX+1;
                else
                if (sig_left == 1 && BeeX>2)                // Check for left button
                    BeeX<=BeeX-1;
            end    
    end
endmodule