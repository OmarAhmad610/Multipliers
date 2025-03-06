`timescale 1ns/1ps

module Shift_Right_Multiplier_TB ();
    localparam width = 32;
	localparam clk_period = 10;
	localparam delay = (width + 2) * clk_period;

	reg signed [width-1:0] a, x;
	reg clk, rst_n;
	wire signed [2*width:0] Result;

    reg signed [2*width:0] expected;

    integer i;

	(* dont_touch = "true" *) Shift_Right_Multiplier #(width) UUT (a, x, clk, rst_n, Result);
	
	initial
	begin
		clk = 1'b0;
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