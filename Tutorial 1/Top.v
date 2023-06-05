//----------------------------------------------
// Top.v module
// Digilent Basys 3             
// Bee Invaders Tutorial_1
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------

`default_nettype none
`timescale 1ns / 1ps

module Top (
    input  wire clk_100m,       // 100 MHz clock
    input  wire btn_rst_n,      // reset button
    output wire vga_hsync,      // VGA horizontal sync
    output wire vga_vsync,      // VGA vertical sync
    output reg [3:0] vga_r,     // 4-bit VGA red
    output reg [3:0] vga_g,     // 4-bit VGA green
    output reg [3:0] vga_b      // 4-bit VGA blue
    );

    // generate pixel clock
    reg reset;                  // Reset Button
    wire clk_pix;               // 25.2Mhz Pixel clock
    wire clk_pix_locked;        // Pixel clock locked?
    
    VGA_Clock clock_pix_inst (
       .clk_100m(clk_100m),
       .reset(btn_rst_n),      // reset button is active high
       .clk_pix(clk_pix),
       .clk_pix_locked(clk_pix_locked)
    );

    // display sync signals and coordinates
    localparam CORDW = 10;      // screen coordinate width in bits 
	reg rst_pix; 
    wire [CORDW-1:0] sx, sy;
    wire hsync; 
    wire vsync; 
    wire de;
    VGA_Timing display_inst (
        .clk_pix(clk_pix),
        .rst_pix(!clk_pix_locked),  // wait for clock lock
        .sx(sx),
        .sy(sy),
        .hsync(hsync),
        .vsync(vsync),
        .de(de)
    );
       
    // VGA Output
    assign vga_hsync = hsync;
    assign vga_vsync = vsync;
    always @(posedge clk_pix) begin    
        if (de) 
            begin  // VGA colour orange/brown
                vga_r <= 4'hD;
                vga_g <= 4'hA;
                vga_b <= 4'h5;
            end 
        else 
            begin  // VGA colour should be black in blanking interval
                vga_r <= 4'h0;
                vga_g <= 4'h0;
                vga_b <= 4'h0;
            end
        end
endmodule