module ttl74x283(
    input cin,
    input [3:0] a, b,
    output c4,
    output [3:0] s);

    wire [4:0] sum, with_carry;

    assign sum = a + b;
    assign with_carry = sum + cin;

    assign {c4, s} = with_carry;

endmodule
