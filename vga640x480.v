//-----------------------------------
// vga640x480 Module
// Digilent Basys 3               
// BeeInvaders : Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25MHz
//-----------------------------------
`timescale 1ns / 1ps

// Setup vga640x480 Module
module vga640x480(
    input wire i_clk, // 100MHz onboard clock
    input wire i_pix_clk, // 25MHz pixel clock
    input wire i_rst, // reset
    output wire o_hsync, // horizontal sync
    output wire o_vsync, // vertical sync
    output wire o_active, // high during active pixel drawing
    output wire [9:0] o_x, // current pixel x position
    output wire [9:0] o_y // current pixel y position
    );

    // setup VGA timings
    //-------------------------------------
    // VGA 640x480 Horizontal Timing (line)
    localparam HSYNCSTART = 16; // horizontal sync start
    localparam HSYNCEND = 16 + 96; // horizontal sync end
    localparam HACTIVESTART = 16 + 96 + 48; // horizontal active start
    localparam HACTIVEEND = 16 + 96 + 48 + 640; // total line length in pixels
    reg [9:0] H_SCAN; // line position
    
    // VGA 640x480 Vertical timing (frame)
    localparam VSYNCSTART = 10; // vertical sync start
    localparam VSYNCEND = 10 + 2; // vertical sync end
    localparam VACTIVESTART = 10 + 2 + 33; // vertical active start
    localparam VACTIVEEND = 10 + 2 + 33 + 480; // vertical active end
    reg [9:0] V_SCAN; // screen position

    // set sync signals to low (active) or high (inactive)
    assign o_hsync = ~((H_SCAN >= HSYNCSTART) & (H_SCAN < HSYNCEND));
    assign o_vsync = ~((V_SCAN >= VSYNCSTART) & (V_SCAN < VSYNCEND));
   
    // set x and y values
    assign o_x = (H_SCAN < HACTIVESTART) ? 0 : (H_SCAN - HACTIVESTART);
    assign o_y = (V_SCAN < VACTIVESTART) ? 0 : (V_SCAN - VACTIVESTART);

    // set active high during active area
    assign o_active = ~((H_SCAN < HACTIVESTART) | (V_SCAN < VACTIVESTART)); 

    // check for reset / create frame loop
    always @ (posedge i_clk)
    begin
        // check for reset button pressed
        if (i_rst) // jump to start of a frame and reset registers
        begin
            H_SCAN <= 0;
            V_SCAN <= 0;
        end
        
        // loop through a full screen
        if (i_pix_clk)  
        begin
            if (H_SCAN == HACTIVEEND)  // if at the end of a line update registers
            begin
                H_SCAN <= 0;
                V_SCAN <= V_SCAN + 1;
            end
            else 
                H_SCAN <= H_SCAN + 1; // else increment horizontal counter

            if (V_SCAN == VACTIVEEND)  // if at the end of a screen reset vertical counter
                V_SCAN <= 0;
        end
    end
endmodule
