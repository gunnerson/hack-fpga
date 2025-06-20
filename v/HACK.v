module HACK (
    input        CLK,
    input        RST,
    input        BUT,
    input [ 9:0] SW,
    input [15:0] instruction,
    input [15:0] inRAM,

    output [15:0] LED,
    output [15:0] SEG,
    output [15:0] RAM_ADDR,
    output [15:0] pc,
    output        RAM_WREN
);

  // wires {{{1
  wire        clk = CLK;
  wire        reset = ~RST;
  wire        button = ~BUT;
  wire        writeM;
  wire [15:0] addressM;
  wire [15:0] outM;
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
  wire        loadIO8;
  wire        loadIO9;
  wire        loadIOA;
  wire        loadIOB;
  wire        loadIOC;
  wire        loadIOD;
  wire        loadIOE;
  wire        loadIOF;
  wire [15:0] outIO0;
  wire [15:0] outIO1;
  wire [15:0] outIO2;
  wire [15:0] outIO3;
  wire [15:0] outIO4;
  wire [15:0] outIO5;
  wire [15:0] outIO6;
  wire [15:0] outIO7;
  wire [15:0] outIO8;
  wire [15:0] outIO9;
  wire [15:0] outIOA;
  wire [15:0] outIOB;
  wire [15:0] outIOC;
  wire [15:0] outIOD;
  wire [15:0] outIOE;
  wire [15:0] outIOF;

  assign RAM_ADDR = addressM;
  assign RAM_WREN = loadRAM;
  assign LED = outIO2;
  assign SEG = outIO3;

  // CPU {{{1
  CPU cpu (
      .clk(clk),
      .inM(inM),
      .instruction(instruction),
      .reset(reset),
      .outM(outM),
      .writeM(writeM),
      .addressM(addressM),
      .pc(pc)
  );

  // Memory {{{1
  Memory memory (
      .address(addressM),
      .load(writeM),
      .out(inM),
      .loadRAM(loadRAM),
      .inRAM(inRAM),
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
      .inIO7(outIO7),
      .loadIO8(loadIO8),
      .inIO8(outIO8),
      .loadIO9(loadIO9),
      .inIO9(outIO9),
      .loadIOA(loadIOA),
      .inIOA(outIOA),
      .loadIOB(loadIOB),
      .inIOB(outIOB),
      .loadIOC(loadIOC),
      .inIOC(outIOC),
      .loadIOD(loadIOD),
      .inIOD(outIOD),
      .loadIOE(loadIOE),
      .inIOE(outIOE),
      .loadIOF(loadIOF),
      .inIOF(outIOF)
  );

  // IO {{{1
  Register but (
      .clk (clk),
      .in  (button),
      .load(1'b1),
      .out (outIO0)
  );

  Register sw (
      .clk (clk),
      .in  (SW),
      .load(1'b1),
      .out (outIO1)
  );

  Register ledr (
      .clk (clk),
      .in  (outM),
      .load(loadIO2),
      .out (outIO2)
  );

  Register seg (
      .clk (clk),
      .in  (outM),
      .load(loadIO3),
      .out (outIO3)
  );

  Register io4 (
      .clk (clk),
      .in  (outM),
      .load(loadIO4),
      .out (outIO4)
  );

  Register io5 (
      .clk (clk),
      .in  (outM),
      .load(loadIO5),
      .out (outIO5)
  );

  Register io6 (
      .clk (clk),
      .in  (outM),
      .load(loadIO6),
      .out (outIO6)
  );

  Register io7 (
      .clk (clk),
      .in  (outM),
      .load(loadIO7),
      .out (outIO7)
  );

  Register io8 (
      .clk (clk),
      .in  (outM),
      .load(loadIO8),
      .out (outIO8)
  );

  Register io9 (
      .clk (clk),
      .in  (outM),
      .load(loadIO9),
      .out (outIO9)
  );

  Register ioA (
      .clk (clk),
      .in  (outM),
      .load(loadIOA),
      .out (outIOA)
  );

  Register debug0 (
      .clk (clk),
      .in  (outM),
      .load(loadIOB),
      .out (outIOB)
  );

  Register debug1 (
      .clk (clk),
      .in  (outM),
      .load(loadIOC),
      .out (outIOC)
  );

  Register debug2 (
      .clk (clk),
      .in  (outM),
      .load(loadIOD),
      .out (outIOD)
  );

  Register debug3 (
      .clk (clk),
      .in  (outM),
      .load(loadIOE),
      .out (outIOE)
  );

  Register debug4 (
      .clk (clk),
      .in  (outM),
      .load(loadIOF),
      .out (outIOF)
  );
  // }}}1

endmodule

