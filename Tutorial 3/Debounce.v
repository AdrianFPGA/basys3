//----------------------------------------------
// Debounce.v Module         
// Digilent Basys 3             
// Bee Invaders Tutorial_3
// Onboard clock 100MHz
// VGA Resolution: 640x480 @ 60Hz
// Pixel Clock 25.2MHz
//----------------------------------------------
`timescale 1ns / 1ps

// Setup Debounce module
module Debounce (
    input wire clk_pix,             // Clock signal to synchronize the button input
    input wire btn,
    output wire out
  );
 
  reg [19:0] ctr_d;                 // 20 bit counter to increment when button is pressed or released
  reg [19:0] ctr_q;                 // 20 bit counter to increment when button is pressed or released
  reg [1:0] sync_d;                 // button flip-flop for synchronization              
  reg [1:0] sync_q;                 // button flip-flop for synchronization
 
  assign out = ctr_q == {20{1'b1}}; // if ctr_q = 11111111111111111111
 
  always @(*) 
  begin
    sync_d[0] = btn;
    sync_d[1] = sync_q[0];
    ctr_d = ctr_q + 1'b1;
 
    if (ctr_q == {20{1'b1}})
      ctr_d = ctr_q;
 
    if (!sync_q[1])
      ctr_d = 20'd0;
  end
 
  always @(posedge clk_pix) 
  begin
    ctr_q <= ctr_d;
    sync_q <= sync_d;
  end
endmodule