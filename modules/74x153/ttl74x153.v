module ttl74x153 (
    input a,  // a on datasheet
    input b,  // b on datasheet
    input enable1,  // g on datasheet, active low
    input enable2,  // g on datasheet, active low
    input [3:0] c1,
    input [3:0] c2,
    output y1,
    output y2 );

    wire [3:0] c [1:2];
    wire [1:0] select;

    assign c[1] = c1;
    assign c[2] = c2;
    assign select = {b, a};

    assign y1 = ~enable1 & c[1][select];
    assign y2 = ~enable2 & c[2][select];

endmodule
