module ttl74x377(
    input clock,
    input enable,  // active low
    input [7:0] d,
    output reg [7:0] q);

    always @ (posedge clock) begin
        if (enable == 0) begin
            q <= d;
        end else begin
            q <= q;
        end
    end


endmodule
