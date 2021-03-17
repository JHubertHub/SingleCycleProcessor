`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: MUX21
// Project Name: Lab 4
//////////////////////////////////////////////////////////////////////////////////

module MUX21 #(
  parameter WIDTH = 32
)(
  input  [WIDTH-1:0]  D1, D2, 
  input               S,
  output [WIDTH-1:0]  Y
  );
  
  // data flow
  assign Y = (~S)?  D1 : D2;

endmodule // MUX21
