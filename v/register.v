module register (
    input             clk,
    input             rst,
    input      [15:0] in,
    input             load,
    output reg [15:0] out
);

  always @(posedge clk) out <= rst ? 16'h0000 : load ? in : out;

endmodule
