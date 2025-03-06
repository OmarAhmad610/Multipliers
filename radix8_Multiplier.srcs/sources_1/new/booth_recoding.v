module booth_radix8 #(parameter B = 32) (x, a, y);
	input signed [B-1:0] a;
	input [3:0] x;
	output reg signed [B+1:0] y;
	always @(*)
	begin
		case (x)
		4'b0001, 4'b0010 : y = a;
		4'b0011, 4'b0100 : y = a << 1;
		4'b0101, 4'b0110 : y = (a << 1) + a;
		4'b0111 : y = a << 2;
		4'b1000 : y = -(a << 2);
		4'b1001, 4'b1010 : y = -((a << 1) + a);
		4'b1011, 4'b1100 : y = -(a << 1);
		4'b1101, 4'b1110 : y = -a;
		default : y = 0;
		endcase
	end
endmodule