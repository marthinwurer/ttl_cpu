

module tb_74x377 ();

// declare all our wires
    reg
    clock,
    enable;  // active low

    reg [7:0] d, q;

    // module under test
    ttl74x377 to_test (
    clock,
    enable,  // active low
    d,
    q);

    // declare our test data
    parameter inbetween = 5;
    parameter num_tests = 4;
    reg[31:0] successes;
    reg [16:0] test_info[num_tests];
    reg[31:0] test;
    reg[31:0] testval;
    reg[31:0] testdesired;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0,to_test);
        //                   d       q
        //                  e7654321076543210 // A on the chip is low
        test_info[0] <= 17'b01000000010000000;
        test_info[1] <= 17'b1xxxxxxxx10000000;
        test_info[2] <= 17'b01111000011110000;
        test_info[3] <= 17'b10000000011110000;

        successes <= 0;

        clock <= 1;
        #inbetween;
        for (test = 0; test < num_tests; test = test + 1) begin
            clock <= 0;
            // assign
            enable <= test_info[test][16];
            d <= test_info[test][15:8];

            // wait
            #inbetween;
            clock <= 1;
            #inbetween;

            // do our assert
            testval <= q;
            testdesired <= test_info[test][7:0];
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