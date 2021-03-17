`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: alu_32
// Project Name: Lab 4
//////////////////////////////////////////////////////////////////////////////////

module alu_32 (
  input wire signed [31:0]  A_in, B_in,
  input wire         [3:0]  ALU_Sel,
  output reg signed [31:0]  ALU_Out,
  output reg                Carry_Out = 1'b0, Zero = 1'b0, Overflow = 1'b0
  );
  
  // submodule output connections
  wire signed [31:0] Add_res, Sub_res; // results
  wire Add_C, Add_O, Sub_C, Sub_O; // Couts, Overflows

  // submodule instantiation
  Add32 Adder (
    .AS_sel  (1'b0), // Addition mode
    .A       (A_in),
    .B       (B_in),
    .Sum     (Add_res),
    .Cout    (Add_C),
    .oFlow   (Add_O)
  );       
  
  Add32 Subber(
    .AS_sel  (1'b1), // Subtraction mode
    .A       (A_in),
    .B       (B_in),
    .Sum     (Sub_res),
    .Cout    (Sub_C),
    .oFlow   (Sub_O)
  );       
 
  // ALU behavior 
  always @ (*) begin
  
    {Carry_Out, Overflow} = 2'b0; // start off setting both to 0

    case (ALU_Sel)
      
      // AND
      4'b0000:
        ALU_Out = A_in & B_in;
      
      // OR
      4'b0001:
        ALU_Out = A_in | B_in;
      
      // ADD - SIGNED
      4'b0010: begin
        ALU_Out = Add_res;
        Carry_Out = Add_C;
        Overflow = Add_O;
      end
      
      // SUBTRACT - SIGNED         
      4'b0110: begin
        ALU_Out = Sub_res;
        Carry_Out = 1'b0; // no carry-out returned as per spec
        Overflow = Sub_O;
      end
      
      // SET LESS THAN - SIGNED
      4'b0111: begin
        // can't be lower than lowest number
        if (B_in == 32'h80000000)
          ALU_Out = 0;
        else
        // if (Aneg & Bpos) OR (A and B same sign & [A-B]neg) => A < B
          ALU_Out = (A_in[31] & ~B_in[31]) | (~(A_in[31] ^ B_in[31]) & Sub_res[31]);
      end
      
      // NOR        
      4'b1100:
        ALU_Out = ~(A_in | B_in);
      
      // EQUAL COMPARISON        
      4'b1111:
        ALU_Out = &(~(A_in ^ B_in)); // &reduce on XNOR (aka Equality) 
      
      // TRY AGAIN
      default:
        ALU_Out = 0;

    endcase
    
    // Zero check
    Zero = &(~ALU_Out); // if ALU_Out is all 0s, &reduce will be true
    
  end // ALU behavior
  
endmodule // alu_32


// ADDER SUBMODULE - does subtraction too
module Add32 (
  input              AS_sel, // 0 => add, 1 => subtract
  input      [31:0]  A, B,
  output reg [31:0]  Sum,
  output reg         Cout,
  output reg         oFlow 
  );
  
  // helper signal
  reg [31:0] Breg;

  // behavior
  always @ (AS_sel, A, B) begin
    // conversion for 2s-comp subtraction
    Breg = (AS_sel)? ~B+1 : B;
    
    // the addition
    {Cout, Sum} = A + Breg;
  
    // overflow check
    oFlow = (( A[31] &  Breg[31] & ~Sum[31]) |  // if (A- & B- & S+)
             (~A[31] & ~Breg[31] &  Sum[31]) |  // or (A+ & B+ & S-)
             (AS_sel &  B[31]    & Breg[31]) ); // or subtracted B=-2^16
  end
endmodule // Add32

// that's all folks