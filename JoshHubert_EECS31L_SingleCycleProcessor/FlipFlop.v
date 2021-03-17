`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: FlipFlop
// Project Name: Lab 4
//////////////////////////////////////////////////////////////////////////////////

module FlipFlop #(
  parameter WIDTH = 8
)(
  input                   clk, reset,
  input      [WIDTH-1:0]  d,
  output reg [WIDTH-1:0]  q = 0 // comment out init to make first half cycle red X's
  );

  // behavior 
  always @ (posedge clk)
    q <= (reset)? 0 : d;
  
endmodule // FlipFlop
