module hack (
    input         iCLK,
    input  [ 1:0] iBUT,
    input  [ 9:0] iSW,
    output [ 9:0] oLED,
    output [23:0] oSEG
);

  wire        clk;
  wire        reset;
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

  assign reset = ~iBUT[0];
  assign oLED  = outIO2[9:0];
  assign oSEG  = {8'b0, outIO3};

  pll PLL (
      .inclk0(iCLK),
      .c0(clk)
  );

  cpu CPU (
      .clk(clk),
      .inM(inM),
      .instruction(instruction),
      .reset(reset),
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
      .loadIO5(loadIO5),
      .inIO5(outIO5),
      .loadIO6(loadIO6),
      .inIO6(outIO6),
      .loadIO7(loadIO7),
      .inIO7(outIO7)
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
      .in  ({15'b0, ~iBUT[1]}),
      .load(1'b1),
      .out (outIO0)
  );

  register regSW (
      .clk (clk),
      .in  ({6'b0, iSW}),
      .load(1'b1),
      .out (outIO1)
  );

  register regLED (
      .clk (clk),
      .in  (outM),
      .load(loadIO2),
      .out (outIO2)
  );

  register regSEG (
      .clk (clk),
      .in  (outM),
      .load(loadIO3),
      .out (outIO3)
  );

  register debug0 (
      .clk (clk),
      .in  (outM),
      .load(loadIO4),
      .out (outIO4)
  );

  register debug1 (
      .clk (clk),
      .in  (outM),
      .load(loadIO5),
      .out (outIO5)
  );

  register debug2 (
      .clk (clk),
      .in  (outM),
      .load(loadIO6),
      .out (outIO6)
  );

  register debug3 (
      .clk (clk),
      .in  (outM),
      .load(loadIO7),
      .out (outIO7)
  );

endmodule
