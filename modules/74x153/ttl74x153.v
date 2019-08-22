module ttl74x153 (
    a,  // a on datasheet
    b,  // b on datasheet
    enable1,  // g on datasheet, active low
    enable2,  // g on datasheet, active low
    c10,
    c11,
    c12,
    c13,
    c20,
    c21,
    c22,
    c23,
    y1,
    y2 );

// Inputs
    input a;  // a on datasheet
    input b;  // b on datasheet
    input enable1;  // g on datasheet, active low
    input enable2;  // g on datasheet, active low
    input c10;
    input c11;
    input c12;
    input c13;
    input c20;
    input c21;
    input c22;
    input c23;
// Outputs
    output y1;
    output y2;

    wire [3:0] c [1:2];
    wire [1:0] select;

    assign c[1] =
        {c13, c12, c11, c10};
    assign c[2] =
        {c23, c22, c21, c20};
    assign select = {b, a};

    assign y1 = ~enable1 & c[1][select];
    assign y2 = ~enable2 & c[2][select];

endmodule
