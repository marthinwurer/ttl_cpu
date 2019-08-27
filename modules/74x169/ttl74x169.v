module ttl74x169(
    input clock,
    input load,  // active low
    input ud,  // count direction. Up on 1, down on 0
    input ent,  // carry in
    input enp,  // count enable
    input [3:0] d,
    output rco,  // carry out, active low
    output reg [3:0] q);

    reg enabled;

    assign enabled = ent == 0 && enp == 0;

    always @ (posedge clock) begin
        if (load == 0) begin
            q <= d;
        end else if (ud == 1 && enabled) begin
            q <= q + 1;
        end else if (ud == 0 && enabled) begin
            q <= q - 1;
        end else begin
            q <= q;
        end
    end

    assign rco = !((ud == 1 && q == 'b1111) || (ud == 0 && q == 'b0000));

endmodule
