//----------------------------------------------
// BBulletSprite.v Module         
// Digilent Basys 3             
// Bee Invaders Tutorial_6
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup BBulletSprite module
module BBulletSprite(
    input wire clk_pix,                 // 25.2MHz pixel clock
    input wire [9:0] sx,                // current x position
    input wire [9:0] sy,                // current y position
    input wire de,                      // 1 = visible pixels, 0 = blanking period
    input wire btnF,                    // fire button
    input wire [9:0] BeeX,              // bee bullet x position
    input wire [1:0] BBhithive1,        // 1 = bullet hit hive, 0 = no hit
    input wire [1:0] BBhithive2,        // 1 = bullet hit hive, 0 = no hit
    input wire [1:0] BBhithive3,        // 1 = bullet hit hive, 0 = no hit
    input wire [1:0] BBhithive4,        // 1 = bullet hit hive, 0 = no hit
    input wire [1:0] BBhitAlien1,       // 1 = bullet hit Alien1, 0 = no hit
    input wire [1:0] BBhitAlien2,       // 1 = bullet hit Alien2, 0 = no hit
    input wire [1:0] BBhitAlien3,       // 1 = bullet hit Alien3, 0 = no hit
    output reg [1:0] BBulletSpriteOn,   // 1=on, 0=off
    output wire [7:0] BBdout,           // pixel value from BBullet.mem
    output reg [9:0] yBBullet,          // y coordinate for Bee Bullet
    output reg [9:0] xBBullet,          // bee bullet x position
    output reg [1:0] BBulletstate       // 1 = moving, 2 = stopped
    );
    
    // instantiate BBulletRom
    reg [3:0] BBaddress;                // 2^4 or 15, need 1 x 7 = 7
    BBulletRom BBulletVRom (
        .BBaddress(BBaddress),
        .clk_pix(clk_pix),
        .BBdout(BBdout)
    );
    
    // Instantiate Debounce
    Debounce deb_fire (
        .clk_pix(clk_pix),
        .btn(btnF),
        .out(sig_fire)
    );
    
    // setup character size
    localparam BBWidth = 1;             // Bee Bullet width in pixels
    localparam BBHeight = 7;            // Bee Bullet height in pixels
  
    always @ (posedge clk_pix)
    begin
        // if sx,sy are within the confines of the Bee Bullet character, switch the Bee Bullet On
        if((de) && (BBulletstate == 1))
            begin
                if((sx==xBBullet-2) && (sy==yBBullet))                  
                    begin
                        BBaddress <= 0;                       
                        BBulletSpriteOn <=1;
                    end
                if((sx>xBBullet-2) && (sx<xBBullet+BBWidth-1) && (sy>yBBullet-1) && (sy<yBBullet+BBHeight)) 
                    begin
                        BBaddress <= BBaddress +1;              
                        BBulletSpriteOn <=1;
                    end
                else
                    BBulletSpriteOn <=0;
            end
        else    
        // if fire button pressed, move the Bee Bullet up the screen
        if ((sx==640) && (sy==480))                         // check for movement once every frame
        begin                         
            if (BBulletstate == 0)
                begin
                    BBulletstate <= 2;                      // initialise BBulletstate = stopped 
                end
            if ((sig_fire == 1) && (xBBullet == 0))         // Check for fire button and bullet stopped
                begin
                    xBBullet <= BeeX + 16;
                    yBBullet<=425;
                    BBulletstate<=1;                        // 1 = bullet moving, 2 = bullet stopped 
                end
            if ((BBulletstate == 1))                        
                begin
                    yBBullet<=yBBullet-2;                   // move bullet up the screen
                    if ((BBhithive1 == 1) || (BBhithive2 == 1) || (BBhithive3 == 1) || (BBhithive4 == 1) || (BBhitAlien1 == 1) || (BBhitAlien2 == 1) || (BBhitAlien3 == 1)) // Check if Bee Bullet has hit hive1-4 and Alien1-3   
                        begin
                            BBulletstate<=2;                // stop the bullet
                            yBBullet<=425;                  // bullet y start position
                            xBBullet<=0; 
                        end               
                    if (yBBullet<10)                        // Check if Bee Bullet at top of screen
                        begin
                            BBulletstate<=2;                // stop the bullet
                            yBBullet<=425;                  // bullet y start position
                            xBBullet<=0; 
                        end
                end
        end    
    end
endmodule