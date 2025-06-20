module Memory (
    input [15:0] address,
    input load,
    output [15:0] out,
    output loadRAM,
    output loadIO0,
    output loadIO1,
    output loadIO2,
    output loadIO3,
    output loadIO4,
    output loadIO5,
    output loadIO6,
    output loadIO7,
    output loadIO8,
    output loadIO9,
    output loadIOA,
    output loadIOB,
    output loadIOC,
    output loadIOD,
    output loadIOE,
    output loadIOF,
    input [15:0] inRAM,
    input [15:0] inIO0,
    input [15:0] inIO1,
    input [15:0] inIO2,
    input [15:0] inIO3,
    input [15:0] inIO4,
    input [15:0] inIO5,
    input [15:0] inIO6,
    input [15:0] inIO7,
    input [15:0] inIO8,
    input [15:0] inIO9,
    input [15:0] inIOA,
    input [15:0] inIOB,
    input [15:0] inIOC,
    input [15:0] inIOD,
    input [15:0] inIOE,
    input [15:0] inIOF
);

  assign out = (
      (address==16385) ? inIO0 :
      (address==16386) ? inIO1 :
      (address==16387) ? inIO2 :
      (address==16388) ? inIO3 :
      (address==16389) ? inIO4 :
      (address==16390) ? inIO5 :
      (address==16391) ? inIO6 :
      (address==16392) ? inIO7 :
      (address==16393) ? inIO8 :
      (address==16394) ? inIO9 :
      (address==16395) ? inIOA :
      (address==16396) ? inIOB :
      (address==16397) ? inIOC :
      (address==16398) ? inIOD :
      (address==16399) ? inIOE :
      (address==16400) ? inIOF :
       inRAM);

  assign loadRAM = (address <= 16384) ? load : 0;
  assign loadIO0 = (address == 16385) ? load : 0;
  assign loadIO1 = (address == 16386) ? load : 0;
  assign loadIO2 = (address == 16387) ? load : 0;
  assign loadIO3 = (address == 16388) ? load : 0;
  assign loadIO4 = (address == 16389) ? load : 0;
  assign loadIO5 = (address == 16390) ? load : 0;
  assign loadIO6 = (address == 16391) ? load : 0;
  assign loadIO7 = (address == 16392) ? load : 0;
  assign loadIO8 = (address == 16393) ? load : 0;
  assign loadIO9 = (address == 16394) ? load : 0;
  assign loadIOA = (address == 16395) ? load : 0;
  assign loadIOB = (address == 16396) ? load : 0;
  assign loadIOC = (address == 16397) ? load : 0;
  assign loadIOD = (address == 16398) ? load : 0;
  assign loadIOE = (address == 16399) ? load : 0;
  assign loadIOF = (address == 16400) ? load : 0;

endmodule
