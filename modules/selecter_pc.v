module selecter_pc (
    input [15:0] Y2,
    input [15:0] PC,
    input rFlag,
    output [15:0] PC_im
);
    assign PC_im = (rFlag) ? Y2 : PC;
endmodule