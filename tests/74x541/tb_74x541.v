

module tb_74x541 ();

// declare all our wires
    reg enable1, enable2;
    reg [7:0] d, q;

    reg
    clock;

    // module under test
    ttl74x541 to_test (
    enable1,
    enable2,
    d, q);

    // declare our test data
    parameter inbetween = 5;
    parameter num_tests = 5;
    reg[31:0] successes;
    reg [17:0] test_info[num_tests];
    reg[31:0] test;
    reg[31:0] testval;
    reg[31:0] testdesired;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0,to_test);
        //                  eed  b   cs
        //                  127654321076543210// A on the chip is low
        test_info[0] <= 18'b1100100010zzzzzzzz;
        test_info[1] <= 18'b0111100001zzzzzzzz;
        test_info[2] <= 18'b1011100011zzzzzzzz;
        test_info[3] <= 18'b000011111100111111;
        test_info[4] <= 18'b000010000x0010000x;

        successes <= 0;

        clock <= 1;
        #inbetween;
        for (test = 0; test < num_tests; test = test + 1) begin
            clock <= 0;
            // assign
            {enable1, enable2, d} <= test_info[test][17:8];

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