module radix8_Multiplier #(parameter n = 32)(clk, rst_n, a, x, Result);
	input clk, rst_n;
	input signed [n-1:0] a, x;
	output reg signed [(2*n)-1:0] Result;

	wire [n+1:0]y, S, C; 
	wire [n-1:0] SUM, CARRY, fs;
	wire [n-2:0] Final_S;
	reg signed [n+1:0]sum, carry, multiplier;
	reg FF, count;
	wire [3:0] adder;

	assign adder = sum[2:0]+{carry[1:0],FF};
	assign SUM = {sum[n+1], sum[n+1:3]};
	assign CARRY = carry[n+1:2];
	assign fs = SUM + CARRY + adder[3];
	assign Final_S = fs[n-2:0];
	booth_radix8 #(n) B0 (multiplier[3:0], a, y);

	CSA #(n+2) C0 (y, {{2{SUM[n-1]}}, SUM}, {{2{CARRY[n-1]}}, CARRY}, S, C);
	
	always @(posedge clk or negedge rst_n) 
	begin
		if(!rst_n)
		begin
			multiplier <= 0;
			sum <= 0;
			carry <= 0;
			FF <= 0;
			Result <= 0;
			count <= 1'b1;
		end
		
		else if (count == 1'b1)
		begin
		  multiplier <= {x[n-1], x, 1'b0};
          sum <= 0;
          carry <= 0;
          FF <= 0;
          Result <= 0;
          count <= 1'b0;
		end
		else
		begin
			multiplier <= multiplier >>> 3;
			sum <= S;
			carry <= C;
			FF <= adder[3];
			
			if (n%3 == 2)
    			Result <= {Final_S, adder[2:0], Result[n:3]};
    		else if (n%3 == 1)
    			Result <= {Final_S, adder[2:0], Result[n+1:3]};
    		else
    			Result <= {Final_S[n-2], Final_S, adder[2:0], Result[n-1:3]};
		end
	end
endmodule