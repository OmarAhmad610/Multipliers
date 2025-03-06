module Shift_Right_Multiplier #(parameter n = 32) (a, x, clk, rst_n, Result);
    input signed [n-1:0] a, x;
    input clk, rst_n;
    output reg signed [2*n:0] Result;

    reg signed [2*n:0] product;
    reg [$clog2(n):0] Count;
    wire signed [n:0] multiplicand;
    wire [n:0]sum, diff;

    assign multiplicand = {a[n-1], a};
    assign sum = product[2*n:n] + multiplicand;
    assign diff = product[2*n:n] - multiplicand;

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            Result <= 0;
            product <= 0;
            Count <= n+2;
        end
        
        else if (Count == n+2)
        begin
            Result <= 0;
            product <= {{(n+1){1'b0}}, x};
            Count <= n+1;
        end

        else if (Count > 2'd2)
        begin
            if (product [0] == 1'b0)
                product <= {product[2*n], product[2*n:1]};
            else
                product <= {sum[n], sum, product[n-1:1]};
            Count <= Count - 1'b1;
        end
        
        else if (Count > 1'b1)
        begin
            if (product[0] == 1'b0)
                product <= {product[2*n], product[2*n:1]};
            else
                product <= {diff[n], diff, product[n-1:1]};
            Count <= Count - 1'b1;
        end
        
        else
            Result <= product;
    end
endmodule