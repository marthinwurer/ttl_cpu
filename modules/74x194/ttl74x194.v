module ttl74x194(
    input clock,
    input mr,  // active low
    input [1:0] select,
    input dsr,
    input dsl,
    input [3:0] d,
    output [3:0] q);


    always @ (posedge clock or mr) begin
        if (mr == 0) begin
            q <= 4'b0000;
        end else begin
            if (select == 'b00) begin
                q <= q;
            end else if (select == 'b00) begin
                q <= q;
            end else if (select == 'b00) begin
                q <= q;
            end else begin
                q <= q;
            end
        end
    end


endmodule
