//----------------------------------------------
// ScoreRom.v Module
// Single Port ROM              
// Digilent Basys 3             
// Bee Invaders Tutorial_6
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup ScoreRom module
module ScoreRom(
    input wire [9:0] Scoreaddress,      // (2^10 or 1023, need 55 x 13 = 715
    input wire clk_pix,                 // pixel clock
    output reg [7:0] Scoredout          // (7:0) 8 bit pixel value from Score.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] Scorememory_array [0:714]; // 8 bit values for 715 pixels of Score (55 x 13)

    initial 
    begin
        $readmemh("Score.mem", Scorememory_array);
    end

    always@(posedge clk_pix)
            Scoredout <= Scorememory_array[Scoreaddress];     
endmodule
