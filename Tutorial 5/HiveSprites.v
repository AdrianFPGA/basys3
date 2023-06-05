//----------------------------------------------
// HiveSprites.v module
// Digilent Basys 3             
// Bee Invaders Tutorial_5
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
    input wire [9:0] xBBullet,      // x coordinate for Bee Bullet
    input wire [9:0] yBBullet,      // y coordinate for Bee Bullet
    output reg [1:0] BBhithive1,    // set to 1 when Bee Bullet hit hive1
    output reg [1:0] BBhithive2,    // set to 1 when Bee Bullet hit hive2
    output reg [1:0] BBhithive3,    // set to 1 when Bee Bullet hit hive3
    output reg [1:0] BBhithive4,    // set to 1 when Bee Bullet hit hive4
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
    reg [1:0] write1;               // write1 = 0 (read data), write1 = 1 (write data) 
    reg [7:0] data1;                // Data to write if write1 = 1 (write data)
    reg [11:0] H1address;           // Address to read/write data from/to Hive1 (2^12 or 4095, need 66 x 39 = 2574)
    
    Hive1Ram Hive1VRam (
        .clk_pix(clk_pix),
        .H1address(H1address),
        .write1(write1),
        .data1(data1),
        .H1dout(H1dout)
    );
    
    // instantiate Hive2Ram
    reg [1:0] write2;               // write2 = 0 (read data), write2 = 1 (write data)
    reg [7:0] data2;                // Data to write if write2 = 1 (write data)
    reg [11:0] H2address;           // Address to read/write data from/to Hive2 (2^12 or 4095, need 66 x 39 = 2574)
    
    Hive2Ram Hive2VRam (
        .clk_pix(clk_pix),
        .H2address(H2address),
        .write2(write2),
        .data2(data2),
        .H2dout(H2dout)
    );
    
    // instantiate Hive3Ram
    reg [1:0] write3;               // write3 = 0 (read data), write3 = 1 (write data)
    reg [7:0] data3;                // Data to write if write3 = 1 (write data)
    reg [11:0] H3address;           // Address to read/write data from/to Hive3 (2^12 or 4095, need 66 x 39 = 2574)
    
    Hive3Ram Hive3VRam (
        .clk_pix(clk_pix),
        .H3address(H3address),
        .write3(write3),
        .data3(data3),
        .H3dout(H3dout)
    );
    
    // instantiate Hive4Ram
    reg [1:0] write4;               // write4 = 0 (read data), write4 = 1 (write data)
    reg [7:0] data4;                // Data to write if write4 = 1 (write data)
    reg [11:0] H4address;           // Address to read/write data from/to Hive4 (2^12 or 4095, need 66 x 39 = 2574)
    
    Hive4Ram Hive4VRam (
        .clk_pix(clk_pix),
        .H4address(H4address),
        .write4(write4),
        .data4(data4),
        .H4dout(H4dout)
    );
    
    // Load BHole.mem
    reg [7:0] BHoleaddress;                 // 2^8 or 255, need 11 x 16 = 176
    reg [7:0] BHoledata [0:175];            // 8 bit values from BHole.mem
    initial begin
        $readmemh("BHole.mem", BHoledata);  // load 176 hex values into BHole.mem
    end    
    
    // setup Hive character positions and sizes
    localparam Hive1X = 78;             // Hive1 X start position
    localparam Hive1Y = 360;            // Hive1 Y start position
    localparam Hive2X = 217;            // Hive2 X start position
    localparam Hive2Y = 360;            // Hive2 Y start position
    localparam Hive3X = 356;            // Hive3 X start position
    localparam Hive3Y = 360;            // Hive3 Y start position
    localparam Hive4X = 495;            // Hive4 X start position
    localparam Hive4Y = 360;            // Hive4 Y start position
    localparam HiveWidth = 66;          // Hive width in pixels
    localparam HiveHeight = 39;         // Hive height in pixels
    
    reg [9:0] BHit1x;                   // Saves the x position of where the bee bullet hit hive1
    reg [9:0] BHit1y;                   // Saves the y position of where the bee bullet hit hive1
    reg [9:0] BHit2x;                   // Saves the x position of where the bee bullet hit hive2
    reg [9:0] BHit2y;                   // Saves the y position of where the bee bullet hit hive2
    reg [9:0] BHit3x;                   // Saves the x position of where the bee bullet hit hive3
    reg [9:0] BHit3y;                   // Saves the y position of where the bee bullet hit hive3
    reg [9:0] BHit4x;                   // Saves the x position of where the bee bullet hit hive4
    reg [9:0] BHit4y;                   // Saves the y position of where the bee bullet hit hive4
    reg [3:0] hzcounter1 = 0;           // Hole 11 pixels wide - Hive1
    reg [4:0] vtcounter1 = 0;           // Hole 16 pixels high - Hive1
    reg [3:0] hzcounter2 = 0;           // Hole 11 pixels wide - Hive2
    reg [4:0] vtcounter2 = 0;           // Hole 16 pixels high - Hive2
    reg [3:0] hzcounter3 = 0;           // Hole 11 pixels wide - Hive2
    reg [4:0] vtcounter3 = 0;           // Hole 16 pixels high - Hive2
    reg [3:0] hzcounter4 = 0;           // Hole 11 pixels wide - Hive2
    reg [4:0] vtcounter4 = 0;           // Hole 16 pixels high - Hive2
    
    always @ (posedge clk_pix)
    begin
        if (de)
            begin
                // check if sx,sy are within the confines of the Hive character - hive1
                if ((sx==Hive1X-2) && (sy==Hive1Y))
                    begin
                        write1<=0;
                        H1address <= 0;
                        Hive1SpriteOn <=1;
                    end
                if ((sx>Hive1X-2) && (sx<Hive1X+HiveWidth-1) && (sy>Hive1Y-1) && (sy<Hive1Y+HiveHeight))
                    begin
                        write1<=0;  
                        H1address <= H1address + 1;
                        Hive1SpriteOn <= 1; 
                        // Check if Bee Bullet Has Hit Hive 1          
                        if ((sx == xBBullet) && (sy == yBBullet) && (sx>Hive1X-1) && (BBhithive1 == 0) && (H1dout > 0)) 
                            begin                                                         
                                BBhithive1 <= 1;
                                BHit1x <= xBBullet - 5;
                                BHit1y <= yBBullet - 15; 
                            end                                             
                    end
                else
                    Hive1SpriteOn <= 0;
                    
                // check if sx,sy are within the confines of the Hive character - hive2
                if ((sx==Hive2X-2) && (sy==Hive2Y))
                    begin
                        write2<=0;
                        H2address <= 0;
                        Hive2SpriteOn <=1;
                    end
                if ((sx>Hive2X-2) && (sx<Hive2X+HiveWidth-1) && (sy>Hive2Y-1) && (sy<Hive2Y+HiveHeight))
                    begin
                        write2<=0;  
                        H2address <= H2address + 1;
                        Hive2SpriteOn <= 1; 
                        // Check if Bee Bullet Has Hit Hive 2          
                        if ((sx == xBBullet) && (sy == yBBullet) && (sx>Hive2X-1) && (BBhithive2 == 0) && (H2dout > 0)) 
                            begin                                                         
                                BBhithive2 <= 1;
                                BHit2x <= xBBullet - 5;
                                BHit2y <= yBBullet - 15; 
                            end                                             
                    end
                else
                    Hive2SpriteOn <= 0;
                    
                 // check if sx,sy are within the confines of the Hive character - hive3
                if ((sx==Hive3X-2) && (sy==Hive3Y))
                    begin
                        write3<=0;
                        H3address <= 0;
                        Hive3SpriteOn <=1;
                    end
                if ((sx>Hive3X-2) && (sx<Hive3X+HiveWidth-1) && (sy>Hive3Y-1) && (sy<Hive3Y+HiveHeight))
                    begin
                        write3<=0;  
                        H3address <= H3address + 1;
                        Hive3SpriteOn <= 1; 
                        // Check if Bee Bullet Has Hit Hive 3          
                        if ((sx == xBBullet) && (sy == yBBullet) && (sx>Hive3X-1) && (BBhithive3 == 0) && (H3dout > 0)) 
                            begin                                                         
                                BBhithive3 <= 1;
                                BHit3x <= xBBullet - 5;
                                BHit3y <= yBBullet - 15; 
                            end                                             
                    end
                else
                    Hive3SpriteOn <= 0;
                    
                 // check if sx,sy are within the confines of the Hive character - hive4
                if ((sx==Hive4X-2) && (sy==Hive4Y))
                    begin
                        write4<=0;
                        H4address <= 0;
                        Hive4SpriteOn <=1;
                    end
                if ((sx>Hive4X-2) && (sx<Hive4X+HiveWidth-1) && (sy>Hive4Y-1) && (sy<Hive4Y+HiveHeight))
                    begin
                        write4<=0;  
                        H4address <= H4address + 1;
                        Hive4SpriteOn <= 1; 
                        // Check if Bee Bullet Has Hit Hive 4          
                        if ((sx == xBBullet) && (sy == yBBullet) && (sx>Hive4X-1) && (BBhithive4 == 0) && (H4dout > 0)) 
                            begin                                                         
                                BBhithive4 <= 1;
                                BHit4x <= xBBullet - 5;
                                BHit4y <= yBBullet - 15; 
                            end                                             
                    end
                else
                    Hive4SpriteOn <= 0;        
            end     
        else   
        
        // insert bullet hole - Hive1
        if ((sx>640) && (sy>480) && (BBhithive1 == 1))   
            begin
                if ((hzcounter1 == 0) && (vtcounter1 == 0))
                    begin
                        H1address <= (BHit1x - Hive1X) + ((BHit1y - Hive1Y) * HiveWidth);
                        BHoleaddress <= 0;
                        hzcounter1 <= hzcounter1 + 1;
                    end
                else
                if (hzcounter1 < 12)
                    begin
                        if (BHoledata[BHoleaddress] > 0)
                            write1<=0;
                        else
                            begin
                                write1<=1;
                                data1 <= BHoledata[BHoleaddress];
                            end
                       
                        BHoleaddress <= BHoleaddress + 1;
                        H1address <= H1address + 1;
                        hzcounter1 <= hzcounter1 + 1;
                    end
                else
                if ((hzcounter1 == 12) && (vtcounter1 < 16))
                    begin
                        if (BHoledata[BHoleaddress] > 0)
                            write1<=0;
                        else
                            begin
                                write1<=1;
                                data1 <= BHoledata[BHoleaddress];
                            end
                            
                        H1address <= H1address + HiveWidth - 11;   
                        vtcounter1 <= vtcounter1 + 1;
                        hzcounter1 <= 1;
                    end
                    
                if (vtcounter1 > 15)
                    begin
                        BBhithive1 <= 0;
                        write1 <= 0;
                        hzcounter1 <= 0;
                        vtcounter1 <= 0;
                    end    
            end       
            
        // insert bullet hole - Hive2
        if ((sx>640) && (sy>480) && (BBhithive2 == 1))   
            begin
                if ((hzcounter2 == 0) && (vtcounter2 == 0))
                    begin
                        H2address <= (BHit2x - Hive2X) + ((BHit2y - Hive2Y) * HiveWidth);
                        BHoleaddress <= 0;
                        hzcounter2 <= hzcounter2 + 1;
                    end
                else
                if (hzcounter2 < 12)
                    begin
                        if (BHoledata[BHoleaddress] > 0)
                            write2<=0;
                        else
                            begin
                                write2<=1;
                                data2 <= BHoledata[BHoleaddress];
                            end
                       
                        BHoleaddress <= BHoleaddress + 1;
                        H2address <= H2address + 1;
                        hzcounter2 <= hzcounter2 + 1;
                    end
                else
                if ((hzcounter2 == 12) && (vtcounter2 < 16))
                    begin
                        if (BHoledata[BHoleaddress] > 0)
                            write2<=0;
                        else
                            begin
                                write2<=1;
                                data2 <= BHoledata[BHoleaddress];
                            end
                            
                        H2address <= H2address + HiveWidth - 11;   
                        vtcounter2 <= vtcounter2 + 1;
                        hzcounter2 <= 1;
                    end
                    
                if (vtcounter2 > 15)
                    begin
                        BBhithive2 <= 0;
                        write2 <= 0;
                        hzcounter2 <= 0;
                        vtcounter2 <= 0;
                    end    
            end   
        // insert bullet hole - Hive3
        if ((sx>640) && (sy>480) && (BBhithive3 == 1))  
            begin
                if ((hzcounter3 == 0) && (vtcounter3 == 0))
                    begin
                        H3address <= (BHit3x - Hive3X) + ((BHit3y - Hive3Y) * HiveWidth);
                        BHoleaddress <= 0;
                        hzcounter3 <= hzcounter3 + 1;
                    end
                else
                if (hzcounter3 < 12)
                    begin
                        if (BHoledata[BHoleaddress] > 0)
                            write3<=0;
                        else
                            begin
                                write3<=1;
                                data3 <= BHoledata[BHoleaddress];
                            end
                       
                        BHoleaddress <= BHoleaddress + 1;
                        H3address <= H3address + 1;
                        hzcounter3 <= hzcounter3 + 1;
                    end
                else
                if ((hzcounter3 == 12) && (vtcounter3 < 16))
                    begin
                        if (BHoledata[BHoleaddress] > 0)
                            write3<=0;
                        else
                            begin
                                write3<=1;
                                data3 <= BHoledata[BHoleaddress];
                            end
                            
                        H3address <= H3address + HiveWidth - 11;   
                        vtcounter3 <= vtcounter3 + 1;
                        hzcounter3 <= 1;
                    end
                    
                if (vtcounter3 > 15)
                    begin
                        BBhithive3 <= 0;
                        write3 <= 0;
                        hzcounter3 <= 0;
                        vtcounter3 <= 0;
                    end    
            end     
        // insert bullet hole - Hive4
        if ((sx>640) && (sy>480) && (BBhithive4 == 1)) 
            begin
                if ((hzcounter4 == 0) && (vtcounter4 == 0))
                    begin
                        H4address <= (BHit4x - Hive4X) + ((BHit4y - Hive4Y) * HiveWidth);
                        BHoleaddress <= 0;
                        hzcounter4 <= hzcounter4 + 1;
                    end
                else
                if (hzcounter4 < 12)
                    begin
                        if (BHoledata[BHoleaddress] > 0)
                            write4<=0;
                        else
                            begin
                                write4<=1;
                                data4 <= BHoledata[BHoleaddress];
                            end
                       
                        BHoleaddress <= BHoleaddress + 1;
                        H4address <= H4address + 1;
                        hzcounter4 <= hzcounter4 + 1;
                    end
                else
                if ((hzcounter4 == 12) && (vtcounter4 < 16))
                    begin
                        if (BHoledata[BHoleaddress] > 0)
                            write4<=0;
                        else
                            begin
                                write4<=1;
                                data4 <= BHoledata[BHoleaddress];
                            end
                            
                        H4address <= H4address + HiveWidth - 11;   
                        vtcounter4 <= vtcounter4 + 1;
                        hzcounter4 <= 1;
                    end
                    
                if (vtcounter4 > 15)
                    begin
                        BBhithive4 <= 0;
                        write4 <= 0;
                        hzcounter4 <= 0;
                        vtcounter4 <= 0;
                    end    
            end             
end
endmodule