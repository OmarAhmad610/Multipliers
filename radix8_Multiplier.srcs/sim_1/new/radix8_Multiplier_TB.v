`timescale 1ns/1ps

module radix8_Multiplier_TB ();
    localparam width = 32;
	localparam clk_period = 10;
	localparam delay = ((width+8)/3)*clk_period;
	
	reg clk, rst_n;
	reg signed [width-1:0] a, x;
	wire signed [2*width-1:0] Result;
	
	reg signed [2*width-1:0] expected;
	integer i;
	
	(* dont_touch = "true" *) radix8_Multiplier #(width) UUT (clk, rst_n, a, x, Result);
	
	initial begin
	   clk = 0;
	   forever #(clk_period/2) clk = ~clk;
	end

	initial begin
	   rst_n = 0;
	   for (i = 0; i < 8; i = i + 1) begin
	       a = $random;
           x = $random;
           expected = a*x;
	       #2 rst_n = 1;
   	       #(delay);
   	       if (Result == expected) begin
   	        $display ("a = %d, x = %d, Result = %d, expected = %d", a, x, Result, expected);
   	        $display ("Correct");
   	       end
   	       else begin
   	        $display ("a = %d, x = %d, Result = %d, expected = %d", a, x, Result, expected);
   	        $display ("Wrong");  
           end
           rst_n = 0;
       end
       $stop;
	end
endmodule