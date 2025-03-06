module CSA #(parameter w = 32)(x, y, z, S, C);
	input signed [w-1:0] x, y, z;
	output signed [w-1:0] S, C;
	assign S = x ^ y ^ z;
	assign C = (x & y) | (x & z) | (y & z);
endmodule