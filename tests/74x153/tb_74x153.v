

module tb_74x153 ();

// declare all our wires
    wire
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
    y2;

    // declare our test data
    parameter inbetween = 50;
    parameter num_tests = 32;
    bit [13:0] test_info[0:1] =
        '{14'b00000000000000,
        14'b00000000000000};
    reg[31:0] test;

    // module under test
    ttl74x153 to_test (
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
        y2);

    initial begin
        for (test = 0; test < num_tests; test++) begin
            // assign
            {a, b, enable1, enable2, c10, c11, c12, c13, c20, c21, c22, c23} <= test_info[13:2];
            // wait
            #inbetween;
            // assert
//            assert ({y1, y2} == test_info[1:0]);
        end
    end

endmodule