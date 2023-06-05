//----------------------------------------------
// Top.v module
// Digilent Basys 3             
// Bee Invaders Tutorial_4
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
    input wire btnL                         // Left button
    );

    // Instantiate VGA_Clock
    reg reset;                              // Reset Button
    wire clk_pix;                           // 25.2Mhz Pixel clock
    wire clk_pix_locked;                    // Pixel clock locked?
    
    VGA_Clock clock_pix_inst (
       .clk_100m(clk_100m),
       .reset(btn_rst_n),      // reset button is active high
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
    BeeSprite BeeDisplay (
        .clk_pix(clk_pix),
        .sx(sx),
        .sy(sy),
        .de(de),
        .BeeSpriteOn(BeeSpriteOn),
        .btnR(btnR),
        .btnL(btnL),
        .dataout(dout)
    );
  
    // Instantiate AlienSprites
    wire [1:0] Alien1SpriteOn;              // 1=on, 0=off
    wire [1:0] Alien2SpriteOn;              // 1=on, 0=off
    wire [1:0] Alien3SpriteOn;              // 1=on, 0=off
    wire [7:0] Alien1dout;                  // pixel value from Alien1.mem
    wire [7:0] Alien2dout;                  // pixel value from Alien2.mem
    wire [7:0] Alien3dout;                  // pixel value from Alien3.mem
    AlienSprites AlienDisplay (
        .clk_pix(clk_pix),
        .sx(sx),
        .sy(sy),
        .de(de),
        .Alien1SpriteOn(Alien1SpriteOn),
        .Alien2SpriteOn(Alien2SpriteOn),
        .Alien3SpriteOn(Alien3SpriteOn),
        .A1dout(Alien1dout),
        .A2dout(Alien2dout),
        .A3dout(Alien3dout)
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
    HiveSprites HDisplay (
        .clk_pix(clk_pix),
        .sx(sx),
        .sy(sy),
        .de(de),
        .Hive1SpriteOn(Hive1SpriteOn),
        .Hive2SpriteOn(Hive2SpriteOn),
        .Hive3SpriteOn(Hive3SpriteOn),
        .Hive4SpriteOn(Hive4SpriteOn),
        .H1dout(H1dataout),
        .H2dout(H2dataout),
        .H3dout(H3dataout),
        .H4dout(H4dataout)
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