module test;

    reg clk = 0;
    reg ce = 1'b0;
    reg we = 1'b0;
    reg [7:0] addr = 0;
    reg [7:0] din = 0;
    wire [7:0] dout;

    reg [7:0] addr_q;

//    output led [7:0];

    spram256x8 uut(.clk(clk), .ce(ce), .we(we), .addr(addr), .din(din), .dout(dout));

    always #1 clk = ~clk;  // toggle clock every 5 time units

    always @(posedge clk) begin
        addr_q <= addr;                 // previous address
        addr <= addr + 1;
    end

    always @(posedge clk) begin
        $strobe("t=%0t addr=%02h dout=%02h", $time, addr_q, dout);
    end

    always @(posedge clk) begin
        if (dout[0] == 1'b1) $display("odd");
    end

    initial begin
        ce = 1;
        we = 0;
        din = 0;
        #100;
        $finish;
  end

  initial
    repeat (20) @(posedge clk);

//     $monitor("time unit %t ce=%h we=%h addr=%h din=%h dout=%h", $time, ce, we, addr, din, dout);
endmodule
