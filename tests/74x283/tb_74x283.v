

module tb_74x283 ();

// declare all our wires
    reg cin, c4;
    reg [3:0] a, b, s;

    reg
    clock;

    // module under test
    ttl74x283 to_test (
    cin,
    a, b,
    c4,
    s);

    // declare our test data
    parameter inbetween = 5;
    parameter num_tests = 5;
    reg[31:0] successes;
    reg [14:0] test_info[num_tests];
    reg[31:0] test;
    reg[31:0] testval;
    reg[31:0] testdesired;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0,to_test);
        //                  ca   b   cs
        //                  i3210321043210// A on the chip is low
        test_info[0] <= 14'b00001000100010;
        test_info[1] <= 14'b11111000010000;
        test_info[2] <= 14'b01111000110000;
        test_info[3] <= 14'b10001111110001;
        test_info[4] <= 14'b10001000000010;

        successes <= 0;

        clock <= 1;
        #inbetween;
        for (test = 0; test < num_tests; test = test + 1) begin
            clock <= 0;
            // assign
            {cin, a, b} <= test_info[test][14:5];

            // wait
            #inbetween;
            clock <= 1;
            #inbetween;

            // do our assert
            testval <= {c4, s};
            testdesired <= test_info[test][4:0];
            if (testval !== testdesired) begin
                $display("Assertation failed at test %d: %b does not match %b", test, testval, testdesired);
            end else begin
                successes <= successes + 1;
            end
        end
        #inbetween;

        if (successes == num_tests) begin
            $display("Test was successful");
        end else begin
            $display("Test failed");
        end

        $finish;
    end

endmodule