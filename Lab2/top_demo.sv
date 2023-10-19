`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2021 06:40:11 PM
// Design Name: 
// Module Name: top_demo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_demo
(
  // input
  input  logic [7:0] sw,
  input  logic [3:0] btn,
  input  logic       sysclk_125mhz,
  input  logic       rst,
  // output  
  output logic [7:0] led,
  output logic sseg_ca,
  output logic sseg_cb,
  output logic sseg_cc,
  output logic sseg_cd,
  output logic sseg_ce,
  output logic sseg_cf,
  output logic sseg_cg,
  output logic sseg_dp,
  output logic [3:0] sseg_an
);

  logic [16:0] CURRENT_COUNT;
  logic [16:0] NEXT_COUNT;
  logic        smol_clk;
  logic [15:0] toSeg;
  logic encrypt;
  logic cipher;
  assign encrypt = sw[7];
  assign cipher = sw[6];
  
  
logic [64:0] plainText; 
   always @(*) 
   begin
    case(sw[3:0])
        4'b0000: toSeg = plainText[15:0];
        4'b0001: toSeg = plainText[31:16];
        4'b0010: toSeg = plainText[47:32];
        4'b0011: toSeg = plainText[63:48];
        default: toSeg = 16'h0;
    endcase
    end
    
    logic keyCheck;
    logic [7:0] parityKeys;
    logic [63:0] keys;
    assign parityKeys[0] = ^keys[7:0];
    assign parityKeys[1] = ^keys[15:8];
    assign parityKeys[2] = ^keys[23:16];
    assign parityKeys[3] = ^keys[31:24];
    assign parityKeys[4] = ^keys[39:32];
    assign parityKeys[5] = ^keys[47:40];
    assign parityKeys[6] = ^keys[55:48];
    assign parityKeys[7] = ^keys[63:56];
    
    assign keyCheck = ^parityKeys[7:0];
    assign keyCheck = led[0];
       
    
  
  
  // Place TicTacToe instantiation here
  
  // 7-segment display
  segment_driver driver(
  .clk(smol_clk),
  .rst(btn[3]),
  .digit0(sw[3:0]),
  .digit1(4'b0111),
  .digit2(sw[7:4]),
  .digit3(4'b1111),
  .decimals({1'b0, btn[2:0]}),
  .segment_cathodes({sseg_dp, sseg_cg, sseg_cf, sseg_ce, sseg_cd, sseg_cc, sseg_cb, sseg_ca}),
  .digit_anodes(sseg_an)
  );
  
// Register logic storing clock counts
  always@(posedge sysclk_125mhz)
  begin
    if(btn[3])
      CURRENT_COUNT = 17'h00000;
    else
      CURRENT_COUNT = NEXT_COUNT;
  end
  
  // Increment logic
  assign NEXT_COUNT = CURRENT_COUNT == 17'd100000 ? 17'h00000 : CURRENT_COUNT + 1;

  // Creation of smaller clock signal from counters
  assign smol_clk = CURRENT_COUNT == 17'd100000 ? 1'b1 : 1'b0;

endmodule
