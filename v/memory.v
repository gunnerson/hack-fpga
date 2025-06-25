module memory (
    input [15:0] address,
    input        load,
    input [15:0] inRAM,
    input [15:0] inIO0,
    input [15:0] inIO1,
    input [15:0] inIO2,
    input [15:0] inIO3,
    input [15:0] inIO4,
    input [15:0] inIO5,
    input [15:0] inIO6,
    input [15:0] inIO7,

    output [15:0] out,
    output        loadRAM,
    output        loadIO0,
    output        loadIO1,
    output        loadIO2,
    output        loadIO3,
    output        loadIO4,
    output        loadIO5,
    output        loadIO6,
    output        loadIO7
);

  assign out = (
      (address == 16384) ? inIO0 :
      (address == 16385) ? inIO1 :
      (address == 16386) ? inIO2 :
      (address == 16387) ? inIO3 :
      (address == 16388) ? inIO4 :
      (address == 16389) ? inIO5 :
      (address == 16390) ? inIO6 :
      (address == 16391) ? inIO7 :
      inRAM);

  assign loadRAM = (address <= 16383) ? load : 1'b0;  // RAM
  assign loadIO0 = (address == 16384) ? load : 1'b0;  // BUT
  assign loadIO1 = (address == 16385) ? load : 1'b0;  // SW
  assign loadIO2 = (address == 16386) ? load : 1'b0;  // LED
  assign loadIO3 = (address == 16387) ? load : 1'b0;  // SEG
  assign loadIO4 = (address == 16388) ? load : 1'b0;  // DEBUG0
  assign loadIO5 = (address == 16389) ? load : 1'b0;  // DEBUG1
  assign loadIO6 = (address == 16390) ? load : 1'b0;  // DEBUG2
  assign loadIO7 = (address == 16391) ? load : 1'b0;  // DEBUG3

endmodule
