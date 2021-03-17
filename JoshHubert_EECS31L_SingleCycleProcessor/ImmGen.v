`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: ImmGen
// Project Name: Lab 4
//////////////////////////////////////////////////////////////////////////////////

module ImmGen #(
  parameter INST_W = 32,
  parameter DATA_W = 32
)(
  input      [INST_W-1:0]  InstCode,
  output reg [DATA_W-1:0]  ImmOut
  );

  // behavior
  always @ (InstCode) begin
  
    case (InstCode[6:0])
    
      // I-type - Load Word only
      7'b0000011:
        // sign-extend 1 or 0 based on bit 31
        ImmOut = {InstCode[31]? {20{1'b1}} : 20'b0, InstCode[31:20]};
        
      // I-type - non-Load (all other ops involving an immediate)
      7'b0010011:
        ImmOut = {InstCode[31]? {20{1'b1}} : 20'b0, InstCode[31:20]};
        
      // S-type - Store Word only
      7'b0100011: // different instruction config since rs2 used and rd not used
        ImmOut = {InstCode[31]? {20{1'b1}} : 20'b0, InstCode[31:25], InstCode[11:7]};
        
      // U-type - idk
      7'b0010111:
        ImmOut = {InstCode[31:12], 12'b0};
      
      // covers all R-Type instructions (involving both rs1 and rs2)
      default: ImmOut = {32'b0}; // since they don't use an immmediate
      
    endcase
    
  end
  
endmodule // ImmGen
