module register (
    input clk,
    input [15:0] in,
    input load,
    output reg [15:0] out
);

  always @(posedge clk) out <= (load ? in : out);

endmodule
