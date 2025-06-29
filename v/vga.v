module vga (
    input            iRST,
    input            iCLK,
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
  wire        wDISPLAY_n;
  wire        wHS;
  wire        wVS;
  wire        rst;

  assign rst = iRST;

  vga_sync VGA_SYNC (
      .iCLK(iCLK),
      .iRST(rst),
      .oDISPLAY_n(wDISPLAY_n),
      .oHS(wHS),
      .oVS(wVS)
  );

  ////Addresss generator
  always @(posedge iCLK, posedge rst) begin
    if (rst) ADDR <= 19'd0;
    else if (wDISPLAY_n == 1'b1) ADDR <= ADDR + 1;
    else ADDR <= 19'd0;
  end

  always @(posedge iCLK) begin
    if (rst) begin
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

  // Delay VS/HS one clock cycle;
  reg rHS;
  reg rVS;
  always @(posedge iCLK) begin
    rHS <= wHS;
    rVS <= wVS;
    oHS <= rHS;
    oVS <= rVS;
  end

endmodule
