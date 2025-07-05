## Introduction
In this project we are going to implement the HACK computer designed in parts I and II of the [Nand2Tetris](https://www.nand2tetris.org/) course.

## Hardware
For the HACK computer itself we will be using DE10-Lite FPGA board from Terasic. It is available for purchase from their [website](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=234&No=1021#contents) for around $80 along with many expansion interface, multimedia, video/imaging, networking, AD/DA, robotics boards. It is also freely available on ebay. The board is built aroung Altera MAX 10 10M50DAF484C7G chip with 50,000 logic elements, 1,638 Kb of on-chip memory, 64MB of SDRAM, 2x20 GPIO interface and a VGA interface.

![](resources/DE10-Lite_45.jpg)

And for the peripherals we will need a VGA monitor with a cable and a PS/2 keyboard.

## Design

In part I of the course we designed the HACK computer using a hardware definition language designed by the authors. Now we need to implement it in a real HDL. There are 2 options to choose from: Verilog and VHDL. Which one is better is a subject of a thirty years holy war, but if you don't already have a favourite I suggest Verilog for it's shallower learning curve and simpler syntax. 

In part I we used structural design pattern to implement system logic. We chose a NAND gate as a basic building block, and then instantiated it inside higher modules to gradually create more complex functions. While this approach has its place in hardware design it isn't always the most effective. Take for example our ALU. To design it we first had to design `AND`, `OR`, `XOR` and `OOT` gates, along with their 16-bit verions. Then using these basic gates we designed a multiplexer and an 8-way `OR` gate, then tied them all together to get the required ALU functionality. Now compare all that code we had to write to the same ALU implemented in Verilog using behavioral modeling:

~~~verilog
module alu (
    input  [15:0] x,    // input x (16 bit)
    input  [15:0] y,    // input y (16 bit)
    input         zx,   // zero the x input?
    input         nx,   // negate the x input?
    input         zy,   // zero the y input?
    input         ny,   // negate the y input?
    input         f,    // compute out = x + y (if 1) or x & y (if 0)
    input         no,   // negate the out output?
    output [15:0] out,  // 16-bit output
    output        zr,   // 1 if (out == 0), 0 otherwise
    output        ng    // 1 if (out < 0),  0 otherwise
);

  wire [15:0] xz = zx ? 16'h0000 : x;
  wire [15:0] xn = nx ? ~xz : xz;
  wire [15:0] yz = zy ? 16'h0000 : y;
  wire [15:0] yn = ny ? ~yz : yz;
  wire [15:0] outn = f ? (xn + yn) : (xn & yn);

  assign out = no ? ~outn : outn;
  assign zr  = (out == 16'h0000);
  assign ng  = out[15];

endmodule
~~~

Here we implemented the same logic as before in only 8 lines of code. And now it is the synthesis tool's job to generate the most efficient hardware realisation of this function.

![](resources/alu.png)
In order to be able to run Pong, which compiles to 50,000 instructions, we need to make one small change to our CPU design. In the original specification we destinguish A from C instruction by the first MSB only. This limits ROM address pool to only 32,768 instructions, which isn't enough for Pong. So in out design we will make a small change. Only instructions starting with `111` are now C-instructions and everything else will be A-instructions. This way we increase ROM address pool to 57,343 while maintaing reverse compatibility with original design.

## Software

To synthesise and program our design to DE10 we will use [Quartus Prime](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html) software from Intel. It has a free Lite version which is enough for our project. It also comes with a free simulation tool ModelSim.

