`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: ALUController
// Project Name: Lab 5
//////////////////////////////////////////////////////////////////////////////////

module ALUController (
  input  [1:0] ALUOp, 
  input  [6:0] Funct7, 
  input  [2:0] Funct3,
  output [3:0] Operation
  );  
  
  // breaking it down
  assign Operation[0] = ((Funct3 == 3'b110) | (Funct3 == 3'b010 & ~ALUOp[0]));
  assign Operation[1] = ((Funct3 == 3'b000) | (Funct3 == 3'b010));
  assign Operation[2] = ((Funct3 == 3'b100) | (Funct3 == 3'b010 & ~ALUOp[0]) | (Funct7 == 7'b0100000 & ALUOp[1]) );
  assign Operation[3] =  (Funct3 == 3'b100);
  
endmodule // ALUController
