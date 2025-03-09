module data_selector (
    input [15:0] F,
    input [15:0] memory_data,
    input [7:0] imm,
    input [2:0] data_SEL,
    output [15:0] BUS
);
    assign BUS = (data_SEL==3'd2) ? {8'd0, imm} : (data_SEL==3'd1) ? memory_data : F;
endmodule