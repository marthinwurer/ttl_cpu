module ttl74x193(
    input clock,
    input load,  // active low
    input clr,  // active low
    input ent,  // count enables. One for carry in, one for general enable.
    input enp,
    input [3:0] d,
    output rco,  // carry out
    output [3:0] q);


    always @ (posedge clock or negedge clr) begin
        if (clr == 0) begin
            q <= 4'b0000;
        end else begin
            if (if  == 'b00) begin
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
