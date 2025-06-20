
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module DE10_LITE_Default (

    //////////// CLOCK //////////
    input ADC_CLK_10,
    input MAX10_CLK1_50,
    input MAX10_CLK2_50,

    //////////// SDRAM //////////
    output [12:0] DRAM_ADDR,
    output [ 1:0] DRAM_BA,
    output        DRAM_CAS_N,
    output        DRAM_CKE,
    output        DRAM_CLK,
    output        DRAM_CS_N,
    inout  [15:0] DRAM_DQ,
    output        DRAM_LDQM,
    output        DRAM_RAS_N,
    output        DRAM_UDQM,
    output        DRAM_WE_N,

    //////////// SEG7 //////////
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX3,
    output [7:0] HEX4,
    output [7:0] HEX5,

    //////////// KEY //////////
    input [1:0] KEY,

    //////////// LED //////////
    output [9:0] LEDR,

    //////////// SW //////////
    input [9:0] SW,

    //////////// VGA //////////
    output [3:0] VGA_B,
    output [3:0] VGA_G,
    output       VGA_HS,
    output [3:0] VGA_R,
    output       VGA_VS,

    //////////// Accelerometer //////////
    output       GSENSOR_CS_N,
    input  [2:1] GSENSOR_INT,
    output       GSENSOR_SCLK,
    inout        GSENSOR_SDI,
    inout        GSENSOR_SDO,

    //////////// Arduino //////////
    inout [15:0] ARDUINO_IO,
    inout        ARDUINO_RESET_N
    //////////// GPIO, GPIO connect to GPIO Default //////////
    //    inout [35:0] GPIO

);

  //=======================================================
  //  REG/WIRE declarations
  //=======================================================

  wire        DLY_RST;
  wire        VGA_CTRL_CLK;

  wire [ 9:0] mVGA_R;
  wire [ 9:0] mVGA_G;
  wire [ 9:0] mVGA_B;
  wire [19:0] mVGA_ADDR;
  wire        VGA_CLK;

  // reg  [31:0] Cont;
  wire [23:0] mSEG7_DIG;
  wire        spi_clk;
  wire        spi_clk_out;
  wire        resrt_n;
  wire [15:0] data_x;

  wire [ 9:0] led_gensor;

  wire        clk_0;
  wire [14:0] ram_addr;
  wire [15:0] ram_rdata;
  wire [15:0] ram_wdata;
  wire        ram_wren;
  wire [14:0] rom_addr;
  wire [15:0] rom_data;

  //=======================================================
  //  Structural coding
  //=======================================================

  assign DRAM_DQ    = 16'hzzzz;
  assign ARDUINO_IO = 16'hzzzz;
  assign GPIO       = 36'hzzzzzzzz;

  assign VGA_CLK    = VGA_CTRL_CLK;
  assign resrt_n    = KEY[0];

  // always @(posedge MAX10_CLK2_50) begin
  //   Cont <= Cont + 1;
  // end
  // assign LEDR = resrt_n ? (SW[0] ? led_gensor : {Cont[25:24],Cont[25:24],Cont[25:24],Cont[25:24],Cont[25:24]}) : 10'h3ff ;
  // assign mSEG7_DIG = resrt_n ? {Cont[27:24],Cont[27:24],Cont[27:24],Cont[27:24],Cont[27:24],Cont[27:24]} : {6{4'b1000}};

  Reset_Delay r0 (
      .iCLK  (MAX10_CLK1_50),
      .oRESET(DLY_RST)
  );

  SEG7_LUT_6 u0 (
      .oSEG0(HEX0),
      .oSEG1(HEX1),
      .oSEG2(HEX2),
      .oSEG3(HEX3),
      .oSEG4(HEX4),
      .oSEG5(HEX5),
      .iDIG (mSEG7_DIG)
  );

  VGA_Audio_PLL p1 (
      .areset(~DLY_RST),
      .inclk0(MAX10_CLK2_50),
      .c0(VGA_CTRL_CLK),
      .c1(spi_clk),  // 2MHz
      .c2(spi_clk_out),  // 2MHz phase shift
  );

  VGA_Controller u1 (
      // Host Side
      .iCursor_RGB_EN(4'h7),
      .oAddress(mVGA_ADDR),
      .iRed(mVGA_R[9:6]),
      .iGreen(mVGA_G[9:6]),
      .iBlue(mVGA_B[9:6]),
      // VGA Side
      .oVGA_R(VGA_R),
      .oVGA_G(VGA_G),
      .oVGA_B(VGA_B),
      .oVGA_H_SYNC(VGA_HS),
      .oVGA_V_SYNC(VGA_VS),
      .oVGA_SYNC(VGA_SYNC),
      .oVGA_BLANK(),
      // Control Signal
      .iCLK(VGA_CLK),  //VGA_CTRL_CLK),
      .iRST_N(DLY_RST)
  );

  VGA_OSD_RAM u2 (
      // Read Out Side
      .oRed(mVGA_R),
      .oGreen(mVGA_G),
      .oBlue(mVGA_B),
      .iVGA_ADDR(mVGA_ADDR),
      .iVGA_CLK(VGA_CLK),  // VGA_CTRL_CLK ),//VGA_CLK),
      // CLUT
      .iON_R(1023),
      .iON_G(1023),
      .iON_B(1023),
      .iOFF_R(0),
      .iOFF_G(0),
      .iOFF_B(512),
      // Control Signals
      .iRST_N(DLY_RST)
  );

  // Initial Setting and Data Read Back
  spi_ee_config u_spi_ee_config (
      .iRSTN(DLY_RST),
      .iSPI_CLK(spi_clk),
      .iSPI_CLK_OUT(spi_clk_out),
      .iG_INT2(GSENSOR_INT[1]),
      .oDATA_L(data_x[7:0]),
      .oDATA_H(data_x[15:8]),
      .SPI_SDIO(GSENSOR_SDI),
      .oSPI_CSN(GSENSOR_CS_N),
      .oSPI_CLK(GSENSOR_SCLK)
  );

  // LED
  led_driver u_led_driver (
      .iRSTN(DLY_RST),
      .iCLK(MAX10_CLK1_50),
      .iDIG(data_x[9:0]),
      .iG_INT2(GSENSOR_INT[1]),
      .oLED(led_gensor)
  );

  pll u3 (
      .inclk0(MAX10_CLK1_50),
      .c0(clk_0)
  );

  HACK u4 (
      .CLK(clk_0),
      .RST(resrt_n),
      .BUT(KEY[1]),
      .SW(SW[9:0]),
      .SEG(mSEG7_DIG[15:0]),
      .instruction(rom_data),
      .inRAM(ram_rdata),
      .LED(LEDR[9:0]),
      .RAM_ADDR(ram_addr),
      .pc(rom_addr),
      .RAM_WREN(ram_wren)
  );

  ram u5 (
      .address(ram_addr),
      .clock(clk_0),
      .data(ram_wdata),
      .wren(ram_wren),
      .q(ram_rdata)
  );

  rom u6 (
      .address(rom_addr),
      .clock(clk_0),
      .q(rom_data)
  );

endmodule
