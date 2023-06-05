//----------------------------------------------
// BeeSprite.v Module         
// Digilent Basys 3             
// Bee Invaders Tutorial_5
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup BeeSprite module
module BeeSprite(
    input wire clk_pix,                 // 25.2MHz pixel clock
    input wire [9:0] sx,                // current x position
    input wire [9:0] sy,                // current y position
    input wire de,                      // high during active pixel drawing
    input wire btnR,                    // right button
    input wire btnL,                    // left button
    output reg [9:0] BeeX,              // Bee X position
    output reg [1:0] BeeSpriteOn,       // 1=on, 0=off
    output wire [7:0] dataout           // pixel value from Bee.mem
    );

    // instantiate BeeRom
    reg [9:0] address;                  // 2^10 or 1024, need 34 x 27 = 918
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
    reg [8:0] BeeY = 433;           // Bee Y start position
    localparam BeeWidth = 34;       // Bee width in pixels
    localparam BeeHeight = 27;      // Bee height in pixels
  
    always @ (posedge clk_pix)
    begin
        // if sx,sy are within the confines of the Bee character, switch the Bee On
        if(de)
            begin
                if((sx==BeeX-2) && (sy==BeeY))              
                    begin
                        address <= 0;                       
                        BeeSpriteOn <=1;
                    end
                if((sx>BeeX-2) && (sx<BeeX+BeeWidth-1) && (sy>BeeY-1) && (sy<BeeY+BeeHeight))
                    begin
                        address <= address +1;
                        BeeSpriteOn <=1;
                    end
                else
                        BeeSpriteOn <=0;
            end
            
        // if left or right button pressed, move the Bee
        if (BeeX == 0)
            BeeX <= 320;                                        // initailise Bee x position
        if ((sx==64) && (sy==480))                              // check for buttons once every frame
            begin 
                if ((sig_right == 1) && (BeeX<640-BeeWidth))    // Check for right button
                    BeeX<=BeeX+1;                               // move right
                if ((sig_left == 1) && (BeeX>2))                // Check for left button
                    BeeX<=BeeX-1;                               // move left
            end
    end
endmodule