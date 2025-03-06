module Array_Multiplier #(parameter n = 5)(a, x, Result);
    input signed [n-1:0] a, x;
    output signed[2*n-1:0] Result;
    
    wire [n-1:0] multiplier, multiplicand;
    wire [n-2:0] c [0:n-2];
    wire [n-2:0] s [0:n-2];
    wire sign;
    wire [2*n-1:0] p;
    wire [n-2:0] carry;

    assign multiplier = x[n-1] ? (~x + 1'b1) : x;
    assign multiplicand = a[n-1] ? (~a + 1'b1) : a;
    assign p[0] = multiplicand[0] & multiplier[0];
    assign p[2*n-1] = carry[n-2];
    assign sign = x[n-1] ^ a[n-1];

    genvar i, j;
    generate	
        for (i = 0; i < n-1; i = i + 1)
        begin : first_stage
            fall_adder_array I0 (1'b0, multiplicand[i+1] & multiplier[0], multiplicand[i] & multiplier[1], s[0][i], c[0][i]);
        end
        
        for (i = 0; i < n-2; i = i + 1)
        begin : inner_stages
            for (j = 0; j < n-2; j = j + 1)
                fall_adder_array I1 (c[i][j], s[i][j+1], multiplicand[j] & multiplier[i+2], s[i+1][j], c[i+1][j]);
        end
        
        for (i = 0; i < n-2; i = i + 1)
        begin : left_co
            fall_adder_array I2 (c[i][n-2], multiplicand[n-1] & multiplier[i+1], multiplicand[n-2] & multiplier[i+2], s[i+1][n-2], c[i+1][n-2]);
        end
        
        for (i = 0; i < n-1; i = i + 1)
        begin : final_stage
            if (i == 0)
                fall_adder_array I3 (1'b0, c[n-2][0], s[n-2][1], p[n], carry[i]);
            else if (i < n-2)
                fall_adder_array I4 (carry[i-1], c[n-2][i], s[n-2][i+1], p[n+i], carry[i]);
            else
                fall_adder_array I5 (carry[i-1], c[n-2][i], multiplicand[n-1] & multiplier[n-1], p[n+i], carry[i]);
        end
        for (i = 0; i <= n-2; i = i + 1)
        begin : ASSIGN
            assign p[i+1] = s[i][0];
        end
    endgenerate	
    assign Result = (sign) ? ~p +  1'b1 : p;
endmodule