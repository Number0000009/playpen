module test;

    reg reset = 0;
    reg clk = 0;
    wire [3:0] count;

    counter uut(.clk(clk), .reset(reset), .count(count));

    always #5 clk = ~clk;  // toggle clock every 5 time units

    initial begin
        reset = 1;  #10
        reset = 0;
        #200;
        $finish;
  end

  initial
     $monitor("time unit %t  count=%h (%0d) reset=%h", $time, count, count, reset);
endmodule
