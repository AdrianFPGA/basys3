//--------------------------------------------------
// HiveSprites Module : Digilent Basys 3               
// BeeInvaders Tutorial 4 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//--------------------------------------------------
`timescale 1ns / 1ps

// Setup HiveSprites Module
module HiveSprites(
    input wire [9:0] xx,            // current x position
    input wire [9:0] yy,            // current y position
    input wire aactive,             // high during active pixel drawing
    output reg H1SpriteOn,          // 1=on, 0=off
    output reg H2SpriteOn,          // 1=on, 0=off
    output reg H3SpriteOn,          // 1=on, 0=off
    output reg H4SpriteOn,          // 1=on, 0=off
    output wire [7:0] H1dataout,    // 8 bit pixel value from Hive1
    output wire [7:0] H2dataout,    // 8 bit pixel value from Hive2
    output wire [7:0] H3dataout,    // 8 bit pixel value from Hive3
    output wire [7:0] H4dataout,    // 8 bit pixel value from Hive4
    input wire Pclk                 // 25MHz pixel clock
    );
    
    // instantiate Hive1Ram code
    reg [11:0] H1address;           // 2^12 or 4096, need 56 x 39 = 2184
    Hive1Ram Hive1VRam (.i_addr(H1address),.i_clk2(Pclk),.o_data(H1dataout),//,
                        .i_write(0),.i_data(0));
    
    // instantiate Hive2Ram code
    reg [11:0] H2address;           // 2^12 or 4096, need 56 x 39 = 2184
    Hive2Ram Hive2VRam (.i_addr(H2address),.i_clk2(Pclk),.o_data(H2dataout),
                        .i_write(0),.i_data(0));
    
    // instantiate Hive3Ram code
    reg [11:0] H3address;           // 2^12 or 4096, need 56 x 39 = 2184
    Hive3Ram Hive3VRam (.i_addr(H3address),.i_clk2(Pclk),.o_data(H3dataout),
                       .i_write(0),.i_data(0));
    
    // instantiate Hive4Ram code
    reg [11:0] H4address;           // 2^12 or 4096, need 56 x 39 = 2184
    Hive4Ram Hive4VRam (.i_addr(H4address),.i_clk2(Pclk),.o_data(H4dataout),
                        .i_write(0),.i_data(0));
    
    // instantiate Hive5Rom code - Temporary disabled
//    reg [11:0] H5address;           // 2^12 or 4096, need 56 x 39 = 2184
//    Hive5Rom Hive5VRom (.i_addr(H5address),.i_clk2(Pclk),.o_data(H5dataout));
            
    // setup character positions and sizes
    reg [9:0] Hive1X = 127;         // Hive1 X start position
    reg [8:0] Hive1Y = 360;         // Hive1 Y start position
    reg [9:0] Hive2X = 237;         // Hive2 X start position
    reg [8:0] Hive2Y = 360;         // Hive2 Y start position
    reg [9:0] Hive3X = 347;         // Hive3 X start position
    reg [8:0] Hive3Y = 360;         // Hive3 Y start position
    reg [9:0] Hive4X = 457;         // Hive4 X start position
    reg [8:0] Hive4Y = 360;         // Hive4 Y start position
    localparam HiveWidth = 56;      // Hive width in pixels
    localparam HiveHeight = 39;     // Hive height in pixels
  
    always @ (posedge Pclk)
    begin
        if (aactive)
            // check if xx,yy are within the confines of the Hive characters
            // hive1
            begin 
                if (xx==Hive1X-1 && yy==Hive1Y)
                    begin
                        H1address <= 0;
                        H1SpriteOn <=1;
                    end
                if ((xx>Hive1X-1) && (xx<Hive1X+HiveWidth) && (yy>Hive1Y-1) && (yy<Hive1Y+HiveHeight))
                    begin
                        H1address <= H1address + 1;
                        H1SpriteOn <=1;
                    end
                else
                    H1SpriteOn <=0;
                    
                // hive2
                if (xx==Hive2X-1 && yy==Hive2Y)
                    begin
                        H2address <= 0;
                        H2SpriteOn <=1;
                    end
                if ((xx>Hive2X-1) && (xx<Hive2X+HiveWidth) && (yy>Hive2Y-1) && (yy<Hive2Y+HiveHeight))
                    begin
                        H2address <= H2address + 1;
                        H2SpriteOn <=1;
                    end
                else
                    H2SpriteOn <=0;
                    
                // hive3
                if (xx==Hive3X-1 && yy==Hive3Y)
                    begin
                        H3address <= 0;
                        H3SpriteOn <=1;
                    end
                if ((xx>Hive3X-1) && (xx<Hive3X+HiveWidth) && (yy>Hive3Y-1) && (yy<Hive3Y+HiveHeight))
                    begin
                        H3address <= H3address + 1;
                        H3SpriteOn <=1;
                    end
                else
                    H3SpriteOn <=0;
                    
                // hive4
                if (xx==Hive4X-1 && yy==Hive4Y)
                    begin
                        H4address <= 0;
                        H4SpriteOn <=1;
                    end
                if ((xx>Hive4X-1) && (xx<Hive4X+HiveWidth) && (yy>Hive4Y-1) && (yy<Hive4Y+HiveHeight))
                    begin
                        H4address <= H4address + 1;
                        H4SpriteOn <=1;
                    end
                else
                    H4SpriteOn <=0;
            end
    end
endmodule