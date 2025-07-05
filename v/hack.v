module hack (
    input         iRST,
    input         iCLK,
    input         iBUT_n,
    input  [ 9:0] iSW,
    input  [15:0] iKBD,
    input  [12:0] iSCR_ADDR,
    output [ 9:0] oLED,
    output [23:0] oSEG,
    output [15:0] oSCR
);

  wire        clk;
  wire        rst;
  wire        writeM;
  wire [15:0] instruction;
  wire [15:0] addressM;
  wire [15:0] outM;
  wire [15:0] pc;
  wire [15:0] inM;
  wire        loadRAM;
  wire        loadScreen;
  wire        loadIO2;
  wire        loadIO3;
  wire        loadIO4;
  wire [15:0] outRAM;
  wire [15:0] outScreen;
  wire [15:0] outKeyboard;
  wire [15:0] outIO0;
  wire [15:0] outIO1;
  wire [15:0] outIO2;
  wire [15:0] outIO3;
  wire [15:0] outIO4;

  assign oLED        = outIO2[9:0];
  assign oSEG[15:0]  = outIO3;
  assign oSEG[23:16] = outIO4[7:0];
  assign clk         = iCLK;
  assign rst         = iRST;

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
      .loadScreen(loadScreen),
      .inScreen(outScreen),
      .inKeyboard(outKeyboard),
      .inIO0(outIO0),
      .inIO1(outIO1),
      .loadIO2(loadIO2),
      .inIO2(outIO2),
      .loadIO3(loadIO3),
      .inIO3(outIO3),
      .loadIO4(loadIO4),
      .inIO4(outIO4)
  );

  ram RAM (
      .address(addressM[13:0]),
      .clock(clk),
      .data(outM),
      .wren(loadRAM),
      .q(outRAM)
  );

  screen_map SCREEN (
      .r_address(iSCR_ADDR),
      .address(addressM[12:0]),
      .clock(clk),
      .data(outM),
      .wren(loadScreen),
      .q(outScreen),
      .qb(oSCR)
  );

  register KEYBOARD (
      .clk (clk),
      .rst (rst),
      .in  (outIO1),
      .load(1'b1),
      .out (outKeyboard)
  );

  register regBUT (
      .clk (clk),
      .rst (rst),
      .in  ({15'b0, ~iBUT_n}),
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
