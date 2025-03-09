module address_reg (
    input clk,
    input rst,
    input LD,
    input [15:0] imm,
    output reg [15:0] address
);
    always @(posedge clk) begin
        if(rst) begin
            address <= 16'd0;
        end else if(LD) begin
            address <= imm;
        end
    end
endmodule