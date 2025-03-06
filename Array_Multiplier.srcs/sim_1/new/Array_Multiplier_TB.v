module Array_Multiplier_TB #(parameter width = 32)();
	reg signed [width-1:0] a, x;
	wire signed [2*width-1:0] Result;

	reg signed [2*width-1:0] expected;
	integer i;
	
	(* dont_touch = "true" *) Array_Multiplier #(width) I0 (a, x, Result);

	initial	begin
        for (i = 0; i < 8; i = i + 1) begin
            a = $random; x = $random;
			expected = a*x;
			#10;
		end
	end
	
	initial
		$monitor ("a = %d, x = %d, Result = %d, expected = %d", a, x, Result, expected);
endmodule
