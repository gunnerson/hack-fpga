/**
 * The Memory chip implements the complete address space of the Hack data memory,
 * including the RAM and memory mapped I/O.
 * Outputs the value of the memory location specified by the address input.
 * If (load == 1), sets the memory location specified by the address input
 * to the value of the in input.
 * Address space rules:
 * Only the upper 16K + 8K + 1 words of the memory are used.
 * Access to address 0 to 16383 results in accessing the RAM;
 * Access to address 16384 to 24575 results in accessing the Screen memory map;
 * Access to address 24576 results in accessing the Keyboard memory map.
 * Access to addresses 24577-24581 results in accessing of DE10 Lite IO devices.
 */

module memory (
    input [15:0] address,
    input        load,
    input [15:0] inRAM,
    input [15:0] inScreen,
    input [15:0] inKeyboard,
    input [15:0] inIO0,
    input [15:0] inIO1,
    input [15:0] inIO2,
    input [15:0] inIO3,
    input [15:0] inIO4,

    output [15:0] out,
    output        loadRAM,
    output        loadScreen,
    output        loadIO2,
    output        loadIO3,
    output        loadIO4
);

  assign out = (
      (address == 24576) ? inKeyboard :
      (address == 24577) ? inIO0 :
      (address == 24578) ? inIO1 :
      (address == 24579) ? inIO2 :
      (address == 24580) ? inIO3 :
      (address == 24581) ? inIO4 :
      (address > 16383) ? inScreen :
      inRAM);

  assign loadRAM = (address[14]) ? 1'b0 : load;  // RAM
  assign loadScreen = (address[14:13] == 2'b10) ? load : 1'b0;  // Screen map
  assign loadIO2 = (address == 24579) ? load : 1'b0;  // LED
  assign loadIO3 = (address == 24580) ? load : 1'b0;  // SEG
  assign loadIO4 = (address == 24581) ? load : 1'b0;  // STATUS

endmodule
