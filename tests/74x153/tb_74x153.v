

module tb_74x153 ();

// declare all our wires
    reg
    a,  // a on datasheet
    b,  // b on datasheet
    enable1,  // g on datasheet, active low
    enable2,  // g on datasheet, active low
    y1,
    y2;

    reg [3:0] c1, c2;

    // module under test
    ttl74x153 to_test (
        a,  // a on datasheet
        b,  // b on datasheet
        enable1,  // g on datasheet, active low
        enable2,  // g on datasheet, active low
        c1,
        c2,
        y1,
        y2);

    // declare our test data
    parameter inbetween = 50;
    parameter num_tests = 19;
    reg[31:0] successes;
    reg [13:0] test_info[num_tests];
    reg[31:0] test;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0,to_test);
        //                      c1  c2  yy
        //                  abgg0123012312
        test_info[0] <= 14'b00000000000000;
        test_info[1] <= 14'b00001000000010;
        test_info[2] <= 14'b10001000000000;
        test_info[3] <= 14'b10001100000010;
        test_info[4] <= 14'b01001100000000;
        test_info[5] <= 14'b01001110000010;
        test_info[6] <= 14'b11001110000000;
        test_info[7] <= 14'b11001111000010;
        test_info[8] <= 14'b00001111000010;
        test_info[9] <= 14'b00001111100011;
        test_info[10]<= 14'b10001111100010;
        test_info[11]<= 14'b10001111110011;
        test_info[12]<= 14'b01001111110010;
        test_info[13]<= 14'b01001111111011;
        test_info[14]<= 14'b11001111111010;
        test_info[15]<= 14'b11001111111111;
        test_info[16]<= 14'b11111111111100;
        test_info[17]<= 14'b11011111111110;
        test_info[18]<= 14'b11101111111101;

        successes <= 0;
//        #inbetween;
        for (test = 0; test < num_tests; test = test + 1) begin
            #inbetween;
            // assign
            {a, b, enable1, enable2, c1[0], c1[1], c1[2], c1[3], c2[0], c2[1], c2[2], c2[3]} <= test_info[test][13:2];
            // wait
            #inbetween;
            // assert
//            assert ({y1, y2} == test_info[1:0]);
            if ({y1, y2} !== test_info[test][1:0]) begin
                $display("Assertation failed at test %h", test);
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