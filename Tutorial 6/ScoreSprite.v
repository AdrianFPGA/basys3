//----------------------------------------------
// ScoreSprite.v Module         
// Digilent Basys 3             
// Bee Invaders Tutorial_6
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup ScoreSprite module
module ScoreSprite(
    input wire clk_pix,                 // 25.2MHz pixel clock
    input wire [9:0] sx,
    input wire [9:0] sy,
    input wire de,
    input wire [16:0] Score,            // Score value
    output reg [1:0] ScoreSpriteOn,     // 1=on, 0=off
    output wire [7:0] Scoredout,        // pixel value from Score.mem
    output reg [1:0] DigitsSpriteOn,    // 1=on, 0=off
    output wire [7:0] Digitsdout        // pixel value from Digit.mem
    );

    // instantiate ScoreRom
    reg [9:0] Scoreaddress;             // 2^10 or 1023, need 55 x 13 = 715
    ScoreRom ScoreVRom (
        .Scoreaddress(Scoreaddress),
        .clk_pix(clk_pix),
        .Scoredout(Scoredout)
    );

    // instantiate DigitsRom
    reg [10:0] Digitsaddress;           // 2^11 or 2047, need 110 x 13 = 1430
    DigitsRom DigitsVRom (
        .Digitsaddress(Digitsaddress),
        .clk_pix(clk_pix),
        .Digitsdout(Digitsdout)
    );
    
    // setup Score and Digits positions, sizes and variables
    localparam ScoreWidth = 55;         // Score width in pixels
    localparam ScoreHeight = 13;        // Score height in pixels
    localparam ScoreX = 6;              // Score X position
    localparam ScoreY = 6;              // Score Y position
    localparam scorevalx = 80;          // Score value X position
    localparam scposxl = 11;            // One digit - pixel width
    localparam scposyl = 13;            // One digit - pixel height
    reg [10:0] scoreyoffset=0;          // Y offset used in calculating Digitsaddress
    reg [16:0] digit5=0;                // 5th digit value of score
    reg [13:0] digit4=0;                // 4th digit value of score
    reg [9:0] digit3=0;                 // 3rd digit value of score
    reg [6:0] digit2=0;                 // 2nd digit value of score
    reg [3:0] digit1=0;                 // 1st digit value of score
    reg [6:0] t10=10;                   // used to calculate digit1-5
    reg [9:0] t100=100;                 // used to calculate digit1-5
    reg [13:0] t1000=1000;              // used to calculate digit1-5
    reg [16:0] t10000=10000;            // used to calculate digit1-5
    reg [7:0] counter = 0;              // used to calculate digit1-5

    always @ (posedge clk_pix)
    begin
        // if sx,sy are within the confines of the Score character, switch the Score On
        if(de)
            begin
                if((sx==ScoreX-2) && (sy==ScoreY))              
                    begin
                        Scoreaddress <=0;                       
                        ScoreSpriteOn <=1;
                    end
                if((sx>ScoreX-2) && (sx<ScoreX+ScoreWidth-1) && (sy>ScoreY-1) && (sy<ScoreY+ScoreHeight))
                    begin
                        ScoreSpriteOn <=1;
                        Scoreaddress <= Scoreaddress + 1;
                    end
                else 
                        ScoreSpriteOn <=0;
                if((sx==scorevalx-2) && (sy==ScoreY))
				begin
				    scoreyoffset <= 110;
				    DigitsSpriteOn <=1;
					digit5 <= Score / t10000;
					digit4<= (Score-(digit5*t10000)) / t1000;
					digit3<= (Score-((digit5*t10000)+(digit4*t1000))) / t100;
					digit2<= (Score-((digit5*t10000)+(digit4*t1000)+(digit3*t100))) / t10;
					digit1<= (Score-((digit5*t10000)+(digit4*t1000)+(digit3*t100)+(digit2*t10)));
					Digitsaddress <= digit5 * scposxl;
					counter<=0;
				end
				if((sx>scorevalx-2) && (sx<scorevalx+(scposxl*5)-1) && (sy>ScoreY-1) && (sy<ScoreY+scposyl))
				    begin
                        DigitsSpriteOn <=1;	
                        counter <= counter + 1;
                        if(counter==(scposxl*1)-1)
                            Digitsaddress<=(digit4*scposxl)+(scoreyoffset-110);
                        else
                        if(counter==(scposxl*2)-1)
                            Digitsaddress<=(digit3*scposxl)+(scoreyoffset-110);
                        else
                        if(counter==(scposxl*3)-1)
							Digitsaddress<=(digit2*scposxl)+(scoreyoffset-110);
					    else
                        if(counter==(scposxl*4)-1)
                            Digitsaddress<=(digit1*scposxl)+(scoreyoffset-110);
                        else
                            Digitsaddress <= Digitsaddress + 1;	
                end
				    else
                            DigitsSpriteOn <=0;
                            if(counter==scposxl*5)
                            begin
                                scoreyoffset <= scoreyoffset + 110;  
                                Digitsaddress <= (digit5 * scposxl) + scoreyoffset;
                                counter<=0;
                            end	
            end
    end
endmodule