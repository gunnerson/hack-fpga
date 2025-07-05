module seg6 (
    input  [23:0] iDIG,
    output [ 6:0] oSEG0,
    output [ 6:0] oSEG1,
    output [ 6:0] oSEG2,
    output [ 6:0] oSEG3,
    output [ 6:0] oSEG4,
    output [ 6:0] oSEG5
);

  seg u0 (
      .iDIG(iDIG[3:0]),
      .oSEG(oSEG0)
  );
  seg u1 (
      .iDIG(iDIG[7:4]),
      .oSEG(oSEG1)
  );
  seg u2 (
      .iDIG(iDIG[11:8]),
      .oSEG(oSEG2)
  );
  seg u3 (
      .iDIG(iDIG[15:12]),
      .oSEG(oSEG3)
  );
  seg u4 (
      .iDIG(iDIG[19:16]),
      .oSEG(oSEG4)
  );
  seg u5 (
      .iDIG(iDIG[23:20]),
      .oSEG(oSEG5)
  );

endmodule
