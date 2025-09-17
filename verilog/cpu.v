module cpu (
    input wire        clk,
    input wire        wr,
    input wire [15:0] addr,
    inout wire  [7:0] data
);

    reg [7:0] data_out;

    assign data = data_out;

    always @(posedge clk) begin
        if (wr) begin
            data_out <= 8'h42;
        end else begin
            data_out <= 8'bx;
        end
    end

endmodule
