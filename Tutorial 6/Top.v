//----------------------------------------------
// Top.v module
// Digilent Basys 3             
// Bee Invaders Tutorial_6
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------

`default_nettype none
`timescale 1ns / 1ps

// Setup Top module
module Top (
    input  wire clk_100m,                   // 100 MHz clock
    input  wire btn_rst_n,                  // reset button
    output wire vga_hsync,                  // VGA horizontal sync
    output wire vga_vsync,                  // VGA vertical sync
    output reg [3:0] vga_r,                 // 4-bit VGA red
    output reg [3:0] vga_g,                 // 4-bit VGA green
    output reg [3:0] vga_b,                 // 4-bit VGA blue
    input wire btnR,                        // Right button
    input wire btnL,                        // Left button
    input wire btnF                         // Fire button
    );

    // Instantiate VGA_Clock
    reg reset;                              // Reset Button
    wire clk_pix;                           // 25.2Mhz Pixel clock
    wire clk_pix_locked;                    // Pixel clock locked?
    
    VGA_Clock clock_pix_inst (
       .clk_100m(clk_100m),
       .reset(btn_rst_n),                   // reset button is active high
       .clk_pix(clk_pix),
       .clk_pix_locked(clk_pix_locked)
    );

    // Instantiate VGA_Timing
    localparam CORDW = 10;                  // screen coordinate width in bits 
	reg rst_pix; 
    wire [CORDW-1:0] sx, sy;
    wire hsync; 
    wire vsync; 
    wire de;
    VGA_Timing display_inst (
        .clk_pix(clk_pix),
        .rst_pix(!clk_pix_locked),          // wait for clock lock
        .sx(sx),
        .sy(sy),
        .hsync(hsync),
        .vsync(vsync),
        .de(de)
    );
       
    // Instantiate BeeSprite
    wire [1:0] BeeSpriteOn;                 // 1=on, 0=off
    wire [7:0] dout;                        // pixel value from Bee.mem
    wire [9:0] BeeX;
    BeeSprite BeeDisplay (
        .clk_pix(clk_pix),
        .sx(sx),
        .sy(sy),
        .de(de),
        .btnR(btnR),
        .btnL(btnL),
        .BeeX(BeeX),
        .BeeSpriteOn(BeeSpriteOn),
        .dataout(dout)
    );
  
    // Instantiate BBulletSprite
    wire [1:0] BBulletSpriteOn;             // 1=on, 0=off
    wire [7:0] BBdout;                      // pixel value from BBullet.mem
    wire [9:0] yBBullet;                    // y coordinate for Bee Bullet
    wire [9:0] xBBullet;                    // x coordinate for Bee Bullet
    reg [1:0] BBulletHive1 = 0;             // 1 = bullet hit hive1, 0 = no hit
    reg [1:0] BBulletHive2 = 0;             // 1 = bullet hit hive2, 0 = no hit
    reg [1:0] BBulletHive3 = 0;             // 1 = bullet hit hive3, 0 = no hit
    reg [1:0] BBulletHive4 = 0;             // 1 = bullet hit hive4, 0 = no hit
    wire [1:0] BBulletstate;                // 1 = moving, 2 = stopped
    BBulletSprite BBulletDisplay (
        .clk_pix(clk_pix),
        .sx(sx),
        .sy(sy),
        .de(de),
        .btnF(btnF),
        .BeeX(BeeX),
        .BBhithive1(BBhithive1),
        .BBhithive2(BBhithive2),
        .BBhithive3(BBhithive3),
        .BBhithive4(BBhithive4),
        .BBhitAlien1(BBhitAlien1),
        .BBhitAlien2(BBhitAlien2),
        .BBhitAlien3(BBhitAlien3),
        .BBulletSpriteOn(BBulletSpriteOn),
        .BBdout(BBdout),
        .yBBullet(yBBullet),
        .xBBullet(xBBullet),
        .BBulletstate(BBulletstate)
    );
  
    // Instantiate AlienSprites
    wire [1:0] Alien1SpriteOn;              // 1=on, 0=off
    wire [1:0] Alien2SpriteOn;              // 1=on, 0=off
    wire [1:0] Alien3SpriteOn;              // 1=on, 0=off
    wire [1:0] LevelSpriteOn;               // Level Indicator
    wire [7:0] Alien1dout;                  // pixel value from Alien1.mem
    wire [7:0] Alien2dout;                  // pixel value from Alien2.mem
    wire [7:0] Alien3dout;                  // pixel value from Alien3.mem
    wire [7:0] Ldout;                       // pixel value for Level
    wire [1:0] BBhitAlien1;                 // Bee Bullet Hit Alien1 (0 = No, 1 = Yes)
    wire [1:0] BBhitAlien2;                 // Bee Bullet Hit Alien2 (0 = No, 1 = Yes)
    wire [1:0] BBhitAlien3;                 // Bee Bullet Hit Alien3 (0 = No, 1 = Yes)
    wire [16:0] Score;                      // Score value
    wire [1:0] ResetHives;                  // set to 1 if level completed in order to reset hive graphics
    AlienSprites AlienDisplay (
        .clk_pix(clk_pix),
        .sx(sx),
        .sy(sy),
        .de(de),
        .xBBullet(xBBullet),                // x coordinate for Bee Bullet
        .yBBullet(yBBullet),                // y coordinate for Bee Bullet
        .BBhitAlien1(BBhitAlien1),
        .BBhitAlien2(BBhitAlien2),
        .BBhitAlien3(BBhitAlien3),
        .Alien1SpriteOn(Alien1SpriteOn),
        .Alien2SpriteOn(Alien2SpriteOn),
        .Alien3SpriteOn(Alien3SpriteOn),
        .LevelSpriteOn(LevelSpriteOn),
        .A1dout(Alien1dout),
        .A2dout(Alien2dout),
        .A3dout(Alien3dout),
        .Ldout(Ldout),
        .Score(Score),
        .ResetHives(ResetHives)
    );
  
    // instantiate HiveSprites
    wire [1:0] Hive1SpriteOn;               // 1=on, 0=off
    wire [1:0] Hive2SpriteOn;               // 1=on, 0=off
    wire [1:0] Hive3SpriteOn;               // 1=on, 0=off
    wire [1:0] Hive4SpriteOn;               // 1=on, 0=off
    wire [7:0] H1dataout;                   // pixel value from Hive1
    wire [7:0] H2dataout;                   // pixel value from Hive2
    wire [7:0] H3dataout;                   // pixel value from Hive3
    wire [7:0] H4dataout;                   // pixel value from Hive4
    wire [1:0] BBhithive1;                  // Bee Bullet Hit Hive1 (0 = No, 1 = Yes)
    wire [1:0] BBhithive2;                  // Bee Bullet Hit Hive2 (0 = No, 1 = Yes)
    wire [1:0] BBhithive3;                  // Bee Bullet Hit Hive3 (0 = No, 1 = Yes)
    wire [1:0] BBhithive4;                  // Bee Bullet Hit Hive4 (0 = No, 1 = Yes)
    wire [11:0] lpcounter;                  // Loop counter used in resetting hive graphics
    
    HiveSprites HDisplay (
        .clk_pix(clk_pix),
        .sx(sx),
        .sy(sy),
        .de(de),
        .xBBullet(xBBullet),
        .yBBullet(yBBullet),
        .ResetHives(ResetHives),
        .BBhithive1(BBhithive1),
        .BBhithive2(BBhithive2),
        .BBhithive3(BBhithive3),
        .BBhithive4(BBhithive4),
        .Hive1SpriteOn(Hive1SpriteOn),
        .Hive2SpriteOn(Hive2SpriteOn),
        .Hive3SpriteOn(Hive3SpriteOn),
        .Hive4SpriteOn(Hive4SpriteOn),
        .H1dout(H1dataout),
        .H2dout(H2dataout),
        .H3dout(H3dataout),
        .H4dout(H4dataout),  
        .lpcounter(lpcounter)
    );  
    
    // Instantiate Score
    wire [1:0] ScoreSpriteOn;               // 1=on, 0=off
    wire [7:0] Scoredout;                   // pixel value from Score.mem
    wire [1:0] DigitsSpriteOn;              // 1=on, 0=off
    wire [7:0] Digitsdout;                  // pixel value from Digits.mem
    wire [10:0] Digitsaddress;              // 11^10 or 2047, need 110 x 13 = 1430
    ScoreSprite ScoreDisplay (
        .clk_pix(clk_pix),
        .sx(sx),
        .sy(sy),
        .de(de),
        .Score(Score),
        .ScoreSpriteOn(ScoreSpriteOn),
        .Scoredout(Scoredout),
        .DigitsSpriteOn(DigitsSpriteOn),
        .Digitsdout(Digitsdout)
    );
    
    // Instantiate Honeycomb1
    wire [1:0] Honeycomb1SpriteOn;          // 1=on, 0=off
    wire [7:0] Honeycomb1dout;              // pixel value from Honeycomb1.mem
    Honeycomb1Sprite Honeycomb1Display (
         .clk_pix(clk_pix),
        .sx(sx),
        .sy(sy),
        .de(de),
        .Honeycomb1SpriteOn(Honeycomb1SpriteOn),
        .Honeycomb1dout(Honeycomb1dout)
    );
    
    // Load colour palette
    reg [7:0] palette [0:191];              // 8 bit values from the 192 hex entries in the colour palette
    reg [7:0] COL = 0;                      // background colour palette value
    initial begin
        $readmemh("pal24bit.mem", palette); // load 192 hex values into "palette"
    end   
    
    // VGA Output
    assign vga_hsync = hsync;
    assign vga_vsync = vsync;
    always @ (posedge clk_pix)
    begin
        if(de)
            begin
                if (BeeSpriteOn==1)
                    begin
                        vga_r <= (palette[(dout*3)])>>4;            // RED bits(7:4) from colour palette
                        vga_g <= (palette[(dout*3)+1])>>4;          // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(dout*3)+2])>>4;          // BLUE bits(7:4) from colour palette
                    end
                else
                if (BBulletSpriteOn==1)
                    begin
                        vga_r <= (palette[(BBdout*3)])>>4;      // RED bits(7:4) from colour palette
                        vga_g <= (palette[(BBdout*3)+1])>>4;    // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(BBdout*3)+2])>>4;    // BLUE bits(7:4) from colour palette
                    end
                else
                if (Alien1SpriteOn==1)
                    begin
                        vga_r <= (palette[(Alien1dout*3)])>>4;      // RED bits(7:4) from colour palette
                        vga_g <= (palette[(Alien1dout*3)+1])>>4;    // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(Alien1dout*3)+2])>>4;    // BLUE bits(7:4) from colour palette
                    end
                else
                if (Alien2SpriteOn==1)
                    begin
                        vga_r <= (palette[(Alien2dout*3)])>>4;      // RED bits(7:4) from colour palette
                        vga_g <= (palette[(Alien2dout*3)+1])>>4;    // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(Alien2dout*3)+2])>>4;    // BLUE bits(7:4) from colour palette
                    end
                else
                if (Alien3SpriteOn==1)
                    begin
                        vga_r <= (palette[(Alien3dout*3)])>>4;      // RED bits(7:4) from colour palette
                        vga_g <= (palette[(Alien3dout*3)+1])>>4;    // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(Alien3dout*3)+2])>>4;    // BLUE bits(7:4) from colour palette
                    end
                else
                if (Hive1SpriteOn==1)
                    begin
                        vga_r <= (palette[(H1dataout*3)])>>4;       // RED bits(7:4) from colour palette
                        vga_g <= (palette[(H1dataout*3)+1])>>4;     // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(H1dataout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (Hive2SpriteOn==1)
                    begin
                        vga_r <= (palette[(H2dataout*3)])>>4;       // RED bits(7:4) from colour palette
                        vga_g <= (palette[(H2dataout*3)+1])>>4;     // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(H2dataout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (Hive3SpriteOn==1)
                    begin
                        vga_r <= (palette[(H3dataout*3)])>>4;       // RED bits(7:4) from colour palette
                        vga_g <= (palette[(H3dataout*3)+1])>>4;     // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(H3dataout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (Hive4SpriteOn==1)
                    begin
                        vga_r <= (palette[(H4dataout*3)])>>4;       // RED bits(7:4) from colour palette
                        vga_g <= (palette[(H4dataout*3)+1])>>4;     // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(H4dataout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (ScoreSpriteOn==1)
                    begin
                        vga_r <= (palette[(Scoredout*3)])>>4;       // RED bits(7:4) from colour palette
                        vga_g <= (palette[(Scoredout*3)+1])>>4;     // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(Scoredout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (DigitsSpriteOn==1)
                    begin
                        vga_r <= (palette[(Digitsdout*3)])>>4;       // RED bits(7:4) from colour palette
                        vga_g <= (palette[(Digitsdout*3)+1])>>4;     // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(Digitsdout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
               else
                    if (LevelSpriteOn==1)
                    begin
                        vga_r <= (palette[(Ldout*3)])>>4;           // RED bits(7:4) from colour palette
                        vga_g <= (palette[(Ldout*3)+1])>>4;         // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(Ldout*3)+2])>>4;         // BLUE bits(7:4) from colour palette
                    end    
                else
                    if (Honeycomb1SpriteOn==1)
                    begin
                        vga_r <= (palette[(Honeycomb1dout*3)])>>4;       // RED bits(7:4) from colour palette
                        vga_g <= (palette[(Honeycomb1dout*3)+1])>>4;     // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(Honeycomb1dout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
               
                else
                    begin
                        vga_r <= (palette[(COL*3)])>>4;             // RED bits(7:4) from colour palette
                        vga_g <= (palette[(COL*3)+1])>>4;           // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(COL*3)+2])>>4;           // BLUE bits(7:4) from colour palette
                    end
            end
        else
            begin
                vga_r <= 0; // set RED, GREEN & BLUE
                vga_g <= 0; // to "0" when x,y outside of
                vga_b <= 0; // the active display area 
            end
    end
endmodule