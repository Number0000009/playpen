module test;

    reg clk = 1'b0;
    reg wr = 1'b0;
    reg [15:0] addr = 16'h0;
    wire [7:0] data;

    reg [15:0] addr_q;

    cpu uut(.clk(clk), .wr(wr), .addr(addr), .data(data));

    always #1 clk = ~clk;

    always @(posedge clk) begin
        addr_q <= addr;                 // previous address
        addr <= addr + 1;
    end

    always @(posedge clk) begin
//        $strobe("t=%0t addr=%02h data=%02h", $time, addr_q, data);
        $display("t=%0t addr=%02h data=%02h", $time, addr_q, data);
    end

    initial begin
        wr = 1'b1;
        #100;
        $finish;
    end

    initial
        repeat (20) @(posedge clk);

//     $monitor("time unit %t ce=%h we=%h addr=%h din=%h dout=%h", $time, ce, we, addr, din, dout);
endmodule
