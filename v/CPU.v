/**
 * The Hack CPU (Central Processing unit), consisting of an ALU,
 * two registers named A and D, and a program counter named PC.
 * The CPU is designed to fetch and execute instructions written in 
 * the Hack machine language. In particular, functions as follows:
 * Executes the inputted instruction according to the Hack machine 
 * language specification. The D and A in the language specification
 * refer to CPU-resident registers, while M refers to the external
 * memory location addressed by A, i.e. to Memory[A]. The inM input 
 * holds the value of this location. If the current instruction needs 
 * to write a value to M, the value is placed in outM, the address 
 * of the target location is placed in the addressM output, and the 
 * writeM control bit is asserted. (When writeM==0, any value may 
 * appear in outM). The outM and writeM outputs are combinational: 
 * they are affected instantaneously by the execution of the current 
 * instruction. The addressM and pc outputs are clocked: although they 
 * are affected by the execution of the current instruction, they commit 
 * to their new values only in the next time step. If reset==1 then the 
 * CPU jumps to address 0 (i.e. pc is set to 0 in next time step) rather 
 * than to the address resulting from executing the current instruction. 
 */

module CPU (
    input        clk,
    input [15:0] inM,          // M value input  (M = contents of RAM[A])
    input [15:0] instruction,  // Instruction for execution
    input        reset,        // Signals whether to re-start the current
                               // program (reset==1) or continue executing
                               // the current program (reset==0).

    output     [15:0] outM,              // M value output
    output            writeM,            // Write to M?
    output reg [15:0] addressM = 16'b0,  // Address in data memory (of M) to read
    output reg [15:0] pc = 16'b0         // address of next instruction
);

  reg  [15:0] d = 16'b0;
  wire [15:0] y = instruction[12] ? inM : addressM;
  wire        cInstr = &instruction[15:13];
  wire        zr;
  wire        ng;
  wire        jeq = instruction[1] & zr;
  wire        jlt = instruction[2] & ng;
  wire        jgt = instruction[0] & (~zr & ~ng);
  wire        jmp = cInstr & (jlt | jgt | jeq);

  assign writeM = cInstr & instruction[3];

  always @(posedge clk) begin
    addressM <= cInstr ? (instruction[5] ? outM : addressM) : instruction;
    d        <= cInstr ? (instruction[4] ? outM : d) : d;
    pc       <= reset ? 16'b0 : (jmp ? addressM : pc + 1);
  end

  ALU alu_1 (
      .x  (d),
      .y  (y),
      .zx (instruction[11]),
      .nx (instruction[10]),
      .zy (instruction[9]),
      .ny (instruction[8]),
      .f  (instruction[7]),
      .no (instruction[6]),
      .out(outM),
      .zr (zr),
      .ng (ng)
  );

endmodule
