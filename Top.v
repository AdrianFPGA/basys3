//----------------------------------------------
// Top Module
// Digilent Basys 3               
// BeeInvaders Tutorial 1 : Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Top Module
module Top(
    input wire CLK, // Onboard clock 100MHz : INPUT Pin W5
    input wire RESET, // Reset button : INPUT Pin U18
    output wire HSYNC, // VGA horizontal sync : OUTPUT Pin P19
    output wire VSYNC, // VGA vertical sync : OUTPUT Pin R19
    output reg [3:0] RED, // 4-bit VGA Red : OUTPUT Pin G19, Pin H19, Pin J19, Pin N19
    output reg [3:0] GREEN, // 4-bit VGA Green : OUTPUT Pin J17, Pin H17, Pin G17, Pin D17
    output reg [3:0] BLUE // 4-bit VGA Blue : OUTPUT Pin N18, Pin L18, Pin K18, Pin J18
    );
    
    // Setup Reset button
    wire rst = RESET; // reset : active high (BTNC)

    // generate 25MHz pixel clock using a "Fractional Clock Divider"
    reg [15:0] counter1;
    reg pix_clk;
    always @(posedge CLK)
        // divide 100MHz by 4 = 25MHz : (2^16)/4 = 16384 decimal or 4000 hex
        {pix_clk, counter1} <= counter1 + 16'h4000;
        
    // instantiate vga640x480 code
    wire [9:0] x; // pixel x position: 10-bit value: 0-1023 : only need 800
    wire [9:0] y; // pixel y position: 10-bit value: 0-1023 : only need 525
    wire active; // high during active pixel drawing
    vga640x480 display (
        .i_clk(CLK), 
        .i_pix_clk(pix_clk),
        .i_rst(rst),
        .o_hsync(HSYNC), 
        .o_vsync(VSYNC), 
        .o_x(x), 
        .o_y(y),
        .o_active(active)
    );
   
   // setup palette and RGB registers
    reg [7:0] palette [0:192]; // 8 bit values from the 192 hex entries in the colour palette
    reg [7:0] COL; // holds hex colour palette value to display on the screen
    reg [7:0] colourR; // 8 bit hex value for RED
    reg [7:0] colourG; // 8 bit hex value for GREEN
    reg [7:0] colourB; // 8 bit hex value for BLUE
    
    // load colour palette
    initial begin
        $readmemh("pal24bit.mem", palette); // load 192 hex values into "palette"
    end

    // fill the active area of the screen
    always @ (posedge CLK)
    begin
        COL <= 8'h19; // set colour to pink (decimal 25)
        if (active)
            begin
                colourR <= palette[(COL*3)]; // retrieve RED palette hex value
                colourG <= palette[(COL*3)+1]; // retrieve GREEN palette hex value
                colourB <= palette[(COL*3)+2]; // retrieve BLUE palette hex value
                RED <= colourR[7:4]; // output 4 left hand bits of the 8 bit RED value retrieved  
                GREEN <= colourG[7:4]; // output 4 left hand bits of the 8 bit GREEN value retrieved  
                BLUE <= colourB[7:4]; // output 4 left hand bits of the 8 bit BLUE value retrieved  
            end
        else
            begin
                RED <= 0; // set RED, GREEN & BLUE
                GREEN <= 0; // to "0" when x,y outside of
                BLUE <= 0; // the active display area
            end
    end
endmodule
