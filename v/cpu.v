module cpu (
    input        clk,
    input [15:0] inM,
    input [15:0] instruction,
    input        reset,

    output     [15:0] outM,
    output            writeM,
    output     [15:0] addressM,
    output reg [15:0] pc = 16'h0
);

  reg  [15:0] A = 16'h0;
  reg  [15:0] D = 16'h0;

  wire        cInstr = &instruction[15:13];
  wire        zr;
  wire        ng;
  wire        jeq = instruction[1] & zr;
  wire        jlt = instruction[2] & ng;
  wire        jgt = instruction[0] & (~zr & ~ng);
  wire        jmp = cInstr & (jlt | jgt | jeq);

  wire [15:0] M = instruction[12] ? inM : A;

  assign writeM   = cInstr & instruction[3];
  assign addressM = A;

  always @(posedge clk) begin
    A  <= ~cInstr ? instruction : instruction[5] ? outM : A;
    D  <= reset ? 16'h0 : (cInstr & instruction[4]) ? outM : D;
    pc <= reset ? 16'h0 : jmp ? A : pc + 1;
  end

  alu ALU (
      .x  (D),
      .y  (M),
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
