//--------------------------------------------------
// vga640x480 Module : Digilent Basys 3               
// BeeInvaders Tutorial 4 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//--------------------------------------------------
`timescale 1ns / 1ps

// Setup vga640x480 Module
module vga640x480(
    input wire i_clk,       // 100MHz onboard clock
    input wire i_rst,       // reset
    output wire o_hsync,    // horizontal sync
    output wire o_vsync,    // vertical sync
    output wire [9:0] o_x,  // current pixel x position
    output wire [9:0] o_y,  // current pixel y position
    output wire o_active,   // high during active pixel drawing
    output reg pix_clk      // 25MHz pixel clock
    );
	
    // VGA 640x480 Horizontal Timing (line)
	localparam HACTIVE     = 640;                      // horizontal visible area
	localparam HBACKPORCH  = 48;                       // horizontal back porch
	localparam HFRONTPORCH = 16;                       // horizontal front porch
	localparam HSYNC       = 96;                       // horizontal sync pulse
	localparam HSYNCSTART  = 640 + 16;                 // horizontal sync start
	localparam HSYNCEND    = 640 + 16 + 96 - 1;        // horizontal sync end
	localparam LINEEND     = 640 + 48 + 16 + 96 - 1;   // horizontal line end
	reg [9:0] H_SCAN;                                  // horizontal line position
	
	// VGA 640x480 Vertical timing (frame)
	localparam VACTIVE     = 480;                      // vertical visible area
	localparam VBACKPORCH  = 33;                       // vertical back porch
	localparam VFRONTPORCH = 10;                       // vertical front porch
	localparam VSYNC       = 2;                        // vertical sync pulse
    localparam VSYNCSTART  = 480 + 33;                 // vertical sync start
	localparam VSYNCEND    = 480 + 33 + 2 - 1;         // vertical sync end
	localparam SCREENEND   = 480 + 10 + 33 + 2 - 1;    // vertical screen end
	reg [9:0] V_SCAN;                                  // vertical screen position
	
    // set sync signals to low (active) or high (inactive)
    assign o_hsync = H_SCAN >= HSYNCSTART && H_SCAN <= HSYNCEND;
    assign o_vsync = V_SCAN >= VSYNCSTART && V_SCAN <= VSYNCEND;
    
    // set x and y values
    assign o_x = H_SCAN;
    assign o_y = V_SCAN;
    
    // set active high during active area
    assign o_active = ~(H_SCAN > HACTIVE) | (V_SCAN > VACTIVE);
  
    // generate 25MHz pixel clock using a "Fractional Clock Divider"
    reg [15:0] counter1;
    always @(posedge i_clk)
        // divide 100MHz by 4 = 25MHz : (2^16)/4 = 16384 decimal or 4000 hex
	    {pix_clk, counter1} <= counter1 + 16'h4000;
	    
	// check for reset / create frame loop
    always @(posedge i_clk)
		begin
		  if (i_rst)
            begin
                H_SCAN <= 0;
                V_SCAN <= 0;
            end
          if (pix_clk)  
            begin
		          if (H_SCAN == LINEEND)
		              begin
		                  H_SCAN <= 0;
		                  V_SCAN <= V_SCAN + 1;
		              end
		          else
		              H_SCAN <= H_SCAN + 1;
		          if (V_SCAN == SCREENEND)
		              V_SCAN <= 0;	
            end	      
		end
endmodule