// 256 x 8 single-port synchronous RAM
module spram256x8 (
    input  wire        clk,
    input  wire        ce,      // clock enable (optional but handy)
    input  wire        we,      // write enable
    input  wire [7:0]  addr,    // 0..255
    input  wire [7:0]  din,
    output reg  [7:0]  dout
);
    // Hint the synthesizer (optional; vendor-specific)
    // Xilinx:   (* ram_style = "block" *)
    // Lattice:  (* ram_style = "block" *)
    // Intel:    (* ramstyle  = "M9K"   *)
    (*ram_style = "block" *)
    reg [7:0] mem [0:255];

    always @(posedge clk) begin
        if (ce) begin
            if (we) mem[addr] <= din;
            // "read-first" behavior (old data shows on same-cycle read)
            // For "write-first", do: dout <= we ? din : mem[addr];
            dout <= mem[addr];
        end
    end

  initial $readmemh("ram_init.hex", mem);

endmodule
