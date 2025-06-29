module vga_sync (
    input      iRST,
    input      iCLK,
    output reg oDISPLAY_n,
    output reg oHS,
    output reg oVS
);

  parameter H_sync = 96;
  parameter H_line = 800;
  parameter H_back = 144;
  parameter H_front = 16;
  parameter V_sync = 2;
  parameter V_line = 525;
  parameter V_back = 34;
  parameter V_front = 11;

  reg  [9:0] H_cnt;
  reg  [9:0] V_cnt;
  wire       wHS;
  wire       wVS;
  wire       H_display;
  wire       V_display;

  always @(negedge iCLK, posedge iRST) begin
    if (iRST) begin
      H_cnt <= 10'h0;
      V_cnt <= 10'h0;
    end else begin
      if (H_cnt == H_line - 1) begin
        H_cnt <= 10'h0;
        if (V_cnt == V_line - 1) V_cnt <= 10'h0;
        else V_cnt <= V_cnt + 1;
      end else H_cnt <= H_cnt + 1;
    end
  end

  assign wHS = (H_cnt < H_sync) ? 1'b0 : 1'b1;
  assign wVS = (V_cnt < V_sync) ? 1'b0 : 1'b1;

  assign H_display = (H_cnt < (H_line - H_front) && H_cnt >= H_back) ? 1'b1 : 1'b0;
  assign V_display = (V_cnt < (V_line - V_front) && V_cnt >= V_back) ? 1'b1 : 1'b0;

  assign display_n = H_display && V_display;

  always @(negedge iCLK) begin
    oHS <= wHS;
    oVS <= wVS;
    oDISPLAY_n <= display_n;
  end

endmodule
