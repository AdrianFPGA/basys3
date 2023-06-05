//----------------------------------------------
// Top.v module
// Digilent Basys 3             
// Bee Invaders Tutorial_2
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
    output reg [3:0] vga_b                  // 4-bit VGA blue
    );

    // Instantiate VGA_Clock
    reg reset;                              // Reset Button
    wire clk_pix;                           // 25.2Mhz Pixel clock
    wire clk_pix_locked;                    // Pixel clock locked?
    
    VGA_Clock clock_pix_inst (
       .clk_100m(clk_100m),
       .reset(btn_rst_n),                  // reset button is active high
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
        .dataout(dout)
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
                        vga_r <= (palette[(dout*3)])>>4;    // RED bits(7:4) from colour palette
                        vga_g <= (palette[(dout*3)+1])>>4;  // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(dout*3)+2])>>4;  // BLUE bits(7:4) from colour palette
                    end
                else
                    begin
                        vga_r <= (palette[(COL*3)])>>4;     // RED bits(7:4) from colour palette
                        vga_g <= (palette[(COL*3)+1])>>4;   // GREEN bits(7:4) from colour palette
                        vga_b <= (palette[(COL*3)+2])>>4;   // BLUE bits(7:4) from colour palette
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