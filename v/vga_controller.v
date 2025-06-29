module vga_controller (
    input            iRST_n,
    input            iVGA_CLK,
    output reg       oBLANK_n,
    output reg       oHS,
    output reg       oVS,
    output     [3:0] oVGA_B,
    output     [3:0] oVGA_G,
    output     [3:0] oVGA_R
);

  parameter VIDEO_W = 640;
  parameter VIDEO_H = 480;

  reg  [18:0] ADDR;
  wire        VGA_CLK_n;
  wire [ 7:0] index;
  reg  [23:0] bgr_data;
  wire [23:0] bgr_data_raw;
  wire        cBLANK_n;
  wire        cHS;
  wire        cVS;
  wire        rst;

  assign rst = ~iRST_n;

  video_sync_generator LTM (
      .iVGA_CLK(iVGA_CLK),
      .iRST(rst),
      .oBLANK_n(cBLANK_n),
      .oHS(cHS),
      .oVS(cVS)
  );

  ////Addresss generator
  always @(posedge iVGA_CLK, negedge iRST_n) begin
    if (!iRST_n) ADDR <= 19'd0;
    else if (cBLANK_n == 1'b1) ADDR <= ADDR + 1;
    else ADDR <= 19'd0;
  end

  always @(posedge iVGA_CLK) begin
    if (~iRST_n) begin
      bgr_data <= 24'h000000;
    end else begin
      if (0 < ADDR && ADDR <= VIDEO_W / 3) bgr_data <= {8'hff, 8'h00, 8'h00};  // blue
      else if (ADDR > VIDEO_W / 3 && ADDR <= VIDEO_W * 2 / 3)
        bgr_data <= {8'h00, 8'hff, 8'h00};  // green
      else if (ADDR > VIDEO_W * 2 / 3 && ADDR <= VIDEO_W) bgr_data <= {8'h00, 8'h00, 8'hff};  // red
      else bgr_data <= 24'h0000;

    end
  end

  assign oVGA_B = bgr_data[23:20];
  assign oVGA_G = bgr_data[15:12];
  assign oVGA_R = bgr_data[7:4];

  //////Delay the iHD, iVD,iDEN for one clock cycle;
  reg mHS, mVS, mBLANK_n;
  always @(posedge iVGA_CLK) begin
    mHS <= cHS;
    mVS <= cVS;
    mBLANK_n <= cBLANK_n;
    oHS <= mHS;
    oVS <= mVS;
    oBLANK_n <= mBLANK_n;
  end


  ////for signaltap ii/////////////
  reg [18:0] H_Cont  /*synthesis noprune*/;
  always @(posedge iVGA_CLK, negedge iRST_n) begin
    if (!iRST_n) H_Cont <= 19'd0;
    else if (mHS == 1'b1) H_Cont <= H_Cont + 1;
    else H_Cont <= 19'd0;
  end
endmodule
