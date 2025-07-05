module screen_map (
    input             clock,
    input      [12:0] r_address,
    input      [12:0] address,
    input      [15:0] data,
    input             wren,
    output reg [15:0] q,
    output reg [15:0] qb
);
  reg [15:0] MEM[0:8191];

  always @(posedge clock) if (wren) MEM[address] <= data;
  always @(negedge clock) q <= MEM[address];
  always @(negedge clock) qb <= MEM[r_address];

endmodule

