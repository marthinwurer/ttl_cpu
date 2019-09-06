module ttl74x541(
    input enable1, enable2,  // active low
    input [7:0] d,
    output [7:0] q);

    wire enabled;

    assign enabled = (!enable1) && (!enable2);

    assign q = enabled ? d : 8'bzzzzzzzz;

endmodule
