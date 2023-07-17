//----------------------------------------------
// AlienSprites.v module
// Digilent Basys 3             
// Bee Invaders Tutorial_6
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup AlienSprites Module
module AlienSprites(
    input wire clk_pix,                 // 25MHz pixel clock
    input wire [9:0] sx,                // current x position
    input wire [9:0] sy,                // current y position
    input wire de,                      // high during active pixel drawing
    input wire [9:0] xBBullet,          // x coordinate for Bee Bullet
    input wire [9:0] yBBullet,          // y coordinate for Bee Bullet
    input wire [11:0] lpcounter,        // Loop counter used in resetting hive graphics
    output reg [1:0] BBhitAlien1,       // 1=hit, 0=no hit
    output reg [1:0] BBhitAlien2,       // 1=hit, 0=no hit
    output reg [1:0] BBhitAlien3,       // 1=hit, 0=no hit
    output reg [1:0] Alien1SpriteOn,    // 1=on, 0=off
    output reg [1:0] Alien2SpriteOn,    // 1=on, 0=off
    output reg [1:0] Alien3SpriteOn,    // 1=on, 0=off
    output reg [1:0] LevelSpriteOn,     // 1=on, 0=off
    output wire [7:0] A1dout,           // 8 bit pixel value from Alien1.mem
    output wire [7:0] A2dout,           // 8 bit pixel value from Alien2.mem
    output wire [7:0] A3dout,           // 8 bit pixel value from Alien3.mem
    output reg [7:0] Ldout,             // 8 bit pixel value for Level
    output reg [16:0] Score,            // 8 bit pixel value from Score.mem
    output reg [1:0] ResetHives         // set to 1 if level completed in order to reset hive graphics
    );

// instantiate Alien1Rom code
    reg [9:0] A1address;                // 2^10 or 1024, need 31 x 26 = 806
    Alien1Rom Alien1VRom (
        .A1address(A1address),
        .clk_pix(clk_pix),
        .A1dout(A1dout)
    );

// instantiate Alien2Rom code
    reg [9:0] A2address;                // 2^10 or 1024, need 31 x 21 = 651
    Alien2Rom Alien2VRom (
        .A2address(A2address),
        .clk_pix(clk_pix),
        .A2dout(A2dout)
    );

// instantiate Alien3Rom code
    reg [9:0] A3address;                // 2^10 or 1024, need 31 x 27 = 837
    Alien3Rom Alien3VRom (
        .A3address(A3address),
        .clk_pix(clk_pix),
        .A3dout(A3dout)
    );

