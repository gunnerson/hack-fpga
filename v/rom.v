module rom (
    input clock,
    input [15:0] address,
    output reg [15:0] q
);

  reg [15:0] MEM[0:65535];
  initial $readmemb("os/os.hack", MEM);
  always @(negedge clock) q <= MEM[address];

endmodule

