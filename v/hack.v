module hack (
    input         iCLK,
    input  [ 1:0] iBUT,
    input  [ 9:0] iSW,
    output [ 9:0] oLED,
    output [23:0] oSEG
);

  wire        clk;
  wire        locked;
  wire        writeM;
  wire [15:0] instruction;
  wire [15:0] addressM;
  wire [15:0] outM;
  wire [15:0] pc;
  wire [15:0] inM;
  wire        loadRAM;
  wire        loadIO0;
  wire        loadIO1;
  wire        loadIO2;
  wire        loadIO3;
  wire        loadIO4;
  wire        loadIO5;
  wire        loadIO6;
  wire        loadIO7;
  wire [15:0] outRAM;
  wire [15:0] outIO0;
  wire [15:0] outIO1;
  wire [15:0] outIO2;
  wire [15:0] outIO3;
  wire [15:0] outIO4;
  wire [15:0] outIO5;
  wire [15:0] outIO6;
  wire [15:0] outIO7;

  assign oLED = outIO2[9:0];
  assign oSEG[15:0] = outIO3;
  assign oSEG[23:16] = outIO4[7:0];

  reg [3:0] reset = 0;
  wire rst = ~reset[3];
  always @(negedge clk)
    if (~iBUT[0] | ~locked) reset <= 0;
    else if (rst) reset <= reset + 1;

  pll PLL (
      .inclk0(iCLK),
      .locked(locked),
      .c0(clk)
  );

  cpu CPU (
      .clk(clk),
      .inM(inM),
      .instruction(instruction),
      .reset(rst),
      .outM(outM),
      .writeM(writeM),
      .addressM(addressM),
      .pc(pc)
  );

  rom ROM (
      .address(pc),
      .clock(clk),
      .q(instruction)
  );

  memory MEM (
      .address(addressM),
      .load(writeM),
      .out(inM),
      .loadRAM(loadRAM),
      .inRAM(outRAM),
      .loadIO0(loadIO0),
      .inIO0(outIO0),
      .loadIO1(loadIO1),
      .inIO1(outIO1),
      .loadIO2(loadIO2),
      .inIO2(outIO2),
      .loadIO3(loadIO3),
      .inIO3(outIO3),
      .loadIO4(loadIO4),
      .inIO4(outIO4),
  );

  ram RAM (
      .address(addressM[13:0]),
      .clock(clk),
      .data(outM),
      .wren(loadRAM),
      .q(outRAM)
  );

  register regBUT (
      .clk (clk),
      .rst (rst),
      .in  ({15'b0, ~iBUT[1]}),
      .load(1'b1),
      .out (outIO0)
  );

  register regSW (
      .clk (clk),
      .rst (rst),
      .in  ({6'b0, iSW}),
      .load(1'b1),
      .out (outIO1)
  );

  register regLED (
      .clk (clk),
      .rst (rst),
      .in  (outM),
      .load(loadIO2),
      .out (outIO2)
  );

  register regSEG (
      .clk (clk),
      .rst (rst),
      .in  (outM),
      .load(loadIO3),
      .out (outIO3)
  );

  register regSTATUS (
      .clk (clk),
      .rst (rst),
      .in  (outM),
      .load(loadIO4),
      .out (outIO4)
  );

endmodule
