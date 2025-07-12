// VGA 640 x 480 @ 60Hz

module vga (
    input         iRST,
    input         iCLK,
    input  [15:0] iDATA,
    output [12:0] oADDR,
    output        oHS,
    output        oVS,
    output [ 3:0] oVGA_B,
    output [ 3:0] oVGA_G,
    output [ 3:0] oVGA_R
);

  parameter h_pol = 1'b0;
  parameter h_fp = 16;
  parameter h_sync = 96;
  parameter h_bp = 48;
  parameter h_video = 640;
  parameter h_lb = h_fp + h_sync + h_bp;
  parameter h_rb = h_fp + h_sync + h_bp + h_video;

  parameter v_pol = 1'b0;
  parameter v_fp = 10;
  parameter v_sync = 2;
  parameter v_bp = 33;
  parameter v_video = 480;
  parameter v_tb = v_fp + v_sync + v_bp;
  parameter v_bb = v_fp + v_sync + v_bp + v_video;

  reg [9:0] r_h;
  wire h_last = (r_h == h_rb - 1);
  always @(posedge iCLK)
    if (iRST | h_last) r_h <= 0;
    else r_h <= r_h + 1;

  reg [9:0] r_v;
  wire v_last = (r_v == v_bb - 1);
  always @(posedge iCLK)
    if (iRST) r_v <= 0;
    else if (h_last && v_last) r_v <= 0;
    else if (h_last) r_v <= r_v + 1;

  reg r_hs;
  always @(posedge iCLK)
    if (iRST) r_hs <= ~h_pol;
    else if (r_h == h_fp - 1) r_hs <= h_pol;
    else if (r_h == h_fp + h_sync - 1) r_hs <= ~h_pol;

  reg r_vs;
  always @(posedge iCLK)
    if (iRST) r_vs <= ~v_pol;
    else if (h_last && (r_v == v_fp - 1)) r_vs <= v_pol;
    else if (h_last && (r_v == v_fp + v_sync - 1)) r_vs <= ~v_pol;

  wire inside_frame = (r_v >= v_tb) && (r_v < v_bb) && (r_h >= h_lb - 1) && (r_h < h_rb - 1);
  wire [10:0] frame_row = (r_v - v_tb - 112);
  wire [10:0] frame_col = (r_h - h_lb - 64 + 3);
  wire inside_hack_screen = (r_v >= v_tb + 111) && (r_v < v_tb + 367) && (r_h >= h_lb + 63) && (r_h < h_lb + 575);
  wire next_addr = (frame_row < 256) && (frame_col < 512) && (frame_col[3:0] == 4'h0);

  reg data_read;
  always @(posedge iCLK) data_read <= next_addr;

  reg [12:0] r_addr;
  always @(posedge iCLK)
    if (iRST) r_addr <= 0;
    else if (next_addr) r_addr <= {frame_row[7:0], frame_col[8:4]};

  reg [15:0] r_data;
  always @(posedge iCLK)
    if (iRST) r_data <= 0;
    else if (data_read) r_data <= iDATA;
    else r_data <= {1'b0, r_data[15:1]};

  assign oADDR = r_addr;

  reg [11:0] r_rgb;
  always @(posedge iCLK)
    if (iRST) r_rgb <= 12'h000;
    else
      r_rgb <= ~inside_frame ? 12'h000 : ~inside_hack_screen ?  12'h888 : r_data[0] ? 12'h000 : 12'hFFF;

  assign oVGA_R = r_rgb[11:8];
  assign oVGA_G = r_rgb[7:4];
  assign oVGA_B = r_rgb[3:0];
  assign oHS = r_hs;
  assign oVS = r_vs;

endmodule
