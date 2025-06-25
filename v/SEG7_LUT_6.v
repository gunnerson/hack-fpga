module SEG7_LUT_6 (
    input  [23:0] iDIG,
    output [ 6:0] oSEG0,
    output [ 6:0] oSEG1,
    output [ 6:0] oSEG2,
    output [ 6:0] oSEG3,
    output [ 6:0] oSEG4,
    output [ 6:0] oSEG5
);

  SEG7_LUT u0 (
      .iDIG(iDIG[3:0]),
      .oSEG(oSEG0)
  );
  SEG7_LUT u1 (
      .iDIG(iDIG[7:4]),
      .oSEG(oSEG1)
  );
  SEG7_LUT u2 (
      .iDIG(iDIG[11:8]),
      .oSEG(oSEG2)
  );
  SEG7_LUT u3 (
      .iDIG(iDIG[15:12]),
      .oSEG(oSEG3)
  );
  SEG7_LUT u4 (
      .iDIG(iDIG[19:16]),
      .oSEG(oSEG4)
  );
  SEG7_LUT u5 (
      .iDIG(iDIG[23:20]),
      .oSEG(oSEG5)
  );

endmodule
