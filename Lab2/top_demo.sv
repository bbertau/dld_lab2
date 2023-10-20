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

  logic [63:0] Key = 64'h133457799bbcdff1;
  logic [63:0] IV = 64'h0000000000000001;
  logic encrypt;
  logic cipher;
  logic clk;
  logic [15:0] digit;
  logic [3:0] disp = sw[3:0];
  logic [16:0] c_clock;
  logic [16:0] n_count;
  logic [63:0] plaintext = 64'h123456abcd132536;
  logic [63:0] ciphertext;
  assign encrypt = sw[7];
  assign cipher = sw[6];
  assign led[0] = encrypt;
  assign led[1] = cipher;
  assign led[7]= (ciphertext == 64'hf77bcd7dfe57e119);
  // Place DES instantiation here
  DES dut(Key, plaintext, encrypt, cipher, IV, ciphertext);
  always @ (*) begin
    case (disp)
    4'b0100: digit = Key[63:48];
    4'b0101: digit = Key[47:32];
    4'b0110: digit = Key[31:16];
    4'b0111: digit = Key[15:0];
    4'b1100: digit = IV[63:48];
    4'b1101: digit = IV[47:32];
    4'b1110: digit = IV[31:16];
    4'b1111: digit = IV[15:0];
    4'b0000: digit = plaintext[63:48];
    4'b0001: digit = plaintext[47:32];
    4'b0010: digit = plaintext[31:16];
    4'b0011: digit = plaintext[15:0];
    4'b1000: digit = ciphertext[63:48];
    4'b1001: digit = ciphertext[47:32];
    4'b1010: digit = ciphertext[31:16];
    4'b1011: digit = ciphertext[15:0];
    endcase
  end
  
  
  
  // 7-segment display
  segment_driver driver(
  .clk(clk),
  .rst(btn[3]),
  .digit0(digit[3:0]),
  .digit1(digit[7:4]),
  .digit2(digit[11:8]),
  .digit3(digit[15:12]),
  .decimals({1'b0, btn[2:0]}),
  .segment_cathodes({sseg_dp, sseg_cg, sseg_cf, sseg_ce, sseg_cd, sseg_cc, sseg_cb, sseg_ca}),
  .digit_anodes(sseg_an)
  );

// Register logic storing clock counts
  always@(posedge sysclk_125mhz)
  begin
    if(btn[3])
      c_clock = 17'h00000;
    else
      c_clock = n_count;
  end

  assign n_count = c_clock == 17'd100000 ? 17'h00000 : c_clock + 1;

  assign clk = c_clock == 17'd100000 ? 1'b1 : 1'b0;


endmodule
