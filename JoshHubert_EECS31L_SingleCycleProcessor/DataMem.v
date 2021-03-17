`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: DataMem
// Project Name: Lab 4
//////////////////////////////////////////////////////////////////////////////////

module DataMem #(
  parameter ADDR_W = 9,
  parameter DATA_W = 32
)(
  input                MemRead, MemWrite, 
  input  [ADDR_W-1:0]  addr, 
  //input  [6:0]  addr,  // attempting to fix weird vivado bug with multiple writes at once
  input  [DATA_W-1:0]  write_data, 
  output [DATA_W-1:0]  read_data 
  );

  // helper signals
  reg [(DATA_W-1):0] memory [(2**(ADDR_W-2)-1):0]; // array of 128 32-bit datas

  integer i; // index for initializing memory
  
  // READ if MemRead == 1
  assign read_data = (MemRead)? memory[addr[(ADDR_W-1):2]] : 32'hdeadbeef; 
  //assign read_data = (MemRead)? memory[addr[6:0]] : 32'hdeadbeef; 

  // 128 memory slots, so use bits 2-8
  
  // WRITE if MemWrite == 1
  // trigger when MemWrite turns on or write_data or addr change
  always @ (posedge MemWrite, write_data, addr) 
    if (MemWrite)
      memory[addr[(ADDR_W-1):2]] = write_data;
      //memory[addr[6:0]] = write_data;

  // initialize to 0
  initial
    for (i = 0; i < 2**(ADDR_W-2); i = i+1)
      memory[i] = 0;
  
endmodule // DataMem
