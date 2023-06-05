//----------------------------------------------
// HiveSprites.v module
// Digilent Basys 3             
// Bee Invaders Tutorial_4
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup HiveSprites Module
module HiveSprites(
    input wire clk_pix,             // 25.2MHz pixel clock
    input wire [9:0] sx,            // current x position
    input wire [9:0] sy,            // current y position
    input wire de,                  // high during active pixel drawing
    output reg [1:0] Hive1SpriteOn, // 1=on, 0=off
    output reg [1:0] Hive2SpriteOn, // 1=on, 0=off
    output reg [1:0] Hive3SpriteOn, // 1=on, 0=off
    output reg [1:0] Hive4SpriteOn, // 1=on, 0=off
    output wire [7:0] H1dout,       // 8 bit pixel value from Hive1
    output wire [7:0] H2dout,       // 8 bit pixel value from Hive2
    output wire [7:0] H3dout,       // 8 bit pixel value from Hive3
    output wire [7:0] H4dout        // 8 bit pixel value from Hive4
    );
    
    // instantiate Hive1Ram
    reg [11:0] H1address;           // 2^12 or 4096, need 56 x 39 = 2184
    Hive1Ram Hive1VRam (
        .clk_pix(clk_pix),
        .H1address(H1address),
        .H1dout(H1dout),
        .write(0),
        .data(0)
    );
    
    // instantiate Hive2Ram
    reg [11:0] H2address;           // 2^12 or 4096, need 56 x 39 = 2184
    Hive2Ram Hive2VRam (
        .clk_pix(clk_pix),
        .H2address(H2address),
        .H2dout(H2dout),
        .write(0),
        .data(0)
    );
    
    // instantiate Hive3Ram
    reg [11:0] H3address;           // 2^12 or 4096, need 56 x 39 = 2184
    Hive3Ram Hive3VRam (
        .clk_pix(clk_pix),
        .H3address(H3address),
        .H3dout(H3dout),
        .write(0),
        .data(0)
    );
    
    // instantiate Hive4Ram
    reg [11:0] H4address;           // 2^12 or 4096, need 56 x 39 = 2184
    Hive4Ram Hive4VRam (
        .clk_pix(clk_pix),
        .H4address(H4address),
        .H4dout(H4dout),
        .write(0),
        .data(0)
    );
            
    // setup character positions and sizes
    reg [9:0] Hive1X = 83;          // Hive1 X start position
    reg [8:0] Hive1Y = 360;         // Hive1 Y start position
    reg [9:0] Hive2X = 222;         // Hive2 X start position
    reg [8:0] Hive2Y = 360;         // Hive2 Y start position
    reg [9:0] Hive3X = 361;         // Hive3 X start position
    reg [8:0] Hive3Y = 360;         // Hive3 Y start position
    reg [9:0] Hive4X = 500;         // Hive4 X start position
    reg [8:0] Hive4Y = 360;         // Hive4 Y start position
    localparam HiveWidth = 56;      // Hive width in pixels
    localparam HiveHeight = 39;     // Hive height in pixels
  
    always @ (posedge clk_pix)
    begin
        if (de)
            // check if sx,sy are within the confines of the Hive characters
            // hive1
            begin 
                if (sx==Hive1X-2 && sy==Hive1Y)
                    begin
                        H1address <= 0;
                        Hive1SpriteOn <=1;
                    end
                if ((sx>Hive1X-2) && (sx<Hive1X+HiveWidth-1) && (sy>Hive1Y-1) && (sy<Hive1Y+HiveHeight))
                    begin
                        H1address <= H1address + 1;
                        Hive1SpriteOn <=1;
                    end
                else
                    Hive1SpriteOn <=0;
                    
                // hive2
                if (sx==Hive2X-2 && sy==Hive2Y)
                    begin
                        H2address <= 0;
                        Hive2SpriteOn <=1;
                    end
                if ((sx>Hive2X-2) && (sx<Hive2X+HiveWidth-1) && (sy>Hive2Y-1) && (sy<Hive2Y+HiveHeight))
                    begin
                        H2address <= H2address + 1;
                        Hive2SpriteOn <=1;
                    end
                else
                    Hive2SpriteOn <=0;
                    
                // hive3
                if (sx==Hive3X-2 && sy==Hive3Y)
                    begin
                        H3address <= 0;
                        Hive3SpriteOn <=1;
                    end
                if ((sx>Hive3X-2) && (sx<Hive3X+HiveWidth-1) && (sy>Hive3Y-1) && (sy<Hive3Y+HiveHeight))
                    begin
                        H3address <= H3address + 1;
                        Hive3SpriteOn <=1;
                    end
                else
                    Hive3SpriteOn <=0;
                    
                // hive4
                if (sx==Hive4X-2 && sy==Hive4Y)
                    begin
                        H4address <= 0;
                        Hive4SpriteOn <=1;
                    end
                if ((sx>Hive4X-2) && (sx<Hive4X+HiveWidth-1) && (sy>Hive4Y-1) && (sy<Hive4Y+HiveHeight))
                    begin
                        H4address <= H4address + 1;
                        Hive4SpriteOn <=1;
                    end
                else
                    Hive4SpriteOn <=0;
            end
    end
endmodule