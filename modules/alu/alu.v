module alu(
    input enable_a,  // active low
    input carry_in,
    input [7:0] a, b,
    input [3:0] lut,
    output [7:0] q,
    output [3:0] status);

    wire [7:0] adder_a, adder_b;  // the a and b values that have been processed
    wire internal_carry;  // internal carry between adders
    wire carry_out;  // carry out of the adder

    ttl74x283 lo (carry_in, adder_a[3:0], adder_b[3:0], internal_carry, q[3:0]);
    ttl74x283 hi (internal_carry, adder_a[7:4], adder_b[7:4], carry_out, q[7:4]);

    // the muxes for the digial logic
    genvar gi;
    generate
    for (gi = 0; gi < 8; gi = gi + 1) begin: muxes
        ttl74x153 mux(); // TODO
    end
    endgenerate





endmodule
