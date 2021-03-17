`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: processor
// Project Name: Lab 5
//////////////////////////////////////////////////////////////////////////////////

module processor (
  input         clk, reset, 
  output [31:0] Result
  );
  
  // --- connection wires ---
  
  wire [6:0] Opcode;     // dp to ctrl
  wire [1:0] ALUOp;      // ctrl to ALUctrl
  wire [6:0] Funct7;     // dp to ALUctrl
  wire [2:0] Funct3;     // dp to ALUctrl
  wire [3:0] Operation;  // ALUctrl to dp
  // ctrl to dp
  wire ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite;
  
  // --- structure ---
  
  data_path dp (
    .clk         (clk),        // in ext
    .reset       (reset),   
    .reg_write   (RegWrite),   // in from ctrl
    .mem2reg     (MemtoReg),
    .alu_src     (ALUSrc), 
    .mem_write   (MemWrite), 
    .mem_read    (MemRead),   
    .alu_cc      (Operation),  // in from ALUctrl
    .opcode      (Opcode),     // out to ctrl
    .funct7      (Funct7),     // out to ALUctrl
    .funct3      (Funct3),
    .alu_result  (Result)      // out ext
  );
  
  Controller ctrl (
    .Opcode      (Opcode),     // in from dp
    .ALUSrc      (ALUSrc),     // out to dp
    .MemtoReg    (MemtoReg),   
    .RegWrite    (RegWrite),
    .MemRead     (MemRead),
    .MemWrite    (MemWrite),
    .ALUOp       (ALUOp)       // out to ALUctrl
  );
  
  ALUController alu_ctrl (
    .ALUOp       (ALUOp),      // in from ctrl
    .Funct7      (Funct7),     // in from dp
    .Funct3      (Funct3),
    .Operation   (Operation)   // out to dp
  );

endmodule // processor
