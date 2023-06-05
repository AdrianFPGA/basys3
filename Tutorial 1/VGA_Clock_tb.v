//----------------------------------------------
// VGA_Clock_tb.v module
// Digilent Basys 3             
// Bee Invaders Tutorial_1
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------

`timescale 1ns / 1ps

module VGA_Clock_tb();

parameter CLK_PERIOD = 10;

    reg reset; 
    reg clk_100m;

    // 640x480p60 clocks
    wire clk_pix;
    wire clk_pix_locked;

    VGA_Clock clock_pix_inst (
       .clk_100m(clk_100m),
       .reset(reset),
       .clk_pix(clk_pix),
       .clk_pix_locked(clk_pix_locked)
    );

    // generate clock
    always #(CLK_PERIOD / 2) clk_100m = ~clk_100m;

    initial
    begin
        clk_100m = 1;
        reset = 1;
        #100
        reset = 0;

        #19000
        $finish;
    end
endmodule
