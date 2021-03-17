`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: RegFile
// Project Name: Lab 4
//////////////////////////////////////////////////////////////////////////////////

module RegFile #(
  parameter ADDR_W = 5,
  parameter DATA_W = 32
)(
  input                clk, reset, rg_wrt_en,                 // 1-bit flags
  input  [ADDR_W-1:0]  rg_wrt_addr, rg_rd_addr1, rg_rd_addr2,// 5-bit addresses to operate on
  input  [DATA_W-1:0]  rg_wrt_data,                         // 32-bit data write port
  output [DATA_W-1:0]  rg_rd_data1, rg_rd_data2            // 32-bit data read ports
  );
  
  // helper signals
  reg [DATA_W-1:0] reg_mem [2**(ADDR_W)-1:0]; // array of 32 32-bit register memories
  reg prev_reset = 1'b0;    // tracks value of reset on previous clock 
  integer i;               // index for looping

  // ---- BEHAVIOR ----
  
  // initialize registers to zero
  initial
    for (i = 0; i < 2**(ADDR_W); i = i+1)
      reg_mem[i] = 0;
  
  // READ: input read addresses and data values go to 
  // the two output lines, regardless of clock or reset. 
  
  assign rg_rd_data1 = reg_mem [rg_rd_addr1];
  assign rg_rd_data2 = reg_mem [rg_rd_addr2];
  
  // WRITE: if reset is 0 and enable is 1, on the clock, data
  // from rg_wrt_data goes to register number rg_wrt_addr.
  
  always @ (posedge clk, posedge reset) begin
  // 'posedge reset' for async reset
    
    if (reset & ~prev_reset)
      for (i = 0; i < 2**(ADDR_W); i = i+1)
        reg_mem[i] = 0;
        
    else if (rg_wrt_en & ~reset)
      reg_mem [rg_wrt_addr] = rg_wrt_data;
      
    // track previous state to prevent redundant clearing
    prev_reset = reset;
    
  end
 
endmodule // RegFile
