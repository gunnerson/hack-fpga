/**
 * 16-bit register:
 * If load[t] == 1 then out[t+1] = in[t]
 * else out does not change
 */

module Register (
    input clk,
    input [15:0] in,
    input load,
    output reg [15:0] out
);

  always @(posedge clk) out <= (load ? in : out);

endmodule
