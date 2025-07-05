module ps2 (
    input             iCLK,
    input             iPS2CLK,
    input             iRST,
    input             iDATA,
    output reg [23:0] oDATA
);
  reg  [10:0] bits;
  reg  [ 1:0] ps2_clock;
  wire        stop;
  wire        edg;

  // buffer last two bits
  always @(posedge iCLK) ps2_clock <= {ps2_clock[0], iPS2CLK};

  // detect posedge from low to high
  assign edg  = (ps2_clock == 2'b01);

  // stop after last bit (number 10)
  assign stop = (bits[0] == 1'b0);

  // buffer last 11 bits
  always @(posedge iCLK)
    if (iRST | stop) bits <= 11'b11111111111;
    else if (edg) bits <= {iDATA, bits[10:1]};

  // store last three bytes
  always @(posedge iCLK)
    if (iRST) oDATA <= 0;
    else if (stop) oDATA <= {oDATA[15:0], bits[8:1]};

endmodule
