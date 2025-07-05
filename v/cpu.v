/**
 * The Hack Central Processing unit (CPU).
 * Parses the binary code in the instruction input and executes it according to the
 * Hack machine language specification. In the case of a C-instruction, computes the
 * function specified by the instruction. If the instruction specifies to read a memory
 * value, the inM input is expected to contain this value. If the instruction specifies
 * to write a value to the memory, sets the outM output to this value, sets the addressM
 * output to the target address, and asserts the writeM output (when writeM == 0, any
 * value may appear in outM).
 * If the reset input is 0, computes the address of the next instruction and sets the
 * pc output to that value. If the reset input is 1, sets pc to 0.
 * Note: The outM and writeM outputs are combinational: they are affected by the
 * instruction's execution during the current cycle. The addressM and pc outputs are
 * clocked: although they are affected by the instruction's execution, they commit to
 * their new values only in the next cycle.
 */

module cpu (
    input        clk,
    input [15:0] inM,          // M value input  (M = contents of RAM[A])
    input [15:0] instruction,  // Instruction for execution
    input        reset,

    output     [15:0] outM,          // M value output
    output            writeM,        // Write to M? instruction[3]
    output     [15:0] addressM,      // Address in data memory (of M)
    output reg [15:0] pc = 16'h0000  // Address of next instruction
);

  reg  [15:0] A = 16'h0000;
  reg  [15:0] D = 16'h0000;

  wire        cInstr = &instruction[15:13];
  wire        zr;
  wire        ng;
  wire        jeq = instruction[1] & zr;
  wire        jlt = instruction[2] & ng;
  wire        jgt = instruction[0] & (~zr & ~ng);
  wire        jmp = cInstr & (jlt | jgt | jeq);
  wire [15:0] M_or_A = instruction[12] ? inM : A;

  assign writeM   = cInstr & instruction[3];
  assign addressM = A;

  always @(posedge clk) begin
    A  <= ~cInstr ? instruction : instruction[5] ? outM : A;
    D  <= reset ? 16'h0000 : (cInstr & instruction[4]) ? outM : D;
    pc <= reset ? 16'h0000 : jmp ? A : pc + 1;
  end

  alu ALU (
      .x  (D),
      .y  (M_or_A),
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
