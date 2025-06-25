module ram (
    input clock,
    input [13:0] address,
    input [15:0] data,
    input wren,
    output reg [15:0] q
);
  reg [15:0] MEM[0:16383];

  // integer i;
  // initial begin
  //   for (i = 0; i < 16384; i = i + 1) MEM[i] = 0;
  // end

  always @(posedge clock) if (wren) MEM[address] <= data;
  always @(negedge clock) q <= MEM[address];

endmodule

