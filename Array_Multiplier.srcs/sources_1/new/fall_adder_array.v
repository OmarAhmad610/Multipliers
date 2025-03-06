module fall_adder_array (x, y, z, S, C);
    input x, y, z;
    output S, C;
    assign {C,S} = x + y + z;
endmodule 