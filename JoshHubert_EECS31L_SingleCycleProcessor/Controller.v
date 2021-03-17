`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: Controller
// Project Name: Lab 5
//////////////////////////////////////////////////////////////////////////////////

module Controller (
  input  [6:0] Opcode,
  output       ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, // to datapath
  output [1:0] ALUOp                                         // to ALUctrl
  );
  
  // opcode instruction-type constants
  reg [6:0] R_TYPE, I_TYPE, LW, SW;
  
  initial begin
    R_TYPE = 7'b0110011; // uses rs1, rs2, and rd
    I_TYPE = 7'b0010011; // constant used instead of rs2
    LW     = 7'b0000011; // load, variant of I-type, rs2 not used
    SW     = 7'b0100011; // store, rd not used bc writing to DataMem
  end
  
  // --- SET CONTROL SIGNALS BASED ON INSTRUCTION TYPE ---
  
  // modes that use immediate as SrcB require alu_src to be 1
  assign ALUSrc   =  (Opcode == LW || Opcode == SW || Opcode == I_TYPE);
  
  // all modes implemented except 'store word' require reg_write to be 1
  assign RegWrite =  (Opcode == R_TYPE || Opcode == LW || Opcode == I_TYPE);
  
  // 'load word' is the only mode that writes memory data to reg_write_addr
  assign MemtoReg =  (Opcode == LW);
  assign MemRead  =  (Opcode == LW);
  assign MemWrite =  (Opcode == SW);
  
  // ALUOp bits set separately
  assign ALUOp[0] = (Opcode == LW || Opcode == SW);
  assign ALUOp[1] = (Opcode == R_TYPE); // 00 if I_TYPE
  // ALUOp logic reduction
//  assign ALUOp[0] = ~Opcode[4];               // 1 for LW and SW
//  assign ALUOp[1] =  Opcode[4] & Opcode[5];   // 1 for R-type

endmodule // Controller
