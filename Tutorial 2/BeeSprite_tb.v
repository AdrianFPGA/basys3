//----------------------------------------------
// BeeSprite_tb.v module
// Digilent Basys 3             
// Bee Invaders Tutorial_2
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------

`timescale 1ns / 1ps

module BeeSprite_tb();

    parameter CLK_PERIOD = 10;  // 10 ns == 100 MHz
    parameter CORDW = 10;       // screen coordinate width in bits

    // VGA_Clock
    reg reset;
    reg clk_100m;
    wire clk_pix;          
    wire clk_pix_locked;  
    VGA_Clock clock_pix_inst (
       .clk_100m(clk_100m),
       .reset(reset),
       .clk_pix(clk_pix),
       .clk_pix_locked(clk_pix_locked)         
    );
     
    // VGA_Timing
	reg rst_pix;   
	wire [9:0] sx;  
	wire [9:0] sy;  
	wire hsync;     
	wire vsync;     
	wire de;
	VGA_Timing display_inst (
	    .clk_pix(clk_pix),  
	    .rst_pix(!clk_pix_locked),
	    .sx(sx), 
	    .sy(sy),  
	    .hsync(hsync),     
	    .vsync(vsync),     
	    .de(de)         
	);

    // BeeSprite
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

    // generate clock
    always #(CLK_PERIOD / 2) clk_100m = ~clk_100m;
    initial 
    begin
        clk_100m = 1;
        reset = 1;
        #100
        reset = 0;
        #20_000_000;
        $finish;
    end
endmodule
