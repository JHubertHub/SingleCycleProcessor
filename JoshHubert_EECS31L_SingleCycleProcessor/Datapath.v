`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: data_path
// Project Name: Lab 4
//////////////////////////////////////////////////////////////////////////////////

module data_path #(
  parameter PC_W = 8,                 // Program Counter    
  parameter INS_W = 32,               // Instruction Width
  parameter RF_ADDRESS = 5,           // Register File Address
  parameter DATA_W = 32,              // Data WriteData
  parameter DM_ADDRESS = 9,           // Data Memory Address
  parameter ALU_CC_W = 4              // ALU Control Code Width
)(
  input                  clk,         // CLK in datapath figure        X
  input                  reset,       // Reset in datapath figure      X   
  input                  reg_write,   // RegWrite in datapath figure   X
  input                  mem2reg,     // MemtoReg in datapath figure   X
  input                  alu_src,     // ALUSrc in datapath figure     X
  input                  mem_write,   // MemWrite in datapath figure   X
  input                  mem_read,    // MemRead in datapath figure    X      
  input  [ALU_CC_W-1:0]  alu_cc,      // ALUCC in datapath figure      X
  output          [6:0]  opcode,      // opcode in dataptah figure     X
  output          [6:0]  funct7,      // Funct7 in datapath figure     X
  output          [2:0]  funct3,      // Funct3 in datapath figure     X
  output   [DATA_W-1:0]  alu_result   // Datapath_Result in datapath figure, either data or memory address
  );

  // the inter-module connection wires
  wire   [PC_W-1:0]  PC, PCplus4;     // program counter  
  wire  [INS_W-1:0]  Instruct;        // instruction data
  wire [DATA_W-1:0]  Reg1, Reg2;      // register read data
  wire [DATA_W-1:0]  ExtImm;          // Sign-extended immediate data (a constant)
  wire [DATA_W-1:0]  SrcB;            // ALU source B, either Reg2 or ExtImm
  wire [DATA_W-1:0]  DataMem_read;    // data read from DataMem
  wire [DATA_W-1:0]  WriteBack_Data;  // written back to specified register


  // --- THE DATAPATH TEAM ---
  
  FlipFlop #(.WIDTH(PC_W))  Florence (
    .clk          (clk),
    .reset        (reset),
    .d            (PCplus4),
    .q            (PC)
  );
  
  assign PCplus4 = PC + 8'd4;
  
  InstMem #(.ADDR_W(PC_W), .INST_W(INS_W))  Ingrid (
    .addr         (PC),
    .instruction  (Instruct)
  );
  
  // instruction-decode output wires
  assign opcode = Instruct [6:0];
  assign funct7 = Instruct [31:25];
  assign funct3 = Instruct [14:12];
  
  RegFile #(.ADDR_W(RF_ADDRESS), .DATA_W(DATA_W))  Reginald (
    .clk          (clk),                          // 1-bit flags
    .reset        (reset),
    .rg_wrt_en    (reg_write), 
    .rg_wrt_addr  (Instruct [7+RF_ADDRESS-1:7]),  // 5-bit addresses to operate on
    .rg_rd_addr1  (Instruct [15+RF_ADDRESS-1:15]),
    .rg_rd_addr2  (Instruct [20+RF_ADDRESS-1:20]),
    .rg_wrt_data  (WriteBack_Data),               // 32-bit data write port
    .rg_rd_data1  (Reg1),                         // 32-bit data read ports
    .rg_rd_data2  (Reg2)
  );
  
  ImmGen #(.INST_W(INS_W), .DATA_W(DATA_W))  Imogen ( 
    .InstCode     (Instruct),
    .ImmOut       (ExtImm)
  );

  MUX21 #(.WIDTH(DATA_W))  Monty (
    .D1           (Reg2),
    .D2           (ExtImm),
    .S            (alu_src),
    .Y            (SrcB)
  );
  
  alu_32 Albert ( // didn't want to mess with Albert
    .A_in         (Reg1),
    .B_in         (SrcB),
    .ALU_Sel      (alu_cc),
    .ALU_Out      (alu_result), // output wire
    .Carry_Out    (),           // flags unused
    .Zero         (),
    .Overflow     () 
  );
  
  DataMem #(.ADDR_W(DM_ADDRESS), .DATA_W(DATA_W))  Dana (
    .MemRead      (mem_read),
    .MemWrite     (mem_write),
    .addr         (alu_result[(DM_ADDRESS-1):0]),
    //.addr         (alu_result[8:2]),  
    .write_data   (Reg2),
    .read_data    (DataMem_read)
  );
  
  MUX21 #(.WIDTH(DATA_W))  Monica (
    .D1           (alu_result),
    .D2           (DataMem_read),
    .S            (mem2reg),
    .Y            (WriteBack_Data)
  );
  
endmodule // data_path
