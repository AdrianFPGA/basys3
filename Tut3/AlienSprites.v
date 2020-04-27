//--------------------------------------------------
// AlienSprites Module : Digilent Basys 3               
// BeeInvaders Tutorial 3 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//--------------------------------------------------
`timescale 1ns / 1ps

// Setup AlienSprites Module
module AlienSprites(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg A1SpriteOn, // 1=on, 0=off
    output reg A2SpriteOn, // 1=on, 0=off
    output reg A3SpriteOn, // 1=on, 0=off
    output wire [7:0] A1dataout, // 8 bit pixel value from Alien1.mem
    output wire [7:0] A2dataout, // 8 bit pixel value from Alien2.mem
    output wire [7:0] A3dataout, // 8 bit pixel value from Alien3.mem
    input wire Pclk // 25MHz pixel clock
    );

// instantiate Alien1Rom code
    reg [9:0] A1address; // 2^10 or 1024, need 31 x 26 = 806
    Alien1Rom Alien1VRom (.i_A1addr(A1address),.i_clk2(Pclk),.o_A1data(A1dataout));

// instantiate Alien2Rom code
    reg [9:0] A2address; // 2^10 or 1024, need 31 x 21 = 651
    Alien2Rom Alien2VRom (.i_A2addr(A2address),.i_clk2(Pclk),.o_A2data(A2dataout));

// instantiate Alien3Rom code
    reg [9:0] A3address; // 2^10 or 1024, need 31 x 27 = 837
    Alien3Rom Alien3VRom (.i_A3addr(A3address),.i_clk2(Pclk),.o_A3data(A3dataout));

// setup character positions and sizes
    reg [9:0] A1X = 135; // Alien1 X start position
    reg [9:0] A1Y = 85; // Alien1 Y start position
    localparam A1Width = 31; // Alien1 width in pixels
    localparam A1Height = 26; // Alien1 height in pixels
    reg [9:0] A2X = 135; // Alien2 X start position
    reg [9:0] A2Y = 120; // Alien2 Y start position
    localparam A2Width = 31; // Alien2 width in pixels
    localparam A2Height = 21; // Alien2 height in pixels
    reg [9:0] A3X = 135; // Alien3 X start position
    reg [9:0] A3Y = 180; // Alien3 Y start position
    localparam A3Width = 31; // Alien3 width in pixels
    localparam A3Height = 27; // Alien3 height in pixels

    reg [9:0] AoX = 0; // Offset for X Position of next Alien in row
    reg [9:0] AoY = 0; // Offset for Y Position of next row of Aliens
    reg [9:0] AcounterW = 0; // Counter to check if Alien width reached
    reg [9:0] AcounterH = 0; // Counter to check if Alien height reached
    reg [3:0] AcolCount = 11; // Number of horizontal aliens in all columns

    always @ (posedge Pclk)
    begin
        if (aactive)
            begin 
                // check if xx,yy are within the confines of the Alien characters
                // Alien1
                if (xx==A1X+AoX-1 && yy==A1Y+AoY)
                    begin
                        A1address <= 0;
                        A1SpriteOn <=1;
                        AcounterW<=0;
                    end                   
                if ((xx>A1X+AoX-1) && (xx<A1X+A1Width+AoX) && (yy>A1Y+AoY-1) && (yy<A1Y+A1Height+AoY))   
                    begin
                        A1address <= A1address + 1;
                        AcounterW <= AcounterW + 1;
                        A1SpriteOn <=1;
                        if (AcounterW==A1Width-1)
                            begin
                                AcounterW <= 0;
                                AoX <= AoX + 40;
                                if(AoX<(AcolCount-1)*40)
								    A1address <= A1address - (A1Width-1);
							    else
							    if(AoX==(AcolCount-1)*40)
								    AoX<=0;
					        end
                    end
                else
                    A1SpriteOn <=0;
                    
                // Alien2    
                if (xx==A2X+AoX-1 && yy==A2Y+AoY)
                    begin
                        A2address <= 0;
                        A2SpriteOn <=1;
                        AcounterW<=0;
                    end
                if ((xx>A2X+AoX-1) && (xx<A2X+A2Width+AoX) && (yy>A2Y+AoY-1) && (yy<A2Y+AoY+A2Height))
                    begin
                        A2address <= A2address + 1;
                        AcounterW <= AcounterW + 1;
                        A2SpriteOn <=1;
                        if (AcounterW==A2Width-1)
                            begin
                                AcounterW <= 0;
                                AoX <= AoX + 40;
                                if(AoX<(AcolCount-1)*40)
								    A2address <= A2address - (A2Width-1);
							    else
							    if(AoX==(AcolCount-1)*40)
                                    begin
								        AoX<=0;
								        AcounterH <= AcounterH + 1;
								        if(AcounterH==A2Height-1)
                                            begin
							                    AcounterH<=0;
							                    AoY <= AoY + 30;
							                    if(AoY==30)
							                        begin
								                        AoY<=0;
								                        AoX<=0;
				                                    end
						                    end
                                    end
                            end         
                    end
                else
                    A2SpriteOn <=0;
                    
                // Alien3
                if (xx==A3X+AoX-1 && yy==A3Y+AoY)
                    begin
                        A3address <= 0;
                        A3SpriteOn <=1;
                        AcounterW<=0;
                        AcounterH<=0;
                    end
                if ((xx>A3X+AoX-1) && (xx<A3X+AoX+A3Width) && (yy>A3Y+AoY-1) && (yy<A3Y+AoY+A3Height))
                    begin
                        A3address <= A3address + 1;
                        AcounterW <= AcounterW + 1;
                        A3SpriteOn <=1;
                        if (AcounterW==A3Width-1)
                            begin
                                AcounterW <= 0;
                                AoX <= AoX + 40;
                                if(AoX<(AcolCount-1)*40)
								    A3address <= A3address - (A3Width-1);
							    else
							    if(AoX==(AcolCount-1)*40)
                                    begin
								        AoX<=0;
								        AcounterH <= AcounterH + 1;
								        if(AcounterH==A3Height-1)
                                            begin
							                    AcounterH<=0;
							                    AoY <= AoY + 36;
							                    if(AoY==36)
							                        begin
								                        AoY<=0;
								                        AoX<=0;
				                                    end
						                    end
								    end	    
					        end
                    end
                else
                    A3SpriteOn <=0;
            end
    end
endmodule
