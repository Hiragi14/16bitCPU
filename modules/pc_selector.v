module pc_selector (
    input [15:0] BUS,
    input [15:0] PC,
    input rFlag,
    output [15:0] PC_address
);
    assign PC_address = (rFlag) ? BUS : PC;
endmodule