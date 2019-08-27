

module tb_74x169 ();

// declare all our wires
    reg
    clock,
    load,  // active low
    ud,  // count direction. Up on 1, down on 0
    ent,  // carry in
    enp,  // count enable
    rco;  // carry out, active low

    reg [3:0] d, q;

    // module under test
    ttl74x169 to_test (
    clock,
    load,  // active low
    ud,  // count direction. Up on 1, down on 0
    ent,  // carry in
    enp,  // count enable
    d,
    rco,  // carry out, active low
    q);

    // declare our test data
    parameter inbetween = 5;
    parameter num_tests = 15;
    reg[31:0] successes;
    reg [12:0] test_info[num_tests];
    reg[31:0] test;
    reg[31:0] testval;
    reg[31:0] testdesired;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0,to_test);
        //                   ueed    q
        //                  ldtp3210c3210 // A on the chip is low
        test_info[0] <= 13'b0100110111101;
        test_info[1] <= 13'b1111110111101;
        test_info[2] <= 13'b1100xxxx11110;
        test_info[3] <= 13'b1100xxxx01111;
        test_info[4] <= 13'b1100xxxx10000;
        test_info[5] <= 13'b1100xxxx10001;
        test_info[6] <= 13'b1100xxxx10010;
        test_info[7] <= 13'b1111xxxx10010;
        test_info[8] <= 13'b1011xxxx10010;
        test_info[9] <= 13'b1011xxxx10010;
        test_info[10]<= 13'b1000xxxx10001;
        test_info[11]<= 13'b1000xxxx00000;
        test_info[12]<= 13'b1000xxxx11111;
        test_info[13]<= 13'b1000xxxx11110;
        test_info[14]<= 13'b1000xxxx11101;

        successes <= 0;

        clock <= 1;
        #inbetween;
        for (test = 0; test < num_tests; test = test + 1) begin
            clock <= 0;
            // assign
            {load, ud, ent, enp} <= test_info[test][12:9];
            d <= test_info[test][8:5];
//            {a, b, enable1, enable2, c10, c11, c12, c13, c20, c21, c22, c23} <= test_info[test][13:2];
            // wait
            #inbetween;
            clock <= 1;
            #inbetween;

            // do our assert
            testval <= {rco, q};
            testdesired <= test_info[test][4:0];
            if (testval != testdesired) begin
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