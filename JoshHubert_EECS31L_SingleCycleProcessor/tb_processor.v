`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh Hubert
// Company: EECS 31L
// Module Name: tb_processor
// Project Name: Lab 5
//////////////////////////////////////////////////////////////////////////////////

module tb_processor ();

  // test signals 
  reg         clk, rst;
  wire [31:0] tb_Result;
  integer     point = 0; 
  
  // DUT
  processor processor_inst (
    .clk     (clk),
    .reset   (rst),
    .Result  (tb_Result)
  );
  
  // clock
  always #10 clk = ~clk;
  
  // reset
  initial begin
    clk = 0;
    @(posedge clk);
    rst = 1;
    @(posedge clk);
    rst = 0;
  end
  
  //  --- TESTS ---
  
  always @(*) begin
    
    #20 if (tb_Result == 32'h00000000) // 0. and
      point = point + 1;
    #20 if (tb_Result == 32'h00000001) // 1. addi
      point = point + 1;
    #20 if (tb_Result == 32'h00000002) // 2. addi
      point = point + 1;
    #20 if (tb_Result == 32'h00000004) // 3. addi
      point = point + 1;
    #20 if (tb_Result == 32'h00000005) // 4. addi
      point = point + 1;
    #20 if (tb_Result == 32'h00000007) // 5. addi
      point = point + 1;
    #20 if (tb_Result == 32'h00000008) // 6. addi
      point = point + 1;
    #20 if (tb_Result == 32'h0000000b) // 7. addi
      point = point + 1;
    #20 if (tb_Result == 32'h00000003) // 8. add
      point = point + 1;
    #20 if (tb_Result == 32'hfffffffe) // 9. sub
      point = point + 1;
    #20 if (tb_Result == 32'h00000000) // 10. and
      point = point + 1;      
    #20 if (tb_Result == 32'h00000005) // 11. or
      point = point + 1;     
    #20 if (tb_Result == 32'h00000001) // 12. SLT
      point = point + 1;     
    #20 if (tb_Result == 32'hfffffff4) // 13. NOR
      point = point + 1;
    #20 if (tb_Result == 32'h000004D2) // 14. andi
      point = point + 1;
    #20 if (tb_Result == 32'hfffff8d7) // 15. ori   
      point = point + 1;
    #20 if (tb_Result == 32'h00000001) // 16. SLT
      point = point + 1;     
    #20 if (tb_Result == 32'hfffffb2c) // 17. nori
      point = point + 1;
    #20 if (tb_Result == 32'h00000030) // 18. sw
      point = point + 1;  
    #20 if (tb_Result == 32'h00000030) // 19. lw
      point = point + 1;
      
    $display("%s%d","The number of correct test cases is:" , point);
  end
  
  initial #430 $finish;

endmodule // tb_processor