// setup Alien character positions and sizes
    reg [9:0] A1X = 135;                // Alien1 X start position
    reg [8:0] A1Y = 85;                 // Alien1 Y start position
    localparam A1Width = 31;            // Alien1 width in pixels
    localparam A1Height = 26;           // Alien1 height in pixels
    reg [9:0] A2X = 135;                // Alien2 X start position
    reg [8:0] A2Y = 120;                // Alien2 Y start position
    localparam A2Width = 31;            // Alien2 width in pixels
    localparam A2Height = 21;           // Alien2 height in pixels
    reg [9:0] A3X = 135;                // Alien3 X start position
    reg [8:0] A3Y = 180;                // Alien3 Y start position
    localparam A3Width = 31;            // Alien3 width in pixels
    localparam A3Height = 27;           // Alien3 height in pixels

    reg [9:0] AoX = 0;                  // Offset for X Position of next Alien in row
    reg [8:0] AoY = 0;                  // Offset for Y Position of next row of Aliens
    reg [9:0] AcounterW = 0;            // Counter to check if Alien width reached
    reg [9:0] AcounterH = 0;            // Counter to check if Alien height reached
    reg [3:0] AcolCount = 11;           // Number of horizontal aliens in all columns
    reg [1:0] Adir = 2;                 // direction of aliens: 2=right, 1=left
    reg [3:0] delaliens = 0;            // counter to slow alien movement
    reg [3:0] delloop = 8;              // counter end value for delaliens
    reg [3:0] M = 4;                    // move Aliens by this number of pixels

    reg [0:10] alienc1=11'b11111111111;	//-----------------------------------
    reg [0:10] alienc2=11'b11111111111; //
    reg [0:10] alienc3=11'b11111111111;	// Set pattern of Aliens 11 x 5 = 55 
    reg [0:10] alienc4=11'b11111111111;	//
    reg [0:10] alienc5=11'b11111111111;	//-----------------------------------

    // setup Level Indicator positions and sizes
    localparam LevelWidth = 6;          // Level Indicator width in pixels
    localparam LevelHeight = 9;         // Level Indicator height in pixels
    reg [9:0] LevelX = 281;             // X position for Honeycomb1 Level Indicator
    reg [8:0] LevelY = 8;               // Y position for Honeycomb1 Level Indicator
    reg [3:0] Level=0;                  // Level Number
    reg [5:0] AlienQ=55;                // Alien quantity in the wave
    reg [9:0] LcounterW=0;              // Counter to check if Honeycomb1 Level Indicator width reached
    reg [9:0] LcounterH=0;              // Counter to check if Honeycomb1 Level Indicator height reached

    always @ (posedge clk_pix)
    begin
        // Initially set ResetHives to 0
        if(Score==0)
            ResetHives<=0;
        if (de)
            begin 
                // check if sx,sy are within the confines of the Alien characters
                // Alien1
                if (sx==A1X+AoX-2 && sy==A1Y+AoY)
                    begin
                        A1address <= 0;
                        Alien1SpriteOn <=1;
                        AcounterW<=0;
                    end                   
                if ((sx>A1X+AoX-2) && (sx<A1X+A1Width+AoX-1) && (sy>A1Y+AoY-1) && (sy<A1Y+A1Height+AoY))
                    begin
                        A1address <= A1address + 1;
                        AcounterW <= AcounterW + 1;
                        Alien1SpriteOn <=1;
                        if(alienc1[AoX/40]==0) 
                            Alien1SpriteOn <=0;
                        if (AcounterW==A1Width-1)
                            begin
                                AcounterW <= 0;
                                if(AcolCount>1)
                                    AoX <= AoX + 40;
                                if(AoX<(AcolCount-1)*40)
								    A1address <= A1address - (A1Width-1);
							    if(AoX==(AcolCount-1)*40)
								    AoX<=0;
					        end
                        // Check if Bee Bullet Has Hit Alien1          
                        if ((sx == xBBullet) && (sy == yBBullet) && (sx>A1X+AoX-1) && (BBhitAlien1 == 0) && (A1dout > 0) && (alienc1[AoX/40]==1))
                            begin                                                         
                                BBhitAlien1 <= 1;
                                alienc1[AoX/40]<=0;
                            end                              
                    end
                else
                    Alien1SpriteOn <=0;
                    
                // Alien2    
                if (sx==A2X+AoX-2 && sy==A2Y+AoY)
                    begin
                        A2address <= 0;
                        Alien2SpriteOn <=1;
                        AcounterW<=0;
                        AcounterH<=0;
                    end
                if ((sx>A2X+AoX-2) && (sx<A2X+A2Width+AoX-1) && (sy>A2Y+AoY-1) && (sy<A2Y+AoY+A2Height))
                    begin
                        A2address <= A2address + 1;
                        AcounterW <= AcounterW + 1;
                        Alien2SpriteOn <=1;
                        if((alienc2[AoX/40]==0) && (sy-A2Y<A2Height+1))
                            Alien2SpriteOn <=0;
                        if((alienc3[AoX/40]==0) && (sy-A2Y>A2Height))
                            Alien2SpriteOn <=0;
                        if (AcounterW==A2Width-1)
                            begin
                                AcounterW <= 0;
                                if(AcolCount>1)
                                    AoX <= AoX + 40;
                                if(AoX<(AcolCount-1)*40)
								    A2address <= A2address - (A2Width-1);
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
                        // Check if Bee Bullet Has Hit Alien2          
                        if ((sx == xBBullet) && (sy == yBBullet) && (sx>A2X+AoX-1) && (BBhitAlien2 == 0) && (A2dout > 0))
                            begin
                                if((sy-A2Y<A2Height+1) && (alienc2[AoX/40]==1))    
                                    begin
                                        BBhitAlien2 <= 1;                                
                                        alienc2[AoX/40]<=0;                
                                    end
                                if((sy-A2Y>A2Height) && (alienc3[AoX/40]==1))    
                                    begin
                                        BBhitAlien2 <= 1;                                
                                        alienc3[AoX/40]<=0;
                                    end
                            end                   
                    end
                else
                    Alien2SpriteOn <=0;
                    
                // Alien3
                if (sx==A3X+AoX-2 && sy==A3Y+AoY)
                    begin
                        A3address <= 0;
                        Alien3SpriteOn <=1;
                        AcounterW<=0;
                        AcounterH<=0;
                    end
                if ((sx>A3X+AoX-2) && (sx<A3X+AoX+A3Width-1) && (sy>A3Y+AoY-1) && (sy<A3Y+AoY+A3Height))
                    begin
                        A3address <= A3address + 1;
                        AcounterW <= AcounterW + 1;
                        Alien3SpriteOn <=1;
                        if((alienc4[(AoX)/40]==0) && (sy-A3Y<A3Height+1))
                            Alien3SpriteOn <=0;
                        if((alienc5[(AoX)/40]==0) && (sy-A3Y>A3Height))
                            Alien3SpriteOn <=0;
                        if (AcounterW==A3Width-1)
                            begin
                                AcounterW <= 0;
                                if(AcolCount>1)
                                    AoX <= AoX + 40;
                                if((AoX<(AcolCount-1)*40))
								    A3address <= A3address - (A3Width-1);
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
                        // Check if Bee Bullet Has Hit Alien3          
                        if ((sx == xBBullet) && (sy == yBBullet) && (sx>A3X+AoX-1) && (BBhitAlien3 == 0) && (A3dout > 0))
                            begin
                                if((sy-A3Y<A3Height+1) && (alienc4[(AoX)/40]==1))    
                                    begin
                                        BBhitAlien3 <= 1;                                
                                        alienc4[(AoX)/40]<=0;
                                    end
                                if((sy-A3Y>A3Height) && (alienc5[(AoX)/40]==1))    
                                    begin
                                        BBhitAlien3 <= 1;                                
                                        alienc5[(AoX)/40]<=0;
                                    end
                            end                      
                    end
                else
                    Alien3SpriteOn <=0;
                    
                //Level Indicator
                if(Level>0)
                    begin
                        if(Level>9)
                            Level<=0;
                        if (sx==LevelX-2 && sy==LevelY)
                            begin
                                Ldout <= 26;
                                LevelSpriteOn <=1;
                                LcounterW<=0;
                                LcounterH<=0;
                            end
                        if ((sx>LevelX-2) && (sx<LevelX+LevelWidth) && (sy>LevelY-1) && (sy<LevelY+LevelHeight))
                            begin
                                Ldout <= 26;
                                LcounterW <= LcounterW + 1;
                                LevelSpriteOn <=1;
                                if(LcounterW==LevelWidth-1)
                                    begin
                                        if(LevelX<((Level-1)*8)+281)
                                            begin
                                              LcounterW <= 0;
                                              LevelX <= LevelX + 8;
                                            end
                                        else
                                            begin
								                LevelX = 281;
								                LcounterH <= LcounterH + 1;
								                LcounterW <= 0;
								                if(LcounterH==LevelHeight-1)
							                        begin
							                             LevelX = 281;
							                             LcounterH <= 0;
							                             LcounterW <= 0;
				                                    end
						                    end
								    end	    
                            end  
                       else
                            LevelSpriteOn <=0;
                    end
            end
        else
        // check if a column of Aliens have all been shot
        if (sx>640 && sy>480)
            begin
                if((alienc1[AcolCount-1]==0) && (alienc2[AcolCount-1]==0) && (alienc3[AcolCount-1]==0) && (alienc4[AcolCount-1]==0) && (alienc5[AcolCount-1]==0) && (AcolCount>1))
                        AcolCount<=AcolCount-1;
                else
                if((alienc1[0]==0) && (alienc2[0]==0) && (alienc3[0]==0) && (alienc4[0]==0) && (alienc5[0]==0) && (AcolCount>1))
                    begin
                        AcolCount<=AcolCount-1;
                        alienc1<=alienc1<<1;      
                        alienc2<=alienc2<<1;     
                        alienc3<=alienc3<<1;      
                        alienc4<=alienc4<<1;      
                        alienc5<=alienc5<<1;
                        A1X<=A1X+40;
                        A2X<=A2X+40;
                        A3X<=A3X+40;                        
                    end
           end 
           // slow down the alien movement / move aliens left or right
           if (sx==640 && sy==480)
            begin                          
                delaliens<=delaliens+1;
                if (delaliens>delloop)
                    begin
                        delaliens<=0;
                        if (Adir==2)
                            begin
                                A1X<=A1X+M;
                                A2X<=A2X+M;
                                A3X<=A3X+M;
                                if (A1X+A1Width+((AcolCount-1)*40)>(640-(M*2)-1))   
                                    Adir<=1;
                            end
                        else
                        if (Adir==1)
                            begin
                                A1X<=A1X-M;
                                A2X<=A2X-M;
                                A3X<=A3X-M;
                                if (A1X<(M*2)+2)
                                    Adir<=2;
                            end
                    end
               // If Alien has been shot increase the Score / If all Aliens have been shot reset the wave and Hives
               if(BBhitAlien1==1)
                    begin
                        BBhitAlien1<=0;
                        Score<=Score+30;
                        AlienQ<=AlienQ-1;
                    end
               if(BBhitAlien2==1)
                    begin
                        BBhitAlien2<=0;
                        Score<=Score+20;
                        AlienQ<=AlienQ-1;
                    end
               if(BBhitAlien3==1)
                    begin
                        BBhitAlien3<=0;
                        Score<=Score+10;
                        AlienQ<=AlienQ-1;
                    end
                if(Score>99999)
                        begin
                            Score<=Score-100000;
                        end
                if(AlienQ<1 && Score>0)
                    begin
                        Level<=Level+1;
                        AcolCount<=11;
                        AlienQ<=55;
                        delloop<=8;
                        A1X<=135;
                        A2X<=135;
                        A3X<=135;
                        M<=4;
                        alienc1<=11'b11111111111;
                        alienc2<=11'b11111111111;
                        alienc3<=11'b11111111111;
                        alienc4<=11'b11111111111;
                        alienc5<=11'b11111111111;
                        ResetHives<=1;
                    end
                if(AlienQ>0)
                        ResetHives<=0;
   
                // Alien speed up stages
                if(AlienQ==50)
                    delloop<=7;
                else    
                if(AlienQ==43)
                    delloop<=6;
                else
                if(AlienQ==36)
                    delloop<=5;
                else
                if(AlienQ==29)
                    delloop<=4;
                else
                if(AlienQ==22)
                    delloop<=3;
                else
                if(AlienQ==15)
                    delloop<=2;
                else
                if(AlienQ==8)
                    delloop<=1;
                else
                if(AlienQ==1)
                    M<=6;
            end
    end
endmodule