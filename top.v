module top (

    //////////// CLOCK 1: 3.3-V LVTTL //////////
    input MAX10_CLK1_50,

    //////////// SEG7: 3.3-V LVTTL //////////
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX3,
    output [7:0] HEX4,
    output [7:0] HEX5,

    //////////// KEY: 3.3 V SCHMITT TRIGGER //////////
    input [1:0] KEY,

    //////////// LED: 3.3-V LVTTL //////////
    output [9:0] LEDR,

    //////////// SW: 3.3-V LVTTL //////////
    input [9:0] SW,

    //////////// VGA: 3.3-V LVTTL //////////
    output [3:0] VGA_B,
    output [3:0] VGA_G,
    output       VGA_HS,
    output [3:0] VGA_R,
    output       VGA_VS,

    //////////// GPIO: 3.3-V LVTTL //////////
    inout [35:0] GPIO
);

  wire        clk_50;
  wire [23:0] seg_dig;
  wire        VGA_CTRL_CLK;
  wire [15:0] VGA_DATA;
  wire [12:0] VGA_ADDR;
  wire        clk_25;
  wire        clk_ps2;
  wire [23:0] ps2_data;
  wire [15:0] kbd;
  wire        locked;

  assign clk_50 = MAX10_CLK1_50;

  reg  [3:0] rst_cnt = 4'h0;
  wire       rst = ~rst_cnt[3];
  always @(negedge clk_25)
    if (~KEY[0] | ~locked) rst_cnt <= 4'h0;
    else if (rst) rst_cnt <= rst_cnt + 1;

  pll u0 (
      .inclk0(clk_50),
      .locked(locked),
      .c0(clk_25)
  );

  seg6 u1 (
      .iDIG (seg_dig),
      .oSEG0(HEX0),
      .oSEG1(HEX1),
      .oSEG2(HEX2),
      .oSEG3(HEX3),
      .oSEG4(HEX4),
      .oSEG5(HEX5)
  );

  vga u2 (
      .iRST(rst),
      .iCLK(clk_25),
      .iDATA(VGA_DATA),
      .oADDR(VGA_ADDR),
      .oHS(VGA_HS),
      .oVS(VGA_VS),
      .oVGA_B(VGA_B),
      .oVGA_G(VGA_G),
      .oVGA_R(VGA_R)
  );

  ps2 u3 (
      .iCLK(clk_25),
      .iRST(rst),
      .iDATA(GPIO[8]),
      .iPS2CLK(GPIO[9]),
      .oDATA(ps2_data)
  );

  kbd u4 (
      .iCLK (clk_25),
      .iRST (rst),
      .iDATA(ps2_data),
      .oDATA(kbd)
  );

  hack u5 (
      .iRST(rst),
      .iCLK(clk_25),
      .iBUT_n(KEY[1]),
      .iSW(SW),
      .iKBD(kbd),
      .iSCR_ADDR(VGA_ADDR),
      .oLED(LEDR),
      .oSEG(seg_dig),
      .oSCR(VGA_DATA)
  );

endmodule
